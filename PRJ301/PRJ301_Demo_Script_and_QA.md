---
title: PRJ301 Demo Script and Q&A
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Demo Script and Q&A

## 1. Current Focus

This document helps the team prepare for the final PRJ301 project presentation and demo.

The goal is:

```text
Explain clearly. Demo confidently. Answer teacher questions calmly.
```

Project environment:

| Component | Required Setup |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 through NetBeans |
| Backend | Servlet/JSP using `javax.servlet.*` |
| Build Tool | Ant |
| Database | MySQL 8.0 |
| Frontend | HTML5, CSS3, vanilla JavaScript |

Important presentation note:

> If the teacher asks why the project uses `javax.servlet.*`, explain that JDK 8 and Tomcat 9 use the old Java EE namespace. Tomcat 10 uses `jakarta.servlet.*`, so it is not used in this project.

---

## 2. Presentation Structure

Recommended order:

```text
1. Greeting and team introduction
2. Problem statement
3. Project objectives
4. Computational Thinking explanation
5. System architecture
6. Database design
7. Main module demo
8. Testing summary
9. Difficulties and solutions
10. Conclusion
11. Q&A
```

Suggested timing:

| Section | Suggested Focus |
|---|---|
| Introduction | Short and confident |
| CT analysis | Important because it is graded |
| Architecture + ERD | Show understanding, not just screenshots |
| Demo | Spend most time here |
| Testing | Show proof the system works |
| Q&A | Answer directly and calmly |

---

## 3. Speaker Assignment

| Speaker | Responsibility | Suggested Sections |
|---|---|---|
| Member 1 | Project overview + login/device demo | Intro, problem, login, device CRUD |
| Member 2 | Database + topology | ERD, topology simulation |
| Member 3 | Monitoring + maintenance | Bandwidth, coverage, maintenance, alerts |
| Member 4 | CT + report + testing | CT analysis, report generation, testing, conclusion |

Tip:

> Each member should be ready to answer at least one technical question, even if they are mainly responsible for documentation or UI.

---

## 4. Opening Script

Use natural wording like this:

```text
Good morning/afternoon teacher. We are Group [number/name]. Today we will present our PRJ301 project: Network Infrastructure Simulation Management System.

Our project is a Java Web application built with NetBeans 13, JDK 8, Apache Tomcat 9, Servlet, JSP, and MySQL. The purpose of the system is to simulate basic network infrastructure management, including device management, topology simulation, bandwidth and coverage monitoring, maintenance scheduling, alerts, and report generation.

We also applied Computational Thinking throughout the project, especially decomposition, pattern recognition, abstraction, and algorithm design.
```

Checklist:

- [ ] Say project name
- [ ] Say technology stack
- [ ] Say main purpose
- [ ] Mention CT clearly

---

## 5. Problem Statement Script

```text
In real organizations, network administrators need to manage many devices such as routers, switches, access points, and servers. They also need to monitor network performance, check coverage, schedule maintenance, and respond to alerts.

If this information is managed manually or separately, it becomes difficult to understand the overall network condition. Our project solves this problem by creating a centralized web-based simulation system for network infrastructure management.
```

Short version:

```text
The main problem is that network information can be scattered. Our system centralizes device, topology, monitoring, maintenance, alert, and report data in one Java Web application.
```

---

## 6. Project Objectives Script

```text
The objectives of our system are:

First, to manage network devices with CRUD functions.
Second, to simulate network topology by showing devices as nodes and links as connections.
Third, to record simulated bandwidth and coverage data.
Fourth, to schedule maintenance tasks and generate alerts.
Finally, to generate summary reports for administrators.
```

---

## 7. Computational Thinking Explanation Script

This is very important.

## 7.1 Decomposition

```text
We applied decomposition by breaking the large network management problem into smaller modules. These modules include authentication, device management, topology simulation, bandwidth monitoring, coverage monitoring, maintenance scheduling, alerts, and reports.

This made the project easier to divide among team members and easier to implement step by step.
```

## 7.2 Pattern Recognition

```text
We applied pattern recognition by identifying repeated structures in the system. For example, many modules follow the same MVC pattern: JSP sends a request, Servlet handles the logic, DAO accesses the database, and JSP displays the result.

CRUD operations are also repeated in Device Management and Maintenance Scheduling.
```

## 7.3 Abstraction

```text
We applied abstraction by focusing only on important data for the simulation. For example, in topology simulation, we represent network devices as nodes and network links as edges. We do not simulate real routing protocols or real packet transmission because that is outside the scope of this Java Web project.
```

