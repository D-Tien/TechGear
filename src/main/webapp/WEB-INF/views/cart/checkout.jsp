<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng COD | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<main class="container py-4">
    <h1 class="mb-4">Đặt hàng COD</h1>

    <c:if test="${not empty orderId}">
        <div class="alert alert-success">
            Đặt hàng thành công. Mã đơn hàng: <strong><c:out value="${orderId}"/></strong>.
            Bạn thanh toán khi nhận hàng.
        </div>
    </c:if>
    <c:if test="${not empty checkoutError}">
        <div class="alert alert-danger"><c:out value="${checkoutError}"/></div>
    </c:if>
    <c:if test="${!loggedIn && empty orderId}">
        <div class="alert alert-warning">Bạn cần đăng nhập để đặt hàng.
            <a href="${pageContext.request.contextPath}/login">Đến trang đăng nhập</a>
        </div>
    </c:if>

    <c:if test="${not empty rows}">
        <table class="table table-bordered">
            <thead><tr><th>Sản phẩm</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead>
            <tbody>
                <c:forEach var="row" items="${rows}">
                    <tr>
                        <td><c:out value="${row.name}"/></td>
                        <td>${row.quantity}</td>
                        <td>${row.priceText}</td>
                        <td>${row.lineTotalText}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <p class="text-end fs-5"><strong>Tạm tính: ${totalText}</strong></p>
        <p>Giá và tồn kho sẽ được kiểm tra lại khi bạn bấm Đặt hàng.</p>
    </c:if>

    <c:if test="${canOrder}">
        <form action="${pageContext.request.contextPath}/checkout" method="post" class="mt-4">
            <div class="mb-3">
                <label for="recipientName" class="form-label">Tên người nhận</label>
                <input id="recipientName" name="recipientName" class="form-control" required maxlength="100"
                       value="<c:out value="${recipientName}"/>">
            </div>
            <div class="mb-3">
                <label for="shippingAddress" class="form-label">Địa chỉ giao hàng</label>
                <textarea id="shippingAddress" name="shippingAddress" class="form-control" required maxlength="500"><c:out value="${shippingAddress}"/></textarea>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">Số điện thoại</label>
                <input id="phone" name="phone" class="form-control" required maxlength="20"
                       value="<c:out value="${phone}"/>">
            </div>
            <p>Phương thức thanh toán: <strong>COD — thanh toán khi nhận hàng</strong></p>
            <button class="btn btn-success" type="submit">Đặt hàng</button>
        </form>
    </c:if>
    <a class="btn btn-outline-primary mt-3" href="${pageContext.request.contextPath}/cart">Quay lại giỏ hàng</a>
</main>
</body>
</html>
