---
title: PRJ301 Implementation Checklist
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Implementation Checklist

## 1. Current Focus

This checklist maps all planning documents into actual implementation work inside NetBeans.

The goal is simple:

```text
Turn planning documents into a working Java Web project step by step.
```

Fixed environment:

| Component | Required Setup |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 through NetBeans |
| Backend | Servlet/JSP using `javax.servlet.*` |
| Build Tool | Ant |
| Database | MySQL 8.0 |
| JDBC Driver | `mysql-connector-java-8.0.33.jar` |
| Optional View Library | `jstl-1.2.jar` |

Important rule:

> Do not start coding randomly. Follow the dependency order below so the team does not build modules before their required tables/classes exist.

---

## 2. Computational Thinking Implementation Strategy

## 2.1 Decomposition

The full project is divided into implementation blocks:

| Block | Purpose |
|---|---|
| Environment setup | Prepare NetBeans, JDK, Tomcat, libraries |
| Database setup | Create MySQL database and tables |
| Base MVC setup | Create packages and shared utility classes |
| Authentication | Login/logout and session foundation |
| Device CRUD | Core device data used by many modules |
| Topology | Uses devices and links |
| Monitoring | Uses devices for bandwidth/coverage records |
| Maintenance & Alerts | Uses devices and users |
| Reports | Reads data from all modules |
| Final report/demo | Screenshots, testing, presentation |

---

## 2.2 Pattern Recognition

Most modules follow this repeated implementation pattern:

```text
1. Create database table
2. Create JavaBean model
3. Create DAO
4. Create Servlet controller
5. Create JSP page
6. Add dashboard link
7. Test in NetBeans/Tomcat
8. Capture screenshot
```

Use this as the team’s default checklist for every feature.

---

## 2.3 Abstraction

Implementation should focus on what is required for PRJ301:

| Focus On | Avoid |
|---|---|
| Servlet/JSP MVC | Spring Boot |
| MySQL CRUD | Complex ORM frameworks |
| Simple JavaBeans | Lombok/records |
| Browser print | PDF libraries |
| Vanilla JS topology | Heavy frontend frameworks |
| NetBeans Ant project | Maven/Gradle unless instructor asks |

---

## 2.4 Algorithm Design

Overall build algorithm:

```text
Start
  ↓
Set up NetBeans project
  ↓
Add Tomcat 9 and JDBC driver
  ↓
Create database schema
  ↓
Create package structure
  ↓
Implement login
  ↓
Implement device CRUD
  ↓
Implement topology simulation
  ↓
Implement monitoring
  ↓
Implement maintenance and alerts
  ↓
Implement reports
  ↓
Run full integration test
  ↓
Take screenshots
  ↓
Complete final report
End
```

---

## 3. Existing Planning Documents

| Document | Purpose | Status |
|---|---|---|
| `PRJ301_Project_Setup_Guide.md` | NetBeans/Tomcat/JDK setup | Ready |
| `PRJ301_ERD_and_Database_Design.md` | Database schema and ERD | Ready |
| `PRJ301_Login_MVC_Implementation.md` | Login/logout module | Ready |
| `PRJ301_Device_CRUD_Implementation.md` | Device management module | Ready |
| `PRJ301_Network_Topology_Simulation.md` | Topology simulation module | Ready |
| `PRJ301_Bandwidth_Coverage_Monitoring.md` | Monitoring module | Ready |
| `PRJ301_Maintenance_Scheduling_and_Alerts.md` | Maintenance and alerts | Ready |
| `PRJ301_Report_Generation.md` | Report dashboard | Ready |
| `PRJ301_Final_Report_Structure.md` | Final documentation | Ready |

---

## 4. Recommended Build Order

Follow this order exactly:

| Order | Module | Why This Comes Here |
|---|---|---|
| 1 | Project setup | Everything depends on NetBeans/Tomcat/JDK working |
| 2 | Database schema | DAOs need tables to test queries |
| 3 | Base packages + `DBContext` | All DAOs need database connection |
| 4 | Login MVC | Provides session and dashboard entry point |
| 5 | Device CRUD | Devices are reused by topology, monitoring, maintenance, alerts |
| 6 | Network topology | Requires devices and network links |
| 7 | Bandwidth & coverage monitoring | Requires devices |
| 8 | Maintenance & alerts | Requires devices and users |
| 9 | Report generation | Reads from all previous modules |
| 10 | Final documentation | Uses screenshots and testing results from working app |

