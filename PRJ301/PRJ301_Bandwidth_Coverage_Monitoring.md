---
title: PRJ301 Bandwidth and Coverage Monitoring
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Bandwidth and Coverage Monitoring

## 1. Current Focus

This document guides the team through implementing:

```text
Bandwidth & Coverage Monitoring
```

This module records and displays simulated network performance data:

- download speed
- upload speed
- latency
- packet loss
- wireless signal strength
- coverage percentage

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

> Keep using `javax.servlet.*`. Do not use `jakarta.servlet.*`.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break monitoring into smaller parts:

| Part | Responsibility | Main Files |
|---|---|---|
| Bandwidth log model | Store bandwidth test data | `BandwidthLog.java` |
| Coverage model | Store signal coverage data | `CoverageArea.java` |
| Bandwidth DAO | Read/write bandwidth logs | `BandwidthDAO.java` |
| Coverage DAO | Read/write coverage records | `CoverageDAO.java` |
| Monitoring controller | Route dashboard and add actions | `MonitoringServlet.java` |
| Dashboard page | Show latest logs and status | `monitoring/dashboard.jsp` |
| Bandwidth form | Add simulated bandwidth test | `monitoring/add-bandwidth.jsp` |
| Coverage form | Add simulated coverage test | `monitoring/add-coverage.jsp` |

Why this matters:

> Monitoring sounds advanced, but in this student project it is mainly collecting records, applying simple rules, and showing status clearly.

---

## 2.2 Pattern Recognition

Both bandwidth and coverage follow the same pattern:

```text
Device → Measurement → Status interpretation → Display result
```

Repeated data pattern:

| Pattern | Bandwidth | Coverage |
|---|---|---|
| Related device | `device_id` | `device_id` |
| Numeric values | speed, latency, packet loss | signal strength, coverage percent |
| Measurement time | `measured_at` | `measured_at` |
| Warning rule | high latency / packet loss | weak signal / low coverage |

---

## 2.3 Abstraction

For PRJ301, simulate monitoring instead of connecting to real network hardware.

| Include Now | Ignore for Now |
|---|---|
| Manual bandwidth input | Real speed test API |
| Manual signal input | Real Wi-Fi scanning |
| Simple warning rules | SNMP polling |
| Latest records table | Real-time WebSocket dashboard |
| Device relationship | Hardware drivers |

---

## 2.4 Algorithm Design

Monitoring dashboard algorithm:

```text
Start
  ↓
User opens /monitoring
  ↓
MonitoringServlet loads devices
  ↓
Servlet loads latest bandwidth logs
  ↓
Servlet loads latest coverage records
  ↓
Forward data to monitoring/dashboard.jsp
  ↓
JSP displays records and status labels
End
```

Add bandwidth log algorithm:

```text
Start
  ↓
User opens add bandwidth form
  ↓
User selects device and enters values
  ↓
Submit to /monitoring?action=insertBandwidth
  ↓
Servlet validates numeric values
  ↓
DAO inserts bandwidth log
  ↓
Redirect to /monitoring
End
```

Add coverage record algorithm:

```text
Start
  ↓
User opens add coverage form
  ↓
User selects device and enters area/signal/coverage
  ↓
Submit to /monitoring?action=insertCoverage
  ↓
Servlet calculates status GOOD/WEAK/NO_SIGNAL
  ↓
DAO inserts coverage record
  ↓
Redirect to /monitoring
End
```

---

## 3. Monitoring Flowchart

```text
+-------+
| Start |
+---+---+
    |
    v
+----------------------+
| User opens monitoring|
+----------+-----------+
           |
           v
+----------------------+
| MonitoringServlet    |
| checks action        |
+----+-------------+---+
     |             |
     v             v
 Dashboard      Add record
     |             |
     v             v
+----------+   +----------------+
| Load logs|   | Validate input |
| + areas  |   +-------+--------+
+----+-----+           |
     |                 v
     v          +--------------+
+-----------+   | Insert record|
| dashboard |   +------+-------+
| JSP       |          |
+-----+-----+          v
      |          +-------------+
      v          | Redirect    |
+-----+          | monitoring  |
| End |          +-------------+
+-----+
```

---

## 4. Sequence Diagrams

