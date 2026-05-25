---
title: PRJ301 Device CRUD Implementation
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Device CRUD Implementation

## 1. Current Focus

This document guides the team through implementing:

```text
Device & Node Management CRUD
```

This is the best feature to build after Login MVC because most other modules depend on devices:

- Network topology links use `device_id`
- Bandwidth logs use `device_id`
- Coverage areas use `device_id`
- Maintenance tasks use `device_id`
- Alerts use `device_id`

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

> Use `javax.servlet.*`, not `jakarta.servlet.*`.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break Device CRUD into smaller actions:

| Action | Meaning | Main Files |
|---|---|---|
| Create | Add a new network device | `devices/form.jsp`, `DeviceServlet`, `DeviceDAO.insertDevice()` |
| Read/List | Show all devices | `devices/list.jsp`, `DeviceServlet`, `DeviceDAO.getAllDevices()` |
| Read/Detail | Show one device | `devices/detail.jsp`, `DeviceServlet`, `DeviceDAO.getDeviceById()` |
| Update | Edit device information | `devices/form.jsp`, `DeviceServlet`, `DeviceDAO.updateDevice()` |
| Delete | Remove a device | `DeviceServlet`, `DeviceDAO.deleteDevice()` |

Why this matters:

> CRUD is like a standard toolbox. Once the team builds Device CRUD, they can reuse the same thinking for Maintenance CRUD, Report management, and Alert management.

---

## 2.2 Pattern Recognition

Device CRUD follows this repeated MVC pattern:

```text
JSP page → Servlet action → DAO method → MySQL table → Servlet → JSP page
```

Repeated actions:

| URL | Servlet Action | DAO Method | JSP Result |
|---|---|---|---|
| `/devices` | list | `getAllDevices()` | `devices/list.jsp` |
| `/devices?action=create` | show create form | none | `devices/form.jsp` |
| `/devices?action=insert` | insert | `insertDevice(device)` | redirect `/devices` |
| `/devices?action=edit&id=1` | show edit form | `getDeviceById(id)` | `devices/form.jsp` |
| `/devices?action=update` | update | `updateDevice(device)` | redirect `/devices` |
| `/devices?action=detail&id=1` | detail | `getDeviceById(id)` | `devices/detail.jsp` |
| `/devices?action=delete&id=1` | delete | `deleteDevice(id)` | redirect `/devices` |

---

## 2.3 Abstraction

For this feature, store and manage only the device details needed by the simulation.

| Include Now | Ignore for Now |
|---|---|
| Device name | Real router firmware config |
| Device type | Real SNMP monitoring |
| IP address | Live network scanning |
| MAC address | Vendor detection |
| Location | GPS map integration |
| Status | Real device ping checking |

This keeps the project realistic for a PRJ301 team.

---

## 2.4 Algorithm Design

List devices algorithm:

```text
Start
  ↓
User opens /devices
  ↓
DeviceServlet receives GET request
  ↓
Servlet calls DeviceDAO.getAllDevices()
  ↓
DAO reads devices table
  ↓
Servlet stores list in request attribute
  ↓
Forward to devices/list.jsp
  ↓
JSP displays table
End
```

Create device algorithm:

```text
Start
  ↓
User opens create form
  ↓
User enters device details
  ↓
Submit form to /devices?action=insert
  ↓
Servlet validates required fields
  ↓
Servlet creates Device object
  ↓
Servlet calls DeviceDAO.insertDevice(device)
  ↓
DAO inserts row into devices table
  ↓
Redirect to /devices
End
```

Update device algorithm:

```text
Start
  ↓
User clicks Edit
  ↓
Servlet loads existing device by ID
  ↓
Forward to form.jsp with existing device
  ↓
User changes information
  ↓
Submit to /devices?action=update
  ↓
Servlet validates and creates Device object
  ↓
DAO updates devices table
  ↓
Redirect to /devices
End
```

Delete device algorithm:

```text
Start
  ↓
User clicks Delete
  ↓
Browser confirms delete
  ↓
Servlet receives device ID
  ↓
DAO deletes device by ID
  ↓
Redirect to /devices
End
```

---

## 3. Device CRUD Flowchart

