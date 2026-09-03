<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><fmt:message key="login.title"/></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
            width: 80px; height: 80px;
            background: rgba(255,255,255,.15);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.4rem; color: #fff;
            margin-bottom: 24px;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,.2);
            box-shadow: 0 10px 30px rgba(0,0,0,.15);
        }
        .brand-title {
            color: #fff; font-size: 2.2rem; font-weight: 700;
            text-align: center; line-height: 1.25;
            letter-spacing: -.5px;
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

        /* ── Lang switcher ── */
        .lang-bar { display: flex; justify-content: flex-end; margin-bottom: 20px; gap: 6px; }
        .lang-btn {
            padding: 4px 12px; border-radius: 20px; border: 1.5px solid #e2e8f0;
            background: #fff; font-size: .75rem; font-weight: 600; color: #64748b;
            cursor: pointer; text-decoration: none; transition: all .15s;
        }
        .lang-btn:hover, .lang-btn.active { background: #1565c0; color: #fff; border-color: #1565c0; }

        .login-heading { font-size: 1.75rem; font-weight: 700; color: #0f2350; margin-bottom: 6px; letter-spacing: -.4px; }
        .login-sub     { color: #64748b; font-size: .92rem; margin-bottom: 32px; }

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
        .success-alert {
            background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px;
            padding: 12px 16px; display: flex; align-items: center; gap: 10px;
            color: #15803d; font-size: .86rem; font-weight: 500; margin-bottom: 16px;
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

        .footer-note { text-align: center; color: #64748b; font-size: .87rem; margin-top: 24px; }
        .footer-note a { color: #1565c0; font-weight: 600; text-decoration: none; }
        .footer-note a:hover { text-decoration: underline; }

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
    <h1 class="brand-title"><fmt:message key="app.name"/></h1>
</div>

<!-- Right login panel -->
<div class="right-panel">
    <div class="login-box">

        <h2 class="login-heading"><fmt:message key="login.heading"/></h2>
        <p class="login-sub"><fmt:message key="login.subheading"/></p>

        <c:if test="${param.registered == '1'}">
            <div class="success-alert">
                <i class="bi bi-check-circle-fill"></i>
                <fmt:message key="login.heading"/> — <fmt:message key="login.register.link"/>!
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
                <label class="form-label" for="username"><fmt:message key="login.username"/></label>
                <div class="input-wrap">
                    <i class="bi bi-person input-icon"></i>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="<fmt:message key='login.username.placeholder'/>"
                           value="${username}" required autocomplete="username">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password"><fmt:message key="login.password"/></label>
                <div class="input-wrap">
                    <i class="bi bi-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="<fmt:message key='login.password.placeholder'/>"
                           required autocomplete="current-password">
                    <button type="button" class="toggle-pass" onclick="togglePassword()" id="toggleBtn">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-login" id="loginBtn">
                <i class="bi bi-box-arrow-in-right"></i>&nbsp;<fmt:message key="login.submit"/>
            </button>
        </form>

        <p class="footer-note">
            <fmt:message key="login.register.prompt"/>
            <a href="${pageContext.request.contextPath}/register"><fmt:message key="login.register.link"/> &rarr;</a>
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

    // Prevent double-submit
    document.getElementById('loginForm').addEventListener('submit', function () {
        document.getElementById('loginBtn').disabled = true;
        document.getElementById('loginBtn').innerHTML = '<i class="bi bi-arrow-repeat"></i> ...';
    });
</script>
</body>
</html>
