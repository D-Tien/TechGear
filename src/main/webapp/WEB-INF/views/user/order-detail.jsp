<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng | TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css' />">
    <link rel="stylesheet" href="<c:url value='/assets/css/orders.css?v=20261106' />">
</head>
<body class="tg-orders-page">
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<main class="tg-orders-main tg-order-detail-main">
    <a class="tg-back-link" href="<c:url value='/my-orders' />">← Quay lại đơn hàng của tôi</a>
    <div class="page-title tg-detail-title">
        <div>
            <span class="eyebrow">TÀI KHOẢN / ĐƠN HÀNG</span>
            <h1>Đơn hàng #<c:out value="${order.orderId}" /></h1>
        </div>
    </div>

    <c:if test="${not empty orderMessage}">
        <div class="tg-order-message" role="status"><c:out value="${orderMessage}" /></div>
    </c:if>

    <section class="order-head">
        <div class="tg-order-head-info">
            <span>Ngày đặt:
                <fmt:formatNumber value="${order.createdAt.dayOfMonth}" minIntegerDigits="2" />/<fmt:formatNumber value="${order.createdAt.monthValue}" minIntegerDigits="2" />/<c:out value="${order.createdAt.year}" />
            </span>
            <span class="tg-order-status
                <c:choose>
                    <c:when test="${order.status eq 'PENDING'}">is-pending</c:when>
                    <c:when test="${order.status eq 'CONFIRMED'}">is-confirmed</c:when>
                    <c:when test="${order.status eq 'SHIPPING'}">is-shipping</c:when>
                    <c:when test="${order.status eq 'DELIVERED'}">is-delivered</c:when>
                    <c:when test="${order.status eq 'CANCELLED'}">is-cancelled</c:when>
                </c:choose>">
                <c:choose>
                    <c:when test="${order.status eq 'PENDING'}">Chờ xác nhận</c:when>
                    <c:when test="${order.status eq 'CONFIRMED'}">Đã xác nhận</c:when>
                    <c:when test="${order.status eq 'SHIPPING'}">Đang giao</c:when>
                    <c:when test="${order.status eq 'DELIVERED'}">Đã giao</c:when>
                    <c:when test="${order.status eq 'CANCELLED'}">Đã hủy</c:when>
                    <c:otherwise><c:out value="${order.status}" /></c:otherwise>
                </c:choose>
            </span>
        </div>
        <c:if test="${order.status eq 'PENDING'}">
            <form action="<c:url value='/order-detail'><c:param name='id' value='${order.orderId}' /></c:url>" method="post"
                  onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}' />">
                <input type="hidden" name="action" value="cancel">
                <button class="tg-action tg-action-secondary tg-cancel-order" type="submit">Hủy đơn hàng</button>
            </form>
        </c:if>
    </section>

    <div class="two-col tg-order-detail-layout">
        <div class="tg-order-detail-primary">
            <section class="panel tg-order-products">
                <h2>Sản phẩm</h2>
                <c:choose>
                    <c:when test="${empty orderRows}">
                        <p class="tg-muted">Không có dòng sản phẩm trong đơn hàng này.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="row" items="${orderRows}">
                            <article class="cart-item tg-order-item">
                                <c:choose>
                                    <c:when test="${not empty row.imageUrl}">
                                        <img src="<c:out value='${row.imageUrl}' />" alt="<c:out value='${row.name}' />">
                                    </c:when>
                                    <c:otherwise><div class="tg-order-image-empty" aria-hidden="true"></div></c:otherwise>
                                </c:choose>
                                <div>
                                    <strong><c:out value="${row.name}" /></strong>
                                    <span>Số lượng: <c:out value="${row.quantity}" /></span>
                                </div>
                                <span class="tg-order-unit-price"><c:out value="${row.priceText}" /> / sản phẩm</span>
                                <strong class="tg-order-line-total"><c:out value="${row.lineTotalText}" /></strong>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>

            <section class="panel tg-order-progress">
                <h2>Tiến trình đơn hàng</h2>
                <div class="timeline">
                    <div class="is-complete">
                        <strong>Đơn hàng đã đặt</strong>
                        <small><fmt:formatNumber value="${order.createdAt.dayOfMonth}" minIntegerDigits="2" />/<fmt:formatNumber value="${order.createdAt.monthValue}" minIntegerDigits="2" />/<c:out value="${order.createdAt.year}" /> · <fmt:formatNumber value="${order.createdAt.hour}" minIntegerDigits="2" />:<fmt:formatNumber value="${order.createdAt.minute}" minIntegerDigits="2" /></small>
                    </div>
                    <c:choose>
                        <c:when test="${order.status eq 'CANCELLED'}">
                            <div class="is-current is-cancelled-step"><strong>Đơn hàng đã hủy</strong></div>
                        </c:when>
                        <c:otherwise>
                            <div class="${order.status eq 'PENDING' ? 'is-current' : (order.status eq 'CONFIRMED' or order.status eq 'SHIPPING' or order.status eq 'DELIVERED' ? 'is-complete' : '')}"><strong>Chờ xác nhận</strong></div>
                            <div class="${order.status eq 'CONFIRMED' ? 'is-current' : (order.status eq 'SHIPPING' or order.status eq 'DELIVERED' ? 'is-complete' : '')}"><strong>Đã xác nhận</strong></div>
                            <div class="${order.status eq 'SHIPPING' ? 'is-current' : (order.status eq 'DELIVERED' ? 'is-complete' : '')}"><strong>Đang giao</strong></div>
                            <div class="${order.status eq 'DELIVERED' ? 'is-current' : ''}"><strong>Đã giao</strong></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>

        <aside class="tg-order-detail-aside">
            <section class="panel tg-delivery-panel">
                <h2>Thông tin giao hàng</h2>
                <strong><c:out value="${order.recipientName}" /></strong>
                <p><c:out value="${order.phone}" /></p>
                <p class="tg-order-address"><c:out value="${order.shippingAddress}" /></p>
            </section>
            <section class="panel tg-payment-panel">
                <h2>Thanh toán</h2>
                <p>
                    <c:choose>
                        <c:when test="${order.paymentMethod eq 'COD'}">Thanh toán khi nhận hàng (COD)</c:when>
                        <c:otherwise><c:out value="${order.paymentMethod}" /></c:otherwise>
                    </c:choose>
                </p>
                <hr>
                <p class="total"><span>Tổng cộng</span><strong><c:out value="${totalText}" /></strong></p>
            </section>
        </aside>
    </div>
</main>

<%@ include file="../common/footer.jsp" %>
</body>
</html>
