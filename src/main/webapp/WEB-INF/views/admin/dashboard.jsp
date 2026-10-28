<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<main class="container">
    <h1>Dashboard</h1>
    <div class="row g-3"><div class="col-md-4"><div class="card p-3"><h5>Doanh thu</h5><strong>${revenue} đ</strong></div></div><div class="col-md-4"><div class="card p-3"><h5>Đơn hàng</h5><strong>${orderCount}</strong></div></div><div class="col-md-4"><div class="card p-3"><h5>Khách hàng</h5><strong>${customerCount}</strong></div></div></div>
    <h2 class="mt-4">Doanh thu theo tháng</h2><table class="table table-bordered"><thead><tr><th>Tháng</th><th>Doanh thu</th></tr></thead><tbody><c:forEach var="entry" items="${monthlyRevenue}"><tr><td>${entry.key}</td><td>${entry.value} đ</td></tr></c:forEach></tbody></table>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
</body>
</html>
