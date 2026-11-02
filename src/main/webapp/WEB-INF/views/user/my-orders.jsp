<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi | TechGear</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=20261101">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css?v=20261102">
</head>
<body class="tg-orders-page">
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<main class="tg-orders-main">
    <div class="tg-orders-heading">
        <div>
            <p class="tg-orders-eyebrow">TÀI KHOẢN</p>
            <h1>Đơn hàng của tôi</h1>
            <p class="tg-orders-description">Theo dõi các đơn hàng bạn đã đặt tại TechGear.</p>
        </div>
        <a class="tg-orders-continue" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm <span aria-hidden="true">→</span></a>
    </div>

    <section class="tg-orders-card" aria-label="Danh sách đơn hàng">
        <div class="tg-orders-card-heading">
            <div>
                <h2>Danh sách đơn hàng</h2>
                <p>Các đơn hàng được đặt bằng tài khoản này.</p>
            </div>
            <span class="tg-orders-count"><c:out value="${fn:length(orders)}"/> đơn hàng</span>
        </div>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="tg-orders-empty">
                    <div class="tg-orders-empty-icon" aria-hidden="true">▤</div>
                    <h3>Bạn chưa có đơn hàng</h3>
                    <p>Sau khi đặt hàng, thông tin đơn hàng sẽ xuất hiện tại đây.</p>
                    <a href="${pageContext.request.contextPath}/products">Xem sản phẩm</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table tg-orders-table">
                        <thead>
                            <tr>
                                <th scope="col">Mã đơn</th>
                                <th scope="col">Ngày đặt</th>
                                <th scope="col">Tổng tiền</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col">Thanh toán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td class="tg-orders-id">#<c:out value="${o.orderId}"/></td>
                                    <td class="tg-orders-date"><c:out value="${o.createdAt}"/></td>
                                    <td class="tg-orders-total"><c:out value="${o.totalAmount}"/>₫</td>
                                    <td>
                                        <span class="tg-order-status
                                            <c:choose>
                                                <c:when test="${o.status eq 'PENDING'}">is-pending</c:when>
                                                <c:when test="${o.status eq 'CONFIRMED'}">is-confirmed</c:when>
                                                <c:when test="${o.status eq 'SHIPPING'}">is-shipping</c:when>
                                                <c:when test="${o.status eq 'DELIVERED'}">is-delivered</c:when>
                                                <c:when test="${o.status eq 'CANCELLED'}">is-cancelled</c:when>
                                            </c:choose>">
                                            <c:choose>
                                                <c:when test="${o.status eq 'PENDING'}">Chờ xác nhận</c:when>
                                                <c:when test="${o.status eq 'CONFIRMED'}">Đã xác nhận</c:when>
                                                <c:when test="${o.status eq 'SHIPPING'}">Đang giao</c:when>
                                                <c:when test="${o.status eq 'DELIVERED'}">Đã giao</c:when>
                                                <c:when test="${o.status eq 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise><c:out value="${o.status}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td><c:out value="${o.paymentMethod}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<%@ include file="../common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
