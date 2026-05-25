---
title: PRJ301 Final Report Structure
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Final Report Structure

## 1. Current Focus

This document helps the team prepare the final PRJ301 project report for:

```text
Network Infrastructure Simulation Management System using Java Web
```

The report should clearly show:

- what problem the system solves
- how Computational Thinking was applied
- how the system was designed
- how each module was implemented
- how the team tested the application
- what each member contributed

Fixed environment used in the project:

| Component | Required Setup |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 through NetBeans |
| Backend | Servlet/JSP using `javax.servlet.*` |
| Build Tool | Ant |
| Database | MySQL 8.0 |
| Frontend | HTML5, CSS3, vanilla JavaScript |

Important:

> In the final report, always mention that the system uses the legacy `javax.servlet.*` namespace because the project runs on JDK 8 and Tomcat 9.

---

## 2. Recommended Final Report Outline

Use this structure for the final document:

```text
1. Cover Page
2. Team Member Contribution Table
3. Introduction
4. Problem Statement
5. Project Objectives
6. Scope of the Project
7. Computational Thinking Analysis
8. System Requirements
9. System Design
10. Database Design
11. System Architecture
12. Module Implementation
13. Testing Plan and Results
14. Screenshots
15. Difficulties and Solutions
16. Conclusion
17. Lessons Learned
18. References
19. Appendix
```

---

## 3. Cover Page

Suggested content:

```text
FPT University / University Name
Course: PRJ301 - Java Web Application Development
Project Title: Network Infrastructure Simulation Management System
Team Name: [Your Team Name]
Class: [Your Class]
Instructor: [Instructor Name]
Semester: [Semester]
Date: 2026-05-25
```

Checklist:

- [ ] University name
- [ ] Course name
- [ ] Project title
- [ ] Team members
- [ ] Instructor name
- [ ] Submission date

---

## 4. Team Member Contribution Table

| Member | Main Role | Main Modules | Deliverables |
|---|---|---|---|
| Member 1 | Backend Lead | Login, Device CRUD, Report DAO | Servlets, DAOs, model classes |
| Member 2 | Database & Topology Lead | ERD, Topology Simulation | SQL schema, topology logic |
| Member 3 | Monitoring & Maintenance Lead | Bandwidth, Coverage, Maintenance | Monitoring DAO/Servlet/JSP |
| Member 4 | Frontend & Documentation Lead | JSP UI, CT docs, Testing | JSP pages, diagrams, report |

Teamwork note:

> Even though each member owns specific modules, all members should understand the full MVC flow because the final demo may include questions about any part of the system.

---

## 5. Introduction

Sample writing:

```text
Network infrastructure is an important part of modern organizations because it connects users, devices, and services. In real environments, administrators need tools to manage devices, monitor bandwidth, check coverage, schedule maintenance, and respond to alerts. However, building a full enterprise network management system is complex and expensive.

This project develops a simplified Network Infrastructure Simulation Management System using Java Web technologies. The system allows users to manage network devices, simulate network topology, record bandwidth and coverage data, schedule maintenance tasks, view alerts, and generate summary reports. The project follows the MVC architecture with Servlet, JSP, DAO, JavaBean models, and MySQL database.
```

Checklist:

- [ ] Explain network infrastructure context
- [ ] Explain why management/monitoring is needed
- [ ] Introduce the Java Web system
- [ ] Mention MVC architecture
- [ ] Mention Servlet/JSP/MySQL

---

## 6. Problem Statement

Sample writing:

```text
Managing a network manually can be difficult because information about devices, connections, performance, maintenance, and alerts may be stored separately. This makes it hard for administrators to understand the current condition of the network and respond quickly to problems.

The problem addressed by this project is how to design and implement a web-based simulation system that can organize network infrastructure data, display network topology, monitor simulated performance, support maintenance planning, and summarize system status in reports.
```

Checklist:

- [ ] State the real-world problem
- [ ] Explain why manual tracking is difficult
- [ ] Connect the problem to the project features
- [ ] Keep the problem realistic for a student project

---

## 7. Project Objectives

