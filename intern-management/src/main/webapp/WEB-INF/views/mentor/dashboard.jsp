<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bảng điều khiển Mentor — Quản lý Thực tập</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0f2318;
            --accent: #10b981;
            --accent2: #34d399;
            --task-col: #0891b2;
            --page-bg: #f0fdf6;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(16,185,129,.2); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
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
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 20px 22px; border: 1px solid var(--border); display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 6px rgba(0,0,0,.05); transition: box-shadow .2s, transform .2s; }
        .stat-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,.10); transform: translateY(-2px); }
        .stat-icon { width: 50px; height: 50px; border-radius: 13px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0; }
        .si-green { background: linear-gradient(135deg,#10b981,#34d399); color:#fff; box-shadow: 0 4px 12px rgba(16,185,129,.3); }
        .si-cyan  { background: linear-gradient(135deg,#0891b2,#22d3ee); color:#fff; box-shadow: 0 4px 12px rgba(8,145,178,.3); }
        .si-amber { background: linear-gradient(135deg,#f59e0b,#fbbf24); color:#fff; box-shadow: 0 4px 12px rgba(245,158,11,.3); }
        .stat-count { font-size: 2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-label { font-size: .78rem; color: var(--text-muted); margin-top: 4px; font-weight: 500; }

        /* Section card */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .si-interns { background: #f0fdf4; color: #10b981; }
        .si-tasks   { background: #ecfeff; color: #0891b2; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .sec-count { font-size: .72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
        .count-intern { background: #f0fdf4; color: #10b981; }
        .count-task   { background: #ecfeff; color: #0891b2; }

        /* Filter */
        .filter-bar { background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: flex-end; gap: 10px; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 4px; }
        .filter-label { font-size: .68rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .filter-input, .filter-select { padding: 7px 10px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .81rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; min-width: 110px; }
        .filter-input:focus, .filter-select:focus { border-color: var(--accent); }
        .btn-filter { padding: 7px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600; display: flex; align-items: center; gap: 5px; text-decoration: none; transition: opacity .15s; }
        .btn-filter:hover { opacity: .85; }
        .btn-filter.green { background: var(--accent);   color: #fff; }
        .btn-filter.cyan  { background: var(--task-col); color: #fff; }
        .btn-filter.ghost { background: var(--border);   color: var(--text-muted); }
        .btn-assign { padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600; display: flex; align-items: center; gap: 6px; text-decoration: none; transition: opacity .15s, box-shadow .2s; background: linear-gradient(135deg,#0891b2,#22d3ee); color: #fff; box-shadow: 0 2px 10px rgba(8,145,178,.35); }
        .btn-assign:hover { opacity: .88; }

        /* Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 13px 16px; font-size: .85rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f0fdf4; }

        .user-cell { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .82rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .ua-green { background: linear-gradient(135deg, #10b981, #34d399); }
        .ua-cyan  { background: linear-gradient(135deg, #0891b2, #22d3ee); }
        .user-name  { font-weight: 600; font-size: .85rem; }
        .user-email { font-size: .75rem; color: var(--text-muted); }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-pending   { background: #fefce8; color: #a16207; }
        .badge-approved  { background: #f0fdf4; color: #16a34a; }
        .badge-interning { background: #eff6ff; color: #1d4ed8; }
        .badge-completed { background: #f5f3ff; color: #7c3aed; }
        .badge-todo      { background: #f1f5f9; color: #475569; }
        .badge-inprog    { background: #fefce8; color: #a16207; }
        .badge-done      { background: #f0fdf4; color: #16a34a; }

        /* Progress bar */
        .progress-wrap { display: flex; align-items: center; gap: 8px; }
        .progress-bar-outer { flex: 1; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; min-width: 60px; }
        .progress-bar-inner { height: 100%; border-radius: 3px; background: linear-gradient(90deg, #10b981, #34d399); }
        .progress-pct { font-size: .72rem; color: var(--text-muted); min-width: 28px; }

        .action-group { display: flex; align-items: center; gap: 6px; }
        .btn-icon { width: 30px; height: 30px; border-radius: 7px; border: 1.5px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: .85rem; cursor: pointer; text-decoration: none; background: #fff; transition: all .15s; }
        .btn-icon.edit   { color: var(--task-col); } .btn-icon.edit:hover   { background: #ecfeff; border-color: var(--task-col); }
        .btn-icon.delete { color: #ef4444; }          .btn-icon.delete:hover { background: #fef2f2; border-color: #ef4444; }

        .empty-state { padding: 36px; text-align: center; color: var(--text-muted); font-size: .87rem; }
        .empty-state i { font-size: 2rem; margin-bottom: 8px; display: block; opacity: .4; }

        /* Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 200; align-items: center; justify-content: center; backdrop-filter: blur(3px); }
        .modal-overlay.open { display: flex; }
        .modal-box { background: #fff; border-radius: 18px; width: 560px; max-width: 95vw; box-shadow: 0 20px 60px rgba(0,0,0,.25); overflow: hidden; animation: slideUp .25s ease; }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px 24px; background: linear-gradient(135deg,#0891b2,#22d3ee); display: flex; align-items: center; justify-content: space-between; }
        .modal-header h3 { color: #fff; font-size: 1rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .modal-close { background: none; border: none; color: rgba(255,255,255,.8); font-size: 1.3rem; cursor: pointer; }
        .modal-close:hover { color: #fff; }
        .modal-body { padding: 24px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
        .form-group.full { grid-column: 1/-1; }
        .form-label { font-size: .77rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .form-input, .form-select, .form-textarea {
            padding: 9px 12px; border: 1.5px solid var(--border); border-radius: 9px;
            font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary);
            background: #fff; outline: none; transition: border-color .2s;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: var(--task-col); box-shadow: 0 0 0 3px rgba(8,145,178,.1); }
        .form-textarea { resize: vertical; min-height: 80px; }
        .modal-footer { padding: 16px 24px; background: #f8fafc; display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border); }
        .btn-submit { padding: 9px 24px; border-radius: 9px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: linear-gradient(135deg,#0891b2,#22d3ee); color: #fff; box-shadow: 0 2px 10px rgba(8,145,178,.3); transition: opacity .15s; }
        .btn-submit:hover { opacity: .88; }
        .btn-cancel { padding: 9px 20px; border-radius: 9px; border: 1.5px solid var(--border); cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: #fff; color: var(--text-muted); transition: border-color .15s; }
        .btn-cancel:hover { border-color: #94a3b8; }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
        <h1>Cổng thông tin<br>Mentor</h1>
        <span>Quản lý Thực tập</span>
    </div>
    <div class="sidebar-section-label">Tổng quan</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/mentor/dashboard" class="active">
            <i class="bi bi-grid"></i> Bảng điều khiển
        </a></li>
    </ul>
    <div class="sidebar-section-label">Thao tác</div>
    <ul class="sidebar-nav">
        <li><a href="#" onclick="openModal();return false;">
            <i class="bi bi-plus-circle"></i> Giao nhiệm vụ mới
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Mentor</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<!-- Main -->
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Quản lý Thực tập sinh</div>
            <div class="page-sub">Thực tập sinh được phân công và theo dõi nhiệm vụ</div>
        </div>
        <button onclick="openModal()" class="btn-assign">
            <i class="bi bi-plus-lg"></i> Giao nhiệm vụ
        </button>
    </div>

    <div class="content">

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="bi bi-people"></i></div>
                <div>
                    <div class="stat-count">${fn:length(myInterns)}</div>
                    <div class="stat-label">TTS của tôi</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-cyan"><i class="bi bi-list-task"></i></div>
                <div>
                    <div class="stat-count">${fn:length(tasks)}</div>
                    <div class="stat-label">Tổng nhiệm vụ</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-amber"><i class="bi bi-hourglass-split"></i></div>
                <div>
                    <%-- Count in-progress tasks --%>
                    <c:set var="inProgressCount" value="0"/>
                    <c:forEach var="t" items="${tasks}">
                        <c:if test="${t.status == 'IN_PROGRESS'}">
                            <c:set var="inProgressCount" value="${inProgressCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    <div class="stat-count">${inProgressCount}</div>
                    <div class="stat-label">Đang thực hiện</div>
                </div>
            </div>
        </div>

        <%-- MY INTERNS SECTION --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon si-interns"><i class="bi bi-people"></i></div>
                    <span class="sec-title">Thực tập sinh của tôi</span>
                    <span class="sec-count count-intern">${fn:length(myInterns)}</span>
                </div>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/mentor/dashboard">
                <div class="filter-group">
                    <span class="filter-label">Tìm kiếm</span>
                    <input class="filter-input" type="text" name="internKeyword" value="${internKeyword}" placeholder="Mã / Tên / Email" style="width:200px">
                </div>
                <button type="submit" class="btn-filter green"><i class="bi bi-search"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn-filter ghost">Xóa lọc</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>Thực tập sinh</th><th>Mã SV</th><th>Chuyên ngành / Trường</th><th>Email</th><th>Trạng thái</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty myInterns}">
                            <tr><td colspan="5"><div class="empty-state"><i class="bi bi-inbox"></i>Chưa có thực tập sinh nào được phân công cho bạn.<br><small>Vui lòng liên hệ HR để được phân công thực tập sinh.</small></div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${myInterns}">
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar ua-green">${fn:substring(i.fullName != null ? i.fullName : 'I', 0, 1)}</div>
                                            <div>
                                                <div class="user-name">${not empty i.fullName ? i.fullName : '—'}</div>
                                                <div class="user-email">${i.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><code style="background:#f0fdf4;padding:2px 7px;border-radius:5px;font-size:.75rem;color:#059669">${i.studentCode}</code></td>
                                    <td>
                                        <div style="font-size:.82rem;font-weight:500">${i.university}</div>
                                        <div style="font-size:.73rem;color:var(--text-muted)">${i.major}</div>
                                    </td>
                                    <td style="color:var(--text-muted)">${i.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.status == 'APPROVED'}"><span class="badge badge-approved"><i class="bi bi-check-circle-fill" style="font-size:.6rem"></i>Đã duyệt</span></c:when>
                                            <c:when test="${i.status == 'INTERNING'}"><span class="badge badge-interning"><i class="bi bi-play-circle-fill" style="font-size:.6rem"></i>Đang thực tập</span></c:when>
                                            <c:when test="${i.status == 'COMPLETED'}"><span class="badge badge-completed"><i class="bi bi-patch-check-fill" style="font-size:.6rem"></i>Hoàn thành</span></c:when>
                                            <c:otherwise><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.6rem"></i>Chờ duyệt</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- TASKS SECTION --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon si-tasks"><i class="bi bi-list-task"></i></div>
                    <span class="sec-title">Giao việc &amp; Nhiệm vụ</span>
                    <span class="sec-count count-task">${fn:length(tasks)}</span>
                </div>
                <button onclick="openModal()" class="btn-assign">
                    <i class="bi bi-plus-lg"></i> Giao nhiệm vụ
                </button>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/mentor/dashboard">
                <div class="filter-group">
                    <span class="filter-label">Trạng thái</span>
                    <select class="filter-select" name="taskStatus" style="width:150px">
                        <option value="">Tất cả trạng thái</option>
                        <option value="TODO"        ${taskStatus == 'TODO'        ? 'selected' : ''}>Cần làm</option>
                        <option value="IN_PROGRESS" ${taskStatus == 'IN_PROGRESS' ? 'selected' : ''}>Đang thực hiện</option>
                        <option value="COMPLETED"   ${taskStatus == 'COMPLETED'   ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter cyan"><i class="bi bi-funnel"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn-filter ghost">Xóa lọc</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>Nhiệm vụ</th><th>TTS phụ trách</th><th>Trạng thái</th><th>Hạn nộp</th><th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <tr><td colspan="5"><div class="empty-state"><i class="bi bi-clipboard-x"></i>Chưa có nhiệm vụ nào được giao. Nhấp "Giao nhiệm vụ" để bắt đầu.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="t" items="${tasks}">
                                <tr>
                                    <td>
                                        <div class="user-name">${t.title}</div>
                                        <c:if test="${not empty t.description}">
                                            <div class="user-email" style="max-width:240px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${t.description}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty t.internName}">
                                            <div class="user-cell">
                                                <div class="user-avatar ua-green" style="width:26px;height:26px;font-size:.7rem">${fn:substring(t.internName,0,1)}</div>
                                                <span style="font-size:.82rem">${t.internName}</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty t.internName}"><span style="color:var(--text-muted);font-size:.8rem">—</span></c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'COMPLETED'}"><span class="badge badge-done"><i class="bi bi-check2-all" style="font-size:.7rem"></i>Hoàn thành</span></c:when>
                                            <c:when test="${t.status == 'IN_PROGRESS'}"><span class="badge badge-inprog"><i class="bi bi-arrow-repeat" style="font-size:.7rem"></i>Đang làm</span></c:when>
                                            <c:otherwise><span class="badge badge-todo"><i class="bi bi-circle" style="font-size:.6rem"></i>Cần làm</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.82rem">
                                        <c:choose>
                                            <c:when test="${not empty t.dueDate}"><i class="bi bi-calendar3" style="font-size:.75rem;margin-right:4px"></i>${t.dueDate}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?id=${t.id}" class="btn-icon edit" title="Sửa"><i class="bi bi-pencil"></i></a>
                                            <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/delete" style="display:inline" onsubmit="return confirm('Xóa nhiệm vụ: ${t.title}?')">
                                                <input type="hidden" name="id" value="${t.id}">
                                                <button type="submit" class="btn-icon delete" title="Xóa"><i class="bi bi-trash"></i></button>
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

    </div>
</div>

<!-- Assign Task Modal -->
<div class="modal-overlay" id="taskModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="bi bi-plus-circle"></i> Giao nhiệm vụ mới</h3>
            <button class="modal-close" onclick="closeModal()">&#x2715;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/create">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Tiêu đề nhiệm vụ *</label>
                    <input type="text" name="title" class="form-input" required placeholder="VD: Xây dựng module đăng nhập">
                </div>
                <div class="form-group">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-textarea" placeholder="Chi tiết yêu cầu và nội dung công việc..."></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Giao cho TTS *</label>
                        <select name="internId" class="form-select" required>
                            <option value="">— Chọn thực tập sinh —</option>
                            <c:forEach var="i" items="${allMyInterns}">
                                <option value="${i.id}">${i.studentCode} — ${not empty i.fullName ? i.fullName : i.email}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="TODO">Cần làm</option>
                            <option value="IN_PROGRESS">Đang thực hiện</option>
                            <option value="COMPLETED">Đã hoàn thành</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Hạn nộp</label>
                    <input type="date" name="dueDate" class="form-input">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-submit"><i class="bi bi-check-lg"></i> Giao nhiệm vụ</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal()  { document.getElementById('taskModal').classList.add('open'); }
    function closeModal() { document.getElementById('taskModal').classList.remove('open'); }
    document.getElementById('taskModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>
