<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | TechGear</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css?v=20261106">
</head>
<body class="tg-cart-page">
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="tg-commerce-main tg-cart-main">
    <p class="tg-commerce-eyebrow">TRANG CHỦ / GIỎ HÀNG</p>
    <h1>Giỏ hàng của bạn <span>(<c:out value="${not empty sessionScope.cartCount ? sessionScope.cartCount : fn:length(rows)}"/>)</span></h1>

    <div class="tg-cart-layout">
        <section class="tg-cart-list" aria-label="Sản phẩm trong giỏ hàng">
            <c:choose>
                <c:when test="${empty rows}">
                    <div class="tg-empty-state">
                        <h2>Giỏ hàng đang trống</h2>
                        <p>Hãy chọn sản phẩm bạn muốn mua.</p>
                        <a class="tg-action tg-action-primary" href="<c:url value='/products'/>">Xem sản phẩm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="row" items="${rows}">
                        <article class="tg-cart-item">
                            <c:choose>
                                <c:when test="${not empty row.imageUrl}">
                                    <img class="tg-cart-image" src="<c:out value='${row.imageUrl}'/>" alt="<c:out value='${row.name}'/>">
                                </c:when>
                                <c:otherwise><div class="tg-cart-image tg-image-empty" aria-hidden="true"></div></c:otherwise>
                            </c:choose>
                            <div class="tg-cart-product"><strong><c:out value="${row.name}"/></strong></div>
                            <div class="tg-quantity" aria-label="Số lượng">
                                <form action="<c:url value='/cart'/>" method="post">
                                    <input type="hidden" name="action" value="decrease">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <button type="submit" aria-label="Giảm số lượng" <c:if test="${row.quantity le 1}">disabled</c:if>>−</button>
                                </form>
                                <form class="tg-quantity-input-form" action="<c:url value='/cart'/>" method="post">
                                    <input type="hidden" name="action" value="setQuantity">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <label class="visually-hidden" for="quantity-${row.productId}">Số lượng <c:out value="${row.name}"/></label>
                                    <input id="quantity-${row.productId}" class="tg-quantity-input" type="number" name="quantity"
                                           value="${row.quantity}" min="1" max="${row.stock lt 99 ? row.stock : 99}"
                                           required inputmode="numeric" aria-label="Số lượng" onchange="this.form.requestSubmit()">
                                    <button class="visually-hidden" type="submit">Cập nhật số lượng</button>
                                </form>
                                <form action="<c:url value='/cart'/>" method="post">
                                    <input type="hidden" name="action" value="increase">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <button type="submit" aria-label="Tăng số lượng" <c:if test="${row.quantity ge 99 or row.quantity ge row.stock}">disabled</c:if>>+</button>
                                </form>
                            </div>
                            <strong class="tg-cart-price"><c:out value="${row.priceText}"/></strong>
                            <form action="<c:url value='/cart'/>" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${row.productId}">
                                <button class="tg-remove" type="submit" aria-label="Xóa sản phẩm">×</button>
                            </form>
                        </article>
                    </c:forEach>
                    <a class="tg-action tg-action-secondary tg-continue" href="<c:url value='/products'/>">← Tiếp tục mua sắm</a>
                </c:otherwise>
            </c:choose>
        </section>

        <aside class="tg-summary">
            <h2>Tóm tắt đơn hàng</h2>
            <div class="summary-row"><span>Tạm tính</span><strong><c:out value="${totalText}"/></strong></div>
            <hr>
            <div class="total"><span>Tổng cộng</span><strong><c:out value="${totalText}"/></strong></div>
            <c:if test="${not empty rows}">
                <a class="tg-action tg-action-primary tg-full" href="<c:url value='/checkout'/>">Tiến hành thanh toán →</a>
            </c:if>
        </aside>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