Draw this flowchart in draw.io, Lucidchart, or StarUML:

```text
+-------+
| Start |
+---+---+
    |
    v
+----------------------+
| User opens /devices  |
+----------+-----------+
           |
           v
+----------------------+
| DeviceServlet checks |
| action parameter     |
+----------+-----------+
           |
           v
+-------------------------------+
| action is null/list/create/   |
| insert/edit/update/detail/    |
| delete                        |
+-----+------+------+------+-----+
      |      |      |      |
      v      v      v      v
   List   Create   Edit   Delete
      |      |      |      |
      v      v      v      v
+---------+ +---------+ +----------+ +----------+
| Get all | | Show    | | Load one | | Delete   |
| devices | | form    | | device   | | by ID    |
+----+----+ +----+----+ +----+-----+ +----+-----+
     |           |           |            |
     v           v           v            v
+----------+ +----------+ +----------+ +----------+
| list.jsp | | form.jsp | | form.jsp | | redirect |
+----------+ +----------+ +----------+ +----------+
```

---

## 4. Device CRUD Sequence Diagram

Draw this sequence diagram for listing devices:

```text
User → Browser: open /devices
Browser → DeviceServlet: GET /devices
DeviceServlet → DeviceDAO: getAllDevices()
DeviceDAO → DBContext: getConnection()
DBContext → MySQL: connect
DeviceDAO → MySQL: SELECT * FROM devices
MySQL → DeviceDAO: result set
DeviceDAO → DeviceServlet: List<Device>
DeviceServlet → devices/list.jsp: forward with deviceList
list.jsp → Browser: render device table
```

Draw this sequence diagram for adding a device:

```text
User → devices/form.jsp: enter device details
form.jsp → DeviceServlet: POST /devices?action=insert
DeviceServlet → DeviceDAO: insertDevice(device)
DeviceDAO → MySQL: INSERT INTO devices
MySQL → DeviceDAO: success
DeviceDAO → DeviceServlet: return
DeviceServlet → Browser: redirect /devices
```

---

## 5. Files to Create in NetBeans

## 5.1 Source Packages

Create these files:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   └── Device.java
    ├── dao/
    │   └── DeviceDAO.java
    └── controller/
        └── DeviceServlet.java
```

Existing required file:

```text
Source Packages/com/networksim/util/DBContext.java
```

---

## 5.2 Web Pages

Create this folder and files:

```text
Web Pages/
└── devices/
    ├── list.jsp
    ├── form.jsp
    └── detail.jsp
```

NetBeans steps:

1. Right-click **Web Pages**.
2. Choose **New → Folder**.
3. Name the folder `devices`.
4. Right-click `devices`.
5. Choose **New → JSP**.
6. Create `list.jsp`, `form.jsp`, and `detail.jsp`.

---

## 6. Database Table Used

This feature uses the `devices` table from the ERD.

```sql
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
```

Recommended device types:

```text
ROUTER
SWITCH
SERVER
ACCESS_POINT
FIREWALL
```

Recommended device statuses:

```text
ONLINE
OFFLINE
MAINTENANCE
```

---

## 7. Sample Device Data

Use this if the table is empty:

```sql
INSERT INTO devices (device_name, device_type, ip_address, mac_address, location, status)
VALUES
('Main Router', 'ROUTER', '192.168.1.1', 'AA:BB:CC:DD:EE:01', 'Server Room', 'ONLINE'),
('Core Switch', 'SWITCH', '192.168.1.2', 'AA:BB:CC:DD:EE:02', 'Server Room', 'ONLINE'),
('Web Server', 'SERVER', '192.168.1.10', 'AA:BB:CC:DD:EE:03', 'Rack A', 'ONLINE'),
('Access Point 1', 'ACCESS_POINT', '192.168.1.20', 'AA:BB:CC:DD:EE:04', 'Floor 1', 'ONLINE');
```

---

## 8. Code Template: `Device.java`

Location:

```text
Source Packages/com/networksim/model/Device.java
```

Code:

```java
package com.networksim.model;

import java.util.Date;

public class Device {

    private int deviceId;
    private String deviceName;
    private String deviceType;
    private String ipAddress;
    private String macAddress;
    private String location;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    public Device() {
    }

