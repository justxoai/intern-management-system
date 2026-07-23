<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Intern Profiles - HR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Intern Profiles</h2>
        <a href="${pageContext.request.contextPath}/hr/interns/create" class="btn btn-primary">+ Add Intern Profile</a>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/hr/interns" method="get" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold">Keyword</label>
                    <input type="text" name="keyword" class="form-control" placeholder="Code, Name, Email" value="${keyword}">
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">University</label>
                    <input type="text" name="university" class="form-control" placeholder="e.g. HUST" value="${university}">
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">Major</label>
                    <input type="text" name="major" class="form-control" placeholder="e.g. Computer Science" value="${major}">
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-bold">Status</label>
                    <select name="status" class="form-select">
                        <option value="">-- All --</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                        <option value="INTERNING" ${status == 'INTERNING' ? 'selected' : ''}>INTERNING</option>
                        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                    </select>
                </div>

                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-dark w-100">Search</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Intern Table List -->
    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Student Code</th>
                        <th>Full Name</th>
                        <th>University</th>
                        <th>Major</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${interns}">
                        <tr>
                            <td><strong>${item.studentCode}</strong></td>
                            <td>${item.fullName != null ? item.fullName : '-'}</td>
                            <td>${item.university}</td>
                            <td>${item.major}</td>
                            <td>${item.email}</td>
                            <td>${item.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.status == 'APPROVED'}">
                                        <span class="badge bg-success">APPROVED</span>
                                    </c:when>
                                    <c:when test="${item.status == 'INTERNING'}">
                                        <span class="badge bg-info text-dark">INTERNING</span>
                                    </c:when>
                                    <c:when test="${item.status == 'COMPLETED'}">
                                        <span class="badge bg-primary">COMPLETED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark">${item.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/hr/interns/edit?id=${item.id}" class="btn btn-sm btn-outline-warning">Edit</a>
                                <a href="${pageContext.request.contextPath}/hr/interns/delete?id=${item.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete this intern?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty interns}">
                        <tr>
                            <td colspan="8" class="text-center text-muted">No intern profiles found matching search criteria.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
