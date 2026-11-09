<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thương hiệu"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="brands"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
    <main class="tg-admin-content tg-admin-main" id="tg-main">
        <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>

        <div class="tg-admin-page-head">
            <div class="tg-page-title">
                <span class="tg-eyebrow">QUẢN LÝ CATALOG</span>
                <h1>Thương hiệu</h1>
            </div>
            <button class="tg-button" type="button" data-dialog-target="tg-add-brand">+ Thêm thương hiệu</button>
        </div>

        <c:if test="${param.saved eq '1'}">
            <div class="tg-notice tg-notice-success" role="status">Đã lưu thương hiệu thành công.</div>
        </c:if>
        <c:if test="${param.deleted eq '1'}">
            <div class="tg-notice tg-notice-success" role="status">Đã xóa thương hiệu.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="tg-notice tg-notice-error" role="alert"><c:out value="${error}"/></div>
        </c:if>

        <section class="tg-panel tg-table-panel" aria-labelledby="tg-brand-list-title">
            <div class="tg-panel-title">
                <h2 id="tg-brand-list-title">Danh sách thương hiệu</h2>
                <span class="tg-muted"><c:out value="${fn:length(brands)}"/> thương hiệu</span>
            </div>
            <div class="tg-table-wrap" tabindex="0" role="region" aria-label="Danh sách thương hiệu">
                <table>
                    <thead>
                        <tr>
                            <th scope="col" style="width: 100px;">Mã</th>
                            <th scope="col">Tên thương hiệu</th>
                            <th scope="col">Mô tả</th>
                            <th scope="col">% tồn kho</th>
                            <th scope="col">Đã bán</th>
                            <th scope="col">Doanh thu</th>
                            <th scope="col" style="width: 170px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${brands}" var="brand">
                            <tr>
                                <td><strong>#<c:out value="${brand.brandId}"/></strong></td>
                                <td><b><c:out value="${brand.brandName}"/></b></td>
                                <td><span class="tg-muted"><c:out value="${not empty brand.description ? brand.description : '—'}"/></span></td>
                                <td><fmt:formatNumber value="${catalogMetrics[brand.brandId].inventoryPercent}" minFractionDigits="1" maxFractionDigits="1"/>%</td>
                                <td><fmt:formatNumber value="${catalogMetrics[brand.brandId].soldQuantity}" groupingUsed="true"/> sản phẩm</td>
                                <td><strong class="tg-metric-revenue"><fmt:formatNumber value="${catalogMetrics[brand.brandId].revenue}" type="number" groupingUsed="true"/> đ</strong></td>
                                <td>
                                    <div class="tg-admin-actions">
                                        <button class="tg-row-action" type="button" data-dialog-target="tg-edit-brand-${brand.brandId}">Sửa <span aria-hidden="true">↗</span></button>
                                        <form method="post" action="<c:url value='/admin/brands'/>">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="brandId" value="${brand.brandId}">
                                            <button class="tg-row-action tg-danger" type="submit" onclick="return confirm('Bạn có chắc muốn xóa thương hiệu này?');">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty brands}">
                            <tr><td colspan="7" class="tg-empty-state">Chưa có thương hiệu nào trong cơ sở dữ liệu.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>

        <dialog class="tg-dialog" id="tg-add-brand" aria-labelledby="tg-add-brand-title">
            <div class="tg-dialog-heading">
                <h2 id="tg-add-brand-title">Thêm thương hiệu</h2>
                <button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng">×</button>
            </div>
            <form class="tg-form" method="post" action="<c:url value='/admin/brands'/>">
                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                <input type="hidden" name="action" value="create">
                <div class="tg-field">
                    <label for="new-brand-name">Tên thương hiệu *</label>
                    <input id="new-brand-name" name="brandName" type="text" required maxlength="100" autocomplete="off">
                </div>
                <div class="tg-field">
                    <label for="new-brand-description">Mô tả</label>
                    <textarea id="new-brand-description" name="description" maxlength="1000" rows="4"></textarea>
                </div>
                <div class="tg-dialog-actions">
                    <button class="tg-button tg-secondary" type="button" data-dialog-close>Hủy</button>
                    <button class="tg-button" type="submit">Thêm thương hiệu</button>
                </div>
            </form>
        </dialog>

        <c:forEach items="${brands}" var="brand">
            <dialog class="tg-dialog" id="tg-edit-brand-${brand.brandId}" aria-labelledby="tg-edit-brand-title-${brand.brandId}">
                <div class="tg-dialog-heading">
                    <h2 id="tg-edit-brand-title-${brand.brandId}">Sửa thương hiệu</h2>
                    <button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng">×</button>
                </div>
                <form class="tg-form" method="post" action="<c:url value='/admin/brands'/>">
                    <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="brandId" value="${brand.brandId}">
                    <div class="tg-field">
                        <label for="brand-name-${brand.brandId}">Tên thương hiệu *</label>
                        <input id="brand-name-${brand.brandId}" name="brandName" type="text" required maxlength="100" value="<c:out value='${brand.brandName}'/>" autocomplete="off">
                    </div>
                    <div class="tg-field">
                        <label for="brand-description-${brand.brandId}">Mô tả</label>
                        <textarea id="brand-description-${brand.brandId}" name="description" maxlength="1000" rows="4"><c:out value="${brand.description}"/></textarea>
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
