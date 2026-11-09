<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thống kê bán hàng"/>
<c:set var="viewMode" value="admin"/>
<c:set var="adminSection" value="dashboard"/>
<%@ include file="../auth/_figma-start.jspf" %>
<div class="tg-admin-layout">
    <%@ include file="admin-sidebar.jspf" %>
    <main class="tg-admin-content tg-admin-main tg-dashboard" id="tg-main">
        <a class="tg-back" href="<c:url value='/home'/>">← Về cửa hàng</a>
        <header class="tg-admin-page-head tg-dashboard-heading">
            <div class="tg-page-title">
                <span class="tg-eyebrow">TECHGEAR / TỔNG QUAN KINH DOANH</span>
                <h1>Thống kê bán hàng</h1>
                <p>Tổng quan doanh thu, đơn hàng và sản phẩm bán chạy</p>
            </div>
        </header>

        <section class="tg-dashboard-metrics" aria-label="Tổng quan doanh thu và đơn hàng">
            <article class="tg-dashboard-metric tg-dashboard-revenue">
                <span class="tg-dashboard-icon" aria-hidden="true">＄</span>
                <strong class="tg-dashboard-value"><fmt:formatNumber value="${revenue}" type="number" groupingUsed="true"/> đ</strong>
                <span class="tg-dashboard-label">Doanh thu từ đơn hoàn tất</span>
                <small>Chỉ tính đơn đã giao thành công</small>
            </article>
            <article class="tg-dashboard-metric">
                <span class="tg-dashboard-icon" aria-hidden="true">◇</span>
                <strong class="tg-dashboard-value"><fmt:formatNumber value="${totalOrders}" groupingUsed="true"/></strong>
                <span class="tg-dashboard-label">Tổng đơn hàng</span>
                <small>Bao gồm mọi trạng thái</small>
            </article>
            <article class="tg-dashboard-metric">
                <span class="tg-dashboard-icon" aria-hidden="true">✓</span>
                <strong class="tg-dashboard-value"><fmt:formatNumber value="${completedOrders}" groupingUsed="true"/></strong>
                <span class="tg-dashboard-label">Đơn hoàn tất</span>
                <small>Đã giao thành công</small>
            </article>
        </section>

        <section class="tg-dashboard-completion" aria-label="Tỷ lệ đơn hoàn tất">
            <div>
                <span class="tg-eyebrow">HIỆU QUẢ ĐƠN HÀNG</span>
                <h2>Tỷ lệ đơn hoàn tất</h2>
                <p><fmt:formatNumber value="${completedOrders}" groupingUsed="true"/> / <fmt:formatNumber value="${totalOrders}" groupingUsed="true"/> đơn hàng đã hoàn tất</p>
            </div>
            <div class="tg-dashboard-progress">
                <strong><fmt:formatNumber value="${completionRate}" maxFractionDigits="1"/>%</strong>
                <progress value="${completedOrders}" max="${totalOrders gt 0 ? totalOrders : 1}" aria-label="Tỷ lệ đơn hoàn tất"></progress>
            </div>
            <a class="tg-button" href="<c:url value='/admin/orders'/>">Quản lý đơn hàng →</a>
        </section>

        <div class="tg-dashboard-section-head">
            <div><span class="tg-eyebrow">SẢN PHẨM NỔI BẬT</span><h2>Hiệu quả bán hàng</h2></div>
            <span>Toàn bộ thời gian</span>
        </div>

        <section class="tg-panel tg-dashboard-best" aria-labelledby="tg-best-selling-title">
            <div class="tg-panel-title tg-dashboard-best-title">
                <div>
                    <h2 id="tg-best-selling-title"><span aria-hidden="true">♜</span> Top 10 sản phẩm bán chạy</h2>
                    <p>Chỉ tính sản phẩm trong các đơn đã giao thành công, kể cả sản phẩm đã ngừng bán.</p>
                </div>
            </div>
            <c:choose>
                <c:when test="${empty bestSelling}">
                    <div class="tg-dashboard-empty">Chưa có sản phẩm bán ra từ đơn đã giao thành công.</div>
                </c:when>
                <c:otherwise>
                    <div class="tg-table-wrap tg-dashboard-table-wrap">
                        <table class="tg-dashboard-table">
                            <thead><tr><th class="tg-rank-column">#</th><th>Sản phẩm</th><th class="tg-sold-column">Số lượng bán</th><th class="tg-revenue-column">Doanh thu</th></tr></thead>
                            <tbody>
                                <c:forEach items="${bestSelling}" var="item" varStatus="loop">
                                    <tr>
                                        <td class="tg-rank-column"><span class="tg-rank-badge rank-${loop.index lt 3 ? loop.index + 1 : 'other'}"><c:out value="${loop.index + 1}"/></span></td>
                                        <td><strong><c:out value="${item.productName}"/></strong></td>
                                        <td class="tg-sold-column"><div class="tg-sold-meter"><b><fmt:formatNumber value="${item.unitsSold}" groupingUsed="true"/></b><meter min="0" max="${bestSelling[0].unitsSold gt 0 ? bestSelling[0].unitsSold : 1}" value="${item.unitsSold}"><c:out value="${item.unitsSold}"/></meter></div></td>
                                        <td class="tg-revenue-column"><strong><fmt:formatNumber value="${item.revenue}" type="number" groupingUsed="true"/> đ</strong></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
<%@ include file="../auth/_figma-end.jspf" %>
