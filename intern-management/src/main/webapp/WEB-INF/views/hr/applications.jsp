<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Applications — HR</title>
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

        /* ── Sidebar ── */
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
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active {
            background: rgba(14,165,233,.2); color: #fff;
            border-left: 3px solid var(--accent);
        }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-badge {
            margin-left: auto; background: #f59e0b; color: #fff;
            border-radius: 10px; padding: 1px 7px; font-size: .68rem; font-weight: 700;
        }
        .sidebar-footer {
            margin-top: auto; padding: 16px 22px;
            border-top: 1px solid rgba(255,255,255,.08);
        }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, #0ea5e9, #38bdf8);
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

        .content { padding: 28px 32px; flex: 1; }

        /* Alert */
        .alert {
            padding: 12px 18px; border-radius: 10px; font-size: .85rem; font-weight: 500;
            margin-bottom: 18px; display: flex; align-items: center; gap: 8px;
        }
        .alert-success { background: #f0fdf4; border: 1px solid #86efac; color: #15803d; }

        /* Filter tabs */
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 20px; }
        .tab-btn {
            padding: 8px 18px; border-radius: 20px; border: 1.5px solid var(--border);
            background: #fff; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600;
            cursor: pointer; text-decoration: none; color: var(--text-muted);
            transition: all .15s; display: flex; align-items: center; gap: 6px;
        }
        .tab-btn:hover, .tab-btn.active {
            border-color: var(--accent); color: var(--accent); background: #f0f9ff;
        }
        .tab-btn.pending.active { border-color: #f59e0b; color: #b45309; background: #fefce8; }

        /* Card & Table */
        .sec-card {
            background: var(--card-bg); border-radius: 16px;
            border: 1px solid var(--border); overflow: hidden;
            box-shadow: 0 1px 6px rgba(0,0,0,.05);
        }
        .sec-header {
            padding: 16px 22px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 10px;
        }
        .sec-icon {
            width: 36px; height: 36px; border-radius: 9px;
            background: #f0f9ff; color: var(--accent);
            display: flex; align-items: center; justify-content: center; font-size: .95rem;
        }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }

        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th {
            padding: 11px 16px; text-align: left;
            font-size: .7rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .5px; color: var(--text-muted);
            background: #f8fafc; border-bottom: 1px solid var(--border);
        }
        .data-table tbody td {
            padding: 14px 16px; font-size: .84rem; color: var(--text-primary);
            border-bottom: 1px solid #f1f5f9; vertical-align: middle;
        }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f8fafc; }

        .intern-cell { display: flex; align-items: center; gap: 10px; }
        .intern-avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, #0ea5e9, #38bdf8);
            display: flex; align-items: center; justify-content: center;
            font-size: .8rem; font-weight: 700; color: #fff; flex-shrink: 0;
        }
        .intern-name { font-weight: 600; font-size: .86rem; }
        .intern-sub  { font-size: .72rem; color: var(--text-muted); }

        .badge {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600;
        }
        .badge-pending   { background: #fefce8; color: #a16207; border: 1px solid #fde68a; }
        .badge-approved  { background: #f0fdf4; color: #16a34a; border: 1px solid #86efac; }
        .badge-rejected  { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        .empty-state { padding: 48px; text-align: center; color: var(--text-muted); }
        .empty-state i { font-size: 2rem; display: block; margin-bottom: 10px; opacity: .35; }
        .date-cell { font-size: .78rem; color: var(--text-muted); }
    </style>
</head>
<body>

<%-- ── Sidebar ── --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-building"></i></div>
        <h1>Human Resource</h1>
    </div>

    <div class="sidebar-section-label">Management</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="bi bi-grid"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications" class="active">
            <i class="bi bi-clipboard-check"></i> Applications
            <c:if test="${pendingCount > 0}"><span class="sidebar-badge">${pendingCount}</span></c:if>
        </a></li>
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

<%-- ── Main ── --%>
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Internship Applications</div>
            <div class="page-sub">View intern application statuses and reviews</div>
        </div>
        <c:if test="${pendingCount > 0}">
            <span style="background:#fefce8;color:#a16207;border-radius:20px;padding:6px 16px;font-size:.82rem;font-weight:700;border:1px solid #fde68a">
                <i class="bi bi-clock-fill" style="margin-right:5px"></i>${pendingCount} Pending
            </span>
        </c:if>
    </div>

    <div class="content">
        <%-- Flash message --%>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i>${param.success}</div>
        </c:if>

        <%-- Filter tabs --%>
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/hr/applications"
               class="tab-btn ${empty statusFilter ? 'active' : ''}">All</a>
            <a href="${pageContext.request.contextPath}/hr/applications?status=PENDING"
               class="tab-btn pending ${statusFilter == 'PENDING' ? 'active' : ''}">
                <i class="bi bi-clock"></i> Pending
                <c:if test="${pendingCount > 0}"> (${pendingCount})</c:if>
            </a>
            <a href="${pageContext.request.contextPath}/hr/applications?status=APPROVED"
               class="tab-btn ${statusFilter == 'APPROVED' ? 'active' : ''}">
                <i class="bi bi-check-circle"></i> Approved
            </a>
            <a href="${pageContext.request.contextPath}/hr/applications?status=REJECTED"
               class="tab-btn ${statusFilter == 'REJECTED' ? 'active' : ''}">
                <i class="bi bi-x-circle"></i> Rejected
            </a>
        </div>

        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-icon"><i class="bi bi-clipboard-check"></i></div>
                <span class="sec-title">Applications
                    <span style="font-size:.75rem;color:var(--text-muted);font-weight:500;margin-left:6px">(${fn:length(applications)} records)</span>
                </span>
            </div>
            <table class="data-table">
                <thead><tr>
                    <th>#</th>
                    <th>Applicant</th>
                    <th>University / Major</th>
                    <th>Applied At</th>
                    <th>Status</th>
                    <th>Reviewed By</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty applications}">
                            <tr><td colspan="6">
                                <div class="empty-state">
                                    <i class="bi bi-clipboard"></i>
                                    No applications found.
                                </div>
                            </td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="app" items="${applications}" varStatus="st">
                                <tr>
                                    <td style="color:var(--text-muted);font-size:.78rem">${st.index + 1}</td>
                                    <td>
                                        <div class="intern-cell">
                                            <div class="intern-avatar">${fn:substring(app.internName, 0, 1)}</div>
                                            <div>
                                                <div class="intern-name">${app.internName}</div>
                                                <div class="intern-sub">${app.internEmail}</div>
                                                <c:if test="${not empty app.studentCode}">
                                                    <div class="intern-sub"><code style="background:#f1f5f9;padding:1px 5px;border-radius:4px;font-size:.7rem">${app.studentCode}</code></div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:.82rem;font-weight:500">${app.major}</div>
                                        <div style="font-size:.73rem;color:var(--text-muted)">${app.university}</div>
                                    </td>
                                    <td class="date-cell">
                                        <c:if test="${not empty app.applicationDate}">
                                            ${fn:substring(app.applicationDate.toString(), 0, 10)}
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${app.status == 'PENDING'}"><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.4rem"></i>Pending</span></c:when>
                                            <c:when test="${app.status == 'APPROVED'}"><span class="badge badge-approved"><i class="bi bi-check-circle-fill" style="font-size:.4rem"></i>Approved</span></c:when>
                                            <c:otherwise><span class="badge badge-rejected"><i class="bi bi-x-circle-fill" style="font-size:.4rem"></i>Rejected</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size:.8rem;color:var(--text-muted)">
                                        <c:choose>
                                            <c:when test="${not empty app.reviewerName}">${app.reviewerName}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty app.reviewedAt}">
                                            <div style="font-size:.7rem">${fn:substring(app.reviewedAt.toString(), 0, 10)}</div>
                                        </c:if>
                                    </td>
                                </tr>
                                <%-- Show rejection reason if any --%>
                                <c:if test="${app.status == 'REJECTED' && not empty app.rejectionReason}">
                                    <tr>
                                        <td></td>
                                        <td colspan="5" style="padding:0 16px 12px;font-size:.78rem;color:#dc2626;background:#fef2f2">
                                            <i class="bi bi-info-circle" style="margin-right:4px"></i>Reason: ${app.rejectionReason}
                                        </td>
                                    </tr>
                                </c:if>
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