## 7.4 Algorithm Design

```text
We applied algorithm design by planning each feature as a clear step-by-step flow before coding. For example, in login: the user submits credentials, the servlet validates them using UserDAO, the system creates a session if valid, and then redirects to the dashboard.
```

Quick CT answer:

```text
Decomposition helped us split the system into modules. Pattern recognition helped us reuse MVC and CRUD patterns. Abstraction helped us simplify real network concepts. Algorithm design helped us define step-by-step logic before implementation.
```

---

## 8. Architecture Explanation Script

```text
Our project follows the MVC architecture.

The View layer is JSP pages such as login.jsp, device list JSP, topology JSP, and report dashboard JSP.

The Controller layer is Servlet classes such as LoginServlet, DeviceServlet, TopologyServlet, MaintenanceServlet, and ReportServlet.

The Model layer contains JavaBean classes such as User, Device, NetworkLink, MaintenanceTask, Alert, and ReportSummary.

The DAO layer handles database operations using JDBC and PreparedStatement.

The database layer is MySQL.
```

Simple architecture flow:

```text
Browser → JSP → Servlet → DAO → MySQL → DAO → Servlet → JSP → Browser
```

If teacher asks why MVC:

```text
MVC separates responsibilities. JSP handles display, Servlet handles request control, DAO handles database access, and model classes store data. This makes the system easier to maintain and debug.
```

---

## 9. Database Design Explanation Script

```text
Our database uses relational tables. The main tables are users, roles, devices, network_links, bandwidth_logs, coverage_areas, maintenance_tasks, and alerts.

The devices table is central because many modules depend on device_id. For example, bandwidth logs, coverage records, maintenance tasks, alerts, and network links all connect to devices.

Foreign keys help maintain data consistency and avoid duplicated device information.
```

Important relationship explanation:

```text
One device can have many bandwidth logs, many coverage records, many maintenance tasks, and many alerts. Network links connect two devices using source_device_id and target_device_id.
```

---

## 10. Demo Script

## 10.1 Before Demo Checklist

Before presenting:

- [ ] Start MySQL server
- [ ] Open NetBeans 13
- [ ] Confirm JDK 8 is selected
- [ ] Confirm Tomcat 9 is registered
- [ ] Clean and build project if needed
- [ ] Run project once before presentation
- [ ] Prepare sample account
- [ ] Prepare sample devices
- [ ] Prepare sample monitoring data
- [ ] Keep SQL backup ready
- [ ] Close unnecessary browser tabs

---

## 10.2 Demo Step 1: Show Project Setup

Say:

```text
First, this is our NetBeans Java Web project. We use JDK 8 and Apache Tomcat 9. The project follows the standard NetBeans Ant structure, with Web Pages for JSP files and Source Packages for Java classes.
```

Show:

- NetBeans project tree
- `Source Packages/com.networksim`
- `Web Pages`
- Libraries with MySQL connector

Do not spend too long here.

---

## 10.3 Demo Step 2: Login

Action:

```text
Open login page → enter valid email/password → click Login
```

Say:

```text
This is the login module. The user enters credentials in login.jsp. LoginServlet receives the request and calls UserDAO to check the users table. If the account is valid, the system creates a session and redirects to the dashboard.
```

Possible teacher question:

```text
Where is the login checked?
```

Answer:

```text
The login is checked in UserDAO through a SQL query. LoginServlet controls the request and session creation.
```

---

## 10.4 Demo Step 3: Dashboard

Action:

```text
Show dashboard links
```

Say:

```text
After login, the dashboard shows the main modules: Device Management, Topology Simulation, Monitoring, Maintenance, Alerts, and Reports.
```

---

## 10.5 Demo Step 4: Device CRUD

Action:

```text
Open Device Management → Add device → Edit device → View list
```

Say:

```text
Device Management is the core module because other modules depend on devices. It supports CRUD operations: create, read, update, and delete. Each device has information such as name, type, IP address, location, and status.
```

Possible teacher question:

```text
Why is Device Management implemented before topology and monitoring?
```

Answer:

```text
Because topology, monitoring, maintenance, and alerts all reference device_id. Without devices, those modules have no base data to work with.
```

---

## 10.6 Demo Step 5: Topology Simulation

Action:

```text
Open Topology → show devices as nodes → show links as connections
```

Say:

```text
The topology module simulates a network diagram. We use abstraction here: devices are represented as nodes, and network links are represented as edges. This allows us to show the structure of the network without simulating real packet routing.
```

Possible teacher question:

