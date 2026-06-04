<%-- 
    userDashboard.jsp - Dashboard for USER role
    Accessible after login when roleID = 'USER'
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.UserDTO"%>
<%
    // Session guard: redirect to login if not authenticated
    UserDTO currentUser = (UserDTO) session.getAttribute("currentUser");
    String role = (String) session.getAttribute("role");
    if (currentUser == null || role == null || !role.equals("USER")) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayName = currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getUserName();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Network Manager — My Dashboard</title>
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
                --sidebar-w: 240px;
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
                padding: 0;
            }

            .sidebar-brand {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1.25rem 1.25rem;
                border-bottom: 1px solid var(--brand-border);
                font-family: 'IBM Plex Mono', monospace;
                font-size: 0.85rem;
                font-weight: 600;
                color: var(--brand-accent);
                letter-spacing: 0.05em;
            }

            .sidebar-brand-icon {
                width: 36px; height: 36px;
                background: linear-gradient(135deg, var(--brand-blue), var(--brand-accent));
                border-radius: 8px;
                display: flex; align-items: center; justify-content: center;
                font-size: 1rem; color: white; flex-shrink: 0;
            }

            .sidebar-section-label {
                font-size: 0.65rem;
                font-weight: 600;
                letter-spacing: 0.12em;
                text-transform: uppercase;
                color: var(--brand-muted);
                padding: 1rem 1.25rem 0.4rem;
                font-family: 'IBM Plex Mono', monospace;
            }

            .nav-item-link {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.6rem 1.25rem;
                font-size: 0.875rem;
                color: #94a3b8;
                text-decoration: none;
                border-radius: 0;
                transition: background 0.15s, color 0.15s;
                cursor: pointer;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
            }

            .nav-item-link:hover {
                background: rgba(26,108,255,0.1);
                color: var(--brand-text);
            }

            .nav-item-link.active {
                background: rgba(26,108,255,0.18);
                color: var(--brand-accent);
                font-weight: 600;
                border-right: 3px solid var(--brand-blue);
            }

            .nav-item-link i { font-size: 1rem; flex-shrink: 0; }

            .sidebar-footer {
                margin-top: auto;
                padding: 1rem 1.25rem;
                border-top: 1px solid var(--brand-border);
            }

            .user-info-chip {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.6rem 0;
            }

            .user-avatar {
                width: 36px; height: 36px;
                background: linear-gradient(135deg, #3b82f6, #06b6d4);
                border-radius: 50%;
                display: flex; align-items: center; justify-content: center;
                font-size: 0.9rem; color: white; font-weight: 600; flex-shrink: 0;
            }

            .user-info-name { font-size: 0.83rem; font-weight: 600; color: var(--brand-text); }
            .user-info-role { font-size: 0.7rem; color: var(--brand-muted); font-family: 'IBM Plex Mono', monospace; }

            /* ---- Main content ---- */
            .main-content {
                margin-left: var(--sidebar-w);
                padding: 0;
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

            .topbar-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--brand-text);
            }

            .topbar-title span {
                font-size: 0.8rem;
                color: var(--brand-muted);
                font-weight: 400;
                margin-left: 0.5rem;
                font-family: 'IBM Plex Mono', monospace;
            }

            .page-body {
                padding: 1.75rem;
            }

            /* Stat cards */
            .stat-card {
                background: var(--brand-surface);
                border: 1px solid var(--brand-border);
                border-radius: 0.75rem;
                padding: 1.25rem 1.5rem;
                transition: border-color 0.2s;
            }

            .stat-card:hover { border-color: var(--brand-blue); }

            .stat-card .stat-icon {
                width: 44px; height: 44px;
                border-radius: 10px;
                display: flex; align-items: center; justify-content: center;
                font-size: 1.2rem;
                margin-bottom: 0.75rem;
            }

            .stat-card .stat-value {
                font-size: 1.6rem;
                font-weight: 700;
                font-family: 'IBM Plex Mono', monospace;
                color: var(--brand-text);
                line-height: 1;
                margin-bottom: 0.25rem;
            }

            .stat-card .stat-label {
                font-size: 0.78rem;
                color: var(--brand-muted);
            }

            /* Content section cards */
            .section-card {
                background: var(--brand-surface);
                border: 1px solid var(--brand-border);
                border-radius: 0.75rem;
                overflow: hidden;
            }

            .section-card-header {
                padding: 1rem 1.25rem;
                border-bottom: 1px solid var(--brand-border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .section-card-header h6 {
                font-size: 0.875rem;
                font-weight: 600;
                color: var(--brand-text);
                margin: 0;
            }

            .section-card-body { padding: 1.25rem; }

            .placeholder-box {
                background: rgba(26,108,255,0.05);
                border: 1px dashed var(--brand-border);
                border-radius: 0.5rem;
                padding: 2.5rem 1rem;
                text-align: center;
                color: var(--brand-muted);
                font-size: 0.83rem;
            }

            .placeholder-box i { font-size: 2rem; display: block; margin-bottom: 0.5rem; }

            .badge-role {
                background: rgba(26,108,255,0.2);
                color: var(--brand-accent);
                border: 1px solid rgba(26,108,255,0.3);
                font-size: 0.68rem;
                font-family: 'IBM Plex Mono', monospace;
                letter-spacing: 0.08em;
                padding: 0.2rem 0.55rem;
                border-radius: 1rem;
            }

            /* Notification badge */
            .notif-dot {
                width: 8px; height: 8px;
                background: #f59e0b;
                border-radius: 50%;
                display: inline-block;
                margin-left: 0.25rem;
                vertical-align: middle;
            }

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
                <div>
                    <div>Network<br>Manager</div>
                </div>
            </div>

            <div class="sidebar-section-label">Overview</div>
            <button class="nav-item-link active" onclick="showPage('dashboard', this)">
                <i class="bi bi-grid-1x2-fill"></i> Dashboard
            </button>

            <div class="sidebar-section-label">My Account</div>
            <button class="nav-item-link" onclick="showPage('profile', this)">
                <i class="bi bi-person-circle"></i> My Profile
            </button>
            <button class="nav-item-link" onclick="showPage('mydevices', this)">
                <i class="bi bi-laptop"></i> My Devices
            </button>
            <button class="nav-item-link" onclick="showPage('notifications', this)">
                <i class="bi bi-bell"></i> Notifications
                <span class="notif-dot ms-auto"></span>
            </button>

            <div class="sidebar-section-label">Support</div>
            <button class="nav-item-link" onclick="showPage('tickets', this)">
                <i class="bi bi-ticket-perforated"></i> My Tickets
            </button>
            <button class="nav-item-link" onclick="showPage('createticket', this)">
                <i class="bi bi-plus-circle"></i> Create Ticket
            </button>

            <div class="sidebar-section-label">Settings</div>
            <button class="nav-item-link" onclick="showPage('changepassword', this)">
                <i class="bi bi-key"></i> Change Password
            </button>

            <div class="sidebar-footer">
                <div class="user-info-chip">
                    <div class="user-avatar"><%= displayName.charAt(0) %></div>
                    <div>
                        <div class="user-info-name"><%= displayName %></div>
                        <div class="user-info-role">USER</div>
                    </div>
                </div>
                <a href="LoginController?action=logout" class="nav-item-link text-danger mt-1" style="padding-left:0;">
                    <i class="bi bi-box-arrow-left"></i> Sign Out
                </a>
            </div>
        </nav>

        <!-- ===== MAIN CONTENT ===== -->
        <div class="main-content">

            <!-- Topbar -->
            <div class="topbar">
                <div class="topbar-title">
                    <span id="pageTitle">Dashboard</span>
                    <span id="pageBreadcrumb">/ Overview</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-role">USER</span>
                    <span style="font-size:0.82rem; color:var(--brand-muted);">
                        Welcome, <strong style="color:var(--brand-text);"><%= displayName %></strong>
                    </span>
                </div>
            </div>

            <div class="page-body">

                <!-- ===== PAGE: DASHBOARD ===== -->
                <div class="page-section active" id="page-dashboard">
                    <div class="row g-3 mb-4">
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(26,108,255,0.15); color:#1a6cff;">
                                    <i class="bi bi-laptop"></i>
                                </div>
                                <div class="stat-value">2</div>
                                <div class="stat-label">My Devices</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(245,158,11,0.15); color:#f59e0b;">
                                    <i class="bi bi-ticket-perforated"></i>
                                </div>
                                <div class="stat-value">1</div>
                                <div class="stat-label">Open Tickets</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(34,197,94,0.15); color:#22c55e;">
                                    <i class="bi bi-reception-4"></i>
                                </div>
                                <div class="stat-value">Online</div>
                                <div class="stat-label">Network Status</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(0,229,255,0.12); color:#00e5ff;">
                                    <i class="bi bi-bell"></i>
                                </div>
                                <div class="stat-value">3</div>
                                <div class="stat-label">Notifications</div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-laptop me-2"></i>My Active Devices</h6>
                                    <button class="btn btn-sm" style="font-size:0.75rem; color:var(--brand-accent);" onclick="showPage('mydevices', null)">View All</button>
                                </div>
                                <div class="section-card-body">
                                    <div class="placeholder-box">
                                        <i class="bi bi-laptop"></i>
                                        Device list will appear here
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="section-card">
                                <div class="section-card-header">
                                    <h6><i class="bi bi-ticket-perforated me-2"></i>Recent Tickets</h6>
                                    <button class="btn btn-sm" style="font-size:0.75rem; color:var(--brand-accent);" onclick="showPage('tickets', null)">View All</button>
                                </div>
                                <div class="section-card-body">
                                    <div class="placeholder-box">
                                        <i class="bi bi-ticket-perforated"></i>
                                        Your support tickets will appear here
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: PROFILE ===== -->
                <div class="page-section" id="page-profile">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-person-circle me-2"></i>My Profile</h6>
                        </div>
                        <div class="section-card-body">
                            <div class="row g-3">
                                <div class="col-md-4 text-center">
                                    <div class="user-avatar mx-auto mb-3" style="width:72px;height:72px;font-size:2rem;">
                                        <%= displayName.charAt(0) %>
                                    </div>
                                    <div style="font-weight:600;"><%= displayName %></div>
                                    <div style="font-size:0.78rem;color:var(--brand-muted);font-family:'IBM Plex Mono',monospace;">USER</div>
                                </div>
                                <div class="col-md-8">
                                    <div class="row g-2">
                                        <div class="col-12 col-sm-6">
                                            <label class="form-label" style="font-size:0.75rem;color:var(--brand-muted);text-transform:uppercase;letter-spacing:.05em;">Full Name</label>
                                            <div class="form-control" style="background:rgba(255,255,255,0.04);border-color:var(--brand-border);color:var(--brand-text);"><%= displayName %></div>
                                        </div>
                                        <div class="col-12 col-sm-6">
                                            <label class="form-label" style="font-size:0.75rem;color:var(--brand-muted);text-transform:uppercase;letter-spacing:.05em;">Username</label>
                                            <div class="form-control" style="background:rgba(255,255,255,0.04);border-color:var(--brand-border);color:var(--brand-text);"><%= currentUser.getUserName() %></div>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label" style="font-size:0.75rem;color:var(--brand-muted);text-transform:uppercase;letter-spacing:.05em;">Email</label>
                                            <div class="form-control" style="background:rgba(255,255,255,0.04);border-color:var(--brand-border);color:var(--brand-text);">
                                                <%= (currentUser.getEmail() != null && !currentUser.getEmail().isEmpty()) ? currentUser.getEmail() : "—" %>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label" style="font-size:0.75rem;color:var(--brand-muted);text-transform:uppercase;letter-spacing:.05em;">Status</label>
                                            <div>
                                                <span class="badge bg-success">Active</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: MY DEVICES ===== -->
                <div class="page-section" id="page-mydevices">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-laptop me-2"></i>My Registered Devices</h6>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-laptop"></i>
                                Your registered network devices will appear here.<br>
                                <small>Device name, MAC address, IP, and connection status.</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: NOTIFICATIONS ===== -->
                <div class="page-section" id="page-notifications">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-bell me-2"></i>Notifications</h6>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-bell"></i>
                                System notifications and alerts will appear here.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: MY TICKETS ===== -->
                <div class="page-section" id="page-tickets">
                    <div class="section-card">
                        <div class="section-card-header">
                            <h6><i class="bi bi-ticket-perforated me-2"></i>My Support Tickets</h6>
                        </div>
                        <div class="section-card-body">
                            <div class="placeholder-box">
                                <i class="bi bi-ticket-perforated"></i>
                                Your submitted support tickets will appear here.<br>
                                <small>Title, status, date created.</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: CREATE TICKET ===== -->
                <div class="page-section" id="page-createticket">
                    <div class="section-card" style="max-width:600px;">
                        <div class="section-card-header">
                            <h6><i class="bi bi-plus-circle me-2"></i>Create Support Ticket</h6>
                        </div>
                        <div class="section-card-body">
                            <form>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">Title</label>
                                    <input type="text" class="form-control" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);" placeholder="Brief description of your issue">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">Description</label>
                                    <textarea class="form-control" rows="5" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);" placeholder="Describe your issue in detail..."></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">Related Device (optional)</label>
                                    <select class="form-select" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);">
                                        <option value="">— None —</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn" style="background:var(--brand-blue);color:white;font-weight:600;">
                                    <i class="bi bi-send me-2"></i>Submit Ticket
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ===== PAGE: CHANGE PASSWORD ===== -->
                <div class="page-section" id="page-changepassword">
                    <div class="section-card" style="max-width:480px;">
                        <div class="section-card-header">
                            <h6><i class="bi bi-key me-2"></i>Change Password</h6>
                        </div>
                        <div class="section-card-body">
                            <form>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">Current Password</label>
                                    <input type="password" class="form-control" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);" placeholder="Current password">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">New Password</label>
                                    <input type="password" class="form-control" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);" placeholder="New password">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-size:0.8rem;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;">Confirm New Password</label>
                                    <input type="password" class="form-control" style="background:#0d1526;border-color:var(--brand-border);color:var(--brand-text);" placeholder="Repeat new password">
                                </div>
                                <button type="submit" class="btn" style="background:var(--brand-blue);color:white;font-weight:600;">
                                    <i class="bi bi-check2-circle me-2"></i>Update Password
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

            </div><!-- end page-body -->
        </div><!-- end main-content -->

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const pageTitles = {
                'dashboard':      ['Dashboard',       '/ Overview'],
                'profile':        ['My Profile',      '/ Account'],
                'mydevices':      ['My Devices',      '/ Account'],
                'notifications':  ['Notifications',   '/ Account'],
                'tickets':        ['My Tickets',      '/ Support'],
                'createticket':   ['Create Ticket',   '/ Support'],
                'changepassword': ['Change Password', '/ Settings']
            };

            function showPage(pageId, triggerEl) {
                // Hide all sections
                document.querySelectorAll('.page-section').forEach(s => s.classList.remove('active'));
                document.querySelectorAll('.nav-item-link').forEach(b => b.classList.remove('active'));

                document.getElementById('page-' + pageId).classList.add('active');
                if (triggerEl) triggerEl.classList.add('active');

                const [title, crumb] = pageTitles[pageId] || ['Dashboard', '/ Overview'];
                document.getElementById('pageTitle').textContent = title;
                document.getElementById('pageBreadcrumb').textContent = crumb;
            }
        </script>
    </body>
</html>
