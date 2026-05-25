---
title: PRJ301 Maintenance Scheduling and Alerts
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Maintenance Scheduling and Alerts

## 1. Current Focus

This document guides the team through implementing:

```text
Maintenance Scheduling & Alerts
```

This module helps the system manage planned maintenance tasks and warning messages for network devices.

Simple idea:

```text
Maintenance = planned work on a device.
Alert = message that tells users something needs attention.
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
| Frontend | HTML5, CSS3, vanilla JavaScript if needed |

Important:

> Use `javax.servlet.*`, not `jakarta.servlet.*`. Do not use Spring Boot, Maven, Docker, or Java features newer than Java 8.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break the feature into smaller parts:

| Part | Responsibility | Main Files |
|---|---|---|
| Maintenance model | Store one maintenance task | `MaintenanceTask.java` |
| Alert model | Store one alert message | `Alert.java` |
| Maintenance DAO | Read/write maintenance tasks | `MaintenanceDAO.java` |
| Alert DAO | Read/write alerts | `AlertDAO.java` |
| Maintenance controller | Route list/create/update/delete actions | `MaintenanceServlet.java` |
| Alert controller | Show alerts and mark as read | `AlertServlet.java` |
| Maintenance list page | Display scheduled tasks | `maintenance/list.jsp` |
| Maintenance form page | Add/edit task | `maintenance/form.jsp` |
| Alert list page | Display alert messages | `alerts/list.jsp` |

Why this matters:

> Maintenance and alerts sound like one big module, but they are easier to build as two connected mini-features.

---

## 2.2 Pattern Recognition

Maintenance uses the same CRUD pattern as Device Management:

```text
JSP form → Servlet action → DAO method → MySQL table → JSP result
```

Alerts use a simple list/update pattern:

```text
Generate alert → Store in alerts table → Show alert list → Mark as read
```

Repeated patterns:

| Pattern | Used In |
|---|---|
| `device_id` foreign key | Maintenance tasks and alerts both connect to devices |
| Status field | Maintenance status and alert read/unread status |
| Priority/severity | Maintenance priority and alert severity |
| Date tracking | Scheduled date and alert created date |
| DAO list method | `getAllTasks()`, `getAllAlerts()` |

---

## 2.3 Abstraction

For the PRJ301 version, focus on simulated management logic.

| Include Now | Ignore for Now |
|---|---|
| Add/edit/delete maintenance task | Real enterprise ticketing system |
| Assign task to technician | Advanced staff workload balancing |
| Maintenance status | Automatic repair workflow |
| Alert list | Push notification service |
| Mark alert as read | Email/SMS integration |
| Simple auto-alert when task is HIGH priority | Complex monitoring engine |

This keeps the project realistic for a 4-person student team.

---

## 2.4 Algorithm Design

Maintenance list algorithm:

```text
Start
  ↓
User opens /maintenance
  ↓
MaintenanceServlet loads all maintenance tasks
  ↓
DAO joins maintenance_tasks with devices and users
  ↓
Servlet forwards task list to maintenance/list.jsp
  ↓
JSP displays table
End
```

Create maintenance task algorithm:

```text
Start
  ↓
User opens create form
  ↓
Servlet loads devices and technicians
  ↓
User enters task details
  ↓
Submit to /maintenance?action=insert
  ↓
Servlet validates required fields
  ↓
DAO inserts maintenance task
  ↓
If priority is HIGH, create alert
  ↓
Redirect to /maintenance
End
```

Update maintenance status algorithm:

```text
Start
  ↓
User edits task
  ↓
Servlet loads existing task
  ↓
User changes status or details
  ↓
Submit to /maintenance?action=update
  ↓
DAO updates task
  ↓
If status is COMPLETED, create INFO alert
  ↓
Redirect to /maintenance
End
```

Alert list algorithm:

```text
Start
  ↓
User opens /alerts
  ↓
AlertServlet loads all alerts
  ↓
JSP displays alert list
  ↓
User clicks Mark as Read
  ↓
Servlet updates is_read = true
  ↓
Redirect to /alerts
End
```

---

## 3. Maintenance Flowchart

Draw this in draw.io, Lucidchart, or StarUML:

```text
+-------+
| Start |
+---+---+
    |
    v
