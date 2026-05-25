---
title: PRJ301 Project Setup Guide
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat, Ant, Servlet/JSP
encoding: UTF-8
---

# PRJ301 Project Setup Guide

## 1. Current Focus

This guide sets up the base Java Web project for the team’s **Network Infrastructure Simulation Management System**.

Fixed environment:

| Component | Required Setup |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8, build 1.8.0_172 |
| Server | Apache Tomcat through NetBeans |
| Web Technology | Servlet + JSP |
| Servlet Namespace | `javax.servlet.*` |
| Build Tool | Ant, NetBeans default |
| Database | MySQL 8.0 recommended |

Important rule:

> Use **Tomcat 9.x**, not Tomcat 10+. Tomcat 10 uses `jakarta.*`, which is not compatible with this PRJ301 setup.

---

## 2. Computational Thinking Setup Analysis

### 2.1 Decomposition

We break the setup into smaller parts:

| Setup Area | Purpose |
|---|---|
| JDK setup | Ensures the project compiles with Java 8 |
| Tomcat setup | Runs the Java Web application locally |
| NetBeans Web Application project | Provides the correct Ant-based folder structure |
| Libraries | Adds MySQL JDBC and optional JSTL support |
| Database connection package | Centralizes connection logic |
| MVC folders/packages | Separates Controller, Model, DAO, and View |
| Test run page | Confirms the project deploys correctly |

### 2.2 Pattern Recognition

Most PRJ301 features will repeat the same pattern:

```text
JSP page → Servlet Controller → DAO → MySQL Database → Servlet → JSP page
```

Examples:

| Feature | Repeated Pattern |
|---|---|
| Login | Form JSP → LoginServlet → UserDAO → users table |
| Device CRUD | Device JSP → DeviceServlet → DeviceDAO → devices table |
| Maintenance Scheduling | Schedule JSP → MaintenanceServlet → MaintenanceDAO → maintenance table |
| Reports | Filter JSP → ReportServlet → ReportDAO → report result page |

### 2.3 Abstraction

At setup stage, focus only on what matters:

| Include Now | Ignore for Now |
|---|---|
| Project structure | Advanced simulation algorithm |
| Database connection | Final UI styling |
| Tomcat deployment | Complex charts |
| MVC package layout | User role permissions in detail |
| Basic JSP test page | Full report generation |

### 2.4 Algorithm Design

Project setup algorithm:

```text
Start
  ↓
Install/check JDK 8
  ↓
Register Tomcat 9 in NetBeans
  ↓
Create Java Web Application project using Ant
  ↓
Add required JAR libraries
  ↓
Create MVC packages
  ↓
Create database connection class
  ↓
Create index.jsp test page
  ↓
Run project using NetBeans Tomcat
  ↓
If browser opens successfully → setup complete
Else → check JDK, Tomcat, library, or deployment configuration
End
```

---

## 3. Recommended NetBeans Project Name

Use this project name:

```text
NetworkSimulationManagement
```

Suggested context path:

```text
/NetworkSimulationManagement
```

When running locally, the URL will usually be:

```text
http://localhost:8080/NetworkSimulationManagement/
```

---

## 4. Step-by-Step Setup in NetBeans 13

## 4.1 Check JDK 8

In NetBeans:

1. Open **Tools → Java Platforms**.
2. Confirm that **JDK 1.8** is listed.
3. If not listed:
   - Click **Add Platform**.
   - Select **Java Standard Edition**.
   - Browse to the JDK 8 installation folder.
   - Finish the wizard.

Common mistake:

> Do not use JDK 17 project features. The PRJ301 project must stay Java 8 compatible.

---

## 4.2 Register Apache Tomcat in NetBeans

Recommended version:

```text
Apache Tomcat 9.x
```

Steps:

1. Open **Services** tab.
2. Right-click **Servers**.
3. Choose **Add Server**.
4. Select **Apache Tomcat or TomEE**.
5. Click **Next**.
6. Browse to your Tomcat 9 installation folder.
7. Set username/password if NetBeans asks for manager credentials.
8. Finish.

Warning:

> Avoid Tomcat 10+. It requires `jakarta.servlet.*`, but this project must use `javax.servlet.*`.

---

## 4.3 Create the Web Application Project

In NetBeans:

1. Choose **File → New Project**.
2. Select **Java Web → Web Application**.
3. Click **Next**.
4. Project Name:

```text
NetworkSimulationManagement
```

5. Choose project location.
6. Make sure the project uses **Ant**, not Maven.
7. Server: choose your registered **Apache Tomcat 9**.
8. Java EE Version: choose a version compatible with `javax.*`, such as Java EE 7 or Java EE 8 if available.
9. Click **Finish**.

Expected NetBeans structure:

```text
NetworkSimulationManagement/
├── Web Pages/
│   ├── index.jsp
│   └── WEB-INF/
│       └── web.xml
├── Source Packages/
│   └── com.networksim...
├── Libraries/
├── Test Packages/
├── build.xml
└── nbproject/
```

---

## 5. Required Libraries

## 5.1 MySQL JDBC Driver

Use one of these JARs:

| Library | Compatible JAR |
|---|---|
| MySQL Connector/J 8 | `mysql-connector-java-8.0.33.jar` |
| MySQL Connector/J 5 | `mysql-connector-java-5.1.49.jar` |

Recommended:

```text
mysql-connector-java-8.0.33.jar
```

NetBeans steps:

1. Right-click **Libraries**.
2. Click **Add JAR/Folder**.
3. Select the MySQL Connector/J `.jar` file.
4. Click **Open**.

---

## 5.2 JSTL Library

Use:

```text
jstl-1.2.jar
```

NetBeans steps:

1. Right-click **Libraries**.
2. Click **Add JAR/Folder**.
3. Select `jstl-1.2.jar`.
4. Click **Open**.

Use JSTL later for cleaner JSP pages, especially for loops and conditions.

---

## 6. Recommended Package Structure

Create these packages under **Source Packages**:

```text
com.networksim.controller
com.networksim.dao
com.networksim.model
com.networksim.util
com.networksim.filter
```

Package purpose:

| Package | Purpose |
|---|---|
| `controller` | Servlets that receive requests and choose responses |
| `dao` | Database access classes |
| `model` | JavaBeans / entity classes |
| `util` | Shared helper classes such as DB connection |
| `filter` | Authentication or encoding filters later |

Suggested first files:

```text
com.networksim.util.DBContext.java
com.networksim.model.User.java
com.networksim.dao.UserDAO.java
com.networksim.controller.LoginServlet.java
```

---

## 7. Recommended Web Pages Structure

Under **Web Pages**, create folders like this:

```text
Web Pages/
├── index.jsp
├── login.jsp
├── dashboard.jsp
├── devices/
│   ├── list.jsp
│   ├── form.jsp
│   └── detail.jsp
├── topology/
│   └── simulation.jsp
├── maintenance/
│   ├── list.jsp
│   └── form.jsp
├── reports/
│   └── overview.jsp
├── assets/
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── main.js
│   └── images/
└── WEB-INF/
    └── web.xml
```

Rule:

> Keep reusable layouts, JSP fragments, or protected pages inside `WEB-INF` later if the team wants stricter access control.

---

## 8. Basic `web.xml` Template

Location:

```text
Web Pages/WEB-INF/web.xml
```

Template:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="3.1"
         xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd">

    <display-name>NetworkSimulationManagement</display-name>

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

</web-app>
```

Servlets can be mapped later using either:

1. `@WebServlet("/login")`, or
2. explicit servlet mapping in `web.xml`.

For PRJ301, using `@WebServlet` is usually simpler and still compatible with Java EE servlet projects.

---

## 9. Database Setup Plan

Recommended database name:

```sql
network_simulation_db
```

Initial core tables:

| Table | Purpose |
|---|---|
| `users` | Login and role management |
| `devices` | Router, switch, server, access point, etc. |
| `network_links` | Connections between devices |
| `bandwidth_logs` | Bandwidth monitoring records |
| `coverage_areas` | Signal coverage data |
| `maintenance_tasks` | Scheduled maintenance jobs |
| `alerts` | System warning messages |
| `reports` | Generated report metadata |

Database design should be finalized in the ERD before full coding starts.

---

## 10. Basic DB Connection Template

File location:

```text
Source Packages/com/networksim/util/DBContext.java
```

Java 8-compatible template:

```java
package com.networksim.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String URL = "jdbc:mysql://localhost:3306/network_simulation_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "your_password_here";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // CT - Abstraction: hide database connection details from Servlet and DAO classes.
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

