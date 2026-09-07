<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><fmt:message key="admin.edit.title"/></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px; --sidebar-bg: #0d1b2e;
            --accent: #3b82f6; --accent2: #8b5cf6;
            --hr-col: #3b82f6; --mentor-col: #10b981; --intern-col: #8b5cf6;
            --page-bg: #f1f5f9; --card-bg: #fff;
            --text-primary: #0f172a; --text-muted: #64748b; --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #3b82f6, #8b5cf6); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(99,179,237,.15); color: #fff; border-left: 3px solid #63b3ed; }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #3b82f6, #8b5cf6); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .topbar-back { display: flex; align-items: center; gap: 7px; text-decoration: none; color: var(--text-muted); font-size: .84rem; font-weight: 500; padding: 6px 12px; border-radius: 8px; border: 1px solid var(--border); transition: all .15s; }
        .topbar-back:hover { background: var(--border); color: var(--text-primary); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 36px 32px; flex: 1; display: flex; justify-content: center; }

        /* ── Form Card ── */
        .form-card { background: var(--card-bg); border-radius: 18px; border: 1px solid var(--border); padding: 36px 40px; width: 100%; max-width: 680px; box-shadow: 0 2px 16px rgba(0,0,0,.07); }
        .form-card-header { margin-bottom: 28px; }
        .form-card-title { font-size: 1.1rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 10px; }
        .form-card-title .icon { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, #3b82f6, #8b5cf6); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1rem; }
        .form-card-sub { font-size: .83rem; color: var(--text-muted); margin-top: 6px; margin-left: 48px; }

        .section-label { font-size: .71rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--accent); margin: 26px 0 14px; padding-bottom: 8px; border-bottom: 2px solid #eff6ff; display: flex; align-items: center; gap: 6px; }
        .section-label:first-of-type { margin-top: 0; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-grid .full { grid-column: 1/-1; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: .77rem; font-weight: 600; color: #374151; }
        .required { color: #ef4444; }

        .input-wrap { position: relative; }
        .input-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: .9rem; pointer-events: none; }
        .form-input, .form-select {
            width: 100%; padding: 10px 12px 10px 36px;
            border: 1.5px solid var(--border); border-radius: 9px;
            font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary);
            background: #fff; outline: none; transition: border-color .2s, box-shadow .2s;
        }
        .form-input:focus, .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,.1); }
        .form-input::placeholder { color: #94a3b8; }
        .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #94a3b8; font-size: .9rem; }
        .toggle-pw:hover { color: var(--accent); }

        .alert-error { background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 12px 16px; display: flex; align-items: center; gap: 10px; color: #dc2626; font-size: .85rem; margin-bottom: 20px; }

        .form-actions { display: flex; align-items: center; justify-content: flex-end; gap: 12px; margin-top: 28px; padding-top: 20px; border-top: 1px solid var(--border); }
        .btn-cancel { padding: 10px 20px; border-radius: 9px; border: 1.5px solid var(--border); background: #fff; color: var(--text-muted); font-family: 'Inter', sans-serif; font-size: .87rem; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: all .15s; }
        .btn-cancel:hover { background: #f8fafc; border-color: #c7d2fe; color: var(--text-primary); }
        .btn-save { padding: 10px 24px; border-radius: 9px; border: none; background: linear-gradient(135deg, #3b82f6, #8b5cf6); color: #fff; font-family: 'Inter', sans-serif; font-size: .87rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 3px 12px rgba(59,130,246,.35); transition: opacity .15s, transform .15s; }
        .btn-save:hover { opacity: .88; transform: translateY(-1px); }
        .btn-save:active { transform: translateY(0); }

        @media (max-width: 700px) { .form-grid { grid-template-columns: 1fr; } .form-card { padding: 24px 18px; } }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-shield-check"></i></div>
        <h1><fmt:message key="app.name"/></h1>
        <span>Admin Panel</span>
    </div>
    <div class="sidebar-section-label"><fmt:message key="label.role"/></div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/admin/users">
            <i class="bi bi-people"></i> <fmt:message key="nav.users"/>
        </a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users/create">
            <i class="bi bi-person-plus"></i> <fmt:message key="nav.addUser"/>
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role"><fmt:message key="role.admin"/></div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="<fmt:message key='nav.logout'/>">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/admin/users" class="topbar-back">
            <i class="bi bi-arrow-left"></i> <fmt:message key="btn.back"/>
        </a>
        <div style="border-left:1px solid var(--border);height:28px;margin:0 4px"></div>
        <div style="flex:1">
            <div class="page-title"><fmt:message key="admin.edit.heading"/></div>
            <div class="page-sub"><fmt:message key="admin.edit.subheading"/></div>
        </div>
    </div>


    <div class="content">
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-title">
                    <div class="icon"><i class="bi bi-person-gear"></i></div>
                    <fmt:message key="admin.edit.card.title"/>
                </div>
                <div class="form-card-sub"><fmt:message key="admin.edit.card.sub"/></div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/users/edit" method="post" id="editForm">
                <input type="hidden" name="id" value="${user.id}">

                <%-- 1. Personal Information --%>
                <div class="section-label"><i class="bi bi-person-fill"></i> <fmt:message key="admin.edit.section.personal"/></div>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label"><fmt:message key="label.fullname"/> <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-person input-icon"></i>
                            <input type="text" name="fullName" class="form-input" value="${user.fullName}" required placeholder="e.g. Nguyen Van A">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.email"/> <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-envelope input-icon"></i>
                            <input type="email" name="email" class="form-input" value="${user.email}" required placeholder="user@company.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.phone"/></label>
                        <div class="input-wrap">
                            <i class="bi bi-telephone input-icon"></i>
                            <input type="tel" name="phone" class="form-input" value="${user.phone}" placeholder="e.g. 0901234567">
                        </div>
                    </div>
                </div>

                <%-- 2. Account & Credentials --%>
                <div class="section-label"><i class="bi bi-shield-lock"></i> <fmt:message key="admin.edit.section.credentials"/></div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.username"/> <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-at input-icon"></i>
                            <input type="text" name="username" class="form-input" value="${user.username}" required placeholder="e.g. hr02" autocomplete="off">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.password"/></label>
                        <div class="input-wrap" style="position:relative;">
                            <i class="bi bi-lock input-icon"></i>
                            <input type="password" name="password" id="pwField" class="form-input"
                                   placeholder="<fmt:message key='admin.edit.pw.placeholder'/>"
                                   autocomplete="new-password" style="padding-right:40px;">
                            <button type="button" class="toggle-pw" onclick="togglePw()">
                                <i class="bi bi-eye" id="pwEye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.role"/> <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-person-badge input-icon"></i>
                            <select name="role" class="form-select" required>
                                <option value="HR"     ${user.role == 'HR'     ? 'selected' : ''}><fmt:message key="role.hr"/></option>
                                <option value="MENTOR" ${user.role == 'MENTOR' ? 'selected' : ''}><fmt:message key="role.mentor"/></option>
                                <option value="INTERN" ${user.role == 'INTERN' ? 'selected' : ''}><fmt:message key="role.intern"/></option>
                                <c:if test="${user.role == 'ADMIN'}">
                                    <option value="ADMIN" selected><fmt:message key="role.admin"/></option>
                                </c:if>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><fmt:message key="label.status"/> <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-toggle-on input-icon"></i>
                            <select name="status" class="form-select" required>
                                <option value="ACTIVE"   ${user.status == 'ACTIVE'   ? 'selected' : ''}><fmt:message key="status.active"/></option>
                                <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}><fmt:message key="status.inactive"/></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-cancel">
                        <i class="bi bi-x"></i> <fmt:message key="btn.cancel"/>
                    </a>
                    <button type="submit" class="btn-save" id="submitBtn">
                        <i class="bi bi-check-lg"></i> <fmt:message key="admin.edit.btn.submit"/>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function togglePw() {
        var f = document.getElementById('pwField');
        var eye = document.getElementById('pwEye');
        if (f.type === 'password') {
            f.type = 'text';
            eye.className = 'bi bi-eye-slash';
        } else {
            f.type = 'password';
            eye.className = 'bi bi-eye';
        }
    }
    document.getElementById('editForm').addEventListener('submit', function() {
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="bi bi-arrow-repeat"></i> Saving...';
    });
</script>
</body>
</html>
