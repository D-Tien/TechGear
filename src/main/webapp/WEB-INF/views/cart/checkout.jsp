<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty orderId}">Đặt hàng thành công</c:when><c:otherwise>Thanh toán COD</c:otherwise></c:choose> | TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css' />">
    <link rel="stylesheet" href="<c:url value='/assets/css/cart.css?v=20261106' />">
</head>
<body class="tg-checkout-page">
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<c:choose>
    <c:when test="${not empty orderId and not empty successOrder}">
        <main class="tg-commerce-main tg-success-main">
            <section class="success-page">
                <div class="success-icon" aria-hidden="true">✓</div>
                <span class="tg-commerce-eyebrow">ĐẶT HÀNG THÀNH CÔNG</span>
                <h1>Cảm ơn bạn đã mua sắm!</h1>
                <p>Đơn hàng <strong>#<c:out value="${successOrder.orderId}" /></strong> đã được tiếp nhận.</p>
                <div class="receipt">
                    <span>Ngày đặt</span><strong><c:out value="${successDateText}" /></strong>
                    <span>Thanh toán</span><strong><c:out value="${successOrder.paymentMethod}" /></strong>
                    <span>Tổng cộng</span><strong><c:out value="${successTotalText}" /></strong>
                </div>
                <div class="success-actions">
                    <a class="tg-action tg-action-primary" href="<c:url value='/my-orders' />">Xem đơn hàng</a>
                    <a class="tg-action tg-action-secondary" href="<c:url value='/products' />">Tiếp tục mua sắm</a>
                </div>
            </section>
        </main>
    </c:when>
    <c:otherwise>
        <main class="tg-commerce-main tg-checkout-main">
            <p class="tg-commerce-eyebrow">GIỎ HÀNG / THANH TOÁN</p>
            <h1>Thông tin giao hàng</h1>

            <c:if test="${not empty checkoutError}">
                <div class="tg-alert tg-alert-error" role="alert"><c:out value="${checkoutError}" /></div>
            </c:if>
            <c:if test="${!loggedIn}">
                <div class="tg-alert tg-alert-warning" role="status">
                    Bạn cần đăng nhập để đặt hàng.
                    <a href="<c:url value='/login' />">Đăng nhập</a>
                    <a href="<c:url value='/register' />">Tạo tài khoản</a>
                </div>
            </c:if>

            <c:if test="${not empty rows}">
                <div class="two-col tg-checkout-layout">
                    <form id="checkoutForm" class="form-card tg-checkout-form" action="<c:url value='/checkout' />" method="post">
                        <h2>Thông tin người nhận</h2>
                        <div class="form-grid">
                            <label class="field" for="recipientName">
                                <span>Họ và tên *</span>
                                <input id="recipientName" name="recipientName" required maxlength="100"
                                       value="<c:out value='${recipientName}' />" autocomplete="name">
                            </label>
                            <label class="field" for="phone">
                                <span>Số điện thoại *</span>
                                <input id="phone" name="phone" required maxlength="20"
                                       value="<c:out value='${phone}' />" autocomplete="tel">
                            </label>
                            <label class="field wide" for="shippingAddress">
                                <span>Địa chỉ nhận hàng *</span>
                                <textarea id="shippingAddress" name="shippingAddress" required maxlength="500"
                                          autocomplete="street-address"><c:out value="${shippingAddress}" /></textarea>
                            </label>
                        </div>

                        <h2 class="tg-payment-heading">Phương thức thanh toán</h2>
                        <label class="payment">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <span><strong>Thanh toán khi nhận hàng (COD)</strong>
                                <small>Thanh toán khi nhận đơn hàng.</small>
                            </span>
                        </label>
                        <div class="tg-checkout-form-actions">
                            <a class="tg-action tg-action-secondary" href="<c:url value='/cart' />">← Quay lại giỏ hàng</a>
                        </div>
                    </form>

                    <aside class="summary tg-summary order-summary">
                        <h2>Đơn hàng của bạn</h2>
                        <div class="tg-checkout-items">
                            <c:forEach var="row" items="${rows}">
                                <div class="tg-checkout-item">
                                    <c:choose>
                                        <c:when test="${not empty row.imageUrl}">
                                            <img src="<c:out value='${row.imageUrl}' />" alt="<c:out value='${row.name}' />">
                                        </c:when>
                                        <c:otherwise><div class="tg-checkout-image-empty" aria-hidden="true"></div></c:otherwise>
                                    </c:choose>
                                    <div class="tg-checkout-item-info">
                                        <strong><c:out value="${row.name}" /></strong>
                                        <span>Số lượng: <c:out value="${row.quantity}" /></span>
                                    </div>
                                    <strong><c:out value="${row.lineTotalText}" /></strong>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="summary-row"><span>Tạm tính</span><strong><c:out value="${totalText}" /></strong></div>
                        <hr>
                        <div class="total"><span>Tổng thanh toán</span><strong><c:out value="${totalText}" /></strong></div>
                        <c:choose>
                            <c:when test="${canOrder && loggedIn}">
                                <button class="tg-action tg-action-primary tg-full" form="checkoutForm" type="submit">Xác nhận đặt hàng</button>
                            </c:when>
                            <c:otherwise>
                                <button class="tg-action tg-action-primary tg-full" type="button" disabled>Xác nhận đặt hàng</button>
                            </c:otherwise>
                        </c:choose>
                    </aside>
                </div>
            </c:if>

            <c:if test="${empty rows}">
                <section class="tg-empty-state">
                    <h2>Không có sản phẩm để thanh toán</h2>
                    <p>Quay lại giỏ hàng để kiểm tra sản phẩm.</p>
                    <a class="tg-action tg-action-secondary" href="<c:url value='/cart' />">← Quay lại giỏ hàng</a>
                </section>
            </c:if>
        </main>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
