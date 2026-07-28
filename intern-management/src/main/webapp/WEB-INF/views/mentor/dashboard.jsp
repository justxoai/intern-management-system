<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mentor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; }
        .topbar { background: linear-gradient(135deg, #145222 0%, #198754 100%); padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 12px rgba(0,0,0,0.15); }
        .topbar-title { color: #fff; font-size: 1.25rem; font-weight: 700; }
        .page-heading { font-size: 1.6rem; font-weight: 700; color: #145222; }

        .section-card { border-radius: 14px; border: none; box-shadow: 0 2px 16px rgba(0,0,0,0.08); margin-bottom: 28px; overflow: hidden; }
        .section-header { padding: 14px 22px; display: flex; align-items: center; justify-content: space-between; }
        .sh-intern { background: linear-gradient(90deg, #6f42c1, #9b72e6); }
        .sh-task   { background: linear-gradient(90deg, #0891b2, #22d3ee); }
        .section-title { color: #fff; font-size: 1rem; font-weight: 600; }
        .count-badge { background: rgba(255,255,255,.25); color: #fff; border-radius: 20px; padding: 2px 10px; font-size: .8rem; font-weight: 600; }

        .filter-bar { background: #f8f9fa; padding: 14px 22px; border-bottom: 1px solid #e9ecef; }
        .filter-label { font-size: .72rem; font-weight: 700; color: #6c757d; text-transform: uppercase; margin-bottom: 3px; }

        .user-table { margin: 0; }
        .user-table thead th { font-size: .73rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: #495057; border: none; padding: 10px 14px; background: #f1f3f5; }
        .user-table tbody td { padding: 11px 14px; vertical-align: middle; font-size: .87rem; border-color: #f1f3f5; }
        .user-table tbody tr:hover { background: #f8f9ff; }

        .status-todo       { background: #f1f5f9; color: #475569; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-inprogress { background: #fef9c3; color: #92400e; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-done       { background: #dcfce7; color: #14532d; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-pending    { background: #fef9c3; color: #92400e; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-approved   { background: #dcfce7; color: #14532d; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-interning  { background: #dbeafe; color: #1e40af; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-completed  { background: #ede9fe; color: #4c1d95; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }

        .btn-action { font-size: .78rem; padding: 4px 11px; }

        /* Add Task modal */
        .modal-header-task { background: linear-gradient(90deg, #0891b2, #22d3ee); color: #fff; }
    </style>
</head>
<body>

<!-- Top Bar -->
<div class="topbar">
    <span class="topbar-title"><i class="bi bi-mortarboard-fill me-2"></i>Mentor Portal</span>
    <span style="color:rgba(255,255,255,.85); font-size:.88rem;">
        <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.fullName}
        &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/logout" class="text-white" style="opacity:.8">Logout</a>
    </span>
</div>

<div class="container-lg py-4">
    <div class="mb-4">
        <h1 class="page-heading mb-0"><i class="bi bi-clipboard-data me-2"></i>Intern Management</h1>
        <small class="text-muted">Your assigned interns and their task assignments</small>
    </div>

    <%-- Success/Error flash --%>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${param.msg} <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- ==================== MY INTERNS SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header sh-intern">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-people text-white fs-5"></i>
                <span class="section-title">My Interns</span>
                <span class="count-badge">${fn:length(myInterns)}</span>
            </div>
        </div>

        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/mentor/dashboard">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <div class="filter-label">Search (Code / Name / Email)</div>
                    <input type="text" class="form-control form-control-sm" name="internKeyword" value="${internKeyword}" placeholder="Search intern...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Task Status Filter</div>
                    <select class="form-select form-select-sm" name="taskStatus">
                        <option value="">All Tasks</option>
                        <option value="TODO"        ${taskStatus == 'TODO'        ? 'selected' : ''}>TODO</option>
                        <option value="IN_PROGRESS" ${taskStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                        <option value="DONE"        ${taskStatus == 'DONE'        ? 'selected' : ''}>DONE</option>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-sm px-3" style="background:#6f42c1;color:#fff"><i class="bi bi-search me-1"></i>Filter</button>
                    <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table user-table">
                <thead><tr>
                    <th>Code</th><th>Full Name</th><th>University</th><th>Major</th><th>Email</th><th>Intern Status</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty myInterns}">
                            <tr><td colspan="6" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No interns assigned to you yet.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${myInterns}">
                                <tr>
                                    <td><code>${i.studentCode}</code></td>
                                    <td><strong>${i.fullName != null ? i.fullName : '-'}</strong></td>
                                    <td>${i.university}</td>
                                    <td>${i.major}</td>
                                    <td>${i.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.status == 'APPROVED'}"><span class="status-approved">APPROVED</span></c:when>
                                            <c:when test="${i.status == 'INTERNING'}"><span class="status-interning">INTERNING</span></c:when>
                                            <c:when test="${i.status == 'COMPLETED'}"><span class="status-completed">COMPLETED</span></c:when>
                                            <c:otherwise><span class="status-pending">${i.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ==================== TASKS SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header sh-task">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-list-task text-white fs-5"></i>
                <span class="section-title">Task Assignment</span>
                <span class="count-badge">${fn:length(tasks)}</span>
            </div>
            <button type="button" class="btn btn-light btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                <i class="bi bi-plus-lg me-1"></i>Assign Task
            </button>
        </div>

        <div class="table-responsive">
            <table class="table user-table">
                <thead><tr>
                    <th>Title</th><th>Assigned Intern</th><th>Status</th><th>Due Date</th><th>Created</th><th class="text-center">Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <tr><td colspan="6" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No tasks assigned yet. Click "Assign Task" to start.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="t" items="${tasks}">
                                <tr>
                                    <td><strong>${t.title}</strong>
                                        <c:if test="${not empty t.description}">
                                            <div class="text-muted" style="font-size:.78rem;">${t.description}</div>
                                        </c:if>
                                    </td>
                                    <td>${not empty t.internName ? t.internName : '-'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'DONE'}"><span class="status-done">DONE</span></c:when>
                                            <c:when test="${t.status == 'IN_PROGRESS'}"><span class="status-inprogress">IN PROGRESS</span></c:when>
                                            <c:otherwise><span class="status-todo">TODO</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${t.dueDate != null ? t.dueDate : '-'}</td>
                                    <td>${t.createdAt}</td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit?id=${t.id}"
                                           class="btn btn-outline-primary btn-action me-1">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/delete" class="d-inline"
                                              onsubmit="return confirm('Delete task: ${t.title}?')">
                                            <input type="hidden" name="id" value="${t.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-action">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </form>
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
<div class="modal fade" id="addTaskModal" tabindex="-1" aria-labelledby="addTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header modal-header-task">
                <h5 class="modal-title" id="addTaskModalLabel"><i class="bi bi-plus-circle me-2"></i>Assign New Task</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/create">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Task Title <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="e.g. Complete API Integration">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Task details..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Assign to Intern <span class="text-danger">*</span></label>
                            <select name="internId" class="form-select" required>
                                <option value="">-- Select Intern --</option>
                                <c:forEach var="i" items="${allMyInterns}">
                                    <option value="${i.id}">${i.studentCode} - ${i.fullName != null ? i.fullName : i.email}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold">Status</label>
                            <select name="status" class="form-select">
                                <option value="TODO">TODO</option>
                                <option value="IN_PROGRESS">IN PROGRESS</option>
                                <option value="DONE">DONE</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold">Due Date</label>
                            <input type="date" name="dueDate" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Assign Task</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
