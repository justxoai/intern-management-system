<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HR Dashboard — Human Resource</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0c1f3f;
            --accent: #0ea5e9;
            --accent2: #38bdf8;
            --intern-col: #0ea5e9;
            --mentor-col: #10b981;
            --page-bg: #f0f6ff;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-w); background: var(--sidebar-bg);
            display: flex; flex-direction: column; flex-shrink: 0;
            position: fixed; height: 100vh; overflow-y: auto; z-index: 100;
        }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #0ea5e9, #38bdf8);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.15rem; color: #fff; margin-bottom: 10px;
        }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a {
            display: flex; align-items: center; gap: 10px; padding: 10px 12px;
            border-radius: 8px; margin-bottom: 2px; text-decoration: none;
            color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500;
            transition: background .15s, color .15s;
        }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(14,165,233,.2); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* Main */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 22px 24px; border: 1px solid var(--border); display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 6px rgba(0,0,0,.05); transition: box-shadow .2s; }
        .stat-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.10); }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; flex-shrink: 0; }
        .stat-icon.blue  { background: linear-gradient(135deg, #0ea5e9, #38bdf8); color: #fff; box-shadow: 0 4px 12px rgba(14,165,233,.3); }
        .stat-icon.green { background: linear-gradient(135deg, #10b981, #34d399); color: #fff; box-shadow: 0 4px 12px rgba(16,185,129,.3); }
        .stat-count { font-size: 2.2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-label { font-size: .8rem; color: var(--text-muted); margin-top: 4px; font-weight: 500; }
        .stat-hint  { font-size: .72rem; color: var(--accent); margin-top: 4px; }

        /* Section card */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .si-intern { background: #eff6ff; color: #0ea5e9; }
        .si-mentor { background: #f0fdf4; color: #10b981; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .sec-count { font-size: .72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
        .count-intern { background: #eff6ff; color: #0ea5e9; }
        .count-mentor { background: #f0fdf4; color: #10b981; }

        /* Filter */
        .filter-bar { background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: flex-end; gap: 10px; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 4px; }
        .filter-label { font-size: .68rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .filter-input, .filter-select { padding: 7px 10px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .81rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; min-width: 110px; }
        .filter-input:focus, .filter-select:focus { border-color: var(--accent); }
        .btn-filter { padding: 7px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600; display: flex; align-items: center; gap: 5px; transition: opacity .15s; }
        .btn-filter:hover { opacity: .85; }
        .btn-filter.primary { background: var(--accent); color: #fff; }
        .btn-filter.green   { background: var(--mentor-col); color: #fff; }
        .btn-filter.ghost   { background: var(--border); color: var(--text-muted); }
        .btn-add { padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600; display: flex; align-items: center; gap: 6px; text-decoration: none; transition: opacity .15s, box-shadow .2s; }
        .btn-add:hover { opacity: .88; }
        .btn-add.blue  { background: var(--intern-col); color: #fff; box-shadow: 0 2px 10px rgba(14,165,233,.35); }
        .btn-add.green { background: var(--mentor-col); color: #fff; box-shadow: 0 2px 10px rgba(16,185,129,.35); }

        /* Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 13px 16px; font-size: .85rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f0f9ff; }

        .user-cell { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .82rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .ua-blue  { background: linear-gradient(135deg, #0ea5e9, #38bdf8); }
        .ua-green { background: linear-gradient(135deg, #10b981, #34d399); }
        .user-name  { font-weight: 600; font-size: .85rem; }
        .user-email { font-size: .75rem; color: var(--text-muted); }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-pending   { background: #fefce8; color: #a16207; }
        .badge-approved  { background: #f0fdf4; color: #16a34a; }
        .badge-interning { background: #eff6ff; color: #1d4ed8; }
        .badge-completed { background: #f5f3ff; color: #7c3aed; }
        .badge-active    { background: #f0fdf4; color: #16a34a; }
        .badge-inactive  { background: #fef2f2; color: #dc2626; }

        .intern-status { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; }

        .action-group { display: flex; align-items: center; gap: 6px; }
        .btn-icon { width: 30px; height: 30px; border-radius: 7px; border: 1.5px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: .85rem; cursor: pointer; text-decoration: none; background: #fff; transition: all .15s; }
        .btn-icon.edit   { color: var(--accent); } .btn-icon.edit:hover   { background: #eff6ff; border-color: var(--accent); }
        .btn-icon.delete { color: #ef4444; }        .btn-icon.delete:hover { background: #fef2f2; border-color: #ef4444; }

        .empty-state { padding: 36px; text-align: center; color: var(--text-muted); font-size: .87rem; }
        .empty-state i { font-size: 2rem; margin-bottom: 8px; display: block; opacity: .4; }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-building"></i></div>
        <h1>Human Resource</h1>
    </div>

    <div class="sidebar-section-label">Management</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/hr/dashboard" class="active">
            <i class="bi bi-grid"></i> Dashboard
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications">
            <i class="bi bi-clipboard-check"></i> Applications
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents">
            <i class="bi bi-folder-check"></i> Document Review
        </a></li>
    </ul>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">HR Staff</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<!-- Main -->
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Human Resource</div>
            <div class="page-sub">Manage intern profiles and monitor mentors</div>
        </div>
        <a href="${pageContext.request.contextPath}/hr/interns/create"
           style="padding:8px 18px;background:linear-gradient(135deg,#0ea5e9,#38bdf8);color:#fff;border-radius:9px;text-decoration:none;font-size:.82rem;font-weight:600;display:flex;align-items:center;gap:6px;box-shadow:0 3px 10px rgba(14,165,233,.35)">
            <i class="bi bi-plus-lg"></i> Add Intern
        </a>
    </div>

    <div class="content">

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="bi bi-person-workspace"></i></div>
                <div>
                    <div class="stat-count">${fn:length(interns)}</div>
                    <div class="stat-label">Intern Profiles</div>
                    <div class="stat-hint">Across all statuses</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="bi bi-mortarboard"></i></div>
                <div>
                    <div class="stat-count">${fn:length(mentors)}</div>
                    <div class="stat-label">Active Mentors</div>
                    <div class="stat-hint">Available to assign</div>
                </div>
            </div>
        </div>

        <%-- INTERN SECTION --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon si-intern"><i class="bi bi-person-workspace"></i></div>
                    <span class="sec-title">Intern Management</span>
                    <span class="sec-count count-intern">${fn:length(interns)}</span>
                </div>
                <a href="${pageContext.request.contextPath}/hr/interns/create" class="btn-add blue">
                    <i class="bi bi-plus-lg"></i> Add Intern
                </a>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/dashboard">
                <div class="filter-group">
                    <span class="filter-label">Keyword</span>
                    <input class="filter-input" type="text" name="internKeyword" value="${internKeyword}" placeholder="Code / Name / Email" style="width:170px">
                </div>
                <div class="filter-group">
                    <span class="filter-label">University</span>
                    <input class="filter-input" type="text" name="internUniversity" value="${internUniversity}" placeholder="e.g. HUST">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Major</span>
                    <input class="filter-input" type="text" name="internMajor" value="${internMajor}" placeholder="e.g. CS">
                </div>
                <div class="filter-group">
                    <span class="filter-label">Status</span>
                    <select class="filter-select" name="internStatus" style="width:130px">
                        <option value="">All Status</option>
                        <option value="PENDING"   ${internStatus == 'PENDING'   ? 'selected' : ''}>Pending</option>
                        <option value="APPROVED"  ${internStatus == 'APPROVED'  ? 'selected' : ''}>Approved</option>
                        <option value="INTERNING" ${internStatus == 'INTERNING' ? 'selected' : ''}>Interning</option>
                        <option value="COMPLETED" ${internStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter primary"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn-filter ghost" style="text-decoration:none">Clear</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>Intern</th><th>Code</th><th>University / Major</th><th>Phone</th><th>Status</th><th>Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty interns}">
                            <tr><td colspan="6"><div class="empty-state"><i class="bi bi-inbox"></i>No intern profiles found.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${interns}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-blue">${fn:substring(i.fullName != null ? i.fullName : 'U', 0, 1)}</div>
                                            <div>
                                                <div class="user-name">${not empty i.fullName ? i.fullName : '—'}</div>
                                                <div class="user-email">${i.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><code style="background:#f0f9ff;padding:2px 7px;border-radius:5px;font-size:.75rem;color:#0369a1">${i.studentCode}</code></td>
                                    <td>
                                        <div style="font-size:.82rem;font-weight:500">${i.university}</div>
                                        <div style="font-size:.74rem;color:var(--text-muted)">${i.major}</div>
                                    </td>
                                    <td style="color:var(--text-muted)">${i.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.status == 'APPROVED'}"><span class="badge badge-approved"><i class="bi bi-check-circle-fill" style="font-size:.65rem"></i>Approved</span></c:when>
                                            <c:when test="${i.status == 'INTERNING'}"><span class="badge badge-interning"><i class="bi bi-play-circle-fill" style="font-size:.65rem"></i>Interning</span></c:when>
                                            <c:when test="${i.status == 'COMPLETED'}"><span class="badge badge-completed"><i class="bi bi-patch-check-fill" style="font-size:.65rem"></i>Completed</span></c:when>
                                            <c:otherwise><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.65rem"></i>Pending</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/hr/interns/edit?id=${i.id}" class="btn-icon edit" title="Edit"><i class="bi bi-pencil"></i></a>
                                            <a href="${pageContext.request.contextPath}/hr/interns/delete?id=${i.id}" class="btn-icon delete" title="Delete" onclick="return confirm('Delete intern ${i.studentCode}?')"><i class="bi bi-trash"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- MENTOR SECTION --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon si-mentor"><i class="bi bi-mortarboard"></i></div>
                    <span class="sec-title">Mentor Management</span>
                    <span class="sec-count count-mentor">${fn:length(mentors)}</span>
                </div>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/dashboard">
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
                    <select class="filter-select" name="mentorStatus" style="width:120px">
                        <option value="">All</option>
                        <option value="ACTIVE"   ${mentorStatus == 'ACTIVE'   ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${mentorStatus == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter green"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn-filter ghost" style="text-decoration:none">Clear</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>Mentor</th><th>Phone</th><th>Status</th><th>Joined</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty mentors}">
                            <tr><td colspan="4"><div class="empty-state"><i class="bi bi-inbox"></i>No mentors found.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="m" items="${mentors}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-green">${fn:substring(m.fullName, 0, 1)}</div>
                                            <div>
                                                <div class="user-name">${m.fullName}</div>
                                                <div class="user-email">${m.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-muted)">${m.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.status == 'ACTIVE'}"><span class="badge badge-active"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive"><i class="bi bi-circle-fill" style="font-size:.4rem"></i>${m.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.78rem">${m.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
</div>
</body>
</html>
