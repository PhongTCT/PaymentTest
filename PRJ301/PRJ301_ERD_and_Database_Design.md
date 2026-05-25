---
title: PRJ301 ERD and Database Design
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
---

# PRJ301 ERD and Database Design

## 1. Current Focus

This document designs the database for the **Network Infrastructure Simulation Management System**.

Fixed development environment:

| Component | Required Setup |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 through NetBeans |
| Backend | Servlet/JSP with `javax.servlet.*` |
| Build Tool | Ant |
| Database | MySQL 8.0 |
| JDBC Driver | `mysql-connector-java-8.0.33.jar` recommended |

The database design supports these main modules:

1. User Authentication & Role Management
2. Device & Node Management
3. Network Topology Simulation
4. Bandwidth Monitoring
5. Signal Coverage Monitoring
6. Maintenance Scheduling
7. Alerts
8. Report Generation

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

We break the system data into smaller database areas:

| Module | Required Data |
|---|---|
| Authentication | users, roles |
| Device Management | devices, device types, IP address, location, status |
| Network Topology | links between devices, source device, target device, link type |
| Bandwidth Monitoring | upload speed, download speed, latency, packet loss |
| Coverage Monitoring | area name, signal strength, coverage percentage |
| Maintenance Scheduling | task title, device, date, priority, status |
| Alerts | alert message, severity, related device, read/unread status |
| Reports | report type, generated user, generated date, summary |

This decomposition helps the team avoid one huge confusing table.

---

## 2.2 Pattern Recognition

Several tables follow the same CRUD pattern:

```text
id → name/title → description/details → status → created_at → updated_at
```

Repeated patterns:

| Pattern | Used In |
|---|---|
| CRUD data | devices, maintenance_tasks, coverage_areas |
| Log data | bandwidth_logs, alerts, reports |
| Foreign key relationship | user_id, device_id, source_device_id, target_device_id |
| Status field | users, devices, maintenance_tasks, alerts |
| Date tracking | created_at, updated_at, scheduled_date, measured_at |

This pattern makes DAO classes easier because many methods will look similar:

```text
insert()
update()
delete()
getById()
getAll()
```

---

## 2.3 Abstraction

At this stage, we store only the important information needed for PRJ301 features.

| Keep in Database | Ignore for Now |
|---|---|
| Device name, type, IP, status | Real hardware driver configuration |
| Link between two devices | Real packet routing engine |
| Bandwidth measurements | Real-time SNMP integration |
| Coverage percentage | Advanced radio propagation formula |
| Maintenance schedule | Enterprise ticketing integration |
| Alerts | Push notification service |
| Reports metadata | PDF export engine details |

The project is a **simulation management system**, so the database should support realistic management behavior without becoming too complex for a semester project.

---

## 2.4 Algorithm Design

Database design algorithm:

```text
Start
  ↓
Identify main system modules
  ↓
Convert each module into one or more entities
  ↓
Choose primary keys for each entity
  ↓
Find relationships between entities
  ↓
Add foreign keys
  ↓
Normalize repeated data where needed
  ↓
Write MySQL CREATE TABLE script
  ↓
Test table creation in MySQL
  ↓
Use tables in DAO classes
End
```

---

## 3. Main Entities

## 3.1 `users`

Purpose: Stores accounts for administrators, technicians, and viewers.

| Field | Type | Description |
|---|---|---|
| `user_id` | INT PK AI | Unique user ID |
| `full_name` | VARCHAR(100) | User's full name |
| `email` | VARCHAR(100) | Login email |
| `password_hash` | VARCHAR(255) | Hashed password, not plain text |
| `role` | VARCHAR(30) | ADMIN, TECHNICIAN, VIEWER |
| `status` | VARCHAR(20) | ACTIVE, INACTIVE |
| `created_at` | DATETIME | Account creation time |

---

## 3.2 `devices`

Purpose: Stores routers, switches, servers, access points, and other network nodes.