| Objective | Description |
|---|---|
| Manage users | Allow login/logout and role-based access foundation |
| Manage devices | Add, view, edit, and delete network devices |
| Simulate topology | Display devices as nodes and links as connections |
| Monitor bandwidth | Record simulated upload, download, latency, and packet loss |
| Monitor coverage | Record signal strength and coverage percentage |
| Schedule maintenance | Plan maintenance tasks for network devices |
| Show alerts | Display warning messages and mark alerts as read |
| Generate reports | Summarize important network status metrics |

Short paragraph:

```text
The main objective of the project is to build a Java Web application that demonstrates basic network infrastructure management using a realistic but simplified simulation model. The system is designed for educational purposes and focuses on clear data organization, MVC implementation, and Computational Thinking.
```

---

## 8. Scope of the Project

## 8.1 In Scope

- User authentication
- Device and node CRUD
- Network topology simulation
- Bandwidth monitoring
- Coverage monitoring
- Maintenance scheduling
- System alerts
- Report generation
- MySQL database storage
- Servlet/JSP MVC implementation

## 8.2 Out of Scope

- Real-time packet capture
- Real router/switch integration
- Real SNMP monitoring
- Email/SMS alerts
- Advanced graph layout algorithms
- Enterprise PDF/Excel reporting
- Spring Boot or microservices

Why this matters:

> A clear scope helps the team explain that the system is a simulation, not a production network monitoring platform.

---

## 9. Computational Thinking Analysis

This is one of the most important graded sections.

## 9.1 Decomposition

The system was divided into smaller modules:

| Module | Responsibility |
|---|---|
| Authentication | Login, logout, session management |
| Device Management | CRUD operations for network devices |
| Topology Simulation | Display devices and links as a network diagram |
| Bandwidth Monitoring | Record and view simulated bandwidth data |
| Coverage Monitoring | Record and view wireless signal coverage data |
| Maintenance Scheduling | Manage planned maintenance tasks |
| Alerts | Show warnings and system messages |
| Reports | Summarize important system information |

Sample writing:

```text
Decomposition was applied by breaking the large network management problem into smaller modules. Each module has a clear responsibility and can be developed independently. For example, Device Management handles only device information, while Topology Simulation uses device data to draw network connections.
```

## 9.2 Pattern Recognition

Repeated patterns found in the project:

| Pattern | Example |
|---|---|
| MVC flow | JSP → Servlet → DAO → Database |
| CRUD operations | Device, Maintenance |
| Status fields | Device status, task status, alert status |
| Foreign keys | `device_id` reused in topology, monitoring, maintenance, alerts |
| Summary queries | Report module uses `COUNT` and `AVG` repeatedly |

Sample writing:

```text
Pattern recognition helped the team reuse similar structures across modules. Device CRUD, Maintenance Scheduling, and Monitoring all follow a similar flow where users submit data through JSP forms, Servlets process requests, DAOs communicate with MySQL, and JSP pages display results.
```

## 9.3 Abstraction

Important data selected for each module:

| Area | Important Data | Ignored Details |
|---|---|---|
| Device | name, type, IP, location, status | low-level hardware configuration |
| Topology | source device, target device, link type | real routing protocols |
| Bandwidth | download, upload, latency, packet loss | real packet inspection |
| Coverage | signal strength, coverage percentage | real radio wave calculation |
| Maintenance | device, title, date, priority, status | enterprise ticketing workflow |
| Alerts | message, severity, read status | email/SMS notification |

Sample writing:

```text
Abstraction was used to focus only on the information needed for a student-level simulation system. For example, the topology module represents devices as nodes and links as edges, without implementing real routing algorithms or physical network protocols.
```

## 9.4 Algorithm Design

Main system algorithm:

```text
Start
  ↓
User logs in
  ↓
System creates session
  ↓
User selects module from dashboard
  ↓
Servlet receives request
  ↓
Servlet calls DAO
  ↓
DAO reads or writes MySQL data
  ↓
Servlet forwards result to JSP
  ↓
JSP displays response
End
```

Sample writing:

```text
Algorithm design was applied before implementation by defining the step-by-step logic for each module. For example, the login algorithm validates user credentials, creates a session when valid, and redirects the user to the dashboard. The report algorithm collects summary data from multiple tables and displays the result in one dashboard.
```

