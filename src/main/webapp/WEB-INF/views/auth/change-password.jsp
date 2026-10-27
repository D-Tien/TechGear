<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đổi mật khẩu"/>
<c:set var="viewMode" value="auth"/>
<c:set var="authScreen" value="password"/>
<%@ include file="_figma-start.jspf" %>
<main class="tg-auth-page tg-account-password" id="tg-main">
    <%@ include file="_figma-visual.jspf" %>
    <section class="tg-auth-card-wrap" aria-labelledby="tg-page-title">
      <div class="tg-auth-card">
        <a class="tg-back" href="<c:url value='/profile'/>">← Quay lại hồ sơ</a>
        <div class="tg-auth-heading">
            <span class="tg-login-kicker">TECHGEAR MEMBER</span>
            <h1 id="tg-page-title">Đổi mật khẩu</h1>
            <p>Cập nhật mật khẩu định kỳ để bảo vệ tài khoản.</p>
        </div>
        <%@ include file="_figma-messages.jspf" %>

        <form class="tg-form" method="post" action="<c:url value='/change-password'/>" data-password-validation>
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <div class="tg-field">
<label for="tg-currentPassword">Mật khẩu hiện tại</label>
<div class="tg-password-field"><input id="tg-currentPassword" placeholder="Nhập mật khẩu hiện tại" name="currentPassword" type="password" required autocomplete="current-password"><button class="tg-password-toggle" type="button" data-password-toggle="tg-currentPassword" aria-controls="tg-currentPassword" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div><div class="tg-field">
<label for="tg-password">Mật khẩu mới</label>
<div class="tg-password-field"><input id="tg-password" placeholder="Tối thiểu 8 ký tự" name="password" type="password" required minlength="8" autocomplete="new-password" aria-describedby="tg-password-hint"><button class="tg-password-toggle" type="button" data-password-toggle="tg-password" aria-controls="tg-password" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div><div class="tg-field">
<label for="tg-confirmPassword">Xác nhận mật khẩu</label>
<div class="tg-password-field"><input id="tg-confirmPassword" placeholder="Nhập lại mật khẩu" name="confirmPassword" type="password" required minlength="8" autocomplete="new-password"><button class="tg-password-toggle" type="button" data-password-toggle="tg-confirmPassword" aria-controls="tg-confirmPassword" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div><p class="tg-hint" id="tg-password-hint">Mật khẩu tối thiểu 8 ký tự, tối đa 72 byte UTF-8.</p><p class="tg-hint">Bạn cần đăng nhập lại sau khi đổi mật khẩu thành công.</p>

            <button class="tg-button tg-button-block" type="submit">Lưu mật khẩu mới</button>
        </form>

        <p class="tg-auth-switch"><a href="<c:url value='/profile'/>">Quay lại hồ sơ cá nhân</a></p>
      </div>
    </section>
</main>
<%@ include file="_figma-end.jspf" %>