---

## 5. NetBeans Project Structure Checklist

Expected project structure:

```text
NetworkInfrastructureSimulation/
├── Web Pages/
│   ├── META-INF/
│   ├── WEB-INF/
│   │   └── web.xml
│   ├── assets/
│   │   ├── css/
│   │   └── js/
│   ├── devices/
│   │   ├── list.jsp
│   │   ├── form.jsp
│   │   └── detail.jsp
│   ├── topology/
│   │   └── simulation.jsp
│   ├── monitoring/
│   │   ├── dashboard.jsp
│   │   ├── add-bandwidth.jsp
│   │   └── add-coverage.jsp
│   ├── maintenance/
│   │   ├── list.jsp
│   │   └── form.jsp
│   ├── alerts/
│   │   └── list.jsp
│   ├── reports/
│   │   └── dashboard.jsp
│   ├── login.jsp
│   └── dashboard.jsp
├── Source Packages/
│   └── com.networksim/
│       ├── controller/
│       ├── dao/
│       ├── model/
│       └── util/
├── Libraries/
│   ├── mysql-connector-java-8.0.33.jar
│   └── jstl-1.2.jar optional
└── build.xml
```

Checklist:

- [ ] Project is a NetBeans **Java Web Application**
- [ ] Project uses **Ant**, not Maven
- [ ] JDK is set to **JDK 8**
- [ ] Server is **Tomcat 9**
- [ ] No `pom.xml` required
- [ ] No `module-info.java`
- [ ] All servlet imports use `javax.servlet.*`

---

## 6. Step 1: Environment Setup

Reference document:

```text
PRJ301_Project_Setup_Guide.md
```

Checklist:

- [ ] Install/configure NetBeans 13
- [ ] Configure JDK 8 build `1.8.0_172`
- [ ] Add Apache Tomcat 9 in NetBeans
- [ ] Create Java Web Application project
- [ ] Confirm project uses Ant
- [ ] Add `mysql-connector-java-8.0.33.jar`
- [ ] Optional: add `jstl-1.2.jar`
- [ ] Run a test JSP page successfully

NetBeans path reminders:

```text
Services tab → Servers → Add Server → Apache Tomcat
Project → Right-click Libraries → Add JAR/Folder
Project → Right-click → Properties → Libraries
Project → Right-click → Run
```

Common pitfall:

> If imports show `jakarta.servlet.*`, the server/library setup is wrong for this project. Use Tomcat 9 and `javax.servlet.*`.

---

## 7. Step 2: Database Setup

Reference document:

```text
PRJ301_ERD_and_Database_Design.md
```

Checklist:

- [ ] Create database, for example `network_simulation_db`
- [ ] Create `roles` table
- [ ] Create `users` table
- [ ] Create `devices` table
- [ ] Create `network_links` table
- [ ] Create `bandwidth_logs` table
- [ ] Create `coverage_areas` table
- [ ] Create `maintenance_tasks` table
- [ ] Create `alerts` table
- [ ] Insert sample roles
- [ ] Insert sample admin user
- [ ] Insert sample devices
- [ ] Test database connection from NetBeans

Suggested implementation order for tables:

```text
roles
users
devices
network_links
bandwidth_logs
coverage_areas
maintenance_tasks
alerts
generated_reports optional
```

Why this order:

> Tables with foreign keys must be created after the tables they reference.

---

## 8. Step 3: Base MVC Packages

Create packages:

```text
Source Packages/com.networksim.model
Source Packages/com.networksim.dao
Source Packages/com.networksim.controller
Source Packages/com.networksim.util
```

Checklist:

- [ ] Create `com.networksim.model`
- [ ] Create `com.networksim.dao`
- [ ] Create `com.networksim.controller`
- [ ] Create `com.networksim.util`
- [ ] Create `DBContext.java`
- [ ] Test `DBContext.getConnection()` through login or simple DAO test

Expected `DBContext` role:

```text
Central place for MySQL connection settings.
```

Important:

> Do not duplicate connection code in every DAO. Keep it inside `DBContext.java`.

---

## 9. Step 4: Login MVC Module

Reference document:

```text
PRJ301_Login_MVC_Implementation.md
```

Files checklist:

| File | Done |
|---|---|
| `model/User.java` | [ ] |
| `dao/UserDAO.java` | [ ] |
| `controller/LoginServlet.java` | [ ] |
| `controller/LogoutServlet.java` | [ ] |
| `Web Pages/login.jsp` | [ ] |
| `Web Pages/dashboard.jsp` | [ ] |

Feature checklist:

- [ ] Login page displays
- [ ] Valid user can log in
- [ ] Invalid login shows error
- [ ] Session stores logged-in user
- [ ] Dashboard displays after login
- [ ] Logout clears session
- [ ] Protected pages check session if implemented

Test data needed:

```text
At least 1 admin user in users table.
```

---

## 10. Step 5: Device CRUD Module

Reference document:

```text
PRJ301_Device_CRUD_Implementation.md
```

Files checklist:

| File | Done |
|---|---|
| `model/Device.java` | [ ] |
| `dao/DeviceDAO.java` | [ ] |
| `controller/DeviceServlet.java` | [ ] |
| `Web Pages/devices/list.jsp` | [ ] |
| `Web Pages/devices/form.jsp` | [ ] |
| `Web Pages/devices/detail.jsp` | [ ] |

Feature checklist:

- [ ] Device list works
- [ ] Add device works
- [ ] Edit device works
- [ ] Delete device works
- [ ] View device detail works
- [ ] Dashboard link to `/devices` works

Test data needed:

```text
Router A
Switch A
Access Point A
Server A
```

Why this module is critical:

> Device CRUD must work before topology, monitoring, maintenance, and alerts because those modules depend on `device_id`.

---

## 11. Step 6: Network Topology Simulation

Reference document:

```text
PRJ301_Network_Topology_Simulation.md
```

Files checklist:

| File | Done |
|---|---|
| `model/NetworkLink.java` | [ ] |
| `dao/NetworkLinkDAO.java` | [ ] |
| `controller/TopologyServlet.java` | [ ] |
| `Web Pages/topology/simulation.jsp` | [ ] |
| Optional `Web Pages/assets/js/topology.js` | [ ] |

Feature checklist:

- [ ] Load devices as nodes
- [ ] Load links as edges
- [ ] Add link between two devices
- [ ] Prevent same source and target device if validation is implemented
- [ ] Display topology diagram
- [ ] Dashboard link to `/topology` works

Test data needed:

```text
Router A → Switch A
Switch A → Access Point A
Switch A → Server A
```

CT explanation for report:

```text
Topology simulation abstracts a network as a graph where devices are nodes and network links are edges.
```

---

## 12. Step 7: Bandwidth & Coverage Monitoring

Reference document:

```text
PRJ301_Bandwidth_Coverage_Monitoring.md
```

Files checklist:

| File | Done |
|---|---|
| `model/BandwidthLog.java` | [ ] |
| `model/CoverageArea.java` | [ ] |
| `dao/BandwidthDAO.java` | [ ] |
| `dao/CoverageDAO.java` | [ ] |
| `controller/MonitoringServlet.java` | [ ] |
| `Web Pages/monitoring/dashboard.jsp` | [ ] |
| `Web Pages/monitoring/add-bandwidth.jsp` | [ ] |
| `Web Pages/monitoring/add-coverage.jsp` | [ ] |

Feature checklist:

- [ ] Monitoring dashboard opens
- [ ] Add bandwidth record works
- [ ] Add coverage record works
- [ ] Latest bandwidth data displays
- [ ] Latest coverage data displays
- [ ] Dashboard link to `/monitoring` works

Test data needed:

```text
Bandwidth:
- download: 90 Mbps, upload: 40 Mbps, latency: 15 ms, packet loss: 0.2%
- download: 60 Mbps, upload: 25 Mbps, latency: 35 ms, packet loss: 1.1%

Coverage:
- signal: -45 dBm, coverage: 95%
- signal: -75 dBm, coverage: 65%
```

---

## 13. Step 8: Maintenance Scheduling & Alerts

Reference document:

```text
PRJ301_Maintenance_Scheduling_and_Alerts.md
```

Files checklist:

