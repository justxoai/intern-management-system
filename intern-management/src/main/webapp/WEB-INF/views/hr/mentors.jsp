<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mentor Management — HR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0c1f3f;
            --accent: #0ea5e9;
            --page-bg: #f0f6ff;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
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
        .page-sub   { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        .alert { display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-radius: 10px; font-size: .86rem; font-weight: 500; margin-bottom: 20px; }
        .alert-success { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
        .alert-error   { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        /* Stats strip */
        .stats-strip { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-pill { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border); padding: 16px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .stat-pill-icon { width: 44px; height: 44px; border-radius: 10px; background: #eff6ff; color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .stat-pill-num { font-size: 1.4rem; font-weight: 800; color: var(--text-primary); }
        .stat-pill-lbl { font-size: .75rem; color: var(--text-muted); font-weight: 500; }

        /* Filter bar */
        .filter-card { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border); padding: 14px 20px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; flex-wrap: wrap; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .filter-input { padding: 8px 12px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .82rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; }
        .filter-input:focus { border-color: var(--accent); }
        .btn-filter { padding: 8px 18px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600; display: flex; align-items: center; gap: 5px; transition: opacity .15s; }
        .btn-filter.blue  { background: var(--accent); color: #fff; }
        .btn-filter.ghost { background: var(--border); color: var(--text-muted); text-decoration: none; }
        .btn-filter:hover { opacity: .85; }

        /* Mentor Cards Grid */
        .mentor-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 20px; }
        .mentor-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); display: flex; flex-direction: column; }
        .mc-header { padding: 18px 20px 14px; display: flex; align-items: flex-start; gap: 12px; border-bottom: 1px solid #f1f5f9; }
        .mc-avatar { width: 44px; height: 44px; border-radius: 12px; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .mc-name { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .mc-email { font-size: .78rem; color: var(--text-muted); margin-top: 1px; }
        .mc-phone { font-size: .75rem; color: var(--text-muted); margin-top: 1px; }

        /* Workload progress */
        .workload-bar-wrap { padding: 12px 20px; background: #f8fafc; border-bottom: 1px solid #f1f5f9; }
        .workload-label { display: flex; justify-content: space-between; font-size: .75rem; color: var(--text-muted); margin-bottom: 6px; font-weight: 600; }
        .workload-track { background: #e2e8f0; border-radius: 6px; height: 8px; overflow: hidden; }
        .workload-fill  { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #10b981, #0ea5e9); transition: width .4s; }
        .workload-fill.full { background: linear-gradient(90deg, #f59e0b, #ef4444); }
        .workload-fill.over { background: #ef4444; }

        /* Card body & forms */
        .mc-body { padding: 16px 20px; flex: 1; display: flex; flex-direction: column; gap: 14px; }
        .edit-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 8px; }
        .edit-group { display: flex; flex-direction: column; gap: 3px; }
        .edit-group label { font-size: .7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .3px; }
        .edit-input { padding: 6px 9px; border: 1.5px solid var(--border); border-radius: 7px; font-family: 'Inter', sans-serif; font-size: .8rem; color: var(--text-primary); background: #fff; outline: none; }
        .edit-input:focus { border-color: var(--accent); }
        .btn-save { padding: 7px 14px; border-radius: 7px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .78rem; font-weight: 600; background: #eff6ff; color: var(--accent); border: 1px solid #bfdbfe; transition: all .15s; }
        .btn-save:hover { background: var(--accent); color: #fff; }

        /* Assign section */
        .mc-assign { padding: 14px 20px; background: #f8fafc; border-top: 1px solid #f1f5f9; }
        .assign-title { font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: .4px; color: var(--text-muted); margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
        
        .assigned-list { display: flex; flex-direction: column; gap: 6px; margin-bottom: 12px; max-height: 140px; overflow-y: auto; }
        .assigned-item { display: flex; align-items: center; justify-content: space-between; padding: 6px 10px; background: #fff; border: 1px solid var(--border); border-radius: 7px; font-size: .78rem; }
        .assigned-name { font-weight: 600; color: var(--text-primary); }
        .assigned-code { color: var(--text-muted); font-size: .72rem; }
        .btn-unassign { border: none; background: #fef2f2; color: #dc2626; border-radius: 5px; padding: 2px 7px; font-size: .72rem; cursor: pointer; font-weight: 600; transition: background .15s; }
        .btn-unassign:hover { background: #dc2626; color: #fff; }
        .no-assigned { font-size: .78rem; color: var(--text-muted); font-style: italic; padding: 4px 0; }

        .assign-form { display: flex; gap: 8px; align-items: center; }
        .assign-select { flex: 1; padding: 7px 10px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .8rem; color: var(--text-primary); background: #fff; outline: none; }
        .assign-select:focus { border-color: var(--accent); }
        .btn-assign { padding: 7px 14px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .8rem; font-weight: 600; background: linear-gradient(135deg, #0ea5e9, #38bdf8); color: #fff; flex-shrink: 0; transition: opacity .15s; }
        .btn-assign:hover { opacity: .88; }
    </style>
</head>
<body>

<%-- Sidebar --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-building"></i></div>
        <h1>Human Resource</h1>
    </div>
    <div class="sidebar-section-label">Management</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="bi bi-grid"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/mentors" class="active"><i class="bi bi-mortarboard"></i> Mentors</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications"><i class="bi bi-clipboard-check"></i> Applications</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/contracts"><i class="bi bi-file-earmark-text"></i> Contracts</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents"><i class="bi bi-folder-check"></i> Document Review</a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">HR Staff</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<%-- Main Content --%>
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Mentor Management</div>
            <div class="page-sub">Workload distribution and intern assignment</div>
        </div>
        <a href="${pageContext.request.contextPath}/hr/mentors/create"
           style="padding:8px 18px;background:linear-gradient(135deg,#10b981,#059669);color:#fff;border-radius:9px;text-decoration:none;font-size:.82rem;font-weight:600;display:flex;align-items:center;gap:6px;box-shadow:0 3px 10px rgba(16,185,129,.35)">
            <i class="bi bi-plus-lg"></i> Add Mentor
        </a>
    </div>

    <div class="content">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i>${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i>${param.error}</div>
        </c:if>

        <%-- Stats strip --%>
        <div class="stats-strip">
            <div class="stat-pill">
                <div class="stat-pill-icon"><i class="bi bi-mortarboard"></i></div>
                <div>
                    <div class="stat-pill-num">${totalMentors}</div>
                    <div class="stat-pill-lbl">Total Mentors</div>
                </div>
            </div>
            <div class="stat-pill">
                <div class="stat-pill-icon"><i class="bi bi-people"></i></div>
                <div>
                    <div class="stat-pill-num">${totalAssigned}</div>
                    <div class="stat-pill-lbl">Active Assignments</div>
                </div>
            </div>
            <div class="stat-pill">
                <div class="stat-pill-icon" style="background:#f0f6ff;color:#0ea5e9"><i class="bi bi-person-workspace"></i></div>
                <div>
                    <div class="stat-pill-num">${fn:length(allInterns)}</div>
                    <div class="stat-pill-lbl">Total Interns</div>
                </div>
            </div>
        </div>

        <%-- Filter bar --%>
        <form class="filter-card" method="get" action="${pageContext.request.contextPath}/hr/mentors">
            <input class="filter-input" type="text" name="keyword" value="${keyword}" placeholder="Search mentor by name, email..." style="width:230px">
            <input class="filter-input" type="text" name="department" value="${department}" placeholder="Department..." style="width:170px">
            <button type="submit" class="btn-filter blue"><i class="bi bi-search"></i> Search</button>
            <a href="${pageContext.request.contextPath}/hr/mentors" class="btn-filter ghost">Reset</a>
        </form>

        <%-- Mentor cards --%>
        <c:choose>
            <c:when test="${empty mentors}">
                <div style="background:#fff;border:1px solid var(--border);border-radius:16px;padding:48px;text-align:center;color:var(--text-muted)">
                    <i class="bi bi-mortarboard" style="font-size:2rem;display:block;margin-bottom:10px;opacity:.3"></i>
                    No mentor profiles found. Create a Mentor user account first.
                </div>
            </c:when>
            <c:otherwise>
                <div class="mentor-grid">
                    <c:forEach var="m" items="${mentors}">
                        <c:set var="fillPct" value="${m.maxInterns > 0 ? (m.currentInternCount * 100 / m.maxInterns) : 0}"/>
                        <c:set var="fillClass" value="${fillPct >= 100 ? 'over' : (fillPct >= 80 ? 'full' : '')}"/>

                        <div class="mentor-card">
                            <%-- Header --%>
                            <div class="mc-header">
                                <div class="mc-avatar">${fn:substring(m.fullName, 0, 1)}</div>
                                <div style="flex:1;min-width:0">
                                    <div class="mc-name">${m.fullName}</div>
                                    <div class="mc-email">${m.email}</div>
                                </div>
                                <c:choose>
                                    <c:when test="${m.userStatus == 'ACTIVE'}">
                                        <span style="background:#f0fdf4;color:#16a34a;font-size:.68rem;font-weight:700;padding:3px 9px;border-radius:20px">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background:#f1f5f9;color:#475569;font-size:.68rem;font-weight:700;padding:3px 9px;border-radius:20px">${m.userStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Workload bar --%>
                            <div class="workload-bar-wrap">
                                <div class="workload-label">
                                    <span>Workload</span>
                                    <strong>${m.currentInternCount} / ${m.maxInterns}</strong>
                                </div>
                                <div class="workload-track">
                                    <div class="workload-fill ${fillClass}" style="width:${fillPct > 100 ? 100 : fillPct}%"></div>
                                </div>
                            </div>

                            <%-- Edit profile form --%>
                            <div class="mc-body">
                                <div style="font-size:.75rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px">
                                    <i class="bi bi-pencil-square" style="margin-right:4px"></i>Edit Profile
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/hr/mentors/update">
                                    <input type="hidden" name="mentorId" value="${m.id}">
                                    <div class="edit-grid">
                                        <div class="edit-group">
                                            <label>Department</label>
                                            <input class="edit-input" type="text" name="department" value="${m.department}" placeholder="e.g. IT">
                                        </div>
                                        <div class="edit-group">
                                            <label>Position</label>
                                            <input class="edit-input" type="text" name="position" value="${m.position}" placeholder="e.g. Lead Tech">
                                        </div>
                                        <div class="edit-group" style="grid-column: 1/-1">
                                            <label>Max Interns</label>
                                            <input class="edit-input" type="number" name="maxInterns" value="${m.maxInterns}" min="1" max="50">
                                        </div>
                                    </div>
                                    <button type="submit" class="btn-save"><i class="bi bi-floppy"></i> Save Details</button>
                                </form>
                            </div>

                            <%-- Assign Intern section --%>
                            <div class="mc-assign">
                                <div class="assign-title"><i class="bi bi-people"></i> Assigned Interns (${m.currentInternCount})</div>
                                <div class="assigned-list">
                                    <c:set var="assignedList" value="${mentorAssignments[m.id]}"/>
                                    <c:choose>
                                        <c:when test="${empty assignedList}">
                                            <div class="no-assigned">No interns assigned yet.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="ai" items="${assignedList}">
                                                <div class="assigned-item">
                                                    <div>
                                                        <div class="assigned-name">${not empty ai.fullName ? ai.fullName : ai.email}</div>
                                                        <div class="assigned-code">${ai.studentCode} · ${ai.university}</div>
                                                    </div>
                                                    <form method="post" action="${pageContext.request.contextPath}/hr/mentors/unassign" style="margin:0"
                                                          onsubmit="return confirm('Remove ${ai.studentCode} from ${m.fullName}?')">
                                                        <input type="hidden" name="mentorId" value="${m.id}">
                                                        <input type="hidden" name="internId" value="${ai.id}">
                                                        <button type="submit" class="btn-unassign"><i class="bi bi-x"></i> Remove</button>
                                                    </form>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- Assign form --%>
                                <c:choose>
                                    <c:when test="${m.currentInternCount >= m.maxInterns}">
                                        <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:8px 12px;display:flex;align-items:center;gap:6px;color:#dc2626;font-size:.78rem;font-weight:600">
                                            <i class="bi bi-slash-circle-fill"></i> Capacity Full (${m.maxInterns}/${m.maxInterns} interns)
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/hr/mentors/assign" class="assign-form">
                                            <input type="hidden" name="mentorId" value="${m.id}">
                                            <select name="internId" class="assign-select" required>
                                                <option value="">— Select Intern —</option>
                                                <c:forEach var="intern" items="${allInterns}">
                                                    <option value="${intern.id}">
                                                        ${not empty intern.fullName ? intern.fullName : intern.email}
                                                        <c:if test="${not empty intern.studentCode}"> (${intern.studentCode})</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="btn-assign"><i class="bi bi-plus-lg"></i> Assign</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