Dashboard sequence:

```text
User → Browser: open /monitoring
Browser → MonitoringServlet: GET /monitoring
MonitoringServlet → DeviceDAO: getAllDevices()
MonitoringServlet → BandwidthDAO: getLatestLogs()
MonitoringServlet → CoverageDAO: getLatestCoverageAreas()
MonitoringServlet → dashboard.jsp: forward devices, bandwidthLogs, coverageAreas
JSP → Browser: render monitoring dashboard
```

Add bandwidth sequence:

```text
User → add-bandwidth.jsp: enter test result
add-bandwidth.jsp → MonitoringServlet: POST /monitoring?action=insertBandwidth
MonitoringServlet → BandwidthDAO: insertBandwidthLog(log)
BandwidthDAO → MySQL: INSERT INTO bandwidth_logs
MonitoringServlet → Browser: redirect /monitoring
```

Add coverage sequence:

```text
User → add-coverage.jsp: enter signal result
add-coverage.jsp → MonitoringServlet: POST /monitoring?action=insertCoverage
MonitoringServlet → MonitoringServlet: calculate coverage status
MonitoringServlet → CoverageDAO: insertCoverageArea(area)
CoverageDAO → MySQL: INSERT INTO coverage_areas
MonitoringServlet → Browser: redirect /monitoring
```

---

## 5. Files to Create in NetBeans

Source Packages:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   ├── BandwidthLog.java
    │   └── CoverageArea.java
    ├── dao/
    │   ├── BandwidthDAO.java
    │   └── CoverageDAO.java
    └── controller/
        └── MonitoringServlet.java
```

Web Pages:

```text
Web Pages/
└── monitoring/
    ├── dashboard.jsp
    ├── add-bandwidth.jsp
    └── add-coverage.jsp
```

Existing required files:

```text
Device.java
DeviceDAO.java
DBContext.java
```

---

## 6. Database Tables Used

Bandwidth table:

```sql
CREATE TABLE bandwidth_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    download_speed DECIMAL(10,2) NOT NULL DEFAULT 0,
    upload_speed DECIMAL(10,2) NOT NULL DEFAULT 0,
    latency_ms DECIMAL(10,2) NOT NULL DEFAULT 0,
    packet_loss DECIMAL(5,2) NOT NULL DEFAULT 0,
    measured_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bandwidth_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id)
);
```

Coverage table:

```sql
CREATE TABLE coverage_areas (
    coverage_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    area_name VARCHAR(100) NOT NULL,
    signal_strength DECIMAL(6,2) NOT NULL DEFAULT 0,
    coverage_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'GOOD',
    measured_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_coverage_device
        FOREIGN KEY (device_id) REFERENCES devices(device_id)
);
```

---

## 7. Monitoring Status Rules

Bandwidth warning rules:

| Condition | Status |
|---|---|
| `latency_ms >= 100` | High latency warning |
| `packet_loss >= 5` | Packet loss warning |
| both conditions false | Normal |

Coverage rules:

| Condition | Status |
|---|---|
| `coverage_percent < 40` or `signal_strength <= -85` | `NO_SIGNAL` |
| `coverage_percent < 70` or `signal_strength <= -70` | `WEAK` |
| otherwise | `GOOD` |

---

## 8. Code Template: `BandwidthLog.java`

Location:

```text
Source Packages/com/networksim/model/BandwidthLog.java
```

```java
package com.networksim.model;

import java.util.Date;

public class BandwidthLog {

    private int logId;
    private int deviceId;
    private String deviceName;
    private double downloadSpeed;
    private double uploadSpeed;
    private double latencyMs;
    private double packetLoss;
    private Date measuredAt;

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public double getDownloadSpeed() { return downloadSpeed; }
    public void setDownloadSpeed(double downloadSpeed) { this.downloadSpeed = downloadSpeed; }

    public double getUploadSpeed() { return uploadSpeed; }
    public void setUploadSpeed(double uploadSpeed) { this.uploadSpeed = uploadSpeed; }

    public double getLatencyMs() { return latencyMs; }
    public void setLatencyMs(double latencyMs) { this.latencyMs = latencyMs; }

    public double getPacketLoss() { return packetLoss; }
    public void setPacketLoss(double packetLoss) { this.packetLoss = packetLoss; }

