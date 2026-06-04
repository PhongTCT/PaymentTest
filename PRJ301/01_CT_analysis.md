---
title: "Computational Thinking Analysis"
tags: [prj301, planning, ct, analysis]
created: 2026-05-26
---

# Computational Thinking Analysis

This document applies the **4 pillars of Computational Thinking** to the University Network Management System.

---

## 1. Decomposition — Breaking the System into Parts

We decompose the system into **5 major subsystems**, each containing related models:

### 1.1 Authentication & Authorization

| Model | Purpose |
|---|---|
| **User** | Login, account management, role assignment |
| **Role** | Define access levels: Admin, Technician, Viewer |
| **AuthenticationLog** | Track all login attempts (success/failure) |

### 1.2 Device Management

| Model | Purpose |
|---|---|
| **Router** | Campus routers — name, IP, firmware, online/offline |
| **AccessPoint** | WiFi APs — SSID, connected users, signal |
| **Switch** | Network switches — ports, usage |
| **NetworkDevice** | Student/lecturer devices — MAC, owner, block/unblock |
| **Room** | Physical classrooms with network infrastructure |

### 1.3 Network Monitoring & Analytics

| Model | Purpose |
|---|---|
| **BandwidthUsage** | Track upload/download speed per device |
| **WiFiAnalytics** | Aggregate WiFi usage — total users, peak, avg speed |
| **NetworkAlert** | Auto-generated alerts on outages or anomalies |

### 1.4 Infrastructure Management

| Model | Purpose |
|---|---|
| **VLAN** | Campus VLAN definitions and subnets |
| **IPAddressManagement** | IP allocation and availability tracking |

### 1.5 Support & Maintenance

| Model | Purpose |
|---|---|
| **SupportTicket** | Student-submitted WiFi issue reports |
| **MaintenanceSchedule** | Planned maintenance windows |
| **SystemLog** | Full audit trail of all system actions |

### Decomposition Diagram

```mermaid
graph TD
    A[University Network Management System] --> B[Authentication & Authorization]
    A --> C[Device Management]
    A --> D[Network Monitoring]
    A --> E[Infrastructure Management]
    A --> F[Support & Maintenance]

    B --> B1[User]
    B --> B2[Role]
    B --> B3[AuthenticationLog]

    C --> C1[Router]
    C --> C2[AccessPoint]
    C --> C3[Switch]
    C --> C4[NetworkDevice]
    C --> C5[Room]

    D --> D1[BandwidthUsage]
    D --> D2[WiFiAnalytics]
    D --> D3[NetworkAlert]

    E --> E1[VLAN]
    E --> E2[IPAddressManagement]

    F --> F1[SupportTicket]
    F --> F2[MaintenanceSchedule]
    F --> F3[SystemLog]
```

---

## 2. Pattern Recognition — Identifying Repeating Structures

### 2.1 CRUD Pattern

Almost every model follows the same Create-Read-Update-Delete pattern:

```text
insert()  →  INSERT INTO table ...
findAll() →  SELECT * FROM table
findById()→  SELECT * FROM table WHERE id = ?
update()  →  UPDATE table SET ...
delete()  →  DELETE FROM table WHERE id = ?
```

Models that follow this exact pattern: User, Role, Router, AccessPoint, Switch, NetworkDevice, Room, VLAN, MaintenanceSchedule, NetworkAlert, SupportTicket, SystemLog.

### 2.2 Status Management Pattern

Many models use a `status` field with a fixed set of values:

| Model | Status Values |
|---|---|
| User | `ACTIVE`, `INACTIVE`, `LOCKED` |
| Router | `ONLINE`, `OFFLINE`, `MAINTENANCE` |
| AccessPoint | `ONLINE`, `OFFLINE` |
| Switch | `ONLINE`, `OFFLINE` |
| NetworkDevice | `ALLOWED`, `BLOCKED` |
| SupportTicket | `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED` |
| MaintenanceSchedule | `PLANNED`, `IN_PROGRESS`, `COMPLETED` |
| IPAddressManagement | `AVAILABLE`, `ASSIGNED`, `RESERVED` |

### 2.3 Role-Based Access Pattern

Every Servlet checks the user's role before processing:

```text
if (user.getRole().equals("ADMIN"))     → full access
if (user.getRole().equals("TECHNICIAN"))→ limited write access
if (user.getRole().equals("VIEWER"))    → read-only access
```

### 2.4 Date/Time Tracking Pattern

Most models include timestamp fields:

| Field | Used In |
|---|---|
| `createdAt` / `createdDate` | User, NetworkAlert, SupportTicket, SystemLog |
| `loginTime` | AuthenticationLog |
| `recordTime` | BandwidthUsage |
| `analyticsDate` | WiFiAnalytics |
| `startTime` / `endTime` | MaintenanceSchedule |

