<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Intern Weekly Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3">Intern Weekly Reports</h1>
        <a class="btn btn-danger" href="${pageContext.request.contextPath}/logout">Sign out</a>
    </div>

    <c:if test="${not empty param.message}">
        <div class="alert alert-success">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">${param.error}</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                <tr>
                    <th>Intern Name</th>
                    <th>Week</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Submitted At</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="report" items="${reports}">
                    <tr>
                        <td><c:out value="${report.internName}"/></td>
                        <td>Week ${report.weekNumber}</td>
                        <td><c:out value="${report.title}"/></td>
                        <td>
                            <span class="badge bg-${report.status == 'REVIEWED' ? 'success' : 'warning'}">
                                ${report.status}
                            </span>
                        </td>
                        <td>${report.submittedAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/mentor/reports?action=view&id=${report.id}" class="btn btn-sm btn-primary">Review</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty reports}">
                    <tr>
                        <td colspan="6" class="text-center py-3 text-muted">No reports to review.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
