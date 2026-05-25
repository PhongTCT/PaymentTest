---
title: PRJ301 Report Generation
author: OpenClaude
date: 2026-05-25
project: Network Infrastructure Simulation Management System
course: PRJ301 Java Web Application Development
environment: NetBeans 13, JDK 8, Apache Tomcat 9, Ant, Servlet/JSP, MySQL 8
encoding: UTF-8
tags:
---

# PRJ301 Report Generation

## 1. Current Focus

This document guides the team through implementing:

```text
Report Generation
```

The report module summarizes important data from the whole Network Infrastructure Simulation Management System.

Simple idea:

```text
A report is a readable summary of system data.
```

For this PRJ301 project, the report module should summarize:

- total devices
- devices by status
- latest bandwidth results
- latest coverage results
- maintenance task status
- unread alerts

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

> Keep the implementation simple and compatible with Java 8. Do not use Spring, Maven, Docker, Tomcat 10, `jakarta.servlet.*`, records, `var`, or `Stream.toList()`.

---

## 2. Computational Thinking Analysis

## 2.1 Decomposition

Break report generation into smaller parts:

| Part | Responsibility | Main Files |
|---|---|---|
| Report model | Store summary values | `ReportSummary.java` |
| Report DAO | Query summary data from MySQL | `ReportDAO.java` |
| Report controller | Handle report page request | `ReportServlet.java` |
| Report JSP | Display summary tables/cards | `reports/dashboard.jsp` |
| Print/export view | Let browser print report | Same JSP with print CSS |

Why this matters:

> A report looks like a big final feature, but it is mostly a collection of smaller database summary queries.

---

## 2.2 Pattern Recognition

The report module reuses data from previous modules:

| Existing Module | Report Data Reused |
|---|---|
| Device CRUD | total devices, active/inactive devices |
| Topology Simulation | total network links |
| Bandwidth Monitoring | average download/upload speed, average latency |
| Coverage Monitoring | average signal strength, average coverage percentage |
| Maintenance Scheduling | pending/in-progress/completed maintenance tasks |
| Alerts | unread alerts and critical alerts |

Repeated pattern:

```text
Servlet → DAO summary query → ReportSummary object → JSP display
```

This is similar to other modules, but instead of showing all records, it shows calculated values.

---

## 2.3 Abstraction

For a student project, do not build a complex enterprise report system.

| Include Now | Ignore for Now |
|---|---|
| Summary dashboard | PDF generation library |
| Print button using browser print | Excel export |
| Simple cards and tables | Scheduled email reports |
| MySQL aggregate queries | BI dashboard tools |
| Report generated date | Advanced chart libraries |

Why:

> The goal is to prove the team can collect, process, and present system data clearly. Browser print is enough for PRJ301.

---

## 2.4 Algorithm Design

Report dashboard algorithm:

```text
Start
  ↓
User opens /reports
  ↓
ReportServlet receives GET request
  ↓
ReportDAO runs summary queries
  ↓
DAO fills ReportSummary object
  ↓
Servlet attaches summary to request
  ↓
Forward to reports/dashboard.jsp
  ↓
JSP displays report cards and tables
  ↓
User can click Print Report
End
```

Report query algorithm:

```text
Start
  ↓
Count devices
  ↓
Count devices by status
  ↓
Count network links
  ↓
Calculate bandwidth averages
  ↓
Calculate coverage averages
  ↓
Count maintenance tasks by status
  ↓
Count unread and critical alerts
  ↓
Return ReportSummary
End
```

---

## 3. Report Flowchart

Draw this in draw.io, Lucidchart, or StarUML:

```text
+-------+
| Start |
+---+---+
    |
    v
+--------------------+
| User opens /reports|
+---------+----------+
          |
          v
+--------------------+
| ReportServlet      |
| handles request    |
+---------+----------+
          |
          v
+--------------------+
| ReportDAO          |
| runs summary SQL   |
+---------+----------+
          |
          v
+--------------------+
| Build              |
| ReportSummary      |
+---------+----------+
          |
          v
+--------------------+
| Forward to         |
| dashboard.jsp      |
+---------+----------+
          |
          v
+--------------------+
| Display report     |
| cards and tables   |
+---------+----------+
          |
          v
+--------------------+
| User prints report |
+---------+----------+
          |
          v
+-------+
| End   |
+-------+
```

---

## 4. Sequence Diagram

