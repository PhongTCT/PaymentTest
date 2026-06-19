# Bandwidth Upgrade & Virtual Payment System — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a bandwidth upgrade system with MoMo sandbox hybrid payment and Points/Voucher system for Viewer role.

**Architecture:** Java Servlet/JSP MVC, SQL Server JDBC, MoMo Sandbox API for QR payment simulation, custom point-based virtual currency, background scheduler for expiration handling.

**Tech Stack:** Java 8, Servlets, JSP + JSTL, SQL Server, MoMo Java SDK, Apache Tomcat 9, Ant build

## Global Constraints

- All new servlets in package `Controller`, extend `HttpServlet`, use `processRequest` pattern
- All new DAOs in package `Models`, implement `IDAO<DTO, Integer>` where applicable
- All new DTOs in package `Models`, simple beans with private fields + getters/setters
- Database: SQL Server `network_simulation_db3`, connection via `Utils.DbUtils.getConnection()`
- JSPs use Bootstrap 5.3.3 + Bootstrap Icons from CDN, dark neon theme matching existing style
- All viewer-facing pages go through `userDashboard.jsp` as page sections
- All admin/technician pages go through `staffDashboard.jsp` with sidebar from `sidebar.jsp`
- New servlets must be registered in `web.xml`
- New actions must be registered in `MainController.java`
- 1 point = 1000 VND sandbox for MoMo conversion
- MoMo SDK JAR (`momopayment-1.0.jar`) must be downloaded and placed in `web/lib/`

---

### Task 1: Database — Create new tables

**Files:**
- Create: `NetworkManagerWeb/src/sql/004_bandwidth_upgrade.sql`

**Interfaces:**
- Consumes: existing `network_simulation_db3` database
- Produces: 7 new tables used by all DAOs

- [ ] **Step 1: Write the SQL file**

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