```text
What CT pillar is most important in topology?
```

Answer:

```text
Abstraction, because we simplify a real network into nodes and edges. Pattern recognition is also used because this is similar to graph representation.
```

---

## 10.7 Demo Step 6: Bandwidth and Coverage Monitoring

Action:

```text
Open Monitoring → add bandwidth data → add coverage data → return dashboard
```

Say:

```text
The monitoring module stores simulated performance data. Bandwidth records include download speed, upload speed, latency, and packet loss. Coverage records include signal strength and coverage percentage.
```

Possible teacher question:

```text
Is this real monitoring?
```

Answer:

```text
No, this is simulated monitoring for educational purposes. The system stores and displays manually entered performance data instead of connecting to real routers or packet monitoring tools.
```

---

## 10.8 Demo Step 7: Maintenance Scheduling

Action:

```text
Open Maintenance → add HIGH priority task
```

Say:

```text
The maintenance module allows users to schedule work for a device. Each task has a title, description, scheduled date, priority, and status.
```

Then say:

```text
When a task has HIGH priority, the system automatically creates an alert. This is an example of algorithm design because we define a rule: if priority is HIGH, create a warning alert.
```

Possible teacher question:

```text
Where is the alert created?
```

Answer:

```text
The alert is created in MaintenanceServlet after the maintenance task is inserted. The servlet calls AlertDAO to save the alert into the alerts table.
```

---

## 10.9 Demo Step 8: Alerts

Action:

```text
Open Alerts → show new alert → mark as read
```

Say:

```text
The alerts module displays system messages. Users can see the severity and mark alerts as read. This helps administrators know which issues still need attention.
```

Possible teacher question:

```text
Why use is_read?
```

Answer:

```text
The is_read field helps separate new alerts from already reviewed alerts. This is useful for tracking whether an administrator has handled a warning.
```

---

## 10.10 Demo Step 9: Report Generation

Action:

```text
Open Reports → show summary → click Print Report
```

Say:

```text
The report module summarizes data from multiple modules. It shows total devices, device status counts, network links, bandwidth averages, coverage averages, maintenance status counts, and alert counts.

This module uses SQL aggregate functions such as COUNT and AVG.
```

Possible teacher question:

```text
Why is report generation implemented last?
```

Answer:

```text
Because reports depend on data from all other modules. If device, monitoring, maintenance, and alert data do not exist yet, the report has nothing useful to summarize.
```

---

## 10.11 Demo Step 10: Logout

Action:

```text
Click Logout
```

Say:

```text
Finally, the logout function removes the user session and returns the user to the login page.
```

---

## 11. Common Teacher Questions and Answers

## 11.1 Technology Questions

### Q1. Why did you use Servlet and JSP?

```text
Because PRJ301 focuses on Java Web development. Servlet and JSP are suitable for learning MVC, request handling, session management, and database interaction using Java EE technologies.
```

### Q2. Why not use Spring Boot?

```text
Our project scope and environment are based on NetBeans 13, JDK 8, Tomcat, Ant, Servlet, and JSP. Spring Boot would add complexity and is outside the fixed project environment.
```

### Q3. Why use Tomcat 9 instead of Tomcat 10?

```text
Tomcat 9 supports the javax.servlet namespace, which matches JDK 8 and traditional Java EE Servlet/JSP projects. Tomcat 10 uses jakarta.servlet, so it is not compatible with our current code.
```

### Q4. Why use MySQL?

```text
MySQL is suitable for storing structured relational data such as users, devices, links, monitoring records, maintenance tasks, and alerts. It also supports foreign keys for data consistency.
```

---

## 11.2 MVC Questions

### Q5. What is MVC in your project?

```text
MVC separates the system into Model, View, and Controller. JSP pages are the View, Servlets are the Controller, JavaBeans are the Model, and DAO classes handle database access.
```

### Q6. Why should JSP not directly query the database?

```text
Because JSP should focus on presentation. Database logic belongs in DAO classes. This separation makes the code cleaner, easier to test, and easier to maintain.
```

### Q7. What does DAO mean?

```text
DAO means Data Access Object. It is responsible for communicating with the database, such as running SELECT, INSERT, UPDATE, and DELETE queries.
```

---

## 11.3 Database Questions

### Q8. What is the most important table in your database?

```text
The devices table is one of the most important tables because many modules depend on device_id, including topology, bandwidth, coverage, maintenance, and alerts.
```

### Q9. Why use foreign keys?

```text
Foreign keys keep related data consistent. For example, a bandwidth record should belong to an existing device. Foreign keys help prevent invalid records.
```

