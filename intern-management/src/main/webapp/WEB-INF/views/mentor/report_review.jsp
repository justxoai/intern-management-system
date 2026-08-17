<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="card shadow-sm mx-auto" style="max-width: 800px;">
        <div class="card-body p-4">
            <h1 class="h4 mb-4">Review Report - Week ${report.weekNumber}</h1>

            <div class="mb-4">
                <h5><c:out value="${report.title}"/></h5>
                <p class="text-muted mb-2">Submitted at: ${report.submittedAt}</p>
                <div class="p-3 bg-light border rounded">
                    <c:out value="${report.content}"/>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/mentor/reports" method="post">
                <input type="hidden" name="id" value="${report.id}">
                <div class="mb-3">
                    <label for="feedback" class="form-label fw-bold">Your Feedback</label>
                    <textarea class="form-control" id="feedback" name="feedback" rows="5" required>${report.feedback}</textarea>
                </div>
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/mentor/reports" class="btn btn-secondary">Back to List</a>
                    <button type="submit" class="btn btn-primary">Submit Feedback</button>
                </div>
            </form>
        </div>
    </div>
</main>
</body>
</html>
