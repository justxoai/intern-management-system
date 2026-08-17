<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Mentor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4" style="max-width: 700px;">
    <h2>Create Mentor Profile</h2>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/hr/mentors/create" method="post" class="card p-4 shadow-sm">
        <div class="mb-3">
            <label class="form-label">Select Mentor User</label>
            <select name="userId" class="form-select" required>
                <option value="">-- Choose user --</option>
                <c:forEach var="user" items="${mentorUsers}">
                    <option value="${user.id}" ${mentor != null && mentor.userId == user.id ? 'selected' : ''}>${user.fullName} (${user.username})</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Department</label>
            <input type="text" name="department" class="form-control" value="${mentor.department}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Position</label>
            <input type="text" name="position" class="form-control" value="${mentor.position}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Max Interns</label>
            <input type="number" name="maxInterns" class="form-control" value="${mentor.maxInterns != null ? mentor.maxInterns : 5}" required>
        </div>
        <button type="submit" class="btn btn-primary">Save Mentor</button>
        <a href="${pageContext.request.contextPath}/hr/mentors" class="btn btn-secondary ms-2">Back</a>
    </form>
</div>
</body>
</html>
