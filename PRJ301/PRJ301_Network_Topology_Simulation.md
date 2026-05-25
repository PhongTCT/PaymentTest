---
title: PRJ301 Network Topology Simulation
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Network Topology Simulation

## 1. Current Focus

This document guides the team through implementing:

```text
Network Topology Simulation
```

The topology module lets users connect devices and display a simple simulated network diagram.

Core idea:

```text
Devices are nodes.
Network links are edges.
The topology page draws nodes and edges in the browser.
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
| Frontend | HTML5, CSS3, vanilla JavaScript |

Important:

> Do not use Spring, Maven, Docker, or `jakarta.servlet.*`. This implementation stays compatible with NetBeans 13 + JDK 8 + Tomcat 9.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break topology simulation into small parts:

| Part | Responsibility | Main Files |
|---|---|---|
| Device data | Provides nodes in the diagram | `devices` table, `DeviceDAO` |
| Link data | Provides connections between nodes | `network_links` table, `NetworkLinkDAO` |
| Topology controller | Loads devices and links | `TopologyServlet.java` |
| Topology view | Displays form and diagram | `topology/simulation.jsp` |
| JavaScript renderer | Draws nodes and lines | inline JS or `assets/js/topology.js` |
| Validation | Prevents invalid links | Servlet + JSP form checks |

Why this matters:

> A network diagram looks complex, but it is just two simple things: nodes and connections.

---

## 2.2 Pattern Recognition

Topology simulation uses a familiar graph pattern:

```text
Node + Edge = Network Topology
```

In this project:

| Graph Concept | Project Concept | Database Table |
|---|---|---|
| Node | Device | `devices` |
| Edge | Network link | `network_links` |
| Source node | Starting device | `source_device_id` |
| Target node | Ending device | `target_device_id` |
| Edge weight | Bandwidth capacity | `bandwidth_capacity` |
| Edge status | Link status | `status` |

This is the same mental model used in real networking tools, but simplified for a student Java Web project.

---

## 2.3 Abstraction

For the PRJ301 version, focus on simulation data instead of real networking.

| Include Now | Ignore for Now |
|---|---|
| Device nodes | Real packet routing |
| Source and target device | Live network discovery |
| Link type | Real cabling detection |
| Bandwidth capacity | Real bandwidth measurement from hardware |
| Link status | SNMP polling |
| Simple browser diagram | Advanced drag-and-drop canvas editor |

The goal is to demonstrate design, MVC, database relationships, and CT clearly.

---

## 2.4 Algorithm Design

Load topology algorithm:

```text
Start
  ↓
User opens /topology
  ↓
TopologyServlet loads all devices
  ↓
TopologyServlet loads all network links
  ↓
Servlet forwards data to simulation.jsp
  ↓
JSP renders device/link data into JavaScript arrays
  ↓
JavaScript places devices around a circle
  ↓
JavaScript draws lines between connected devices
End
```

Create link algorithm:

```text
Start
  ↓
User selects source device
  ↓
User selects target device
  ↓
User selects link type and bandwidth capacity
  ↓
Submit form to /topology?action=insert
  ↓
Servlet validates source != target
  ↓
Servlet validates bandwidth > 0
  ↓
DAO inserts new network link
  ↓
Redirect to /topology
End
```

Delete link algorithm:

```text
Start
  ↓
User clicks Delete on a link
  ↓
Servlet receives link ID
  ↓
DAO deletes link
  ↓
Redirect to /topology
End
```

---

## 3. Topology Flowchart

Draw this in draw.io, Lucidchart, or StarUML:

```text
+-------+
| Start |
+---+---+
    |
    v
+----------------------+
| User opens /topology |
+----------+-----------+
           |
           v
+----------------------+
| TopologyServlet      |
| checks action        |
+----------+-----------+
           |
           v
+------------------------------+
| action is list/insert/delete |
+------+-------------+---------+
       |             |
       v             v
    List view      Insert link
       |             |
       v             v
+-------------+   +----------------+
| Load devices|   | Validate input |
| and links   |   +-------+--------+
+------+------+           |
       |                  v
       v          +----------------+
