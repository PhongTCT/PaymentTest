---
title: "Team Assignment and Sprint Plan"
tags: [prj301, planning, team, sprint]
created: 2026-05-26
updated: 2026-06-06
---

# Team Assignment and Sprint Plan

## 1. Team Overview

| Item | Detail |
|---|---|
| **Course** | PRJ301 — Java Web Application Development |
| **Team Size** | 4 members |
| **Total Tables** | 20 (16 main + 4 junction tables) |
| **Project** | University Network Management System |

> ⚠️ **Lưu ý cập nhật:** File này đã được đồng bộ lại theo `Network2.sql`. So với phiên bản cũ, schema thực tế có **4 bảng junction bổ sung** (`UserRole`, `MaintenanceRouter`, `MaintenanceAccessPoint`, `MaintenanceSwitch`) và nhiều field FK mới ở các bảng chính.

---

## 2. Model Assignment Table

| Member | Models chính | Junction tables | Category |
|---|---|---|---|
| **Member A** | User, Role, AuthenticationLog, SystemLog | UserRole | Auth & Logging |
| **Member B** | Router, AccessPoint, Switch, NetworkDevice | — | Core Devices |
| **Member C** | Room, VLAN, IPAddressManagement, SupportTicket | — | Infrastructure & Support |
| **Member D** | BandwidthUsage, WiFiAnalytics, NetworkAlert, MaintenanceSchedule | MaintenanceRouter, MaintenanceAccessPoint, MaintenanceSwitch | Monitoring & Scheduling |

---

## 3. Detailed Reference per Member

### 3.1 Member A — Auth & Logging

#### User

| Field      | Type   | Ghi chú |
|------------|--------|---------|
| userId     | int    | PK, auto-increment |
| username   | String | UNIQUE, NOT NULL |
| password   | String | NOT NULL |
| fullName   | String | NOT NULL |
| email      | String | |
| status     | String | DEFAULT `'ACTIVE'` |

> ❌ **Đã xóa field `role`** khỏi bảng `User`. Role được quản lý qua bảng `UserRole` (xem bên dưới).

**DAO Methods:** `login()`, `insert()`, `update()`, `delete()`, `findById()`, `findAll()`, `changePassword()`, `findByUsername()`

---

#### Role

| Field       | Type   | Ghi chú |
|-------------|--------|---------|
| roleId      | int    | PK, auto-increment |
| roleName    | String | UNIQUE, NOT NULL |
| description | String | |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `findById()`

---

#### UserRole ⭐ *(Bảng mới)*

> Bảng junction thể hiện quan hệ **M:N** giữa `User` và `Role`. Một user có thể có nhiều role, một role có thể gán cho nhiều user.

| Field      | Type     | Ghi chú |
|------------|----------|---------|
| userId     | int      | FK → User, PK composite |
| roleId     | int      | FK → Role, PK composite |
| assignedAt | DateTime | DEFAULT `GETDATE()` |

**DAO Methods:** `assignRole(userId, roleId)`, `removeRole(userId, roleId)`, `findRolesByUser(userId)`, `findUsersByRole(roleId)`

---

#### AuthenticationLog

| Field       | Type     | Ghi chú |
|-------------|----------|---------|
| logId       | int      | PK, auto-increment |
| username    | String   | NOT NULL |
| loginStatus | String   | NOT NULL (`SUCCESS` / `FAILED`) |
| ipAddress   | String   | |
| loginTime   | DateTime | DEFAULT `GETDATE()` |
| userId      | int      | FK → User, **nullable** (null nếu đăng nhập thất bại) |

> ⭐ **Field mới:** `userId` — liên kết với bảng `User`. Để `null` khi login failed (username không tồn tại).

**DAO Methods:** `insert()`, `findByUser(userId)`, `findFailedAttempts()`, `findAll()`

---

#### SystemLog

| Field       | Type     | Ghi chú |
|-------------|----------|---------|
| logId       | int      | PK, auto-increment |
| action      | String   | NOT NULL |
| createdAt   | DateTime | DEFAULT `GETDATE()` |
| details     | String   | |
| performedBy | int      | FK → User (thay vì String) |

