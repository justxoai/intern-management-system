<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Internship Applications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3">Internship Applications</h1>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/hr/interns">Back to HR Dashboard</a>
    </div>

    <c:if test="${not empty param.message}">
        <div class="alert alert-success">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">${param.error}</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                <tr>
                    <th>Intern Name</th>
                    <th>Application Date</th>
                    <th>Status</th>
                    <th>Reviewed By</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="app" items="${applications}">
                    <tr>
                        <td><c:out value="${app.internName}"/></td>
                        <td>${app.applicationDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${app.status == 'APPROVED'}">
                                    <span class="badge bg-success">APPROVED</span>
                                </c:when>
                                <c:when test="${app.status == 'REJECTED'}">
                                    <span class="badge bg-danger">REJECTED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark">PENDING</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty app.reviewerName}">
                                <c:out value="${app.reviewerName}"/> <br>
                                <small class="text-muted">${app.reviewedAt}</small>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${app.status == 'PENDING'}">
                                <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#approveModal${app.id}">
                                    Approve
                                </button>
                                <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal${app.id}">
                                    Reject
                                </button>

                                <!-- Approve Modal -->
                                <div class="modal fade" id="approveModal${app.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <form action="${pageContext.request.contextPath}/hr/applications" method="post" class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Confirm Approval</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Are you sure you want to approve the application for <strong><c:out value="${app.internName}"/></strong>?</p>
                                                <input type="hidden" name="id" value="${app.id}">
                                                <input type="hidden" name="status" value="APPROVED">
                                                <input type="hidden" name="reason" value="">
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-success">Approve Application</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Reject Modal -->
                                <div class="modal fade" id="rejectModal${app.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <form action="${pageContext.request.contextPath}/hr/applications" method="post" class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Confirm Rejection</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Are you sure you want to reject the application for <strong><c:out value="${app.internName}"/></strong>?</p>
                                                <div class="mb-3">
                                                    <label for="reason${app.id}" class="form-label">Rejection Reason</label>
                                                    <textarea class="form-control" id="reason${app.id}" name="reason" rows="3" required></textarea>
                                                </div>
                                                <input type="hidden" name="id" value="${app.id}">
                                                <input type="hidden" name="status" value="REJECTED">
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-danger">Reject Application</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty applications}">
                    <tr>
                        <td colspan="5" class="text-center py-3 text-muted">No applications found.</td>
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