```text
User → Browser: open /reports
Browser → ReportServlet: GET /reports
ReportServlet → ReportDAO: getReportSummary()
ReportDAO → MySQL: COUNT devices
MySQL → ReportDAO: device totals
ReportDAO → MySQL: AVG bandwidth values
MySQL → ReportDAO: bandwidth averages
ReportDAO → MySQL: AVG coverage values
MySQL → ReportDAO: coverage averages
ReportDAO → MySQL: COUNT maintenance statuses
MySQL → ReportDAO: maintenance totals
ReportDAO → MySQL: COUNT unread alerts
MySQL → ReportDAO: alert totals
ReportDAO → ReportServlet: ReportSummary
ReportServlet → reports/dashboard.jsp: forward summary
reports/dashboard.jsp → Browser: render report
```

---

## 5. Files to Create in NetBeans

## 5.1 Source Packages

Create these files:

```text
Source Packages/
└── com.networksim/
    ├── model/
    │   └── ReportSummary.java
    ├── dao/
    │   └── ReportDAO.java
    └── controller/
        └── ReportServlet.java
```

---

## 5.2 Web Pages

Create this folder and JSP:

```text
Web Pages/
└── reports/
    └── dashboard.jsp
```

NetBeans steps:

1. Right-click **Web Pages**.
2. Choose **New → Folder**.
3. Name it `reports`.
4. Right-click `reports`.
5. Choose **New → JSP**.
6. Name it `dashboard.jsp`.

---

## 6. Database Tables Used

This module reads from existing tables:

```text
users
devices
network_links
bandwidth_logs
coverage_areas
maintenance_tasks
alerts
```

No new table is required for the basic report module.

Optional table if the team wants to record generated reports:

```sql
CREATE TABLE generated_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_title VARCHAR(150) NOT NULL,
    generated_by INT,
    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    summary TEXT,
    CONSTRAINT fk_report_user
        FOREIGN KEY (generated_by) REFERENCES users(user_id)
);
```

Recommendation:

> For the first version, skip `generated_reports`. Build the live report dashboard first.

---

## 7. Code Template: `ReportSummary.java`

Location:

```text
Source Packages/com/networksim/model/ReportSummary.java
```

```java
package com.networksim.model;

import java.util.Date;

public class ReportSummary {

    private int totalDevices;
    private int activeDevices;
    private int inactiveDevices;
    private int maintenanceDevices;
    private int totalLinks;

    private double averageDownloadSpeed;
    private double averageUploadSpeed;
    private double averageLatency;
    private double averagePacketLoss;

    private double averageSignalStrength;
    private double averageCoveragePercentage;

    private int pendingMaintenance;
    private int inProgressMaintenance;
    private int completedMaintenance;
    private int cancelledMaintenance;

    private int unreadAlerts;
    private int criticalAlerts;
    private int warningAlerts;

    private Date generatedAt;

    public int getTotalDevices() { return totalDevices; }
    public void setTotalDevices(int totalDevices) { this.totalDevices = totalDevices; }

    public int getActiveDevices() { return activeDevices; }
    public void setActiveDevices(int activeDevices) { this.activeDevices = activeDevices; }

    public int getInactiveDevices() { return inactiveDevices; }
    public void setInactiveDevices(int inactiveDevices) { this.inactiveDevices = inactiveDevices; }

    public int getMaintenanceDevices() { return maintenanceDevices; }
    public void setMaintenanceDevices(int maintenanceDevices) { this.maintenanceDevices = maintenanceDevices; }

    public int getTotalLinks() { return totalLinks; }
    public void setTotalLinks(int totalLinks) { this.totalLinks = totalLinks; }

    public double getAverageDownloadSpeed() { return averageDownloadSpeed; }
    public void setAverageDownloadSpeed(double averageDownloadSpeed) { this.averageDownloadSpeed = averageDownloadSpeed; }

    public double getAverageUploadSpeed() { return averageUploadSpeed; }
    public void setAverageUploadSpeed(double averageUploadSpeed) { this.averageUploadSpeed = averageUploadSpeed; }

    public double getAverageLatency() { return averageLatency; }
    public void setAverageLatency(double averageLatency) { this.averageLatency = averageLatency; }

    public double getAveragePacketLoss() { return averagePacketLoss; }
    public void setAveragePacketLoss(double averagePacketLoss) { this.averagePacketLoss = averagePacketLoss; }

    public double getAverageSignalStrength() { return averageSignalStrength; }
    public void setAverageSignalStrength(double averageSignalStrength) { this.averageSignalStrength = averageSignalStrength; }

    public double getAverageCoveragePercentage() { return averageCoveragePercentage; }
    public void setAverageCoveragePercentage(double averageCoveragePercentage) { this.averageCoveragePercentage = averageCoveragePercentage; }

    public int getPendingMaintenance() { return pendingMaintenance; }
    public void setPendingMaintenance(int pendingMaintenance) { this.pendingMaintenance = pendingMaintenance; }

    public int getInProgressMaintenance() { return inProgressMaintenance; }
    public void setInProgressMaintenance(int inProgressMaintenance) { this.inProgressMaintenance = inProgressMaintenance; }

    public int getCompletedMaintenance() { return completedMaintenance; }
    public void setCompletedMaintenance(int completedMaintenance) { this.completedMaintenance = completedMaintenance; }

    public int getCancelledMaintenance() { return cancelledMaintenance; }
    public void setCancelledMaintenance(int cancelledMaintenance) { this.cancelledMaintenance = cancelledMaintenance; }

    public int getUnreadAlerts() { return unreadAlerts; }
    public void setUnreadAlerts(int unreadAlerts) { this.unreadAlerts = unreadAlerts; }

    public int getCriticalAlerts() { return criticalAlerts; }
    public void setCriticalAlerts(int criticalAlerts) { this.criticalAlerts = criticalAlerts; }

    public int getWarningAlerts() { return warningAlerts; }
    public void setWarningAlerts(int warningAlerts) { this.warningAlerts = warningAlerts; }

    public Date getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(Date generatedAt) { this.generatedAt = generatedAt; }
}
```