Checklist:

- [ ] Explain all 4 CT pillars
- [ ] Connect CT to actual modules
- [ ] Include at least one algorithm flow
- [ ] Do not write CT as theory only

---

## 10. System Requirements

## 10.1 Functional Requirements

| ID | Requirement |
|---|---|
| FR1 | The system shall allow users to log in and log out. |
| FR2 | The system shall allow users to manage network devices. |
| FR3 | The system shall allow users to create network links between devices. |
| FR4 | The system shall display a simulated network topology. |
| FR5 | The system shall allow users to record bandwidth monitoring data. |
| FR6 | The system shall allow users to record coverage monitoring data. |
| FR7 | The system shall allow users to schedule maintenance tasks. |
| FR8 | The system shall generate alerts for important events. |
| FR9 | The system shall allow users to mark alerts as read. |
| FR10 | The system shall generate summary reports. |

## 10.2 Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR1 | The system shall run on JDK 8. |
| NFR2 | The system shall use Apache Tomcat 9 through NetBeans. |
| NFR3 | The system shall use Servlet/JSP with `javax.servlet.*`. |
| NFR4 | The system shall store data in MySQL. |
| NFR5 | The system shall use the MVC architecture. |
| NFR6 | The user interface shall be simple and understandable for students. |
| NFR7 | The system shall use prepared statements for database queries. |

---

## 11. System Design

## 11.1 Use Case Diagram

Actors:

```text
Admin
Technician
Viewer
```

Use cases:

```text
Login
Logout
Manage Devices
View Topology
Manage Network Links
Record Bandwidth Data
Record Coverage Data
Schedule Maintenance
View Alerts
Mark Alert as Read
Generate Report
```

Draw.io guidance:

```text
Admin connects to all use cases.
Technician connects to View Topology, Record Monitoring Data, Schedule Maintenance, View Alerts.
Viewer connects to View Topology, View Alerts, Generate Report.
```

## 11.2 ERD

Main entities:

```text
users
roles
devices
network_links
bandwidth_logs
coverage_areas
maintenance_tasks
alerts
generated_reports optional
```

Important relationships:

| Relationship | Meaning |
|---|---|
| roles 1 - many users | One role can belong to many users |
| devices 1 - many bandwidth_logs | One device can have many bandwidth records |
| devices 1 - many coverage_areas | One device can have many coverage records |
| devices 1 - many maintenance_tasks | One device can have many maintenance tasks |
| devices 1 - many alerts | One device can have many alerts |
| devices 1 - many network_links as source | Device can connect to other devices |
| devices 1 - many network_links as target | Device can be connected from other devices |

## 11.3 System Architecture Diagram

Architecture:

```text
Browser
  ↓
JSP Pages
  ↓
Servlet Controllers
  ↓
DAO Classes
  ↓
MySQL Database
```

Detailed MVC mapping:

| Layer | Files |
|---|---|
| View | `login.jsp`, `devices/list.jsp`, `topology/simulation.jsp`, `reports/dashboard.jsp` |
| Controller | `LoginServlet`, `DeviceServlet`, `TopologyServlet`, `ReportServlet` |
| Model | `User`, `Device`, `MaintenanceTask`, `ReportSummary` |
| DAO | `UserDAO`, `DeviceDAO`, `ReportDAO` |
| Database | MySQL tables |

---

## 12. Database Design Summary

Include this table in the report:

| Table | Purpose |
|---|---|
| `roles` | Stores user roles |
| `users` | Stores login accounts |
| `devices` | Stores network device information |
| `network_links` | Stores connections between devices |
| `bandwidth_logs` | Stores simulated bandwidth records |
| `coverage_areas` | Stores signal coverage records |
| `maintenance_tasks` | Stores maintenance schedules |
| `alerts` | Stores system alert messages |
| `generated_reports` | Optional table for saved reports |

Suggested paragraph:

```text
The database was designed using relational principles. Foreign keys are used to connect related data, especially `device_id`, which appears in topology, monitoring, maintenance, and alert tables. This design helps avoid duplicated device information and keeps the system consistent.
```

