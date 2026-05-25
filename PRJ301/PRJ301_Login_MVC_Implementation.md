---
title: PRJ301 Login MVC Implementation
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---
# PRJ301 Login MVC Implementation

## 1. Current Focus

This document guides the team through implementing the first full MVC feature:

```text
Login MVC Module
```

The login module proves that the project can connect these layers successfully:

```text
JSP View → Servlet Controller → DAO → MySQL Database → Session → Dashboard JSP
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

Important:

> Do not use `jakarta.servlet.*`. Use `javax.servlet.*` only.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break login into small parts:

| Part | Responsibility |
|---|---|
| `login.jsp` | Displays login form |
| `LoginServlet.java` | Receives email/password and controls login logic |
| `UserDAO.java` | Queries the `users` table |
| `User.java` | Stores user information as a JavaBean |
| `DBContext.java` | Creates database connection |
| `dashboard.jsp` | Shows page after successful login |
| `LogoutServlet.java` | Removes session and logs user out |
| `HttpSession` | Remembers logged-in user |

Why decomposition matters:

> Each file has one clear job, so the team can debug problems faster.

---

## 2.2 Pattern Recognition

Login follows the same pattern that later modules will reuse:

```text
Form JSP → Servlet → DAO → Database → Servlet → Result JSP
```

Later examples:

| Feature | Same MVC Pattern |
|---|---|
| Device CRUD | device form → DeviceServlet → DeviceDAO → devices table |
| Maintenance | maintenance form → MaintenanceServlet → MaintenanceDAO → maintenance_tasks table |
| Reports | report filter → ReportServlet → ReportDAO → reports table |

Once login works, the team has a working template for the rest of the project.

---

## 2.3 Abstraction

For login, focus only on necessary details:

| Include Now | Ignore for Now |
|---|---|
| Email input | Password reset |
| Password input | Email verification |
| User role | OAuth / Google login |
| User status | Two-factor authentication |
| Session storage | Remember-me cookies |
| Redirect to dashboard | Advanced permission matrix |

This keeps the first implementation realistic for PRJ301.

---

## 2.4 Algorithm Design

Login algorithm:

```text
Start
  ↓
User opens login.jsp
  ↓
User enters email and password
  ↓
Submit form to LoginServlet using POST
  ↓
LoginServlet validates empty fields
  ↓
LoginServlet calls UserDAO.checkLogin(email, password)
  ↓
UserDAO queries users table
  ↓
If user exists and status is ACTIVE
      Create session
      Store user object in session
      Redirect to dashboard.jsp
  Else
      Send error message back to login.jsp
End
```

Logout algorithm:

```text
Start
  ↓
User clicks Logout
  ↓
Request goes to LogoutServlet
  ↓
Servlet invalidates session
  ↓
Redirect to login.jsp
End
```

---

## 3. Login Flowchart

Draw this flowchart in draw.io, Lucidchart, or StarUML:

```text
+-------+
| Start |
+---+---+
    |
    v
+----------------+
| Open login.jsp |
+-------+--------+
        |
        v
+--------------------------+
| Enter email and password |
+------------+-------------+
             |
             v
+--------------------------+
| Submit to LoginServlet   |
+------------+-------------+
             |
             v
+--------------------------+
| Are fields empty?        |
+------------+-------------+
     Yes     |      No
     v       |      v
+---------+  |  +-----------------------+
| Show    |  |  | Call UserDAO          |
| error   |  |  | checkLogin()          |
+---------+  |  +-----------+-----------+
             |              |
             v              v
        +--------------------------+
        | Is login valid and active? |
        +------------+-------------+
             No      |      Yes
             v       |      v
       +----------+  |  +----------------+
       | Show     |  |  | Create session |
       | error    |  |  +-------+--------+
       +----------+  |          |
                     v          v
                +-------------------+
                | Go to dashboard   |
                +---------+---------+
                          |
                          v
                      +---+---+
                      | End   |
                      +-------+
```

---

## 4. Login Sequence Diagram

Draw this sequence diagram:

```text
User → login.jsp: enter email/password
login.jsp → LoginServlet: POST /login
LoginServlet → UserDAO: checkLogin(email, password)
UserDAO → DBContext: getConnection()
DBContext → MySQL: create JDBC connection
UserDAO → MySQL: SELECT user by email/password/status
MySQL → UserDAO: return user row
UserDAO → LoginServlet: return User object or null
LoginServlet → HttpSession: setAttribute("account", user)
LoginServlet → dashboard.jsp: redirect if success
LoginServlet → login.jsp: forward with error if failed
```

---

## 5. Files to Create in NetBeans

## 5.1 Source Packages

Create these files:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   └── User.java
    ├── dao/
    │   └── UserDAO.java
    ├── util/
    │   └── DBContext.java
    └── controller/
        ├── LoginServlet.java
        └── LogoutServlet.java
```

NetBeans steps:

1. Right-click **Source Packages**.
2. Choose **New → Java Package**.
3. Create:
   - `com.networksim.model`
   - `com.networksim.dao`
   - `com.networksim.util`
   - `com.networksim.controller`
