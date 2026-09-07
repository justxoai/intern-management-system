<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Nhiệm vụ của tôi — Cổng TTS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px; --sidebar-bg: #1a0a3d;
            --accent: #8b5cf6; --accent2: #7c3aed;
            --page-bg: #f5f3ff; --card-bg: #fff;
            --text-primary: #0f172a; --text-muted: #64748b; --border: #e2e8f0;
            --todo-col: #64748b; --progress-col: #f59e0b; --done-col: #10b981;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(139,92,246,.25); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub   { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* Alert */
        .alert { padding: 12px 18px; border-radius: 10px; font-size: .85rem; font-weight: 500; margin-bottom: 18px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: #f0fdf4; border: 1px solid #86efac; color: #15803d; }

        /* Stats strip */
        .stats-strip { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 22px; }
        .stat-pill { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 16px 18px; display: flex; align-items: center; gap: 12px; box-shadow: 0 1px 4px rgba(0,0,0,.05); }
        .stat-pill-icon { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
        .sp-all      { background: #f5f3ff; color: var(--accent); }
        .sp-todo     { background: #f1f5f9; color: var(--todo-col); }
        .sp-progress { background: #fefce8; color: var(--progress-col); }
        .sp-done     { background: #f0fdf4; color: var(--done-col); }
        .stat-pill-num { font-size: 1.5rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-pill-lbl { font-size: .73rem; color: var(--text-muted); font-weight: 500; }

        /* Filter tabs */
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
        .tab-btn { padding: 7px 18px; border-radius: 20px; border: 1.5px solid var(--border); background: #fff; font-family: 'Inter', sans-serif; font-size: .82rem; font-weight: 600; cursor: pointer; text-decoration: none; color: var(--text-muted); transition: all .15s; }
        .tab-btn:hover, .tab-btn.active { border-color: var(--accent); color: var(--accent); background: #f5f3ff; }

        /* Task cards */
        .task-list { display: flex; flex-direction: column; gap: 14px; }
        .task-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); transition: box-shadow .2s; }
        .task-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.10); }
        .task-card.border-todo     { border-left: 4px solid var(--todo-col); }
        .task-card.border-progress { border-left: 4px solid var(--progress-col); }
        .task-card.border-done     { border-left: 4px solid var(--done-col); }

        .task-header { padding: 16px 20px; display: flex; align-items: flex-start; gap: 14px; }
        .task-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
        .ti-todo     { background: #f1f5f9; color: var(--todo-col); }
        .ti-progress { background: #fefce8; color: var(--progress-col); }
        .ti-done     { background: #f0fdf4; color: var(--done-col); }

        .task-title { font-weight: 700; font-size: .95rem; color: var(--text-primary); line-height: 1.3; }
        .task-desc  { font-size: .82rem; color: var(--text-muted); margin-top: 4px; line-height: 1.5; }
        .task-meta  { display: flex; align-items: center; gap: 14px; margin-top: 8px; }
        .task-meta-item { display: flex; align-items: center; gap: 5px; font-size: .75rem; color: var(--text-muted); }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-todo     { background: #f1f5f9; color: var(--todo-col); }
        .badge-progress { background: #fefce8; color: #a16207; border: 1px solid #fde68a; }
        .badge-done     { background: #f0fdf4; color: #16a34a; border: 1px solid #86efac; }

        /* Progress bar */
        .task-progress-wrap { padding: 0 20px 10px; }
        .progress-track { background: #f1f5f9; border-radius: 999px; height: 7px; overflow: hidden; }
        .progress-fill  { height: 100%; border-radius: 999px; background: linear-gradient(90deg, #8b5cf6, #a78bfa); transition: width .4s; }
        .progress-fill.done { background: linear-gradient(90deg, #10b981, #34d399); }
        .progress-fill.inprog { background: linear-gradient(90deg, #f59e0b, #fbbf24); }

        /* Update form */
        .task-update { padding: 14px 20px; background: #f8fafc; border-top: 1px solid var(--border); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .update-label { font-size: .75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; white-space: nowrap; }
        .status-select, .progress-range { border: 1.5px solid var(--border); border-radius: 8px; background: #fff; font-family: 'Inter', sans-serif; font-size: .82rem; color: var(--text-primary); outline: none; padding: 6px 10px; transition: border-color .2s; }
        .status-select:focus, .progress-range:focus { border-color: var(--accent); }
        .progress-range { -webkit-appearance: none; height: 6px; cursor: pointer; border: none; background: transparent; padding: 0; }
        .progress-range::-webkit-slider-thumb { -webkit-appearance: none; width: 16px; height: 16px; border-radius: 50%; background: var(--accent); cursor: pointer; }
        .progress-range::-webkit-slider-runnable-track { background: linear-gradient(90deg, var(--accent) var(--pct, 0%), #e2e8f0 var(--pct, 0%)); height: 6px; border-radius: 999px; }
        .progress-val { font-size: .82rem; font-weight: 700; color: var(--accent); min-width: 38px; }
        .btn-update { padding: 7px 18px; border-radius: 8px; border: none; background: var(--accent); color: #fff; font-family: 'Inter', sans-serif; font-size: .8rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 5px; transition: opacity .15s, transform .15s; }
        .btn-update:hover { opacity: .85; transform: translateY(-1px); }
        .btn-update:active { transform: translateY(0); }

        .empty-state { text-align: center; padding: 56px 24px; background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); }
        .empty-state i { font-size: 2.5rem; color: #c4b5fd; display: block; margin-bottom: 14px; }
        .empty-state p { color: var(--text-muted); font-size: .9rem; }
    </style>
</head>
<body>

<%-- ── Sidebar ── --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
        <h1>Cổng thông tin<br>Thực tập sinh</h1>
        <span>Không gian làm việc</span>
    </div>
    <div class="sidebar-section-label">Không gian của tôi</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/intern/documents">
            <i class="bi bi-folder2-open"></i> Tài liệu của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/contracts">
            <i class="bi bi-file-earmark-check"></i> Hợp đồng của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/tasks" class="active">
            <i class="bi bi-list-task"></i> Nhiệm vụ của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/reports">
            <i class="bi bi-journal-text"></i> Báo cáo tuần
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Thực tập sinh</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<%-- ── Main ── --%>
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Nhiệm vụ của tôi</div>
            <div class="page-sub">Theo dõi nhiệm vụ được giao và cập nhật tiến độ</div>
        </div>
        <c:if test="${not empty intern}">
            <span style="background:#f5f3ff;color:#7c3aed;border-radius:20px;padding:6px 14px;font-size:.8rem;font-weight:600;border:1px solid #ddd6fe">
                <i class="bi bi-person-workspace" style="margin-right:4px"></i>${intern.fullName}
            </span>
        </c:if>
    </div>

    <div class="content">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i>${param.success}</div>
        </c:if>

        <%-- Stats strip --%>
        <c:set var="todoCount" value="0"/>
        <c:set var="progressCount" value="0"/>
        <c:set var="doneCount" value="0"/>
        <%-- Need all tasks for stats, use a separate unfiltered count trick: count from request attr --%>
        <c:forEach var="t" items="${tasks}">
            <c:choose>
                <c:when test="${t.status == 'TODO'}"><c:set var="todoCount" value="${todoCount + 1}"/></c:when>
                <c:when test="${t.status == 'IN_PROGRESS'}"><c:set var="progressCount" value="${progressCount + 1}"/></c:when>
                <c:when test="${t.status == 'COMPLETED'}"><c:set var="doneCount" value="${doneCount + 1}"/></c:when>
            </c:choose>
        </c:forEach>
        <div class="stats-strip">
            <div class="stat-pill">
                <div class="stat-pill-icon sp-all"><i class="bi bi-list-task"></i></div>
                <div>
                    <div class="stat-pill-num">${fn:length(tasks)}</div>
                    <div class="stat-pill-lbl">Tổng nhiệm vụ</div>
                </div>
            </div>
            <div class="stat-pill">
                <div class="stat-pill-icon sp-todo"><i class="bi bi-circle"></i></div>
                <div>
                    <div class="stat-pill-num">${todoCount}</div>
                    <div class="stat-pill-lbl">Chờ thực hiện</div>
                </div>
            </div>
            <div class="stat-pill">
                <div class="stat-pill-icon sp-progress"><i class="bi bi-arrow-clockwise"></i></div>
                <div>
                    <div class="stat-pill-num">${progressCount}</div>
                    <div class="stat-pill-lbl">Đang làm</div>
                </div>
            </div>
            <div class="stat-pill">
                <div class="stat-pill-icon sp-done"><i class="bi bi-check-circle"></i></div>
                <div>
                    <div class="stat-pill-num">${doneCount}</div>
                    <div class="stat-pill-lbl">Đã hoàn thành</div>
                </div>
            </div>
        </div>

        <%-- Filter tabs --%>
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/intern/tasks"
               class="tab-btn ${empty statusFilter ? 'active' : ''}">Tất cả</a>
            <a href="${pageContext.request.contextPath}/intern/tasks?status=TODO"
               class="tab-btn ${statusFilter == 'TODO' ? 'active' : ''}">
                <i class="bi bi-circle"></i> Chờ thực hiện
            </a>
            <a href="${pageContext.request.contextPath}/intern/tasks?status=IN_PROGRESS"
               class="tab-btn ${statusFilter == 'IN_PROGRESS' ? 'active' : ''}">
                <i class="bi bi-arrow-clockwise"></i> Đang làm
            </a>
            <a href="${pageContext.request.contextPath}/intern/tasks?status=COMPLETED"
               class="tab-btn ${statusFilter == 'COMPLETED' ? 'active' : ''}">
                <i class="bi bi-check-circle"></i> Đã hoàn thành
            </a>
        </div>

        <%-- Task list --%>
        <c:choose>
            <c:when test="${empty tasks}">
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <p>Chưa có nhiệm vụ nào. Mentor sẽ giao việc cho bạn khi kỳ thực tập bắt đầu.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="task-list">
                    <c:forEach var="task" items="${tasks}" varStatus="st">
                        <c:set var="cardClass" value="${task.status == 'COMPLETED' ? 'border-done' : (task.status == 'IN_PROGRESS' ? 'border-progress' : 'border-todo')}"/>
                        <c:set var="iconClass" value="${task.status == 'COMPLETED' ? 'ti-done' : (task.status == 'IN_PROGRESS' ? 'ti-progress' : 'ti-todo')}"/>
                        <c:set var="iconName"  value="${task.status == 'COMPLETED' ? 'bi-check2-circle' : (task.status == 'IN_PROGRESS' ? 'bi-arrow-clockwise' : 'bi-circle')}"/>
                        <c:set var="badgeClass" value="${task.status == 'COMPLETED' ? 'badge-done' : (task.status == 'IN_PROGRESS' ? 'badge-progress' : 'badge-todo')}"/>
                        <c:set var="fillClass"  value="${task.status == 'COMPLETED' ? 'done' : (task.status == 'IN_PROGRESS' ? 'inprog' : '')}"/>

                        <div class="task-card ${cardClass}">
                            <div class="task-header">
                                <div class="task-icon ${iconClass}">
                                    <i class="bi ${iconName}"></i>
                                </div>
                                <div style="flex:1;min-width:0">
                                    <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap">
                                        <div class="task-title">${task.title}</div>
                                        <span class="badge ${badgeClass}">${task.status == 'COMPLETED' ? 'Đã hoàn thành' : (task.status == 'IN_PROGRESS' ? 'Đang làm' : 'Chờ thực hiện')}</span>
                                    </div>
                                    <c:if test="${not empty task.description}">
                                        <div class="task-desc">${task.description}</div>
                                    </c:if>
                                    <div class="task-meta">
                                        <c:if test="${not empty task.mentorName}">
                                            <span class="task-meta-item">
                                                <i class="bi bi-mortarboard"></i> ${task.mentorName}
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty task.dueDate}">
                                            <span class="task-meta-item">
                                                <i class="bi bi-calendar3"></i> Hạn nộp: ${task.dueDate}
                                            </span>
                                        </c:if>
                                        <span class="task-meta-item">
                                            <i class="bi bi-bar-chart"></i> ${task.progress}% hoàn thành
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <%-- Progress bar --%>
                            <div class="task-progress-wrap">
                                <div class="progress-track">
                                    <div class="progress-fill ${fillClass}" style="width:${task.progress}%"></div>
                                </div>
                            </div>

                            <%-- Update form (only if not completed) --%>
                            <c:if test="${task.status != 'COMPLETED'}">
                                <div class="task-update" id="update-${task.id}">
                                    <span class="update-label"><i class="bi bi-pencil"></i> Cập nhật:</span>
                                    <form method="post" action="${pageContext.request.contextPath}/intern/tasks/update"
                                          style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;flex:1">
                                        <input type="hidden" name="taskId" value="${task.id}">
                                        <select name="status" class="status-select" id="sel-${task.id}"
                                                onchange="syncProgress(${task.id}, this.value)">
                                            <option value="TODO"        ${task.status == 'TODO'        ? 'selected' : ''}>📋 Chờ thực hiện</option>
                                            <option value="IN_PROGRESS" ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>⏳ Đang làm</option>
                                            <option value="COMPLETED"                                                    >✅ Đã hoàn thành</option>
                                        </select>
                                        <span class="update-label">Tiến độ:</span>
                                        <input type="range" name="progress" min="0" max="100" step="5"
                                               value="${task.progress}" class="progress-range"
                                               id="range-${task.id}"
                                               oninput="updateVal(${task.id}, this.value)"
                                               style="width:120px">
                                        <span class="progress-val" id="val-${task.id}">${task.progress}%</span>
                                        <button type="submit" class="btn-update">
                                            <i class="bi bi-floppy"></i> Lưu
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                            <c:if test="${task.status == 'COMPLETED'}">
                                <div style="padding:10px 20px;background:#f0fdf4;border-top:1px solid #bbf7d0;display:flex;align-items:center;justify-content:space-between;font-size:.78rem;color:#15803d;font-weight:600">
                                    <span><i class="bi bi-check-circle-fill" style="margin-right:5px"></i>Nhiệm vụ đã hoàn thành</span>
                                    <button type="button" onclick="document.getElementById('update-${task.id}').style.display='flex';this.parentElement.style.display='none';" style="background:none;border:none;color:#059669;cursor:pointer;font-size:.75rem;font-weight:600;text-decoration:underline">
                                        <i class="bi bi-pencil"></i> Chỉnh sửa lại
                                    </button>
                                </div>
                                <div class="task-update" id="update-${task.id}" style="display:none">
                                    <span class="update-label"><i class="bi bi-pencil"></i> Cập nhật:</span>
                                    <form method="post" action="${pageContext.request.contextPath}/intern/tasks/update"
                                          style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;flex:1">
                                        <input type="hidden" name="taskId" value="${task.id}">
                                        <select name="status" class="status-select" id="sel-${task.id}"
                                                onchange="syncProgress(${task.id}, this.value)">
                                            <option value="TODO">📋 Chờ thực hiện</option>
                                            <option value="IN_PROGRESS">⏳ Đang làm</option>
                                            <option value="COMPLETED" selected>✅ Đã hoàn thành</option>
                                        </select>
                                        <span class="update-label">Tiến độ:</span>
                                        <input type="range" name="progress" min="0" max="100" step="5"
                                               value="${task.progress}" class="progress-range"
                                               id="range-${task.id}"
                                               oninput="updateVal(${task.id}, this.value)"
                                               style="width:120px">
                                        <span class="progress-val" id="val-${task.id}">${task.progress}%</span>
                                        <button type="submit" class="btn-update">
                                            <i class="bi bi-floppy"></i> Lưu
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function updateVal(id, val) {
        document.getElementById('val-' + id).textContent = val + '%';
        var range = document.getElementById('range-' + id);
        range.style.setProperty('--pct', val + '%');
    }
    function syncProgress(id, status) {
        var range = document.getElementById('range-' + id);
        if (!range) return;
        if (status === 'COMPLETED') { range.value = 100; updateVal(id, 100); }
        else if (status === 'TODO') { range.value = 0; updateVal(id, 0); }
        else if (status === 'IN_PROGRESS' && parseInt(range.value) === 0) { range.value = 25; updateVal(id, 25); }
    }
    // Init range colors on load
    document.querySelectorAll('.progress-range').forEach(function(r) {
        r.style.setProperty('--pct', r.value + '%');
    });
</script>
</body>
</html>
