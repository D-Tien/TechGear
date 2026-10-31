<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng & Thanh toán COD | TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/cart.css'/>">
</head>
<body class="tg-checkout-page">

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container py-4">
    <h1 class="mb-4">Đặt hàng & Thanh toán COD</h1>

    <c:if test="${not empty orderId}">
        <div class="alert alert-success shadow-sm">
            <h4 class="alert-heading">🎉 Đặt hàng thành công!</h4>
            <p>Mã đơn hàng của bạn là: <strong>#<c:out value="${orderId}"/></strong>.</p>
            <p class="mb-0">Phương thức: <strong>COD (Thanh toán khi nhận hàng)</strong>. Đơn hàng sẽ sớm được nhân viên liên hệ xác nhận và bàn giao cho đơn vị vận chuyển.</p>
            <hr>
            <div class="d-flex gap-2">
                <a href="<c:url value='/my-orders'/>" class="btn btn-outline-success">Xem đơn hàng của tôi</a>
                <a href="<c:url value='/products'/>" class="btn btn-primary">Tiếp tục mua sắm</a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty checkoutError}">
        <div class="alert alert-danger shadow-sm"><c:out value="${checkoutError}"/></div>
    </c:if>

    <c:if test="${!loggedIn && empty orderId}">
        <div class="alert alert-warning shadow-sm">
            <strong>Thông báo:</strong> Bạn cần đăng nhập tài khoản để xác thực và tiến hành đặt hàng.
            <div class="mt-2">
                <a class="btn btn-primary btn-sm" href="<c:url value='/login'/>">Đến trang đăng nhập</a>
                <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/register'/>">Đăng ký tài khoản</a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty rows}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Tóm tắt đơn hàng (${rows.size()} mặt hàng)</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-bordered mb-0 align-middle">
                    <thead class="table-light"><tr><th>Sản phẩm</th><th class="text-center">Số lượng</th><th class="text-end">Đơn giá</th><th class="text-end">Thành tiền</th></tr></thead>
                    <tbody>
                        <c:forEach var="row" items="${rows}">
                            <tr>
                                <td><strong><c:out value="${row.name}"/></strong></td>
                                <td class="text-center">${row.quantity}</td>
                                <td class="text-end">${row.priceText}</td>
                                <td class="text-end">${row.lineTotalText}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="card-footer bg-white text-end py-3">
                <span class="fs-5 me-2">Tổng thanh toán:</span>
                <strong class="fs-4 text-primary">${totalText}</strong>
                <p class="text-muted small mb-0 mt-1">Đã bao gồm thuế VAT và phí xử lý đơn hàng.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${canOrder}">
        <div class="card shadow-sm">
            <div class="card-header bg-light">
                <h5 class="mb-0">Thông tin giao hàng</h5>
            </div>
            <div class="card-body">
                <form action="<c:url value='/checkout'/>" method="post">
                    <div class="mb-3">
                        <label for="recipientName" class="form-label">Tên người nhận <span class="text-danger">*</span></label>
                        <input id="recipientName" name="recipientName" class="form-control" required maxlength="100"
                               placeholder="Họ và tên người nhận" value="<c:out value="${recipientName}"/>">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại liên hệ <span class="text-danger">*</span></label>
                        <input id="phone" name="phone" class="form-control" required maxlength="20"
                               placeholder="Số điện thoại nhận hàng" value="<c:out value="${phone}"/>">
                    </div>
                    <div class="mb-3">
                        <label for="shippingAddress" class="form-label">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                        <textarea id="shippingAddress" name="shippingAddress" class="form-control" required rows="3" maxlength="500"
                                  placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"><c:out value="${shippingAddress}"/></textarea>
                    </div>

                    <div class="p-3 bg-light rounded mb-4">
                        <h6 class="mb-2">Hình thức thanh toán:</h6>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="COD" checked>
                            <label class="form-check-label" for="codPayment">
                                <strong>COD — Thanh toán tiền mặt khi nhận hàng</strong>
                                <small class="text-muted d-block">Bạn có thể kiểm tra hàng cùng bưu tá trước khi thanh toán.</small>
                            </label>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <a class="btn btn-outline-secondary" href="<c:url value='/cart'/>">← Quay lại giỏ hàng</a>
                        <button class="btn btn-success btn-lg px-4" type="submit">Xác nhận đặt hàng</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <c:if test="${!canOrder && empty orderId}">
        <div class="mt-3">
            <a class="btn btn-outline-primary" href="<c:url value='/cart'/>">← Quay lại giỏ hàng</a>
        </div>
    </c:if>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