    public Date getMeasuredAt() { return measuredAt; }
    public void setMeasuredAt(Date measuredAt) { this.measuredAt = measuredAt; }

    public boolean hasWarning() {
        return latencyMs >= 100 || packetLoss >= 5;
    }
}
```

---

## 9. Code Template: `CoverageArea.java`

Location:

```text
Source Packages/com/networksim/model/CoverageArea.java
```

```java
package com.networksim.model;

import java.util.Date;

public class CoverageArea {

    private int coverageId;
    private int deviceId;
    private String deviceName;
    private String areaName;
    private double signalStrength;
    private double coveragePercent;
    private String status;
    private Date measuredAt;

    public int getCoverageId() { return coverageId; }
    public void setCoverageId(int coverageId) { this.coverageId = coverageId; }

    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }

    public double getSignalStrength() { return signalStrength; }
    public void setSignalStrength(double signalStrength) { this.signalStrength = signalStrength; }

    public double getCoveragePercent() { return coveragePercent; }
    public void setCoveragePercent(double coveragePercent) { this.coveragePercent = coveragePercent; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getMeasuredAt() { return measuredAt; }
    public void setMeasuredAt(Date measuredAt) { this.measuredAt = measuredAt; }
}
```

---

## 10. Code Template: `BandwidthDAO.java`

Location:

```text
Source Packages/com/networksim/dao/BandwidthDAO.java
```

```java
package com.networksim.dao;

