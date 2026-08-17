<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3">My Weekly Reports</h1>
        <a href="${pageContext.request.contextPath}/intern/home" class="btn btn-secondary">Back to Home</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                <tr>
                    <th>Week</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Submitted At</th>
                    <th>Feedback</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="report" items="${reports}">
                    <tr>
                        <td>Week ${report.weekNumber}</td>
                        <td><c:out value="${report.title}"/></td>
                        <td>
                            <span class="badge bg-${report.status == 'REVIEWED' ? 'success' : 'warning'}">
                                ${report.status}
                            </span>
                        </td>
                        <td>${report.submittedAt}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.feedback}">
                                    <button type="button" class="btn btn-sm btn-outline-info" data-bs-toggle="modal" data-bs-target="#feedbackModal${report.id}">
                                        View
                                    </button>
                                    
                                    <!-- Modal -->
                                    <div class="modal fade" id="feedbackModal${report.id}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Mentor Feedback - Week ${report.weekNumber}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p><c:out value="${report.feedback}"/></p>
                                                    <small class="text-muted">Reviewed at: ${report.reviewedAt}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">No feedback yet</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty reports}">
                    <tr>
                        <td colspan="5" class="text-center py-3 text-muted">No reports submitted yet.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