| Field | Type | Description |
|---|---|---|
| `device_id` | INT PK AI | Unique device ID |
| `device_name` | VARCHAR(100) | Display name |
| `device_type` | VARCHAR(50) | ROUTER, SWITCH, SERVER, ACCESS_POINT, FIREWALL |
| `ip_address` | VARCHAR(45) | IPv4 or IPv6 address |
| `mac_address` | VARCHAR(50) | Device MAC address |
| `location` | VARCHAR(150) | Physical or simulated location |
| `status` | VARCHAR(30) | ONLINE, OFFLINE, MAINTENANCE |
| `created_at` | DATETIME | Creation time |
| `updated_at` | DATETIME | Last update time |

---

## 3.3 `network_links`

Purpose: Stores connections between two devices in the topology diagram.

| Field | Type | Description |
|---|---|---|
| `link_id` | INT PK AI | Unique link ID |
| `source_device_id` | INT FK | Starting device |
| `target_device_id` | INT FK | Ending device |
| `link_type` | VARCHAR(50) | ETHERNET, FIBER, WIRELESS |
| `bandwidth_capacity` | DECIMAL(10,2) | Maximum bandwidth in Mbps |
| `status` | VARCHAR(30) | ACTIVE, DOWN, DEGRADED |
| `created_at` | DATETIME | Creation time |

Relationship:

```text
One device can connect to many network links.
Each network link connects exactly two devices.
```

---

## 3.4 `bandwidth_logs`

Purpose: Stores bandwidth test results for each device.

| Field | Type | Description |
|---|---|---|
| `log_id` | INT PK AI | Unique bandwidth log ID |
| `device_id` | INT FK | Related device |
| `download_speed` | DECIMAL(10,2) | Download speed in Mbps |
| `upload_speed` | DECIMAL(10,2) | Upload speed in Mbps |
| `latency_ms` | DECIMAL(10,2) | Latency in milliseconds |
| `packet_loss` | DECIMAL(5,2) | Packet loss percentage |
| `measured_at` | DATETIME | Measurement time |

Relationship:

```text
One device can have many bandwidth logs.
```

---

## 3.5 `coverage_areas`

Purpose: Stores simulated wireless coverage data for areas such as rooms, floors, or buildings.

| Field | Type | Description |
|---|---|---|
| `coverage_id` | INT PK AI | Unique coverage area ID |
| `device_id` | INT FK | Related access point or wireless device |
| `area_name` | VARCHAR(100) | Area name |
| `signal_strength` | DECIMAL(6,2) | Signal strength in dBm |
| `coverage_percent` | DECIMAL(5,2) | Coverage percentage |
| `status` | VARCHAR(30) | GOOD, WEAK, NO_SIGNAL |
| `measured_at` | DATETIME | Measurement time |

Relationship:

```text
One wireless device can cover many areas.
```

---

## 3.6 `maintenance_tasks`

Purpose: Stores scheduled maintenance work for devices.

| Field | Type | Description |
|---|---|---|
| `task_id` | INT PK AI | Unique maintenance task ID |
| `device_id` | INT FK | Device that needs maintenance |
| `assigned_user_id` | INT FK | Technician assigned to task |
| `title` | VARCHAR(150) | Task title |
| `description` | TEXT | Task details |
| `scheduled_date` | DATETIME | Planned maintenance date |
| `priority` | VARCHAR(20) | LOW, MEDIUM, HIGH |
| `status` | VARCHAR(30) | PENDING, IN_PROGRESS, COMPLETED, CANCELLED |
| `created_at` | DATETIME | Creation time |

Relationships:

```text
One device can have many maintenance tasks.
One user can be assigned many maintenance tasks.
```

---

## 3.7 `alerts`

Purpose: Stores warnings about device, bandwidth, coverage, or maintenance problems.

| Field | Type | Description |
|---|---|---|
| `alert_id` | INT PK AI | Unique alert ID |
| `device_id` | INT FK NULL | Related device, if any |
| `message` | VARCHAR(255) | Alert message |
| `severity` | VARCHAR(20) | INFO, WARNING, CRITICAL |
| `is_read` | BOOLEAN | Read/unread status |
| `created_at` | DATETIME | Alert creation time |

