<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mentor Workload Stats</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Mentor Workload Statistics</h2>
        <a href="${pageContext.request.contextPath}/hr/mentors" class="btn btn-secondary">Back</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>Mentor</th>
                    <th>Department / Position</th>
                    <th>Assigned Interns</th>
                    <th>Capacity</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stat" items="${stats}">
                    <tr>
                        <td>${stat.mentorName}</td>
                        <td>${stat.assignedAt}</td>
                        <td>${stat.internCode}</td>
                        <td>${stat.maxInterns}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stats}">
                    <tr><td colspan="4" class="text-center text-muted">No workload data available.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