import com.networksim.model.BandwidthLog;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BandwidthDAO {

    public List<BandwidthLog> getLatestLogs() throws Exception {
        List<BandwidthLog> logs = new ArrayList<BandwidthLog>();
        String sql = "SELECT bl.log_id, bl.device_id, d.device_name, bl.download_speed, "
                + "bl.upload_speed, bl.latency_ms, bl.packet_loss, bl.measured_at "
                + "FROM bandwidth_logs bl JOIN devices d ON bl.device_id = d.device_id "
                + "ORDER BY bl.measured_at DESC LIMIT 20";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                BandwidthLog log = new BandwidthLog();
                log.setLogId(rs.getInt("log_id"));
                log.setDeviceId(rs.getInt("device_id"));
                log.setDeviceName(rs.getString("device_name"));
                log.setDownloadSpeed(rs.getDouble("download_speed"));
                log.setUploadSpeed(rs.getDouble("upload_speed"));
                log.setLatencyMs(rs.getDouble("latency_ms"));
                log.setPacketLoss(rs.getDouble("packet_loss"));
                log.setMeasuredAt(rs.getTimestamp("measured_at"));
                logs.add(log);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return logs;
    }

    public void insertBandwidthLog(BandwidthLog log) throws Exception {
        String sql = "INSERT INTO bandwidth_logs (device_id, download_speed, upload_speed, latency_ms, packet_loss) "
                + "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, log.getDeviceId());
            ps.setDouble(2, log.getDownloadSpeed());
            ps.setDouble(3, log.getUploadSpeed());
            ps.setDouble(4, log.getLatencyMs());
            ps.setDouble(5, log.getPacketLoss());
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

## 11. Code Template: `CoverageDAO.java`

Location:

```text
Source Packages/com/networksim/dao/CoverageDAO.java
```

```java
package com.networksim.dao;

import com.networksim.model.CoverageArea;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CoverageDAO {

    public List<CoverageArea> getLatestCoverageAreas() throws Exception {
        List<CoverageArea> areas = new ArrayList<CoverageArea>();
        String sql = "SELECT ca.coverage_id, ca.device_id, d.device_name, ca.area_name, "
                + "ca.signal_strength, ca.coverage_percent, ca.status, ca.measured_at "
                + "FROM coverage_areas ca JOIN devices d ON ca.device_id = d.device_id "
                + "ORDER BY ca.measured_at DESC LIMIT 20";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                CoverageArea area = new CoverageArea();
                area.setCoverageId(rs.getInt("coverage_id"));
                area.setDeviceId(rs.getInt("device_id"));
                area.setDeviceName(rs.getString("device_name"));
                area.setAreaName(rs.getString("area_name"));
                area.setSignalStrength(rs.getDouble("signal_strength"));
                area.setCoveragePercent(rs.getDouble("coverage_percent"));
                area.setStatus(rs.getString("status"));
                area.setMeasuredAt(rs.getTimestamp("measured_at"));
                areas.add(area);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return areas;
    }

    public void insertCoverageArea(CoverageArea area) throws Exception {
        String sql = "INSERT INTO coverage_areas (device_id, area_name, signal_strength, coverage_percent, status) "
                + "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, area.getDeviceId());
            ps.setString(2, area.getAreaName());
            ps.setDouble(3, area.getSignalStrength());
            ps.setDouble(4, area.getCoveragePercent());
            ps.setString(5, area.getStatus());
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

## 12. Code Template: `MonitoringServlet.java`

Location:

```text
Source Packages/com/networksim/controller/MonitoringServlet.java
```

```java
package com.networksim.controller;

import com.networksim.dao.BandwidthDAO;
import com.networksim.dao.CoverageDAO;
import com.networksim.dao.DeviceDAO;
import com.networksim.model.BandwidthLog;
import com.networksim.model.CoverageArea;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MonitoringServlet", urlPatterns = {"/monitoring"})
public class MonitoringServlet extends HttpServlet {

    private DeviceDAO deviceDAO;
    private BandwidthDAO bandwidthDAO;
    private CoverageDAO coverageDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
        bandwidthDAO = new BandwidthDAO();
        coverageDAO = new CoverageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("addBandwidth".equals(action)) {
                request.setAttribute("deviceList", deviceDAO.getAllDevices());
                request.getRequestDispatcher("monitoring/add-bandwidth.jsp").forward(request, response);
            } else if ("addCoverage".equals(action)) {
                request.setAttribute("deviceList", deviceDAO.getAllDevices());
                request.getRequestDispatcher("monitoring/add-coverage.jsp").forward(request, response);
            } else {
                showDashboard(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot load monitoring data.");
            request.getRequestDispatcher("monitoring/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            if ("insertBandwidth".equals(action)) {
                insertBandwidth(request, response);
            } else if ("insertCoverage".equals(action)) {
                insertCoverage(request, response);
            } else {
                response.sendRedirect("monitoring");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Cannot save monitoring data. Please check your input.");
            try {
                request.setAttribute("deviceList", deviceDAO.getAllDevices());
            } catch (Exception ignored) {
            }
            request.getRequestDispatcher("monitoring/dashboard.jsp").forward(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("bandwidthLogs", bandwidthDAO.getLatestLogs());
        request.setAttribute("coverageAreas", coverageDAO.getLatestCoverageAreas());
        request.getRequestDispatcher("monitoring/dashboard.jsp").forward(request, response);
    }

    private void insertBandwidth(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        BandwidthLog log = new BandwidthLog();
        log.setDeviceId(Integer.parseInt(request.getParameter("deviceId")));
        log.setDownloadSpeed(Double.parseDouble(request.getParameter("downloadSpeed")));
        log.setUploadSpeed(Double.parseDouble(request.getParameter("uploadSpeed")));
        log.setLatencyMs(Double.parseDouble(request.getParameter("latencyMs")));
        log.setPacketLoss(Double.parseDouble(request.getParameter("packetLoss")));

        if (log.getDownloadSpeed() < 0 || log.getUploadSpeed() < 0
                || log.getLatencyMs() < 0 || log.getPacketLoss() < 0) {
            request.setAttribute("error", "Monitoring values cannot be negative.");
            request.setAttribute("deviceList", deviceDAO.getAllDevices());
            request.getRequestDispatcher("monitoring/add-bandwidth.jsp").forward(request, response);
            return;
        }

        bandwidthDAO.insertBandwidthLog(log);
        response.sendRedirect("monitoring");
    }

    private void insertCoverage(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        CoverageArea area = new CoverageArea();
        area.setDeviceId(Integer.parseInt(request.getParameter("deviceId")));
        area.setAreaName(request.getParameter("areaName"));
        area.setSignalStrength(Double.parseDouble(request.getParameter("signalStrength")));
        area.setCoveragePercent(Double.parseDouble(request.getParameter("coveragePercent")));
        area.setStatus(calculateCoverageStatus(area.getSignalStrength(), area.getCoveragePercent()));

        if (area.getCoveragePercent() < 0 || area.getCoveragePercent() > 100) {
            request.setAttribute("error", "Coverage percent must be between 0 and 100.");
            request.setAttribute("deviceList", deviceDAO.getAllDevices());
            request.getRequestDispatcher("monitoring/add-coverage.jsp").forward(request, response);
            return;
        }

        coverageDAO.insertCoverageArea(area);
        response.sendRedirect("monitoring");
    }

    private String calculateCoverageStatus(double signalStrength, double coveragePercent) {
        // CT - Algorithm Design: convert raw numbers into a simple status.
        if (coveragePercent < 40 || signalStrength <= -85) {
            return "NO_SIGNAL";
        }
        if (coveragePercent < 70 || signalStrength <= -70) {
            return "WEAK";
        }
        return "GOOD";
    }
}
```

---

## 13. Code Template: `monitoring/dashboard.jsp`

Location:

```text
Web Pages/monitoring/dashboard.jsp
```

```jsp
<%@page import="com.networksim.model.CoverageArea"%>
<%@page import="com.networksim.model.BandwidthLog"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<BandwidthLog> bandwidthLogs = (List<BandwidthLog>) request.getAttribute("bandwidthLogs");
    List<CoverageArea> coverageAreas = (List<CoverageArea>) request.getAttribute("coverageAreas");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bandwidth & Coverage Monitoring</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 24px; }
        .container { background: white; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; margin-bottom: 24px; }
        th, td { border: 1px solid #ddd; padding: 9px; text-align: left; }
        th { background: #0d1117; color: white; }
        .btn { display: inline-block; padding: 8px 12px; border-radius: 4px; background: #1f6feb; color: white; text-decoration: none; }
        .btn-secondary { background: #6c757d; }
        .normal, .good { color: #16a34a; font-weight: bold; }
        .warning, .weak { color: #f59e0b; font-weight: bold; }
        .danger, .no-signal { color: #b00020; font-weight: bold; }
        .error { color: #b00020; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>Bandwidth & Coverage Monitoring</h2>

    <p>
        <a class="btn" href="monitoring?action=addBandwidth">Add Bandwidth Log</a>
        <a class="btn" href="monitoring?action=addCoverage">Add Coverage Record</a>
        <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
    </p>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <h3>Latest Bandwidth Logs</h3>
    <table>
        <tr>
            <th>Device</th>
            <th>Download</th>
            <th>Upload</th>
            <th>Latency</th>
            <th>Packet Loss</th>
            <th>Status</th>
            <th>Measured At</th>
        </tr>
        <% if (bandwidthLogs != null && !bandwidthLogs.isEmpty()) { %>
            <% for (BandwidthLog log : bandwidthLogs) { %>
                <tr>
                    <td><%= log.getDeviceName() %></td>
                    <td><%= log.getDownloadSpeed() %> Mbps</td>
                    <td><%= log.getUploadSpeed() %> Mbps</td>
                    <td><%= log.getLatencyMs() %> ms</td>
                    <td><%= log.getPacketLoss() %>%</td>
                    <td>
                        <% if (log.hasWarning()) { %>
                            <span class="warning">WARNING</span>
                        <% } else { %>
                            <span class="normal">NORMAL</span>
                        <% } %>
                    </td>
                    <td><%= log.getMeasuredAt() %></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="7">No bandwidth logs found.</td></tr>
        <% } %>
    </table>

    <h3>Latest Coverage Records</h3>
    <table>
        <tr>
            <th>Device</th>
            <th>Area</th>
            <th>Signal Strength</th>
            <th>Coverage</th>
            <th>Status</th>
            <th>Measured At</th>
        </tr>
        <% if (coverageAreas != null && !coverageAreas.isEmpty()) { %>
            <% for (CoverageArea area : coverageAreas) { %>
                <tr>
                    <td><%= area.getDeviceName() %></td>
                    <td><%= area.getAreaName() %></td>
                    <td><%= area.getSignalStrength() %> dBm</td>
                    <td><%= area.getCoveragePercent() %>%</td>
                    <td>
                        <% if ("GOOD".equals(area.getStatus())) { %>
                            <span class="good">GOOD</span>
                        <% } else if ("WEAK".equals(area.getStatus())) { %>
                            <span class="weak">WEAK</span>
                        <% } else { %>
                            <span class="no-signal">NO SIGNAL</span>
                        <% } %>
                    </td>
                    <td><%= area.getMeasuredAt() %></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="6">No coverage records found.</td></tr>
        <% } %>
    </table>
</div>
</body>
</html>
```

---

## 14. Code Template: `monitoring/add-bandwidth.jsp`

Location:

```text
Web Pages/monitoring/add-bandwidth.jsp
```

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
    <title>Add Bandwidth Log</title>
</head>
<body>
    <h2>Add Bandwidth Log</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="monitoring" method="post">
        <input type="hidden" name="action" value="insertBandwidth">

        <label>Device</label>
        <select name="deviceId" required>
            <% if (deviceList != null) { %>
                <% for (Device device : deviceList) { %>
                    <option value="<%= device.getDeviceId() %>"><%= device.getDeviceName() %></option>
                <% } %>
            <% } %>
        </select><br><br>

        <label>Download Speed Mbps</label>
        <input type="number" name="downloadSpeed" min="0" step="0.01" required><br><br>

        <label>Upload Speed Mbps</label>
        <input type="number" name="uploadSpeed" min="0" step="0.01" required><br><br>

        <label>Latency ms</label>
        <input type="number" name="latencyMs" min="0" step="0.01" required><br><br>

        <label>Packet Loss %</label>
        <input type="number" name="packetLoss" min="0" max="100" step="0.01" required><br><br>

        <button type="submit">Save</button>
        <a href="monitoring">Cancel</a>
    </form>
</body>
</html>
```

---

## 15. Code Template: `monitoring/add-coverage.jsp`

Location:

```text
Web Pages/monitoring/add-coverage.jsp
```

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
    <title>Add Coverage Record</title>
</head>
<body>
    <h2>Add Coverage Record</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="monitoring" method="post">
        <input type="hidden" name="action" value="insertCoverage">

        <label>Device</label>
        <select name="deviceId" required>
            <% if (deviceList != null) { %>
                <% for (Device device : deviceList) { %>
                    <option value="<%= device.getDeviceId() %>"><%= device.getDeviceName() %></option>
                <% } %>
            <% } %>
        </select><br><br>

        <label>Area Name</label>
        <input type="text" name="areaName" required><br><br>

        <label>Signal Strength dBm</label>
        <input type="number" name="signalStrength" step="0.01" required><br><br>

        <label>Coverage Percent</label>
        <input type="number" name="coveragePercent" min="0" max="100" step="0.01" required><br><br>

        <button type="submit">Save</button>
        <a href="monitoring">Cancel</a>
    </form>
</body>
</html>
```

---

## 16. Add Link from Dashboard

Update `dashboard.jsp`:

```jsp
<li><a href="monitoring">Bandwidth & Coverage Monitoring</a></li>
```

Example:

```jsp
<ul>
    <li><a href="devices">Device & Node Management</a></li>
    <li><a href="topology">Network Topology Simulation</a></li>
    <li><a href="monitoring">Bandwidth & Coverage Monitoring</a></li>
    <li>Maintenance Scheduling</li>
    <li>Reports</li>
</ul>
```

---

## 17. Sample Data

```sql
INSERT INTO bandwidth_logs (device_id, download_speed, upload_speed, latency_ms, packet_loss)
VALUES
(1, 850.50, 740.20, 3.50, 0.10),
(2, 780.00, 700.00, 120.00, 0.20),
(4, 120.00, 80.00, 12.50, 6.50);

INSERT INTO coverage_areas (device_id, area_name, signal_strength, coverage_percent, status)
VALUES
(4, 'Floor 1 - Room A', -45.50, 95.00, 'GOOD'),
(4, 'Floor 1 - Room B', -72.00, 65.00, 'WEAK'),
(4, 'Floor 1 - Room C', -90.00, 30.00, 'NO_SIGNAL');
```

---

## 18. How to Run in NetBeans

1. Confirm Login MVC works.
2. Confirm Device CRUD works.
3. Confirm `bandwidth_logs` and `coverage_areas` tables exist.
4. Create model, DAO, Servlet, and JSP files.
5. Add dashboard link.
6. Right-click project → **Clean and Build**.
7. Right-click project → **Run**.
8. Login.
9. Open:

```text
http://localhost:8080/NetworkSimulationManagement/monitoring
```

Expected result:

```text
The monitoring dashboard shows latest bandwidth logs and coverage records.
```

---

## 19. Monitoring Test Cases

| Test Case | Action | Expected Result |
|---|---|---|
| Load monitoring dashboard | Open `/monitoring` | Bandwidth and coverage tables appear |
| Add normal bandwidth log | Low latency, low packet loss | Status shows NORMAL |
| Add high latency log | latency `100` or more | Status shows WARNING |
| Add packet loss warning | packet loss `5` or more | Status shows WARNING |
| Add good coverage | strong signal and high coverage | Status shows GOOD |
| Add weak coverage | signal `-70` or coverage below `70` | Status shows WEAK |
| Add no signal coverage | signal `-85` or coverage below `40` | Status shows NO SIGNAL |
| Negative bandwidth value | Enter negative number | Browser/Servlet rejects input |
| Coverage over 100 | Enter `120` | Browser/Servlet rejects input |

---

## 20. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| `/monitoring` gives 404 | Servlet mapping missing | Check `@WebServlet("/monitoring")` |
| Empty dashboard | No sample logs | Insert sample data or add records manually |
| FK error | Device does not exist | Create devices first |
| JSP compile error | Missing imports | Import `BandwidthLog`, `CoverageArea`, and `List` |
| Number format error | Blank or invalid numeric input | Use required number fields and validate in Servlet |
| Coverage status wrong | Rule order incorrect | Check `NO_SIGNAL` before `WEAK` |
| `jakarta.servlet` compile error | Wrong namespace | Replace with `javax.servlet.*` |

---

## 21. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Bandwidth backend lead | `BandwidthLog.java`, `BandwidthDAO.java` |
| Member 2 | Coverage backend lead | `CoverageArea.java`, `CoverageDAO.java` |
| Member 3 | Servlet + JSP lead | `MonitoringServlet.java`, monitoring JSP pages |
| Member 4 | Testing + report lead | Flowchart, sequence diagrams, screenshots, test cases |

Parallel workflow:

```text
Member 1 builds bandwidth model/DAO
Member 2 builds coverage model/DAO
Member 3 builds controller and JSP pages
Member 4 tests rules and documents screenshots
```

---

## 22. Report Explanation Paragraph

```text
The Bandwidth and Coverage Monitoring module applies Computational Thinking by decomposing network monitoring into two smaller measurement types: bandwidth logs and coverage records. Pattern recognition is used because both types store device-based measurements with timestamps. Abstraction is applied by simulating monitoring values instead of connecting to real hardware. Algorithm design is used to classify raw values into simple statuses such as NORMAL, WARNING, GOOD, WEAK, and NO_SIGNAL. This allows the system to demonstrate realistic monitoring behavior while remaining suitable for a Java Web student project.
```

---

## 23. Completion Checklist

- [ ] `bandwidth_logs` table exists
- [ ] `coverage_areas` table exists
- [ ] `BandwidthLog.java` created
- [ ] `CoverageArea.java` created
- [ ] `BandwidthDAO.java` created
- [ ] `CoverageDAO.java` created
- [ ] `MonitoringServlet.java` created
- [ ] `monitoring/dashboard.jsp` created
- [ ] `monitoring/add-bandwidth.jsp` created
- [ ] `monitoring/add-coverage.jsp` created
- [ ] Dashboard links to `/monitoring`
- [ ] Latest bandwidth logs display
- [ ] Latest coverage records display
- [ ] Bandwidth warning rules work
- [ ] Coverage status rules work
- [ ] Add bandwidth form works
- [ ] Add coverage form works
- [ ] Flowchart completed
- [ ] Sequence diagrams completed
- [ ] Test screenshots saved for report

---

## 24. Next Recommended Feature

After monitoring works, implement:

```text
Maintenance Scheduling & Alerts
```

Reason:

> Once devices can be monitored, the system should support planning maintenance and showing alerts when problems are detected.

Recommended next document:

```text
PRJ301_Maintenance_Alerts.md
```