> ⭐ **Thay đổi:** `performedBy` chuyển từ `String` sang `int` FK trỏ về `User(userId)`.

**DAO Methods:** `insert()`, `findAll()`, `findByDate()`, `findByUser(userId)`

**Servlets to build:** `LoginServlet`, `UserServlet`, `RoleServlet`
**JSPs to build:** `login.jsp`, `user-list.jsp`, `user-form.jsp`, `role-list.jsp`, `system-log.jsp`

---

### 3.2 Member B — Core Devices

> ⭐ **Thay đổi chung:** Tất cả 4 bảng trong nhóm này đều có thêm field `roomId` (FK → `Room`). Member B cần phụ thuộc vào Member C (bảng `Room`) khi tạo dữ liệu.

#### Router

| Field      | Type   | Ghi chú |
|------------|--------|---------|
| routerId   | int    | PK, auto-increment |
| routerName | String | NOT NULL |
| ipAddress  | String | UNIQUE |
| macAddress | String | UNIQUE |
| model      | String | |
| firmware   | String | |
| status     | String | DEFAULT `'ONLINE'` |
| location   | String | |
| roomId     | int    | FK → Room, **nullable** |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findById()`, `findAll()`, `updateStatus()`, `findByRoom(roomId)`

---

#### AccessPoint

| Field          | Type   | Ghi chú |
|----------------|--------|---------|
| apId           | int    | PK, auto-increment |
| apName         | String | NOT NULL |
| ssid           | String | |
| ipAddress      | String | UNIQUE |
| connectedUsers | int    | DEFAULT `0` |
| status         | String | DEFAULT `'ONLINE'` |
| location       | String | |
| roomId         | int    | FK → Room, **nullable** |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `countConnectedUsers()`, `updateSSID()`, `findByRoom(roomId)`

---

#### Switch

| Field      | Type   | Ghi chú |
|------------|--------|---------|
| switchId   | int    | PK, auto-increment |
| switchName | String | NOT NULL |
| totalPorts | int    | DEFAULT `0` |
| usedPorts  | int    | DEFAULT `0` |
| ipAddress  | String | UNIQUE |
| status     | String | DEFAULT `'ONLINE'` |
| roomId     | int    | FK → Room, **nullable** |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `updatePortUsage()`, `findByRoom(roomId)`

---

#### NetworkDevice

| Field      | Type   | Ghi chú |
|------------|--------|---------|
| deviceId   | int    | PK, auto-increment |
| deviceName | String | NOT NULL |
| macAddress | String | UNIQUE |
| ipAddress  | String | |
| owner      | String | |
| deviceType | String | |
| status     | String | DEFAULT `'ALLOWED'` |
| roomId     | int    | FK → Room, **nullable** |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findByMAC()`, `blockDevice()`, `unblockDevice()`, `findByRoom(roomId)`

**Servlets to build:** `RouterServlet`, `AccessPointServlet`, `SwitchServlet`, `NetworkDeviceServlet`
**JSPs to build:** `router-list.jsp`, `router-form.jsp`, `ap-list.jsp`, `ap-form.jsp`, `switch-list.jsp`, `switch-form.jsp`, `device-list.jsp`, `device-form.jsp`

---

### 3.3 Member C — Infrastructure & Support

#### Room

| Field    | Type   | Ghi chú |
|----------|--------|---------|
| roomId   | int    | PK, auto-increment |
| roomName | String | NOT NULL |
| building | String | |
| floor    | int    | DEFAULT `1` |
| capacity | int    | DEFAULT `0` |

> ⚠️ `Room` là **entity nền tảng** (anchor entity). Bảng này cần được tạo và insert dữ liệu **trước** tất cả các bảng khác có `roomId`.

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `findById()`

---

#### VLAN

| Field    | Type   | Ghi chú |
|----------|--------|---------|
| vlanId   | int    | PK, auto-increment |
| vlanName | String | NOT NULL |
| subnet   | String | |
| purpose  | String | |
| roomId   | int    | FK → Room, **nullable** |

> ⭐ **Field mới:** `roomId` — xác định VLAN thuộc phòng/khu vực nào.

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `findByRoom(roomId)`

---

#### IPAddressManagement