    public Device(int deviceId, String deviceName, String deviceType, String ipAddress,
            String macAddress, String location, String status, Date createdAt, Date updatedAt) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.deviceType = deviceType;
        this.ipAddress = ipAddress;
        this.macAddress = macAddress;
        this.location = location;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getMacAddress() {
        return macAddress;
    }

    public void setMacAddress(String macAddress) {
        this.macAddress = macAddress;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
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

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
```

---

## 9. Code Template: `DeviceDAO.java`

Location:

```text
Source Packages/com/networksim/dao/DeviceDAO.java
```

Code:

```java
package com.networksim.dao;

import com.networksim.model.Device;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DeviceDAO {

    public List<Device> getAllDevices() throws Exception {
        // CT - Pattern Recognition: list operation appears in every CRUD module.
        List<Device> devices = new ArrayList<Device>();
        String sql = "SELECT device_id, device_name, device_type, ip_address, mac_address, "
                + "location, status, created_at, updated_at FROM devices ORDER BY device_id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }

        return devices;
    }

    public Device getDeviceById(int deviceId) throws Exception {
        String sql = "SELECT device_id, device_name, device_type, ip_address, mac_address, "
                + "location, status, created_at, updated_at FROM devices WHERE device_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToDevice(rs);
            }
        } finally {
            closeResources(rs, ps, conn);
        }

        return null;
    }

