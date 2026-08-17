<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mentor Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Mentor Management</h2>
        <div>
            <a href="${pageContext.request.contextPath}/hr/mentors/create" class="btn btn-primary">+ Create Mentor</a>
            <a href="${pageContext.request.contextPath}/hr/mentors/assign" class="btn btn-outline-secondary">Assign Mentor</a>
            <a href="${pageContext.request.contextPath}/hr/mentors/stats" class="btn btn-outline-info">Workload Stats</a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Mentor Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Position</th>
                    <th>Max Interns</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="mentor" items="${mentors}">
                    <tr>
                        <td>${mentor.id}</td>
                        <td>${mentor.fullName}</td>
                        <td>${mentor.username}</td>
                        <td>${mentor.email}</td>
                        <td>${mentor.department}</td>
                        <td>${mentor.position}</td>
                        <td>${mentor.maxInterns}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty mentors}">
                    <tr><td colspan="7" class="text-center text-muted">No mentors found.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