Relationship:

```text
One device can have many alerts.
Some alerts may be general and not attached to a device.
```

---

## 3.8 `reports`

Purpose: Stores generated report metadata.

| Field | Type | Description |
|---|---|---|
| `report_id` | INT PK AI | Unique report ID |
| `generated_by` | INT FK | User who generated the report |
| `report_type` | VARCHAR(50) | DEVICE, BANDWIDTH, MAINTENANCE, COVERAGE |
| `title` | VARCHAR(150) | Report title |
| `summary` | TEXT | Report summary |
| `generated_at` | DATETIME | Generated time |

Relationship:

```text
One user can generate many reports.
```

---

## 4. ERD Relationship Summary

| Relationship | Cardinality |
|---|---|
| `users` → `maintenance_tasks` | One-to-Many |
| `users` → `reports` | One-to-Many |
| `devices` → `network_links` as source | One-to-Many |
| `devices` → `network_links` as target | One-to-Many |
| `devices` → `bandwidth_logs` | One-to-Many |
| `devices` → `coverage_areas` | One-to-Many |
| `devices` → `maintenance_tasks` | One-to-Many |
| `devices` → `alerts` | One-to-Many |

---

## 5. ERD Diagram Drawing Guide

Draw these entities as boxes:

```text
users
  PK user_id
  full_name
  email
  password_hash
  role
  status
  created_at

 devices
  PK device_id
  device_name
  device_type
  ip_address
  mac_address
  location
  status
  created_at
  updated_at

network_links
  PK link_id
  FK source_device_id
  FK target_device_id
  link_type
  bandwidth_capacity
  status
  created_at

bandwidth_logs
  PK log_id
  FK device_id
  download_speed
  upload_speed
  latency_ms
  packet_loss
  measured_at

coverage_areas
  PK coverage_id
  FK device_id
  area_name
  signal_strength
  coverage_percent
  status
  measured_at

maintenance_tasks
  PK task_id
  FK device_id
  FK assigned_user_id
  title
  description
  scheduled_date
  priority
  status
  created_at

alerts
  PK alert_id
  FK device_id
  message
  severity
  is_read
  created_at

reports
  PK report_id
  FK generated_by
  report_type
  title
  summary
  generated_at
```

Connect the boxes like this:

```text
users.user_id 1 ───< maintenance_tasks.assigned_user_id
users.user_id 1 ───< reports.generated_by

devices.device_id 1 ───< bandwidth_logs.device_id
devices.device_id 1 ───< coverage_areas.device_id
devices.device_id 1 ───< maintenance_tasks.device_id
devices.device_id 1 ───< alerts.device_id

devices.device_id 1 ───< network_links.source_device_id
devices.device_id 1 ───< network_links.target_device_id
```

In draw.io:

1. Use rectangle shapes for tables.
2. Put the table name at the top.
3. Mark primary keys as `PK`.
4. Mark foreign keys as `FK`.
5. Use crow’s foot notation if available.
6. Use `1` near parent table and `many` near child table.

---

## 6. MySQL 8 Database Script

Run this script in MySQL Workbench, phpMyAdmin, or NetBeans database tools.