---

## 13. Module Implementation Sections

Use this format for every module.

```text
13.x Module Name
- Purpose
- CT application
- Main files
- Key functions
- Screenshot
- Testing result
```

## 13.1 Login MVC Module

| Item | Description |
|---|---|
| Purpose | Authenticate users and create sessions |
| Main files | `login.jsp`, `LoginServlet.java`, `UserDAO.java`, `User.java` |
| CT focus | Decomposition and algorithm design |
| Result | Users can log in and access dashboard |

## 13.2 Device & Node Management

| Item | Description |
|---|---|
| Purpose | Manage network devices using CRUD |
| Main files | `DeviceServlet.java`, `DeviceDAO.java`, `Device.java`, device JSPs |
| CT focus | Pattern recognition through CRUD |
| Result | Users can add, view, edit, and delete devices |

## 13.3 Network Topology Simulation

| Item | Description |
|---|---|
| Purpose | Display devices as nodes and links as edges |
| Main files | `TopologyServlet.java`, `NetworkLinkDAO.java`, `simulation.jsp` |
| CT focus | Abstraction of network diagram as graph |
| Result | Users can view a simulated topology diagram |

## 13.4 Bandwidth & Coverage Monitoring

| Item | Description |
|---|---|
| Purpose | Store simulated network performance data |
| Main files | `MonitoringServlet.java`, `BandwidthDAO.java`, `CoverageDAO.java` |
| CT focus | Decomposition into bandwidth and coverage data |
| Result | Users can record and view monitoring results |

## 13.5 Maintenance Scheduling & Alerts

| Item | Description |
|---|---|
| Purpose | Schedule maintenance tasks and show alerts |
| Main files | `MaintenanceServlet.java`, `AlertServlet.java`, `MaintenanceDAO.java`, `AlertDAO.java` |
| CT focus | Algorithm design for automatic alert creation |
| Result | High priority tasks and completed tasks can create alerts |

## 13.6 Report Generation

| Item | Description |
|---|---|
| Purpose | Summarize system data in one dashboard |
| Main files | `ReportServlet.java`, `ReportDAO.java`, `ReportSummary.java`, `reports/dashboard.jsp` |
| CT focus | Pattern recognition using repeated summary queries |
| Result | Users can view and print system reports |

---

## 14. Testing Plan and Results

Use this table:

| Test ID | Feature | Test Case | Input | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| TC01 | Login | Valid login | Correct email/password | Go to dashboard | Same as expected | Pass |
| TC02 | Login | Invalid login | Wrong password | Show error | Same as expected | Pass |
| TC03 | Device CRUD | Add device | Valid device data | Device appears in list | Same as expected | Pass |
| TC04 | Device CRUD | Edit device | Changed IP/status | Updated data appears | Same as expected | Pass |
| TC05 | Topology | Add link | Source + target devices | Link appears in topology | Same as expected | Pass |
| TC06 | Monitoring | Add bandwidth log | Speed/latency data | Log appears in dashboard | Same as expected | Pass |
| TC07 | Coverage | Add coverage data | Signal/coverage data | Record appears | Same as expected | Pass |
| TC08 | Maintenance | Add high priority task | Priority HIGH | Alert created | Same as expected | Pass |
| TC09 | Alerts | Mark alert as read | Click Mark as Read | Status becomes READ | Same as expected | Pass |
| TC10 | Reports | Generate report | Open `/reports` | Summary displayed | Same as expected | Pass |

Checklist:

- [ ] Include at least 10 test cases
- [ ] Include both success and failure tests
- [ ] Add screenshots for important tests
- [ ] Mark each test as Pass/Fail

---

## 15. Screenshot Checklist

Take screenshots for:

- [ ] Login page
- [ ] Dashboard page
- [ ] Device list page
- [ ] Device form page
- [ ] Topology simulation page
- [ ] Bandwidth dashboard
- [ ] Coverage form or list
- [ ] Maintenance list
- [ ] Maintenance form
- [ ] Alerts page
- [ ] Report dashboard
- [ ] Browser print preview for report
- [ ] MySQL database tables
- [ ] NetBeans project structure

Tip:

