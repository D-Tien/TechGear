<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm – TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body class="tg-product-page">

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<main class="container">
    <!-- Breadcrumb -->
    <nav class="tg-breadcrumb" aria-label="Đường dẫn">
        <a href="<c:url value='/home'/>">Trang chủ</a>
        <span class="sep">/</span>
        <span class="current">Cửa hàng sản phẩm</span>
        <c:if test="${not empty keyword}">
            <span class="sep">/</span>
            <span class="current">Tìm kiếm: "<c:out value='${keyword}'/>"</span>
        </c:if>
    </nav>

    <div class="catalog-layout">
        <!-- Sidebar Filters -->
        <aside class="filters-sidebar">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                <h3 style="margin: 0;">Bộ lọc sản phẩm</h3>
                <a href="<c:url value='/products'/>" style="font-size: 12px; color: var(--blue); text-decoration: none; font-weight: 600;">Xóa tất cả</a>
            </div>

            <form id="filterForm" method="get" action="<c:url value='/products'/>">
                <!-- Keep search keyword & sort when filtering -->
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>">
                </c:if>
                <input type="hidden" name="sortBy" value="<c:out value='${sortBy}'/>">

                <!-- Categories -->
                <div class="filter-group">
                    <span class="filter-title">Danh mục</span>
                    <label class="filter-option">
                        <input type="radio" name="categoryId" value="" ${empty selectedCategory ? 'checked' : ''} onchange="this.form.submit()">
                        <span>Tất cả danh mục</span>
                    </label>
                    <c:forEach items="${categories}" var="cat">
                        <label class="filter-option">
                            <input type="radio" name="categoryId" value="${cat.categoryId}" ${selectedCategory == cat.categoryId ? 'checked' : ''} onchange="this.form.submit()">
                            <span><c:out value="${cat.categoryName}"/></span>
                            <c:if test="${cat.productCount > 0}">
                                <small style="color: var(--muted); margin-left: auto;">(${cat.productCount})</small>
                            </c:if>
                        </label>
                    </c:forEach>
                </div>

                <!-- Brands -->
                <c:if test="${not empty brands}">
                    <div class="filter-group">
                        <span class="filter-title">Thương hiệu</span>
                        <label class="filter-option">
                            <input type="radio" name="brandId" value="" ${empty selectedBrand ? 'checked' : ''} onchange="this.form.submit()">
                            <span>Tất cả thương hiệu</span>
                        </label>
                        <c:forEach items="${brands}" var="b">
                            <label class="filter-option">
                                <input type="radio" name="brandId" value="${b.brandId}" ${selectedBrand == b.brandId ? 'checked' : ''} onchange="this.form.submit()">
                                <span><c:out value="${b.brandName}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Price Range Presets -->
                <div class="filter-group">
                    <span class="filter-title">Khoảng giá</span>
                    <label class="filter-option">
                        <input type="radio" name="priceRange" value="" ${empty priceRange ? 'checked' : ''} onchange="this.form.submit()">
                        <span>Tất cả mức giá</span>
                    </label>
                    <label class="filter-option">
                        <input type="radio" name="priceRange" value="under-500k" ${priceRange eq 'under-500k' ? 'checked' : ''} onchange="this.form.submit()">
                        <span>Dưới 500.000₫</span>
                    </label>
                    <label class="filter-option">
                        <input type="radio" name="priceRange" value="500k-1m" ${priceRange eq '500k-1m' ? 'checked' : ''} onchange="this.form.submit()">
                        <span>500.000₫ – 1.000.000₫</span>
                    </label>
                    <label class="filter-option">
                        <input type="radio" name="priceRange" value="1m-2m" ${priceRange eq '1m-2m' ? 'checked' : ''} onchange="this.form.submit()">
                        <span>1.000.000₫ – 2.000.000₫</span>
                    </label>
                    <label class="filter-option">
                        <input type="radio" name="priceRange" value="over-2m" ${priceRange eq 'over-2m' ? 'checked' : ''} onchange="this.form.submit()">
                        <span>Trên 2.000.000₫</span>
                    </label>
                </div>

                <!-- In Stock Only -->
                <div class="filter-group">
                    <span class="filter-title">Tình trạng kho</span>
                    <label class="filter-option">
                        <input type="checkbox" name="inStock" value="true" ${inStockOnly ? 'checked' : ''} onchange="this.form.submit()">
                        <span>Chỉ hiện hàng có sẵn</span>
                    </label>
                </div>

                <noscript>
                    <button type="submit" class="btn sm primary" style="width: 100%; margin-top: 10px;">Áp dụng</button>
                </noscript>
            </form>
        </aside>

        <!-- Catalog Main Area -->
        <section class="catalog-main">
            <!-- Toolbar -->
            <div class="catalog-toolbar">
                <div class="catalog-count">
                    Tìm thấy <b>${totalCount}</b> sản phẩm
                    <c:if test="${not empty keyword}">
                        cho từ khóa "<b><c:out value='${keyword}'/></b>"
                    </c:if>
                </div>

                <div class="catalog-sort">
                    <label for="sortSelect">Sắp xếp:</label>
                    <select id="sortSelect" onchange="applySort(this.value)">
                        <option value="newest" ${sortBy eq 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="price_asc" ${sortBy eq 'price_asc' ? 'selected' : ''}>Giá: Thấp đến cao</option>
                        <option value="price_desc" ${sortBy eq 'price_desc' ? 'selected' : ''}>Giá: Cao đến thấp</option>
                        <option value="rating" ${sortBy eq 'rating' ? 'selected' : ''}>Đánh giá cao nhất</option>
                        <option value="bestseller" ${sortBy eq 'bestseller' ? 'selected' : ''}>Bán chạy nhất</option>
                    </select>
                </div>
            </div>

            <!-- Active Filter Chips -->
            <c:if test="${not empty keyword or not empty selectedCategory or not empty selectedBrand or not empty priceRange or inStockOnly}">
                <div class="filter-chips">
                    <span style="font-size: 13px; color: var(--muted); font-weight: 600;">Đang lọc:</span>
                    <c:if test="${not empty keyword}">
                        <span class="chip">Từ khóa: "${keyword}" <a href="<c:url value='/products?categoryId=${selectedCategory}&brandId=${selectedBrand}&priceRange=${priceRange}&inStock=${inStockOnly}&sortBy=${sortBy}'/>" class="remove-chip">×</a></span>
                    </c:if>
                    <c:if test="${not empty priceRange}">
                        <span class="chip">Mức giá <a href="<c:url value='/products?keyword=${keyword}&categoryId=${selectedCategory}&brandId=${selectedBrand}&inStock=${inStockOnly}&sortBy=${sortBy}'/>" class="remove-chip">×</a></span>
                    </c:if>
                    <c:if test="${inStockOnly}">
                        <span class="chip">Còn hàng <a href="<c:url value='/products?keyword=${keyword}&categoryId=${selectedCategory}&brandId=${selectedBrand}&priceRange=${priceRange}&sortBy=${sortBy}'/>" class="remove-chip">×</a></span>
                    </c:if>
                    <a href="<c:url value='/products'/>" class="chip clear-all">Xóa bộ lọc</a>
                </div>
            </c:if>

            <!-- Product Cards Grid -->
            <c:choose>
                <c:when test="${empty products}">
                    <div class="empty-catalog">
                        <span class="empty-icon">🔍</span>
                        <h3>Không tìm thấy sản phẩm phù hợp</h3>
                        <p>Hãy thử thay đổi từ khóa tìm kiếm hoặc bỏ chọn một số tiêu chí bộ lọc.</p>
                        <a href="<c:url value='/products'/>" class="btn primary">Xem tất cả sản phẩm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="product-grid">
                        <c:forEach items="${products}" var="prod">
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
                                            <c:when test="${prod.bestSeller}">
                                                <span class="badge orange">Bán chạy</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <img src="<c:out value='${not empty prod.imageUrl ? prod.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80\"}'/>" 
                                         alt="<c:out value='${prod.productName}'/>" 
                                         loading="lazy">
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
                                        <button type="submit" class="btn sm" style="width:100%;" ${prod.stockQuantity == 0 ? 'disabled' : ''}>Thêm vào giỏ</button>
                                    </form>
                                    <a href="<c:url value='/product?id=${prod.productId}'/>" class="icon-btn" aria-label="Xem chi tiết">→</a>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="<c:url value='/products?page=${currentPage - 1}&keyword=${keyword}&categoryId=${selectedCategory}&brandId=${selectedBrand}&priceRange=${priceRange}&inStock=${inStockOnly}&sortBy=${sortBy}'/>" aria-label="Trang trước">←</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="current">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/products?page=${i}&keyword=${keyword}&categoryId=${selectedCategory}&brandId=${selectedBrand}&priceRange=${priceRange}&inStock=${inStockOnly}&sortBy=${sortBy}'/>">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="<c:url value='/products?page=${currentPage + 1}&keyword=${keyword}&categoryId=${selectedCategory}&brandId=${selectedBrand}&priceRange=${priceRange}&inStock=${inStockOnly}&sortBy=${sortBy}'/>" aria-label="Trang sau">→</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<%@ include file="../common/footer.jsp" %>

<script>
    function applySort(val) {
        const url = new URL(window.location.href);
        url.searchParams.set('sortBy', val);
        url.searchParams.set('page', '1');
        window.location.href = url.toString();
    }
</script>

</body>
</html>