+-------------+   | source != target? |
| simulation  |   +-------+--------+
| JSP         |       No  | Yes
+------+------+       v   v
       |          +------+ +--------------+
       v          | Error| | Insert link  |
+-------------+   +------+ +------+-------+
| Draw diagram|                  |
+------+------+                  v
       |                   +-------------+
       v                   | Redirect    |
+------+                   | /topology   |
| End  |                   +-------------+
+------+
```

---

## 4. Topology Sequence Diagram

Draw this sequence diagram for loading the topology:

```text
User → Browser: open /topology
Browser → TopologyServlet: GET /topology
TopologyServlet → DeviceDAO: getAllDevices()
DeviceDAO → MySQL: SELECT devices
MySQL → DeviceDAO: device rows
DeviceDAO → TopologyServlet: List<Device>
TopologyServlet → NetworkLinkDAO: getAllLinks()
NetworkLinkDAO → MySQL: SELECT network_links with device names
MySQL → NetworkLinkDAO: link rows
NetworkLinkDAO → TopologyServlet: List<NetworkLink>
TopologyServlet → simulation.jsp: forward devices + links
simulation.jsp → Browser: render HTML + JavaScript diagram
```

Draw this sequence diagram for creating a link:

```text
User → simulation.jsp: select source, target, type, bandwidth
simulation.jsp → TopologyServlet: POST /topology?action=insert
TopologyServlet → TopologyServlet: validate source != target and bandwidth > 0
TopologyServlet → NetworkLinkDAO: insertLink(link)
NetworkLinkDAO → MySQL: INSERT INTO network_links
MySQL → NetworkLinkDAO: success
NetworkLinkDAO → TopologyServlet: return
TopologyServlet → Browser: redirect /topology
```

---

## 5. Files to Create in NetBeans

## 5.1 Source Packages

Create these files:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   └── NetworkLink.java
    ├── dao/
    │   └── NetworkLinkDAO.java
    └── controller/
        └── TopologyServlet.java
```

Existing required files:

```text
Source Packages/com/networksim/model/Device.java
Source Packages/com/networksim/dao/DeviceDAO.java
Source Packages/com/networksim/util/DBContext.java
```

---

## 5.2 Web Pages

Create this folder and file:

```text
Web Pages/
└── topology/
    └── simulation.jsp
```

NetBeans steps:

1. Right-click **Web Pages**.
2. Choose **New → Folder**.
3. Name the folder `topology`.
4. Right-click `topology`.
5. Choose **New → JSP**.
6. Create `simulation.jsp`.

---

## 6. Database Table Used

This feature uses `network_links` from the ERD.

```sql
CREATE TABLE network_links (
    link_id INT AUTO_INCREMENT PRIMARY KEY,
    source_device_id INT NOT NULL,
    target_device_id INT NOT NULL,
    link_type VARCHAR(50) NOT NULL,
    bandwidth_capacity DECIMAL(10,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_link_source_device
        FOREIGN KEY (source_device_id) REFERENCES devices(device_id),
    CONSTRAINT fk_link_target_device
        FOREIGN KEY (target_device_id) REFERENCES devices(device_id),
    CONSTRAINT chk_link_different_devices
        CHECK (source_device_id <> target_device_id)
);
```

If MySQL rejects the `CHECK` constraint, remove it and rely on Java validation in `TopologyServlet`.

Recommended link types:

```text
ETHERNET
FIBER
WIRELESS
```

Recommended link statuses:

```text
ACTIVE
DOWN
DEGRADED
```

---

## 7. Sample Link Data

Only run this after the `devices` table has sample records.

```sql
INSERT INTO network_links (source_device_id, target_device_id, link_type, bandwidth_capacity, status)
VALUES
(1, 2, 'ETHERNET', 1000.00, 'ACTIVE'),
(2, 3, 'ETHERNET', 1000.00, 'ACTIVE'),
(2, 4, 'WIRELESS', 300.00, 'ACTIVE');
```

---

## 8. Code Template: `NetworkLink.java`

Location:

```text
Source Packages/com/networksim/model/NetworkLink.java
```

Code:

```java
package com.networksim.model;

import java.util.Date;

public class NetworkLink {

    private int linkId;
    private int sourceDeviceId;
    private int targetDeviceId;
    private String sourceDeviceName;
    private String targetDeviceName;
    private String linkType;
    private double bandwidthCapacity;
    private String status;
    private Date createdAt;

    public NetworkLink() {
    }

    public int getLinkId() {
        return linkId;
    }

    public void setLinkId(int linkId) {
        this.linkId = linkId;
    }

    public int getSourceDeviceId() {
        return sourceDeviceId;
    }

    public void setSourceDeviceId(int sourceDeviceId) {
        this.sourceDeviceId = sourceDeviceId;
    }

    public int getTargetDeviceId() {
        return targetDeviceId;
    }

    public void setTargetDeviceId(int targetDeviceId) {
        this.targetDeviceId = targetDeviceId;
    }

    public String getSourceDeviceName() {
        return sourceDeviceName;
    }

    public void setSourceDeviceName(String sourceDeviceName) {
        this.sourceDeviceName = sourceDeviceName;
    }

    public String getTargetDeviceName() {
        return targetDeviceName;
    }

    public void setTargetDeviceName(String targetDeviceName) {
        this.targetDeviceName = targetDeviceName;
    }

    public String getLinkType() {
        return linkType;
    }

    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }

    public double getBandwidthCapacity() {
        return bandwidthCapacity;
    }

    public void setBandwidthCapacity(double bandwidthCapacity) {
        this.bandwidthCapacity = bandwidthCapacity;
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

## 9. Code Template: `NetworkLinkDAO.java`

Location:

```text
Source Packages/com/networksim/dao/NetworkLinkDAO.java
```

Code:

```java
package com.networksim.dao;

