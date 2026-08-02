<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create User Account - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5" style="max-width: 600px;">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Create User Account</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/users/create" method="post">
                <div class="mb-3">
                    <label class="form-label">Username *</label>
                    <input type="text" name="username" class="form-control" value="${user.username}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Password *</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Full Name *</label>
                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email *</label>
                    <input type="email" name="email" class="form-control" value="${user.email}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" class="form-control" value="${user.phone}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Role *</label>
                    <select name="role" class="form-select" required>
                        <option value="HR" ${user.role == 'HR' ? 'selected' : ''}>HR</option>
                        <option value="MENTOR" ${user.role == 'MENTOR' ? 'selected' : ''}>MENTOR</option>
                        <option value="INTERN" ${user.role == 'INTERN' ? 'selected' : ''}>INTERN</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-success">Save Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