+-------------------------+
| User opens /maintenance |
+------------+------------+
             |
             v
+-------------------------+
| MaintenanceServlet      |
| checks action parameter |
+------------+------------+
             |
             v
+-------------------------------------+
| list / create / insert / edit /     |
| update / delete                     |
+------+----------+----------+--------+
       |          |          |
       v          v          v
    List       Create      Update/Delete
       |          |          |
       v          v          v
+-----------+ +----------+ +----------------+
| Load all  | | Show form| | Validate input |
| tasks     | | data     | +-------+--------+
+-----+-----+ +----+-----+         |
      |            |               v
      v            v        +---------------+
+-----------+  +---------+  | Save changes  |
| list.jsp  |  | form.jsp|  +-------+-------+
+-----+-----+  +---------+          |
      |                             v
      v                      +--------------+
+-----+                      | Create alert |
| End |                      | if needed    |
+-----+                      +------+-------+
                                    |
                                    v
                              +-----------+
                              | Redirect  |
                              +-----------+
```

---

## 4. Alert Flowchart

```text
+-------+
| Start |
+---+---+
    |
    v
+------------------+
| User opens alerts|
+--------+---------+
         |
         v
+------------------+
| AlertServlet     |
| checks action    |
+--------+---------+
         |
         v
+-------------------------+
| list or markAsRead      |
+----------+--------------+
           |
      +----+----+
      |         |
      v         v
+----------+ +----------------+
| Load all | | Update is_read |
| alerts   | | to true        |
+----+-----+ +-------+--------+
     |               |
     v               v
+----------+   +------------+
| list.jsp |   | Redirect   |
+----+-----+   +------------+
     |
     v
+----+----+
| End     |
+---------+
```

---

## 5. Sequence Diagrams

Maintenance list sequence:

```text
User → Browser: open /maintenance
Browser → MaintenanceServlet: GET /maintenance
MaintenanceServlet → MaintenanceDAO: getAllTasks()
MaintenanceDAO → MySQL: SELECT tasks JOIN devices JOIN users
MySQL → MaintenanceDAO: task rows
MaintenanceDAO → MaintenanceServlet: List<MaintenanceTask>
MaintenanceServlet → maintenance/list.jsp: forward taskList
list.jsp → Browser: render maintenance table
```

Create high-priority maintenance sequence:

```text
User → form.jsp: enter HIGH priority maintenance task
form.jsp → MaintenanceServlet: POST /maintenance?action=insert
MaintenanceServlet → MaintenanceDAO: insertTask(task)
MaintenanceDAO → MySQL: INSERT INTO maintenance_tasks
MaintenanceServlet → AlertDAO: insertAlert(alert)
AlertDAO → MySQL: INSERT INTO alerts
MaintenanceServlet → Browser: redirect /maintenance
```

Alert list sequence:

```text
User → Browser: open /alerts
Browser → AlertServlet: GET /alerts
AlertServlet → AlertDAO: getAllAlerts()
AlertDAO → MySQL: SELECT alerts LEFT JOIN devices
MySQL → AlertDAO: alert rows
AlertDAO → AlertServlet: List<Alert>
AlertServlet → alerts/list.jsp: forward alertList
list.jsp → Browser: render alerts
```

---

## 6. Files to Create in NetBeans

## 6.1 Source Packages

Create these files:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   ├── MaintenanceTask.java
    │   └── Alert.java
    ├── dao/
    │   ├── MaintenanceDAO.java
    │   └── AlertDAO.java
    └── controller/
        ├── MaintenanceServlet.java
        └── AlertServlet.java
```

Existing required files:

```text
Source Packages/com/networksim/model/Device.java
Source Packages/com/networksim/model/User.java
Source Packages/com/networksim/dao/DeviceDAO.java
Source Packages/com/networksim/util/DBContext.java
```

---

## 6.2 Web Pages

Create these folders and files:

```text
Web Pages/
├── maintenance/
│   ├── list.jsp
│   └── form.jsp
└── alerts/
    └── list.jsp
```

NetBeans steps:

1. Right-click **Web Pages**.
2. Choose **New → Folder**.
3. Create `maintenance`.
4. Right-click `maintenance` → **New → JSP**.
5. Create `list.jsp` and `form.jsp`.
6. Right-click **Web Pages** again.
7. Create folder `alerts`.
8. Right-click `alerts` → **New → JSP**.
9. Create `list.jsp`.

