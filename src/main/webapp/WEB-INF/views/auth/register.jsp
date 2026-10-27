<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Tạo tài khoản"/>
<c:set var="viewMode" value="auth"/>
<c:set var="authScreen" value="register"/>
<%@ include file="_figma-start.jspf" %>
<main class="tg-auth-page tg-account-register" id="tg-main">
    <%@ include file="_figma-visual.jspf" %>
    <section class="tg-auth-card-wrap" aria-labelledby="tg-page-title">
      <div class="tg-auth-card">
        <a class="tg-back" href="<c:url value='/login'/>">← Quay lại đăng nhập</a>
        <div class="tg-auth-heading">
            <span class="tg-login-kicker">TECHGEAR MEMBER</span>
            <h1 id="tg-page-title">Tạo tài khoản</h1>
            <p>Gia nhập TechGear chỉ trong một phút.</p>
        </div>
        <%@ include file="_figma-messages.jspf" %>

        <form class="tg-form" method="post" action="<c:url value='/register'/>" data-password-validation>
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <div class="tg-register-fields">
<div class="tg-field">
<label for="tg-username">Tên đăng nhập</label>
<input id="tg-username" placeholder="Nhập tên đăng nhập" name="username" type="text" required minlength="4" maxlength="30" pattern="[A-Za-z0-9_.-]{4,30}" autocomplete="username" aria-describedby="tg-username-hint" value="<c:out value='${param.username}'/>">
</div><div class="tg-field">
<label for="tg-fullName">Họ và tên</label>
<input id="tg-fullName" placeholder="Nhập họ và tên" name="fullName" type="text" required maxlength="100" autocomplete="name" value="<c:out value='${param.fullName}'/>">
</div><div class="tg-field">
<label for="tg-email">Email</label>
<input id="tg-email" placeholder="Nhập email" name="email" type="email" required maxlength="254" autocomplete="email" value="<c:out value='${param.email}'/>">
</div><div class="tg-field">
<label for="tg-phone">Số điện thoại <span class="tg-sr-only">(không bắt buộc)</span></label>
<input id="tg-phone" placeholder="Không bắt buộc" name="phone" type="tel" maxlength="20" autocomplete="tel" value="<c:out value='${param.phone}'/>">
</div><div class="tg-field">
<label for="tg-password">Mật khẩu</label>
<div class="tg-password-field"><input id="tg-password" placeholder="Tối thiểu 8 ký tự" name="password" type="password" required minlength="8" autocomplete="new-password" aria-describedby="tg-password-hint"><button class="tg-password-toggle" type="button" data-password-toggle="tg-password" aria-controls="tg-password" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div><div class="tg-field">
<label for="tg-confirmPassword">Xác nhận mật khẩu</label>
<div class="tg-password-field"><input id="tg-confirmPassword" placeholder="Nhập lại mật khẩu" name="confirmPassword" type="password" required minlength="8" autocomplete="new-password"><button class="tg-password-toggle" type="button" data-password-toggle="tg-confirmPassword" aria-controls="tg-confirmPassword" aria-pressed="false" aria-label="Hiện mật khẩu" hidden>Hiện</button></div>
</div></div>
            <div class="tg-password-note"><b>Mật khẩu an toàn</b><p class="tg-hint" id="tg-password-hint">Mật khẩu tối thiểu 8 ký tự, tối đa 72 byte UTF-8.</p></div>
            <p class="tg-hint" id="tg-username-hint">4–30 ký tự: chữ không dấu, số, dấu chấm, gạch dưới hoặc gạch ngang.</p>

            <button class="tg-button tg-button-block" type="submit">Tạo tài khoản</button>
        </form>

        <p class="tg-auth-switch">Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập</a></p>
      </div>
    </section>
</main>
<%@ include file="_figma-end.jspf" %>
