<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Người dùng"/>
<c:set var="viewMode" value="admin"/>
<c:set var="submittedCreate" value="${not empty error and param.action eq 'create'}"/>
<%@ include file="../auth/_figma-start.jspf" %>
<main class="tg-admin-content" id="tg-main">
    <a class="tg-back" href="<c:url value='/home'/>">← Về trang chủ</a>
    <a class="tg-back" href="<c:url value='/profile'/>">Hồ sơ và đăng xuất</a>
    <div class="tg-admin-page-head">
        <div class="tg-page-title"><span class="tg-eyebrow">QUẢN LÝ</span><h1>Người dùng</h1></div>
        <button class="tg-button" type="button" data-dialog-target="tg-create-user">+ Thêm người dùng</button>
    </div>
    <%@ include file="../auth/_figma-messages.jspf" %>
    <c:if test="${param.saved eq '1'}"><div class="tg-notice tg-notice-success" role="status">Đã lưu thay đổi.</div></c:if>
    <div class="tg-catalog-tools">
        <form class="tg-search" method="get" action="<c:url value='/admin/users'/>" role="search">
            <label class="tg-sr-only" for="tg-user-search">Tìm username, họ tên hoặc email</label>
            <input id="tg-user-search" name="keyword" type="search" maxlength="254" placeholder="Tìm người dùng..." value="<c:out value="${param.keyword}"/>">
            <button type="submit" aria-label="Tìm kiếm">⌕</button>
        </form>
        <label class="tg-sr-only" for="tg-role-filter">Lọc vai trò</label>
        <select id="tg-role-filter" data-role-filter><option value="">Tất cả vai trò</option><c:forEach items="${roles}" var="role"><option value="${role.roleId}"><c:out value="${role.roleName}"/></option></c:forEach></select>
        <label class="tg-sr-only" for="tg-status-filter">Lọc trạng thái</label>
        <select id="tg-status-filter" data-status-filter><option value="">Tất cả trạng thái</option><option value="true">Hoạt động</option><option value="false">Đã khóa</option></select>
    </div>
    <section class="tg-panel tg-table-panel" aria-labelledby="tg-user-list-title">
        <div class="tg-panel-title"><h2 id="tg-user-list-title">Danh sách người dùng</h2><span class="tg-muted" data-result-count aria-live="polite"><c:out value="${fn:length(users)}"/> người dùng</span></div>
        <div class="tg-table-wrap" tabindex="0" role="region" aria-label="Danh sách người dùng, cuộn ngang trên màn hình nhỏ">
            <table data-user-table>
                <thead><tr><th scope="col">Người dùng</th><th scope="col">Email</th><th scope="col">Vai trò</th><th scope="col">Ngày tham gia</th><th scope="col">Trạng thái</th><th scope="col">Thao tác</th></tr></thead>
                <tbody>
                <c:forEach items="${users}" var="user">
                    <tr data-user-row data-role="${user.roleId}" data-active="${user.active}">
                        <td><div class="tg-table-person"><span class="tg-small-avatar" aria-hidden="true"><c:out value="${fn:toUpperCase(fn:substring(user.fullName,0,1))}"/></span><div><b><c:out value="${user.fullName}"/></b><small>@<c:out value="${user.username}"/></small></div></div></td>
                        <td><c:out value="${user.email}"/></td>
                        <td><c:forEach items="${roles}" var="role"><c:if test="${role.roleId eq user.roleId}"><span class="tg-badge ${role.roleName eq 'ADMIN' ? 'tg-blue' : 'tg-neutral'}"><c:out value="${role.roleName eq 'ADMIN' ? 'Quản trị viên' : 'Khách hàng'}"/></span></c:if></c:forEach></td>
                        <td><time datetime="<c:out value="${user.createdAt}"/>" title="UTC"><c:out value="${fn:substring(user.createdAt,8,10)}"/>/<c:out value="${fn:substring(user.createdAt,5,7)}"/>/<c:out value="${fn:substring(user.createdAt,0,4)}"/></time></td>
                        <td><span class="tg-badge ${user.active ? 'tg-green' : 'tg-red'}">${user.active ? 'Hoạt động' : 'Đã khóa'}</span></td>
                        <td><button class="tg-row-action" type="button" data-dialog-target="tg-edit-user-${user.userId}" aria-label="Chỉnh sửa tài khoản mã ${user.userId}">Chỉnh sửa <span aria-hidden="true">↗</span></button></td>
                    </tr>
                </c:forEach>
                    <tr data-filter-empty ${not empty users ? 'hidden' : ''}><td colspan="6" class="tg-empty-state">Không tìm thấy người dùng phù hợp.</td></tr>
                </tbody>
            </table>
        </div>
    </section>
    <nav class="tg-pagination" data-user-pagination aria-label="Phân trang người dùng"></nav>
    <p class="tg-hint">Khóa tài khoản giữ nguyên lịch sử đơn hàng. Thay đổi quyền hoặc trạng thái cần mật khẩu xác nhận của ADMIN.</p>
    <noscript><p class="tg-notice">Danh sách bên trên lấy từ database. Bật JavaScript để dùng bộ lọc, phân trang và biểu mẫu tạo/sửa.</p></noscript>

    <dialog class="tg-dialog" id="tg-create-user" aria-labelledby="tg-create-title" data-auto-open="${submittedCreate}">
        <div class="tg-dialog-heading"><h2 id="tg-create-title">Tạo tài khoản</h2><button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng biểu mẫu">×</button></div>
        <p class="tg-muted">Thông tin tài khoản mới và quyền truy cập.</p>
        <c:if test="${submittedCreate}"><%@ include file="../auth/_figma-messages.jspf" %></c:if>
        <form class="tg-form" method="post" action="<c:url value='/admin/users'/>" data-password-validation>
            <input type="hidden" name="csrfToken" value="<c:out value="${sessionScope.csrfToken}"/>"><input type="hidden" name="action" value="create">
            <div class="tg-form-grid">
                <div class="tg-field"><label for="tg-create-username">Tên đăng nhập</label><input id="tg-create-username" name="username" type="text" required minlength="4" maxlength="30" pattern="[A-Za-z0-9_.-]{4,30}" autocomplete="off" value="<c:out value="${submittedCreate ? param.username : ''}"/>"></div>
                <div class="tg-field tg-field-note"><p class="tg-hint">4–30 ký tự: chữ không dấu, số, _, . hoặc -.</p></div>
                <div class="tg-field"><label for="tg-create-fullName">Họ và tên</label><input id="tg-create-fullName" name="fullName" type="text" required maxlength="100" autocomplete="off" value="<c:out value="${submittedCreate ? param.fullName : ''}"/>"></div><div class="tg-field"><label for="tg-create-email">Email</label><input id="tg-create-email" name="email" type="email" required maxlength="254" autocomplete="off" value="<c:out value="${submittedCreate ? param.email : ''}"/>"></div><div class="tg-field"><label for="tg-create-phone">Số điện thoại <span class="tg-optional">(không bắt buộc)</span></label><input id="tg-create-phone" name="phone" type="tel" maxlength="20" autocomplete="off" value="<c:out value="${submittedCreate ? param.phone : ''}"/>"></div><div class="tg-field"><label for="tg-create-roleId">Vai trò</label><select id="tg-create-roleId" name="roleId" required><c:forEach items="${roles}" var="role"><option value="${role.roleId}" ${(submittedCreate ? param.roleId eq role.roleId : role.roleName eq 'CUSTOMER') ? 'selected' : ''}><c:out value="${role.roleName}"/></option></c:forEach></select></div><div class="tg-field tg-wide"><label for="tg-create-address">Địa chỉ <span class="tg-optional">(không bắt buộc)</span></label><input id="tg-create-address" name="address" type="text" maxlength="500" autocomplete="off" value="<c:out value="${submittedCreate ? param.address : ''}"/>"></div>
                <div class="tg-field"><label for="tg-create-password">Mật khẩu</label><input id="tg-create-password" name="password" type="password" required minlength="8" autocomplete="new-password"></div>
                <div class="tg-field"><label for="tg-create-confirmPassword">Xác nhận mật khẩu</label><input id="tg-create-confirmPassword" name="confirmPassword" type="password" required minlength="8" autocomplete="new-password"></div>
                <div class="tg-wide"><div class="tg-field"><label for="tg-create-adminPassword">Mật khẩu ADMIN đang đăng nhập</label><input id="tg-create-adminPassword" name="adminPassword" type="password" required autocomplete="current-password"></div></div>
            </div>
            <p class="tg-hint">Mật khẩu mới tối thiểu 8 ký tự, tối đa 72 byte UTF-8.</p>
            <div class="tg-dialog-actions"><button class="tg-button tg-secondary" type="button" data-dialog-close>Hủy</button><button class="tg-button" type="submit">Tạo tài khoản</button></div>
        </form>
    </dialog>
    <c:forEach items="${users}" var="user">
        <c:set var="submittedEdit" value="${not empty error and param.action eq 'update' and param.userId eq user.userId}"/>
        <dialog class="tg-dialog" id="tg-edit-user-${user.userId}" aria-labelledby="tg-edit-title-${user.userId}" data-auto-open="${submittedEdit}">
            <div class="tg-dialog-heading"><h2 id="tg-edit-title-${user.userId}">Chỉnh sửa người dùng</h2><button class="tg-dialog-close" type="button" data-dialog-close aria-label="Đóng biểu mẫu">×</button></div>
            <p class="tg-muted">Tài khoản <strong><c:out value="${user.username}"/></strong> · Mã #<c:out value="${user.userId}"/></p>
            <c:if test="${submittedEdit}"><%@ include file="../auth/_figma-messages.jspf" %></c:if>
            <form class="tg-form" method="post" action="<c:url value='/admin/users'/>">
                <input type="hidden" name="csrfToken" value="<c:out value="${sessionScope.csrfToken}"/>"><input type="hidden" name="action" value="update"><input type="hidden" name="userId" value="${user.userId}">
                <div class="tg-form-grid">
                    <div class="tg-field"><label for="tg-edit-${user.userId}-fullName">Họ và tên</label><input id="tg-edit-${user.userId}-fullName" name="fullName" type="text" required maxlength="100" autocomplete="off" value="<c:out value="${submittedEdit ? param.fullName : user.fullName}"/>"></div><div class="tg-field"><label for="tg-edit-${user.userId}-email">Email</label><input id="tg-edit-${user.userId}-email" name="email" type="email" required maxlength="254" autocomplete="off" value="<c:out value="${submittedEdit ? param.email : user.email}"/>"></div><div class="tg-field"><label for="tg-edit-${user.userId}-phone">Số điện thoại <span class="tg-optional">(không bắt buộc)</span></label><input id="tg-edit-${user.userId}-phone" name="phone" type="tel" maxlength="20" autocomplete="off" value="<c:out value="${submittedEdit ? param.phone : user.phone}"/>"></div><div class="tg-field"><label for="tg-edit-${user.userId}-roleId">Vai trò</label><select id="tg-edit-${user.userId}-roleId" name="roleId" required><c:forEach items="${roles}" var="role"><option value="${role.roleId}" ${(submittedEdit ? param.roleId eq role.roleId : user.roleId eq role.roleId) ? 'selected' : ''}><c:out value="${role.roleName}"/></option></c:forEach></select></div><div class="tg-field tg-wide"><label for="tg-edit-${user.userId}-address">Địa chỉ <span class="tg-optional">(không bắt buộc)</span></label><input id="tg-edit-${user.userId}-address" name="address" type="text" maxlength="500" autocomplete="off" value="<c:out value="${submittedEdit ? param.address : user.address}"/>"></div>
                    <label class="tg-checkbox tg-wide"><input type="checkbox" name="active" value="true" ${(submittedEdit ? param.active eq 'true' : user.active) ? 'checked' : ''}> Cho phép tài khoản đăng nhập</label>
                    <div class="tg-wide"><div class="tg-field"><label for="tg-edit-${user.userId}-adminPassword">Mật khẩu ADMIN đang đăng nhập</label><input id="tg-edit-${user.userId}-adminPassword" name="adminPassword" type="password" required autocomplete="current-password"></div></div>
                </div>
                <p class="tg-hint">Không thể tự khóa, tự hạ quyền hoặc làm mất ADMIN cuối cùng.</p>
                <div class="tg-dialog-actions"><button class="tg-button tg-secondary" type="button" data-dialog-close>Hủy</button><button class="tg-button" type="submit">Cập nhật tài khoản</button></div>
            </form>
        </dialog>
    </c:forEach>
</main>
<%@ include file="../auth/_figma-end.jspf" %>
