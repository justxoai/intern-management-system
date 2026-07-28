<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Task - Mentor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; }
        .edit-card { border-radius: 16px; border: none; box-shadow: 0 4px 24px rgba(0,0,0,0.10); }
        .edit-header { background: linear-gradient(135deg, #0891b2 0%, #22d3ee 100%); border-radius: 16px 16px 0 0; }
    </style>
</head>
<body>
<div class="container py-5" style="max-width: 640px;">
    <div class="card edit-card">
        <div class="edit-header text-white px-4 py-3 d-flex align-items-center gap-2">
            <i class="bi bi-pencil-square fs-4"></i>
            <h5 class="mb-0">Edit Task</h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${task == null}">
                <div class="alert alert-danger">Task not found.</div>
            </c:if>
            <c:if test="${task != null}">
                <form method="post" action="${pageContext.request.contextPath}/mentor/dashboard/task/edit">
                    <input type="hidden" name="id" value="${task.id}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Task Title <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" value="${task.title}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3">${task.description}</textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Assigned Intern</label>
                            <select name="internId" class="form-select">
                                <option value="">-- No Intern --</option>
                                <c:forEach var="i" items="${allMyInterns}">
                                    <option value="${i.id}" ${task.internId == i.id ? 'selected' : ''}>
                                        ${i.studentCode} - ${i.fullName != null ? i.fullName : i.email}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold">Status</label>
                            <select name="status" class="form-select">
                                <option value="TODO"        ${task.status == 'TODO'        ? 'selected' : ''}>TODO</option>
                                <option value="IN_PROGRESS" ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                                <option value="DONE"        ${task.status == 'DONE'        ? 'selected' : ''}>DONE</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold">Due Date</label>
                            <input type="date" name="dueDate" class="form-control" value="${task.dueDate}">
                        </div>
                    </div>

                    <div class="d-flex gap-2 mt-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-check-circle me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn btn-outline-secondary px-4">Cancel</a>
                    </div>
                </form>
            </c:if>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
