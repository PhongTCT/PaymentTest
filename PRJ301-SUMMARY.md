# PRJ301 Project Summary
## Network Infrastructure Simulation Management System

**Last Updated:** 2026-05-22  
**Environment:** NetBeans 13 | JDK 8 | Tomcat 9 | MySQL 8.0 | javax.servlet

---

## Project Overview

Simulate network diagrams, manage and monitor network systems, perform network maintenance, and check bandwidth and signal coverage.

**Methodology:** Computational Thinking (CT) applied throughout.

---

## Phase 1: CT Analysis (COMPLETE)

### Decomposition — 6 Modules
| Module | Description |
|--------|-------------|
| A. User & Authentication | Login, roles (Admin/Engineer/Viewer), sessions |
| B. Device Management (CRUD) | Add/edit/delete network devices |
| C. Topology Visualization | Visual diagram of network (HTML5 Canvas) |
| D. Monitoring & Diagnostics | Bandwidth, latency, device status |
| E. Maintenance Management | Schedule tasks, history, alerts |
| F. Report Generation | Summary reports, exports |

### Pattern Recognition
- CRUD pattern repeats across: Users, Devices, Maintenance
- MVC pattern: Servlet (Controller) → JSP (View) → DAO (Model)
- Database → Java Bean → DAO → Servlet → JSP

### Abstraction
- System **simulates** — uses fake/mock data, not real network protocols
- Focus on visualization and management, not actual ping/SNMP

### Algorithm Design
- Login: form → servlet → DAO authenticate → session → redirect
- CRUD: list → add/edit/delete → DB operations → redirect

---

## Phase 2: Database Schema (COMPLETE)

**Database:** `network_simulation` (MySQL 8.0)

| Table | Purpose | Seed Data |
|-------|---------|-----------|
| `users` | Authentication & roles | 4 users (admin, 2 engineers, 1 viewer) |
| `device_types` | Device categories | 6 types (Router, Switch, Server, PC, Firewall, AP) |
| `devices` | Network devices | 10 sample devices |
| `connections` | Links between devices | 9 connections |
| `device_positions` | X,Y for topology canvas | 10 positions |
| `bandwidth_logs` | Monitoring data | 5 sample logs |
| `maintenance_tasks` | Scheduled maintenance | 2 tasks |
| `alerts` | System alerts | 2 alerts |

**SQL File:** Run the full SQL script provided in chat to create database + seed data.

---

## Phase 3: Login Feature — MVC Pattern (COMPLETE)

### Files Created (9 files)

```
/home/kts/NetworkSimulation/
├── src/java/
│   ├── dao/
│   │   ├── DBConnection.java      ← Singleton DB connection utility
│   │   └── UserDAO.java           ← User queries (authenticate, CRUD)
│   ├── model/
│   │   └── User.java              ← Java Bean (maps to users table)
│   └── controller/
│       ├── LoginServlet.java      ← GET/POST /login
│       └── DashboardServlet.java  ← GET /dashboard (protected)
└── web/
    ├── login.jsp                  ← Login form (public)
    ├── css/style.css              ← Base stylesheet
    └── WEB-INF/
        ├── web.xml                ← Servlet mappings
        └── views/
            └── dashboard.jsp      ← Dashboard (protected)
```

### MVC Flow
```
Browser → /login (GET) → LoginServlet → login.jsp (form)
Browser → /login (POST) → LoginServlet → UserDAO.authenticate()
         → Session created → /dashboard → DashboardServlet → dashboard.jsp
```

### Test Credentials
| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | ADMIN (full access) |
| engineer1 | eng123 | ENGINEER (can edit) |
| engineer2 | eng123 | ENGINEER (can edit) |
| viewer1 | view123 | VIEWER (read only) |

---

## NetBeans Setup Checklist

1. [ ] Create Web Application project: `NetworkSimulation`
2. [ ] Add JARs to Libraries: `mysql-connector-java-8.0.33.jar`, `jstl-1.2.jar`
3. [ ] Configure Tomcat 9 in Services → Servers
4. [ ] Copy `.java` files to matching packages under `Source Packages/`
5. [ ] Copy `login.jsp` to `Web Pages/`
6. [ ] Copy `dashboard.jsp` to `Web Pages/WEB-INF/views/`
7. [ ] Create `css` folder under `Web Pages/` and copy `style.css`
8. [ ] Replace `web.xml` with provided version
9. [ ] Edit `DBConnection.java` line 21 — set your MySQL password
10. [ ] Run SQL script in MySQL Workbench to create database
11. [ ] Right-click project → Run → test login

---

## Team Task Assignment (Suggested)

| Member | Focus Area | Modules |
|--------|-----------|---------|
| Member 1 (You?) | Backend Core | User Auth, Device CRUD, DB |
| Member 2 | Frontend/UI | JSP pages, CSS, topology canvas |
| Member 3 | Monitoring | Bandwidth, alerts, status |
| Member 4 | Maintenance | Tasks, history, reports |

---

## What's Next — Phase 4: Device Management (CRUD)

Build the full CRUD for network devices following the same MVC pattern:

**Files to create:**
- `model/Device.java`
- `dao/DeviceDAO.java`
- `controller/DeviceServlet.java`
- `web/WEB-INF/views/devices/list.jsp`
- `web/WEB-INF/views/devices/form.jsp`
- `web/WEB-INF/views/devices/detail.jsp`

**Features:**
- List all devices (with pagination for 1000+ devices)
- Add new device
- Edit device details
- Delete device (with confirmation)
- Filter by type, status, location
- Search by name/IP

---

## Quick Reference

| What | Where |
|------|-------|
| Project files | `/home/kts/NetworkSimulation/` |
| Database name | `network_simulation` |
| Login URL | `http://localhost:8080/NetworkSimulation/login` |
| Dashboard URL | `http://localhost:8080/NetworkSimulation/dashboard` |
| MySQL password config | `DBConnection.java` line 21 |