---

## 7. Database Tables Used

This module uses `maintenance_tasks` and `alerts` from the ERD.

```sql
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
```

Recommended maintenance priorities:

```text
LOW
MEDIUM
HIGH
```

Recommended maintenance statuses:

```text
PENDING
IN_PROGRESS
COMPLETED
CANCELLED
```

Recommended alert severities:

```text
INFO
WARNING
CRITICAL
```

---

## 8. Code Template: `MaintenanceTask.java`

Location:

```text
Source Packages/com/networksim/model/MaintenanceTask.java
```

```java
package com.networksim.model;

import java.util.Date;

public class MaintenanceTask {

    private int taskId;
    private int deviceId;
    private int assignedUserId;
    private String deviceName;
    private String assignedUserName;
    private String title;
    private String description;
    private Date scheduledDate;
    private String priority;
    private String status;
    private Date createdAt;

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }

    public int getAssignedUserId() { return assignedUserId; }
    public void setAssignedUserId(int assignedUserId) { this.assignedUserId = assignedUserId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public String getAssignedUserName() { return assignedUserName; }
    public void setAssignedUserName(String assignedUserName) { this.assignedUserName = assignedUserName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getScheduledDate() { return scheduledDate; }
    public void setScheduledDate(Date scheduledDate) { this.scheduledDate = scheduledDate; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
```

---

## 9. Code Template: `Alert.java`

Location:

```text
Source Packages/com/networksim/model/Alert.java
```

```java
package com.networksim.model;

import java.util.Date;

public class Alert {

    private int alertId;
    private Integer deviceId;
    private String deviceName;
    private String message;
    private String severity;
    private boolean read;
    private Date createdAt;

    public int getAlertId() { return alertId; }
    public void setAlertId(int alertId) { this.alertId = alertId; }

    public Integer getDeviceId() { return deviceId; }
    public void setDeviceId(Integer deviceId) { this.deviceId = deviceId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
```

---

## 10. Code Template: `AlertDAO.java`

Location:

```text
Source Packages/com/networksim/dao/AlertDAO.java
```

```java
package com.networksim.dao;

import com.networksim.model.Alert;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AlertDAO {

    public List<Alert> getAllAlerts() throws Exception {
        List<Alert> alerts = new ArrayList<Alert>();
        String sql = "SELECT a.alert_id, a.device_id, d.device_name, a.message, "
                + "a.severity, a.is_read, a.created_at "
                + "FROM alerts a LEFT JOIN devices d ON a.device_id = d.device_id "
                + "ORDER BY a.created_at DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Alert alert = new Alert();
                alert.setAlertId(rs.getInt("alert_id"));
                int deviceId = rs.getInt("device_id");
                if (!rs.wasNull()) {
                    alert.setDeviceId(deviceId);
                }
                alert.setDeviceName(rs.getString("device_name"));
                alert.setMessage(rs.getString("message"));
                alert.setSeverity(rs.getString("severity"));
                alert.setRead(rs.getBoolean("is_read"));
                alert.setCreatedAt(rs.getTimestamp("created_at"));
                alerts.add(alert);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return alerts;
    }

    public void insertAlert(Alert alert) throws Exception {
        String sql = "INSERT INTO alerts (device_id, message, severity, is_read) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            if (alert.getDeviceId() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, alert.getDeviceId().intValue());
            }
            ps.setString(2, alert.getMessage());
            ps.setString(3, alert.getSeverity());
            ps.setBoolean(4, alert.isRead());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void markAsRead(int alertId) throws Exception {
        String sql = "UPDATE alerts SET is_read = TRUE WHERE alert_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, alertId);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) throws Exception {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}
```

---

## 11. Code Template: `MaintenanceDAO.java`

Location:

```text
Source Packages/com/networksim/dao/MaintenanceDAO.java
```

