# Bandwidth Upgrade & Virtual Payment System — Design Spec

## 1. Tổng quan

Tính năng cho phép Viewer nâng cấp băng thông (tốc độ + dung lượng) trong 30 ngày bằng điểm nội bộ (Points). Hệ thống tích hợp **MoMo Sandbox API** để tạo trải nghiệm thanh toán thật (quét QR bằng app MoMo thật, nhập PIN xác nhận) nhưng **không dùng tiền thật** — MoMo sandbox dùng tiền ảo, phù hợp test và demo.

Kiến trúc hybrid:
- **Front-end:** Hiển thị QR do MoMo API tạo ra — viewer quét bằng app MoMo thật
- **Backend:** Gọi MoMo API → nhận webhook IPN (Instant Payment Notification) → xác thực chữ ký → xử lý nội bộ (trừ point, nâng cấp bandwidth, ghi log)
- **Point system:** Vẫn giữ point nội bộ — viewer cần có point để "thanh toán". MoMo sandbox chỉ là kênh xác thực giống thật.

## 2. Actors

| Actor | Vai trò |
|-------|---------|
| **Viewer** | Người dùng cuối — chọn gói, quét QR (trên desktop), xác nhận trên điện thoại, theo dõi upgrade và lịch sử |
| **Admin** | Quản lý — cấp point, tạo gói bandwidth, tạo voucher, xem thông báo, audit log |

## 3. Business Rules

- Mỗi gói bandwidth có: tên, tốc độ (Mbps), data cap (GB), thời hạn (30 ngày), giá (point)
- Viewer chỉ nâng cấp được nếu đủ point
- Upgrade có hiệu lực 30 ngày kể từ ngày kích hoạt
- Hệ thống tự động nhắc nhở: 7 ngày, 1 ngày trước khi hết hạn
- Hết hạn tự động tắt gói, reset về mặc định
- Mọi giao dịch point đều bất biến (chỉ INSERT, không UPDATE/DELETE)
- Giao dịch dùng database transaction + row lock tránh double-spend

## 4. Database Schema

### 4.1 BandwidthPlan
```sql
CREATE TABLE BandwidthPlan (
    plan_id INT IDENTITY PRIMARY KEY,
    plan_name NVARCHAR(100) NOT NULL,
    speed_mbps INT NOT NULL,
    data_cap_gb INT NOT NULL,
    duration_days INT NOT NULL DEFAULT 30,
    point_cost INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);
```

### 4.2 UserPoints
```sql
CREATE TABLE UserPoints (
    user_id INT PRIMARY KEY REFERENCES [User](user_id),
    balance INT NOT NULL DEFAULT 0,
    total_earned INT NOT NULL DEFAULT 0,
    total_spent INT NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT GETDATE()
);
```

### 4.3 PointTransaction
```sql
CREATE TABLE PointTransaction (
    txn_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES [User](user_id),
    amount INT NOT NULL,
    balance_after INT NOT NULL,
    txn_type NVARCHAR(50) NOT NULL, -- admin_grant, upgrade_spend, voucher, refund
    ref_id NVARCHAR(100),
    description NVARCHAR(500),
    created_by INT REFERENCES [User](user_id),
    created_at DATETIME DEFAULT GETDATE(),
    ip_address NVARCHAR(50)
);
```

### 4.4 UserBandwidthUpgrade
```sql
CREATE TABLE UserBandwidthUpgrade (
    upgrade_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES [User](user_id),
    plan_id INT NOT NULL REFERENCES BandwidthPlan(plan_id),
    speed_mbps INT NOT NULL,
    data_cap_gb INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    is_active BIT DEFAULT 1,
    is_expired BIT DEFAULT 0,
    notified_7day BIT DEFAULT 0,
    notified_1day BIT DEFAULT 0,
    txn_id INT REFERENCES PointTransaction(txn_id),
    created_at DATETIME DEFAULT GETDATE()
);
```