| File | Done |
|---|---|
| `model/MaintenanceTask.java` | [ ] |
| `model/Alert.java` | [ ] |
| `dao/MaintenanceDAO.java` | [ ] |
| `dao/AlertDAO.java` | [ ] |
| `controller/MaintenanceServlet.java` | [ ] |
| `controller/AlertServlet.java` | [ ] |
| `Web Pages/maintenance/list.jsp` | [ ] |
| `Web Pages/maintenance/form.jsp` | [ ] |
| `Web Pages/alerts/list.jsp` | [ ] |

Feature checklist:

- [ ] Maintenance list opens
- [ ] Add maintenance task works
- [ ] Edit maintenance task works
- [ ] Delete maintenance task works
- [ ] HIGH priority task creates alert
- [ ] COMPLETED task creates alert
- [ ] Alert page opens
- [ ] Mark alert as read works
- [ ] Dashboard links to `/maintenance` and `/alerts` work

Test data needed:

```text
Task 1: Router A firmware update, HIGH, PENDING
Task 2: Switch A cable inspection, MEDIUM, IN_PROGRESS
Task 3: Access Point A replacement, LOW, COMPLETED
```

---

## 14. Step 9: Report Generation

Reference document:

```text
PRJ301_Report_Generation.md
```

Files checklist:

| File | Done |
|---|---|
| `model/ReportSummary.java` | [ ] |
| `dao/ReportDAO.java` | [ ] |
| `controller/ReportServlet.java` | [ ] |
| `Web Pages/reports/dashboard.jsp` | [ ] |

Feature checklist:

- [ ] `/reports` opens
- [ ] Device totals display
- [ ] Network link total displays
- [ ] Bandwidth averages display
- [ ] Coverage averages display
- [ ] Maintenance status counts display
- [ ] Alert counts display
- [ ] Print button works
- [ ] Dashboard link to `/reports` works

Before testing reports, confirm:

- [ ] Devices exist
- [ ] Links exist
- [ ] Bandwidth logs exist
- [ ] Coverage records exist
- [ ] Maintenance tasks exist
- [ ] Alerts exist

---

## 15. Dashboard Navigation Checklist

Final `dashboard.jsp` should link to:

```jsp
<ul>
    <li><a href="devices">Device & Node Management</a></li>
    <li><a href="topology">Network Topology Simulation</a></li>
    <li><a href="monitoring">Bandwidth & Coverage Monitoring</a></li>
    <li><a href="maintenance">Maintenance Scheduling</a></li>
    <li><a href="alerts">System Alerts</a></li>
    <li><a href="reports">Report Generation</a></li>
</ul>
```

Checklist:

- [ ] `devices` link works
- [ ] `topology` link works
- [ ] `monitoring` link works
- [ ] `maintenance` link works
- [ ] `alerts` link works
- [ ] `reports` link works
- [ ] `logout` link works

---

## 16. Integration Testing Checklist

Run this after all modules are implemented:

| Step | Test | Done |
|---|---|---|
| 1 | Start Tomcat 9 from NetBeans | [ ] |
| 2 | Open login page | [ ] |
| 3 | Login with valid account | [ ] |
| 4 | Open dashboard | [ ] |
| 5 | Add device | [ ] |
| 6 | Edit device | [ ] |
| 7 | Add topology link | [ ] |
| 8 | View topology diagram | [ ] |
| 9 | Add bandwidth record | [ ] |
| 10 | Add coverage record | [ ] |
| 11 | Add HIGH priority maintenance task | [ ] |
| 12 | Confirm alert created | [ ] |
| 13 | Mark alert as read | [ ] |
| 14 | Open report dashboard | [ ] |
| 15 | Print report preview | [ ] |
| 16 | Logout | [ ] |

---

## 17. Bug Fix Checklist

When a bug happens, debug in this order:

```text
1. Check browser URL
2. Check servlet mapping
3. Check JSP link/action
4. Check request parameter names
5. Check DAO SQL table/column names
6. Check database data
7. Check Tomcat output window in NetBeans
8. Check Java imports
```

Common bug mapping:

| Error | Check First |
|---|---|
| HTTP 404 | URL pattern and JSP link |
| HTTP 500 | Tomcat output stack trace |
| ClassNotFound JDBC | MySQL connector JAR |
| Cannot connect database | DB URL, username, password |
| NullPointerException | Missing request attribute or DAO result |
| Date parse error | `datetime-local` format |
| Compile error on servlet imports | `javax.servlet.*`, not `jakarta.servlet.*` |

---

## 18. Screenshot Collection Checklist

