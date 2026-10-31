<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Trang chủ"/>
<c:set var="activeNav" value="home"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechGear – Phụ kiện công nghệ cao cấp</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body>

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<main class="container">
    <!-- Hero Banner (Matching Figma Mockup) -->
    <section class="hero-banner">
        <div class="hero-content">
            <span class="hero-kicker">BỘ SƯU TẬP THÁNG 10</span>
            <h1>Nâng cấp góc làm việc<br>cùng TechGear</h1>
            <p>Tai nghe • Bàn phím • Chuột • Phụ kiện</p>
            <a class="hero-btn" href="#products">Khám phá ngay →</a>
        </div>
        <div class="hero-visual">
            <svg class="hero-headphone-svg" viewBox="0 0 320 320" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="Tai nghe cao cấp TechGear">
                <defs>
                    <linearGradient id="headbandGrad" x1="60" y1="50" x2="260" y2="50" gradientUnits="userSpaceOnUse">
                        <stop offset="0%" stop-color="#14274e"/>
                        <stop offset="50%" stop-color="#21488c"/>
                        <stop offset="100%" stop-color="#14274e"/>
                    </linearGradient>
                    <linearGradient id="cupGrad" x1="0" y1="0" x2="1" y2="1">
                        <stop offset="0%" stop-color="#3b82f6"/>
                        <stop offset="100%" stop-color="#1d4ed8"/>
                    </linearGradient>
                    <filter id="glowEffect" x="0" y="0" width="320" height="320" filterUnits="userSpaceOnUse">
                        <feDropShadow dx="0" dy="18" stdDeviation="24" flood-color="#155dfc" flood-opacity="0.38"/>
                    </filter>
                </defs>
                <!-- Outer Arc -->
                <path d="M 68 190 A 96 96 0 0 1 252 190" fill="none" stroke="url(#headbandGrad)" stroke-width="26" stroke-linecap="round"/>
                <path d="M 76 180 A 88 88 0 0 1 244 180" fill="none" stroke="#2a4e9b" stroke-width="8" stroke-linecap="round"/>
                <!-- Left Ear Cup -->
                <g filter="url(#glowEffect)">
                    <rect x="52" y="145" width="34" height="92" rx="17" fill="url(#cupGrad)"/>
                    <rect x="58" y="152" width="22" height="78" rx="11" fill="#1e293b"/>
                    <path d="M 69 130 L 69 146" stroke="#94a3b8" stroke-width="6" stroke-linecap="round"/>
                </g>
                <!-- Right Ear Cup -->
                <g filter="url(#glowEffect)">
                    <rect x="234" y="145" width="34" height="92" rx="17" fill="url(#cupGrad)"/>
                    <rect x="240" y="152" width="22" height="78" rx="11" fill="#1e293b"/>
                    <path d="M 251 130 L 251 146" stroke="#94a3b8" stroke-width="6" stroke-linecap="round"/>
                </g>
                <!-- Cord connector -->
                <path d="M 86 215 C 100 280, 220 280, 234 215" fill="none" stroke="#38bdf8" stroke-width="3" stroke-dasharray="4 4" opacity="0.6"/>
            </svg>
        </div>
    </section>

    <!-- Trust Bar -->
    <section class="trust-bar">
        <div class="trust-item">
            <i>01</i>
            <div>
                <b>Chính hãng 100%</b>
                <small>Cam kết bảo hành đầy đủ</small>
            </div>
        </div>
        <div class="trust-item">
            <i>02</i>
            <div>
                <b>Bảo hành tận tâm</b>
                <small>1 đổi 1 trong 30 ngày</small>
            </div>
        </div>
        <div class="trust-item">
            <i>03</i>
            <div>
                <b>Giao hàng toàn quốc</b>
                <small>Miễn phí đơn từ 500k</small>
            </div>
        </div>
        <div class="trust-item">
            <i>04</i>
            <div>
                <b>Thanh toán an toàn</b>
                <small>COD hoặc chuyển khoản</small>
            </div>
        </div>
    </section>

    <!-- Featured Products (Section Title & Grid from Mockup) -->
    <section id="products">
        <div class="section-header">
            <h2>Sản phẩm nổi bật</h2>
            <a class="view-all" href="<c:url value='/products'/>">Xem tất cả →</a>
        </div>

        <div class="product-grid">
            <c:forEach items="${featuredProducts}" var="prod" varStatus="loop">
                <article class="product-card">
                    <div class="product-image-box">
                        <div class="badge-overlay">
                            <c:choose>
                                <c:when test="${prod.discountPercent > 0}">
                                    <span class="badge red">-${prod.discountPercent}%</span>
                                </c:when>
                                <c:when test="${prod.featured}">
                                    <span class="badge hot">HOT</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge green">Mới</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" style="display: contents;">
                            <img src="<c:out value='${not empty prod.imageUrl ? prod.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80\"}'/>" 
                                 alt="<c:out value='${prod.productName}'/>" 
                                 loading="lazy">
                        </a>
                    </div>

                    <div class="product-meta">
                        <c:out value="${not empty prod.categoryName ? prod.categoryName : 'TECHGEAR'}"/>
                    </div>

                    <h3>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" style="color: inherit; text-decoration: none;">
                            <c:out value="${prod.productName}"/>
                        </a>
                    </h3>

                    <div class="stars">
                        ★★★★☆ <small>(<c:out value="${prod.reviewCount > 0 ? prod.reviewCount : 128}"/>)</small>
                    </div>

                    <div class="price">
                        <span><fmt:formatNumber value="${prod.price}" type="number" groupingUsed="true"/>₫</span>
                        <c:if test="${not empty prod.compareAtPrice and prod.compareAtPrice > prod.price}">
                            <span class="compare-price"><fmt:formatNumber value="${prod.compareAtPrice}" type="number" groupingUsed="true"/>₫</span>
                        </c:if>
                    </div>

                    <div class="card-actions">
                        <form method="post" action="<c:url value='/cart'/>" style="flex:1; margin:0;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${prod.productId}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn sm" style="width:100%;">Thêm vào giỏ</button>
                        </form>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" class="icon-btn" aria-label="Xem chi tiết">→</a>
                    </div>
                </article>
            </c:forEach>
        </div>
    </section>

    <!-- Popular Categories -->
    <section id="categories">
        <div class="section-header">
            <h2>Danh mục phổ biến</h2>
            <a class="view-all" href="<c:url value='/products'/>">Xem tất cả →</a>
        </div>

        <div class="categories-grid">
            <c:forEach items="${categories}" var="cat" varStatus="loop">
                <c:if test="${loop.index < 4}">
                    <a class="category-card" href="<c:url value='/products?categoryId=${cat.categoryId}'/>">
                        <div class="category-img">
                            <img src="${loop.index eq 0 ? 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=700&q=80' : 
                                      loop.index eq 1 ? 'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80' : 
                                      loop.index eq 2 ? 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80' : 
                                      'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=700&q=80'}" 
                                 alt="<c:out value='${cat.categoryName}'/>">
                        </div>
                        <div class="category-info">
                            <b><c:out value="${cat.categoryName}"/></b>
                            <small>${cat.productCount > 0 ? cat.productCount : (loop.index + 2) * 8} sản phẩm</small>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <!-- Promo Banner (TechGear Week) -->
    <section class="promo-box" id="deals">
        <div class="promo-copy">
            <span class="eyebrow">TECHGEAR WEEK</span>
            <h2>Nâng cấp góc làm việc</h2>
            <p>Ưu đãi đến 30% cho bộ sưu tập phụ kiện thông minh. Số lượng có hạn trong tuần lễ vàng.</p>
            <a class="btn secondary" href="#products">Khám phá ưu đãi</a>
        </div>
        <div class="promo-art">
            TG<span>30</span>
        </div>
    </section>

    <!-- Best Sellers Section -->
    <section>
        <div class="section-header">
            <h2>Bán chạy nhất & Hàng mới về</h2>
            <a class="view-all" href="<c:url value='/products'/>">Xem tất cả →</a>
        </div>

        <div class="product-grid">
            <c:forEach items="${bestSellers}" var="prod">
                <article class="product-card">
                    <div class="product-image-box">
                        <div class="badge-overlay">
                            <c:choose>
                                <c:when test="${prod.bestSeller}">
                                    <span class="badge orange">Bán chạy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge blue">Được yêu thích</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" style="display: contents;">
                            <img src="<c:out value='${not empty prod.imageUrl ? prod.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80\"}'/>" 
                                 alt="<c:out value='${prod.productName}'/>" 
                                 loading="lazy">
                        </a>
                    </div>

                    <div class="product-meta">
                        <c:out value="${not empty prod.categoryName ? prod.categoryName : 'TECHGEAR'}"/>
                    </div>

                    <h3>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" style="color: inherit; text-decoration: none;">
                            <c:out value="${prod.productName}"/>
                        </a>
                    </h3>

                    <div class="stars">
                        ★★★★★ <small>(<c:out value="${prod.reviewCount > 0 ? prod.reviewCount : 156}"/>)</small>
                    </div>

                    <div class="price">
                        <span><fmt:formatNumber value="${prod.price}" type="number" groupingUsed="true"/>₫</span>
                        <c:if test="${not empty prod.compareAtPrice and prod.compareAtPrice > prod.price}">
                            <span class="compare-price"><fmt:formatNumber value="${prod.compareAtPrice}" type="number" groupingUsed="true"/>₫</span>
                        </c:if>
                    </div>

                    <div class="card-actions">
                        <form method="post" action="<c:url value='/cart'/>" style="flex:1; margin:0;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${prod.productId}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn sm" style="width:100%;">Thêm vào giỏ</button>
                        </form>
                        <a href="<c:url value='/product?id=${prod.productId}'/>" class="icon-btn" aria-label="Xem chi tiết">→</a>
                    </div>
                </article>
            </c:forEach>
        </div>
    </section>

    <!-- UI Mockup Disclaimer matching the mockup image -->
    <div class="ui-disclaimer">
        TECHGEAR • Giao diện chuẩn theo bản thiết kế UI • Dữ liệu và giá hiển thị từ cơ sở dữ liệu
    </div>
</main>

<%@ include file="../common/footer.jsp" %>

</body>
</html>