### 4.5 Voucher
```sql
CREATE TABLE Voucher (
    voucher_id INT IDENTITY PRIMARY KEY,
    code NVARCHAR(50) UNIQUE NOT NULL,
    plan_id INT REFERENCES BandwidthPlan(plan_id),
    discount_percent INT DEFAULT 100,
    max_uses INT DEFAULT 1,
    current_uses INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    expires_at DATETIME,
    created_by INT REFERENCES [User](user_id),
    created_at DATETIME DEFAULT GETDATE()
);
```

### 4.6 Notification
```sql
CREATE TABLE Notification (
    notif_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES [User](user_id),
    title NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX),
    notif_type NVARCHAR(50) NOT NULL, -- upgrade_activated, upgrade_expiring, upgrade_expired, point_received, admin_broadcast
    is_read BIT DEFAULT 0,
    ref_id INT,
    created_at DATETIME DEFAULT GETDATE()
);
```

## 5. Security Design

### 5.1 Transaction Atomicity
- Mọi giao dịch point dùng `BEGIN TRANSACTION` + `ROWLOCK`
- Không cho phép số dư âm
- Nếu lỗi giữa chừng → rollback toàn bộ

### 5.2 Audit Trail
- `PointTransaction` chỉ INSERT, không UPDATE/DELETE
- `SystemLog` ghi mọi hành động Admin (cấp point, tạo voucher, xoá gói)
- Mỗi giao dịch có IP người dùng

### 5.3 Authorization
- Mọi Servlet kiểm tra `session.getAttribute("role")`
- Chỉ Viewer được gọi upgrade API
- Chỉ Admin được cấp point/tạo voucher
- Viewer chỉ upgrade được cho chính mình (kiểm tra `session.user.id`)

### 5.4 Input Validation
- Validate số point, ngày tháng, voucher code
- Chống XSS khi hiển thị thông báo
- CSRF token cho form quan trọng

## 6. Flow Chi tiết

### 6.1 Luồng thanh toán (MoMo Hybrid — Sandbox)

```
[Desktop] Viewer chọn gói → kiểm tra đủ point
         ↓
[System] Tạo orderId + requestId (UUID)
         Gọi MoMo API: POST /v2/gateway/api/create
           Body: {
             partnerCode: sandbox_code,
             orderId: "BW_20260619_001",
             amount: 500 (point → quy đổi thành VND ảo, VD: 1 point = 1000 VND ảo),
             orderInfo: "Nang cap Bandwidth Pro",
             redirectUrl: "https://hethong/momo-callback",
             ipnUrl: "https://hethong/api/momo-ipn",
             requestType: "captureWallet",
             signature: HMAC_SHA256(...)
           }
         ↓
[MoMo]    API trả về: { payUrl, qrCodeUrl, deeplink, ... }
[Desktop] Hiển thị QR code (qrCodeUrl) + nút "Mở app MoMo" (deeplink)
         ↓
[Phone]   Viewer mở app MoMo thật → quét QR
          → MoMo hiện: "Xác nhận thanh toán 500,000đ
             cho NetworkManagerWeb
             [XÁC NHẬN] [HỦY]"
          → Viewer nhập PIN → xác nhận
         ↓
[MoMo]    MoMo xử lý → gửi IPN đến server:
          POST /api/momo-ipn {
            partnerCode, orderId, requestId,
            resultCode: 0 (success),
            transId, amount, signature
          }
         ↓
[System]  Xác thực chữ ký MoMo (kiểm tra signature)
          Kiểm tra resultCode == 0
          Kiểm tra orderId chưa được xử lý (idempotent)
          ↓
          BEGIN TRANSACTION
            SELECT balance FROM UserPoints WITH (ROWLOCK) WHERE user_id = ?
            UPDATE UserPoints SET balance = balance - cost
            INSERT INTO PointTransaction
            INSERT INTO UserBandwidthUpgrade
            COMMIT
          ↓
[System]  Gửi Notification cho Viewer + Admin
          Redirect viewer tới trang thành công
         ↓
[Desktop] Tự động refresh/poll → "Nâng cấp thành công!"
[Phone]   MoMo hiện: "Thanh toán thành công!"
```

