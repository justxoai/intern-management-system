<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sign In — Internship Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        /* ── Left Panel ── */
        .left-panel {
            background: linear-gradient(145deg, #0f2350 0%, #1565c0 50%, #1e88e5 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 48px;
            position: relative;
            overflow: hidden;
        }
        .left-panel::before {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,.05);
            top: -100px; left: -100px;
        }
        .left-panel::after {
            content: '';
            position: absolute;
            width: 300px; height: 300px;
            border-radius: 50%;
            background: rgba(255,255,255,.04);
            bottom: -80px; right: -80px;
        }
        .brand-icon {
            width: 72px; height: 72px;
            background: rgba(255,255,255,.15);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; color: #fff;
            margin-bottom: 28px;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,.2);
        }
        .brand-title { color: #fff; font-size: 1.9rem; font-weight: 700; text-align: center; margin-bottom: 12px; line-height: 1.2; }
        .brand-sub   { color: rgba(255,255,255,.7); font-size: .95rem; text-align: center; line-height: 1.6; max-width: 340px; margin-bottom: 48px; }

        .feature-list { list-style: none; width: 100%; max-width: 340px; }
        .feature-list li {
            display: flex; align-items: center; gap: 12px;
            color: rgba(255,255,255,.85); font-size: .88rem;
            padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,.1);
        }
        .feature-list li:last-child { border-bottom: none; }
        .feature-list .fi {
            width: 32px; height: 32px; border-radius: 8px;
            background: rgba(255,255,255,.12);
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; flex-shrink: 0;
        }

        /* ── Right Panel ── */
        .right-panel {
            background: #f8fafc;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 48px;
        }

        .login-box { width: 100%; max-width: 400px; }

        .login-heading { font-size: 1.65rem; font-weight: 700; color: #0f2350; margin-bottom: 6px; }
        .login-sub     { color: #64748b; font-size: .9rem; margin-bottom: 36px; }

        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block; font-size: .82rem; font-weight: 600;
            color: #374151; margin-bottom: 7px; text-transform: uppercase; letter-spacing: .4px;
        }
        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            color: #94a3b8; font-size: 1.05rem; pointer-events: none;
        }
        .form-input {
            width: 100%; padding: 12px 14px 12px 42px;
            border: 1.5px solid #e2e8f0; border-radius: 10px;
            font-family: 'Inter', sans-serif; font-size: .92rem; color: #1e293b;
            background: #fff; outline: none;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-input:focus {
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(21,101,192,.12);
        }
        .form-input::placeholder { color: #94a3b8; }

        .toggle-pass {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #94a3b8; font-size: 1rem; padding: 0;
        }
        .toggle-pass:hover { color: #1565c0; }

        .error-alert {
            background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px;
            padding: 12px 16px; display: flex; align-items: center; gap: 10px;
            color: #dc2626; font-size: .87rem; margin-bottom: 20px;
        }

        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #1565c0 0%, #1e88e5 100%);
            color: #fff; border: none; border-radius: 10px;
            font-family: 'Inter', sans-serif; font-size: .97rem; font-weight: 600;
            cursor: pointer; letter-spacing: .3px;
            transition: transform .15s, box-shadow .2s;
            box-shadow: 0 4px 14px rgba(21,101,192,.35);
            margin-top: 8px;
        }
        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(21,101,192,.45);
        }
        .btn-login:active { transform: translateY(0); }

        .divider { display: flex; align-items: center; gap: 12px; margin: 28px 0 20px; }
        .divider hr { flex: 1; border: none; border-top: 1px solid #e2e8f0; }
        .divider span { color: #94a3b8; font-size: .8rem; }

        .demo-accounts { background: #f1f5f9; border-radius: 10px; padding: 16px 18px; }
        .demo-title { font-size: .75rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: .4px; margin-bottom: 10px; }
        .demo-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .demo-item {
            background: #fff; border-radius: 8px; padding: 10px 12px;
            border: 1px solid #e2e8f0; cursor: pointer;
            transition: border-color .2s, box-shadow .15s;
        }
        .demo-item:hover { border-color: #1565c0; box-shadow: 0 2px 8px rgba(21,101,192,.12); }
        .demo-role { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .4px; margin-bottom: 2px; }
        .demo-creds { font-size: .78rem; color: #64748b; font-family: monospace; }
        .role-admin  { color: #dc2626; }
        .role-hr     { color: #0891b2; }
        .role-mentor { color: #059669; }
        .role-intern { color: #7c3aed; }

        .footer-note { text-align: center; color: #94a3b8; font-size: .78rem; margin-top: 28px; }

        @media (max-width: 768px) {
            body { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 40px 24px; }
        }
    </style>
</head>
<body>

<!-- Left decorative panel -->
<div class="left-panel">
    <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
    <h1 class="brand-title">Internship<br>Management System</h1>
    <p class="brand-sub">A unified platform for managing your internship program from onboarding to evaluation.</p>
    <ul class="feature-list">
        <li>
            <span class="fi"><i class="bi bi-shield-check"></i></span>
            Role-based access control
        </li>
        <li>
            <span class="fi"><i class="bi bi-people"></i></span>
            Intern & mentor management
        </li>
        <li>
            <span class="fi"><i class="bi bi-list-task"></i></span>
            Task assignment & tracking
        </li>
        <li>
            <span class="fi"><i class="bi bi-bar-chart"></i></span>
            Progress reports & evaluations
        </li>
    </ul>
</div>

<!-- Right login panel -->
<div class="right-panel">
    <div class="login-box">
        <h2 class="login-heading">Welcome back 👋</h2>
        <p class="login-sub">Sign in to access your dashboard</p>

        <c:if test="${param.registered == '1'}">
            <div style="background:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;padding:12px 16px;display:flex;align-items:center;gap:10px;color:#15803d;font-size:.86rem;font-weight:500;margin-bottom:16px">
                <i class="bi bi-check-circle-fill"></i>
                Registration successful! Please sign in with your new account.
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="error-alert">
                <i class="bi bi-exclamation-circle-fill"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <div class="input-wrap">
                    <i class="bi bi-person input-icon"></i>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Enter your username" value="${username}" required autocomplete="username">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrap">
                    <i class="bi bi-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="Enter your password" required autocomplete="current-password">
                    <button type="button" class="toggle-pass" onclick="togglePassword()" id="toggleBtn">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-login" id="loginBtn">
                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
            </button>
        </form>

        <div class="divider">
            <hr><span>Quick access demo accounts</span><hr>
        </div>

        <div class="demo-accounts">
            <div class="demo-title">Demo Credentials (all passwords: 123456)</div>
            <div class="demo-grid">
                <div class="demo-item" onclick="fillLogin('admin','123456')">
                    <div class="demo-role role-admin"><i class="bi bi-shield-fill me-1"></i>Admin</div>
                    <div class="demo-creds">admin / 123456</div>
                </div>
                <div class="demo-item" onclick="fillLogin('hr01','123456')">
                    <div class="demo-role role-hr"><i class="bi bi-building me-1"></i>HR</div>
                    <div class="demo-creds">hr01 / 123456</div>
                </div>
                <div class="demo-item" onclick="fillLogin('mentor01','123456')">
                    <div class="demo-role role-mentor"><i class="bi bi-mortarboard me-1"></i>Mentor</div>
                    <div class="demo-creds">mentor01 / 123456</div>
                </div>
                <div class="demo-item" onclick="fillLogin('intern01','123456')">
                    <div class="demo-role role-intern"><i class="bi bi-person-workspace me-1"></i>Intern</div>
                    <div class="demo-creds">intern01 / 123456</div>
                </div>
            </div>
        </div>

        <p class="footer-note">© 2026 Internship Management System. All rights reserved.</p>
        <p class="footer-note" style="margin-top:8px">
            New intern? <a href="${pageContext.request.contextPath}/register" style="color:var(--accent);font-weight:600;text-decoration:none">Register here →</a>
        </p>
    </div>
</div>

<script>
    function togglePassword() {
        const pw  = document.getElementById('password');
        const ico = document.getElementById('eyeIcon');
        if (pw.type === 'password') {
            pw.type = 'text';
            ico.className = 'bi bi-eye-slash';
        } else {
            pw.type = 'password';
            ico.className = 'bi bi-eye';
        }
    }

    function fillLogin(user, pass) {
        document.getElementById('username').value = user;
        document.getElementById('password').value = pass;
        document.getElementById('loginBtn').focus();
    }

    // Prevent double-submit
    document.getElementById('loginForm').addEventListener('submit', function () {
        document.getElementById('loginBtn').disabled = true;
        document.getElementById('loginBtn').innerHTML = '<i class="bi bi-arrow-repeat me-1"></i> Signing in...';
    });
</script>
</body>
</html>
