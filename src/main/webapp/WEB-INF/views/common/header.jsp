<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="announcement">
    <span>Miễn phí giao hàng toàn quốc cho đơn từ 500.000₫</span>
    <span>Hỗ trợ 24/7 · 1900 6868</span>
</div>
<header class="customer-header">
    <a class="logo" href="<c:url value='/home'/>" aria-label="Trang chủ TechGear">
        <img class="brand-logo-img" src="<c:url value='/assets/images/techgear-logo-navy.png'/>" alt="TechGear">
    </a>

    <form class="search-bar" method="get" action="<c:url value='/products'/>" role="search">
        <input name="keyword" type="search" placeholder="Tìm bàn phím, tai nghe, chuột, phụ kiện..." value="<c:out value='${param.keyword}'/>" autocomplete="off">
        <button type="submit" aria-label="Tìm kiếm">⌕</button>
    </form>

    <div class="header-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <c:if test="${sessionScope.roleName eq 'ADMIN'}">
                    <a class="header-btn" href="<c:url value='/admin/dashboard'/>">
                        ⚙ Quản trị
                    </a>
                </c:if>
                <a class="header-btn" href="<c:url value='/profile'/>">
                    👤 <c:out value="${sessionScope.currentUser.fullName}"/>
                </a>
            </c:when>
            <c:otherwise>
                <a class="header-btn auth-btn" href="<c:url value='/login'/>">
                    Đăng nhập
                </a>
            </c:otherwise>
        </c:choose>

        <a class="header-btn cart-btn" href="<c:url value='/cart'/>">
            Giỏ hàng <b class="badge-count">${not empty sessionScope.cartCount ? sessionScope.cartCount : (not empty sessionScope.cart ? sessionScope.cart.size() : 0)}</b>
        </a>
    </div>
</header>