CREATE TABLE UserPoints (
    user_id INT PRIMARY KEY REFERENCES [User](user_id),
    balance INT NOT NULL DEFAULT 0,
    total_earned INT NOT NULL DEFAULT 0,
    total_spent INT NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE PointTransaction (
    txn_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES [User](user_id),
    amount INT NOT NULL,
    balance_after INT NOT NULL,
    txn_type NVARCHAR(50) NOT NULL,
    ref_id NVARCHAR(100),
    description NVARCHAR(500),
    created_by INT REFERENCES [User](user_id),
    created_at DATETIME DEFAULT GETDATE(),
    ip_address NVARCHAR(50)
);

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

CREATE TABLE PaymentToken (
    token_id INT IDENTITY PRIMARY KEY,
    token NVARCHAR(100) UNIQUE NOT NULL,
    user_id INT NOT NULL REFERENCES [User](user_id),
    plan_id INT NOT NULL REFERENCES BandwidthPlan(plan_id),
    voucher_id INT NULL REFERENCES Voucher(voucher_id),
    final_cost INT NOT NULL,
    is_used BIT DEFAULT 0,
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Notification (
    notif_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES [User](user_id),
    title NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX),
    notif_type NVARCHAR(50) NOT NULL,
    is_read BIT DEFAULT 0,
    ref_id INT,
    created_at DATETIME DEFAULT GETDATE()
);
```

- [ ] **Step 2: Execute SQL and seed data**

```sql
INSERT INTO BandwidthPlan (plan_name, speed_mbps, data_cap_gb, duration_days, point_cost)
VALUES
('Co Ban', 50, 100, 30, 300),
('Nang Cao', 100, 200, 30, 600),
('Pro', 200, 500, 30, 1200),
('Ultra', 500, 1000, 30, 2000);
```

- [ ] **Step 3: Commit**

```bash
git add NetworkManagerWeb/src/sql/004_bandwidth_upgrade.sql
git commit -m "feat(db): add bandwidth upgrade & payment tables"
```

---

### Task 2: DTOs — Create data models (7 files)

**Files:**
- Create: `NetworkManagerWeb/src/java/Models/BandwidthPlanDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/UserPointsDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/PointTransactionDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/UserBandwidthUpgradeDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/VoucherDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/PaymentTokenDTO.java`
- Create: `NetworkManagerWeb/src/java/Models/NotificationDTO.java`

**Pattern:** Each DTO is a simple Java bean: package `Models`, private fields matching DB columns (snake_case → camelCase), no-arg constructor, full constructor, getters/setters.

- [ ] **Step 1: Create BandwidthPlanDTO.java**

```java
package Models;

import java.sql.Timestamp;

public class BandwidthPlanDTO {
    private int planId;
    private String planName;
    private int speedMbps;
    private int dataCapGb;
    private int durationDays;
    private int pointCost;
    private boolean isActive;
    private Timestamp createdAt;

    public BandwidthPlanDTO() {}
    public BandwidthPlanDTO(int planId, String planName, int speedMbps, int dataCapGb, int durationDays, int pointCost, boolean isActive, Timestamp createdAt) {
        this.planId = planId; this.planName = planName; this.speedMbps = speedMbps; this.dataCapGb = dataCapGb;
        this.durationDays = durationDays; this.pointCost = pointCost; this.isActive = isActive; this.createdAt = createdAt;
    }
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public int getSpeedMbps() { return speedMbps; }
    public void setSpeedMbps(int speedMbps) { this.speedMbps = speedMbps; }
    public int getDataCapGb() { return dataCapGb; }
    public void setDataCapGb(int dataCapGb) { this.dataCapGb = dataCapGb; }
    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }
    public int getPointCost() { return pointCost; }
    public void setPointCost(int pointCost) { this.pointCost = pointCost; }
    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```

- [ ] **Step 2: Create UserPointsDTO.java** (userId, balance, totalEarned, totalSpent, updatedAt)

```java
package Models;
import java.sql.Timestamp;
public class UserPointsDTO {
    private int userId; private int balance; private int totalEarned; private int totalSpent; private Timestamp updatedAt;
    public UserPointsDTO() {}
    public UserPointsDTO(int userId, int balance, int totalEarned, int totalSpent, Timestamp updatedAt) {
        this.userId = userId; this.balance = balance; this.totalEarned = totalEarned; this.totalSpent = totalSpent; this.updatedAt = updatedAt;
    }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public int getBalance() { return balance; } public void setBalance(int balance) { this.balance = balance; }
    public int getTotalEarned() { return totalEarned; } public void setTotalEarned(int totalEarned) { this.totalEarned = totalEarned; }
    public int getTotalSpent() { return totalSpent; } public void setTotalSpent(int totalSpent) { this.totalSpent = totalSpent; }
    public Timestamp getUpdatedAt() { return updatedAt; } public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
```

- [ ] **Step 3: Create PointTransactionDTO.java** (txnId, userId, amount, balanceAfter, txnType, refId, description, createdBy Integer, createdAt, ipAddress)

```java
package Models;
import java.sql.Timestamp;
public class PointTransactionDTO {
    private int txnId; private int userId; private int amount; private int balanceAfter; private String txnType;
    private String refId; private String description; private Integer createdBy; private Timestamp createdAt; private String ipAddress;
    public PointTransactionDTO() {}
    public int getTxnId() { return txnId; } public void setTxnId(int txnId) { this.txnId = txnId; }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public int getAmount() { return amount; } public void setAmount(int amount) { this.amount = amount; }
    public int getBalanceAfter() { return balanceAfter; } public void setBalanceAfter(int balanceAfter) { this.balanceAfter = balanceAfter; }
    public String getTxnType() { return txnType; } public void setTxnType(String txnType) { this.txnType = txnType; }
    public String getRefId() { return refId; } public void setRefId(String refId) { this.refId = refId; }
    public String getDescription() { return description; } public void setDescription(String description) { this.description = description; }
    public Integer getCreatedBy() { return createdBy; } public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getIpAddress() { return ipAddress; } public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
}
```

- [ ] **Step 4: Create UserBandwidthUpgradeDTO.java** (upgradeId, userId, planId, speedMbps, dataCapGb, startDate, endDate, isActive, isExpired, notified7day, notified1day, txnId Integer, createdAt)

```java
package Models;
import java.sql.Timestamp;
public class UserBandwidthUpgradeDTO {
    private int upgradeId; private int userId; private int planId; private int speedMbps; private int dataCapGb;
    private Timestamp startDate; private Timestamp endDate; private boolean isActive; private boolean isExpired;
    private boolean notified7day; private boolean notified1day; private Integer txnId; private Timestamp createdAt;
    public UserBandwidthUpgradeDTO() {}
    public int getUpgradeId() { return upgradeId; } public void setUpgradeId(int upgradeId) { this.upgradeId = upgradeId; }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public int getPlanId() { return planId; } public void setPlanId(int planId) { this.planId = planId; }
    public int getSpeedMbps() { return speedMbps; } public void setSpeedMbps(int speedMbps) { this.speedMbps = speedMbps; }
    public int getDataCapGb() { return dataCapGb; } public void setDataCapGb(int dataCapGb) { this.dataCapGb = dataCapGb; }
    public Timestamp getStartDate() { return startDate; } public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    public Timestamp getEndDate() { return endDate; } public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    public boolean isIsActive() { return isActive; } public void setIsActive(boolean isActive) { this.isActive = isActive; }
    public boolean isIsExpired() { return isExpired; } public void setIsExpired(boolean isExpired) { this.isExpired = isExpired; }
    public boolean isNotified7day() { return notified7day; } public void setNotified7day(boolean notified7day) { this.notified7day = notified7day; }
    public boolean isNotified1day() { return notified1day; } public void setNotified1day(boolean notified1day) { this.notified1day = notified1day; }
    public Integer getTxnId() { return txnId; } public void setTxnId(Integer txnId) { this.txnId = txnId; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```

- [ ] **Step 5: Create VoucherDTO.java** (voucherId, code, planId Integer, discountPercent, maxUses, currentUses, isActive, expiresAt Timestamp, createdBy Integer, createdAt)

```java
package Models;
import java.sql.Timestamp;
public class VoucherDTO {
    private int voucherId; private String code; private Integer planId; private int discountPercent;
    private int maxUses; private int currentUses; private boolean isActive; private Timestamp expiresAt; private Integer createdBy; private Timestamp createdAt;
    public VoucherDTO() {}
    public int getVoucherId() { return voucherId; } public void setVoucherId(int voucherId) { this.voucherId = voucherId; }
    public String getCode() { return code; } public void setCode(String code) { this.code = code; }
    public Integer getPlanId() { return planId; } public void setPlanId(Integer planId) { this.planId = planId; }
    public int getDiscountPercent() { return discountPercent; } public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
    public int getMaxUses() { return maxUses; } public void setMaxUses(int maxUses) { this.maxUses = maxUses; }
    public int getCurrentUses() { return currentUses; } public void setCurrentUses(int currentUses) { this.currentUses = currentUses; }
    public boolean isIsActive() { return isActive; } public void setIsActive(boolean isActive) { this.isActive = isActive; }
    public Timestamp getExpiresAt() { return expiresAt; } public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }
    public Integer getCreatedBy() { return createdBy; } public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```

- [ ] **Step 6: Create PaymentTokenDTO.java** (tokenId, token, userId, planId, voucherId Integer, finalCost, isUsed, expiresAt, createdAt)

```java
package Models;
import java.sql.Timestamp;
public class PaymentTokenDTO {
    private int tokenId; private String token; private int userId; private int planId; private Integer voucherId;
    private int finalCost; private boolean isUsed; private Timestamp expiresAt; private Timestamp createdAt;
    public PaymentTokenDTO() {}
    public int getTokenId() { return tokenId; } public void setTokenId(int tokenId) { this.tokenId = tokenId; }
    public String getToken() { return token; } public void setToken(String token) { this.token = token; }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public int getPlanId() { return planId; } public void setPlanId(int planId) { this.planId = planId; }
    public Integer getVoucherId() { return voucherId; } public void setVoucherId(Integer voucherId) { this.voucherId = voucherId; }
    public int getFinalCost() { return finalCost; } public void setFinalCost(int finalCost) { this.finalCost = finalCost; }
    public boolean isIsUsed() { return isUsed; } public void setIsUsed(boolean isUsed) { this.isUsed = isUsed; }
    public Timestamp getExpiresAt() { return expiresAt; } public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```

- [ ] **Step 7: Create NotificationDTO.java** (notifId, userId, title, message, notifType, isRead, refId Integer, createdAt)

```java
package Models;
import java.sql.Timestamp;
public class NotificationDTO {
    private int notifId; private int userId; private String title; private String message; private String notifType;
    private boolean isRead; private Integer refId; private Timestamp createdAt;
    public NotificationDTO() {}
    public int getNotifId() { return notifId; } public void setNotifId(int notifId) { this.notifId = notifId; }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public String getTitle() { return title; } public void setTitle(String title) { this.title = title; }
    public String getMessage() { return message; } public void setMessage(String message) { this.message = message; }
    public String getNotifType() { return notifType; } public void setNotifType(String notifType) { this.notifType = notifType; }
    public boolean isIsRead() { return isRead; } public void setIsRead(boolean isRead) { this.isRead = isRead; }
    public Integer getRefId() { return refId; } public void setRefId(Integer refId) { this.refId = refId; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```

- [ ] **Step 8: Commit**

```bash
git add NetworkManagerWeb/src/java/Models/*DTO.java
git commit -m "feat(model): add DTOs for bandwidth upgrade system"
```

---

### Task 3: DAOs — Implement data access layer (7 files)

**Files:**
- Create: `NetworkManagerWeb/src/java/Models/BandwidthPlanDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/UserPointsDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/PointTransactionDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/UserBandwidthUpgradeDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/VoucherDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/PaymentTokenDAO.java`
- Create: `NetworkManagerWeb/src/java/Models/NotificationDAO.java`

**Pattern:** Each DAO uses `Utils.DbUtils.getConnection()`, try-with-resources, mapRow for ResultSet mapping. DAOs for tables with IDENTITY PK implement `IDAO<DTO, Integer>`. PointTransactionDAO and NotificationDAO don't need IDAO (no standard CRUD).

- [ ] **Step 1: Create BandwidthPlanDAO.java** — Full CRUD + listActive()

Key methods: insert, update, remove, ListAll, searchById (IDAO), listActive() returns only is_active=1 plans ordered by point_cost ASC. Use mapRow to map ResultSet → BandwidthPlanDTO.

- [ ] **Step 2: Create UserPointsDAO.java** — insert, update, searchById, ListAll, hasSufficientBalance()

Key methods: update balance/total fields, hasSufficientBalance(userId, cost) checks if balance >= cost. Remove returns false (never delete points).

- [ ] **Step 3: Create PointTransactionDAO.java** — insert, findByUser()

IMPORTANT: This table is append-only. No update, no remove, no IDAO. findByUser returns all transactions for a user ordered by created_at DESC.

- [ ] **Step 4: Create UserBandwidthUpgradeDAO.java** — Full CRUD + findByUser, findActiveByUser, findActiveUpgrades, findExpiringInDays, findExpiredToday

Key queries:
- findExpiringInDays(days): `WHERE is_active=1 AND is_expired=0 AND DATEDIFF(DAY, GETDATE(), end_date) = ?`
- findExpiredToday: `WHERE is_active=1 AND is_expired=0 AND end_date < GETDATE()`

- [ ] **Step 5: Create VoucherDAO.java** — Full CRUD + findByCode(), incrementUses()

findByCode uses exact match on code column. incrementUses does `UPDATE Voucher SET current_uses = current_uses + 1`.

- [ ] **Step 6: Create PaymentTokenDAO.java** — insert, update (is_used), findByToken()

Token expires_at is set via `DATEADD(MINUTE, 5, GETDATE())` in INSERT.

- [ ] **Step 7: Create NotificationDAO.java** — insert, markAsRead, findByUser, findRecentByUser, countUnread

No IDAO interface.

- [ ] **Step 8: Commit**

```bash
git add NetworkManagerWeb/src/java/Models/BandwidthPlanDAO.java NetworkManagerWeb/src/java/Models/UserPointsDAO.java NetworkManagerWeb/src/java/Models/PointTransactionDAO.java NetworkManagerWeb/src/java/Models/UserBandwidthUpgradeDAO.java NetworkManagerWeb/src/java/Models/VoucherDAO.java NetworkManagerWeb/src/java/Models/PaymentTokenDAO.java NetworkManagerWeb/src/java/Models/NotificationDAO.java
git commit -m "feat(dao): add DAOs for bandwidth upgrade system"
```

---

### Task 4: MoMoUtils — MoMo Sandbox Integration

**Files:**
- Create: `NetworkManagerWeb/src/java/Utils/MoMoUtils.java`

**Interfaces:**
- `createPaymentRequest(orderId, amount, orderInfo, requestId)` → JsonObject (MoMo API response)
- `verifyIpnSignature(JsonObject ipnData)` → boolean
- `convertPointsToVnd(points)` → long (1 point = 1000 VND)

- [ ] **Step 1: Create MoMoUtils.java**

```java
package Utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class MoMoUtils {

    private static final String PARTNER_CODE = "MOMO";
    private static final String ACCESS_KEY = "F8BBA842ECF85";
    private static final String SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private static final String CREATE_ORDER_URL = "https://test-payment.momo.vn/v2/gateway/api/create";
    private static final String IPN_URL = "https://hethong/api/momo-ipn";
    private static final String REDIRECT_URL = "https://hethong/momo-callback";
    private static final Gson gson = new Gson();

    public static String hmacSha256(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format("%02x", b));
        return hex.toString();
    }

    public static JsonObject createPaymentRequest(String orderId, long amount, String orderInfo, String requestId) throws Exception {
        String raw = "accessKey=" + ACCESS_KEY + "&amount=" + amount + "&extraData=&ipnUrl=" + IPN_URL
                + "&orderId=" + orderId + "&orderInfo=" + orderInfo + "&partnerCode=" + PARTNER_CODE
                + "&redirectUrl=" + REDIRECT_URL + "&requestId=" + requestId + "&requestType=captureWallet";
        String sig = hmacSha256(raw, SECRET_KEY);

        JsonObject body = new JsonObject();
        body.addProperty("partnerCode", PARTNER_CODE);
        body.addProperty("accessKey", ACCESS_KEY);
        body.addProperty("requestId", requestId);
        body.addProperty("amount", amount);
        body.addProperty("orderId", orderId);
        body.addProperty("orderInfo", orderInfo);
        body.addProperty("redirectUrl", REDIRECT_URL);
        body.addProperty("ipnUrl", IPN_URL);
        body.addProperty("requestType", "captureWallet");
        body.addProperty("extraData", "");
        body.addProperty("signature", sig);
        body.addProperty("lang", "vi");

        URL url = new URL(CREATE_ORDER_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(gson.toJson(body).getBytes(StandardCharsets.UTF_8));
        }

        StringBuilder resp = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line; while ((line = br.readLine()) != null) resp.append(line);
        }
        return gson.fromJson(resp.toString(), JsonObject.class);
    }

    public static boolean verifyIpnSignature(JsonObject d) throws Exception {
        String raw = "accessKey=" + ACCESS_KEY + "&amount=" + d.get("amount").getAsLong()
                + "&extraData=" + d.get("extraData").getAsString() + "&message=" + d.get("message").getAsString()
                + "&orderId=" + d.get("orderId").getAsString() + "&orderInfo=" + d.get("orderInfo").getAsString()
                + "&orderType=" + d.get("orderType").getAsString() + "&partnerCode=" + d.get("partnerCode").getAsString()
                + "&payType=" + d.get("payType").getAsString() + "&requestId=" + d.get("requestId").getAsString()
                + "&responseTime=" + d.get("responseTime").getAsLong() + "&resultCode=" + d.get("resultCode").getAsInt()
                + "&transId=" + d.get("transId").getAsString();
        return hmacSha256(raw, SECRET_KEY).equals(d.get("signature").getAsString());
    }

    public static long convertPointsToVnd(int points) { return (long) points * 1000; }
}
```

- [ ] **Step 2: Commit**

```bash
git add NetworkManagerWeb/src/java/Utils/MoMoUtils.java
git commit -m "feat(utils): add MoMo sandbox integration utilities"
```

---

### Task 5: MoMoController — Handle MoMo payment flow

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/MoMoController.java`
- Modify: `NetworkManagerWeb/web/WEB-INF/web.xml` — register servlet

- [ ] **Step 1: Create MoMoController.java**

Actions:
- `createPayment`: Check login, load plan + voucher, check balance, call MoMoUtils.createPaymentRequest, save PaymentToken, return payUrl/qrCodeUrl/deeplink as JSON
- `momoIpn`: Read JSON from POST body, verify signature via MoMoUtils.verifyIpnSignature, find PaymentToken by orderId, validate not used/not expired, call processUpgrade()
- `momoCallback`: Get orderId + resultCode from query params, if success call processUpgrade(), redirect to userDashboard

processUpgrade() is a synchronized method that: deducts points, inserts PointTransaction, inserts UserBandwidthUpgrade (30 days from now), marks token used, increments voucher uses if applicable, inserts Notification, inserts SystemLog.

- [ ] **Step 2: Register in web.xml**

```xml
    <servlet>
        <servlet-name>MoMoController</servlet-name>
        <servlet-class>Controller.MoMoController</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>MoMoController</servlet-name>
        <url-pattern>/MoMoController</url-pattern>
    </servlet-mapping>
```

- [ ] **Step 3: Commit**

---

### Task 6: PointController — Admin grant + viewer balance

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/PointController.java`

Actions:
- `adminGrant`: Admin only. Insert/update UserPoints, insert PointTransaction (type=admin_grant), insert Notification (type=point_received), insert SystemLog. Redirect back to admin page.
- `myPoints`: Return UserPointsDTO as request attribute, forward to userDashboard.jsp?page=myPoints
- `pointHistory`: Find transactions by user, forward to userDashboard.jsp?page=pointHistory
- `adminList`: List all UserPoints with user info, forward to admin page

- [ ] **Commit**

---

### Task 7: UpgradeController — Viewer upgrade + fallback QR flow

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/UpgradeController.java`
- Modify: `NetworkManagerWeb/web/WEB-INF/web.xml` — register servlet

Actions:
- `listPlans`: Return JSON with balance + all active plans
- `createToken`: Validate plan/voucher/balance, insert PaymentToken (5min expiry), return JSON with token + confirmUrl + plan info
- `confirmPayment`: Called from phone QR scan or manual confirm. Find token, validate, process upgrade atomically, return JSON success
- `myUpgrades`: Return JSON list of user's upgrades
- `voucherRedeem`: Validate voucher code, return discount info as JSON
- `applyVoucher`: Same as voucherRedeem

- [ ] **Register in web.xml**

```xml
    <servlet>
        <servlet-name>UpgradeController</servlet-name>
        <servlet-class>Controller.UpgradeController</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>UpgradeController</servlet-name>
        <url-pattern>/UpgradeController</url-pattern>
    </servlet-mapping>
```

- [ ] **Commit**

---

### Task 8: BandwidthPlanController — Admin CRUD for plans

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/BandwidthPlanController.java`

Actions: list, addForm, insert, editForm, update, delete.
All actions require Admin role check. redirect to login if not admin.

- [ ] **Commit**

---

### Task 9: VoucherController — Admin voucher CRUD

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/VoucherController.java`

Actions: list, createForm, create (uppercase code), toggleActive, delete.
All require Admin role. Log to SystemLog on create.

- [ ] **Commit**

---

### Task 10: NotificationController — Read/mark notifications

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/NotificationController.java`

Actions: myNotifs (JSON), unreadCount (JSON), markRead (JSON), adminNotifs (Admin only, JSON).

- [ ] **Commit**

---

### Task 11: BandwidthScheduler — Background expiration job

**Files:**
- Create: `NetworkManagerWeb/src/java/Controller/BandwidthScheduler.java`
- Modify: `NetworkManagerWeb/web/WEB-INF/web.xml` — register listener

Implements `ServletContextListener`. On startup, creates a daemon Timer that runs every hour.

Tasks:
1. Find upgrades where DATEDIFF=7 AND notified_7day=0 → insert notification, set notified_7day=1
2. Find upgrades where DATEDIFF=1 AND notified_1day=0 → insert notification, set notified_1day=1
3. Find upgrades where end_date < GETDATE() AND is_active=1 → set is_active=0, is_expired=1, insert notification "Goi da het han"

- [ ] **Register in web.xml**

```xml
    <listener>
        <listener-class>Controller.BandwidthScheduler</listener-class>
    </listener>
```

- [ ] **Commit**

---

### Task 12: User JSP — Viewer dashboard sections

**Files:**
- Modify: `NetworkManagerWeb/web/userDashboard.jsp`

**Changes needed:**
1. **Sidebar:** Add "Nang Cap Bandwidth", "Lich Su Nang Cap", "Vi Point", "Nhap Voucher" buttons before "Settings" section
2. **pageTitles:** Add entries for 'upgrade', 'myUpgrades', 'myPoints', 'voucher'
3. **Sections:** Add page-upgrade (plan cards + QR modal), page-myUpgrades (history table), page-myPoints (balance + transaction list), page-voucher (redeem input)
4. **JavaScript:** loadPlans(), startPayment(), confirmPayment(), loadUpgradeHistory(), loadPointHistory(), loadBalance(), redeemVoucher(), loadNotifications(), markNotif(), loadNotifBadge()
5. Override showPage to call load functions on page switch

- [ ] **Commit**

---

### Task 13: Admin JSP — Sidebar + Dashboard + Pages

**Files:**
- Modify: `NetworkManagerWeb/web/sidebar.jsp`
- Modify: `NetworkManagerWeb/web/staffDashboard.jsp`
- Create: `NetworkManagerWeb/web/admin-bandwidth-plans.jsp`
- Create: `NetworkManagerWeb/web/admin-vouchers.jsp`
- Create: `NetworkManagerWeb/web/admin-notifications.jsp`

- [ ] **sidebar.jsp:** Add "Bandwidth Management" section after Monitoring: Goi Bandwidth, Nang Cap, Cap Point, Voucher links

- [ ] **staffDashboard.jsp:** Add bandwidth overview cards (upgradeTodayCount, expiringSoonCount, expiredTodayCount) + Recent notifications widget to dashboard. Add content sections for bandwidth pages (plan list, upgrade list, point grant form, notification list) using the existing page parameter switching (staffDashboard.jsp?page=...)

- [ ] **Create admin-bandwidth-plans.jsp:** Table listing all plans + Add/Edit form. Dark theme matching existing style. Inline within staffDashboard content area.

- [ ] **Create admin-vouchers.jsp:** Table listing all vouchers + Create form. Dark theme matching existing style.

- [ ] **Create admin-notifications.jsp:** Table listing + filter by type. Dark theme.

- [ ] **Commit**

---

### Task 14: Download MoMo SDK + Finalize

- [ ] **Step 1:** Download MoMo Java SDK from Maven Central and place in `NetworkManagerWeb/web/lib/`

```bash
# Option 1: Download from Maven Central
curl -o NetworkManagerWeb/web/lib/momopayment-1.0.jar https://repo1.maven.org/maven2/io/github/momo-wallet/momopayment/1.0/momopayment-1.0.jar

# Option 2: Build from source
git clone https://github.com/momo-wallet/java.git
cd java
mvn package -DskipTests
cp target/momopayment-1.0.jar ../NetworkManagerWeb/web/lib/
```

- [ ] **Step 2:** Verify all servlet registrations in web.xml

Ensure these are all present:
- MoMoController (/MoMoController)
- UpgradeController (/UpgradeController)
- PointController (/PointController)
- BandwidthPlanController (/BandwidthPlanController)
- VoucherController (/VoucherController)
- NotificationController (/NotificationController)
- BandwidthScheduler (listener)

- [ ] **Step 3:** Final commit

```bash
git add -A
git commit -m "feat: complete bandwidth upgrade system with MoMo sandbox integration"
```

Spec doc: `docs/superpowers/specs/2026-06-19-bandwidth-upgrade-design.md`
Plan doc: This file
