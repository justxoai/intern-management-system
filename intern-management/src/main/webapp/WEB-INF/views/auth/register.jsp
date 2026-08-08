<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register — Internship Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --accent: #8b5cf6; --accent2: #a78bfa; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #1a0533 0%, #0c1f3f 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 40px 20px; }

        .register-wrap { width: 100%; max-width: 760px; }

        .brand { text-align: center; margin-bottom: 28px; }
        .brand-icon { width: 52px; height: 52px; border-radius: 14px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #fff; margin: 0 auto 12px; box-shadow: 0 6px 20px rgba(139,92,246,.4); }
        .brand h1 { color: #fff; font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .brand p { color: rgba(255,255,255,.6); font-size: .87rem; }

        .card { background: #fff; border-radius: 20px; padding: 36px 40px; box-shadow: 0 20px 60px rgba(0,0,0,.3); }

        .card-title { font-size: 1.15rem; font-weight: 700; color: #0f172a; margin-bottom: 6px; }
        .card-sub   { font-size: .83rem; color: #64748b; margin-bottom: 28px; }

        .section-label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--accent); margin: 24px 0 14px; padding-bottom: 8px; border-bottom: 2px solid #f5f3ff; display: flex; align-items: center; gap: 6px; }
        .section-label:first-of-type { margin-top: 0; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-grid .full { grid-column: 1/-1; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: .77rem; font-weight: 600; color: #374151; }
        .required { color: #ef4444; }
        .input-wrap { position: relative; }
        .input-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: .95rem; }
        .form-input, .form-select {
            width: 100%; padding: 10px 12px 10px 36px;
            border: 1.5px solid #e2e8f0; border-radius: 9px;
            font-family: 'Inter', sans-serif; font-size: .85rem; color: #0f172a;
            background: #fff; outline: none; transition: border-color .2s, box-shadow .2s;
        }
        .form-input:focus, .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(139,92,246,.1); }
        .form-input::placeholder { color: #94a3b8; }
        .no-icon { padding-left: 12px; }

        .toggle-btn { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #94a3b8; font-size: .9rem; }
        .toggle-btn:hover { color: var(--accent); }

        .alert-error { background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 12px 16px; display: flex; align-items: center; gap: 10px; color: #dc2626; font-size: .85rem; margin-bottom: 20px; }

        .btn-register { width: 100%; padding: 13px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: #fff; border: none; border-radius: 10px; font-family: 'Inter', sans-serif; font-size: .97rem; font-weight: 700; cursor: pointer; box-shadow: 0 4px 16px rgba(139,92,246,.4); transition: opacity .15s, transform .15s; margin-top: 24px; }
        .btn-register:hover { opacity: .9; transform: translateY(-1px); }
        .btn-register:active { transform: translateY(0); }

        .login-link { text-align: center; margin-top: 18px; font-size: .85rem; color: #64748b; }
        .login-link a { color: var(--accent); font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }

        .strength-bar { height: 4px; border-radius: 2px; background: #e2e8f0; margin-top: 6px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }

        @media (max-width: 600px) { .form-grid { grid-template-columns: 1fr; } .card { padding: 28px 22px; } }
    </style>
</head>
<body>
<div class="register-wrap">
    <div class="brand">
        <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
        <h1>Join as an Intern</h1>
        <p>Create your account and submit your application</p>
    </div>

    <div class="card">
        <div class="card-title">Create Intern Account</div>
        <div class="card-sub">Fill in all required fields to register and submit your internship application.</div>

        <c:if test="${not empty error}">
            <div class="alert-error"><i class="bi bi-exclamation-circle-fill"></i>${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register" id="regForm" novalidate>

            <%-- Account Info --%>
            <div class="section-label"><i class="bi bi-lock"></i> Account Information</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Username <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-at input-icon"></i>
                        <input type="text" name="username" class="form-input" value="${username}" required placeholder="e.g. nguyenvan01" autocomplete="username">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Full Name <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-person input-icon"></i>
                        <input type="text" name="fullName" class="form-input" value="${fullName}" required placeholder="Nguyen Van A">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Password <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-lock input-icon"></i>
                        <input type="password" name="password" id="pwField" class="form-input" required placeholder="Min 6 characters" oninput="checkStrength(this.value)">
                        <button type="button" class="toggle-btn" onclick="togglePw('pwField','eyeIcon1')"><i class="bi bi-eye" id="eyeIcon1"></i></button>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-lock-fill input-icon"></i>
                        <input type="password" name="confirmPassword" id="cpField" class="form-input" required placeholder="Repeat password">
                        <button type="button" class="toggle-btn" onclick="togglePw('cpField','eyeIcon2')"><i class="bi bi-eye" id="eyeIcon2"></i></button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Email <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-envelope input-icon"></i>
                        <input type="email" name="email" class="form-input" value="${email}" required placeholder="example@email.com">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone</label>
                    <div class="input-wrap">
                        <i class="bi bi-phone input-icon"></i>
                        <input type="tel" name="phone" class="form-input" placeholder="0900000000">
                    </div>
                </div>
            </div>

            <%-- Academic Info --%>
            <div class="section-label"><i class="bi bi-mortarboard"></i> Academic Information</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Student Code</label>
                    <div class="input-wrap">
                        <i class="bi bi-card-text input-icon"></i>
                        <input type="text" name="studentCode" class="form-input" placeholder="e.g. SV003">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Gender</label>
                    <div class="input-wrap">
                        <i class="bi bi-gender-ambiguous input-icon"></i>
                        <select name="gender" class="form-select">
                            <option value="">-- Select --</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-group full">
                    <label class="form-label">University <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-building-fill-check input-icon"></i>
                        <input type="text" name="university" class="form-input" required placeholder="e.g. Hanoi University of Science and Technology">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Major <span class="required">*</span></label>
                    <div class="input-wrap">
                        <i class="bi bi-book input-icon"></i>
                        <input type="text" name="major" class="form-input" required placeholder="e.g. Computer Science">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Date of Birth</label>
                    <div class="input-wrap">
                        <i class="bi bi-calendar3 input-icon"></i>
                        <input type="date" name="dateOfBirth" class="form-input">
                    </div>
                </div>
                <div class="form-group full">
                    <label class="form-label">Address</label>
                    <div class="input-wrap">
                        <i class="bi bi-geo-alt input-icon"></i>
                        <input type="text" name="address" class="form-input" placeholder="e.g. 123 Street, Hanoi">
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-register" id="submitBtn">
                <i class="bi bi-send-fill me-1"></i> Submit Registration
            </button>
        </form>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </div>
    </div>
</div>

<script>
    function togglePw(fieldId, iconId) {
        var f = document.getElementById(fieldId);
        var i = document.getElementById(iconId);
        if (f.type === 'password') { f.type = 'text'; i.className = 'bi bi-eye-slash'; }
        else { f.type = 'password'; i.className = 'bi bi-eye'; }
    }

    function checkStrength(val) {
        var fill = document.getElementById('strengthFill');
        var score = 0;
        if (val.length >= 6) score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;
        var colors = ['#ef4444','#f59e0b','#eab308','#22c55e','#16a34a'];
        fill.style.width = (score * 20) + '%';
        fill.style.background = colors[score - 1] || '#e2e8f0';
    }

    document.getElementById('regForm').addEventListener('submit', function(e) {
        var pw  = document.getElementById('pwField').value;
        var cp  = document.getElementById('cpField').value;
        if (pw !== cp) { e.preventDefault(); alert('Passwords do not match!'); return; }
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').innerHTML = '<i class="bi bi-arrow-repeat me-1"></i> Submitting...';
    });
</script>
</body>
</html>