---

## 8. Code Template: `ReportDAO.java`

Location:

```text
Source Packages/com/networksim/dao/ReportDAO.java
```

```java
package com.networksim.dao;

import com.networksim.model.ReportSummary;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

public class ReportDAO {

    public ReportSummary getReportSummary() throws Exception {
        // CT - Decomposition: each summary value is calculated by a small focused query.
        ReportSummary summary = new ReportSummary();

        Connection conn = null;
        try {
            conn = DBContext.getConnection();

            summary.setTotalDevices(countAll(conn, "devices"));
            summary.setActiveDevices(countByValue(conn, "devices", "status", "ACTIVE"));
            summary.setInactiveDevices(countByValue(conn, "devices", "status", "INACTIVE"));
            summary.setMaintenanceDevices(countByValue(conn, "devices", "status", "MAINTENANCE"));
            summary.setTotalLinks(countAll(conn, "network_links"));

            loadBandwidthAverages(conn, summary);
            loadCoverageAverages(conn, summary);
            loadMaintenanceCounts(conn, summary);
            loadAlertCounts(conn, summary);

            summary.setGeneratedAt(new Date());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }

        return summary;
    }

    private int countAll(Connection conn, String tableName) throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM " + tableName;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } finally {
            closeResources(rs, ps);
        }
    }

    private int countByValue(Connection conn, String tableName, String columnName, String value) throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM " + tableName + " WHERE " + columnName + " = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, value);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } finally {
            closeResources(rs, ps);
        }
    }

    private void loadBandwidthAverages(Connection conn, ReportSummary summary) throws Exception {
        String sql = "SELECT AVG(download_speed) AS avg_download, "
                + "AVG(upload_speed) AS avg_upload, "
                + "AVG(latency) AS avg_latency, "
                + "AVG(packet_loss) AS avg_packet_loss "
                + "FROM bandwidth_logs";

        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                summary.setAverageDownloadSpeed(rs.getDouble("avg_download"));
                summary.setAverageUploadSpeed(rs.getDouble("avg_upload"));
                summary.setAverageLatency(rs.getDouble("avg_latency"));
                summary.setAveragePacketLoss(rs.getDouble("avg_packet_loss"));
            }
        } finally {
            closeResources(rs, ps);
        }
    }

    private void loadCoverageAverages(Connection conn, ReportSummary summary) throws Exception {
        String sql = "SELECT AVG(signal_strength) AS avg_signal, "
                + "AVG(coverage_percentage) AS avg_coverage "
                + "FROM coverage_areas";

        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                summary.setAverageSignalStrength(rs.getDouble("avg_signal"));
                summary.setAverageCoveragePercentage(rs.getDouble("avg_coverage"));
            }
        } finally {
            closeResources(rs, ps);
        }
    }

    private void loadMaintenanceCounts(Connection conn, ReportSummary summary) throws Exception {
        summary.setPendingMaintenance(countByValue(conn, "maintenance_tasks", "status", "PENDING"));
        summary.setInProgressMaintenance(countByValue(conn, "maintenance_tasks", "status", "IN_PROGRESS"));
        summary.setCompletedMaintenance(countByValue(conn, "maintenance_tasks", "status", "COMPLETED"));
        summary.setCancelledMaintenance(countByValue(conn, "maintenance_tasks", "status", "CANCELLED"));
    }

    private void loadAlertCounts(Connection conn, ReportSummary summary) throws Exception {
        String unreadSql = "SELECT COUNT(*) AS total FROM alerts WHERE is_read = FALSE";
        String criticalSql = "SELECT COUNT(*) AS total FROM alerts WHERE severity = 'CRITICAL'";
        String warningSql = "SELECT COUNT(*) AS total FROM alerts WHERE severity = 'WARNING'";

        summary.setUnreadAlerts(countBySql(conn, unreadSql));
        summary.setCriticalAlerts(countBySql(conn, criticalSql));
        summary.setWarningAlerts(countBySql(conn, warningSql));
    }

    private int countBySql(Connection conn, String sql) throws Exception {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } finally {
            closeResources(rs, ps);
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement ps) throws Exception {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
    }
}
```