```sql
CREATE DATABASE IF NOT EXISTS network_simulation_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE network_simulation_db;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'VIEWER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    ip_address VARCHAR(45),
    mac_address VARCHAR(50),
    location VARCHAR(150),
    status VARCHAR(30) NOT NULL DEFAULT 'ONLINE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE network_links (
    link_id INT AUTO_INCREMENT PRIMARY KEY,
    source_device_id INT NOT NULL,
    target_device_id INT NOT NULL,
    link_type VARCHAR(50) NOT NULL,
    bandwidth_capacity DECIMAL(10,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_link_source_device
        FOREIGN KEY (source_device_id) REFERENCES devices(device_id),
    CONSTRAINT fk_link_target_device
        FOREIGN KEY (target_device_id) REFERENCES devices(device_id),
    CONSTRAINT chk_link_different_devices
        CHECK (source_device_id <> target_device_id)
);

CREATE TABLE bandwidth_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    download_speed DECIMAL(10,2) NOT NULL DEFAULT 0,
    upload_speed DECIMAL(10,2) NOT NULL DEFAULT 0,
    latency_ms DECIMAL(10,2) NOT NULL DEFAULT 0,
    packet_loss DECIMAL(5,2) NOT NULL DEFAULT 0,
    measured_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bandwidth_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id)
);

CREATE TABLE coverage_areas (
    coverage_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    area_name VARCHAR(100) NOT NULL,
    signal_strength DECIMAL(6,2) NOT NULL DEFAULT 0,
    coverage_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'GOOD',
    measured_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_coverage_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id)
);

CREATE TABLE maintenance_tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    assigned_user_id INT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    scheduled_date DATETIME NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_maintenance_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id),
    CONSTRAINT fk_maintenance_user
        FOREIGN KEY (assigned_user_id) REFERENCES users(user_id)
);

CREATE TABLE alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT,
    message VARCHAR(255) NOT NULL,
    severity VARCHAR(20) NOT NULL DEFAULT 'INFO',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    generated_by INT NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    summary TEXT,
    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_report_user
        FOREIGN KEY (generated_by) REFERENCES users(user_id)
);
```

Important MySQL note:

> MySQL 8.0.16+ enforces `CHECK` constraints. If your MySQL version ignores or rejects the `CHECK`, remove `chk_link_different_devices` and validate this rule in Java instead.

---

## 7. Optional Sample Data

Use sample data for testing after the tables are created.

```sql
INSERT INTO users (full_name, email, password_hash, role, status)
VALUES
('System Administrator', 'admin@networksim.local', '123456', 'ADMIN', 'ACTIVE'),
('Network Technician', 'tech@networksim.local', '123456', 'TECHNICIAN', 'ACTIVE'),
('Viewer User', 'viewer@networksim.local', '123456', 'VIEWER', 'ACTIVE');

INSERT INTO devices (device_name, device_type, ip_address, mac_address, location, status)
VALUES
('Main Router', 'ROUTER', '192.168.1.1', 'AA:BB:CC:DD:EE:01', 'Server Room', 'ONLINE'),
('Core Switch', 'SWITCH', '192.168.1.2', 'AA:BB:CC:DD:EE:02', 'Server Room', 'ONLINE'),
('Web Server', 'SERVER', '192.168.1.10', 'AA:BB:CC:DD:EE:03', 'Rack A', 'ONLINE'),
('Access Point 1', 'ACCESS_POINT', '192.168.1.20', 'AA:BB:CC:DD:EE:04', 'Floor 1', 'ONLINE');

INSERT INTO network_links (source_device_id, target_device_id, link_type, bandwidth_capacity, status)
VALUES
(1, 2, 'ETHERNET', 1000.00, 'ACTIVE'),
(2, 3, 'ETHERNET', 1000.00, 'ACTIVE'),
(2, 4, 'WIRELESS', 300.00, 'ACTIVE');

INSERT INTO bandwidth_logs (device_id, download_speed, upload_speed, latency_ms, packet_loss)
VALUES
(1, 850.50, 740.20, 3.50, 0.10),
(2, 780.00, 700.00, 4.20, 0.20),
(4, 120.00, 80.00, 12.50, 1.50);

INSERT INTO coverage_areas (device_id, area_name, signal_strength, coverage_percent, status)
VALUES
(4, 'Floor 1 - Room A', -45.50, 95.00, 'GOOD'),
(4, 'Floor 1 - Room B', -70.00, 65.00, 'WEAK');

INSERT INTO maintenance_tasks (device_id, assigned_user_id, title, description, scheduled_date, priority, status)
VALUES
(1, 2, 'Router firmware check', 'Check and update router firmware if needed.', '2026-06-01 09:00:00', 'HIGH', 'PENDING'),
(4, 2, 'Access point signal test', 'Test signal coverage in Floor 1 rooms.', '2026-06-03 14:00:00', 'MEDIUM', 'PENDING');

INSERT INTO alerts (device_id, message, severity, is_read)
VALUES
(4, 'Weak signal detected in Floor 1 - Room B', 'WARNING', FALSE),
(2, 'Core switch bandwidth usage is high', 'INFO', FALSE);

INSERT INTO reports (generated_by, report_type, title, summary)
VALUES
(1, 'DEVICE', 'Initial Device Inventory Report', 'System contains router, switch, server, and access point sample records.');
```

