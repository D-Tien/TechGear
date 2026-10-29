<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="tg-orders-page">
<main class="container">
    <h1>My Orders</h1>
    <c:choose><c:when test="empty orders"><div class="alert alert-info">Bạn chưa có đơn hàng.</div></c:when><c:otherwise>
    <table class="table table-bordered"><thead><tr><th>Mã đơn</th><th>Ngày đặt</th><th>Tổng tiền</th><th>Trạng thái</th><th>Thanh toán</th></tr></thead><tbody>
    <c:forEach var="o" items="${orders}"><tr><td>#${o.orderId}</td><td>${o.createdAt}</td><td>${o.totalAmount} đ</td><td>${o.status}</td><td>${o.paymentMethod}</td></tr></c:forEach>
    </tbody></table></c:otherwise></c:choose>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