```java
package com.networksim.dao;

import com.networksim.model.MaintenanceTask;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO {

    public List<MaintenanceTask> getAllTasks() throws Exception {
        List<MaintenanceTask> tasks = new ArrayList<MaintenanceTask>();
        String sql = "SELECT mt.task_id, mt.device_id, d.device_name, mt.assigned_user_id, "
                + "u.full_name AS assigned_user_name, mt.title, mt.description, "
                + "mt.scheduled_date, mt.priority, mt.status, mt.created_at "
                + "FROM maintenance_tasks mt "
                + "JOIN devices d ON mt.device_id = d.device_id "
                + "LEFT JOIN users u ON mt.assigned_user_id = u.user_id "
                + "ORDER BY mt.scheduled_date ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                tasks.add(mapResultSetToTask(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return tasks;
    }

    public MaintenanceTask getTaskById(int taskId) throws Exception {
        String sql = "SELECT mt.task_id, mt.device_id, d.device_name, mt.assigned_user_id, "
                + "u.full_name AS assigned_user_name, mt.title, mt.description, "
                + "mt.scheduled_date, mt.priority, mt.status, mt.created_at "
                + "FROM maintenance_tasks mt "
                + "JOIN devices d ON mt.device_id = d.device_id "
                + "LEFT JOIN users u ON mt.assigned_user_id = u.user_id "
                + "WHERE mt.task_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, taskId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToTask(rs);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    public void insertTask(MaintenanceTask task) throws Exception {
        String sql = "INSERT INTO maintenance_tasks "
                + "(device_id, assigned_user_id, title, description, scheduled_date, priority, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, task.getDeviceId());
            if (task.getAssignedUserId() <= 0) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, task.getAssignedUserId());
            }
            ps.setString(3, task.getTitle());
            ps.setString(4, task.getDescription());
            ps.setTimestamp(5, new java.sql.Timestamp(task.getScheduledDate().getTime()));
            ps.setString(6, task.getPriority());
            ps.setString(7, task.getStatus());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void updateTask(MaintenanceTask task) throws Exception {
        String sql = "UPDATE maintenance_tasks SET device_id = ?, assigned_user_id = ?, "
                + "title = ?, description = ?, scheduled_date = ?, priority = ?, status = ? "
                + "WHERE task_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, task.getDeviceId());
            if (task.getAssignedUserId() <= 0) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, task.getAssignedUserId());
            }
            ps.setString(3, task.getTitle());
            ps.setString(4, task.getDescription());
            ps.setTimestamp(5, new java.sql.Timestamp(task.getScheduledDate().getTime()));
            ps.setString(6, task.getPriority());
            ps.setString(7, task.getStatus());
            ps.setInt(8, task.getTaskId());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void deleteTask(int taskId) throws Exception {
        String sql = "DELETE FROM maintenance_tasks WHERE task_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, taskId);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    private MaintenanceTask mapResultSetToTask(ResultSet rs) throws Exception {
        // CT - Abstraction: convert database row details into one object.
        MaintenanceTask task = new MaintenanceTask();
        task.setTaskId(rs.getInt("task_id"));
        task.setDeviceId(rs.getInt("device_id"));
        task.setDeviceName(rs.getString("device_name"));
        task.setAssignedUserId(rs.getInt("assigned_user_id"));
        task.setAssignedUserName(rs.getString("assigned_user_name"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setScheduledDate(rs.getTimestamp("scheduled_date"));
        task.setPriority(rs.getString("priority"));
        task.setStatus(rs.getString("status"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        return task;
    }

    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) throws Exception {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}
```

---

## 12. Code Template: `AlertServlet.java`

Location:

```text
Source Packages/com/networksim/controller/AlertServlet.java
```

```java
package com.networksim.controller;

import com.networksim.dao.AlertDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AlertServlet", urlPatterns = {"/alerts"})
public class AlertServlet extends HttpServlet {

    private AlertDAO alertDAO;

    @Override
    public void init() throws ServletException {
        alertDAO = new AlertDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("read".equals(action)) {
                markAsRead(request, response);
            } else {
                listAlerts(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot load alerts.");
            request.getRequestDispatcher("alerts/list.jsp").forward(request, response);
        }
    }

    private void listAlerts(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        request.setAttribute("alertList", alertDAO.getAllAlerts());
        request.getRequestDispatcher("alerts/list.jsp").forward(request, response);
    }

    private void markAsRead(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        int alertId = Integer.parseInt(request.getParameter("id"));
        alertDAO.markAsRead(alertId);
        response.sendRedirect("alerts");
    }
}
```

