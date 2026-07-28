<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User - Internship System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: #f0f4f8; }
        .edit-card { border-radius: 16px; border: none; box-shadow: 0 4px 24px rgba(0,0,0,0.10); }
        .edit-header { background: linear-gradient(135deg, #1e3a5f 0%, #2d6bcf 100%); border-radius: 16px 16px 0 0; }
    </style>
</head>
<body>
<div class="container py-5" style="max-width:600px;">
    <div class="card edit-card">
        <div class="edit-header text-white px-4 py-3 d-flex align-items-center gap-2">
            <i class="bi bi-person-gear fs-4"></i>
            <h5 class="mb-0">Edit User Account</h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/edit">
                <input type="hidden" name="id" value="${user.id}">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Username</label>
                    <input type="text" class="form-control" value="${user.username}" readonly disabled>
                    <small class="text-muted">Username cannot be changed.</small>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control" value="${user.email}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Phone</label>
                    <input type="text" name="phone" class="form-control" value="${user.phone}">
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Role</label>
                        <select name="role" class="form-select">
                            <option value="HR"     ${user.role == 'HR'     ? 'selected' : ''}>HR</option>
                            <option value="MENTOR" ${user.role == 'MENTOR' ? 'selected' : ''}>MENTOR</option>
                            <option value="INTERN" ${user.role == 'INTERN' ? 'selected' : ''}>INTERN</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Status</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE"   ${user.status == 'ACTIVE'   ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-check-circle me-1"></i>Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary px-4">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
