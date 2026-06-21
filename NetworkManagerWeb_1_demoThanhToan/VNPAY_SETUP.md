# VNPay Sandbox - cấu hình và chạy thử

Phần tích hợp đã dùng chuẩn VNPay Payment 2.1.0, ký `HmacSHA512`. Số tiền Premium mặc định là **99.000 VND/tháng** và luôn được quyết định ở server.

## 1. Cập nhật database

- Database mới: chạy toàn bộ `web/lib/Network2.sql`.
- Database `network_simulation_db3` đã tồn tại: chạy `web/lib/vnpay_migration.sql` một lần bằng SQL Server Management Studio.

Hoặc chạy target Ant có sẵn: `ant migrate-vnpay` (có thể ghi đè bằng `-Ddb.user=... -Ddb.password=...`).

## 2. Điền thông tin merchant Sandbox

Lấy `TmnCode` và `HashSecret` từ tài khoản merchant VNPay Sandbox. Cách khuyến nghị là khai báo biến môi trường cho Tomcat:

```text
VNPAY_TMN_CODE=<TmnCode Sandbox>
VNPAY_HASH_SECRET=<HashSecret Sandbox>
VNPAY_PAY_URL=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
VNPAY_PREMIUM_AMOUNT=99000
```

Dự án hiện đã được cấu hình sẵn bộ merchant test `2QXUI4J4` trong `web/WEB-INF/web.xml`. Không dùng bộ khóa này cho production; khi triển khai thật hãy ghi đè bằng biến môi trường và không commit khóa production.

Return URL được ứng dụng tự tạo theo host hiện tại:

```text
http://localhost:8080/NetworkManagerWeb_1_demoThanhToan/vnpay-return
```

Có thể ghi đè bằng `VNPAY_RETURN_URL` khi dùng domain hoặc tunnel HTTPS.

## 3. Cấu hình IPN

Khai báo URL sau trong trang quản trị merchant Sandbox:

```text
https://<public-domain>/NetworkManagerWeb_1_demoThanhToan/vnpay-ipn
```

VNPay không thể gọi IPN vào `localhost`; khi test IPN local cần dùng một HTTPS tunnel. Luồng Return vẫn xác nhận chữ ký và kích hoạt Premium để có thể test trực tiếp trên máy.

## 4. Chạy thử

Đăng nhập bằng tài khoản vai trò `Viewer`, mở `userDashboard.jsp`, chọn **Nâng cấp Premium**, rồi thanh toán bằng thông tin thẻ test do VNPay Sandbox cung cấp. Thanh toán thành công sẽ tạo/gia hạn Premium thêm một tháng; callback lặp lại không cộng thêm thời hạn.