> Put screenshots near the module they belong to, not all at the end. This makes the report easier to read.

---

## 16. Difficulties and Solutions

| Difficulty | Solution |
|---|---|
| Servlet mapping caused HTTP 404 | Checked `@WebServlet` URL patterns and JSP links |
| Tomcat 10 caused import errors | Switched to Tomcat 9 and used `javax.servlet.*` |
| MySQL connection failed | Added compatible JDBC driver JAR to NetBeans Libraries |
| Date input parsing failed | Used `datetime-local` and `yyyy-MM-dd'T'HH:mm` format |
| Topology drawing was complex | Abstracted devices as nodes and links as edges |
| Team task overlap | Divided modules by backend, frontend, database, and documentation |

Sample writing:

```text
One difficulty was understanding the difference between `javax.servlet.*` and `jakarta.servlet.*`. Because the project uses JDK 8 and Tomcat 9, the correct namespace is `javax.servlet.*`. Using Tomcat 10 caused compatibility issues, so the team used Tomcat 9 through NetBeans.
```

---

## 17. Conclusion

Sample writing:

```text
The Network Infrastructure Simulation Management System successfully demonstrates how a Java Web application can be used to manage and monitor a simplified network environment. The system includes authentication, device management, topology simulation, bandwidth and coverage monitoring, maintenance scheduling, alerts, and report generation.

Through this project, the team practiced MVC architecture, Servlet/JSP development, DAO-based database access, MySQL design, and Computational Thinking. The project also helped the team understand how large systems can be decomposed into smaller modules and implemented step by step.
```

---

## 18. Lessons Learned

Suggested bullet points:

- Learned how to build Java Web applications using NetBeans, JDK 8, Tomcat 9, Servlet, and JSP.
- Learned how to apply MVC architecture in a real project.
- Learned how to design relational database tables using primary keys and foreign keys.
- Learned how Computational Thinking helps break down complex systems.
- Learned how to divide work across team members.
- Learned how to debug common web application problems such as HTTP 404, database connection errors, and servlet mapping issues.

---

## 19. References

Suggested references:

```text
1. Oracle Java SE 8 Documentation
2. Apache Tomcat 9 Documentation
3. MySQL 8.0 Reference Manual
4. NetBeans IDE Documentation
5. Java Servlet API Documentation
6. Course PRJ301 lecture materials
```

Do not cite random blogs unless the team actually used them.

---

## 20. Appendix

Put long technical details here:

- SQL schema
- Extra source code snippets
- Full test data
- Additional screenshots
- Team meeting notes
- GitHub link if available

---

## 21. Final Submission Checklist

- [ ] Cover page completed
- [ ] Team contribution table completed
- [ ] Introduction written
- [ ] Problem statement written
- [ ] Objectives listed
- [ ] Scope clearly defined
- [ ] CT analysis includes all 4 pillars
- [ ] Use case diagram included
- [ ] ERD included
- [ ] MVC architecture diagram included
- [ ] Flowcharts included
- [ ] Sequence diagrams included
- [ ] Database design explained
- [ ] All modules described
- [ ] Testing table completed
- [ ] Screenshots inserted
- [ ] Difficulties and solutions written
- [ ] Conclusion written
- [ ] Lessons learned written
- [ ] References added
- [ ] Formatting checked
- [ ] Spelling checked
- [ ] File exported to PDF if required by instructor

---

## 22. Suggested Presentation Structure

If the team needs to present, use this order:

```text
1. Introduce project problem
2. Explain CT decomposition
3. Show system architecture
4. Show ERD
5. Demo login
6. Demo device CRUD
7. Demo topology simulation
8. Demo monitoring
9. Demo maintenance and alerts
10. Demo report generation
11. Explain testing
12. Explain lessons learned
```

Presentation timing tip:

> Do not spend too long on login. The most interesting parts are topology simulation, monitoring, maintenance alerts, and reports.

---

## 23. Recommended Next Step

The planning phase is now mostly complete. The next practical step is:

```text
Build an implementation checklist that maps every Markdown guide to actual NetBeans files.
```

Suggested next file:

```text
PRJ301_Implementation_Checklist.md
```
