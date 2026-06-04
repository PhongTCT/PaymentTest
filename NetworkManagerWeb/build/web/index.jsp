<%-- 
    index.jsp - Verification / Entry Page
    Step 1 of auth flow: User opens app → sees this page → redirects to login
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Network Manager — Verifying</title>
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
            }

            * { box-sizing: border-box; }

            body {
                background-color: var(--brand-dark);
                color: var(--brand-text);
                font-family: 'IBM Plex Sans', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }

            /* Animated grid background */
            body::before {
                content: '';
                position: fixed;
                inset: 0;
                background-image:
                    linear-gradient(rgba(26,108,255,0.07) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(26,108,255,0.07) 1px, transparent 1px);
                background-size: 48px 48px;
                z-index: 0;
                animation: gridPan 20s linear infinite;
            }

            @keyframes gridPan {
                0%   { background-position: 0 0; }
                100% { background-position: 48px 48px; }
            }

            .verify-card {
                position: relative;
                z-index: 1;
                background: var(--brand-surface);
                border: 1px solid var(--brand-border);
                border-radius: 1rem;
                padding: 3rem 2.5rem;
                max-width: 420px;
                width: 100%;
                text-align: center;
                box-shadow: 0 0 60px rgba(26,108,255,0.15), 0 0 0 1px rgba(0,229,255,0.05);
                animation: fadeUp 0.6s ease both;
            }

            @keyframes fadeUp {
                from { opacity: 0; transform: translateY(20px); }
                to   { opacity: 1; transform: translateY(0); }
            }

            .verify-logo {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--brand-blue), var(--brand-accent));
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                font-size: 1.75rem;
                color: white;
                box-shadow: 0 0 30px rgba(0,229,255,0.3);
            }

            .verify-title {
                font-family: 'IBM Plex Mono', monospace;
                font-size: 1.1rem;
                font-weight: 600;
                letter-spacing: 0.08em;
                color: var(--brand-accent);
                text-transform: uppercase;
                margin-bottom: 0.25rem;
            }

            .verify-subtitle {
                font-size: 0.85rem;
                color: var(--brand-muted);
                margin-bottom: 2rem;
                font-family: 'IBM Plex Mono', monospace;
            }

            /* Progress bar */
            .verify-progress {
                background: rgba(255,255,255,0.08);
                border-radius: 4px;
                height: 4px;
                overflow: hidden;
                margin-bottom: 1rem;
            }

            .verify-progress-bar {
                height: 100%;
                border-radius: 4px;
                background: linear-gradient(90deg, var(--brand-blue), var(--brand-accent));
                animation: verifyProgress 2.8s ease forwards;
            }

            @keyframes verifyProgress {
                0%   { width: 0%; }
                30%  { width: 40%; }
                60%  { width: 70%; }
                85%  { width: 90%; }
                100% { width: 100%; }
            }

            .verify-status {
                font-family: 'IBM Plex Mono', monospace;
                font-size: 0.78rem;
                color: var(--brand-muted);
                min-height: 1.4em;
                transition: all 0.3s ease;
            }

            .verify-status.success {
                color: #22c55e;
            }

            .check-icon {
                font-size: 2.5rem;
                color: #22c55e;
                display: none;
                animation: popIn 0.4s cubic-bezier(0.175,0.885,0.32,1.275) both;
            }

            @keyframes popIn {
                from { opacity: 0; transform: scale(0.4); }
                to   { opacity: 1; transform: scale(1); }
            }

            .footer-text {
                position: fixed;
                bottom: 1.5rem;
                font-size: 0.75rem;
                color: var(--brand-muted);
                font-family: 'IBM Plex Mono', monospace;
                z-index: 1;
            }
        </style>
    </head>
    <body>

        <div class="verify-card">
            <div class="verify-logo">
                <i class="bi bi-wifi"></i>
            </div>
            <div class="verify-title">Network Manager</div>
            <div class="verify-subtitle">University Network Management System</div>

            <div id="progressSection">
                <div class="verify-progress">
                    <div class="verify-progress-bar"></div>
                </div>
                <div class="verify-status" id="statusText">Initializing connection...</div>
            </div>

            <div class="check-icon mt-3" id="checkIcon">
                <i class="bi bi-patch-check-fill"></i>
            </div>
        </div>

        <div class="footer-text">&copy; University Network Management System</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const messages = [
                { t: 500,  msg: "Checking system availability..." },
                { t: 1100, msg: "Verifying security certificate..." },
                { t: 1800, msg: "Establishing secure channel..." },
                { t: 2400, msg: "Verification complete." }
            ];

            messages.forEach(({ t, msg }) => {
                setTimeout(() => {
                    const el = document.getElementById('statusText');
                    el.textContent = msg;
                    if (msg.includes("complete")) el.classList.add('success');
                }, t);
            });

            // After verification completes, show checkmark then redirect to login
            setTimeout(() => {
                document.getElementById('progressSection').style.display = 'none';
                document.getElementById('checkIcon').style.display = 'block';
            }, 2800);

            setTimeout(() => {
                window.location.href = 'login.jsp';
            }, 3600);
        </script>
    </body>
</html>
