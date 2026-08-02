<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>User Information - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #1e3a5f;
            --accent:  #2d6bcf;
            --hr-color:     #0d6efd;
            --mentor-color: #198754;
            --intern-color: #6f42c1;
        }
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; }

        /* Top bar */
        .topbar {
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            padding: 18px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 12px rgba(0,0,0,0.15);
        }
        .topbar-title { color: #fff; font-size: 1.3rem; font-weight: 700; letter-spacing: .5px; }
        .topbar-user { color: rgba(255,255,255,.85); font-size: .9rem; }

        /* Page heading */
        .page-heading { font-size: 1.6rem; font-weight: 700; color: var(--primary); }

        /* Section card */
        .section-card {
            border-radius: 14px;
            border: none;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
            margin-bottom: 28px;
            overflow: hidden;
        }
        .section-header {
            padding: 14px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,.2);
        }
        .section-header-hr     { background: linear-gradient(90deg, #0d6efd, #4d94ff); }
        .section-header-mentor { background: linear-gradient(90deg, #198754, #28c76f); }
        .section-header-intern { background: linear-gradient(90deg, #6f42c1, #9b72e6); }
        .section-title { color: #fff; font-size: 1rem; font-weight: 600; letter-spacing: .3px; }

        /* Filter bar */
        .filter-bar { background: #f8f9fa; padding: 14px 22px; border-bottom: 1px solid #e9ecef; }
        .filter-bar .form-control,
        .filter-bar .form-select { font-size: .82rem; }
        .filter-label { font-size: .75rem; font-weight: 600; color: #6c757d; text-transform: uppercase; margin-bottom: 3px; }

        /* Table */
        .user-table { margin: 0; }
        .user-table thead tr { background: #f1f3f5; }
        .user-table thead th {
            font-size: .75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .6px;
            color: #495057;
            border: none;
            padding: 10px 14px;
        }
        .user-table tbody td { padding: 11px 14px; vertical-align: middle; font-size: .87rem; border-color: #f1f3f5; }
        .user-table tbody tr:hover { background: #f8f9ff; }

        .badge-role { font-size: .72rem; padding: 4px 10px; border-radius: 20px; font-weight: 600; }
        .badge-active   { background: #d1fae5; color: #065f46; }
        .badge-inactive { background: #fee2e2; color: #991b1b; }

        .btn-edit   { font-size: .78rem; padding: 4px 12px; }
        .btn-delete { font-size: .78rem; padding: 4px 12px; }

        /* Count badge */
        .count-badge { background: rgba(255,255,255,.25); color: #fff; border-radius: 20px; padding: 2px 10px; font-size: .8rem; font-weight: 600; }
    </style>
</head>
<body>

<!-- Top Bar -->
<div class="topbar">
    <span class="topbar-title"><i class="bi bi-shield-check me-2"></i>Internship Management System — Admin</span>
    <span class="topbar-user">
        <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.fullName}
        &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/logout" class="text-white text-decoration-underline" style="opacity:.8">Logout</a>
    </span>
</div>

<div class="container-lg py-4">

    <!-- Page Heading -->
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h1 class="page-heading mb-0"><i class="bi bi-people me-2" style="color:var(--accent)"></i>User Information</h1>
    </div>

    <%-- ==================== HR SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header section-header-hr">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-person-badge text-white fs-5"></i>
                <span class="section-title">Human Resources (HR)</span>
                <span class="count-badge">${fn:length(hrUsers)}</span>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/create?role=HR"
               class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-plus-lg me-1"></i>Add HR
            </a>
        </div>

        <!-- HR Filter -->
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users" id="hrFilterForm">
            <input type="hidden" name="activeTab" value="hr">
            <div class="row g-2 align-items-end">
                <div class="col-md-2">
                    <div class="filter-label">ID</div>
                    <input type="text" class="form-control form-control-sm" name="hrId" value="${hrId}" placeholder="e.g. 1">
                </div>
                <div class="col-md-3">
                    <div class="filter-label">Name</div>
                    <input type="text" class="form-control form-control-sm" name="hrName" value="${hrName}" placeholder="Full name...">
                </div>
                <div class="col-md-3">
                    <div class="filter-label">Email</div>
                    <input type="text" class="form-control form-control-sm" name="hrEmail" value="${hrEmail}" placeholder="email@...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Phone</div>
                    <input type="text" class="form-control form-control-sm" name="hrPhone" value="${hrPhone}" placeholder="090...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Status</div>
                    <select class="form-select form-select-sm" name="hrStatus">
                        <option value="">All</option>
                        <option value="ACTIVE"   ${hrStatus == 'ACTIVE'   ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${hrStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm px-3">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <!-- HR Table -->
        <div class="table-responsive">
            <table class="table user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Created At</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty hrUsers}">
                            <tr><td colspan="7" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No HR accounts found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${hrUsers}">
                                <tr>
                                    <td><span class="text-muted">#${u.id}</span></td>
                                    <td><strong>${u.fullName}</strong></td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active">Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive">${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${u.createdAt}</td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn btn-outline-primary btn-edit me-1">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" class="d-inline"
                                              onsubmit="return confirm('Delete HR account ${u.fullName}?')">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-delete">
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

    <%-- ==================== MENTOR SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header section-header-mentor">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-mortarboard text-white fs-5"></i>
                <span class="section-title">Mentors</span>
                <span class="count-badge">${fn:length(mentorUsers)}</span>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/create?role=MENTOR"
               class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-plus-lg me-1"></i>Add Mentor
            </a>
        </div>

        <!-- Mentor Filter -->
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users" id="mentorFilterForm">
            <input type="hidden" name="activeTab" value="mentor">
            <div class="row g-2 align-items-end">
                <div class="col-md-2">
                    <div class="filter-label">ID</div>
                    <input type="text" class="form-control form-control-sm" name="mentorId" value="${mentorId}" placeholder="e.g. 1">
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
                    <button type="submit" class="btn btn-success btn-sm px-3">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <!-- Mentor Table -->
        <div class="table-responsive">
            <table class="table user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Created At</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty mentorUsers}">
                            <tr><td colspan="7" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No Mentor accounts found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${mentorUsers}">
                                <tr>
                                    <td><span class="text-muted">#${u.id}</span></td>
                                    <td><strong>${u.fullName}</strong></td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active">Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive">${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${u.createdAt}</td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn btn-outline-primary btn-edit me-1">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" class="d-inline"
                                              onsubmit="return confirm('Delete Mentor account ${u.fullName}?')">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-delete">
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

    <%-- ==================== INTERN SECTION ==================== --%>
    <div class="section-card">
        <div class="section-header section-header-intern">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-person-workspace text-white fs-5"></i>
                <span class="section-title">Interns</span>
                <span class="count-badge">${fn:length(internUsers)}</span>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/create?role=INTERN"
               class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-plus-lg me-1"></i>Add Intern
            </a>
        </div>

        <!-- Intern Filter -->
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/users" id="internFilterForm">
            <input type="hidden" name="activeTab" value="intern">
            <div class="row g-2 align-items-end">
                <div class="col-md-2">
                    <div class="filter-label">ID / Code</div>
                    <input type="text" class="form-control form-control-sm" name="internId" value="${internId}" placeholder="ID or code...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Name</div>
                    <input type="text" class="form-control form-control-sm" name="internName" value="${internName}" placeholder="Full name...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Email</div>
                    <input type="text" class="form-control form-control-sm" name="internEmail" value="${internEmail}" placeholder="email@...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Phone</div>
                    <input type="text" class="form-control form-control-sm" name="internPhone" value="${internPhone}" placeholder="090...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">Major / Business</div>
                    <input type="text" class="form-control form-control-sm" name="internMajor" value="${internMajor}" placeholder="Major...">
                </div>
                <div class="col-md-2">
                    <div class="filter-label">University</div>
                    <input type="text" class="form-control form-control-sm" name="internUniversity" value="${internUniversity}" placeholder="University...">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-sm px-3" style="background:#6f42c1;color:#fff">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm ms-1">Clear</a>
                </div>
            </div>
        </form>

        <!-- Intern Table -->
        <div class="table-responsive">
            <table class="table user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Code</th>
                        <th>Full Name</th>
                        <th>Major</th>
                        <th>University</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty internUsers}">
                            <tr><td colspan="9" class="text-center text-muted py-4"><i class="bi bi-inbox me-2"></i>No Intern accounts found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${internUsers}">
                                <tr>
                                    <td><span class="text-muted">#${u.id}</span></td>
                                    <td><code>${not empty u.studentCode ? u.studentCode : 'N/A'}</code></td>
                                    <td><strong>${u.fullName}</strong></td>
                                    <td>${not empty u.major ? u.major : 'N/A'}</td>
                                    <td>${not empty u.university ? u.university : 'N/A'}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge badge-active">Active</span></c:when>
                                            <c:otherwise><span class="badge badge-inactive">${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn btn-outline-primary btn-edit me-1">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" class="d-inline"
                                              onsubmit="return confirm('Delete Intern account ${u.fullName}?')">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-delete">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
