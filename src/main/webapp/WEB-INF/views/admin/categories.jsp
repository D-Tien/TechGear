<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Danh mục"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="categories"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
<main class="tg-admin-content tg-admin-main" id="tg-main">
    <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>
    
    <div class="tg-admin-page-head">
        <div class="tg-page-title">
            <span class="tg-eyebrow">QUẢN LÝ CATALOG</span>
            <h1>Danh mục sản phẩm</h1>
        </div>
        <button class="tg-button" type="button" data-dialog-target="tg-add-category">
            + Thêm danh mục
        </button>
    </div>

    <c:if test="${param.saved eq '1'}">
        <div class="tg-notice tg-notice-success" role="status">Đã lưu thay đổi danh mục thành công.</div>
    </c:if>
    <c:if test="${param.deleted eq '1'}">
        <div class="tg-notice tg-notice-success" role="status">Đã xóa danh mục thành công.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="tg-notice tg-notice-error" role="alert"><c:out value="${error}"/></div>
    </c:if>

    <div class="tg-catalog-tools">
        <form class="tg-search" method="get" action="<c:url value='/admin/categories'/>" role="search">
            <label class="tg-sr-only" for="tg-cat-search">Tìm kiếm danh mục</label>
            <input id="tg-cat-search" name="keyword" type="search" maxlength="100" placeholder="Tìm tên hoặc mô tả danh mục..." value="<c:out value='${param.keyword}'/>">
            <button type="submit" aria-label="Tìm kiếm">⌕</button>
        </form>
        <c:if test="${not empty param.keyword}">
            <a class="tg-action-link" href="<c:url value='/admin/categories'/>">✕ Xóa tìm kiếm</a>
        </c:if>
    </div>

    <section class="tg-panel tg-table-panel" aria-labelledby="tg-cat-list-title">
        <div class="tg-panel-title">
            <h2 id="tg-cat-list-title">Danh sách danh mục</h2>
            <span class="tg-muted"><c:out value="${fn:length(categories)}"/> danh mục</span>
        </div>
        <div class="tg-table-wrap" tabindex="0" role="region" aria-label="Danh sách danh mục">
            <table>
                <thead>
                    <tr>
                        <th scope="col" style="width: 80px;">Mã DM</th>
                        <th scope="col">Tên danh mục</th>
                        <th scope="col">Mô tả</th>
                        <th scope="col">Số sản phẩm</th>
                        <th scope="col" style="width: 170px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${categories}" var="cat">
                        <tr>
                            <td><strong>#<c:out value="${cat.categoryId}"/></strong></td>
                            <td>
                                <b><c:out value="${cat.categoryName}"/></b>
                            </td>
                            <td>
                                <span class="tg-muted"><c:out value="${not empty cat.description ? cat.description : '—'}"/></span>
                            </td>
                            <td>
                                <a href="<c:url value='/admin/products?categoryId=${cat.categoryId}'/>" class="tg-badge ${cat.productCount > 0 ? 'tg-blue' : 'tg-neutral'}" title="Xem các sản phẩm">
                                    <c:out value="${cat.productCount}"/> sản phẩm
                                </a>
                            </td>
                            <td>
                                <div class="tg-admin-actions">
                                    <button class="tg-row-action" type="button" data-dialog-target="tg-edit-cat-${cat.categoryId}">
                                        Sửa <span aria-hidden="true">↗</span>
                                    </button>
                                    <c:choose>
                                        <c:when test="${cat.productCount eq 0}">
                                            <form method="post" action="<c:url value='/admin/categories'/>" style="display:inline; margin:0;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">
                                                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                                <button class="tg-row-action" style="color: #e11d48;" type="submit">Xóa</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="tg-muted" style="font-size: 11px;" title="Danh mục có sản phẩm không thể xóa">(Đang dùng)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="5" class="tg-empty-state">Chưa có danh mục nào hoặc không tìm thấy kết quả.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Dialog Thêm mới danh mục -->
    <dialog class="tg-dialog" id="tg-add-category" aria-labelledby="tg-add-cat-title">
        <div class="tg-dialog-heading">
            <h2 id="tg-add-cat-title">Thêm danh mục mới</h2>
            <button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng biểu mẫu">×</button>
        </div>
        <p class="tg-muted">Tạo danh mục mới để phân loại và quản lý sản phẩm trong cửa hàng.</p>
        <form class="tg-form" method="post" action="<c:url value='/admin/categories'/>">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <input type="hidden" name="action" value="create">
            <div class="tg-field">
                <label for="new-categoryName">Tên danh mục *</label>
                <input id="new-categoryName" name="categoryName" type="text" required maxlength="100" placeholder="Ví dụ: Bàn phím cơ, Tai nghe không dây..." autocomplete="off">
            </div>
            <div class="tg-field">
                <label for="new-description">Mô tả danh mục</label>
                <input id="new-description" name="description" type="text" maxlength="500" placeholder="Mô tả ngắn gọn về nhóm sản phẩm này..." autocomplete="off">
            </div>
            <div class="tg-dialog-actions">
                <button class="tg-button tg-secondary" type="button" data-dialog-close>Hủy</button>
                <button class="tg-button" type="submit">Tạo danh mục</button>
            </div>
        </form>
    </dialog>

    <!-- Dialogs Chỉnh sửa từng danh mục -->
    <c:forEach items="${categories}" var="cat">
        <dialog class="tg-dialog" id="tg-edit-cat-${cat.categoryId}" aria-labelledby="tg-edit-title-${cat.categoryId}">
            <div class="tg-dialog-heading">
                <h2 id="tg-edit-title-${cat.categoryId}">Chỉnh sửa danh mục</h2>
                <button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng biểu mẫu">×</button>
            </div>
            <p class="tg-muted">Danh mục #<c:out value="${cat.categoryId}"/> · Hiện có <c:out value="${cat.productCount}"/> sản phẩm</p>
            <form class="tg-form" method="post" action="<c:url value='/admin/categories'/>">
                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="categoryId" value="${cat.categoryId}">
                <div class="tg-field">
                    <label for="edit-categoryName-${cat.categoryId}">Tên danh mục *</label>
                    <input id="edit-categoryName-${cat.categoryId}" name="categoryName" type="text" required maxlength="100" value="<c:out value='${cat.categoryName}'/>" autocomplete="off">
                </div>
                <div class="tg-field">
                    <label for="edit-description-${cat.categoryId}">Mô tả danh mục</label>
                    <input id="edit-description-${cat.categoryId}" name="description" type="text" maxlength="500" value="<c:out value='${cat.description}'/>" autocomplete="off">
                </div>
                <div class="tg-dialog-actions">
                    <button class="tg-button tg-secondary" type="button" data-dialog-close>Hủy</button>
                    <button class="tg-button" type="submit">Lưu thay đổi</button>
                </div>
            </form>
        </dialog>
    </c:forEach>
</main>
</div>
<%@ include file="../auth/_figma-end.jspf" %>