| Field     | Type   | Ghi chú |
|-----------|--------|---------|
| ipId      | int    | PK, auto-increment |
| ipAddress | String | UNIQUE, NOT NULL |
| status    | String | DEFAULT `'AVAILABLE'` |
| deviceId  | int    | FK → NetworkDevice, UNIQUE, **nullable** |

> ⭐ **Thay đổi:** `assignedTo` (String) đã được **thay bằng** `deviceId` (INT FK → `NetworkDevice`). Cần phụ thuộc Member B khi code DAO.

**DAO Methods:** `assignIP(ipId, deviceId)`, `releaseIP(ipId)`, `findAvailableIP()`, `findByDevice(deviceId)`

---

#### SupportTicket

| Field       | Type     | Ghi chú |
|-------------|----------|---------|
| ticketId    | int      | PK, auto-increment |
| title       | String   | NOT NULL |
| description | String   | |
| status      | String   | DEFAULT `'OPEN'` |
| createdDate | DateTime | DEFAULT `GETDATE()` |
| createdBy   | int      | FK → User, NOT NULL |
| deviceId    | int      | FK → NetworkDevice, **nullable** |

> ⭐ **Thay đổi:** `createdBy` chuyển từ `String` sang `int` FK → `User`. **Field mới:** `deviceId` — liên kết ticket với thiết bị liên quan.

**DAO Methods:** `insert()`, `updateStatus()`, `assignTechnician()`, `findAll()`, `findByUser(userId)`, `findByDevice(deviceId)`

**Servlets to build:** `RoomServlet`, `VLANServlet`, `IPServlet`, `TicketServlet`
**JSPs to build:** `room-list.jsp`, `room-form.jsp`, `vlan-list.jsp`, `vlan-form.jsp`, `ip-list.jsp`, `ticket-list.jsp`, `ticket-form.jsp`

---

### 3.4 Member D — Monitoring & Scheduling

#### BandwidthUsage

| Field         | Type     | Ghi chú |
|---------------|----------|---------|
| usageId       | int      | PK, auto-increment |
| uploadSpeed   | double   | DEFAULT `0` |
| downloadSpeed | double   | DEFAULT `0` |
| recordTime    | DateTime | DEFAULT `GETDATE()` |
| deviceId      | int      | FK → NetworkDevice, NOT NULL |

> ⭐ **Thay đổi:** `deviceName` (String) đã được **thay bằng** `deviceId` (INT FK → `NetworkDevice`). Cần phụ thuộc Member B khi code DAO.

**DAO Methods:** `insert()`, `findByDate()`, `findByDevice(deviceId)`, `findTopUsage()`, `generateReport()`

---

#### WiFiAnalytics

| Field         | Type   | Ghi chú |
|---------------|--------|---------|
| analyticsId   | int    | PK, auto-increment |
| totalUsers    | int    | DEFAULT `0` |
| peakUsers     | int    | DEFAULT `0` |
| avgSpeed      | double | DEFAULT `0` |
| analyticsDate | Date   | NOT NULL |
| apId          | int    | FK → AccessPoint, NOT NULL |

> ⭐ **Field mới:** `apId` — analytics gắn với từng Access Point cụ thể. Cần phụ thuộc Member B khi code DAO.

**DAO Methods:** `generateDailyAnalytics()`, `generateMonthlyAnalytics()`, `findAll()`, `findByAP(apId)`

---

#### NetworkAlert

| Field     | Type     | Ghi chú |
|-----------|----------|---------|
| alertId   | int      | PK, auto-increment |
| alertType | String   | NOT NULL |
| message   | String   | NOT NULL |
| severity  | String   | DEFAULT `'INFO'` (`INFO` / `WARNING` / `CRITICAL`) |
| createdAt | DateTime | DEFAULT `GETDATE()` |
| routerId  | int      | FK → Router, **nullable** |
| apId      | int      | FK → AccessPoint, **nullable** |
| switchId  | int      | FK → Switch, **nullable** |

> ⭐ **3 field FK mới:** `routerId`, `apId`, `switchId` — đều nullable, một alert chỉ liên quan tới **một** loại thiết bị. Cần phụ thuộc Member B khi code DAO.

