<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${not empty product.productName ? product.productName : 'Chi tiết sản phẩm'}"/> – TechGear</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body class="tg-product-page">

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<main class="container">
    <!-- Breadcrumbs -->
    <nav class="tg-breadcrumb" aria-label="Đường dẫn điều hướng">
        <a href="<c:url value='/home'/>">Trang chủ</a>
        <span class="sep">/</span>
        <a href="<c:url value='/products'/>">Sản phẩm</a>
        <c:if test="${not empty product.categoryName}">
            <span class="sep">/</span>
            <a href="<c:url value='/products?categoryId=${product.categoryId}'/>"><c:out value="${product.categoryName}"/></a>
        </c:if>
        <span class="sep">/</span>
        <span class="current"><c:out value="${product.productName}"/></span>
    </nav>

    <!-- Main Detail Layout -->
    <section class="product-detail-layout">
        <!-- Visual Gallery Column -->
        <div class="detail-gallery">
            <div class="detail-main-img-box">
                <div class="badge-overlay">
                    <c:choose>
                        <c:when test="${product.discountPercent > 0}">
                            <span class="badge red">-${product.discountPercent}%</span>
                        </c:when>
                        <c:when test="${product.featured}">
                            <span class="badge hot">HOT</span>
                        </c:when>
                        <c:when test="${product.bestSeller}">
                            <span class="badge orange">Bán chạy</span>
                        </c:when>
                    </c:choose>
                    <c:if test="${product.newArrival}">
                        <span class="badge green">Mới</span>
                    </c:if>
                </div>
                <img id="mainProductImg"
                     src="<c:out value='${not empty product.imageUrl ? product.imageUrl : \"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80\"}'/>" 
                     alt="<c:out value='${product.productName}'/>">
            </div>

            <!-- Guarantee Badges -->
            <div class="detail-guarantees">
                <div class="detail-guarantee-item">
                    <span class="icon">🛡</span>
                    <div>
                        <b>Bảo hành ${product.warrantyMonths > 0 ? product.warrantyMonths : 12} tháng</b>
                        <small>Chính hãng 100%</small>
                    </div>
                </div>
                <div class="detail-guarantee-item">
                    <span class="icon">🔄</span>
                    <div>
                        <b>1 đổi 1 trong 30 ngày</b>
                        <small>Lỗi do nhà sản xuất</small>
                    </div>
                </div>
                <div class="detail-guarantee-item">
                    <span class="icon">🚚</span>
                    <div>
                        <b>Giao toàn quốc</b>
                        <small>Freeship đơn từ 500k</small>
                    </div>
                </div>
                <div class="detail-guarantee-item">
                    <span class="icon">💳</span>
                    <div>
                        <b>Thanh toán COD</b>
                        <small>Kiểm tra khi nhận hàng</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Info & Actions Column -->
        <div class="detail-info">
            <div class="detail-tags">
                <c:if test="${not empty product.categoryName}">
                    <span class="detail-tag"><c:out value="${product.categoryName}"/></span>
                </c:if>
                <c:if test="${not empty product.brandName}">
                    <span class="detail-tag brand"><c:out value="${product.brandName}"/></span>
                </c:if>
                <c:if test="${not empty product.sku}">
                    <span class="detail-tag brand">SKU: <c:out value="${product.sku}"/></span>
                </c:if>
            </div>

            <h1><c:out value="${product.productName}"/></h1>

            <div class="detail-meta-bar">
                <div class="detail-stars">
                    ★★★★★
                    <span class="score"><c:out value="${product.averageRating != null ? product.averageRating : '4.8'}"/></span>
                </div>
                <span>•</span>
                <span><c:out value="${product.reviewCount > 0 ? product.reviewCount : 128}"/> đánh giá</span>
                <span>•</span>
                <c:choose>
                    <c:when test="${product.stockQuantity > 0}">
                        <span class="detail-stock-badge in-stock">● Còn hàng (${product.stockQuantity} sản phẩm)</span>
                    </c:when>
                    <c:otherwise>
                        <span class="detail-stock-badge out-of-stock">● Tạm hết hàng</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Price Box -->
            <div class="detail-price-box">
                <span class="main-price">
                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
                </span>
                <c:if test="${not empty product.compareAtPrice and product.compareAtPrice > product.price}">
                    <span class="compare-price">
                        <fmt:formatNumber value="${product.compareAtPrice}" type="number" groupingUsed="true"/>₫
                    </span>
                    <span class="save-badge">
                        Tiết kiệm ${product.discountPercent}%
                    </span>
                </c:if>
            </div>

            <!-- Short Description -->
            <div class="detail-short-desc">
                <c:choose>
                    <c:when test="${not empty product.shortDescription}">
                        <p><c:out value="${product.shortDescription}"/></p>
                    </c:when>
                    <c:otherwise>
                        <p>Trải nghiệm công nghệ đỉnh cao cùng sản phẩm chính hãng TechGear. Thiết kế công thái học hiện đại, hiệu năng ổn định, đáp ứng hoàn hảo cho nhu cầu công việc và giải trí.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Add to Cart / Buy Form -->
            <form class="detail-actions-form" method="post" action="<c:url value='/cart'/>">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="qty-control-row">
                    <label for="detailQuantity">Số lượng:</label>
                    <div class="qty-picker">
                        <button type="button" id="btnMinus" aria-label="Giảm số lượng">−</button>
                        <input type="number" id="detailQuantity" name="quantity" value="1" min="1" max="${product.stockQuantity > 0 ? product.stockQuantity : 99}">
                        <button type="button" id="btnPlus" aria-label="Tăng số lượng">+</button>
                    </div>
                    <small style="color: var(--muted);">(Tối đa ${product.stockQuantity > 0 ? product.stockQuantity : 99} sản phẩm)</small>
                </div>

                <div class="detail-btn-group">
                    <button type="submit" class="btn-add-cart" ${product.stockQuantity == 0 ? 'disabled' : ''}>
                        🛒 Thêm vào giỏ
                    </button>
                    <button type="submit" name="buyNow" value="true" class="btn-buy-now" ${product.stockQuantity == 0 ? 'disabled' : ''}>
                        ⚡ Mua ngay
                    </button>
                </div>
            </form>
        </div>
    </section>

    <!-- Details & Specifications Tabs -->
    <section class="detail-content-tabs">
        <div class="tabs-nav" role="tablist">
            <button class="tab-btn active" type="button" onclick="switchTab(event, 'tab-desc')">Mô tả sản phẩm</button>
            <button class="tab-btn" type="button" onclick="switchTab(event, 'tab-specs')">Thông số kỹ thuật</button>
            <button class="tab-btn" type="button" onclick="switchTab(event, 'tab-policy')">Chính sách bảo hành</button>
        </div>

        <div id="tab-desc" class="tab-pane active">
            <c:choose>
                <c:when test="${not empty product.description}">
                    <div style="white-space: pre-line;"><c:out value="${product.description}"/></div>
                </c:when>
                <c:otherwise>
                    <p>Sản phẩm <strong><c:out value="${product.productName}"/></strong> được TechGear phân phối chính hãng, đầy đủ hóa đơn VAT và chế độ bảo hành chuẩn quốc tế.</p>
                    <p>Được hoàn thiện từ những vật liệu cao cấp, mang lại độ bền cơ học cao, chịu lực tốt và cảm giác cầm nắm đầm tay, chắc chắn. Thích hợp cho cả người dùng làm việc văn phòng, sáng tạo nội dung lẫn game thủ chuyên nghiệp.</p>
                    <p>Mọi thắc mắc kỹ thuật hoặc hướng dẫn sử dụng, quý khách vui lòng liên hệ hotline hỗ trợ 24/7 của TechGear: <strong>1900 6868</strong>.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="tab-specs" class="tab-pane">
            <table class="specs-table">
                <tbody>
                    <tr>
                        <td>Thương hiệu</td>
                        <td><c:out value="${not empty product.brandName ? product.brandName : 'TechGear Official'}"/></td>
                    </tr>
                    <tr>
                        <td>Danh mục</td>
                        <td><c:out value="${not empty product.categoryName ? product.categoryName : 'Phụ kiện công nghệ'}"/></td>
                    </tr>
                    <tr>
                        <td>Mã sản phẩm (SKU)</td>
                        <td><c:out value="${not empty product.sku ? product.sku : 'TG-PROD-'}"/>${product.productId}</td>
                    </tr>
                    <tr>
                        <td>Thời gian bảo hành</td>
                        <td>${product.warrantyMonths > 0 ? product.warrantyMonths : 12} tháng chính hãng</td>
                    </tr>
                    <tr>
                        <td>Tình trạng hàng</td>
                        <td>${product.stockQuantity > 0 ? 'Còn hàng trong kho' : 'Đặt trước'}</td>
                    </tr>
                    <c:if test="${not empty product.specifications}">
                        <tr>
                            <td>Thông số chi tiết</td>
                            <td style="white-space: pre-line;"><c:out value="${product.specifications}"/></td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div id="tab-policy" class="tab-pane">
            <h4>Chính sách bảo hành & dịch vụ tại TechGear</h4>
            <ul style="line-height: 2; margin-top: 12px; color: #475569;">
                <li>Cam kết 100% hàng chính hãng, nguyên seal, đầy đủ phụ kiện từ nhà sản xuất.</li>
                <li>Bảo hành 1 đổi 1 trong vòng 30 ngày nếu phát sinh lỗi kỹ thuật từ phần cứng.</li>
                <li>Hỗ trợ sửa chữa, thay thế linh kiện chính hãng trọn đời sản phẩm.</li>
                <li>Giao hàng nhanh toàn quốc, cho phép đồng kiểm hàng trước khi thanh toán.</li>
            </ul>
        </div>
    </section>

    <!-- Related Products -->
    <c:if test="${not empty relatedProducts}">
        <section class="related-section">
            <div class="section-header">
                <h2>Sản phẩm liên quan</h2>
                <a class="view-all" href="<c:url value='/products'/>">Xem tất cả →</a>
            </div>

            <div class="product-grid">
                <c:forEach items="${relatedProducts}" var="rel">
                    <article class="product-card">
                        <div class="product-image-box">
                            <div class="badge-overlay">
                                <c:if test="${rel.discountPercent > 0}">
                                    <span class="badge red">-${rel.discountPercent}%</span>
                                </c:if>
                            </div>
                            <img src="<c:out value='${not empty rel.imageUrl ? rel.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80\"}'/>" 
                                 alt="<c:out value='${rel.productName}'/>" loading="lazy">
                        </div>

                        <div class="product-meta">
                            <c:out value="${not empty rel.categoryName ? rel.categoryName : 'TECHGEAR'}"/>
                        </div>

                        <h3><c:out value="${rel.productName}"/></h3>

                        <div class="stars">
                            ★★★★☆ <small>(<c:out value="${rel.reviewCount > 0 ? rel.reviewCount : 88}"/>)</small>
                        </div>

                        <div class="price">
                            <span><fmt:formatNumber value="${rel.price}" type="number" groupingUsed="true"/>₫</span>
                            <c:if test="${not empty rel.compareAtPrice and rel.compareAtPrice > rel.price}">
                                <span class="compare-price"><fmt:formatNumber value="${rel.compareAtPrice}" type="number" groupingUsed="true"/>₫</span>
                            </c:if>
                        </div>

                        <div class="card-actions">
                            <form method="post" action="<c:url value='/cart'/>" style="flex:1; margin:0;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${rel.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn sm" style="width:100%;">Thêm vào giỏ</button>
                            </form>
                            <a href="<c:url value='/product?id=${rel.productId}'/>" class="icon-btn" aria-label="Xem chi tiết">→</a>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>

<%@ include file="../common/footer.jsp" %>

<script>
    // Tab switching
    function switchTab(evt, tabId) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        evt.currentTarget.classList.add('active');
        const target = document.getElementById(tabId);
        if (target) target.classList.add('active');
    }

    // Quantity controls
    document.addEventListener('DOMContentLoaded', function() {
        const minusBtn = document.getElementById('btnMinus');
        const plusBtn = document.getElementById('btnPlus');
        const qtyInput = document.getElementById('detailQuantity');

        if (minusBtn && plusBtn && qtyInput) {
            minusBtn.addEventListener('click', function() {
                let val = parseInt(qtyInput.value) || 1;
                if (val > 1) {
                    qtyInput.value = val - 1;
                }
            });

            plusBtn.addEventListener('click', function() {
                let val = parseInt(qtyInput.value) || 1;
                let max = parseInt(qtyInput.getAttribute('max')) || 99;
                if (val < max) {
                    qtyInput.value = val + 1;
                }
            });
        }
    });
</script>

</body>
</html>
