<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Intern Profile - HR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4" style="max-width: 700px;">
    <div class="card shadow">
        <div class="card-header bg-warning text-dark">
            <h4 class="mb-0">Edit Intern Profile</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/hr/interns/edit" method="post">
                <input type="hidden" name="id" value="${intern.id}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Student Code *</label>
                        <input type="text" name="studentCode" class="form-control" value="${intern.studentCode}" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" value="${intern.fullName}" disabled>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">University *</label>
                        <input type="text" name="university" class="form-control" value="${intern.university}" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Major *</label>
                        <input type="text" name="major" class="form-control" value="${intern.major}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date of Birth</label>
                        <input type="date" name="dateOfBirth" class="form-control" value="${intern.dateOfBirth}">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Gender</label>
                        <select name="gender" class="form-select">
                            <option value="Male" ${intern.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${intern.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${intern.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" class="form-control" value="${intern.phone}">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Email *</label>
                        <input type="email" name="email" class="form-control" value="${intern.email}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <input type="text" name="address" class="form-control" value="${intern.address}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="PENDING" ${intern.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                        <option value="APPROVED" ${intern.status == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                        <option value="INTERNING" ${intern.status == 'INTERNING' ? 'selected' : ''}>INTERNING</option>
                        <option value="COMPLETED" ${intern.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/hr/interns" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-warning">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