---

## 13. Code Template: `MaintenanceServlet.java`

Location:

```text
Source Packages/com/networksim/controller/MaintenanceServlet.java
```

```java
package com.networksim.controller;

import com.networksim.dao.AlertDAO;
import com.networksim.dao.DeviceDAO;
import com.networksim.dao.MaintenanceDAO;
import com.networksim.model.Alert;
import com.networksim.model.MaintenanceTask;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MaintenanceServlet", urlPatterns = {"/maintenance"})
public class MaintenanceServlet extends HttpServlet {

    private MaintenanceDAO maintenanceDAO;
    private DeviceDAO deviceDAO;
    private AlertDAO alertDAO;

    @Override
    public void init() throws ServletException {
        maintenanceDAO = new MaintenanceDAO();
        deviceDAO = new DeviceDAO();
        alertDAO = new AlertDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            if ("create".equals(action)) {
                showCreateForm(request, response);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("delete".equals(action)) {
                deleteTask(request, response);
            } else {
                listTasks(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Maintenance operation failed.");
            request.getRequestDispatcher("maintenance/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertTask(request, response);
            } else if ("update".equals(action)) {
                updateTask(request, response);
            } else {
                response.sendRedirect("maintenance");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot save maintenance task. Please check your input.");
            prepareFormData(request);
            request.getRequestDispatcher("maintenance/form.jsp").forward(request, response);
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        request.setAttribute("taskList", maintenanceDAO.getAllTasks());
        request.getRequestDispatcher("maintenance/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        request.setAttribute("formAction", "insert");
        prepareFormData(request);
        request.getRequestDispatcher("maintenance/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("task", maintenanceDAO.getTaskById(taskId));
        request.setAttribute("formAction", "update");
        prepareFormData(request);
        request.getRequestDispatcher("maintenance/form.jsp").forward(request, response);
    }

    private void insertTask(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        MaintenanceTask task = buildTaskFromRequest(request);
        maintenanceDAO.insertTask(task);

        if ("HIGH".equals(task.getPriority())) {
            createAlert(task.getDeviceId(), "High priority maintenance scheduled: " + task.getTitle(), "WARNING");
        }

        response.sendRedirect("maintenance");
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        MaintenanceTask task = buildTaskFromRequest(request);
        task.setTaskId(Integer.parseInt(request.getParameter("taskId")));
        maintenanceDAO.updateTask(task);

        if ("COMPLETED".equals(task.getStatus())) {
            createAlert(task.getDeviceId(), "Maintenance completed: " + task.getTitle(), "INFO");
        }

        response.sendRedirect("maintenance");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int taskId = Integer.parseInt(request.getParameter("id"));
        maintenanceDAO.deleteTask(taskId);
        response.sendRedirect("maintenance");
    }

    private MaintenanceTask buildTaskFromRequest(HttpServletRequest request) throws Exception {
        // CT - Decomposition: collect fields, convert types, then create one object.
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Date scheduledDate = formatter.parse(request.getParameter("scheduledDate"));

        MaintenanceTask task = new MaintenanceTask();
        task.setDeviceId(Integer.parseInt(request.getParameter("deviceId")));

        String assignedUserId = request.getParameter("assignedUserId");
        if (assignedUserId != null && !assignedUserId.trim().isEmpty()) {
            task.setAssignedUserId(Integer.parseInt(assignedUserId));
        }

        task.setTitle(request.getParameter("title"));
        task.setDescription(request.getParameter("description"));
        task.setScheduledDate(scheduledDate);
        task.setPriority(request.getParameter("priority"));
        task.setStatus(request.getParameter("status"));
        return task;
    }

    private void createAlert(int deviceId, String message, String severity) throws Exception {
        // CT - Algorithm Design: generate an alert automatically from maintenance rules.
        Alert alert = new Alert();
        alert.setDeviceId(Integer.valueOf(deviceId));
        alert.setMessage(message);
        alert.setSeverity(severity);
        alert.setRead(false);
        alertDAO.insertAlert(alert);
    }

    private void prepareFormData(HttpServletRequest request) throws Exception {
        request.setAttribute("deviceList", deviceDAO.getAllDevices());
    }
}
```

Important note:

