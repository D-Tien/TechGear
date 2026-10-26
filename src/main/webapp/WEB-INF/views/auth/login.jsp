<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Chào mừng trở lại"/>
<c:set var="viewMode" value="auth"/>
<%@ include file="_figma-start.jspf" %>
<main class="tg-auth-page" id="tg-main">
    <%@ include file="_figma-visual.jspf" %>
    <section class="tg-auth-card" aria-labelledby="tg-page-title">
        <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>
        <div class="tg-auth-heading">
            <h1 id="tg-page-title">Chào mừng trở lại</h1>
            <p>Đăng nhập để tiếp tục mua sắm.</p>
        </div>
        <%@ include file="_figma-messages.jspf" %>
        <c:if test="${param.registered eq '1'}"><div class="tg-notice tg-notice-success" role="status">Đăng ký thành công. Bạn có thể đăng nhập.</div></c:if>
<c:if test="${param.changed eq '1'}"><div class="tg-notice tg-notice-success" role="status">Đã đổi mật khẩu. Vui lòng đăng nhập lại.</div></c:if>
<c:if test="${param.logout eq '1'}"><div class="tg-notice tg-notice-success" role="status">Bạn đã đăng xuất.</div></c:if>
        <form class="tg-form" method="post" action="<c:url value='/login'/>">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <div class="tg-field">
<label for="tg-username">Tên đăng nhập</label>
<input id="tg-username" name="username" type="text" required maxlength="30" autocomplete="username" autofocus value="<c:out value='${param.username}'/>">
</div><div class="tg-field">
<label for="tg-password">Mật khẩu</label>
<div class="tg-password-field"><input id="tg-password" name="password" type="password" required autocomplete="current-password"><button class="tg-password-toggle" type="button" data-password-toggle="tg-password" aria-controls="tg-password" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div>
            <button class="tg-button tg-button-block" type="submit">Đăng nhập</button>
        </form>

        <p class="tg-auth-switch">Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký ngay</a></p>
    </section>
</main>
<%@ include file="_figma-end.jspf" %>
