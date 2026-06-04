---
title: "Project Overview — University Network Management System"
tags: [prj301, planning, overview]
created: 2026-05-26
---

# Project Overview — University Network Management System

## 1. Project Information

| Item | Detail |
|---|---|
| **Course** | PRJ301 — Java Web Application Development |
| **Topic** | University Network Management System (Quan ly he thong mang trong truong dai hoc) |
| **Team** | 4 members — Member A, Member B, Member C, Member D |
| **Semester** | Spring 2026 |

---

## 2. System Description

This web application helps university IT staff manage and monitor the campus network infrastructure. It provides a centralized dashboard to track routers, access points, switches, and end-user devices across buildings and floors.

**Who uses the system?**

| Role | Description |
|---|---|
| **Admin** | Full control — manage users, assign roles, configure all devices |
| **Technician** | Handle maintenance tasks, resolve support tickets, update device status |
| **Viewer** | Read-only access — view dashboards, reports, and network status |

**What does it do?**

- Authenticate users with role-based access control (Admin / Technician / Viewer)
- Manage network devices: Routers, Access Points, Switches, and end-user devices
- Monitor bandwidth usage and WiFi analytics
- Manage VLANs, IP address allocation, and room infrastructure
- Track network alerts and support tickets
- Schedule maintenance windows
- Generate activity and performance reports

---

## 3. Tech Stack

| Component | Technology |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 (Java 1.8) |
| Server | Apache Tomcat 9 |
| Backend | Java Servlet + JSP (`javax.servlet.*`) |
| Build Tool | Ant (NetBeans default) |
| Database | MySQL 8.0 |
| JDBC Driver | `mysql-connector-java-8.0.33.jar` |
| View Layer | JSP + JSTL 1.2 |
| Project Name | `NetworkSimulationManagement` |
| DB Name | `network_simulation_db` |

> [!warning]
> Use **Tomcat 9**, not Tomcat 10+. Tomcat 10 uses `jakarta.servlet.*`, which is incompatible with this project.

---

## 4. Computational Thinking Overview

### 4.1 Decomposition

We break the system into **5 major subsystems**:

1. **Authentication & Authorization** — Login, role management, session handling
2. **Device Management** — CRUD for Routers, APs, Switches, and end-user devices
3. **Network Monitoring** — Bandwidth tracking, WiFi analytics, alerts
4. **Infrastructure Management** — Rooms, VLANs, IP addresses
5. **Support & Maintenance** — Support tickets, maintenance schedules, system logs

Each subsystem is independent enough for one team member to own, yet connected through shared entities (User, Room, Device).

### 4.2 Pattern Recognition

Nearly every feature follows the same **CRUD pattern**:

```text
JSP Form  →  Servlet Controller  →  DAO  →  MySQL  →  Servlet  →  JSP List
```

Recognized repeating structures:
- Every model has `insert()`, `update()`, `delete()`, `findAll()` methods
- Status fields appear in Users, Routers, APs, Switches, Devices, Tickets, Maintenance
- Date/time tracking is consistent: `createdAt`, `loginTime`, `recordTime`, etc.
- Role-based filtering applies across all list views

### 4.3 Abstraction

We define clean layers to separate concerns:

| Layer | Responsibility | Examples |
|---|---|---|
| **Presentation** (JSP) | Display data, accept input | `login.jsp`, `router-list.jsp` |
| **Controller** (Servlet) | Handle HTTP, route logic | `LoginServlet`, `RouterServlet` |
| **Data Access** (DAO) | SQL operations | `UserDAO`, `RouterDAO` |
| **Data Transfer** (DTO) | Carry data between layers | `User`, `Router`, `BandwidthUsage` |

The **DTO** (Data Transfer Object) is the core abstraction — each model is a plain Java class with fields, getters, and setters. The DAO knows about the database; the Servlet knows about HTTP; the JSP knows about HTML. They communicate only through DTOs.

### 4.4 Algorithm Design

Key algorithms in the system:

1. **Login Flow** — Validate credentials → check role → create session → redirect by role
2. **Device Block/Unblock** — Find device by MAC → update status → log action → alert if needed
3. **Alert Trigger** — Monitor device status → detect anomaly → create alert → notify dashboard
4. **Support Ticket Lifecycle** — Submit → assign technician → update status → resolve → close

Each algorithm is documented with Mermaid flowcharts in [[01_CT_analysis|CT Analysis]].

---

## 5. Related Documents

| Document | Description |
|---|---|
| [[01_CT_analysis]] | Full Computational Thinking breakdown |
| [[02_erd_database]] | ERD diagram and SQL scripts |
| [[03_team_assignment]] | Member assignments and sprint plan |
| [[04_system_architecture]] | Architecture layers and folder structure |
| [[05_feature_list]] | Feature list grouped by role |
| [[06_report_template]] | Vietnamese-language report outline |
| [[07_coding_guide]] | Step-by-step coding guide with examples |

---

> [!tip]
> Start with [[03_team_assignment]] to understand who does what, then move to [[07_coding_guide]] to see how to implement one model end-to-end.
