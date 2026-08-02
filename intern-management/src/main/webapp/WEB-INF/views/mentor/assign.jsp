<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Mentor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4" style="max-width: 700px;">
    <h2>Assign Mentor to Intern</h2>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/hr/mentors/assign" method="post" class="card p-4 shadow-sm">
        <div class="mb-3">
            <label class="form-label">Mentor</label>
            <select name="mentorId" class="form-select" required>
                <option value="">-- Choose mentor --</option>
                <c:forEach var="mentor" items="${mentors}">
                    <option value="${mentor.id}">${mentor.fullName} (${mentor.department})</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Intern</label>
            <select name="internId" class="form-select" required>
                <option value="">-- Choose intern --</option>
                <c:forEach var="intern" items="${interns}">
                    <option value="${intern.id}">${intern.studentCode} - ${intern.fullName}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Assign</button>
        <a href="${pageContext.request.contextPath}/hr/mentors" class="btn btn-secondary ms-2">Back</a>
    </form>
</div>
</body>
</html>