### Q10. How do you prevent SQL injection?

```text
We use PreparedStatement for SQL queries with user input. PreparedStatement separates SQL structure from parameter values, which helps prevent SQL injection.
```

---

## 11.4 Computational Thinking Questions

### Q11. Where did you apply decomposition?

```text
We applied decomposition by dividing the system into modules: authentication, device management, topology, monitoring, maintenance, alerts, and reports.
```

### Q12. Where did you apply pattern recognition?

```text
We recognized repeated MVC and CRUD patterns. Many modules follow the same flow: JSP form, Servlet controller, DAO database access, and JSP result page.
```

### Q13. Where did you apply abstraction?

```text
We applied abstraction in topology simulation by representing real network devices as nodes and connections as edges. We also abstracted monitoring data into simple values like speed, latency, signal strength, and coverage percentage.
```

### Q14. Where did you apply algorithm design?

```text
We designed step-by-step logic for each module before coding. For example, in maintenance alerts: if a user creates a HIGH priority maintenance task, the system inserts the task and then automatically creates a warning alert.
```

---

## 11.5 Module-Specific Questions

### Q15. Why is topology a graph?

```text
Because a network contains devices and connections. In graph terms, devices are nodes and links are edges. This makes the topology easier to represent and display.
```

### Q16. Is bandwidth monitoring real-time?

```text
No. It is simulated. Users enter test values manually, and the system stores them for display and reporting.
```

### Q17. How are alerts generated?

```text
Alerts can be generated from system logic. For example, when a HIGH priority maintenance task is created, the system creates a warning alert. When a task is completed, the system can create an information alert.
```

### Q18. What does the report module do?

```text
The report module summarizes data from different tables. It shows totals and averages such as total devices, network links, bandwidth averages, coverage averages, maintenance statuses, and alert counts.
```

---

## 12. If Something Breaks During Demo

Stay calm. Use these backup lines.

## 12.1 If Login Fails

```text
It seems the sample account data may not be available in the database. We can explain the login flow from the code: login.jsp submits to LoginServlet, which checks UserDAO and creates a session if valid.
```

## 12.2 If Database Connection Fails

```text
This is likely a local MySQL connection issue. The application uses DBContext.java for database connection and MySQL Connector/J. In our screenshots and test cases, the module worked with the configured database.
```

## 12.3 If Tomcat Fails

```text
This may be a local server startup issue. The project is configured for Tomcat 9 because it supports javax.servlet. We can still explain the project structure and show screenshots from successful tests.
```

## 12.4 If A Page Shows 404

```text
This usually means the URL mapping or link path needs checking. In Servlet/JSP projects, each servlet is mapped using @WebServlet or web.xml.
```

Important:

> Do not panic or blame teammates. Explain the likely cause and show screenshots/code if needed.

---

## 13. Short Answers for Fast Q&A

| Question | Short Answer |
|---|---|
| Main architecture? | MVC with JSP, Servlet, DAO, JavaBean, MySQL |
| Main CT pillar? | All four: decomposition, pattern recognition, abstraction, algorithm design |
| Why devices first? | Other modules depend on `device_id` |
| Why Tomcat 9? | Supports `javax.servlet.*` with JDK 8 |
| Why not Tomcat 10? | Tomcat 10 uses `jakarta.servlet.*` |
| What is DAO? | Class responsible for database access |
| What is topology abstraction? | Devices = nodes, links = edges |
| Is monitoring real? | No, simulated/manual data for education |
| How alerts work? | Stored messages with severity and read/unread status |
| What reports show? | Counts and averages from all modules |

---

## 14. Final Rehearsal Checklist

- [ ] Every member knows their speaking part
- [ ] Every member can explain one CT pillar
- [ ] Every member can explain one module
- [ ] Demo account works
- [ ] Sample data is inserted
- [ ] Tomcat starts successfully
- [ ] MySQL is running
- [ ] Screenshots are ready as backup
- [ ] Final report is exported if required
- [ ] Presentation slides are ready
- [ ] Demo script practiced at least once

---

## 15. Confidence Tips

- Speak slowly.
- Do not memorize word by word; understand the idea.
- If you do not know, explain what you do know clearly.
- Use the MVC flow when answering technical questions.
- Use CT pillars when answering design questions.
- Keep the demo simple and avoid unnecessary typing.
- Prepare screenshots as backup.

Final mindset:

```text
We are not presenting a perfect enterprise network system.
We are presenting a clear Java Web student project that applies MVC and Computational Thinking correctly.
```
