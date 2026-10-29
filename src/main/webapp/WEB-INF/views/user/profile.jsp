<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fn"
uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Hồ sơ cá nhân" />
<c:set var="viewMode" value="profile" />
<c:set
  var="account"
  value="${not empty profile ? profile : sessionScope.currentUser}"
/>
<%@ include file="../auth/_figma-start.jspf" %>
<main class="tg-container" id="tg-main">
  <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>
  <div class="tg-page-title">
    <span class="tg-eyebrow">TÀI KHOẢN</span>
    <h1>Hồ sơ cá nhân</h1>
  </div>
  <div class="tg-profile-layout">
    <aside class="tg-profile-nav">
      <div class="tg-avatar" aria-hidden="true">
        <c:out
          value="${fn:toUpperCase(fn:substring(not empty account.fullName ? account.fullName : account.username,0,1))}"
        />
      </div>
      <strong><c:out value="${account.fullName}" /></strong>
      <span class="tg-account-email"><c:out value="${account.email}" /></span>
      <nav aria-label="Tài khoản cá nhân">
        <a
          class="tg-active"
          href="<c:url value='/profile'/>"
          aria-current="page"
          >Thông tin cá nhân</a
        >
        <c:if test="${sessionScope.roleName ne 'ADMIN'}"
          ><a href="<c:url value='/my-orders'/>">Đơn hàng của tôi</a></c:if
        >
        <a href="<c:url value='/change-password'/>">Đổi mật khẩu</a>
        <c:if test="${sessionScope.roleName eq 'ADMIN'}"
          ><a href="<c:url value='/admin/users'/>">Quản lý người dùng</a></c:if
        >
        <form method="post" action="<c:url value='/logout'/>">
          <input
            type="hidden"
            name="csrfToken"
            value="<c:out value='${sessionScope.csrfToken}'/>"
          /><button type="submit">Đăng xuất</button>
        </form>
      </nav>
    </aside>
    <section class="tg-form-card">
      <h2>Thông tin cá nhân</h2>
      <p class="tg-muted">Quản lý thông tin để bảo mật tài khoản.</p>
      <%@ include file="../auth/_figma-messages.jspf" %>
      <c:if test="${param.saved eq '1'}"
        ><div class="tg-notice tg-notice-success" role="status">
          Đã lưu hồ sơ.
        </div></c:if
      >
      <form class="tg-form" method="post" action="<c:url value='/profile'/>">
        <input
          type="hidden"
          name="csrfToken"
          value="<c:out value='${sessionScope.csrfToken}'/>"
        />
        <div class="tg-form-grid">
          <div class="tg-field">
            <label for="tg-profile-name">Họ và tên</label
            ><input
              id="tg-profile-name"
              name="fullName"
              maxlength="100"
              required
              autocomplete="name"
              value="<c:out value='${not empty error and param.fullName ne null ? param.fullName : account.fullName}'/>"
            />
          </div>
          <div class="tg-field">
            <label for="tg-profile-username">Tên đăng nhập</label
            ><input
              id="tg-profile-username"
              readonly
              aria-describedby="tg-username-readonly"
              value="<c:out value='${account.username}'/>"
            /><small class="tg-hint" id="tg-username-readonly"
              >Tên đăng nhập không thay đổi.</small
            >
          </div>
          <div class="tg-field">
            <label for="tg-profile-email">Email</label
            ><input
              id="tg-profile-email"
              name="email"
              type="email"
              maxlength="254"
              required
              autocomplete="email"
              value="<c:out value='${not empty error and param.email ne null ? param.email : account.email}'/>"
            />
          </div>
          <div class="tg-field">
            <label for="tg-profile-phone"
              >Số điện thoại
              <span class="tg-optional">(không bắt buộc)</span></label
            ><input
              id="tg-profile-phone"
              name="phone"
              type="tel"
              maxlength="20"
              autocomplete="tel"
              value="<c:out value='${not empty error and param.phone ne null ? param.phone : account.phone}'/>"
            />
          </div>
          <div class="tg-field tg-wide">
            <label for="tg-profile-address"
              >Địa chỉ <span class="tg-optional">(không bắt buộc)</span></label
            ><input
              id="tg-profile-address"
              name="address"
              maxlength="500"
              autocomplete="street-address"
              value="<c:out value='${not empty error and param.address ne null ? param.address : account.address}'/>"
            />
          </div>
          <div class="tg-field tg-wide">
            <label for="tg-profile-current"
              >Mật khẩu hiện tại để xác nhận</label
            >
            <div class="tg-password-field">
              <input
                id="tg-profile-current"
                name="currentPassword"
                type="password"
                required
                autocomplete="current-password"
              /><button
                class="tg-password-toggle"
                type="button"
                data-password-toggle="tg-profile-current"
                aria-controls="tg-profile-current"
                aria-pressed="false"
                aria-label="Hiện mật khẩu"
                hidden
              >
                Hiện
              </button>
            </div>
          </div>
        </div>
        <div class="tg-form-actions">
          <button class="tg-button" type="submit">Lưu thay đổi</button>
        </div>
      </form>
      <hr class="tg-divider" />
      <h2>Đổi mật khẩu</h2>
      <p class="tg-muted">Sau khi cập nhật, bạn cần đăng nhập lại.</p>
      <form
        class="tg-form"
        method="post"
        action="<c:url value='/change-password'/>"
        data-password-validation
      >
        <input
          type="hidden"
          name="csrfToken"
          value="<c:out value='${sessionScope.csrfToken}'/>"
        />
        <div class="tg-form-grid">
          <div class="tg-field tg-wide">
            <label for="tg-change-current">Mật khẩu hiện tại</label>
            <div class="tg-password-field">
              <input
                id="tg-change-current"
                name="currentPassword"
                type="password"
                required
                autocomplete="current-password"
              /><button
                class="tg-password-toggle"
                type="button"
                data-password-toggle="tg-change-current"
                aria-controls="tg-change-current"
                aria-pressed="false"
                aria-label="Hiện mật khẩu"
                hidden
              >
                Hiện
              </button>
            </div>
          </div>
          <div class="tg-field">
            <label for="tg-change-new">Mật khẩu mới</label>
            <div class="tg-password-field">
              <input
                id="tg-change-new"
                name="password"
                type="password"
                required
                minlength="8"
                autocomplete="new-password"
                aria-describedby="tg-change-hint"
              /><button
                class="tg-password-toggle"
                type="button"
                data-password-toggle="tg-change-new"
                aria-controls="tg-change-new"
                aria-pressed="false"
                aria-label="Hiện mật khẩu"
                hidden
              >
                Hiện
              </button>
            </div>
          </div>
          <div class="tg-field">
            <label for="tg-change-confirm">Xác nhận mật khẩu</label>
            <div class="tg-password-field">
              <input
                id="tg-change-confirm"
                name="confirmPassword"
                type="password"
                required
                minlength="8"
                autocomplete="new-password"
              /><button
                class="tg-password-toggle"
                type="button"
                data-password-toggle="tg-change-confirm"
                aria-controls="tg-change-confirm"
                aria-pressed="false"
                aria-label="Hiện mật khẩu"
                hidden
              >
                Hiện
              </button>
            </div>
          </div>
        </div>
        <p class="tg-hint" id="tg-change-hint">
          Mật khẩu tối thiểu 8 ký tự, tối đa 72 byte UTF-8 và khác mật khẩu cũ.
        </p>
        <div class="tg-form-actions">
          <button class="tg-button tg-secondary" type="submit">
            Cập nhật mật khẩu
          </button>
        </div>
      </form>
    </section>
  </div>
</main>
<%@ include file="../auth/_figma-end.jspf" %>