---

## 3. Abstraction — Defining Clean Layers

### 3.1 Three-Layer Architecture

```mermaid
graph LR
    A[Browser] -->|HTTP| B[Presentation Layer<br/>JSP + HTML]
    B -->|Form Submit| C[Controller Layer<br/>Servlet]
    C -->|Call Methods| D[Data Access Layer<br/>DAO]
    D -->|JDBC| E[(MySQL Database)]
    D -->|Return DTO| C
    C -->|Set Attribute| B
```

### 3.2 DTO as Data Carrier

Each model is a **DTO (Data Transfer Object)** — a plain Java class that carries data between layers:

```text
┌─────────────────────────────────┐
│           Router DTO            │
├─────────────────────────────────┤
│ - routerId: int                 │
│ - routerName: String            │
│ - ipAddress: String             │
│ - macAddress: String            │
│ - model: String                 │
│ - firmware: String              │
│ - status: String                │
│ - location: String              │
├─────────────────────────────────┤
│ + getters / setters             │
└─────────────────────────────────┘
```

The DTO has **no database logic** — it only holds data. The DAO handles all SQL. The Servlet handles all HTTP. The JSP handles all HTML. This separation is the core abstraction.

### 3.3 Interface Abstraction

Each DAO can optionally implement a common interface:

```java
public interface BaseDAO<T> {
    boolean insert(T entity);
    boolean update(T entity);
    boolean delete(int id);
    T findById(int id);
    List<T> findAll();
}
```

This reduces code duplication and makes the system consistent.

---

## 4. Algorithm Design — Step-by-Step Logic

### 4.1 Login Flow

```mermaid
flowchart TD
    A[User opens login.jsp] --> B[Enter username + password]
    B --> C[Submit to LoginServlet]
    C --> D{Fields empty?}
    D -->|Yes| E[Show error message]
    E --> A
    D -->|No| F[Call UserDAO.login]
    F --> G{User found?}
    G -->|No| H[Show 'Invalid credentials']
    H --> A
    G -->|Yes| I{Status = ACTIVE?}
    I -->|No| J[Show 'Account locked']
    J --> A
    I -->|Yes| K[Create HttpSession]
    K --> L[Store user in session]
    L --> M[Redirect by role]
    M -->|ADMIN| N[Admin Dashboard]
    M -->|TECHNICIAN| O[Technician Dashboard]
    M -->|VIEWER| P[Viewer Dashboard]
```

### 4.2 Device Block/Unblock Flow

```mermaid
flowchart TD
    A[Admin views device list] --> B[Click Block/Unblock on a device]
    B --> C[Submit to NetworkDeviceServlet]
    C --> D[Call NetworkDeviceDAO.findByMAC]
    D --> E{Device found?}
    E -->|No| F[Show error: Device not found]
    E -->|Yes| G{Action = Block?}
    G -->|Block| H[Call blockDevice - status = BLOCKED]
    G -->|Unblock| I[Call unblockDevice - status = ALLOWED]
    H --> J[Log action to SystemLog]
    I --> J
    J --> K[Create NetworkAlert if blocked]
    K --> L[Redirect to device list with success message]
```

### 4.3 Alert Trigger Flow

```mermaid
flowchart TD
    A[System detects issue] --> B{Issue type?}
    B -->|Device offline| C[Router/AP/Switch status = OFFLINE]
    B -->|High bandwidth| D[BandwidthUsage exceeds threshold]
    B -->|WiFi overload| E[WiFiAnalytics peakUsers > max]
    C --> F[Create NetworkAlert]
    D --> F
    E --> F
    F --> G[Set severity: INFO / WARNING / CRITICAL]
    G --> H[Store in database]
    H --> I[Display on Admin dashboard]
```

### 4.4 Support Ticket Lifecycle

```mermaid
flowchart TD
    A[Student submits ticket] --> B[SupportTicket created - status OPEN]
    B --> C[Admin views open tickets]
    C --> D[Assign technician]
    D --> E[Status = IN_PROGRESS]
    E --> F[Technician resolves issue]
    F --> G[Status = RESOLVED]
    G --> H[Admin confirms]
    H --> I[Status = CLOSED]
```

---

## 5. CT Summary Table

| Pillar | How Applied |
|---|---|
| **Decomposition** | 16 models split into 5 subsystems, each assigned to team members |
| **Pattern Recognition** | CRUD pattern, status fields, role-based access, date tracking |
| **Abstraction** | 3-layer architecture, DTO as data carrier, BaseDAO interface |
| **Algorithm Design** | Flowcharts for login, device block, alert trigger, ticket lifecycle |

---

> [!note]
> This CT analysis should be referenced in **Chapter 2** of the final report. See [[06_report_template]] for the report structure.