**DAO Methods:** `insert()`, `findAll()`, `resolveAlert()`, `findByDevice(routerId, apId, switchId)`, `findBySeverity(severity)`

---

#### MaintenanceSchedule

| Field         | Type     | Ghi chú |
|---------------|----------|---------|
| maintenanceId | int      | PK, auto-increment |
| title         | String   | NOT NULL |
| description   | String   | |
| startTime     | DateTime | NOT NULL |
| endTime       | DateTime | nullable |
| status        | String   | DEFAULT `'PLANNED'` (`PLANNED` / `IN_PROGRESS` / `COMPLETED`) |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findUpcoming()`, `findAll()`

---

#### MaintenanceRouter ⭐ *(Bảng mới)*

> Junction table — Một lịch bảo trì có thể bao gồm nhiều Router, một Router có thể xuất hiện trong nhiều lịch bảo trì.

| Field         | Type | Ghi chú |
|---------------|------|---------|
| maintenanceId | int  | FK → MaintenanceSchedule, PK composite |
| routerId      | int  | FK → Router, PK composite |

**DAO Methods:** `addRouter(maintenanceId, routerId)`, `removeRouter(maintenanceId, routerId)`, `findRoutersByMaintenance(maintenanceId)`

---

#### MaintenanceAccessPoint ⭐ *(Bảng mới)*

> Junction table — tương tự MaintenanceRouter nhưng cho AccessPoint.

| Field         | Type | Ghi chú |
|---------------|------|---------|
| maintenanceId | int  | FK → MaintenanceSchedule, PK composite |
| apId          | int  | FK → AccessPoint, PK composite |

**DAO Methods:** `addAP(maintenanceId, apId)`, `removeAP(maintenanceId, apId)`, `findAPsByMaintenance(maintenanceId)`

---

#### MaintenanceSwitch ⭐ *(Bảng mới)*

> Junction table — tương tự MaintenanceRouter nhưng cho Switch.

| Field         | Type | Ghi chú |
|---------------|------|---------|
| maintenanceId | int  | FK → MaintenanceSchedule, PK composite |
| switchId      | int  | FK → Switch, PK composite |

**DAO Methods:** `addSwitch(maintenanceId, switchId)`, `removeSwitch(maintenanceId, switchId)`, `findSwitchesByMaintenance(maintenanceId)`

**Servlets to build:** `BandwidthServlet`, `WiFiAnalyticsServlet`, `AlertServlet`, `MaintenanceServlet`
**JSPs to build:** `bandwidth-list.jsp`, `bandwidth-form.jsp`, `analytics-dashboard.jsp`, `alert-list.jsp`, `maintenance-list.jsp`, `maintenance-form.jsp`

---

## 4. Database Table Ownership

| Table | Owner | Loại |
|---|---|---|
| User | Member A | Main |
| Role | Member A | Main |
| UserRole | Member A | Junction |
| AuthenticationLog | Member A | Main |
| SystemLog | Member A | Main |
| Router | Member B | Main |
| AccessPoint | Member B | Main |
| Switch | Member B | Main |
| NetworkDevice | Member B | Main |
| Room | Member C | Main |
| VLAN | Member C | Main |
| IPAddressManagement | Member C | Main |
| SupportTicket | Member C | Main |
| BandwidthUsage | Member D | Main |
| WiFiAnalytics | Member D | Main |
| NetworkAlert | Member D | Main |
| MaintenanceSchedule | Member D | Main |
| MaintenanceRouter | Member D | Junction |
| MaintenanceAccessPoint | Member D | Junction |
| MaintenanceSwitch | Member D | Junction |

---

## 5. Sơ đồ phụ thuộc giữa các Member

```
Member C (Room)
    └──► Member B (Router, AP, Switch, NetworkDevice)
              └──► Member A (AuthenticationLog.userId, SystemLog.performedBy)
              └──► Member C (IPAddressManagement.deviceId, SupportTicket.deviceId)
              └──► Member D (BandwidthUsage.deviceId, WiFiAnalytics.apId,
                             NetworkAlert.routerId/apId/switchId,
                             MaintenanceRouter/AP/Switch)
