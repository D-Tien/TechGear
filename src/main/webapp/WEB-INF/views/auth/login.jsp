<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập thử | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<main class="container py-4">
    <h1>Đăng nhập</h1>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${demoLoginEnabled}">
        <p>Dùng tài khoản thử trong database để kiểm tra đặt hàng COD.</p>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="action" value="demo">
            <button class="btn btn-primary" type="submit">Đăng nhập thử</button>
        </form>
    </c:if>
    <c:if test="${!demoLoginEnabled}">
        <p>Đăng nhập thật đang được phát triển.</p>
    </c:if>
    <a class="btn btn-outline-secondary mt-3" href="${pageContext.request.contextPath}/cart">Quay lại giỏ hàng</a>
</main>
</body>
</html>
