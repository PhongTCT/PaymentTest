<%--
    Dashboard Page (View)

    CT Pillar: Abstraction
    - Displays system overview with summary statistics
    - Protected page: only accessible after login (checked by Servlet)
    - Shows different content based on user role

    Compatible with: JDK 8 + Tomcat 9 + JSTL 1.2
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Network Simulation System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-brand">
            <h3>Network Simulation</h3>
        </div>
        <div class="nav-user">
            <span>Welcome, <strong>${currentUser.fullName}</strong></span>
            <span class="badge badge-${currentUser.role.toLowerCase()}">${currentUser.role}</span>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-sm btn-danger">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <h1>Dashboard</h1>

        <!-- Weekly Maintenance Alert -->
        <div class="maintenance-alert">
            <div>
                <span class="alert-badge">MAINTENANCE</span>
                <strong>Weekly maintenance check is scheduled for ${maintenanceAlertDate}.</strong>
            </div>
            <p>Review device status, backups, and pending network tasks before the maintenance window.</p>
        </div>

        <!-- Summary Cards -->
        <div class="card-grid">
            <div class="card card-blue">
                <div class="card-icon">&#128268;</div>
                <div class="card-info">
                    <h3>Total Devices</h3>
                    <p class="card-number">--</p>
                    <p class="card-label">Network devices managed</p>
                </div>
            </div>

            <div class="card card-green">
                <div class="card-icon">&#9989;</div>
                <div class="card-info">
                    <h3>Online</h3>
                    <p class="card-number">--</p>
                    <p class="card-label">Devices currently online</p>
                </div>
            </div>

            <div class="card card-orange">
                <div class="card-icon">&#9888;</div>
                <div class="card-info">
                    <h3>Warnings</h3>
                    <p class="card-number">--</p>
                    <p class="card-label">Devices with issues</p>
                </div>
            </div>

            <div class="card card-red">
                <div class="card-icon">&#128308;</div>
                <div class="card-info">
                    <h3>Maintenance</h3>
                    <p class="card-number">--</p>
                    <p class="card-label">Pending tasks</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="section">
            <h2>Quick Actions</h2>
            <div class="action-grid">
                <a href="${pageContext.request.contextPath}/devices" class="action-card">
                    <div class="action-icon">&#128268;</div>
                    <h3>Device Management</h3>
                    <p>Manage network devices, add new routers, switches, and servers</p>
                </a>

                <a href="${pageContext.request.contextPath}/topology" class="action-card">
                    <div class="action-icon">&#128506;</div>
                    <h3>Network Topology</h3>
                    <p>View and edit the network diagram visualization</p>
                </a>

                <a href="${pageContext.request.contextPath}/monitoring" class="action-card">
                    <div class="action-icon">&#128200;</div>
                    <h3>Monitoring</h3>
                    <p>Check bandwidth, latency, and device status</p>
                </a>

                <a href="${pageContext.request.contextPath}/maintenance" class="action-card">
                    <div class="action-icon">&#128295;</div>
                    <h3>Maintenance</h3>
                    <p>Schedule and track maintenance tasks</p>
                </a>

                <c:if test="${currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/users" class="action-card">
                        <div class="action-icon">&#128101;</div>
                        <h3>User Management</h3>
                        <p>Manage system users and permissions</p>
                    </a>
                </c:if>

                <a href="${pageContext.request.contextPath}/reports" class="action-card">
                    <div class="action-icon">&#128196;</div>
                    <h3>Reports</h3>
                    <p>Generate system reports and exports</p>
                </a>
            </div>
        </div>

        <!-- Recent Alerts Section -->
        <div class="section">
            <h2>Recent Alerts</h2>
            <div class="alert-list">
                <div class="alert-item alert-warning">
                    <span class="alert-badge">WARNING</span>
                    <span class="alert-msg">DB-Server-01 latency exceeds 40ms threshold</span>
                    <span class="alert-time">Just now</span>
                </div>
                <div class="alert-item alert-critical">
                    <span class="alert-badge">CRITICAL</span>
                    <span class="alert-msg">PC-Admin-02 is offline since 2026-05-20</span>
                    <span class="alert-time">2 days ago</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>Network Infrastructure Simulation Management System | PRJ301 Project</p>
    </footer>
</body>
</html>
