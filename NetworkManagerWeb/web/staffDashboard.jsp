<%-- 
    staffDashboard.jsp - Dashboard for ADMIN and TECH roles
    Accessible after login when roleID = 'ADMIN' or 'TECH'
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.UserDTO"%>
<%
    UserDTO currentUser = (UserDTO) session.getAttribute("currentUser");
    String role = (String) session.getAttribute("role");
    if (currentUser == null || role == null || (!role.equals("ADMIN") && !role.equals("TECH"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayName = currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getUserName();
    boolean isAdmin = role.equals("ADMIN");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Network Manager — Staff Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;600&display=swap" rel="stylesheet">
        <style>
            :root {
                --brand-dark: #0a0f1e;
                --brand-blue: #1a6cff;
                --brand-accent: #00e5ff;
                --brand-surface: #111827;
                --brand-border: #1e3a5f;
                --brand-text: #e2e8f0;
                --brand-muted: #64748b;
                --sidebar-w: 256px;
            }

            body {
                background: var(--brand-dark);
                color: var(--brand-text);
                font-family: 'IBM Plex Sans', sans-serif;
                min-height: 100vh;
            }

            /* ---- Sidebar ---- */
            .sidebar {
                position: fixed;
                top: 0; left: 0; bottom: 0;
                width: var(--sidebar-w);
                background: var(--brand-surface);
                border-right: 1px solid var(--brand-border);
                display: flex;
                flex-direction: column;
                z-index: 100;
                overflow-y: auto;
            }

            .sidebar-brand {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1.25rem;
                border-bottom: 1px solid var(--brand-border);
                font-family: 'IBM Plex Mono', monospace;
                font-size: 0.83rem;
                font-weight: 600;
                color: var(--brand-accent);
                letter-spacing: 0.05em;
                flex-shrink: 0;
            }

            .sidebar-brand-icon {
                width: 36px; height: 36px;
                background: linear-gradient(135deg, var(--brand-blue), var(--brand-accent));
                border-radius: 8px;
                display: flex; align-items: center; justify-content: center;
                font-size: 1rem; color: white; flex-shrink: 0;
            }

            .sidebar-section-label {
                font-size: 0.63rem;
                font-weight: 600;
                letter-spacing: 0.14em;
                text-transform: uppercase;
                color: var(--brand-muted);
                padding: 1.1rem 1.25rem 0.35rem;
                font-family: 'IBM Plex Mono', monospace;
            }

            .nav-item-link {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.55rem 1.25rem;
                font-size: 0.855rem;
                color: #94a3b8;
                text-decoration: none;
                transition: background 0.15s, color 0.15s;
                cursor: pointer;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
            }

            .nav-item-link:hover { background: rgba(26,108,255,0.1); color: var(--brand-text); }

            .nav-item-link.active {
                background: rgba(26,108,255,0.18);
                color: var(--brand-accent);
                font-weight: 600;
                border-right: 3px solid var(--brand-blue);
            }

            .nav-item-link i { font-size: 0.95rem; flex-shrink: 0; }

            .sidebar-footer {
                margin-top: auto;
                padding: 1rem 1.25rem;
                border-top: 1px solid var(--brand-border);
                flex-shrink: 0;
            }

            .user-avatar {
                width: 34px; height: 34px;
                border-radius: 50%;
                display: flex; align-items: center; justify-content: center;
                font-size: 0.85rem; color: white; font-weight: 600; flex-shrink: 0;
            }

            .admin-avatar { background: linear-gradient(135deg, #dc2626, #f97316); }
            .tech-avatar  { background: linear-gradient(135deg, #7c3aed, #2563eb); }

            /* ---- Role badge ---- */
            .role-badge-admin {
                background: rgba(220,38,38,0.15);
                color: #f87171;
                border: 1px solid rgba(220,38,38,0.3);
                font-size: 0.67rem;
                font-family: 'IBM Plex Mono', monospace;
                letter-spacing: 0.08em;
                padding: 0.2rem 0.55rem;
                border-radius: 1rem;
            }

            .role-badge-tech {
                background: rgba(124,58,237,0.15);
                color: #a78bfa;
                border: 1px solid rgba(124,58,237,0.3);
                font-size: 0.67rem;
                font-family: 'IBM Plex Mono', monospace;
                letter-spacing: 0.08em;
                padding: 0.2rem 0.55rem;
                border-radius: 1rem;
            }

            /* ---- Main content ---- */
            .main-content {
                margin-left: var(--sidebar-w);
                min-height: 100vh;
            }

            .topbar {
                background: var(--brand-surface);
                border-bottom: 1px solid var(--brand-border);
                padding: 1rem 1.75rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 50;
            }

            .topbar-title { font-size: 1.05rem; font-weight: 600; color: var(--brand-text); }
            .topbar-breadcrumb { font-size: 0.78rem; color: var(--brand-muted); font-family: 'IBM Plex Mono', monospace; margin-left: 0.5rem; }

            .page-body { padding: 1.75rem; }

            /* Stat cards */
            .stat-card {
                background: var(--brand-surface);
                border: 1px solid var(--brand-border);
                border-radius: 0.75rem;
                padding: 1.15rem 1.4rem;
                transition: border-color 0.2s;
            }
            .stat-card:hover { border-color: var(--brand-blue); }
            .stat-icon { width: 42px; height: 42px; border-radius: 10px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; margin-bottom:0.7rem; }
            .stat-value { font-size: 1.5rem; font-weight: 700; font-family: 'IBM Plex Mono', monospace; line-height: 1; margin-bottom: 0.2rem; }
            .stat-label { font-size: 0.75rem; color: var(--brand-muted); }
            .stat-delta { font-size: 0.7rem; font-family: 'IBM Plex Mono', monospace; margin-top: 0.2rem; }
            .delta-up { color: #22c55e; }
            .delta-warn { color: #f59e0b; }
            .delta-danger { color: #ef4444; }

            /* Section card */
            .section-card {
                background: var(--brand-surface);
                border: 1px solid var(--brand-border);
                border-radius: 0.75rem;
                overflow: hidden;
            }

            .section-card-header {
                padding: 0.9rem 1.25rem;
                border-bottom: 1px solid var(--brand-border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .section-card-header h6 { font-size: 0.875rem; font-weight: 600; color: var(--brand-text); margin: 0; }
            .section-card-body { padding: 1.25rem; }

            .placeholder-box {
                background: rgba(26,108,255,0.04);
                border: 1px dashed var(--brand-border);
                border-radius: 0.5rem;
                padding: 2.25rem 1rem;
                text-align: center;
                color: var(--brand-muted);
                font-size: 0.83rem;
            }
            .placeholder-box i { font-size: 1.75rem; display: block; margin-bottom: 0.5rem; }

            /* Alert severity indicators */
            .alert-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.65rem 0;
                border-bottom: 1px solid rgba(255,255,255,0.05);
                font-size: 0.83rem;
            }
            .alert-item:last-child { border-bottom: none; }
            .severity-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
            .severity-critical { background: #ef4444; box-shadow: 0 0 6px #ef4444; }
            .severity-warning  { background: #f59e0b; box-shadow: 0 0 6px #f59e0b; }
            .severity-info     { background: #3b82f6; }

            /* Page visibility */
            .page-section { display: none; }
            .page-section.active { display: block; }

            @media (max-width: 768px) {
                .sidebar { display: none; }
                .main-content { margin-left: 0; }
            }
        </style>
    </head>
    <body>

        <!-- ===== SIDEBAR ===== -->
        <nav class="sidebar">
            <div class="sidebar-brand">
                <div class="sidebar-brand-icon"><i class="bi bi-wifi"></i></div>
                <div>Network<br>Manager</div>
            </div>

            <div class="sidebar-section-label">Overview</div>
            <button class="nav-item-link active" onclick="showPage('dashboard', this)">
                <i class="bi bi-speedometer2"></i> Dashboard
            </button>

            <div class="sidebar-section-label">Infrastructure</div>
            <button class="nav-item-link" onclick="showPage('devices', this)">
                <i class="bi bi-laptop"></i> Network Devices
            </button>
            <button class="nav-item-link" onclick="showPage('accesspoints', this)">
                <i class="bi bi-reception-4"></i> Access Points
            </button>
            <button class="nav-item-link" onclick="showPage('routers', this)">
                <i class="bi bi-router"></i> Routers
            </button>
            <button class="nav-item-link" onclick="showPage('switches', this)">
                <i class="bi bi-hdd-network"></i> Switches
            </button>
            <button class="nav-item-link" onclick="showPage('vlan', this)">
                <i class="bi bi-diagram-3"></i> VLAN
            </button>
            <button class="nav-item-link" onclick="showPage('ipmanage', this)">
                <i class="bi bi-globe"></i> IP Management
            </button>

            <div class="sidebar-section-label">Monitoring</div>
            <button class="nav-item-link" onclick="showPage('bandwidth', this)">
                <i class="bi bi-bar-chart-line"></i> Bandwidth Usage
            </button>
            <button class="nav-item-link" onclick="showPage('wifianalytics', this)">
                <i class="bi bi-graph-up"></i> WiFi Analytics
            </button>
            <button class="nav-item-link" onclick="showPage('alerts', this)">
                <i class="bi bi-exclamation-triangle"></i> Network Alerts
                <span class="ms-auto badge" style="background:rgba(239,68,68,0.2);color:#f87171;font-size:0.65rem;font-family:'IBM Plex Mono',monospace;">3</span>
            </button>

            <div class="sidebar-section-label">Management</div>
            <button class="nav-item-link" onclick="showPage('tickets', this)">
                <i class="bi bi-ticket-perforated"></i> Support Tickets
            </button>
            <button class="nav-item-link" onclick="showPage('maintenance', this)">
                <i class="bi bi-tools"></i> Maintenance
            </button>
            <button class="nav-item-link" onclick="showPage('rooms', this)">
                <i class="bi bi-building"></i> Rooms
            </button>

            <!-- Admin-only sections -->
            <% if (isAdmin) { %>
            <div class="sidebar-section-label">Administration</div>
            <button class="nav-item-link" onclick="showPage('users', this)">
                <i class="bi bi-people"></i> Manage Users
            </button>
            <button class="nav-item-link" onclick="showPage('authlogs', this)">
                <i class="bi bi-shield-check"></i> Auth Logs
            </button>
            <button class="nav-item-link" onclick="showPage('systemlogs', this)">
                <i class="bi bi-journal-text"></i> System Logs
            </button>
            <% } %>

            <div class="sidebar-footer">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <div class="user-avatar <%= isAdmin ? "admin-avatar" : "tech-avatar" %>">
                        <%= displayName.charAt(0) %>
                    </div>
                    <div>
                        <div style="font-size:0.82rem;font-weight:600;color:var(--brand-text);"><%= displayName %></div>
                        <div style="font-size:0.68rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;"><%= role %></div>
                    </div>
                </div>
                <a href="LoginController?action=logout" class="nav-item-link text-danger" style="padding-left:0;">
                    <i class="bi bi-box-arrow-left"></i> Sign Out
                </a>
            </div>
        </nav>

        <!-- ===== MAIN CONTENT ===== -->
        <div class="main-content">
            <div class="topbar">
                <div>
                    <span class="topbar-title" id="pageTitle">Dashboard</span>
                    <span class="topbar-breadcrumb" id="pageBreadcrumb">/ Overview</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="<%= isAdmin ? "role-badge-admin" : "role-badge-tech" %>"><%= role %></span>
                    <span style="font-size:0.82rem;color:var(--brand-muted);">
                        <strong style="color:var(--brand-text);"><%= displayName %></strong>
                    </span>
                </div>
            </div>

            <div class="page-body">

                <!-- ===== PAGE: MAIN DASHBOARD ===== -->
                <div class="page-section active" id="page-dashboard">

                    <!-- Stats row -->
                    <div class="row g-3 mb-4">
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(34,197,94,0.12);color:#22c55e;"><i class="bi bi-laptop"></i></div>
                                <div class="stat-value" style="color:#22c55e;">142</div>
                                <div class="stat-label">Devices Online</div>
                                <div class="stat-delta delta-up"><i class="bi bi-arrow-up"></i> / 200 registered</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(26,108,255,0.12);color:#1a6cff;"><i class="bi bi-reception-4"></i></div>
                                <div class="stat-value">7<span style="font-size:1rem;color:var(--brand-muted);">/8</span></div>
                                <div class="stat-label">Access Points</div>
                                <div class="stat-delta delta-warn"><i class="bi bi-exclamation-circle"></i> 1 offline</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(245,158,11,0.12);color:#f59e0b;"><i class="bi bi-bar-chart-line"></i></div>
                                <div class="stat-value">74<span style="font-size:0.9rem;color:var(--brand-muted);">Mbps</span></div>
                                <div class="stat-label">Current Bandwidth</div>
                                <div class="stat-delta delta-warn">/ 100 Mbps capacity</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(239,68,68,0.12);color:#ef4444;"><i class="bi bi-exclamation-triangle"></i></div>
                                <div class="stat-value" style="color:#ef4444;">3</div>
                                <div class="stat-label">Active Alerts</div>
                                <div class="stat-delta delta-danger">Needs attention</div>
                            </div>
                        </div>
                    </div>

                    <!-- Middle row -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-exclamation-triangle me-2" style="color:#f59e0b;"></i>Recent Alerts</h6>
                                    <button class="btn btn-sm" style="font-size:0.72rem;color:var(--brand-accent);" onclick="showPage('alerts',null)">View All</button>
                                </div>
                                <div class="section-card-body">
                                    <div class="alert-item">
                                        <div class="severity-dot severity-critical"></div>
                                        <div>
                                            <div style="font-weight:600;font-size:0.83rem;">AP-Floor2 went offline</div>
                                            <div style="font-size:0.72rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;">OUTAGE · CRITICAL · just now</div>
                                        </div>
                                    </div>
                                    <div class="alert-item">
                                        <div class="severity-dot severity-warning"></div>
                                        <div>
                                            <div style="font-weight:600;font-size:0.83rem;">High bandwidth on Switch-A1</div>
                                            <div style="font-size:0.72rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;">PERFORMANCE · WARNING · 5m ago</div>
                                        </div>
                                    </div>
                                    <div class="alert-item">
                                        <div class="severity-dot severity-info"></div>
                                        <div>
                                            <div style="font-weight:600;font-size:0.83rem;">Maintenance scheduled tonight</div>
                                            <div style="font-size:0.72rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;">INFO · 22:00</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-reception-4 me-2"></i>Access Point Load</h6>
                                    <button class="btn btn-sm" style="font-size:0.72rem;color:var(--brand-accent);" onclick="showPage('accesspoints',null)">Details</button>
                                </div>
                                <div class="section-card-body">
                                    <%-- AP load rows --%>
                                    <% String[][] aps = {
                                        {"AP_Toa_A_T2","38","66","#22c55e"},
                                        {"AP_Toa_B_T1","45","78","#f59e0b"},
                                        {"AP_Lab_CNTT","22","38","#22c55e"},
                                        {"AP_Thu_Vien","37","64","#22c55e"},
                                        {"AP_Canteen",  "0", "0","#64748b"}
                                    }; %>
                                    <% for (String[] ap : aps) { %>
                                    <div class="d-flex align-items-center gap-2 mb-2" style="font-size:0.82rem;">
                                        <div style="width:110px;color:var(--brand-text);font-family:'IBM Plex Mono',monospace;font-size:0.75rem;flex-shrink:0;"><%= ap[0] %></div>
                                        <div class="flex-grow-1" style="height:6px;background:rgba(255,255,255,0.07);border-radius:3px;overflow:hidden;">
                                            <div style="width:<%= ap[2] %>%;height:100%;background:<%= ap[3] %>;border-radius:3px;transition:width 0.6s;"></div>
                                        </div>
                                        <div style="width:40px;text-align:right;color:<%= ap[3] %>;font-family:'IBM Plex Mono',monospace;font-size:0.75rem;"><%= ap[1] %> tb</div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bottom row -->
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-ticket-perforated me-2"></i>Open Support Tickets</h6>
                                    <button class="btn btn-sm" style="font-size:0.72rem;color:var(--brand-accent);" onclick="showPage('tickets',null)">View All</button>
                                </div>
                                <div class="section-card-body">
                                    <div class="placeholder-box">
                                        <i class="bi bi-ticket-perforated"></i>
                                        Support ticket queue will appear here
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-tools me-2"></i>Upcoming Maintenance</h6>
                                    <button class="btn btn-sm" style="font-size:0.72rem;color:var(--brand-accent);" onclick="showPage('maintenance',null)">View All</button>
                                </div>
                                <div class="section-card-body">
                                    <div class="alert-item">
                                        <div class="severity-dot severity-info"></div>
                                        <div>
                                            <div style="font-weight:600;font-size:0.83rem;">Router firmware upgrade</div>
                                            <div style="font-size:0.72rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;">2026-06-01 22:00 → 02:00 · PLANNED</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== Infrastructure pages (placeholders) ===== -->
                <% String[][] infraPages = {
                    {"devices",      "bi-laptop",         "Network Devices",  "Device name, MAC address, IP, owner, type, status"},
                    {"accesspoints", "bi-reception-4",    "Access Points",    "AP name, SSID, IP, connected users, status, room"},
                    {"routers",      "bi-router",         "Routers",          "Router name, IP, MAC, model, firmware, status"},
                    {"switches",     "bi-hdd-network",    "Switches",         "Switch name, total/used ports, IP, status"},
                    {"vlan",         "bi-diagram-3",      "VLAN Management",  "VLAN name, subnet, purpose"},
                    {"ipmanage",     "bi-globe",          "IP Address Management", "IP address, assigned to, status"}
                }; %>
                <% for (String[] p : infraPages) { %>
                <div class="page-section" id="page-<%= p[0] %>">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi <%= p[1] %> me-2"></i><%= p[2] %></h6>
                            <button class="btn btn-sm" style="background:var(--brand-blue);color:white;font-size:0.75rem;">
                                <i class="bi bi-plus-lg me-1"></i>Add New
                            </button>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi <%= p[1] %>"></i>
                                <%= p[2] %> list will appear here<br>
                                <small><%= p[3] %></small>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- ===== Monitoring pages ===== -->
                <div class="page-section" id="page-bandwidth">
                    <div class="section-card">
                        <div class="section-card-header"><h6><i class="bi bi-bar-chart-line me-2"></i>Bandwidth Usage</h6></div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-bar-chart-line"></i>
                                Bandwidth usage chart will appear here<br>
                                <small>Upload speed, download speed, timestamp, device</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-wifianalytics">
                    <div class="section-card">
                        <div class="section-card-header"><h6><i class="bi bi-graph-up me-2"></i>WiFi Analytics</h6></div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-graph-up"></i>
                                WiFi analytics dashboard will appear here<br>
                                <small>Total users, peak users, average speed, date</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-alerts">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-exclamation-triangle me-2" style="color:#f59e0b;"></i>Network Alerts</h6>
                            <div class="d-flex gap-2">
                                <select class="form-select form-select-sm" style="width:120px;background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);font-size:0.75rem;">
                                    <option>All Severity</option>
                                    <option>CRITICAL</option>
                                    <option>WARNING</option>
                                    <option>INFO</option>
                                </select>
                            </div>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-exclamation-triangle"></i>
                                All network alerts will appear here<br>
                                <small>Type, message, severity, created time</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== Management pages ===== -->
                <div class="page-section" id="page-tickets">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-ticket-perforated me-2"></i>Support Tickets</h6>
                            <select class="form-select form-select-sm" style="width:120px;background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);font-size:0.75rem;">
                                <option>All Status</option>
                                <option>OPEN</option>
                                <option>IN PROGRESS</option>
                                <option>CLOSED</option>
                            </select>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-ticket-perforated"></i>
                                All support tickets will appear here<br>
                                <small>Title, submitted by, status, date created</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-maintenance">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-tools me-2"></i>Maintenance Schedule</h6>
                            <button class="btn btn-sm" style="background:var(--brand-blue);color:white;font-size:0.75rem;">
                                <i class="bi bi-plus-lg me-1"></i>Schedule
                            </button>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-tools"></i>
                                Maintenance schedule will appear here<br>
                                <small>Title, start time, end time, status</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-rooms">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-building me-2"></i>Room Management</h6>
                            <% if (isAdmin) { %>
                            <button class="btn btn-sm" style="background:var(--brand-blue);color:white;font-size:0.75rem;">
                                <i class="bi bi-plus-lg me-1"></i>Add Room
                            </button>
                            <% } %>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-building"></i>
                                Room list will appear here<br>
                                <small>Room name, building, floor, capacity</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== Admin-only pages ===== -->
                <% if (isAdmin) { %>
                <div class="page-section" id="page-users">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-people me-2"></i>User Management</h6>
                            <button class="btn btn-sm" style="background:var(--brand-blue);color:white;font-size:0.75rem;">
                                <i class="bi bi-person-plus me-1"></i>Add User
                            </button>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-people"></i>
                                All system users will appear here<br>
                                <small>Username, full name, email, role, status</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-authlogs">
                    <div class="section-card">
                        <div class="section-card-header"><h6><i class="bi bi-shield-check me-2"></i>Authentication Logs</h6></div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-shield-check"></i>
                                Login history will appear here<br>
                                <small>Username, login status, IP address, timestamp</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-section" id="page-systemlogs">
                    <div class="section-card">
                        <div class="section-card-header"><h6><i class="bi bi-journal-text me-2"></i>System Logs</h6></div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-journal-text"></i>
                                System action logs will appear here<br>
                                <small>Action, performed by, timestamp, details</small>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

            </div><!-- end page-body -->
        </div><!-- end main-content -->

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const pageTitles = {
                'dashboard':     ['Dashboard',             '/ Overview'],
                'devices':       ['Network Devices',       '/ Infrastructure'],
                'accesspoints':  ['Access Points',         '/ Infrastructure'],
                'routers':       ['Routers',               '/ Infrastructure'],
                'switches':      ['Switches',              '/ Infrastructure'],
                'vlan':          ['VLAN',                  '/ Infrastructure'],
                'ipmanage':      ['IP Management',         '/ Infrastructure'],
                'bandwidth':     ['Bandwidth Usage',       '/ Monitoring'],
                'wifianalytics': ['WiFi Analytics',        '/ Monitoring'],
                'alerts':        ['Network Alerts',        '/ Monitoring'],
                'tickets':       ['Support Tickets',       '/ Management'],
                'maintenance':   ['Maintenance Schedule',  '/ Management'],
                'rooms':         ['Rooms',                 '/ Management'],
                'users':         ['User Management',       '/ Administration'],
                'authlogs':      ['Auth Logs',             '/ Administration'],
                'systemlogs':    ['System Logs',           '/ Administration']
            };

            function showPage(pageId, triggerEl) {
                document.querySelectorAll('.page-section').forEach(s => s.classList.remove('active'));
                document.querySelectorAll('.nav-item-link').forEach(b => b.classList.remove('active'));

                const section = document.getElementById('page-' + pageId);
                if (section) section.classList.add('active');
                if (triggerEl) triggerEl.classList.add('active');

                const [title, crumb] = pageTitles[pageId] || ['Dashboard', '/ Overview'];
                document.getElementById('pageTitle').textContent = title;
                document.getElementById('pageBreadcrumb').textContent = crumb;
            }
        </script>
    </body>
</html>