```

> **Thứ tự tạo bảng bắt buộc:** `Room` → `Role` → `User` → `UserRole` → `Router/AP/Switch/NetworkDevice` → các bảng còn lại.

---

## 6. Sprint Plan

### Week 1: Setup + Models (Foundation)

| Task | Owner | Deliverable |
|---|---|---|
| Create NetBeans project, register Tomcat 9 | All | Project runs on localhost |
| Create database + all 20 tables (theo đúng thứ tự FK) | All (each creates their own) | Tables exist in SQL Server |
| Create DBConnection utility | Member A (lead) | `DBContext.java` works |
| Create all 20 DTO classes | Each member creates their own | `com.networksim.model.*` |
| Create all DAO interfaces (kể cả junction tables) | Each member creates their own | `com.networksim.dao.*` |
| Create base JSP layout (header, footer, nav) | Member C | `layout.jsp` |

### Week 2: CRUD + UI (Core Features)

| Task | Owner | Deliverable |
|---|---|---|
| Implement Login (User + UserRole DAO + LoginServlet + login.jsp) | Member A | Login + role check works |
| Implement Router CRUD (list + form) | Member B | Router CRUD works |
| Implement Room CRUD | Member C | Room CRUD works |
| Implement BandwidthUsage CRUD | Member D | Bandwidth CRUD works |
| Implement Role management + UserRole assign | Member A | Role CRUD + assign works |
| Implement AccessPoint, Switch CRUD | Member B | AP + Switch CRUD works |
| Implement VLAN, IP, Ticket CRUD | Member C | All 4 models CRUD works |
| Implement WiFiAnalytics, Alert, Maintenance | Member D | All 4 models + 3 junction DAOs works |
| Implement AuthenticationLog, SystemLog | Member A | Logging works |

### Week 3: Integration + Features

| Task | Owner | Deliverable |
|---|---|---|
| Implement NetworkDevice block/unblock | Member B | Block/unblock works |
| Wire up role-based access (via UserRole) in all Servlets | Member A | Role check works |
| Connect SupportTicket to User + NetworkDevice | Member C | Ticket assignment works |
| Build monitoring dashboard (NetworkAlert + WiFiAnalytics) | Member D | Analytics page works |
| Integrate all modules on dashboard.jsp | All | Dashboard links to all features |
| Cross-model testing | All | No broken links or SQL errors |

### Week 4: Report + Demo

| Task | Owner | Deliverable |
|---|---|---|
| Write CT analysis sections | All | Report Chapter 2 done |
| Write system design sections | All | Report Chapter 3 done |
| Take screenshots of all features | All | 15+ screenshots saved |
| Prepare demo script | Member A (lead) | Demo flow documented |
| Practice demo | All | Team runs through demo |
| Submit report + demo | All | Final submission |

---

## 7. Shared Responsibilities

| Item | Who Builds | Notes |
|---|---|---|
| `DBContext.java` | Member A | All DAOs depend on this |
| `BaseDAO` interface | Member A | Optional but recommended |
| `layout.jsp` (header/footer) | Member C | All JSPs include this |
| `SessionUtil.java` | Member A | Session helper, lưu cả userId và roleId |
| `web.xml` mappings | Member B | Servlet URL mappings |
| `style.css` | Member D | Shared CSS for all pages |
| `dashboard.jsp` | All | Each member adds their module link |

---

## 8. Communication Rules

> [!tip]
> - Push code to shared Git repo daily
> - Pull before starting work each day
> - If you change `DBContext.java` or `web.xml`, notify the team immediately
> - Test your own CRUD before merging
> - Tên database thống nhất: **`network_simulation_db`** (file SQL hiện dùng `network_simulation_db3` — cần đổi lại trước khi chạy chung)
> - **Thứ tự tạo bảng** phải tuân theo sơ đồ FK ở Mục 5 — nếu tạo sai thứ tự sẽ lỗi FOREIGN KEY constraint

---

## 9. Related Documents

- [[00_project_overview]] — Project overview
- [[02_erd_database]] — Database schema and SQL
- [[04_system_architecture]] — Folder structure and naming conventions
- [[07_coding_guide]] — How to implement one model end-to-end
