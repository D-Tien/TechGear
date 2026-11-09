<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi | TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css' />">
    <link rel="stylesheet" href="<c:url value='/assets/css/orders.css?v=20261106' />">
</head>
<body class="tg-orders-page">
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>
<fmt:setLocale value="vi_VN" />

<main class="tg-orders-main">
    <div class="tg-orders-heading">
        <div class="page-title">
            <div>
                <span class="eyebrow">TÀI KHOẢN / ĐƠN HÀNG</span>
                <h1>Đơn hàng của tôi</h1>
            </div>
        </div>
        <a class="tg-action tg-action-secondary" href="<c:url value='/products' />">← Tiếp tục mua sắm</a>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <section class="tg-orders-empty">
                <div class="tg-orders-empty-icon" aria-hidden="true">▤</div>
                <h2>Bạn chưa có đơn hàng</h2>
                <p>Sau khi đặt hàng, đơn hàng sẽ xuất hiện tại đây.</p>
                <a class="tg-action tg-action-primary" href="<c:url value='/products' />">Xem sản phẩm</a>
            </section>
        </c:when>
        <c:otherwise>
            <section class="tg-orders-tools" aria-label="Tìm và lọc đơn hàng">
                <label class="tg-order-search">
                    <span class="visually-hidden">Tìm theo mã đơn hàng</span>
                    <input id="orderSearch" type="search" placeholder="Tìm theo mã đơn hàng">
                </label>
                <div class="tg-order-filters" role="group" aria-label="Lọc theo trạng thái">
                    <button class="tg-order-filter is-active" type="button" data-status-filter="all">Tất cả</button>
                    <button class="tg-order-filter" type="button" data-status-filter="PENDING">Chờ xác nhận</button>
                    <button class="tg-order-filter" type="button" data-status-filter="CONFIRMED">Đã xác nhận</button>
                    <button class="tg-order-filter" type="button" data-status-filter="SHIPPING">Đang giao</button>
                    <button class="tg-order-filter" type="button" data-status-filter="DELIVERED">Đã giao</button>
                    <button class="tg-order-filter" type="button" data-status-filter="CANCELLED">Đã hủy</button>
                </div>
            </section>

            <p class="tg-orders-result-count"><strong id="visibleOrderCount"><c:out value="${fn:length(orders)}" /></strong> đơn hàng</p>
            <section class="order-list tg-order-list" id="orderList" aria-label="Danh sách đơn hàng">
                <c:forEach var="o" items="${orders}">
                    <article class="order-card tg-order-card" data-order-id="${o.orderId}" data-status="<c:out value='${o.status}' />">
                        <div>
                            <small>MÃ ĐƠN</small>
                            <strong class="tg-order-id">#<c:out value="${o.orderId}" /></strong>
                        </div>
                        <div>
                            <small>NGÀY ĐẶT</small>
                            <strong>
                                <fmt:formatNumber value="${o.createdAt.dayOfMonth}" minIntegerDigits="2" />/<fmt:formatNumber value="${o.createdAt.monthValue}" minIntegerDigits="2" />/<c:out value="${o.createdAt.year}" />
                            </strong>
                        </div>
                        <div>
                            <small>TỔNG TIỀN</small>
                            <strong><fmt:formatNumber value="${o.totalAmount}" groupingUsed="true" maxFractionDigits="0" /> ₫</strong>
                        </div>
                        <div>
                            <small>TRẠNG THÁI</small>
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
                                    <c:otherwise><c:out value="${o.status}" /></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <a class="tg-action tg-action-secondary tg-order-detail-link"
                           href="<c:url value='/order-detail'><c:param name='id' value='${o.orderId}' /></c:url>">Xem chi tiết</a>
                    </article>
                </c:forEach>
            </section>
            <div class="tg-orders-no-match" id="noOrdersMatch" hidden>Không tìm thấy đơn hàng phù hợp.</div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="../common/footer.jsp" %>
<script>
    (function () {
        var search = document.getElementById('orderSearch');
        var list = document.getElementById('orderList');
        if (!search || !list) return;
        var cards = Array.prototype.slice.call(list.querySelectorAll('.tg-order-card'));
        var filters = document.querySelectorAll('[data-status-filter]');
        var activeStatus = 'all';
        var count = document.getElementById('visibleOrderCount');
        var emptyMessage = document.getElementById('noOrdersMatch');

        function applyFilters() {
            var query = search.value.trim().toLowerCase().replace(/#/g, '');
            var visible = 0;
            cards.forEach(function (card) {
                var matchesStatus = activeStatus === 'all' || card.getAttribute('data-status') === activeStatus;
                var matchesId = card.getAttribute('data-order-id').toLowerCase().indexOf(query) !== -1;
                card.hidden = !(matchesStatus && matchesId);
                if (!card.hidden) visible++;
            });
            count.textContent = visible;
            emptyMessage.hidden = visible !== 0;
        }

        search.addEventListener('input', applyFilters);
        filters.forEach(function (button) {
            button.addEventListener('click', function () {
                activeStatus = button.getAttribute('data-status-filter');
                filters.forEach(function (item) { item.classList.toggle('is-active', item === button); });
                applyFilters();
            });
        });
    }());
</script>
</body>
</html>