If using MySQL Connector/J 5.1.x, use this driver instead:

```java
Class.forName("com.mysql.jdbc.Driver");
```

Common mistake:

> Do not hard-code the team’s final password in screenshots or reports. Use placeholder text when documenting.

---

## 11. Simple `index.jsp` Test Page

File location:

```text
Web Pages/index.jsp
```

Template:

```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Network Simulation Management</title>
</head>
<body>
    <h1>Network Infrastructure Simulation Management System</h1>
    <p>Project setup is working.</p>

    <ul>
        <li>Device Management</li>
        <li>Network Topology Simulation</li>
        <li>Bandwidth Monitoring</li>
        <li>Maintenance Scheduling</li>
        <li>Reports</li>
    </ul>
</body>
</html>
```

Run test:

1. Right-click project.
2. Select **Run**.
3. NetBeans starts Tomcat.
4. Browser opens the application.
5. Confirm the index page appears.

---

## 12. MVC Architecture Diagram

Draw this in draw.io, Lucidchart, or StarUML:

```text
+------------------+
|      Browser     |
| JSP / HTML / JS  |
+--------+---------+
         |
         | HTTP Request
         v
+------------------+
| Servlet Controller |
| LoginServlet       |
| DeviceServlet      |
| ReportServlet      |
+--------+---------+
         |
         | Calls DAO
         v
+------------------+
| DAO Layer        |
| UserDAO          |
| DeviceDAO        |
| MaintenanceDAO   |
+--------+---------+
         |
         | JDBC
         v
+------------------+
| MySQL Database   |
| users, devices,  |
| links, logs      |
+------------------+
```

Return flow:

```text
Database → DAO → Servlet → JSP → Browser
```

---

## 13. Team Task Assignment for Setup

| Member | Main Responsibility | Deliverables |
|---|---|---|
| Member 1 | NetBeans + Tomcat setup lead | Project created, Tomcat registered, app runs |
| Member 2 | Database setup lead | MySQL database created, initial schema draft prepared |
| Member 3 | MVC structure lead | Packages, folders, base JSP pages organized |
| Member 4 | Documentation + CT lead | Setup screenshots, CT explanation, diagram drafts |

Parallel workflow:

```text
Member 1 creates project
Member 2 prepares DB draft
Member 3 prepares MVC folder plan
Member 4 writes setup documentation
Then all members merge decisions into one consistent project structure
```

---

## 14. Common NetBeans 13 + JDK 8 Pitfalls

| Problem | Cause | Fix |
|---|---|---|
| `jakarta.servlet` error | Tomcat 10 or wrong imports | Use Tomcat 9 and `javax.servlet.*` |
| Project does not run | Tomcat not registered | Add Tomcat in Services → Servers |
| JDBC driver not found | Missing MySQL JAR | Add Connector/J to Libraries |
| Java syntax error | Java version too new | Use Java 8 syntax only |
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Wrong connector or missing JAR | Add `mysql-connector-java-8.0.33.jar` |
| Blank page after run | Wrong welcome file | Check `web.xml` and `index.jsp` |
| Build file missing | Wrong project type | Create Ant Web Application, not Maven |

---

## 15. Setup Completion Checklist

- [ ] JDK 8 added in NetBeans Java Platforms
- [ ] Apache Tomcat 9 registered in NetBeans Services tab
- [ ] Ant-based Java Web Application project created
- [ ] Project named `NetworkSimulationManagement`
- [ ] `index.jsp` runs successfully
- [ ] `WEB-INF/web.xml` exists
- [ ] MySQL Connector/J added to Libraries
- [ ] `jstl-1.2.jar` added to Libraries if needed
- [ ] MVC packages created under Source Packages
- [ ] Web folders created under Web Pages
- [ ] Initial MVC architecture diagram drawn
- [ ] Setup screenshots saved for report
- [ ] Team responsibilities assigned

---

## 16. Next Recommended Step

After setup, the team should create the **database ERD** before writing full CRUD code.

Recommended next document:

```text
PRJ301_ERD_and_Database_Design.md
```

Suggested next feature to implement after ERD:

```text
Login MVC: login.jsp → LoginServlet → UserDAO → users table → dashboard.jsp
```