### 6.1b Luồng Fallback (khi MoMo không available)

Nếu MoMo API lỗi hoặc không kết nối được, hệ thống tự động fallback về QR nội bộ:

```
[Desktop] Hiển thị QR chứa URL nội bộ:
          https://hethong/pay/confirm/{token}
[Phone]   Camera → mở trình duyệt → xác nhận
[Xử lý]  Giống design cũ — xác nhận qua phone browser
```

### 6.2 Luồng admin cấp point

```
Admin vào "Quản lý Point"
→ Nhập username + số point + lý do
→ System kiểm tra user tồn tại
→ BEGIN TRAN
    UPSERT UserPoints (nếu chưa có thì INSERT, có thì UPDATE balance)
    INSERT PointTransaction (txn_type = 'admin_grant')
    INSERT Notification (notif_type = 'point_received')
→ COMMIT
```

### 6.3 Luồng voucher

```
Admin tạo voucher:
→ Nhập code, chọn gói, % giảm, số lượt, hạn dùng
→ INSERT Voucher

Viewer dùng voucher:
→ Nhập code → System kiểm tra tồn tại + còn hạn + còn lượt
→ Tính giá = point_cost * (100 - discount_percent) / 100
→ Tiến hành thanh toán như 6.1
```

### 6.4 Background Job (hàng ngày)

```
Job chạy lúc 00:00 mỗi ngày:

1. Kiểm tra upgrade sắp hết hạn (7 ngày)
   → notified_7day = 0 AND end_date - 7 = today
   → Gửi notif "Sắp hết hạn sau 7 ngày"
   → UPDATE notified_7day = 1

2. Kiểm tra upgrade sắp hết hạn (1 ngày)
   → notified_1day = 0 AND end_date - 1 = today
   → Gửi notif "Sẽ hết hạn vào ngày mai"
   → UPDATE notified_1day = 1

3. Kiểm tra upgrade đã hết hạn
   → end_date < today AND is_active = 1
   → UPDATE is_active = 0, is_expired = 1
   → Reset bandwidth viewer về mặc định (tốc độ gốc, data cap gốc — lấy từ config hệ thống hoặc cột default_speed/default_data_cap trên bảng [User] nếu cần mở rộng sau)
   → Gửi notif "Gói đã hết hạn"
```

## 7. Giao diện

### 7.1 Viewer (userDashboard.jsp)

**Tab mới: "Nâng cấp Bandwidth"**
- Danh sách gói (card view): tên, tốc độ, data cap, giá point
- Button "Nâng cấp" → mở QR modal
- Tab "Lịch sử nâng cấp": gói, ngày bắt đầu, ngày hết hạn, trạng thái
- Tab "Ví Point": số dư, lịch sử giao dịch
- Tab "Nhập Voucher": input code + button

**Sidebar:** Badge thông báo + dropdown 5 thông báo gần nhất

### 7.2 Admin (staffDashboard.jsp)

**Dashboard cards:** Số người nâng cấp hôm nay, sắp hết hạn, đã hết hạn
**Khung thông báo:** 5 thông báo gần đây ở dashboard, link "Xem tất cả →"

**Sidebar mới:**
- Quản lý Bandwidth
  - Gói Bandwidth (CRUD)
  - Danh sách nâng cấp
  - Cấp point cho user
  - Voucher
- Thông báo (trang riêng, phân trang, lọc theo loại)

**Trang /AdminNotifications riêng:**
- Lọc theo loại: Tất cả | Nâng cấp | Point | Hết hạn
- Bảng hiển thị: thời gian, nội dung, loại, trạng thái đã xem/chưa xem

