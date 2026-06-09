---
title: "Bao cao do an - Mau bao cao Tieng Viet"
tags: [prj301, planning, report, vietnamese]
created: 2026-05-26
updated: 2026-06-07
---

# Mau Bao Cao Do An PRJ301

> Day la mau bao cao cho do an PRJ301: **He thong Quan ly Mang trong Truong Dai hoc**. Mau nay da duoc cap nhat theo `Network2.sql` voi SQL Server va 20 bang du lieu.

---

## Trang bia

```text
TRUONG DAI HOC ............
KHOA CONG NGHE THONG TIN

BAO CAO DO AN
MON: PRJ301 - Lap trinh Web voi Java

TEN DE TAI: He thong Quan ly Mang trong Truong Dai hoc
            (University Network Management System)

Giang vien huong dan: ................................
Sinh vien thuc hien:
  - Sinh vien A: ................................
  - Sinh vien B: ................................
  - Sinh vien C: ................................
  - Sinh vien D: ................................

Nam hoc: 2025-2026
```

---

## Loi cam on

Cam on giang vien huong dan, nha truong, khoa, va cac thanh vien trong nhom da ho tro trong qua trinh thuc hien do an.

---

## Muc luc

Tao muc luc tu dong trong Word bang Heading 1, Heading 2, Heading 3.

---

## Chuong 1: Gioi thieu de tai

### 1.1 Dat van de

Trong moi truong truong dai hoc, he thong mang la nen tang quan trong cho hoat dong giang day, nghien cuu va quan ly. Neu viec quan ly thiet bi, phong may, dia chi IP, canh bao va bao tri duoc thuc hien thu cong, nha truong se kho theo doi tinh trang he thong va xu ly su co kip thoi. De tai nay xay dung mot ung dung Web de quan ly va giam sat he thong mang theo mo hinh mo phong.

### 1.2 Muc tieu cua de tai

1. Xay dung he thong Web quan ly nguoi dung va phan quyen theo vai tro.
2. Quan ly thiet bi mang: Router, Access Point, Switch, Network Device.
3. Quan ly co so ha tang: Room, VLAN, IP Address Management.
4. Theo doi bang thong, WiFi analytics, canh bao mang.
5. Quan ly ticket ho tro va lich bao tri thiet bi.

### 1.3 Pham vi va gioi han

```text
Pham vi:
- Quan ly du lieu mo phong cho he thong mang trong truong dai hoc
- CRUD cac bang chinh va xu ly cac chuc nang theo vai tro
- Ghi nhan login log va system log

Gioi han:
- Khong ket noi truc tiep voi thiet bi that
- Khong tich hop SNMP
- Khong gui email/SMS tu dong
```

### 1.4 Cong nghe su dung

| Thanh phan | Cong nghe |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 |
| Backend | Servlet/JSP (`javax.servlet.*`) |
| Database | SQL Server |
| Build | Ant |
| JDBC | Microsoft JDBC Driver for SQL Server (`mssql-jdbc-12.x.x.jre8.jar`) |

---

## Chuong 2: Phan tich yeu cau theo Computational Thinking

### 2.1 Decomposition

He thong duoc tach thanh 5 nhom chinh:

1. Authentication & Authorization: `User`, `Role`, `UserRole`, `AuthenticationLog`, `SystemLog`.
2. Core Devices: `Router`, `AccessPoint`, `Switch`, `NetworkDevice`.
3. Infrastructure & Support: `Room`, `VLAN`, `IPAddressManagement`, `SupportTicket`.
4. Monitoring: `BandwidthUsage`, `WiFiAnalytics`, `NetworkAlert`.
5. Maintenance: `MaintenanceSchedule`, `MaintenanceRouter`, `MaintenanceAccessPoint`, `MaintenanceSwitch`.

### 2.2 Pattern Recognition

```text
Cac mau lap lai:
- CRUD pattern: insert, update, delete, findById, findAll
- Junction table pattern: UserRole, MaintenanceRouter, MaintenanceAccessPoint, MaintenanceSwitch
- Status pattern:
  User: ACTIVE / INACTIVE
  Device: ONLINE / OFFLINE / MAINTENANCE
  NetworkDevice: ALLOWED / BLOCKED
  Ticket: OPEN / IN_PROGRESS / RESOLVED
  Maintenance: PLANNED / IN_PROGRESS / COMPLETED
- Date tracking: assigned_at, login_time, created_at, record_time, analytics_date, start_time, end_time
```

### 2.3 Abstraction

He thong su dung mo hinh MVC:

```text
JSP View -> Servlet Controller -> DAO -> SQL Server
DTO/Model giu du lieu di giua cac lop.
```

### 2.4 Algorithm Design

Can trinh bay flowchart cho cac thuat toan:

1. Dang nhap, ghi `AuthenticationLog`, load role tu `UserRole`.
2. Chan/mo khoa thiet bi bang `NetworkDevice.status`.
3. Tao va loc canh bao theo `severity` va thiet bi lien quan.
4. Tao va cap nhat ticket ho tro.
5. Tao lich bao tri va ghi cac junction table lien quan.

---

## Chuong 3: Thiet ke he thong

### 3.1 ERD va co so du lieu