Security note for the team:

> `countAll()` and `countByValue()` concatenate table and column names, but those names are hardcoded inside the DAO. Never pass user input into table names or column names.

---

## 9. Code Template: `ReportServlet.java`

Location:

```text
Source Packages/com/networksim/controller/ReportServlet.java
```

```java
package com.networksim.controller;

import com.networksim.dao.ReportDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("summary", reportDAO.getReportSummary());
            request.getRequestDispatcher("reports/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Cannot generate report. Please check database tables and data.");
            request.getRequestDispatcher("reports/dashboard.jsp").forward(request, response);
        }
    }
}
```

---

## 10. Code Template: `reports/dashboard.jsp`

Location:

```text
Web Pages/reports/dashboard.jsp
```

```jsp
<%@page import="com.networksim.model.ReportSummary"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ReportSummary summary = (ReportSummary) request.getAttribute("summary");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Report</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; padding: 24px; }
        .container { background: white; padding: 20px; border-radius: 8px; }
        .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-top: 16px; }
        .card { border: 1px solid #ddd; border-radius: 8px; padding: 16px; background: #fafafa; }
        .card h3 { margin-top: 0; color: #0d1117; }
        .value { font-size: 28px; font-weight: bold; color: #1f6feb; }
        table { width: 100%; border-collapse: collapse; margin-top: 16px; }
        th, td { border: 1px solid #ddd; padding: 9px; text-align: left; }
        th { background: #0d1117; color: white; }
        .btn { display: inline-block; padding: 8px 12px; margin: 4px 2px; border-radius: 4px; background: #1f6feb; color: white; text-decoration: none; border: none; cursor: pointer; }
        .btn-secondary { background: #6c757d; }
        .danger { color: #b00020; font-weight: bold; }
        .warning { color: #f59e0b; font-weight: bold; }
        .success { color: #16a34a; font-weight: bold; }
        .error { color: #b00020; font-weight: bold; }

        @media print {
            body { background: white; padding: 0; }
            .btn, .no-print { display: none; }
            .container { box-shadow: none; border-radius: 0; }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Network Infrastructure System Report</h2>

    <div class="no-print">
        <button class="btn" onclick="window.print();">Print Report</button>
        <a class="btn btn-secondary" href="dashboard.jsp">Back to Dashboard</a>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if (summary != null) { %>
        <p><strong>Generated At:</strong> <%= summary.getGeneratedAt() %></p>

        <h3>1. Device Summary</h3>
        <div class="grid">
            <div class="card">
                <h3>Total Devices</h3>
                <div class="value"><%= summary.getTotalDevices() %></div>
            </div>
            <div class="card">
                <h3>Active Devices</h3>
                <div class="value success"><%= summary.getActiveDevices() %></div>
            </div>
            <div class="card">
                <h3>Inactive Devices</h3>
                <div class="value danger"><%= summary.getInactiveDevices() %></div>
            </div>
        </div>

        <table>
            <tr>
                <th>Metric</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Maintenance Devices</td>
                <td><%= summary.getMaintenanceDevices() %></td>
            </tr>
            <tr>
                <td>Total Network Links</td>
                <td><%= summary.getTotalLinks() %></td>
            </tr>
        </table>

        <h3>2. Bandwidth Monitoring Summary</h3>
        <table>
            <tr>
                <th>Metric</th>
                <th>Average Value</th>
            </tr>
            <tr>
                <td>Download Speed</td>
                <td><%= String.format("%.2f", summary.getAverageDownloadSpeed()) %> Mbps</td>
            </tr>
            <tr>
                <td>Upload Speed</td>
                <td><%= String.format("%.2f", summary.getAverageUploadSpeed()) %> Mbps</td>
            </tr>
            <tr>
                <td>Latency</td>
                <td><%= String.format("%.2f", summary.getAverageLatency()) %> ms</td>
            </tr>
            <tr>
                <td>Packet Loss</td>
                <td><%= String.format("%.2f", summary.getAveragePacketLoss()) %>%</td>
            </tr>
        </table>

        <h3>3. Coverage Monitoring Summary</h3>
        <table>
            <tr>
                <th>Metric</th>
                <th>Average Value</th>
            </tr>
            <tr>
                <td>Signal Strength</td>
                <td><%= String.format("%.2f", summary.getAverageSignalStrength()) %> dBm</td>
            </tr>
            <tr>
                <td>Coverage Percentage</td>
                <td><%= String.format("%.2f", summary.getAverageCoveragePercentage()) %>%</td>
            </tr>
        </table>

        <h3>4. Maintenance Summary</h3>
        <table>
            <tr>
                <th>Status</th>
                <th>Total Tasks</th>
            </tr>
            <tr>
                <td>Pending</td>
                <td><%= summary.getPendingMaintenance() %></td>
            </tr>
            <tr>
                <td>In Progress</td>
                <td><%= summary.getInProgressMaintenance() %></td>
            </tr>
            <tr>
                <td>Completed</td>
                <td><%= summary.getCompletedMaintenance() %></td>
            </tr>
            <tr>
                <td>Cancelled</td>
                <td><%= summary.getCancelledMaintenance() %></td>
            </tr>
        </table>

        <h3>5. Alert Summary</h3>
        <table>
            <tr>
                <th>Metric</th>
                <th>Total</th>
            </tr>
            <tr>
                <td>Unread Alerts</td>
                <td class="warning"><%= summary.getUnreadAlerts() %></td>
            </tr>
            <tr>
                <td>Critical Alerts</td>
                <td class="danger"><%= summary.getCriticalAlerts() %></td>
            </tr>
            <tr>
                <td>Warning Alerts</td>
                <td class="warning"><%= summary.getWarningAlerts() %></td>
            </tr>
        </table>

        <h3>6. Report Interpretation</h3>
        <ul>
            <li>If inactive devices are high, the network needs device checking.</li>
            <li>If latency is high, the network may feel slow to users.</li>
            <li>If coverage percentage is low, wireless signal planning should be improved.</li>
            <li>If unread alerts are high, administrators should review system warnings.</li>
            <li>If pending maintenance is high, the team should prioritize maintenance scheduling.</li>
        </ul>
    <% } else { %>
        <p>No report data available.</p>
    <% } %>
</div>
</body>
</html>
```

