<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Weekly Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="card shadow-sm mx-auto" style="max-width: 640px;">
        <div class="card-body p-4">
            <h1 class="h4 mb-4">Submit Weekly Report</h1>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/intern/report/submit" method="post">
                <div class="mb-3">
                    <label for="weekNumber" class="form-label">Week Number</label>
                    <input type="number" class="form-control" id="weekNumber" name="weekNumber" required min="1">
                </div>
                <div class="mb-3">
                    <label for="title" class="form-label">Title</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                <div class="mb-3">
                    <label for="content" class="form-label">Report Content</label>
                    <textarea class="form-control" id="content" name="content" rows="6" required></textarea>
                </div>
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/intern/home" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Submit Report</button>
                </div>
            </form>
        </div>
    </div>
</main>
</body>
</html>
