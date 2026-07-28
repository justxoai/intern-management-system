<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Human Resource Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --hr-primary: #0d6efd;
            --mentor-primary: #198754;
        }
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; }

        .topbar {
            background: linear-gradient(135deg, #0a4a9f 0%, #1565c0 100%);
            padding: 16px 32px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 2px 12px rgba(0,0,0,0.15);
        }
        .topbar-title { color: #fff; font-size: 1.25rem; font-weight: 700; }
        .page-heading { font-size: 1.6rem; font-weight: 700; color: #0a4a9f; }

        .section-card { border-radius: 14px; border: none; box-shadow: 0 2px 16px rgba(0,0,0,0.08); margin-bottom: 28px; overflow: hidden; }
        .section-header { padding: 14px 22px; display: flex; align-items: center; justify-content: space-between; }
        .sh-intern  { background: linear-gradient(90deg, #0d6efd, #4d94ff); }
        .sh-mentor  { background: linear-gradient(90deg, #198754, #28c76f); }
        .section-title { color: #fff; font-size: 1rem; font-weight: 600; }
        .count-badge { background: rgba(255,255,255,.25); color: #fff; border-radius: 20px; padding: 2px 10px; font-size: .8rem; font-weight: 600; }

        .filter-bar { background: #f8f9fa; padding: 14px 22px; border-bottom: 1px solid #e9ecef; }
        .filter-label { font-size: .72rem; font-weight: 700; color: #6c757d; text-transform: uppercase; margin-bottom: 3px; }

        .user-table { margin: 0; }
        .user-table thead tr { background: #f1f3f5; }
        .user-table thead th { font-size: .73rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: #495057; border: none; padding: 10px 14px; }
        .user-table tbody td { padding: 11px 14px; vertical-align: middle; font-size: .87rem; border-color: #f1f3f5; }
        .user-table tbody tr:hover { background: #f0f8ff; }

        .badge-active   { background: #d1fae5; color: #065f46; font-size: .72rem; padding: 4px 9px; border-radius: 20px; font-weight: 600; }
        .badge-inactive { background: #fee2e2; color: #991b1b; font-size: .72rem; padding: 4px 9px; border-radius: 20px; font-weight: 600; }
        .status-pending   { background: #fef9c3; color: #92400e; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-approved  { background: #dcfce7; color: #14532d; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-interning { background: #dbeafe; color: #1e40af; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }
        .status-completed { background: #ede9fe; color: #4c1d95; font-size: .72rem; padding: 3px 9px; border-radius: 20px; font-weight: 600; }

        .btn-action { font-size: .78rem; padding: 4px 11px; }
    </style>
</head>
<body>

<!-- Top Bar -->
<div class="topbar">
    <span class="topbar-title"><i class="bi bi-people-fill me-2"></i>Human Resource System</span>
    <span style="color:rgba(255,255,255,.85); font-size:.88rem;">
        <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.fullName}
        &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/logout" class="text-white" style="opacity:.8">Logout</a>
    </span>
</div>

<div class="container-lg py-4">
    <div class="mb-4">
        <h1 class="page-heading mb-0"><i class="bi bi-building me-2"></i>Human Resource</h1>
        <small class="text-muted">Manage intern profiles and mentor assignments</small>
    </div>

    <%-- ==================== INTERN SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header sh-intern">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-person-workspace text-white fs-5"></i>
                <span class="section-title">Intern Management</span>
                <span class="count-badge">${fn:length(interns)}</span>
            </div>
            <a href="${pageContext.request.contextPath}/hr/interns/create" class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-plus-lg me-1"></i>Add Intern
            </a>
        </div>

        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/dashboard">
            <div class="row g-2 align-items-end">
                <div class="col-md-3">
                    <div class="filter-label">Keyword (Code / Name / Email)</div>
                    <input type="text" class="form-control form-control-sm" name="internKeyword" value="${internKeyword}" placeholder="Search...">
                </div>
                <div class="col-md-3">
                    <div class="filter-label">University</div>
                    <input type="text" class="form-control form-control-sm" name="internUniversity" value="${internUniversity}" placeholder="e.g. HUST">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Major</div>
                    <input type="text" class="form-control form-control-sm" name="internMajor" value="${internMajor}" placeholder="e.g. CS">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Status</div>
                    <select class="form-select form-select-sm" name="internStatus">
                        <option value="">All</option>
                        <option value="PENDING"   ${internStatus == 'PENDING'   ? 'selected' : ''}>PENDING</option>
                        <option value="APPROVED"  ${internStatus == 'APPROVED'  ? 'selected' : ''}>APPROVED</option>
                        <option value="INTERNING" ${internStatus == 'INTERNING' ? 'selected' : ''}>INTERNING</option>
                        <option value="COMPLETED" ${internStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm px-3"><i class="bi bi-search me-1"></i>Search</button>
                    <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table user-table">
                <thead><tr>
                    <th>Code</th><th>Full Name</th><th>University</th><th>Major</th>
                    <th>Email</th><th>Phone</th><th>Status</th><th class="text-center">Actions</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty interns}">
                            <tr><td colspan="8" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No intern profiles found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${interns}">
                                <tr>
                                    <td><code>${i.studentCode}</code></td>
                                    <td><strong>${i.fullName != null ? i.fullName : '-'}</strong></td>
                                    <td>${i.university}</td>
                                    <td>${i.major}</td>
                                    <td>${i.email}</td>
                                    <td>${i.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.status == 'APPROVED'}"><span class="status-approved">APPROVED</span></c:when>
                                            <c:when test="${i.status == 'INTERNING'}"><span class="status-interning">INTERNING</span></c:when>
                                            <c:when test="${i.status == 'COMPLETED'}"><span class="status-completed">COMPLETED</span></c:when>
                                            <c:otherwise><span class="status-pending">${i.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/hr/interns/edit?id=${i.id}" class="btn btn-outline-primary btn-action me-1">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/hr/interns/delete?id=${i.id}"
                                           class="btn btn-outline-danger btn-action"
                                           onclick="return confirm('Delete intern ${i.studentCode}?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ==================== MENTOR SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header sh-mentor">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-mortarboard text-white fs-5"></i>
                <span class="section-title">Mentor Management</span>
                <span class="count-badge">${fn:length(mentors)}</span>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/create?role=MENTOR" class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-plus-lg me-1"></i>Add Mentor
            </a>
        </div>

        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/dashboard">
            <div class="row g-2 align-items-end">
                <div class="col-md-2">
                    <div class="filter-label">ID</div>
                    <input type="text" class="form-control form-control-sm" name="mentorId" value="${mentorId}" placeholder="e.g. 3">
                </div>
                <div class="col-md-3">
                    <div class="filter-label">Name</div>
                    <input type="text" class="form-control form-control-sm" name="mentorName" value="${mentorName}" placeholder="Full name...">
                </div>
                <div class="col-md-3">
                    <div class="filter-label">Email</div>
                    <input type="text" class="form-control form-control-sm" name="mentorEmail" value="${mentorEmail}" placeholder="email@...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Phone</div>
                    <input type="text" class="form-control form-control-sm" name="mentorPhone" value="${mentorPhone}" placeholder="090...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Status</div>
                    <select class="form-select form-select-sm" name="mentorStatus">
                        <option value="">All</option>
                        <option value="ACTIVE"   ${mentorStatus == 'ACTIVE'   ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${mentorStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-success btn-sm px-3"><i class="bi bi-search me-1"></i>Search</button>
                    <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table user-table">
                <thead><tr>
                    <th>ID</th><th>Full Name</th><th>Email</th><th>Phone</th><th>Status</th><th>Created At</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty mentors}">
                            <tr><td colspan="6" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No mentors found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="m" items="${mentors}">
                                <tr>
                                    <td><span class="text-muted">#${m.id}</span></td>
                                    <td><strong>${m.fullName}</strong></td>
                                    <td>${m.email}</td>
                                    <td>${m.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.status == 'ACTIVE'}"><span class="badge-active">Active</span></c:when>
                                            <c:otherwise><span class="badge-inactive">${m.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${m.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