> This version only loads devices in the form. If the team later adds a `UserDAO.getTechnicians()` method, they can also load technician accounts for the `assigned_user_id` dropdown.

---

## 14. Code Template: `maintenance/list.jsp`

Location:

```text
Web Pages/maintenance/list.jsp
```

```jsp
<%@page import="com.networksim.model.MaintenanceTask"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<MaintenanceTask> taskList = (List<MaintenanceTask>) request.getAttribute("taskList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Maintenance Scheduling</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 24px; }
        .container { background: white; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 9px; text-align: left; }
        th { background: #0d1117; color: white; }
        .btn { display: inline-block; padding: 7px 10px; margin: 2px; border-radius: 4px; background: #1f6feb; color: white; text-decoration: none; }
        .btn-danger { background: #b00020; }
        .btn-secondary { background: #6c757d; }
        .high { color: #b00020; font-weight: bold; }
        .medium { color: #f59e0b; font-weight: bold; }
        .low { color: #16a34a; font-weight: bold; }
        .error { color: #b00020; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>Maintenance Scheduling</h2>

    <p>
        <a class="btn" href="maintenance?action=create">Add Maintenance Task</a>
        <a class="btn btn-secondary" href="alerts">View Alerts</a>
        <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
    </p>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Device</th>
            <th>Title</th>
            <th>Scheduled Date</th>
            <th>Priority</th>
            <th>Status</th>
            <th>Assigned User</th>
            <th>Actions</th>
        </tr>
        <% if (taskList != null && !taskList.isEmpty()) { %>
            <% for (MaintenanceTask task : taskList) { %>
                <tr>
                    <td><%= task.getTaskId() %></td>
                    <td><%= task.getDeviceName() %></td>
                    <td><%= task.getTitle() %></td>
                    <td><%= task.getScheduledDate() %></td>
                    <td class="<%= task.getPriority().toLowerCase() %>"><%= task.getPriority() %></td>
                    <td><%= task.getStatus() %></td>
                    <td><%= task.getAssignedUserName() == null ? "Unassigned" : task.getAssignedUserName() %></td>
                    <td>
                        <a class="btn" href="maintenance?action=edit&id=<%= task.getTaskId() %>">Edit</a>
                        <a class="btn btn-danger" href="maintenance?action=delete&id=<%= task.getTaskId() %>"
                           onclick="return confirm('Delete this maintenance task?');">Delete</a>
                    </td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="8">No maintenance tasks found.</td></tr>
        <% } %>
    </table>
</div>
</body>
</html>
```

---

## 15. Code Template: `maintenance/form.jsp`

Location:

```text
Web Pages/maintenance/form.jsp
```