### 4.7 PaymentToken (tạm thời, TTL 5 phút)
```sql
CREATE TABLE PaymentToken (
    token_id INT IDENTITY PRIMARY KEY,
    token NVARCHAR(100) UNIQUE NOT NULL,
    user_id INT NOT NULL REFERENCES [User](user_id),
    plan_id INT NOT NULL REFERENCES BandwidthPlan(plan_id),
    voucher_id INT NULL REFERENCES Voucher(voucher_id),
    final_cost INT NOT NULL,
    is_used BIT DEFAULT 0,
    expires_at DATETIME NOT NULL, -- created_at + 5 phút
    created_at DATETIME DEFAULT GETDATE()
);
```

## 8. Các file cần tạo/sửa

### Mới (Controllers)
- `BandwidthPlanController.java` — CRUD gói bandwidth (admin)
- `UpgradeController.java` — Tạo payment token, xác nhận thanh toán, xử lý giao dịch
- `MoMoController.java` — Tạo MoMo payment request, xử lý IPN webhook từ MoMo, xác thực signature
- `PointController.java` — Admin cấp point, viewer xem số dư + lịch sử
- `VoucherController.java` — CRUD voucher, nhập code
- `NotificationController.java` — Xem thông báo, đánh dấu đã đọc
- `BandwidthScheduler.java` — Background job kiểm tra hết hạn (dùng Timer hoặc ServletContextListener)

### Mới (Utils)
- `MoMoUtils.java` — Cấu hình MoMo sandbox (partnerCode, accessKey, secretKey), tạo signature HMAC, gọi API, parse response

### Mới (DAOs)
- `BandwidthPlanDAO.java`
- `UserPointsDAO.java`
- `PointTransactionDAO.java`
- `UserBandwidthUpgradeDAO.java`
- `VoucherDAO.java`
- `NotificationDAO.java`

### Mới (DTOs)
- `BandwidthPlanDTO.java`
- `UserPointsDTO.java`
- `PointTransactionDTO.java`
- `UserBandwidthUpgradeDTO.java`
- `VoucherDTO.java`
- `NotificationDTO.java`

### Mới (JSP)
- `bandwidth-plans.jsp` — Viewer chọn gói + QR modal
- `upgrade-history.jsp` — Viewer xem lịch sử nâng cấp
- `my-points.jsp` — Viewer xem ví point + lịch sử giao dịch
- `voucher-input.jsp` — Viewer nhập code voucher
- `admin-bandwidth-plans.jsp` — Admin CRUD gói
- `admin-upgrade-list.jsp` — Admin xem danh sách nâng cấp
- `admin-grant-points.jsp` — Admin cấp point
- `admin-vouchers.jsp` — Admin quản lý voucher
- `admin-notifications.jsp` — Admin xem tất cả thông báo
- `confirm-payment.jsp` — Trang xác nhận trên điện thoại

### Sửa
- `MainController.java` — Thêm routing action mới
- `staffDashboard.jsp` — Thêm cards + khung thông báo + sidebar items
- `userDashboard.jsp` — Thêm tabs: Nâng cấp, Lịch sử, Ví Point, Voucher
- `sidebar.jsp` — Thêm menu Quản lý Bandwidth
- `SystemLogDAO.java` — Đảm bảo log mọi hành động point/upgrade

## 9. Thư viện bổ sung

- `momopayment-1.0.jar` — MoMo Java SDK (thêm vào `web/lib/`, tải từ Maven Central hoặc build từ [github.com/momo-wallet/java](https://github.com/momo-wallet/java))
- `zxing-core` / `zxing-javase` — Tạo QR code fallback (thêm vào lib/)
- `javax.xml.bind` — JAXB (MoMo SDK có thể cần, Java 8 built-in)

## 10. Testing

- Unit test: DAO insert/update/validate, PointTransaction atomicity, Voucher logic
- Integration: Luồng upgrade đủ point / không đủ point, Voucher hết hạn, double-spend
- UI: Responsive mobile confirm page, QR scan flow
- Background job: Kiểm tra notification gửi đúng ngày