Create a folder for screenshots:

```text
PRJ301_Final_Report_Screenshots/
```

Recommended screenshots:

| Screenshot | Done |
|---|---|
| NetBeans project structure | [ ] |
| Libraries showing MySQL connector | [ ] |
| Tomcat 9 server in NetBeans | [ ] |
| MySQL tables | [ ] |
| Login page | [ ] |
| Dashboard page | [ ] |
| Device list | [ ] |
| Device form | [ ] |
| Topology simulation | [ ] |
| Monitoring dashboard | [ ] |
| Add bandwidth form | [ ] |
| Add coverage form | [ ] |
| Maintenance list | [ ] |
| Alert list | [ ] |
| Report dashboard | [ ] |
| Print preview | [ ] |

---

## 19. Team Weekly Work Plan

## Week 1: Setup and Database

| Member | Task |
|---|---|
| Member 1 | NetBeans project setup and Tomcat configuration |
| Member 2 | MySQL database schema |
| Member 3 | Base JSP layout and dashboard draft |
| Member 4 | ERD and CT documentation |

Deliverables:

- [ ] Working NetBeans project
- [ ] MySQL schema
- [ ] Initial dashboard
- [ ] ERD draft

## Week 2: Login and Device CRUD

| Member | Task |
|---|---|
| Member 1 | Login Servlet/DAO |
| Member 2 | Device DAO/model |
| Member 3 | Device JSP pages |
| Member 4 | Test cases and screenshots |

Deliverables:

- [ ] Login works
- [ ] Device CRUD works
- [ ] Screenshots captured

## Week 3: Topology and Monitoring

| Member | Task |
|---|---|
| Member 1 | Topology Servlet/DAO |
| Member 2 | Bandwidth/Coverage DAO |
| Member 3 | Topology and monitoring JSPs |
| Member 4 | Flowcharts and sequence diagrams |

Deliverables:

- [ ] Topology works
- [ ] Monitoring works
- [ ] Diagrams updated

## Week 4: Maintenance, Alerts, Reports

| Member | Task |
|---|---|
| Member 1 | Maintenance backend |
| Member 2 | Alerts backend |
| Member 3 | Report dashboard JSP |
| Member 4 | Report DAO/testing documentation |

Deliverables:

- [ ] Maintenance works
- [ ] Alerts work
- [ ] Reports work

## Week 5: Final Testing and Report

| Member | Task |
|---|---|
| Member 1 | Fix backend bugs |
| Member 2 | Verify database and SQL |
| Member 3 | Polish UI and screenshots |
| Member 4 | Final report and presentation |

Deliverables:

- [ ] Full integration test completed
- [ ] Final report completed
- [ ] Presentation ready

---

## 20. Final Demo Script

Use this order during demo:

```text
1. Open NetBeans project
2. Show Tomcat 9 and JDK 8 setup
3. Run project
4. Login
5. Show dashboard
6. Add/view device
7. Show topology simulation
8. Add bandwidth or coverage data
9. Add HIGH priority maintenance task
10. Show generated alert
11. Mark alert as read
12. Open report dashboard
13. Print report preview
14. Logout
```

Demo tip:

> Prepare sample data before demo. Do not type too much live during presentation because typing errors waste time.

---

## 21. Final Quality Checklist

Before submission:

- [ ] Project runs from NetBeans
- [ ] Tomcat version is 9.x
- [ ] JDK version is 8
- [ ] No `jakarta.servlet.*` imports
- [ ] No Java 9+ syntax
- [ ] MySQL connector JAR is added
- [ ] All modules are linked from dashboard
- [ ] All main CRUD functions work
- [ ] Reports show real data
- [ ] Screenshots are clear
- [ ] Diagrams are readable
- [ ] CT analysis is included in report
- [ ] Team contribution is honest and specific
- [ ] Final report spelling checked
- [ ] Presentation demo rehearsed

---

## 22. Next Recommended Step

After this checklist, the planning set is complete enough to start implementation.

Recommended next action:

```text
Start coding Step 1–3 in NetBeans:
1. Project setup
2. Database schema
3. Base MVC packages and DBContext
```

If the team wants another document, create:

```text
PRJ301_Demo_Script_and_QA.md
```

That file can prepare:

- presentation script
- possible teacher questions
- short answers for each module
- CT explanation practice