```jsp
<%@page import="com.networksim.model.Device"%>
<%@page import="com.networksim.model.MaintenanceTask"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MaintenanceTask task = (MaintenanceTask) request.getAttribute("task");
    List<Device> deviceList = (List<Device>) request.getAttribute("deviceList");
    String formAction = (String) request.getAttribute("formAction");
    String scheduledValue = "";
    if (task != null && task.getScheduledDate() != null) {
        scheduledValue = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(task.getScheduledDate());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Maintenance Form</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 24px; }
        .container { background: white; padding: 20px; border-radius: 8px; max-width: 720px; margin: auto; }
        label { display: block; margin-top: 12px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; margin-top: 5px; box-sizing: border-box; }
        button, .btn { display: inline-block; margin-top: 16px; padding: 9px 12px; border: none; border-radius: 4px; background: #1f6feb; color: white; text-decoration: none; cursor: pointer; }
        .btn-secondary { background: #6c757d; }
        .error { color: #b00020; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2><%= "insert".equals(formAction) ? "Add Maintenance Task" : "Edit Maintenance Task" %></h2>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="maintenance" method="post">
        <input type="hidden" name="action" value="<%= formAction %>">
        <% if (task != null) { %>
            <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
        <% } %>

        <label for="deviceId">Device</label>
        <select id="deviceId" name="deviceId" required>
            <% if (deviceList != null) { %>
                <% for (Device device : deviceList) { %>
                    <option value="<%= device.getDeviceId() %>"
                        <%= task != null && task.getDeviceId() == device.getDeviceId() ? "selected" : "" %>>
                        <%= device.getDeviceName() %>
                    </option>
                <% } %>
            <% } %>
        </select>

        <label for="assignedUserId">Assigned User ID</label>
        <input type="number" id="assignedUserId" name="assignedUserId"
               value="<%= task == null || task.getAssignedUserId() == 0 ? "" : task.getAssignedUserId() %>"
               placeholder="Optional technician user ID">

        <label for="title">Title</label>
        <input type="text" id="title" name="title" required
               value="<%= task == null ? "" : task.getTitle() %>">

        <label for="description">Description</label>
        <textarea id="description" name="description" rows="4"><%= task == null || task.getDescription() == null ? "" : task.getDescription() %></textarea>

        <label for="scheduledDate">Scheduled Date</label>
        <input type="datetime-local" id="scheduledDate" name="scheduledDate" required value="<%= scheduledValue %>">

        <label for="priority">Priority</label>
        <select id="priority" name="priority" required>
            <option value="LOW" <%= task != null && "LOW".equals(task.getPriority()) ? "selected" : "" %>>LOW</option>
            <option value="MEDIUM" <%= task == null || "MEDIUM".equals(task.getPriority()) ? "selected" : "" %>>MEDIUM</option>
            <option value="HIGH" <%= task != null && "HIGH".equals(task.getPriority()) ? "selected" : "" %>>HIGH</option>
        </select>

        <label for="status">Status</label>
        <select id="status" name="status" required>
            <option value="PENDING" <%= task == null || "PENDING".equals(task.getStatus()) ? "selected" : "" %>>PENDING</option>
            <option value="IN_PROGRESS" <%= task != null && "IN_PROGRESS".equals(task.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
            <option value="COMPLETED" <%= task != null && "COMPLETED".equals(task.getStatus()) ? "selected" : "" %>>COMPLETED</option>
            <option value="CANCELLED" <%= task != null && "CANCELLED".equals(task.getStatus()) ? "selected" : "" %>>CANCELLED</option>
        </select>

        <button type="submit">Save</button>
        <a class="btn btn-secondary" href="maintenance">Cancel</a>
    </form>
</div>
</body>
</html>
```

---

## 16. Code Template: `alerts/list.jsp`

Location:

```text
Web Pages/alerts/list.jsp
```

```jsp
<%@page import="com.networksim.model.Alert"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Alert> alertList = (List<Alert>) request.getAttribute("alertList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Alerts</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 24px; }
        .container { background: white; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 9px; text-align: left; }
        th { background: #0d1117; color: white; }
        .btn { display: inline-block; padding: 7px 10px; margin: 2px; border-radius: 4px; background: #1f6feb; color: white; text-decoration: none; }
        .btn-secondary { background: #6c757d; }
        .critical { color: #b00020; font-weight: bold; }
        .warning { color: #f59e0b; font-weight: bold; }
        .info { color: #1f6feb; font-weight: bold; }
        .unread { font-weight: bold; background: #fff7ed; }
        .error { color: #b00020; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>System Alerts</h2>

    <p>
        <a class="btn btn-secondary" href="maintenance">Maintenance</a>
        <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
    </p>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Device</th>
            <th>Message</th>
            <th>Severity</th>
            <th>Status</th>
            <th>Created At</th>
            <th>Action</th>
        </tr>
        <% if (alertList != null && !alertList.isEmpty()) { %>
            <% for (Alert alert : alertList) { %>
                <tr class="<%= alert.isRead() ? "" : "unread" %>">
                    <td><%= alert.getAlertId() %></td>
                    <td><%= alert.getDeviceName() == null ? "General" : alert.getDeviceName() %></td>
                    <td><%= alert.getMessage() %></td>
                    <td class="<%= alert.getSeverity().toLowerCase() %>"><%= alert.getSeverity() %></td>
                    <td><%= alert.isRead() ? "READ" : "UNREAD" %></td>
                    <td><%= alert.getCreatedAt() %></td>
                    <td>
                        <% if (!alert.isRead()) { %>
                            <a class="btn" href="alerts?action=read&id=<%= alert.getAlertId() %>">Mark as Read</a>
                        <% } else { %>
                            -
                        <% } %>
                    </td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="7">No alerts found.</td></tr>
        <% } %>
    </table>
</div>
</body>
</html>
```

