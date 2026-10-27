<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<main class="container py-4">
    <h1>Thanh toán</h1>

    <c:if test="${success}">
        <div class="alert alert-success">
            <strong>Thanh toán thành công (bản demo).</strong>
            Giỏ hàng đã được xóa. Chưa tạo đơn hàng trong database.
        </div>
    </c:if>
    <c:if test="${!success}">
        <p>Chưa có giao dịch thanh toán demo.</p>
    </c:if>

    <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/cart">Quay lại giỏ hàng</a>
</main>
</body>
</html>
