<%-- 
    login.jsp - Login Page
    Step 3 of auth flow: After verification → user enters credentials
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Network Manager — Sign In</title>
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
                --brand-input-bg: #0d1526;
            }

            body {
                background-color: var(--brand-dark);
                color: var(--brand-text);
                font-family: 'IBM Plex Sans', sans-serif;
                min-height: 100vh;
                display: flex;
                overflow: hidden;
            }

            /* Left panel — branding */
            .login-left {
                background: linear-gradient(160deg, #0a1628 0%, #0d2347 50%, #0a1628 100%);
                border-right: 1px solid var(--brand-border);
                width: 42%;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 3rem 2.5rem;
                position: relative;
            }

            /* Animated circuit lines on left panel */
            .login-left::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image:
                    linear-gradient(rgba(0,229,255,0.05) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(0,229,255,0.05) 1px, transparent 1px);
                background-size: 32px 32px;
            }

            .left-content {
                position: relative;
                z-index: 1;
                text-align: center;
            }

            .brand-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: rgba(26,108,255,0.15);
                border: 1px solid rgba(26,108,255,0.4);
                border-radius: 2rem;
                padding: 0.35rem 1rem;
                font-family: 'IBM Plex Mono', monospace;
                font-size: 0.7rem;
                color: var(--brand-accent);
                letter-spacing: 0.1em;
                text-transform: uppercase;
                margin-bottom: 2rem;
            }

            .brand-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, var(--brand-blue), var(--brand-accent));
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.2rem;
                color: white;
                margin: 0 auto 1.5rem;
                box-shadow: 0 0 40px rgba(0,229,255,0.25);
            }

            .brand-name {
                font-family: 'IBM Plex Mono', monospace;
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--brand-text);
                margin-bottom: 0.5rem;
            }

            .brand-desc {
                font-size: 0.875rem;
                color: var(--brand-muted);
                line-height: 1.6;
                max-width: 280px;
                margin: 0 auto 2.5rem;
            }

            .feature-list {
                list-style: none;
                padding: 0;
                margin: 0;
                text-align: left;
                width: 100%;
                max-width: 280px;
            }

            .feature-list li {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.5rem 0;
                font-size: 0.82rem;
                color: #94a3b8;
                border-bottom: 1px solid rgba(255,255,255,0.05);
            }

            .feature-list li:last-child { border-bottom: none; }

            .feature-list li i {
                color: var(--brand-accent);
                font-size: 0.9rem;
                flex-shrink: 0;
            }

            /* Right panel — form */
            .login-right {
                flex: 1;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 3rem 2rem;
                background: var(--brand-dark);
            }

            .login-form-wrap {
                width: 100%;
                max-width: 380px;
                animation: slideIn 0.5s ease both;
                animation-delay: 0.1s;
                opacity: 0;
            }

            @keyframes slideIn {
                from { opacity: 0; transform: translateX(20px); }
                to   { opacity: 1; transform: translateX(0); }
            }

            .form-heading {
                margin-bottom: 2rem;
            }

            .form-heading h2 {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--brand-text);
                margin-bottom: 0.25rem;
            }

            .form-heading p {
                font-size: 0.83rem;
                color: var(--brand-muted);
            }

            .form-label {
                font-size: 0.8rem;
                font-weight: 600;
                color: #94a3b8;
                letter-spacing: 0.05em;
                text-transform: uppercase;
                margin-bottom: 0.4rem;
            }

            .form-control {
                background: var(--brand-input-bg);
                border: 1px solid var(--brand-border);
                color: var(--brand-text);
                border-radius: 0.5rem;
                padding: 0.65rem 0.875rem;
                font-size: 0.9rem;
                transition: border-color 0.2s, box-shadow 0.2s;
            }

            .form-control:focus {
                background: var(--brand-input-bg);
                border-color: var(--brand-blue);
                box-shadow: 0 0 0 3px rgba(26,108,255,0.15);
                color: var(--brand-text);
                outline: none;
            }

            .form-control::placeholder {
                color: #374151;
            }

            .input-group-text {
                background: var(--brand-input-bg);
                border: 1px solid var(--brand-border);
                color: var(--brand-muted);
                border-radius: 0 0.5rem 0.5rem 0;
            }

            .input-group .form-control {
                border-right: none;
                border-radius: 0.5rem 0 0 0.5rem;
            }

            .btn-login {
                background: var(--brand-blue);
                border: none;
                color: white;
                font-weight: 600;
                font-size: 0.9rem;
                padding: 0.7rem;
                border-radius: 0.5rem;
                width: 100%;
                letter-spacing: 0.03em;
                transition: background 0.2s, box-shadow 0.2s, transform 0.1s;
            }

            .btn-login:hover {
                background: #2563eb;
                box-shadow: 0 4px 16px rgba(26,108,255,0.4);
                transform: translateY(-1px);
                color: white;
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .divider {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                color: var(--brand-muted);
                font-size: 0.78rem;
                margin: 1.25rem 0;
            }

            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: var(--brand-border);
            }

            .alert-error {
                background: rgba(239,68,68,0.1);
                border: 1px solid rgba(239,68,68,0.3);
                border-radius: 0.5rem;
                color: #fca5a5;
                font-size: 0.83rem;
                padding: 0.65rem 0.875rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .remember-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.25rem;
            }

            .form-check-input {
                background-color: var(--brand-input-bg);
                border-color: var(--brand-border);
            }

            .form-check-input:checked {
                background-color: var(--brand-blue);
                border-color: var(--brand-blue);
            }

            .form-check-label {
                font-size: 0.82rem;
                color: var(--brand-muted);
            }

            .footer-note {
                margin-top: 2rem;
                font-size: 0.75rem;
                color: var(--brand-muted);
                text-align: center;
                font-family: 'IBM Plex Mono', monospace;
            }

            /* Responsive: stack on small screens */
            @media (max-width: 768px) {
                body { flex-direction: column; }
                .login-left {
                    width: 100%;
                    min-height: auto;
                    padding: 2rem 1.5rem;
                }
                .feature-list { display: none; }
            }
        </style>
    </head>
    <body>

        <!-- Left Branding Panel -->
        <div class="login-left">
            <div class="left-content">
                <div class="brand-badge">
                    <i class="bi bi-shield-lock-fill"></i>
                    Secure Portal
                </div>
                <div class="brand-icon">
                    <i class="bi bi-wifi"></i>
                </div>
                <div class="brand-name">Network Manager</div>
                <p class="brand-desc">University-wide network infrastructure management for devices, access points, and connectivity.</p>

                <ul class="feature-list">
                    <li><i class="bi bi-router-fill"></i> Real-time device monitoring</li>
                    <li><i class="bi bi-reception-4"></i> Access point management</li>
                    <li><i class="bi bi-bar-chart-fill"></i> Bandwidth analytics</li>
                    <li><i class="bi bi-bell-fill"></i> Alert & notification system</li>
                    <li><i class="bi bi-tools"></i> Maintenance scheduling</li>
                    <li><i class="bi bi-ticket-perforated-fill"></i> Support ticket system</li>
                </ul>
            </div>
        </div>

        <!-- Right Form Panel -->
        <div class="login-right">
            <div class="login-form-wrap">

                <div class="form-heading">
                    <h2>Sign In</h2>
                    <p>Enter your university credentials to continue</p>
                </div>

                <%-- Show error message if login failed --%>
                <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
                <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                <div class="alert-error mb-3">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <%= errorMsg %>
                </div>
                <% } %>

                <form action="LoginController" method="POST" autocomplete="off">

                    <div class="mb-3">
                        <label class="form-label" for="username">Username</label>
                        <input type="text"
                               class="form-control"
                               id="username"
                               name="username"
                               placeholder="Enter your username"
                               required
                               autofocus>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="password">Password</label>
                        <div class="input-group">
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   required>
                            <span class="input-group-text" id="togglePwd" style="cursor:pointer;">
                                <i class="bi bi-eye-slash" id="eyeIcon"></i>
                            </span>
                        </div>
                    </div>

                    <div class="remember-row">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                            <label class="form-check-label" for="rememberMe">Remember me</label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                    </button>

                </form>

                <div class="divider">or</div>

                <div class="text-center" style="font-size:0.82rem; color: #64748b;">
                    Contact your administrator if you cannot access your account.
                </div>

                <div class="footer-note">
                    &copy; University Network Management System
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Toggle password visibility
            document.getElementById('togglePwd').addEventListener('click', function () {
                const pwd = document.getElementById('password');
                const icon = document.getElementById('eyeIcon');
                if (pwd.type === 'password') {
                    pwd.type = 'text';
                    icon.className = 'bi bi-eye';
                } else {
                    pwd.type = 'password';
                    icon.className = 'bi bi-eye-slash';
                }
            });
        </script>
    </body>
</html>
