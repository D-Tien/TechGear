<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý đơn hàng"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="orders"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
    <main class="tg-admin-content tg-admin-main tg-order-admin" id="tg-main">
        <a class="tg-back" href="<c:url value='/admin/dashboard'/>">← Về tổng quan</a>
        <div class="tg-admin-page-head tg-order-heading">
            <div class="tg-page-title">
                <span class="tg-eyebrow">TECHGEAR / QUẢN TRỊ</span>
                <h1>Quản lý đơn hàng</h1>
                <p>Theo dõi sản phẩm, thông tin giao hàng và cập nhật trạng thái đơn.</p>
            </div>
        </div>

        <c:if test="${param.updated eq '1'}"><div class="tg-notice tg-notice-success">Đã cập nhật trạng thái đơn hàng.</div></c:if>

        <section class="tg-panel tg-order-tools" aria-label="Lọc đơn hàng">
            <nav class="tg-order-tabs" aria-label="Lọc theo trạng thái">
                <c:url var="allUrl" value="/admin/orders"><c:param name="status" value="ALL"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'ALL' ? 'is-active' : ''}" href="${allUrl}">Tất cả <b><c:out value="${statusCounts.ALL}"/></b></a>
                <c:url var="pendingUrl" value="/admin/orders"><c:param name="status" value="PENDING"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'PENDING' ? 'is-active' : ''}" href="${pendingUrl}">Chờ xác nhận <b><c:out value="${statusCounts.PENDING}"/></b></a>
                <c:url var="confirmedUrl" value="/admin/orders"><c:param name="status" value="CONFIRMED"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'CONFIRMED' ? 'is-active' : ''}" href="${confirmedUrl}">Đã xác nhận <b><c:out value="${statusCounts.CONFIRMED}"/></b></a>
                <c:url var="shippingUrl" value="/admin/orders"><c:param name="status" value="SHIPPING"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'SHIPPING' ? 'is-active' : ''}" href="${shippingUrl}">Đang giao <b><c:out value="${statusCounts.SHIPPING}"/></b></a>
                <c:url var="deliveredUrl" value="/admin/orders"><c:param name="status" value="DELIVERED"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'DELIVERED' ? 'is-active' : ''}" href="${deliveredUrl}">Hoàn tất <b><c:out value="${statusCounts.DELIVERED}"/></b></a>
                <c:url var="cancelledUrl" value="/admin/orders"><c:param name="status" value="CANCELLED"/><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
                <a class="${selectedStatus eq 'CANCELLED' ? 'is-active' : ''}" href="${cancelledUrl}">Đã hủy <b><c:out value="${statusCounts.CANCELLED}"/></b></a>
            </nav>
            <div class="tg-order-search-row">
                <form class="tg-search tg-order-search" method="get" action="<c:url value='/admin/orders'/>" role="search">
                    <input type="hidden" name="status" value="${selectedStatus}">
                    <label class="tg-sr-only" for="order-keyword">Tìm đơn hàng</label>
                    <input id="order-keyword" name="keyword" type="search" maxlength="100" placeholder="Tìm mã đơn, người nhận, số điện thoại..." value="<c:out value='${keyword}'/>">
                    <button type="submit" aria-label="Tìm">⌕</button>
                </form>
                <span class="tg-muted">Hiển thị <c:out value="${fn:length(orders)}"/> / <c:out value="${totalOrders}"/> đơn hàng</span>
            </div>
        </section>

        <c:choose>
            <c:when test="${empty orders}"><section class="tg-panel tg-order-empty">Không tìm thấy đơn hàng phù hợp.</section></c:when>
            <c:otherwise>
                <c:forEach items="${orders}" var="o">
                    <article class="tg-panel tg-order-card">
                        <header class="tg-order-card-head">
                            <div><strong>Đơn #<c:out value="${o.orderId}"/></strong>
                                <span class="tg-order-status status-${fn:toLowerCase(o.status)}"><c:out value="${o.status}"/></span></div>
                            <div class="tg-order-meta">Khách #<c:out value="${o.userId}"/> <span>·</span> <c:out value="${o.createdAt}"/></div>
                        </header>
                        <div class="tg-order-info">
                            <div><small>NGƯỜI NHẬN</small><b><c:out value="${o.recipientName}"/></b></div>
                            <div><small>ĐIỆN THOẠI</small><b><c:out value="${o.phone}"/></b></div>
                            <div><small>ĐỊA CHỈ GIAO HÀNG</small><b><c:out value="${o.shippingAddress}"/></b></div>
                            <div><small>THANH TOÁN</small><b><c:out value="${o.paymentMethod}"/></b></div>
                        </div>
                        <details class="tg-order-detail">
                            <summary>Xem sản phẩm và chi tiết đơn hàng <span aria-hidden="true">⌄</span></summary>
                            <div class="tg-order-detail-content">
                                <c:choose>
                                    <c:when test="${empty orderItems[o.orderId]}"><p class="tg-muted">Đơn hàng không có dòng chi tiết sản phẩm.</p></c:when>
                                    <c:otherwise>
                                        <div class="tg-table-wrap"><table>
                                            <thead><tr><th>Sản phẩm</th><th>Số lượng</th><th>Giá lúc mua</th><th>Thành tiền</th></tr></thead>
                                            <tbody><c:forEach items="${orderItems[o.orderId]}" var="item"><tr>
                                                <td><strong><c:out value="${item.productName}"/></strong></td>
                                                <td><c:out value="${item.quantity}"/></td>
                                                <td><fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/> đ</td>
                                                <td><fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true"/> đ</td>
                                            </tr></c:forEach></tbody>
                                        </table></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </details>
                        <footer class="tg-order-card-foot">
                            <div class="tg-order-total"><span>Tổng cộng:</span> <strong><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</strong></div>
                            <form class="tg-order-status-form" method="post" action="<c:url value='/admin/orders'/>">
                                <input type="hidden" name="orderId" value="${o.orderId}">
                                <input type="hidden" name="filterStatus" value="${selectedStatus}">
                                <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>">
                                <input type="hidden" name="page" value="${currentPage}">
                                <label class="tg-sr-only" for="order-status-${o.orderId}">Trạng thái đơn #${o.orderId}</label>
                                <select id="order-status-${o.orderId}" name="status">
                                    <option value="PENDING" ${o.status eq 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="CONFIRMED" ${o.status eq 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="SHIPPING" ${o.status eq 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                                    <option value="DELIVERED" ${o.status eq 'DELIVERED' ? 'selected' : ''}>Hoàn tất</option>
                                    <option value="CANCELLED" ${o.status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                                <button class="tg-button" type="submit">Lưu trạng thái</button>
                            </form>
                        </footer>
                    </article>
                </c:forEach>
                <c:if test="${totalPages gt 1}">
                    <nav class="tg-order-pagination" aria-label="Phân trang đơn hàng">
                        <c:if test="${currentPage gt 1}"><c:url var="previousUrl" value="/admin/orders"><c:param name="status" value="${selectedStatus}"/><c:param name="keyword" value="${keyword}"/><c:param name="page" value="${currentPage - 1}"/></c:url><a href="${previousUrl}">← Trước</a></c:if>
                        <span>Trang <c:out value="${currentPage}"/> / <c:out value="${totalPages}"/></span>
                        <c:if test="${currentPage lt totalPages}"><c:url var="nextUrl" value="/admin/orders"><c:param name="status" value="${selectedStatus}"/><c:param name="keyword" value="${keyword}"/><c:param name="page" value="${currentPage + 1}"/></c:url><a href="${nextUrl}">Tiếp →</a></c:if>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </main>
</div>
<%@ include file="../auth/_figma-end.jspf" %>
