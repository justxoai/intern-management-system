<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard — User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0d1b2e;
            --sidebar-hover: rgba(255,255,255,.07);
            --sidebar-active: rgba(99,179,237,.15);
            --sidebar-active-border: #63b3ed;
            --accent: #3b82f6;
            --accent2: #8b5cf6;
            --hr-col: #3b82f6;
            --mentor-col: #10b981;
            --intern-col: #8b5cf6;
            --page-bg: #f1f5f9;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: var(--sidebar-w); background: var(--sidebar-bg);
            display: flex; flex-direction: column; flex-shrink: 0;
            position: fixed; height: 100vh; overflow-y: auto; z-index: 100;
        }
        .sidebar-brand {
            padding: 28px 22px 20px;
            border-bottom: 1px solid rgba(255,255,255,.08);
        }
        .sidebar-brand .brand-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.15rem; color: #fff; margin-bottom: 10px;
        }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }

        .sidebar-section-label {
            padding: 18px 22px 6px;
            font-size: .67rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .8px; color: rgba(255,255,255,.3);
        }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 8px; margin-bottom: 2px;
            text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500;
            transition: background .15s, color .15s;
        }
        .sidebar-nav li a:hover { background: var(--sidebar-hover); color: #fff; }
        .sidebar-nav li a.active {
            background: var(--sidebar-active); color: #fff;
            border-left: 3px solid var(--sidebar-active-border);
        }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }

        .sidebar-footer {
            margin-top: auto; padding: 16px 22px;
            border-top: 1px solid rgba(255,255,255,.08);
        }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            display: flex; align-items: center; justify-content: center;
            font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0;
        }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }

        .topbar {
            background: var(--card-bg); padding: 16px 32px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 50;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub   { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .topbar-actions { display: flex; align-items: center; gap: 10px; }
        .topbar-badge {
            background: #eff6ff; color: #2563eb; border-radius: 20px;
            padding: 4px 12px; font-size: .75rem; font-weight: 600;
        }

        /* Content */
        .content { padding: 28px 32px; flex: 1; }

        /* Stats row */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card {
            background: var(--card-bg); border-radius: 14px;
            padding: 20px 22px; border: 1px solid var(--border);
            display: flex; align-items: center; gap: 16px;
            box-shadow: 0 1px 6px rgba(0,0,0,.05);
            transition: box-shadow .2s;
        }
        .stat-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.10); }
        .stat-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0;
        }
        .stat-icon.hr     { background: #eff6ff; color: var(--hr-col); }
        .stat-icon.mentor { background: #f0fdf4; color: var(--mentor-col); }
        .stat-icon.intern { background: #f5f3ff; color: var(--intern-col); }
        .stat-count { font-size: 2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-label { font-size: .78rem; color: var(--text-muted); margin-top: 3px; font-weight: 500; }

        /* Section card */
        .sec-card {
            background: var(--card-bg); border-radius: 16px;
            border: 1px solid var(--border); margin-bottom: 24px;
            overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05);
            scroll-margin-top: 82px;
        }
        .sec-header {
            padding: 16px 22px; display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid var(--border);
        }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-dot {
            width: 10px; height: 10px; border-radius: 50%;
        }
        .dot-hr     { background: var(--hr-col); }
        .dot-mentor { background: var(--mentor-col); }
        .dot-intern { background: var(--intern-col); }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .sec-count {
            font-size: .72rem; font-weight: 600; padding: 2px 9px; border-radius: 20px;
        }
        .count-hr     { background: #eff6ff; color: var(--hr-col); }
        .count-mentor { background: #f0fdf4; color: var(--mentor-col); }
        .count-intern { background: #f5f3ff; color: var(--intern-col); }

        /* Filter bar */
        .filter-bar {
            background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border);
            display: flex; align-items: flex-end; gap: 10px; flex-wrap: wrap;
        }
        .filter-group { display: flex; flex-direction: column; gap: 4px; }
        .filter-label { font-size: .68rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .filter-input, .filter-select {
            padding: 7px 10px; border: 1.5px solid var(--border); border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: .81rem; color: var(--text-primary);
            background: #fff; outline: none; transition: border-color .2s;
            min-width: 110px;
        }
        .filter-input:focus, .filter-select:focus { border-color: var(--accent); }

        .btn-filter {
            padding: 7px 16px; border-radius: 8px; border: none; cursor: pointer;
            font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
            transition: opacity .15s;
        }
        .btn-filter:hover { opacity: .85; }
        .btn-filter.primary { background: var(--accent); color: #fff; }
        .btn-filter.ghost   { background: var(--border); color: var(--text-muted); }
        .btn-add {
            padding: 7px 15px; border-radius: 8px; border: none; cursor: pointer;
            font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600;
            display: flex; align-items: center; gap: 5px; text-decoration: none;
            transition: opacity .15s, box-shadow .2s;
        }
        .btn-add:hover { opacity: .88; }
        .btn-add.hr     { background: var(--hr-col);     color: #fff; box-shadow: 0 2px 8px rgba(59,130,246,.3); }
        .btn-add.mentor { background: var(--mentor-col); color: #fff; box-shadow: 0 2px 8px rgba(16,185,129,.3); }
        .btn-add.intern { background: var(--intern-col); color: #fff; box-shadow: 0 2px 8px rgba(139,92,246,.3); }

        /* Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th {
            padding: 11px 16px; text-align: left;
            font-size: .7rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .5px; color: var(--text-muted);
            background: #f8fafc; border-bottom: 1px solid var(--border);
        }
        .data-table tbody td {
            padding: 13px 16px; font-size: .85rem; color: var(--text-primary);
            border-bottom: 1px solid #f1f5f9; vertical-align: middle;
        }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f8fafc; }

        .user-cell { display: flex; align-items: center; gap: 10px; }
        .user-avatar {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: .78rem; font-weight: 700; color: #fff; flex-shrink: 0;
        }
        .ua-hr     { background: linear-gradient(135deg, #3b82f6, #60a5fa); }
        .ua-mentor { background: linear-gradient(135deg, #10b981, #34d399); }
        .ua-intern { background: linear-gradient(135deg, #8b5cf6, #a78bfa); }
        .user-name { font-weight: 600; font-size: .85rem; }
        .user-email { font-size: .75rem; color: var(--text-muted); }

        .badge {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600;
        }
        .badge-active   { background: #f0fdf4; color: #16a34a; }
        .badge-inactive { background: #fef2f2; color: #dc2626; }

        .action-group { display: flex; align-items: center; gap: 6px; }
        .btn-icon {
            width: 30px; height: 30px; border-radius: 7px; border: 1.5px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-size: .85rem; cursor: pointer; text-decoration: none; background: #fff;
            transition: all .15s;
        }
        .btn-icon.edit   { color: var(--accent); } .btn-icon.edit:hover   { background: #eff6ff; border-color: var(--accent); }
        .btn-icon.delete { color: #ef4444; }        .btn-icon.delete:hover { background: #fef2f2; border-color: #ef4444; }

        .empty-state { padding: 36px; text-align: center; color: var(--text-muted); font-size: .87rem; }
        .empty-state i { font-size: 2rem; margin-bottom: 8px; display: block; opacity: .4; }
    </style>
</head>
<body>

<!-- ── Sidebar ── -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-shield-check"></i></div>
        <h1>Internship<br>Management</h1>
        <span>Admin Panel</span>
    </div>

    <div class="sidebar-section-label">Management</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/admin/users" class="active">
            <i class="bi bi-people"></i> User Accounts
        </a></li>
    </ul>

    <div class="sidebar-section-label">Quick Links</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/admin/users/create">
            <i class="bi bi-person-plus"></i> Add New User
        </a></li>
        <li><a href="#section-hr" onclick="scrollTo('section-hr')">
            <i class="bi bi-building"></i> HR Section
        </a></li>
        <li><a href="#section-mentor" onclick="scrollTo('section-mentor')">
            <i class="bi bi-mortarboard"></i> Mentor Section
        </a></li>
        <li><a href="#section-intern" onclick="scrollTo('section-intern')">
            <i class="bi bi-person-workspace"></i> Intern Section
        </a></li>
    </ul>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Administrator</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<!-- ── Main Content ── -->
<div class="main">
    <!-- Topbar -->
    <div class="topbar">
        <div>
            <div class="page-title">User Management</div>
            <div class="page-sub">Manage all HR, Mentor, and Intern accounts</div>
        </div>
        <div class="topbar-actions">
            <span class="topbar-badge"><i class="bi bi-circle-fill me-1" style="font-size:.45rem;color:#22c55e"></i>System Online</span>
            <a href="${pageContext.request.contextPath}/admin/users/create"
               style="padding:8px 16px;background:linear-gradient(135deg,#3b82f6,#8b5cf6);color:#fff;border-radius:9px;text-decoration:none;font-size:.82rem;font-weight:600;display:flex;align-items:center;gap:6px;">
                <i class="bi bi-plus-lg"></i> New User
            </a>
        </div>
    </div>

    <div class="content">

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon hr"><i class="bi bi-person-badge"></i></div>
                <div>
                    <div class="stat-count">${fn:length(hrUsers)}</div>
                    <div class="stat-label">HR Accounts</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon mentor"><i class="bi bi-mortarboard"></i></div>
                <div>
                    <div class="stat-count">${fn:length(mentorUsers)}</div>
                    <div class="stat-label">Mentor Accounts</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon intern"><i class="bi bi-person-workspace"></i></div>
                <div>
                    <div class="stat-count">${fn:length(internUsers)}</div>
                    <div class="stat-label">Intern Accounts</div>
                </div>
            </div>
        </div>

        <%-- ===== HR SECTION ===== --%>
        <div class="sec-card" id="section-hr">
            <div class="sec-header">
                <div class="sec-header-left">
                    <span class="sec-dot dot-hr"></span>
                    <span class="sec-title">Human Resources</span>
                    <span class="sec-count count-hr">${fn:length(hrUsers)}</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users/create?role=HR" class="btn-add hr">
                    <i class="bi bi-plus-lg"></i> Add HR
                </a>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users">
                <div class="filter-group">
                    <span class="filter-label">ID</span>
                    <input class="filter-input" type="text" name="hrId" value="${hrId}" placeholder="e.g. 2" style="width:80px">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Name</span>
                    <input class="filter-input" type="text" name="hrName" value="${hrName}" placeholder="Full name">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Email</span>
                    <input class="filter-input" type="text" name="hrEmail" value="${hrEmail}" placeholder="email@...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Phone</span>
                    <input class="filter-input" type="text" name="hrPhone" value="${hrPhone}" placeholder="090...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Status</span>
                    <select class="filter-select" name="hrStatus" style="width:110px">
                        <option value="">All</option>
                        <option value="ACTIVE"   ${hrStatus == 'ACTIVE'   ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${hrStatus == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter primary"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-filter ghost" style="text-decoration:none">Clear</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>User</th><th>Phone</th><th>Status</th><th>Created</th><th>Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty hrUsers}">
                            <tr><td colspan="5"><div class="empty-state"><i class="bi bi-inbox"></i>No HR accounts found.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${hrUsers}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-hr">${fn:substring(u.fullName,0,1)}</div>
                                            <div>
                                                <div class="user-name">${u.fullName}</div>
                                                <div class="user-email">${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-muted)">${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.78rem">${u.createdAt}</td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn-icon edit" title="Edit"><i class="bi bi-pencil"></i></a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display:inline" onsubmit="return confirm('Delete ${u.fullName}?')">
                                                <input type="hidden" name="id" value="${u.id}">
                                                <button type="submit" class="btn-icon delete" title="Delete"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- ===== MENTOR SECTION ===== --%>
        <div class="sec-card" id="section-mentor">
            <div class="sec-header">
                <div class="sec-header-left">
                    <span class="sec-dot dot-mentor"></span>
                    <span class="sec-title">Mentors</span>
                    <span class="sec-count count-mentor">${fn:length(mentorUsers)}</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users/create?role=MENTOR" class="btn-add mentor">
                    <i class="bi bi-plus-lg"></i> Add Mentor
                </a>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users">
                <div class="filter-group">
                    <span class="filter-label">ID</span>
                    <input class="filter-input" type="text" name="mentorId" value="${mentorId}" placeholder="e.g. 3" style="width:80px">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Name</span>
                    <input class="filter-input" type="text" name="mentorName" value="${mentorName}" placeholder="Full name">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Email</span>
                    <input class="filter-input" type="text" name="mentorEmail" value="${mentorEmail}" placeholder="email@...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Phone</span>
                    <input class="filter-input" type="text" name="mentorPhone" value="${mentorPhone}" placeholder="090...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Status</span>
                    <select class="filter-select" name="mentorStatus" style="width:110px">
                        <option value="">All</option>
                        <option value="ACTIVE"   ${mentorStatus == 'ACTIVE'   ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${mentorStatus == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter primary" style="background:var(--mentor-col)"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-filter ghost" style="text-decoration:none">Clear</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>User</th><th>Phone</th><th>Status</th><th>Created</th><th>Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty mentorUsers}">
                            <tr><td colspan="5"><div class="empty-state"><i class="bi bi-inbox"></i>No Mentor accounts found.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${mentorUsers}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-mentor">${fn:substring(u.fullName,0,1)}</div>
                                            <div>
                                                <div class="user-name">${u.fullName}</div>
                                                <div class="user-email">${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-muted)">${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.78rem">${u.createdAt}</td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn-icon edit" title="Edit"><i class="bi bi-pencil"></i></a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display:inline" onsubmit="return confirm('Delete ${u.fullName}?')">
                                                <input type="hidden" name="id" value="${u.id}">
                                                <button type="submit" class="btn-icon delete" title="Delete"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- ===== INTERN SECTION ===== --%>
        <div class="sec-card" id="section-intern">
            <div class="sec-header">
                <div class="sec-header-left">
                    <span class="sec-dot dot-intern"></span>
                    <span class="sec-title">Interns</span>
                    <span class="sec-count count-intern">${fn:length(internUsers)}</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users/create?role=INTERN" class="btn-add intern">
                    <i class="bi bi-plus-lg"></i> Add Intern
                </a>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users">
                <div class="filter-group">
                    <span class="filter-label">ID / Code</span>
                    <input class="filter-input" type="text" name="internId" value="${internId}" placeholder="ID or code" style="width:95px">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Name</span>
                    <input class="filter-input" type="text" name="internName" value="${internName}" placeholder="Full name">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Email</span>
                    <input class="filter-input" type="text" name="internEmail" value="${internEmail}" placeholder="email@...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Phone</span>
                    <input class="filter-input" type="text" name="internPhone" value="${internPhone}" placeholder="090...">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Major</span>
                    <input class="filter-input" type="text" name="internMajor" value="${internMajor}" placeholder="e.g. CS">
                </div>
                <div class="filter-group">
                    <span class="filter-label">University</span>
                    <input class="filter-input" type="text" name="internUniversity" value="${internUniversity}" placeholder="University">
                </div>
                <button type="submit" class="btn-filter primary" style="background:var(--intern-col)"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-filter ghost" style="text-decoration:none">Clear</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>User</th><th>Code</th><th>Major / University</th><th>Phone</th><th>Status</th><th>Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty internUsers}">
                            <tr><td colspan="6"><div class="empty-state"><i class="bi bi-inbox"></i>No Intern accounts found.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${internUsers}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-intern">${fn:substring(u.fullName,0,1)}</div>
                                            <div>
                                                <div class="user-name">${u.fullName}</div>
                                                <div class="user-email">${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><code style="background:#f1f5f9;padding:2px 6px;border-radius:5px;font-size:.75rem">${not empty u.studentCode ? u.studentCode : 'N/A'}</code></td>
                                    <td>
                                        <div style="font-size:.82rem;font-weight:500">${not empty u.major ? u.major : '-'}</div>
                                        <div style="font-size:.73rem;color:var(--text-muted)">${not empty u.university ? u.university : '-'}</div>
                                    </td>
                                    <td style="color:var(--text-muted)">${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn-icon edit" title="Edit"><i class="bi bi-pencil"></i></a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display:inline" onsubmit="return confirm('Delete ${u.fullName}?')">
                                                <input type="hidden" name="id" value="${u.id}">
                                                <button type="submit" class="btn-icon delete" title="Delete"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div><!-- /content -->
</div><!-- /main -->
<script>
    function scrollTo(id) {
        var el = document.getElementById(id);
        if (el) { el.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
        return false;
    }
    // Auto-scroll if URL has a hash (e.g. #section-hr)
    window.addEventListener('DOMContentLoaded', function() {
        var hash = window.location.hash;
        if (hash) {
            var el = document.querySelector(hash);
            if (el) setTimeout(function(){ el.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 200);
        }
    });
</script>
</body>
</html>