4. Right-click the package.
5. Choose **New → Java Class** or **New → Servlet**.

---

## 5.2 Web Pages

Create these files:

```text
Web Pages/
├── login.jsp
├── dashboard.jsp
└── WEB-INF/
    └── web.xml
```

NetBeans steps:

1. Right-click **Web Pages**.
2. Choose **New → JSP**.
3. Create `login.jsp`.
4. Create `dashboard.jsp`.

---

## 6. Database Table Used

This login module uses the `users` table from the ERD document.

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'VIEWER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

For early testing, this guide uses plain text comparison with the `password_hash` column.

Important security note:

> For the final project, replace plain text comparison with password hashing. The database column is already named `password_hash` so the team can improve security later without changing the ERD.

Sample user:

```sql
INSERT INTO users (full_name, email, password_hash, role, status)
VALUES ('System Administrator', 'admin@networksim.local', '123456', 'ADMIN', 'ACTIVE');
```

Test login:

```text
Email: admin@networksim.local
Password: 123456
```

---

## 7. Code Template: `DBContext.java`

Location:

```text
Source Packages/com/networksim/util/DBContext.java
```

Code:

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
        // CT - Abstraction: hide JDBC details so DAO classes only request a connection.
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

If using MySQL Connector/J 5.1.x, change the driver line to:

```java
Class.forName("com.mysql.jdbc.Driver");
```

---

## 8. Code Template: `User.java`

Location:

```text
Source Packages/com/networksim/model/User.java
```

Code:

```java
package com.networksim.model;

import java.util.Date;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role;
    private String status;
    private Date createdAt;

    public User() {
    }

    public User(int userId, String fullName, String email, String passwordHash,
            String role, String status, Date createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
```

---

## 9. Code Template: `UserDAO.java`

Location:

```text
Source Packages/com/networksim/dao/UserDAO.java
```

Code:

```java
package com.networksim.dao;

import com.networksim.model.User;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User checkLogin(String email, String password) throws Exception {
        // CT - Pattern Recognition: login is a search pattern using email + password + status.
        String sql = "SELECT user_id, full_name, email, password_hash, role, status, created_at "
                + "FROM users "
                + "WHERE email = ? AND password_hash = ? AND status = 'ACTIVE'";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return null;
    }
}
```

Why `PreparedStatement` is used:

> It protects against SQL injection and safely sends user input to MySQL.

---

## 10. Code Template: `LoginServlet.java`

Location:

```text
Source Packages/com/networksim/controller/LoginServlet.java
```

Code:

```java
package com.networksim.controller;

import com.networksim.dao.UserDAO;
import com.networksim.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CT - Decomposition: get input, validate, call DAO, decide response.
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.checkLogin(email.trim(), password.trim());

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("account", user);
                response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid email, password, or inactive account.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Login failed because the server cannot connect to the database.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
```

---

## 11. Code Template: `LogoutServlet.java`

Location:

```text
Source Packages/com/networksim/controller/LogoutServlet.java
```

Code:

```java
package com.networksim.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect("login");
    }
}
```

---

## 12. Code Template: `login.jsp`

Location:

```text
Web Pages/login.jsp
```

Code:

```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Network Simulation Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .login-container {
            width: 360px;
            margin: 100px auto;
            background-color: #ffffff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            margin-top: 18px;
            padding: 10px;
            background-color: #1f6feb;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .error {
            margin-top: 12px;
            color: #b00020;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Network Simulation Login</h2>

        <form action="login" method="post">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </div>
</body>
</html>
```

Note:

> This JSP uses simple scriptlet output for beginner clarity. Later, the team can improve it using JSTL with `jstl-1.2.jar`.

---

## 13. Code Template: `dashboard.jsp`

Location:

```text
Web Pages/dashboard.jsp
```

Code:

```jsp
<%@page import="com.networksim.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User account = (User) session.getAttribute("account");
    if (account == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Network Simulation Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f4f6f8;
        }
        .header {
            background-color: #0d1117;
            color: white;
            padding: 16px 24px;
        }
        .content {
            padding: 24px;
        }
        .card {
            background-color: white;
            padding: 18px;
            margin-bottom: 16px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
        }
        a {
            color: #1f6feb;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>Network Infrastructure Simulation Management System</h2>
        <p>Welcome, <%= account.getFullName() %> | Role: <%= account.getRole() %> | <a href="logout">Logout</a></p>
    </div>

    <div class="content">
        <div class="card">
            <h3>Dashboard</h3>
            <p>Login successful. The MVC connection is working.</p>
        </div>

        <div class="card">
            <h3>Available Modules</h3>
            <ul>
                <li>Device & Node Management</li>
                <li>Network Topology Simulation</li>
                <li>Bandwidth & Coverage Monitoring</li>
                <li>Maintenance Scheduling</li>
                <li>Reports</li>
            </ul>
        </div>
    </div>
</body>
</html>
```

---