He thong gom **20 bang**: 16 bang chinh va 4 bang junction.

| Nhom | Bang |
|---|---|
| Auth & Logging | `User`, `Role`, `UserRole`, `AuthenticationLog`, `SystemLog` |
| Core Devices | `Router`, `AccessPoint`, `Switch`, `NetworkDevice` |
| Infrastructure & Support | `Room`, `VLAN`, `IPAddressManagement`, `SupportTicket` |
| Monitoring | `BandwidthUsage`, `WiFiAnalytics`, `NetworkAlert` |
| Maintenance | `MaintenanceSchedule`, `MaintenanceRouter`, `MaintenanceAccessPoint`, `MaintenanceSwitch` |

Can chen ERD cap nhat theo `Network2.sql`.

### 3.2 Kien truc he thong

```text
1. Lop trinh dien: JSP + CSS + JS
2. Lop dieu khien: Servlet
3. Lop truy cap du lieu: DAO + JDBC
4. Co so du lieu: SQL Server
```

### 3.3 Cau truc thu muc

Chen cau truc thu muc tu `04_system_architecture.md`.

### 3.4 Thiet ke giao dien

Can screenshot:

- Trang dang nhap
- Dashboard
- Danh sach Router/AP/Switch/NetworkDevice
- Form them/sua thiet bi
- Room/VLAN/IP
- Bang giam sat bandwidth va WiFi analytics
- Danh sach ticket
- Lich bao tri
- Canh bao
- User/Role management

---

## Chuong 4: Cai dat va trien khai

### 4.1 Moi truong phat trien

Mo ta cach cai dat:

1. JDK 8
2. NetBeans 13
3. Apache Tomcat 9
4. SQL Server
5. Microsoft JDBC Driver for SQL Server

### 4.2 Cai dat co so du lieu

Script hien tai la `Network2.sql`. Luu y:

- Script dung T-SQL: `GO`, `IDENTITY(1,1)`, `GETDATE()`, `NVARCHAR`.
- Bang `[User]` va `[Switch]` can viet trong ngoac vuong khi truy van.
- Ten database trong script hien la `network_simulation_db3`; khi nop/chay chung nen thong nhat thanh `network_simulation_db`.

### 4.3 Cac buoc cai dat

```text
1. Cai JDK 8 va NetBeans 13
2. Dang ky Tomcat 9 trong NetBeans
3. Tao Java Web project dung Ant
4. Them mssql-jdbc vao Libraries
5. Tao database va chay Network2.sql trong SQL Server
6. Cap nhat DBContext.java dung server, database, username, password
7. Build va run project tren Tomcat
```

### 4.4 Ma nguon cac lop chinh

Can trinh bay:

- `DBContext.java` ket noi SQL Server
- `UserDAO.java`, `UserRoleDAO.java`
- `LoginServlet.java`
- `Router.java`, `RouterDAO.java`
- Mot vi du junction DAO: `MaintenanceRouterDAO.java`

---

## Chuong 5: Ket qua va danh gia

### 5.1 Ket qua thuc hien

```text
- Hoan thanh 20 DTO/model theo schema
- Hoan thanh DAO cho 16 bang chinh va 4 bang junction
- Dang nhap va phan quyen qua UserRole hoat dong
- CRUD cho thiet bi, phong, VLAN, IP, ticket, bao tri
- Monitoring va alert co the xem/loc du lieu
- Ghi AuthenticationLog va SystemLog
```

### 5.2 Huong dan su dung

Mo ta cach su dung theo vai tro:

- Admin: quan ly toan bo he thong.
- Technician: cap nhat thiet bi, xu ly ticket, xem monitoring.
- Viewer: xem trang thai, gui ticket, xem lich bao tri.

### 5.3 Huong phat trien

1. Ket noi thiet bi that qua SNMP.
2. Them Chart.js cho dashboard.
3. Them truong `assigned_to`, `resolved_at`, `resolution_note` cho ticket.
4. Them `status`, `resolved_by`, `resolved_at` cho alert.
5. Xuat bao cao PDF/Excel.

### 5.4 Bai hoc rut ra

```text
- Can dong bo tai lieu voi schema truoc khi code
- Quan he M:N nen tach bang junction ro rang
- DAO giup tach SQL khoi Servlet/JSP
- Role-based access nen xu ly tap trung qua SessionUtil
```

---

## Tai lieu tham khao

1. Java Servlet Specification 3.1
2. Microsoft JDBC Driver for SQL Server Documentation
3. SQL Server Documentation
4. Apache Tomcat 9 Documentation
5. NetBeans IDE Documentation
6. Bai giang PRJ301

---

## Phu luc

- Phu luc A: Script SQL day du `Network2.sql`
- Phu luc B: Ma nguon cac lop chinh
- Phu luc C: Screenshot he thong
- Phu luc D: Phan cong cong viec chi tiet

---

## Huong dan trinh bay

- Dung Heading 1 cho moi chuong.
- Dung Heading 2/3 cho cac muc con.
- Chen hinh anh voi caption ro rang.
- Font Times New Roman, size 13.
- Can le theo yeu cau cua giang vien.
- Kiem tra lai tat ca noi dung MySQL cu, neu con thi doi sang SQL Server.