    public void insertDevice(Device device) throws Exception {
        String sql = "INSERT INTO devices (device_name, device_type, ip_address, mac_address, location, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, device.getDeviceName());
            ps.setString(2, device.getDeviceType());
            ps.setString(3, device.getIpAddress());
            ps.setString(4, device.getMacAddress());
            ps.setString(5, device.getLocation());
            ps.setString(6, device.getStatus());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void updateDevice(Device device) throws Exception {
        String sql = "UPDATE devices SET device_name = ?, device_type = ?, ip_address = ?, "
                + "mac_address = ?, location = ?, status = ? WHERE device_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, device.getDeviceName());
            ps.setString(2, device.getDeviceType());
            ps.setString(3, device.getIpAddress());
            ps.setString(4, device.getMacAddress());
            ps.setString(5, device.getLocation());
            ps.setString(6, device.getStatus());
            ps.setInt(7, device.getDeviceId());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void deleteDevice(int deviceId) throws Exception {
        String sql = "DELETE FROM devices WHERE device_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deviceId);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    private Device mapResultSetToDevice(ResultSet rs) throws Exception {
        // CT - Abstraction: convert one database row into one Java object in one place.
        Device device = new Device();
        device.setDeviceId(rs.getInt("device_id"));
        device.setDeviceName(rs.getString("device_name"));
        device.setDeviceType(rs.getString("device_type"));
        device.setIpAddress(rs.getString("ip_address"));
        device.setMacAddress(rs.getString("mac_address"));
        device.setLocation(rs.getString("location"));
        device.setStatus(rs.getString("status"));
        device.setCreatedAt(rs.getTimestamp("created_at"));
        device.setUpdatedAt(rs.getTimestamp("updated_at"));
        return device;
    }

    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) throws Exception {
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
}
```

Important:

> Because other tables reference `devices.device_id`, deleting a device may fail if it already has related links, logs, maintenance tasks, alerts, or coverage records. For the first CRUD version, this is acceptable. Later, the team can implement safer delete rules.

---

## 10. Code Template: `DeviceServlet.java`

Location:

```text
Source Packages/com/networksim/controller/DeviceServlet.java
```

Code:

```java
package com.networksim.controller;

import com.networksim.dao.DeviceDAO;
import com.networksim.model.Device;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeviceServlet", urlPatterns = {"/devices"})
public class DeviceServlet extends HttpServlet {

    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
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
            } else if ("detail".equals(action)) {
                showDetail(request, response);
            } else if ("delete".equals(action)) {
                deleteDevice(request, response);
            } else {
                listDevices(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Device operation failed.");
            request.getRequestDispatcher("devices/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertDevice(request, response);
            } else if ("update".equals(action)) {
                updateDevice(request, response);
            } else {
                response.sendRedirect("devices");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot save device. Please check the input data.");
            request.getRequestDispatcher("devices/form.jsp").forward(request, response);
        }
    }

    private void listDevices(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Device> deviceList = deviceDAO.getAllDevices();
        request.setAttribute("deviceList", deviceList);
        request.getRequestDispatcher("devices/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("formAction", "insert");
        request.getRequestDispatcher("devices/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int deviceId = Integer.parseInt(request.getParameter("id"));
        Device device = deviceDAO.getDeviceById(deviceId);
        request.setAttribute("device", device);
        request.setAttribute("formAction", "update");
        request.getRequestDispatcher("devices/form.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int deviceId = Integer.parseInt(request.getParameter("id"));
        Device device = deviceDAO.getDeviceById(deviceId);
        request.setAttribute("device", device);
        request.getRequestDispatcher("devices/detail.jsp").forward(request, response);
    }

    private void insertDevice(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Device device = buildDeviceFromRequest(request);
        deviceDAO.insertDevice(device);
        response.sendRedirect("devices");
    }

    private void updateDevice(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Device device = buildDeviceFromRequest(request);
        device.setDeviceId(Integer.parseInt(request.getParameter("deviceId")));
        deviceDAO.updateDevice(device);
        response.sendRedirect("devices");
    }

    private void deleteDevice(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int deviceId = Integer.parseInt(request.getParameter("id"));
        deviceDAO.deleteDevice(deviceId);
        response.sendRedirect("devices");
    }

    private Device buildDeviceFromRequest(HttpServletRequest request) {
        // CT - Decomposition: collect form fields and convert them into one Device object.
        Device device = new Device();
        device.setDeviceName(request.getParameter("deviceName"));
        device.setDeviceType(request.getParameter("deviceType"));
        device.setIpAddress(request.getParameter("ipAddress"));
        device.setMacAddress(request.getParameter("macAddress"));
        device.setLocation(request.getParameter("location"));
        device.setStatus(request.getParameter("status"));
        return device;
    }
}
```

---

## 11. Code Template: `devices/list.jsp`

Location:

```text
Web Pages/devices/list.jsp
```

Code:

```jsp
<%@page import="com.networksim.model.Device"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Device> deviceList = (List<Device>) request.getAttribute("deviceList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Device Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 24px;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #0d1117;
            color: white;
        }
        .btn {
            display: inline-block;
            padding: 6px 10px;
            margin: 2px;
            text-decoration: none;
            border-radius: 4px;
            color: white;
            background-color: #1f6feb;
        }
        .btn-danger {
            background-color: #b00020;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .error {
            color: #b00020;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Device & Node Management</h2>

        <p>
            <a class="btn" href="devices?action=create">Add New Device</a>
            <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Type</th>
                    <th>IP Address</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (deviceList != null && !deviceList.isEmpty()) { %>
                    <% for (Device device : deviceList) { %>
                        <tr>
                            <td><%= device.getDeviceId() %></td>
                            <td><%= device.getDeviceName() %></td>
                            <td><%= device.getDeviceType() %></td>
                            <td><%= device.getIpAddress() %></td>
                            <td><%= device.getLocation() %></td>
                            <td><%= device.getStatus() %></td>
                            <td>
                                <a class="btn btn-secondary" href="devices?action=detail&id=<%= device.getDeviceId() %>">Detail</a>
                                <a class="btn" href="devices?action=edit&id=<%= device.getDeviceId() %>">Edit</a>
                                <a class="btn btn-danger" href="devices?action=delete&id=<%= device.getDeviceId() %>"
                                   onclick="return confirm('Are you sure you want to delete this device?');">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="7">No devices found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
```

---

## 12. Code Template: `devices/form.jsp`

Location:

```text
Web Pages/devices/form.jsp
```

Code:

```jsp
<%@page import="com.networksim.model.Device"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Device device = (Device) request.getAttribute("device");
    String formAction = (String) request.getAttribute("formAction");
    boolean isEdit = device != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Device" : "Add Device" %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 24px;
        }
        .container {
            width: 520px;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            box-sizing: border-box;
        }
        button, .btn {
            display: inline-block;
            margin-top: 16px;
            padding: 9px 12px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            background-color: #1f6feb;
            cursor: pointer;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .error {
            color: #b00020;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2><%= isEdit ? "Edit Device" : "Add New Device" %></h2>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="devices" method="post">
            <input type="hidden" name="action" value="<%= formAction %>">

            <% if (isEdit) { %>
                <input type="hidden" name="deviceId" value="<%= device.getDeviceId() %>">
            <% } %>

            <label for="deviceName">Device Name</label>
            <input type="text" id="deviceName" name="deviceName"
                   value="<%= isEdit ? device.getDeviceName() : "" %>" required>

            <label for="deviceType">Device Type</label>
            <select id="deviceType" name="deviceType" required>
                <option value="ROUTER" <%= isEdit && "ROUTER".equals(device.getDeviceType()) ? "selected" : "" %>>Router</option>
                <option value="SWITCH" <%= isEdit && "SWITCH".equals(device.getDeviceType()) ? "selected" : "" %>>Switch</option>
                <option value="SERVER" <%= isEdit && "SERVER".equals(device.getDeviceType()) ? "selected" : "" %>>Server</option>
                <option value="ACCESS_POINT" <%= isEdit && "ACCESS_POINT".equals(device.getDeviceType()) ? "selected" : "" %>>Access Point</option>
                <option value="FIREWALL" <%= isEdit && "FIREWALL".equals(device.getDeviceType()) ? "selected" : "" %>>Firewall</option>
            </select>

            <label for="ipAddress">IP Address</label>
            <input type="text" id="ipAddress" name="ipAddress"
                   value="<%= isEdit ? device.getIpAddress() : "" %>">

            <label for="macAddress">MAC Address</label>
            <input type="text" id="macAddress" name="macAddress"
                   value="<%= isEdit ? device.getMacAddress() : "" %>">

            <label for="location">Location</label>
            <input type="text" id="location" name="location"
                   value="<%= isEdit ? device.getLocation() : "" %>">

            <label for="status">Status</label>
            <select id="status" name="status" required>
                <option value="ONLINE" <%= isEdit && "ONLINE".equals(device.getStatus()) ? "selected" : "" %>>Online</option>
                <option value="OFFLINE" <%= isEdit && "OFFLINE".equals(device.getStatus()) ? "selected" : "" %>>Offline</option>
                <option value="MAINTENANCE" <%= isEdit && "MAINTENANCE".equals(device.getStatus()) ? "selected" : "" %>>Maintenance</option>
            </select>

            <button type="submit">Save</button>
            <a class="btn btn-secondary" href="devices">Cancel</a>
        </form>
    </div>
</body>
</html>
```

---

## 13. Code Template: `devices/detail.jsp`

Location:

```text
Web Pages/devices/detail.jsp
```

Code:

```jsp
<%@page import="com.networksim.model.Device"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Device device = (Device) request.getAttribute("device");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Device Detail</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 24px;
        }
        .container {
            width: 600px;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
        }
        .row {
            margin-bottom: 10px;
        }
        .label {
            font-weight: bold;
            display: inline-block;
            width: 140px;
        }
        .btn {
            display: inline-block;
            margin-top: 16px;
            padding: 9px 12px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            background-color: #1f6feb;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Device Detail</h2>

        <% if (device != null) { %>
            <div class="row"><span class="label">ID:</span> <%= device.getDeviceId() %></div>
            <div class="row"><span class="label">Name:</span> <%= device.getDeviceName() %></div>
            <div class="row"><span class="label">Type:</span> <%= device.getDeviceType() %></div>
            <div class="row"><span class="label">IP Address:</span> <%= device.getIpAddress() %></div>
            <div class="row"><span class="label">MAC Address:</span> <%= device.getMacAddress() %></div>
            <div class="row"><span class="label">Location:</span> <%= device.getLocation() %></div>
            <div class="row"><span class="label">Status:</span> <%= device.getStatus() %></div>
            <div class="row"><span class="label">Created At:</span> <%= device.getCreatedAt() %></div>
            <div class="row"><span class="label">Updated At:</span> <%= device.getUpdatedAt() %></div>

            <a class="btn" href="devices?action=edit&id=<%= device.getDeviceId() %>">Edit</a>
            <a class="btn btn-secondary" href="devices">Back to List</a>
        <% } else { %>
            <p>Device not found.</p>
            <a class="btn btn-secondary" href="devices">Back to List</a>
        <% } %>
    </div>
</body>
</html>
```

---

## 14. Add Link from Dashboard

Update `dashboard.jsp` and add this link inside the available modules section:

```jsp
<li><a href="devices">Device & Node Management</a></li>
```

Example:

```jsp
<ul>
    <li><a href="devices">Device & Node Management</a></li>
    <li>Network Topology Simulation</li>
    <li>Bandwidth & Coverage Monitoring</li>
    <li>Maintenance Scheduling</li>
    <li>Reports</li>
</ul>
```

---

## 15. How to Run in NetBeans

1. Make sure MySQL is running.
2. Confirm the `devices` table exists.
3. Add sample device data if needed.
4. Confirm `DBContext.java` has the correct username/password.
5. Right-click project.
6. Select **Clean and Build**.
7. Right-click project.
8. Select **Run**.
9. Login first.
10. Open:

```text
http://localhost:8080/NetworkSimulationManagement/devices
```

Expected result:

```text
The device list page displays all records from the devices table.
```

---

## 16. Device CRUD Test Cases

| Test Case | Action | Expected Result |
|---|---|---|
| List devices | Open `/devices` | Device table appears |
| Add valid device | Fill form and save | New device appears in list |
| Add missing name | Leave name blank | Browser blocks because `required` is set |
| View detail | Click Detail | Device detail page appears |
| Edit device | Change status/location | Updated value appears in list |
| Delete device | Click Delete and confirm | Device removed from list |
| Cancel form | Click Cancel | Return to device list |
| Database down | Stop MySQL and open list | Error message appears |

---

## 17. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| HTTP 404 on `/devices` | Servlet mapping missing | Check `@WebServlet("/devices")` |
| Device list is empty | No data in table | Insert sample device records |
| `ClassNotFoundException` | Missing MySQL connector | Add `mysql-connector-java-8.0.33.jar` to Libraries |
| Delete fails | Device is referenced by another table | Delete related records first or disable delete later |
| JSP compile error | Wrong import or typo | Check `Device` import and package name |
| Form saves null fields | Wrong input `name` attribute | Match JSP field names with Servlet parameter names |
| Redirect loops or wrong path | Wrong relative URL | Use `response.sendRedirect("devices")` from servlet |
| `jakarta.servlet` compile error | Wrong namespace | Replace with `javax.servlet.*` |

---

## 18. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Model + DAO lead | `Device.java`, `DeviceDAO.java` |
| Member 2 | Servlet lead | `DeviceServlet.java`, action routing |
| Member 3 | JSP/frontend lead | `list.jsp`, `form.jsp`, `detail.jsp` |
| Member 4 | Testing + documentation lead | Flowchart, sequence diagram, test screenshots |

Parallel workflow:

```text
Member 1 builds model and DAO
Member 3 builds JSP pages
Member 2 connects actions through DeviceServlet
Member 4 tests list/create/edit/delete/detail and documents results
```

---

## 19. Device CRUD Completion Checklist

- [ ] `devices` table exists
- [ ] Sample device data inserted
- [ ] `Device.java` created
- [ ] `DeviceDAO.java` created
- [ ] `DeviceServlet.java` created
- [ ] `devices/list.jsp` created
- [ ] `devices/form.jsp` created
- [ ] `devices/detail.jsp` created
- [ ] Dashboard links to `/devices`
- [ ] `/devices` lists all devices
- [ ] Add device works
- [ ] Edit device works
- [ ] Detail page works
- [ ] Delete device works for unreferenced devices
- [ ] Error message appears when operation fails
- [ ] Flowchart completed
- [ ] Sequence diagrams completed
- [ ] Test screenshots saved for report

---

## 20. Next Recommended Feature

After Device CRUD works, implement:

```text
Network Topology Simulation
```

Reason:

> Now that devices exist, the team can create links between them and display a simple topology diagram using HTML/CSS/vanilla JavaScript.

Recommended next document:

```text
PRJ301_Network_Topology_Simulation.md
```