Security reminder:

> The sample passwords are plain text only for early local testing. For the real Login module, store hashed passwords using a Java 8-compatible hashing method.

---

## 8. DAO Implementation Order

Recommended coding order after ERD approval:

```text
1. DBContext.java
2. User.java + UserDAO.java
3. LoginServlet.java + login.jsp
4. Device.java + DeviceDAO.java
5. DeviceServlet.java + devices/list.jsp
6. NetworkLink.java + NetworkLinkDAO.java
7. BandwidthLog.java + BandwidthLogDAO.java
8. MaintenanceTask.java + MaintenanceTaskDAO.java
9. Alert.java + AlertDAO.java
10. Report.java + ReportDAO.java
```

Why start with login and devices?

- Login gives the project a realistic entry point.
- Devices are the center of the system.
- Most other modules depend on `device_id`.

---

## 9. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | ERD drawing lead | Final ERD diagram in draw.io/Lucidchart/StarUML |
| Member 2 | SQL script lead | MySQL database and tables created successfully |
| Member 3 | Java model planning lead | JavaBean fields for each table listed |
| Member 4 | Documentation and CT lead | CT explanation, screenshots, relationship explanation |

Parallel workflow:

```text
Member 1 draws the ERD
Member 2 tests the SQL script
Member 3 prepares model class field lists
Member 4 writes CT/database design explanation
Team reviews together before coding DAO classes
```

---

## 10. Database Testing Checklist

- [ ] Database `network_simulation_db` created
- [ ] `users` table created
- [ ] `devices` table created
- [ ] `network_links` table created
- [ ] `bandwidth_logs` table created
- [ ] `coverage_areas` table created
- [ ] `maintenance_tasks` table created
- [ ] `alerts` table created
- [ ] `reports` table created
- [ ] Foreign keys work correctly
- [ ] Sample data inserted successfully
- [ ] ERD diagram matches SQL script
- [ ] Team can explain each relationship
- [ ] `DBContext.java` can connect to the database

---

## 11. Common Mistakes to Avoid

| Mistake | Why It Is Bad | Fix |
|---|---|---|
| Creating one huge table | Hard to maintain and violates database design principles | Split into entities |
| Storing device links as text only | Cannot query topology properly | Use `network_links` with foreign keys |
| Saving plain passwords in final project | Security risk | Hash passwords in Login module |
| Forgetting foreign keys | Weak relationship design | Add FK constraints |
| Using `jakarta.*` in Java code | Not compatible with Tomcat 9/JDK 8 setup | Use `javax.*` |
| Designing too many tables | Too hard for semester timeline | Keep database realistic and focused |
| Starting DAO before ERD is stable | Causes repeated code changes | Finalize ERD first |

---

## 12. Next Recommended Step

After the ERD is approved, implement the first MVC feature:

```text
Login MVC Module
```

Recommended next file:

```text
PRJ301_Login_MVC_Implementation.md
```

Login flow:

```text
login.jsp
  ↓ submit email/password
LoginServlet
  ↓ validate input
UserDAO
  ↓ query users table
MySQL database
  ↓ return user
LoginServlet
  ↓ create session
Dashboard JSP
```

This is the best first feature because it proves the full Servlet/JSP/DAO/MySQL pattern works.