import com.networksim.model.NetworkLink;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NetworkLinkDAO {

    public List<NetworkLink> getAllLinks() throws Exception {
        // CT - Abstraction: hide the join query inside DAO so the Servlet receives ready-to-use objects.
        List<NetworkLink> links = new ArrayList<NetworkLink>();

        String sql = "SELECT nl.link_id, nl.source_device_id, nl.target_device_id, "
                + "src.device_name AS source_device_name, "
                + "tgt.device_name AS target_device_name, "
                + "nl.link_type, nl.bandwidth_capacity, nl.status, nl.created_at "
                + "FROM network_links nl "
                + "JOIN devices src ON nl.source_device_id = src.device_id "
                + "JOIN devices tgt ON nl.target_device_id = tgt.device_id "
                + "ORDER BY nl.link_id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                NetworkLink link = new NetworkLink();
                link.setLinkId(rs.getInt("link_id"));
                link.setSourceDeviceId(rs.getInt("source_device_id"));
                link.setTargetDeviceId(rs.getInt("target_device_id"));
                link.setSourceDeviceName(rs.getString("source_device_name"));
                link.setTargetDeviceName(rs.getString("target_device_name"));
                link.setLinkType(rs.getString("link_type"));
                link.setBandwidthCapacity(rs.getDouble("bandwidth_capacity"));
                link.setStatus(rs.getString("status"));
                link.setCreatedAt(rs.getTimestamp("created_at"));
                links.add(link);
            }
        } finally {
            closeResources(rs, ps, conn);
        }

        return links;
    }

    public void insertLink(NetworkLink link) throws Exception {
        String sql = "INSERT INTO network_links (source_device_id, target_device_id, link_type, bandwidth_capacity, status) "
                + "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, link.getSourceDeviceId());
            ps.setInt(2, link.getTargetDeviceId());
            ps.setString(3, link.getLinkType());
            ps.setDouble(4, link.getBandwidthCapacity());
            ps.setString(5, link.getStatus());
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    public void deleteLink(int linkId) throws Exception {
        String sql = "DELETE FROM network_links WHERE link_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, linkId);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, conn);
        }
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

---

## 10. Code Template: `TopologyServlet.java`

Location:

```text
Source Packages/com/networksim/controller/TopologyServlet.java
```

Code:

```java
package com.networksim.controller;

import com.networksim.dao.DeviceDAO;
import com.networksim.dao.NetworkLinkDAO;
import com.networksim.model.Device;
import com.networksim.model.NetworkLink;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TopologyServlet", urlPatterns = {"/topology"})
public class TopologyServlet extends HttpServlet {

    private DeviceDAO deviceDAO;
    private NetworkLinkDAO networkLinkDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
        networkLinkDAO = new NetworkLinkDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                deleteLink(request, response);
            } else {
                showTopology(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot load topology data.");
            forwardTopology(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertLink(request, response);
            } else {
                response.sendRedirect("topology");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot save network link. Please check the input data.");
            forwardTopology(request, response);
        }
    }

    private void showTopology(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Device> deviceList = deviceDAO.getAllDevices();
        List<NetworkLink> linkList = networkLinkDAO.getAllLinks();

        request.setAttribute("deviceList", deviceList);
        request.setAttribute("linkList", linkList);
        request.getRequestDispatcher("topology/simulation.jsp").forward(request, response);
    }

    private void insertLink(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int sourceDeviceId = Integer.parseInt(request.getParameter("sourceDeviceId"));
        int targetDeviceId = Integer.parseInt(request.getParameter("targetDeviceId"));
        String linkType = request.getParameter("linkType");
        double bandwidthCapacity = Double.parseDouble(request.getParameter("bandwidthCapacity"));
        String status = request.getParameter("status");

        // CT - Algorithm Design: validate rules before saving the edge in the graph.
        if (sourceDeviceId == targetDeviceId) {
            request.setAttribute("error", "Source and target devices must be different.");
            forwardTopology(request, response);
            return;
        }

        if (bandwidthCapacity <= 0) {
            request.setAttribute("error", "Bandwidth capacity must be greater than 0.");
            forwardTopology(request, response);
            return;
        }

        NetworkLink link = new NetworkLink();
        link.setSourceDeviceId(sourceDeviceId);
        link.setTargetDeviceId(targetDeviceId);
        link.setLinkType(linkType);
        link.setBandwidthCapacity(bandwidthCapacity);
        link.setStatus(status);

        networkLinkDAO.insertLink(link);
        response.sendRedirect("topology");
    }

    private void deleteLink(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int linkId = Integer.parseInt(request.getParameter("id"));
        networkLinkDAO.deleteLink(linkId);
        response.sendRedirect("topology");
    }

    private void forwardTopology(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("deviceList", deviceDAO.getAllDevices());
            request.setAttribute("linkList", networkLinkDAO.getAllLinks());
        } catch (Exception ignored) {
        }
        request.getRequestDispatcher("topology/simulation.jsp").forward(request, response);
    }
}
```

---

## 11. Code Template: `topology/simulation.jsp`

Location:

```text
Web Pages/topology/simulation.jsp
```

Code:

```jsp
<%@page import="com.networksim.model.NetworkLink"%>
<%@page import="com.networksim.model.Device"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Device> deviceList = (List<Device>) request.getAttribute("deviceList");
    List<NetworkLink> linkList = (List<NetworkLink>) request.getAttribute("linkList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Network Topology Simulation</title>
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
        .section {
            margin-bottom: 24px;
        }
        label {
            display: inline-block;
            margin-top: 8px;
            margin-right: 6px;
            font-weight: bold;
        }
        select, input {
            padding: 7px;
            margin-right: 10px;
        }
        button, .btn {
            display: inline-block;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            background-color: #1f6feb;
            cursor: pointer;
        }
        .btn-danger {
            background-color: #b00020;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .error {
            color: #b00020;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 9px;
            text-align: left;
        }
        th {
            background-color: #0d1117;
            color: white;
        }
        #topologyCanvas {
            position: relative;
            width: 100%;
            height: 480px;
            border: 1px solid #ccc;
            background-color: #ffffff;
            overflow: hidden;
        }
        .device-node {
            position: absolute;
            width: 120px;
            min-height: 50px;
            padding: 8px;
            text-align: center;
            color: white;
            background-color: #1f6feb;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.25);
            z-index: 2;
        }
        .device-node.offline {
            background-color: #6c757d;
        }
        .device-node.maintenance {
            background-color: #f59e0b;
        }
        svg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }
        .link-active {
            stroke: #16a34a;
        }
        .link-down {
            stroke: #b00020;
            stroke-dasharray: 6, 4;
        }
        .link-degraded {
            stroke: #f59e0b;
            stroke-dasharray: 4, 4;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Network Topology Simulation</h2>

        <p>
            <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
            <a class="btn btn-secondary" href="devices">Manage Devices</a>
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <div class="section">
            <h3>Create Network Link</h3>
            <form action="topology" method="post">
                <input type="hidden" name="action" value="insert">

                <label for="sourceDeviceId">Source</label>
                <select id="sourceDeviceId" name="sourceDeviceId" required>
                    <% if (deviceList != null) { %>
                        <% for (Device device : deviceList) { %>
                            <option value="<%= device.getDeviceId() %>"><%= device.getDeviceName() %></option>
                        <% } %>
                    <% } %>
                </select>

                <label for="targetDeviceId">Target</label>
                <select id="targetDeviceId" name="targetDeviceId" required>
                    <% if (deviceList != null) { %>
                        <% for (Device device : deviceList) { %>
                            <option value="<%= device.getDeviceId() %>"><%= device.getDeviceName() %></option>
                        <% } %>
                    <% } %>
                </select>

                <label for="linkType">Type</label>
                <select id="linkType" name="linkType" required>
                    <option value="ETHERNET">Ethernet</option>
                    <option value="FIBER">Fiber</option>
                    <option value="WIRELESS">Wireless</option>
                </select>

                <label for="bandwidthCapacity">Bandwidth Mbps</label>
                <input type="number" id="bandwidthCapacity" name="bandwidthCapacity" min="1" step="0.01" required>

                <label for="status">Status</label>
                <select id="status" name="status" required>
                    <option value="ACTIVE">Active</option>
                    <option value="DOWN">Down</option>
                    <option value="DEGRADED">Degraded</option>
                </select>

                <button type="submit">Create Link</button>
            </form>
        </div>

        <div class="section">
            <h3>Topology Diagram</h3>
            <div id="topologyCanvas">
                <svg id="linkLayer"></svg>
            </div>
        </div>

        <div class="section">
            <h3>Network Links</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Source</th>
                        <th>Target</th>
                        <th>Type</th>
                        <th>Bandwidth</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (linkList != null && !linkList.isEmpty()) { %>
                        <% for (NetworkLink link : linkList) { %>
                            <tr>
                                <td><%= link.getLinkId() %></td>
                                <td><%= link.getSourceDeviceName() %></td>
                                <td><%= link.getTargetDeviceName() %></td>
                                <td><%= link.getLinkType() %></td>
                                <td><%= link.getBandwidthCapacity() %> Mbps</td>
                                <td><%= link.getStatus() %></td>
                                <td>
                                    <a class="btn btn-danger" href="topology?action=delete&id=<%= link.getLinkId() %>"
                                       onclick="return confirm('Delete this network link?');">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7">No links found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        var devices = [
            <% if (deviceList != null) { %>
                <% for (int i = 0; i < deviceList.size(); i++) { %>
                    <% Device device = deviceList.get(i); %>
                    {
                        id: <%= device.getDeviceId() %>,
                        name: "<%= device.getDeviceName() %>",
                        type: "<%= device.getDeviceType() %>",
                        status: "<%= device.getStatus() %>"
                    }<%= i < deviceList.size() - 1 ? "," : "" %>
                <% } %>
            <% } %>
        ];

        var links = [
            <% if (linkList != null) { %>
                <% for (int i = 0; i < linkList.size(); i++) { %>
                    <% NetworkLink link = linkList.get(i); %>
                    {
                        sourceId: <%= link.getSourceDeviceId() %>,
                        targetId: <%= link.getTargetDeviceId() %>,
                        status: "<%= link.getStatus() %>",
                        type: "<%= link.getLinkType() %>",
                        bandwidth: <%= link.getBandwidthCapacity() %>
                    }<%= i < linkList.size() - 1 ? "," : "" %>
                <% } %>
            <% } %>
        ];

        function renderTopology() {
            // CT - Algorithm Design: place nodes first, then draw edges using node positions.
            var canvas = document.getElementById('topologyCanvas');
            var svg = document.getElementById('linkLayer');
            var width = canvas.clientWidth;
            var height = canvas.clientHeight;
            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(width, height) / 2 - 90;
            var positions = {};

            var oldNodes = canvas.getElementsByClassName('device-node');
            while (oldNodes.length > 0) {
                oldNodes[0].parentNode.removeChild(oldNodes[0]);
            }
            svg.innerHTML = '';

            for (var i = 0; i < devices.length; i++) {
                var angle = (2 * Math.PI * i) / Math.max(devices.length, 1);
                var x = centerX + radius * Math.cos(angle) - 60;
                var y = centerY + radius * Math.sin(angle) - 25;

                positions[devices[i].id] = {
                    x: x + 60,
                    y: y + 25
                };

                var node = document.createElement('div');
                node.className = 'device-node';

                if (devices[i].status === 'OFFLINE') {
                    node.className += ' offline';
                } else if (devices[i].status === 'MAINTENANCE') {
                    node.className += ' maintenance';
                }

                node.style.left = x + 'px';
                node.style.top = y + 'px';
                node.innerHTML = '<strong>' + devices[i].name + '</strong><br>'
                        + devices[i].type + '<br>' + devices[i].status;
                canvas.appendChild(node);
            }

            for (var j = 0; j < links.length; j++) {
                var source = positions[links[j].sourceId];
                var target = positions[links[j].targetId];

                if (source && target) {
                    var line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                    line.setAttribute('x1', source.x);
                    line.setAttribute('y1', source.y);
                    line.setAttribute('x2', target.x);
                    line.setAttribute('y2', target.y);
                    line.setAttribute('stroke-width', '3');

                    if (links[j].status === 'DOWN') {
                        line.setAttribute('class', 'link-down');
                    } else if (links[j].status === 'DEGRADED') {
                        line.setAttribute('class', 'link-degraded');
                    } else {
                        line.setAttribute('class', 'link-active');
                    }

                    svg.appendChild(line);
                }
            }
        }

        window.onload = renderTopology;
        window.onresize = renderTopology;
    </script>
</body>
</html>
```

Important note:

> This renderer is intentionally simple. It places devices in a circle and draws SVG lines between them. This is enough to demonstrate topology simulation without adding external JavaScript libraries.

---

## 12. Add Link from Dashboard

Update `dashboard.jsp` and add this link:

```jsp
<li><a href="topology">Network Topology Simulation</a></li>
```

Example module list:

```jsp
<ul>
    <li><a href="devices">Device & Node Management</a></li>
    <li><a href="topology">Network Topology Simulation</a></li>
    <li>Bandwidth & Coverage Monitoring</li>
    <li>Maintenance Scheduling</li>
    <li>Reports</li>
</ul>
```

---

## 13. Validation Rules

| Rule | Where to Apply | Reason |
|---|---|---|
| Source and target cannot be the same | Servlet + optional DB CHECK | A device should not link to itself |
| Bandwidth must be greater than 0 | JSP input + Servlet | Prevent invalid capacity |
| Link type must be valid | JSP select | Avoid inconsistent data |
| Link status must be valid | JSP select | Keep diagram colors predictable |
| Devices must exist before creating links | FK constraints | Prevent broken topology |

---

## 14. How to Run in NetBeans

1. Make sure Login MVC works.
2. Make sure Device CRUD works.
3. Confirm at least two devices exist in the `devices` table.
4. Confirm `network_links` table exists.
5. Create `NetworkLink.java`.
6. Create `NetworkLinkDAO.java`.
7. Create `TopologyServlet.java`.
8. Create `topology/simulation.jsp`.
9. Add the dashboard link.
10. Right-click project.
11. Select **Clean and Build**.
12. Right-click project.
13. Select **Run**.
14. Login.
15. Open:

```text
http://localhost:8080/NetworkSimulationManagement/topology
```

Expected result:

```text
The page shows a topology diagram with device nodes and connection lines.
```

---

## 15. Topology Test Cases

| Test Case | Action | Expected Result |
|---|---|---|
| Load topology | Open `/topology` | Devices and links appear |
| Add valid Ethernet link | Select two different devices | New link appears in table and diagram |
| Add same source and target | Select same device twice | Error message appears |
| Add zero bandwidth | Enter `0` | Browser or Servlet rejects input |
| Delete link | Click Delete | Link disappears from table and diagram |
| No devices | Empty devices table | Form has no useful choices and diagram is empty |
| Link status ACTIVE | Create active link | Green solid line appears |
| Link status DOWN | Create down link | Red dashed line appears |
| Link status DEGRADED | Create degraded link | Orange dashed line appears |

---

## 16. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| `/topology` gives 404 | Servlet mapping missing | Check `@WebServlet("/topology")` |
| Diagram is empty | No devices or JS error | Check `devices` data and browser console |
| Link insert fails | Source/target device ID missing | Make sure devices exist |
| Same-device link error | Source and target selected same value | Choose two different devices |
| SQL foreign key error | Device ID does not exist | Recreate sample devices and links |
| JSP compile error | Package/import typo | Check `NetworkLink` and `Device` imports |
| JavaScript breaks with special characters | Device name contains quotes | Avoid quotes in sample device names for beginner version |
| Lines do not align after resize | Browser layout changed | Refresh page or check `window.onresize` |
| `jakarta.servlet` compile error | Wrong tutorial copied | Use `javax.servlet.*` |

---

## 17. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Backend DAO lead | `NetworkLink.java`, `NetworkLinkDAO.java` |
| Member 2 | Servlet/controller lead | `TopologyServlet.java`, validation logic |
| Member 3 | Frontend simulation lead | `topology/simulation.jsp`, SVG/JS diagram |
| Member 4 | Testing + documentation lead | Flowchart, sequence diagrams, test screenshots |

Parallel workflow:

```text
Member 1 prepares model and DAO
Member 3 builds topology JSP and diagram layout
Member 2 connects controller logic and validation
Member 4 tests link creation/deletion and documents results
```

---

## 18. Report Explanation Paragraph

The team can use this explanation in the report:

```text
The Network Topology Simulation module applies Computational Thinking by decomposing the network into devices and links. Devices are treated as nodes, while network links are treated as edges in a graph. Pattern recognition is applied because every topology connection follows the same source-device to target-device structure. Abstraction is used by storing only the information required for simulation, such as link type, bandwidth capacity, and link status, instead of real hardware-level configuration. The algorithm loads all devices and links from the database, places devices around a diagram area, and draws lines between connected devices using JavaScript and SVG.
```

---

## 19. Topology Completion Checklist

- [ ] `network_links` table exists
- [ ] At least two devices exist
- [ ] `NetworkLink.java` created
- [ ] `NetworkLinkDAO.java` created
- [ ] `TopologyServlet.java` created
- [ ] `topology/simulation.jsp` created
- [ ] Dashboard links to `/topology`
- [ ] `/topology` loads devices
- [ ] `/topology` loads links
- [ ] Link creation works
- [ ] Same-device link is rejected
- [ ] Zero/negative bandwidth is rejected
- [ ] Link delete works
- [ ] Diagram displays device nodes
- [ ] Diagram displays SVG link lines
- [ ] Link color/status behavior works
- [ ] Flowchart completed
- [ ] Sequence diagrams completed
- [ ] Test screenshots saved for report

---

## 20. Next Recommended Feature

After topology simulation works, implement:

```text
Bandwidth & Coverage Monitoring
```

Reason:

> Once the system has devices and links, it can start showing simulated performance data such as download speed, upload speed, latency, packet loss, signal strength, and coverage percentage.

Recommended next document:

```text
PRJ301_Bandwidth_Coverage_Monitoring.md
```
