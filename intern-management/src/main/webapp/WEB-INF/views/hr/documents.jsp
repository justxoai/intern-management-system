<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Document Review — HR Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px; --sidebar-bg: #0c1f3f; --accent: #0ea5e9;
            --page-bg: #f0f6ff; --card-bg: #fff; --text-primary: #0f172a;
            --text-muted: #64748b; --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

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

        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 20px 22px; border: 1px solid var(--border); display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 6px rgba(0,0,0,.05); transition: box-shadow .2s; }
        .stat-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.10); }
        .stat-icon { width: 48px; height: 48px; border-radius: 13px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0; }
        .si-pending  { background: linear-gradient(135deg, #f59e0b, #fbbf24); color:#fff; box-shadow: 0 4px 12px rgba(245,158,11,.3); }
        .si-approved { background: linear-gradient(135deg, #10b981, #34d399); color:#fff; box-shadow: 0 4px 12px rgba(16,185,129,.3); }
        .si-rejected { background: linear-gradient(135deg, #ef4444, #f87171); color:#fff; box-shadow: 0 4px 12px rgba(239,68,68,.3); }
        .stat-count { font-size: 2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-label { font-size: .78rem; color: var(--text-muted); margin-top: 4px; font-weight: 500; }

        /* Filter & table */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid var(--border); }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; background: #eff6ff; color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); flex: 1; }
        .sec-count { background: #eff6ff; color: var(--accent); font-size: .72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; }

        .filter-bar { background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: flex-end; gap: 10px; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 4px; }
        .filter-label { font-size: .68rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .filter-select { padding: 7px 10px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .81rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; min-width: 150px; }
        .filter-select:focus { border-color: var(--accent); }
        .btn-filter { padding: 7px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600; display: flex; align-items: center; gap: 5px; transition: opacity .15s; }
        .btn-filter.blue  { background: var(--accent); color: #fff; }
        .btn-filter.ghost { background: var(--border);  color: var(--text-muted); text-decoration: none; }
        .btn-filter:hover { opacity: .85; }

        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; font-size: .85rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f0f9ff; }

        .intern-cell { display: flex; align-items: center; gap: 9px; }
        .intern-avatar { width: 30px; height: 30px; border-radius: 50%; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: .75rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .doc-type-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 11px; border-radius: 8px; font-size: .75rem; font-weight: 600; }
        .dt-cv   { background: #f5f3ff; color: #7c3aed; }
        .dt-app  { background: #eff6ff; color: #1d4ed8; }
        .dt-contract { background: #f0fdf4; color: #16a34a; }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 4px 11px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-pending  { background: #fefce8; color: #a16207; }
        .badge-approved { background: #f0fdf4; color: #16a34a; }
        .badge-rejected { background: #fef2f2; color: #dc2626; }

        .review-actions { display: flex; align-items: center; gap: 7px; }
        .btn-approve { display: inline-flex; align-items: center; gap: 5px; padding: 6px 14px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .78rem; font-weight: 600; background: linear-gradient(135deg, #10b981, #34d399); color: #fff; box-shadow: 0 2px 8px rgba(16,185,129,.3); transition: opacity .15s; }
        .btn-approve:hover { opacity: .85; }
        .btn-reject  { display: inline-flex; align-items: center; gap: 5px; padding: 6px 14px; border-radius: 8px; border: 1.5px solid #fecaca; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .78rem; font-weight: 600; background: #fff; color: #dc2626; transition: all .15s; }
        .btn-reject:hover { background: #fef2f2; }
        .btn-view { display: inline-flex; align-items: center; gap: 5px; padding: 6px 12px; border-radius: 8px; text-decoration: none; font-size: .78rem; font-weight: 600; background: #eff6ff; color: var(--accent); border: 1px solid #bfdbfe; transition: all .15s; }
        .btn-view:hover { background: var(--accent); color: #fff; }

        .already-reviewed { font-size: .78rem; color: var(--text-muted); font-style: italic; }
        .empty-state { padding: 48px; text-align: center; color: var(--text-muted); }
        .empty-state i { font-size: 2.5rem; margin-bottom: 12px; display: block; opacity: .35; }
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
        <li><a href="${pageContext.request.contextPath}/hr/dashboard">
            <i class="bi bi-grid"></i> Dashboard
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/mentors">
            <i class="bi bi-mortarboard"></i> Mentors
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications">
            <i class="bi bi-clipboard-check"></i> Applications
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/contracts">
            <i class="bi bi-file-earmark-text"></i> Contracts
        </a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents" class="active">
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
            <div class="page-title">Document Review</div>
            <div class="page-sub">Review and approve intern documents</div>
        </div>
        <%-- Pending count badge --%>
        <c:set var="pendingCount" value="0"/>
        <c:forEach var="d" items="${documents}">
            <c:if test="${d.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
        </c:forEach>
        <c:if test="${pendingCount > 0}">
            <span style="background:#fef9c3;color:#a16207;border-radius:20px;padding:6px 16px;font-size:.82rem;font-weight:700;border:1px solid #fde68a">
                <i class="bi bi-clock-fill me-1"></i> ${pendingCount} Pending Review
            </span>
        </c:if>
    </div>

    <div class="content">

        <%-- Stats --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon si-pending"><i class="bi bi-hourglass-split"></i></div>
                <div>
                    <c:set var="pc" value="0"/>
                    <c:forEach var="d" items="${documents}"><c:if test="${d.status == 'PENDING'}"><c:set var="pc" value="${pc + 1}"/></c:if></c:forEach>
                    <div class="stat-count">${pc}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-approved"><i class="bi bi-check-circle"></i></div>
                <div>
                    <c:set var="ac" value="0"/>
                    <c:forEach var="d" items="${documents}"><c:if test="${d.status == 'APPROVED'}"><c:set var="ac" value="${ac + 1}"/></c:if></c:forEach>
                    <div class="stat-count">${ac}</div>
                    <div class="stat-label">Approved</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-rejected"><i class="bi bi-x-circle"></i></div>
                <div>
                    <c:set var="rc" value="0"/>
                    <c:forEach var="d" items="${documents}"><c:if test="${d.status == 'REJECTED'}"><c:set var="rc" value="${rc + 1}"/></c:if></c:forEach>
                    <div class="stat-count">${rc}</div>
                    <div class="stat-label">Rejected</div>
                </div>
            </div>
        </div>

        <%-- Document list --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-icon"><i class="bi bi-folder-check"></i></div>
                <span class="sec-title">All Intern Documents</span>
                <span class="sec-count">${fn:length(documents)}</span>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/documents">
                <div class="filter-group">
                    <span class="filter-label">Filter by Status</span>
                    <select class="filter-select" name="status">
                        <option value="">All Documents</option>
                        <option value="PENDING"  ${statusFilter == 'PENDING'  ? 'selected' : ''}>Pending</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Approved</option>
                        <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter blue"><i class="bi bi-funnel"></i> Filter</button>
                <a href="${pageContext.request.contextPath}/hr/documents" class="btn-filter ghost">Clear</a>
            </form>

            <table class="data-table">
                <thead><tr>
                    <th>Intern</th><th>Type</th><th>File</th><th>Uploaded</th><th>Status</th><th>Reviewed By</th><th>Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty documents}">
                            <tr><td colspan="7">
                                <div class="empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <p>No documents found for the selected filter.</p>
                                </div>
                            </td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="d" items="${documents}">
                                <tr>
                                    <td>
                                        <div class="intern-cell">
                                            <div class="intern-avatar">${fn:substring(d.internName, 0, 1)}</div>
                                            <span style="font-weight:600">${d.internName}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.documentType == 'CV'}">
                                                <span class="doc-type-badge dt-cv"><i class="bi bi-file-person"></i>CV</span>
                                            </c:when>
                                            <c:when test="${d.documentType == 'INTERNSHIP_APPLICATION'}">
                                                <span class="doc-type-badge dt-app"><i class="bi bi-file-earmark-text"></i>Application</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="doc-type-badge dt-contract"><i class="bi bi-file-earmark-check"></i>Contract</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:.8rem">${d.fileName}</td>
                                    <td style="color:var(--text-muted);font-size:.78rem">${d.uploadedAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.status == 'APPROVED'}"><span class="badge badge-approved"><i class="bi bi-check-circle-fill" style="font-size:.6rem"></i>Approved</span></c:when>
                                            <c:when test="${d.status == 'REJECTED'}"><span class="badge badge-rejected"><i class="bi bi-x-circle-fill" style="font-size:.6rem"></i>Rejected</span></c:when>
                                            <c:otherwise><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.6rem"></i>Pending</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.78rem">
                                        <c:choose>
                                            <c:when test="${not empty d.reviewerName}">${d.reviewerName}<br><small>${d.reviewedAt}</small></c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="review-actions">
                                            <a href="${pageContext.request.contextPath}${d.filePath}" class="btn-view" target="_blank">
                                                <i class="bi bi-eye"></i> View
                                            </a>
                                            <c:if test="${d.status == 'PENDING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/hr/documents/review" style="display:inline">
                                                    <input type="hidden" name="id"     value="${d.id}">
                                                    <input type="hidden" name="action" value="APPROVED">
                                                    <button type="submit" class="btn-approve"><i class="bi bi-check-lg"></i> Approve</button>
                                                </form>
                                                <form method="post" action="${pageContext.request.contextPath}/hr/documents/review" style="display:inline"
                                                      onsubmit="return confirm('Reject this document?')">
                                                    <input type="hidden" name="id"     value="${d.id}">
                                                    <input type="hidden" name="action" value="REJECTED">
                                                    <button type="submit" class="btn-reject"><i class="bi bi-x-lg"></i> Reject</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${d.status != 'PENDING'}">
                                                <span class="already-reviewed">Reviewed</span>
                                            </c:if>
                                        </div>
                                    </td>
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
