<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cập nhật Nhiệm vụ — Cổng thông tin Mentor</title>
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

        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 16px 20px; border: 1px solid var(--border); display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .stat-icon { width: 44px; height: 44px; border-radius: 11px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .si-all   { background: linear-gradient(135deg,#0891b2,#22d3ee); color:#fff; }
        .si-todo  { background: #f1f5f9; color:#475569; }
        .si-inprog{ background: linear-gradient(135deg,#f59e0b,#fbbf24); color:#fff; }
        .si-done  { background: linear-gradient(135deg,#10b981,#34d399); color:#fff; }
        .stat-num { font-size: 1.6rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-lbl { font-size: .74rem; color: var(--text-muted); margin-top: 3px; font-weight: 500; }

        /* Section Card */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .si-cyan  { background: #ecfeff; color: #0891b2; }
        .si-edit  { background: #f0fdf4; color: #10b981; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .sec-count { font-size: .72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; background: #ecfeff; color: #0891b2; }

        /* Buttons */
        .btn-assign { padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: opacity .15s, box-shadow .2s; background: linear-gradient(135deg,#0891b2,#22d3ee); color: #fff; box-shadow: 0 2px 10px rgba(8,145,178,.35); }
        .btn-assign:hover { opacity: .88; }
        .btn-filter { padding: 7px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .81rem; font-weight: 600; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; transition: opacity .15s; }
        .btn-filter.cyan  { background: var(--task-col); color: #fff; }
        .btn-filter.ghost { background: var(--border); color: var(--text-muted); }
        .btn-filter.ghost:hover { background: #cbd5e1; }
        .btn-filter.active-tab { background: var(--accent); color: #fff; }

        /* Filter bar */
        .filter-bar { background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
        .filter-tabs { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
        .filter-input { padding: 7px 12px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .81rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; width: 220px; }
        .filter-input:focus { border-color: var(--task-col); }

        /* Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; font-size: .85rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f0fdf4; }
        .data-table tbody tr.row-selected td { background: #ecfeff; }

        .user-cell { display: flex; align-items: center; gap: 8px; }
        .user-avatar { width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .72rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .ua-green { background: linear-gradient(135deg, #10b981, #34d399); }
        .task-title-cell { font-weight: 600; font-size: .86rem; margin-bottom: 2px; }
        .task-desc-cell { font-size: .75rem; color: var(--text-muted); max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-todo      { background: #f1f5f9; color: #475569; }
        .badge-inprog    { background: #fefce8; color: #a16207; }
        .badge-done      { background: #f0fdf4; color: #16a34a; }

        /* Progress in table */
        .progress-wrap { display: flex; align-items: center; gap: 8px; min-width: 110px; }
        .progress-bar-outer { flex: 1; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
        .progress-bar-inner { height: 100%; border-radius: 3px; }
        .progress-pct { font-size: .74rem; font-weight: 700; min-width: 32px; color: var(--text-primary); }

        /* Action & Quick Update */
        .action-group { display: flex; align-items: center; gap: 6px; }
        .btn-icon { width: 30px; height: 30px; border-radius: 7px; border: 1.5px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: .85rem; cursor: pointer; text-decoration: none; background: #fff; transition: all .15s; }
        .btn-icon.edit   { color: var(--task-col); } .btn-icon.edit:hover   { background: #ecfeff; border-color: var(--task-col); }
        .btn-icon.delete { color: #ef4444; }          .btn-icon.delete:hover { background: #fef2f2; border-color: #ef4444; }

        /* In-table Quick Update Form */
        .quick-update-form { display: flex; align-items: center; gap: 6px; flex-wrap: nowrap; }
        .quick-select { padding: 4px 6px; border: 1px solid var(--border); border-radius: 6px; font-family: 'Inter', sans-serif; font-size: .75rem; background: #fff; color: var(--text-primary); outline: none; }
        .quick-select:focus { border-color: var(--task-col); }
        .quick-range { width: 70px; accent-color: var(--task-col); cursor: pointer; }
        .btn-save-quick { padding: 4px 8px; border-radius: 6px; border: none; cursor: pointer; font-size: .75rem; background: #ecfeff; color: var(--task-col); font-weight: 700; transition: background .15s; }
        .btn-save-quick:hover { background: var(--task-col); color: #fff; }

        /* Full Edit Card */
        .edit-card-body { padding: 22px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
        .form-label { font-size: .75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .form-input, .form-select, .form-textarea { padding: 9px 12px; border: 1.5px solid var(--border); border-radius: 9px; font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: var(--task-col); box-shadow: 0 0 0 3px rgba(8,145,178,.1); }
        .form-textarea { resize: vertical; min-height: 80px; }
        .slider-wrap { display: flex; align-items: center; gap: 12px; background: #f8fafc; padding: 8px 14px; border-radius: 9px; border: 1.5px solid var(--border); }
        .slider-input { flex: 1; accent-color: var(--task-col); height: 6px; cursor: pointer; }
        .slider-val { font-size: .95rem; font-weight: 800; color: var(--task-col); min-width: 45px; text-align: right; }

        .empty-state { padding: 40px; text-align: center; color: var(--text-muted); font-size: .88rem; }
        .empty-state i { font-size: 2.2rem; margin-bottom: 8px; display: block; opacity: .4; }

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
        <li><a href="${pageContext.request.contextPath}/mentor/dashboard">
            <i class="bi bi-grid"></i> Bảng điều khiển
        </a></li>
    </ul>
    <div class="sidebar-section-label">Thao tác</div>
    <ul class="sidebar-nav">
        <li><a href="#" onclick="openModal();return false;">
            <i class="bi bi-plus-circle"></i> Giao nhiệm vụ mới
        </a></li>
        <li><a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit" class="active">
            <i class="bi bi-pencil-square"></i> Cập nhật nhiệm vụ
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
            <div class="page-title">Cập nhật &amp; Quản lý Tiến độ Nhiệm vụ</div>
            <div class="page-sub">Tổng hợp toàn bộ nhiệm vụ đã giao — Theo dõi và cập nhật tiến độ công việc</div>
        </div>
        <div style="display:flex;align-items:center;gap:10px">
            <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn-filter ghost">
                <i class="bi bi-arrow-left"></i> Bảng điều khiển
            </a>
            <button onclick="openModal()" class="btn-assign">
                <i class="bi bi-plus-lg"></i> Giao nhiệm vụ mới
            </button>
        </div>
    </div>

    <div class="content">

        <%-- Alerts --%>
        <c:if test="${not empty param.success}">
            <div style="padding:12px 18px;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;margin-bottom:20px;color:#15803d;font-size:.85rem;font-weight:600;display:flex;align-items:center;gap:8px">
                <i class="bi bi-check-circle-fill"></i> ${param.success}
            </div>
        </c:if>

        <%-- Stats --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon si-all"><i class="bi bi-list-task"></i></div>
                <div>
                    <div class="stat-num">${fn:length(allTasks)}</div>
                    <div class="stat-lbl">Tổng nhiệm vụ</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-todo"><i class="bi bi-clock"></i></div>
                <div>
                    <div class="stat-num">${todoCount}</div>
                    <div class="stat-lbl">Chờ thực hiện</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-inprog"><i class="bi bi-arrow-repeat"></i></div>
                <div>
                    <div class="stat-num">${inProgCount}</div>
                    <div class="stat-lbl">Đang làm</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-done"><i class="bi bi-check2-circle"></i></div>
                <div>
                    <div class="stat-num">${doneCount}</div>
                    <div class="stat-lbl">Đã hoàn thành</div>
                </div>
            </div>
        </div>

        <%-- Detailed Edit Card (when selectedTask is present) --%>
        <c:if test="${not empty selectedTask}">
            <div class="sec-card" style="border:2px solid var(--task-col);box-shadow:0 4px 16px rgba(8,145,178,.15)">
                <div class="sec-header" style="background:#ecfeff">
                    <div class="sec-header-left">
                        <div class="sec-icon si-edit"><i class="bi bi-pencil-square"></i></div>
                        <div>
                            <span class="sec-title">Chỉnh sửa chi tiết nhiệm vụ #${selectedTask.id}: ${selectedTask.title}</span>
                            <div style="font-size:.75rem;color:var(--text-muted);margin-top:2px">
                                TTS: <strong>${not empty selectedTask.internName ? selectedTask.internName : '—'}</strong> |
                                Tiến độ hiện tại: <strong>${selectedTask.progress}%</strong>
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit" class="btn-filter ghost" style="padding:4px 12px;font-size:.78rem">
                        <i class="bi bi-x-lg"></i> Đóng chỉnh sửa
                    </a>
                </div>
                <div class="edit-card-body">
                    <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/edit">
                        <input type="hidden" name="id" value="${selectedTask.id}">

                        <div class="form-group">
                            <label class="form-label">Tiêu đề nhiệm vụ *</label>
                            <input type="text" name="title" class="form-input" required value="${selectedTask.title}">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Mô tả công việc</label>
                            <textarea name="description" class="form-textarea">${selectedTask.description}</textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Giao cho Thực tập sinh *</label>
                                <select name="internId" class="form-select" required>
                                    <c:forEach var="i" items="${allMyInterns}">
                                        <option value="${i.id}" ${i.id == selectedTask.internId ? 'selected' : ''}>
                                            ${not empty i.studentCode ? i.studentCode.concat(' — ') : ''}${not empty i.fullName ? i.fullName : i.email}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hạn nộp</label>
                                <input type="date" name="dueDate" class="form-input" value="${selectedTask.dueDate}">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Trạng thái từ Mentor *</label>
                                <select name="status" id="detailStatus" class="form-select" onchange="syncDetailStatus(this.value)">
                                    <option value="TODO"        ${selectedTask.status == 'TODO'        ? 'selected' : ''}>Chờ thực hiện</option>
                                    <option value="IN_PROGRESS" ${selectedTask.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang làm</option>
                                    <option value="COMPLETED"   ${selectedTask.status == 'COMPLETED'   ? 'selected' : ''}>Đã hoàn thành</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Tiến độ (% hoàn thành)</label>
                                <div class="slider-wrap">
                                    <input type="range" name="progress" min="0" max="100" step="5"
                                           value="${selectedTask.progress}" class="slider-input" id="detailRange"
                                           oninput="document.getElementById('detailVal').textContent=this.value+'%'">
                                    <span class="slider-val" id="detailVal">${selectedTask.progress}%</span>
                                </div>
                            </div>
                        </div>

                        <div style="display:flex;align-items:center;gap:10px;margin-top:8px;padding-top:14px;border-top:1px solid var(--border)">
                            <button type="submit" class="btn-assign" style="padding:9px 22px">
                                <i class="bi bi-floppy"></i> Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit" class="btn-filter ghost" style="padding:9px 18px">
                                Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <%-- Main Aggregated Tasks Section ("Tổng hợp nhiều task") --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon si-cyan"><i class="bi bi-kanban"></i></div>
                    <span class="sec-title">Danh sách Tổng hợp Nhiệm vụ &amp; Cập nhật Tiến độ</span>
                    <span class="sec-count">${fn:length(tasks)} nhiệm vụ</span>
                </div>
            </div>

            <%-- Filter & Search Bar --%>
            <div class="filter-bar">
                <div class="filter-tabs">
                    <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit"
                       class="btn-filter ${empty taskStatus ? 'active-tab' : 'ghost'}">
                        Tất cả (${fn:length(allTasks)})
                    </a>
                    <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?taskStatus=TODO"
                       class="btn-filter ${taskStatus == 'TODO' ? 'active-tab' : 'ghost'}">
                        <i class="bi bi-clock"></i> Chờ thực hiện (${todoCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?taskStatus=IN_PROGRESS"
                       class="btn-filter ${taskStatus == 'IN_PROGRESS' ? 'active-tab' : 'ghost'}">
                        <i class="bi bi-arrow-repeat"></i> Đang làm (${inProgCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?taskStatus=COMPLETED"
                       class="btn-filter ${taskStatus == 'COMPLETED' ? 'active-tab' : 'ghost'}">
                        <i class="bi bi-check2-circle"></i> Đã hoàn thành (${doneCount})
                    </a>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/mentor/dashboard/task/edit" style="display:flex;align-items:center;gap:6px">
                    <c:if test="${not empty taskStatus}">
                        <input type="hidden" name="taskStatus" value="${taskStatus}">
                    </c:if>
                    <input type="text" name="keyword" class="filter-input" placeholder="Tìm tên task hoặc TTS..." value="${keyword}">
                    <button type="submit" class="btn-filter cyan"><i class="bi bi-search"></i></button>
                    <c:if test="${not empty keyword || not empty taskStatus}">
                        <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit" class="btn-filter ghost" title="Xóa lọc">✕</a>
                    </c:if>
                </form>
            </div>

            <%-- Tasks Data Table --%>
            <table class="data-table">
                <thead><tr>
                    <th>Nhiệm vụ</th>
                    <th>TTS phụ trách</th>
                    <th>Hạn nộp</th>
                    <th>Trạng thái &amp; Tiến độ</th>
                    <th style="min-width:240px">Cập nhật nhanh tiến độ</th>
                    <th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <tr><td colspan="6"><div class="empty-state"><i class="bi bi-clipboard-x"></i>Không tìm thấy nhiệm vụ nào.<br><small>Nhấp "Giao nhiệm vụ mới" để tạo công việc cho thực tập sinh.</small></div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="t" items="${tasks}">
                                <tr class="${selectedTaskId == t.id ? 'row-selected' : ''}">
                                    <td>
                                        <div class="task-title-cell">#${t.id} — ${t.title}</div>
                                        <c:if test="${not empty t.description}">
                                            <div class="task-desc-cell" title="${t.description}">${t.description}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.internName}">
                                                <div class="user-cell">
                                                    <div class="user-avatar ua-green">${fn:substring(t.internName,0,1)}</div>
                                                    <div>
                                                        <div style="font-weight:600;font-size:.82rem">${t.internName}</div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted);font-size:.8rem">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.8rem">
                                        <c:choose>
                                            <c:when test="${not empty t.dueDate}"><i class="bi bi-calendar3" style="margin-right:3px"></i>${t.dueDate}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="margin-bottom:6px">
                                            <c:choose>
                                                <c:when test="${t.status == 'COMPLETED'}"><span class="badge badge-done"><i class="bi bi-check2-all" style="font-size:.7rem"></i>Đã hoàn thành</span></c:when>
                                                <c:when test="${t.status == 'IN_PROGRESS'}"><span class="badge badge-inprog"><i class="bi bi-arrow-repeat" style="font-size:.7rem"></i>Đang làm</span></c:when>
                                                <c:otherwise><span class="badge badge-todo"><i class="bi bi-clock" style="font-size:.7rem"></i>Chờ thực hiện</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="progress-wrap">
                                            <div class="progress-bar-outer">
                                                <div class="progress-bar-inner"
                                                     style="width:${t.progress}%; background:${t.status == 'COMPLETED' ? 'linear-gradient(90deg, #10b981, #34d399)' : (t.status == 'IN_PROGRESS' ? 'linear-gradient(90deg, #0891b2, #22d3ee)' : '#cbd5e1')}"></div>
                                            </div>
                                            <span class="progress-pct">${t.progress}%</span>
                                        </div>
                                    </td>

                                    <%-- Quick In-Place Update Form --%>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/edit" class="quick-update-form">
                                            <input type="hidden" name="id" value="${t.id}">
                                            <select name="status" class="quick-select" onchange="syncRowProgress(${t.id}, this.value)">
                                                <option value="TODO"        ${t.status == 'TODO'        ? 'selected' : ''}>Chờ thực hiện</option>
                                                <option value="IN_PROGRESS" ${t.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang làm</option>
                                                <option value="COMPLETED"   ${t.status == 'COMPLETED'   ? 'selected' : ''}>Đã hoàn thành</option>
                                            </select>
                                            <input type="range" name="progress" min="0" max="100" step="5"
                                                   value="${t.progress}" class="quick-range" id="rowRange-${t.id}"
                                                   oninput="document.getElementById('rowVal-${t.id}').textContent=this.value+'%'">
                                            <span id="rowVal-${t.id}" style="font-size:.75rem;font-weight:700;color:var(--task-col);min-width:32px">${t.progress}%</span>
                                            <button type="submit" class="btn-save-quick" title="Lưu cập nhật nhanh tiến độ">
                                                <i class="bi bi-floppy"></i> Lưu
                                            </button>
                                        </form>
                                    </td>

                                    <%-- Thao tác: Sửa chi tiết & Xóa --%>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?id=${t.id}"
                                               class="btn-icon edit" title="Chỉnh sửa toàn bộ thông tin">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/delete"
                                                  style="display:inline" onsubmit="return confirm('Xóa nhiệm vụ #${t.id}: ${t.title}?')">
                                                <input type="hidden" name="id" value="${t.id}">
                                                <button type="submit" class="btn-icon delete" title="Xóa nhiệm vụ">
                                                    <i class="bi bi-trash"></i>
                                                </button>
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

<!-- Add Task Modal -->
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
                                <option value="${i.id}">${not empty i.studentCode ? i.studentCode.concat(' — ') : ''}${not empty i.fullName ? i.fullName : i.email}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái *</label>
                        <select name="status" class="form-select">
                            <option value="TODO" selected>Chờ thực hiện</option>
                            <option value="IN_PROGRESS">Đang làm</option>
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

    function syncDetailStatus(status) {
        var range = document.getElementById('detailRange');
        if (!range) return;
        if (status === 'COMPLETED') {
            range.value = 100;
        } else if (status === 'TODO') {
            range.value = 0;
        } else if (status === 'IN_PROGRESS' && parseInt(range.value) === 0) {
            range.value = 25;
        }
        document.getElementById('detailVal').textContent = range.value + '%';
    }

    function syncRowProgress(taskId, status) {
        var range = document.getElementById('rowRange-' + taskId);
        var valSpan = document.getElementById('rowVal-' + taskId);
        if (!range || !valSpan) return;
        if (status === 'COMPLETED') {
            range.value = 100;
        } else if (status === 'TODO') {
            range.value = 0;
        } else if (status === 'IN_PROGRESS' && parseInt(range.value) === 0) {
            range.value = 25;
        }
        valSpan.textContent = range.value + '%';
    }
</script>
</body>
</html>
