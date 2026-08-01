<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Intern Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5">
    <div class="card shadow-sm mx-auto" style="max-width: 640px;">
        <div class="card-body p-4">
            <h1 class="h3">Intern Portal</h1>
            <p class="text-muted mb-4">
                Welcome, ${sessionScope.currentUser.fullName}. This area is for intern self-service.
            </p>
            <div class="d-flex gap-2">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/logout">Sign out</a>
            </div>
        </div>
    </div>
</main>
</body>
</html>
