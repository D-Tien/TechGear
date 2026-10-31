<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty product}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="products"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
<main class="tg-admin-content tg-admin-main" id="tg-main">
    <a class="tg-back" href="<c:url value='/admin/products'/>">← Quay lại danh sách sản phẩm</a>

    <div class="tg-admin-page-head">
        <div class="tg-page-title">
            <span class="tg-eyebrow">SẢN PHẨM / ${isEdit ? 'CHỈNH SỬA' : 'THÊM MỚI'}</span>
            <h1>${isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'}</h1>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="tg-notice tg-notice-error" role="alert"><c:out value="${error}"/></div>
    </c:if>

    <form class="tg-form" method="post" action="<c:url value='/admin/products'/>">
        <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
        <c:if test="${isEdit}">
            <input type="hidden" name="productId" value="${product.productId}">
        </c:if>

        <div class="tg-form-layout">
            <!-- Cột trái: Thông tin cơ bản -->
            <div class="tg-form-card">
                <h2>Thông tin sản phẩm</h2>
                <div class="tg-form-grid">
                    <div class="tg-field tg-wide">
                        <label for="p-name">Tên sản phẩm *</label>
                        <input id="p-name" name="productName" type="text" required maxlength="200" 
                               placeholder="Ví dụ: Bàn phím cơ KeyPro 75 RGB..." 
                               value="<c:out value='${product.productName}'/>" autocomplete="off">
                    </div>

                    <div class="tg-field">
                        <label for="p-category">Danh mục *</label>
                        <select id="p-category" name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}" ${product.categoryId eq cat.categoryId ? 'selected' : ''}>
                                    <c:out value="${cat.categoryName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="tg-field">
                        <label for="p-brand">Thương hiệu *</label>
                        <select id="p-brand" name="brandId" required>
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach items="${brands}" var="brand">
                                <option value="${brand.brandId}" ${product.brandId eq brand.brandId ? 'selected' : ''}>
                                    <c:out value="${brand.brandName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="tg-field">
                        <label for="p-price">Giá bán (₫) *</label>
                        <input id="p-price" name="price" type="number" step="1000" min="0" required 
                               placeholder="Ví dụ: 1290000" 
                               value="${product.price}">
                    </div>

                    <div class="tg-field">
                        <label for="p-compare-price">Giá gốc so sánh (₫) <span class="tg-optional">(không bắt buộc)</span></label>
                        <input id="p-compare-price" name="compareAtPrice" type="number" step="1000" min="0" 
                               placeholder="Ví dụ: 1590000 (để gạch ngang giảm giá)" 
                               value="${product.compareAtPrice}">
                    </div>

                    <div class="tg-field">
                        <label for="p-stock">Số lượng tồn kho *</label>
                        <input id="p-stock" name="stockQuantity" type="number" min="0" required 
                               placeholder="Ví dụ: 25" 
                               value="${isEdit ? product.stockQuantity : 20}">
                    </div>

                    <div class="tg-field">
                        <label for="p-sku">Mã SKU <span class="tg-optional">(tự tạo nếu để trống)</span></label>
                        <input id="p-sku" name="sku" type="text" maxlength="50" 
                               placeholder="Ví dụ: TG-KB-001" 
                               value="<c:out value='${product.sku}'/>" autocomplete="off">
                    </div>

                    <div class="tg-field tg-wide">
                        <label for="p-short-desc">Mô tả ngắn gọn</label>
                        <input id="p-short-desc" name="shortDescription" type="text" maxlength="500" 
                               placeholder="Tóm tắt tính năng chính 1-2 câu..." 
                               value="<c:out value='${product.shortDescription}'/>" autocomplete="off">
                    </div>

                    <div class="tg-field tg-wide">
                        <label for="p-desc">Mô tả chi tiết</label>
                        <textarea id="p-desc" name="description" rows="5" 
                                  placeholder="Mô tả chi tiết thông số, thiết kế và trải nghiệm sử dụng..."><c:out value='${product.description}'/></textarea>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Hình ảnh & Trạng thái -->
            <div style="display:flex; flex-direction:column; gap:20px;">
                <div class="tg-form-card">
                    <h2>Hình ảnh sản phẩm</h2>
                    <div class="tg-field" style="margin-bottom:14px;">
                        <label for="p-image">URL ảnh sản phẩm</label>
                        <input id="p-image" name="imageUrl" type="url" maxlength="1000" 
                               placeholder="https://images.unsplash.com/..." 
                               value="<c:out value='${product.imageUrl}'/>"
                               oninput="document.getElementById('image-preview').src = this.value">
                    </div>
                    <div style="border:1px dashed var(--tg-line); border-radius:10px; padding:10px; background:#f8fafc; text-align:center;">
                        <img id="image-preview" 
                             src="<c:out value='${not empty product.imageUrl ? product.imageUrl : \"https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=400&q=80\"}'/>" 
                             alt="Xem trước ảnh" 
                             style="max-width:100%; max-height:160px; margin:auto; object-fit:contain; border-radius:8px;"
                             onerror="this.src='https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=400&q=80'">
                        <small class="tg-muted" style="display:block; margin-top:6px;">Ảnh xem trước</small>
                    </div>
                </div>

                <div class="tg-form-card">
                    <h2>Cài đặt & Hiển thị</h2>
                    <div style="display:flex; flex-direction:column; gap:12px;">
                        <label class="tg-checkbox">
                            <input type="checkbox" name="active" value="true" ${!isEdit or product.active ? 'checked' : ''}>
                            <b>Cho phép bán trên cửa hàng</b>
                        </label>
                        <label class="tg-checkbox">
                            <input type="checkbox" name="isFeatured" value="true" ${product.featured ? 'checked' : ''}>
                            <span>Hiển thị ở mục "Sản phẩm nổi bật"</span>
                        </label>
                        <label class="tg-checkbox">
                            <input type="checkbox" name="isBestSeller" value="true" ${product.bestSeller ? 'checked' : ''}>
                            <span>Đánh dấu "Bán chạy nhất"</span>
                        </label>
                        <label class="tg-checkbox">
                            <input type="checkbox" name="isNewArrival" value="true" ${product.newArrival ? 'checked' : ''}>
                            <span>Đánh dấu "Hàng mới về"</span>
                        </label>
                    </div>

                    <div style="margin-top:24px; display:flex; flex-direction:column; gap:10px;">
                        <button class="tg-button" type="submit" style="width:100%;">
                            ${isEdit ? 'Cập nhật sản phẩm' : 'Lưu sản phẩm mới'}
                        </button>
                        <a class="tg-button tg-secondary" href="<c:url value='/admin/products'/>" style="width:100%;">
                            Hủy bỏ
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</main>
</div>
<%@ include file="../auth/_figma-end.jspf" %>
