<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="adminSection" value="orders"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="tg-admin-page">
<div class="tg-admin-layout">
<%@ include file="admin-sidebar.jspf" %>
<main class="container tg-admin-main" id="tg-main">
    <h1>Order Management</h1>
    <table class="table table-bordered"><thead><tr><th>Mã</th><th>Khách</th><th>Ngày</th><th>Tổng</th><th>Trạng thái</th><th>Cập nhật</th></tr></thead><tbody>
    <c:forEach var="o" items="${orders}"><tr><td>#${o.orderId}</td><td>${o.recipientName}<br>${o.phone}</td><td>${o.createdAt}</td><td>${o.totalAmount} đ</td><td>${o.status}</td><td><form method="post" class="d-flex gap-2"><input type="hidden" name="orderId" value="${o.orderId}"><select name="status" class="form-select"><option>PENDING</option><option>CONFIRMED</option><option>SHIPPING</option><option>DELIVERED</option><option>CANCELLED</option></select><button class="btn btn-primary">Lưu</button></form></td></tr></c:forEach>
    </tbody></table>
</main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>