---

## 17. Dashboard Links to Add

In `Web Pages/dashboard.jsp`, add these links under Available Modules:

```jsp
<li><a href="maintenance">Maintenance Scheduling</a></li>
<li><a href="alerts">System Alerts</a></li>
```

Recommended final module list:

```jsp
<ul>
    <li><a href="devices">Device & Node Management</a></li>
    <li><a href="topology">Network Topology Simulation</a></li>
    <li><a href="monitoring">Bandwidth & Coverage Monitoring</a></li>
    <li><a href="maintenance">Maintenance Scheduling</a></li>
    <li><a href="alerts">System Alerts</a></li>
</ul>
```

---

## 18. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Maintenance backend | `MaintenanceTask.java`, `MaintenanceDAO.java`, `MaintenanceServlet.java` |
| Member 2 | Alert backend | `Alert.java`, `AlertDAO.java`, `AlertServlet.java` |
| Member 3 | JSP frontend | `maintenance/list.jsp`, `maintenance/form.jsp`, `alerts/list.jsp` |
| Member 4 | CT documentation + testing | Flowcharts, sequence diagrams, test cases, screenshots |

Parallel workflow:

```text
Member 1 builds maintenance CRUD
Member 2 builds alert list/read logic
Member 3 builds pages using expected request attributes
Member 4 prepares diagrams and test data
Then the team integrates and tests together in NetBeans
```

---

## 19. Testing Plan

| Test Case | Input | Expected Result |
|---|---|---|
| Open maintenance page | `/maintenance` | Task table appears |
| Add LOW priority task | Valid form data | Task saved, no warning alert required |
| Add HIGH priority task | Priority = HIGH | Task saved and WARNING alert created |
| Edit task to COMPLETED | Status = COMPLETED | Task updated and INFO alert created |
| Delete task | Click Delete | Task removed from list |
| Open alerts page | `/alerts` | Alert table appears |
| Mark alert as read | Click Mark as Read | Alert status changes to READ |
| Missing title | Empty title | Browser/Servlet prevents invalid save |
| Missing scheduled date | Empty date | Browser/Servlet prevents invalid save |

---

## 20. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| HTTP 404 on `/maintenance` | Servlet mapping issue | Check `@WebServlet(name = "MaintenanceServlet", urlPatterns = {"/maintenance"})` |
| HTTP 404 on `/alerts` | Servlet mapping issue | Check `@WebServlet(name = "AlertServlet", urlPatterns = {"/alerts"})` |
| Date parsing error | Wrong input format | Use `<input type="datetime-local">` and `yyyy-MM-dd'T'HH:mm` |
| Foreign key error | Device ID or user ID does not exist | Select an existing device and valid user ID |
| Alert not created | Priority/status comparison mismatch | Use exact values: `HIGH`, `COMPLETED` |
| `jakarta.servlet` import error | Wrong servlet namespace | Replace with `javax.servlet.*` and use Tomcat 9 |
| MySQL driver error | Missing JDBC JAR | Add `mysql-connector-java-8.0.33.jar` to Libraries |

---

## 21. Completion Checklist

- [ ] `maintenance_tasks` table exists
- [ ] `alerts` table exists
- [ ] `MaintenanceTask.java` created
- [ ] `Alert.java` created
- [ ] `MaintenanceDAO.java` created
- [ ] `AlertDAO.java` created
- [ ] `MaintenanceServlet.java` created
- [ ] `AlertServlet.java` created
- [ ] `maintenance/list.jsp` created
- [ ] `maintenance/form.jsp` created
- [ ] `alerts/list.jsp` created
- [ ] Dashboard links added
- [ ] Add task works
- [ ] Edit task works
- [ ] Delete task works
- [ ] HIGH priority task creates alert
- [ ] COMPLETED task creates alert
- [ ] Mark alert as read works
- [ ] Flowchart drawn
- [ ] Sequence diagrams drawn
- [ ] Screenshots saved for report

---

## 22. Next Recommended Step

After this module works, the team should implement:

```text
Report Generation
```

The report module can summarize:

- device inventory
- bandwidth status
- coverage status
- maintenance tasks
- alerts

Suggested next file:

```text
PRJ301_Report_Generation.md
```
