<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Sản phẩm"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="products"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
<main class="tg-admin-content tg-admin-main" id="tg-main">
    <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>

    <div class="tg-admin-page-head">
        <div class="tg-page-title">
            <span class="tg-eyebrow">QUẢN LÝ CATALOG</span>
            <h1>Danh sách sản phẩm</h1>
        </div>
        <a class="tg-button" href="<c:url value='/admin/products?action=new'/>">
            + Thêm sản phẩm
        </a>
    </div>

    <c:if test="${param.saved eq '1'}">
        <div class="tg-notice tg-notice-success" role="status">Đã lưu thông tin sản phẩm thành công.</div>
    </c:if>
    <c:if test="${param.deleted eq '1'}">
        <div class="tg-notice tg-notice-success" role="status">Đã cập nhật trạng thái/xóa sản phẩm thành công.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="tg-notice tg-notice-error" role="alert"><c:out value="${error}"/></div>
    </c:if>

    <div class="tg-catalog-tools">
        <form class="tg-search" method="get" action="<c:url value='/admin/products'/>" role="search">
            <label class="tg-sr-only" for="tg-product-search">Tìm kiếm sản phẩm</label>
            <input id="tg-product-search" name="keyword" type="search" maxlength="150" placeholder="Tìm tên, SKU, mô tả..." value="<c:out value='${param.keyword}'/>">
            <button type="submit" aria-label="Tìm kiếm">⌕</button>
        </form>

        <form method="get" action="<c:url value='/admin/products'/>" style="display:flex; gap:10px; align-items:center; margin:0;">
            <c:if test="${not empty param.keyword}">
                <input type="hidden" name="keyword" value="<c:out value='${param.keyword}'/>">
            </c:if>
            <label class="tg-sr-only" for="admin-cat-filter">Lọc theo danh mục</label>
            <select id="admin-cat-filter" name="categoryId" onchange="this.form.submit()">
                <option value="">Tất cả danh mục</option>
                <c:forEach items="${categories}" var="cat">
                    <option value="${cat.categoryId}" ${param.categoryId eq cat.categoryId ? 'selected' : ''}>
                        <c:out value="${cat.categoryName}"/>
                    </option>
                </c:forEach>
            </select>

            <label class="tg-sr-only" for="admin-brand-filter">Lọc theo thương hiệu</label>
            <select id="admin-brand-filter" name="brandId" onchange="this.form.submit()">
                <option value="">Tất cả thương hiệu</option>
                <c:forEach items="${brands}" var="brand">
                    <option value="${brand.brandId}" ${param.brandId eq brand.brandId ? 'selected' : ''}>
                        <c:out value="${brand.brandName}"/>
                    </option>
                </c:forEach>
            </select>
        </form>

        <c:if test="${not empty param.keyword or not empty param.categoryId or not empty param.brandId}">
            <a class="tg-action-link" href="<c:url value='/admin/products'/>">✕ Đặt lại lọc</a>
        </c:if>
    </div>

    <section class="tg-panel tg-table-panel" aria-labelledby="tg-prod-list-title">
        <div class="tg-panel-title">
            <h2 id="tg-prod-list-title">Danh sách sản phẩm</h2>
            <span class="tg-muted"><c:out value="${fn:length(products)}"/> sản phẩm</span>
        </div>
        <div class="tg-table-wrap" tabindex="0" role="region" aria-label="Bảng danh sách sản phẩm">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Sản phẩm</th>
                        <th scope="col">Danh mục</th>
                        <th scope="col">Thương hiệu</th>
                        <th scope="col">Giá bán</th>
                        <th scope="col">Tồn kho</th>
                        <th scope="col">Trạng thái</th>
                        <th scope="col" style="width: 170px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <td>
                                <div class="tg-table-product">
                                    <img class="tg-table-thumb" 
                                         src="<c:out value='${not empty p.imageUrl ? p.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=100&q=80\"}'/>" 
                                         alt="<c:out value='${p.productName}'/>" 
                                         loading="lazy">
                                    <div>
                                        <b><c:out value="${p.productName}"/></b>
                                        <small class="tg-muted">SKU: <c:out value="${p.sku}"/></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="tg-badge tg-neutral"><c:out value="${p.categoryName}"/></span>
                            </td>
                            <td>
                                <b><c:out value="${p.brandName}"/></b>
                            </td>
                            <td>
                                <strong style="color: var(--tg-blue); font-size: 13.5px;">
                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stockQuantity <= 5}">
                                        <span class="tg-badge tg-red" title="Sắp hết hàng"><c:out value="${p.stockQuantity}"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span><c:out value="${p.stockQuantity}"/></span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="tg-badge ${p.active ? 'tg-green' : 'tg-red'}">
                                    ${p.active ? 'Đang bán' : 'Ngừng bán'}
                                </span>
                            </td>
                            <td>
                                <div class="tg-admin-actions">
                                    <a class="tg-row-action" href="<c:url value='/admin/products?action=edit&id=${p.productId}'/>">
                                        Sửa <span aria-hidden="true">↗</span>
                                    </a>
                                    
                                    <form method="post" action="<c:url value='/admin/products'/>" style="display:inline; margin:0;">
                                        <input type="hidden" name="action" value="toggle">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <input type="hidden" name="active" value="${p.active ? 'false' : 'true'}">
                                        <button class="tg-row-action" type="submit" title="${p.active ? 'Tạm ẩn khỏi cửa hàng' : 'Hiển thị lại trên cửa hàng'}">
                                            ${p.active ? 'Ẩn' : 'Hiện'}
                                        </button>
                                    </form>

                                    <form method="post" action="<c:url value='/admin/products'/>" style="display:inline; margin:0;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button class="tg-row-action tg-action-danger" type="submit">Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="7" class="tg-empty-state">Không tìm thấy sản phẩm nào phù hợp với bộ lọc.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>
</div>
<%@ include file="../auth/_figma-end.jspf" %>