---

## 11. Dashboard Link to Add

In `Web Pages/dashboard.jsp`, add:

```jsp
<li><a href="reports">Report Generation</a></li>
```

Recommended dashboard module list:

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

---

## 12. Team Task Assignment

| Member | Responsibility | Deliverables |
|---|---|---|
| Member 1 | Report backend model and DAO | `ReportSummary.java`, `ReportDAO.java` |
| Member 2 | Report controller and routing | `ReportServlet.java`, dashboard link |
| Member 3 | Report JSP design | `reports/dashboard.jsp`, print CSS |
| Member 4 | CT documentation and testing | Flowchart, sequence diagram, test data, screenshots |

Parallel workflow:

```text
Member 1 writes summary queries.
Member 2 connects servlet to DAO and JSP.
Member 3 designs the dashboard page based on ReportSummary getters.
Member 4 prepares diagrams, testing table, and report screenshots.
Then everyone integrates and tests in NetBeans.
```

---

## 13. Testing Plan

| Test Case | Data Needed | Expected Result |
|---|---|---|
| Open report page | Existing database tables | `/reports` opens successfully |
| Count devices | Devices inserted | Total devices matches database |
| Count device statuses | ACTIVE/INACTIVE/MAINTENANCE devices | Status counts display correctly |
| Count links | Network links inserted | Total links displays correctly |
| Bandwidth averages | Bandwidth logs inserted | Average values display with 2 decimals |
| Coverage averages | Coverage records inserted | Average coverage values display |
| Maintenance counts | Tasks with different statuses | Counts display correctly |
| Alert counts | Alerts with severities/read status | Alert totals display correctly |
| Print report | Browser print button | Browser print dialog opens |
| Missing table issue | Remove/rename table accidentally | Error message appears |