## 14. Optional `web.xml` Configuration

If using `@WebServlet`, you do not need manual servlet mappings in `web.xml`.

Basic `web.xml` location:

```text
Web Pages/WEB-INF/web.xml
```

Code:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="3.1"
         xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd">

    <display-name>NetworkSimulationManagement</display-name>

    <welcome-file-list>
        <welcome-file>login.jsp</welcome-file>
    </welcome-file-list>

</web-app>
```

If the teacher requires `web.xml` servlet mapping, remove `@WebServlet` annotations and add mappings manually.

Example:

```xml
<servlet>
    <servlet-name>LoginServlet</servlet-name>
    <servlet-class>com.networksim.controller.LoginServlet</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>LoginServlet</servlet-name>
    <url-pattern>/login</url-pattern>
</servlet-mapping>
```

---

## 15. How to Run in NetBeans

1. Make sure MySQL is running.
2. Create database and `users` table.
3. Insert the sample admin user.
4. Add `mysql-connector-java-8.0.33.jar` to project Libraries.
5. Check `DBContext.java` username and password.
6. Right-click the project.
7. Select **Clean and Build**.
8. Right-click the project again.
9. Select **Run**.
10. Open:

```text
http://localhost:8080/NetworkSimulationManagement/login
```

Login with:

```text
Email: admin@networksim.local
Password: 123456
```

Expected result:

```text
Redirect to dashboard.jsp and show the user's full name and role.
```

---

## 16. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | MySQL JAR missing | Add `mysql-connector-java-8.0.33.jar` to Libraries |
| `Access denied for user root` | Wrong DB password | Update `DBContext.java` password |
| HTTP 404 on `/login` | Servlet mapping issue | Check `@WebServlet("/login")` or `web.xml` |
| Compile error with `jakarta.servlet` | Wrong import or Tomcat 10 tutorial copied | Use `javax.servlet.*` |
| Login always fails | Sample user not inserted or password mismatch | Check data in `users` table |
| Dashboard opens without login | Missing session check | Add account check at top of `dashboard.jsp` |
| Browser shows old page | NetBeans did not redeploy | Clean and Build, then Run again |
| SQL syntax error | Database table not created correctly | Re-run ERD SQL script carefully |

---

## 17. Security Improvement for Final Version

For early testing, plain password comparison is acceptable only because the team is learning MVC.

For the final report and final demo, explain this improvement:

```text
Instead of storing plain text passwords, the system should store hashed passwords.
When users log in, the entered password is hashed and compared with password_hash.
```

Possible Java 8-compatible options:

| Option | Difficulty | Note |
|---|---|---|
| SHA-256 with salt | Medium | Can be implemented manually with Java 8 |
| BCrypt library | Better | Requires adding a compatible JAR |

For PRJ301 simplicity, the team can mention password hashing as a security enhancement if there is not enough time to implement it fully.

---

## 18. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Servlet controller lead | `LoginServlet.java`, `LogoutServlet.java` |
| Member 2 | Database/DAO lead | `users` table, sample data, `UserDAO.java` |
| Member 3 | Frontend JSP lead | `login.jsp`, `dashboard.jsp`, basic CSS |
| Member 4 | Documentation/testing lead | Flowchart, sequence diagram, test cases, screenshots |

Parallel workflow:

```text
Member 2 prepares DB and DAO
Member 3 prepares JSP pages
Member 1 connects Servlet logic
Member 4 tests and documents the full flow
```

---

## 19. Login Test Cases

| Test Case | Input | Expected Result |
|---|---|---|
| Valid login | Correct email + password | Redirect to dashboard |
| Empty email | Blank email | Show required field error |
| Empty password | Blank password | Show required field error |
| Wrong password | Correct email + wrong password | Show invalid login error |
| Inactive account | User status `INACTIVE` | Show invalid login error |
| Logout | Click logout | Session removed and redirect to login |
| Direct dashboard access | Open `dashboard.jsp` without login | Redirect to login |

---

## 20. Login Completion Checklist

- [ ] `users` table created
- [ ] Sample admin user inserted
- [ ] MySQL Connector/J added to Libraries
- [ ] `DBContext.java` connects successfully
- [ ] `User.java` created
- [ ] `UserDAO.java` created
- [ ] `LoginServlet.java` created
- [ ] `LogoutServlet.java` created
- [ ] `login.jsp` created
- [ ] `dashboard.jsp` created
- [ ] `/login` URL works
- [ ] Valid login redirects to dashboard
- [ ] Invalid login shows error
- [ ] Logout works
- [ ] Dashboard blocks unauthenticated access
- [ ] Flowchart completed
- [ ] Sequence diagram completed
- [ ] Screenshots saved for report

---

## 21. Next Recommended Feature

After login works, implement:

```text
Device & Node Management CRUD
```

Reason:

> Devices are the center of the network simulation system. Bandwidth logs, coverage areas, maintenance tasks, alerts, and topology links all depend on devices.

Recommended next document:

```text
PRJ301_Device_CRUD_Implementation.md
```