---

## 14. Sample Test Data Checklist

Before testing reports, make sure the team has at least:

- [ ] 3 devices
- [ ] 1 active device
- [ ] 1 inactive device
- [ ] 1 maintenance device
- [ ] 2 network links
- [ ] 3 bandwidth logs
- [ ] 3 coverage records
- [ ] 3 maintenance tasks with different statuses
- [ ] 3 alerts with different severities
- [ ] 1 unread alert

---

## 15. Common Mistakes and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| HTTP 404 on `/reports` | Servlet mapping issue | Check `@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})` |
| Report page shows error | SQL table/column name mismatch | Compare DAO SQL with actual ERD table names |
| All averages show 0.00 | No monitoring data inserted | Add bandwidth and coverage test records first |
| Device status counts show 0 | Status values do not match | Use exact values: `ACTIVE`, `INACTIVE`, `MAINTENANCE` |
| Alert counts wrong | Severity values do not match | Use exact values: `CRITICAL`, `WARNING`, `INFO` |
| Print button appears in printed report | CSS missing | Add `@media print` and `.no-print { display: none; }` |
| `jakarta.servlet` error | Wrong namespace | Use `javax.servlet.*` with Tomcat 9 |
| Java compile error with newer syntax | Java 8 limitation | Do not use `var`, records, or Java 9+ APIs |

---

## 16. Report Writing Support

Use this section in the final PRJ301 report.

### 16.1 Implementation Description

The Report Generation module provides a summary dashboard for the Network Infrastructure Simulation Management System. It collects data from device management, topology simulation, bandwidth monitoring, coverage monitoring, maintenance scheduling, and system alerts. The module follows the MVC pattern: `ReportServlet` controls the request, `ReportDAO` retrieves aggregate data from MySQL, `ReportSummary` stores the calculated values, and `reports/dashboard.jsp` displays the result to the user.

### 16.2 Computational Thinking Explanation

| CT Pillar | Application in Report Module |
|---|---|
| Decomposition | The report is divided into device, topology, bandwidth, coverage, maintenance, and alert summaries. |
| Pattern Recognition | Most report values use repeated SQL patterns such as `COUNT`, `AVG`, and filtering by status. |
| Abstraction | The system hides raw database rows and shows only meaningful summary values in `ReportSummary`. |
| Algorithm Design | The servlet calls the DAO, the DAO calculates each metric, then the JSP presents the final report. |

### 16.3 Why This Module Is Important

This module helps administrators quickly understand the overall condition of the simulated network. Instead of checking every feature page one by one, users can open one report dashboard and see the key metrics needed for decision-making.

---

## 17. Completion Checklist

- [ ] `ReportSummary.java` created
- [ ] `ReportDAO.java` created
- [ ] `ReportServlet.java` created
- [ ] `reports/dashboard.jsp` created
- [ ] Dashboard link added
- [ ] `/reports` opens successfully
- [ ] Device totals display correctly
- [ ] Network link total displays correctly
- [ ] Bandwidth averages display correctly
- [ ] Coverage averages display correctly
- [ ] Maintenance status counts display correctly
- [ ] Alert counts display correctly
- [ ] Print button works
- [ ] Flowchart drawn
- [ ] Sequence diagram drawn
- [ ] Screenshots saved for final report

---

## 18. Next Recommended Step

After Report Generation, the team should create the final planning/report document:

```text
PRJ301_Final_Report_Structure.md
```

That document should organize:

- introduction
- problem statement
- CT analysis
- system design diagrams
- database design
- implementation screenshots
- testing results
- conclusion and lessons learned
