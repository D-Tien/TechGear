package com.techgear.util;

import com.techgear.model.User;
import jakarta.servlet.http.*;
import java.sql.SQLException;

/** Small form/session helpers shared by Person 1 servlets. No SQL here. */
public final class AuthUtil {
    private AuthUtil() { }
    public static String text(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }
    public static User currentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("currentUser");
    }
    public static void saveSession(HttpServletRequest request, User user, String roleName) {
        user.setPasswordHash(null);
        request.getSession().setAttribute("currentUser", user);
        request.getSession().setAttribute("roleName", roleName);
    }
    public static void readProfile(HttpServletRequest request, User user) {
        String fullName = text(request, "fullName");
        String email = text(request, "email");
        String phone = text(request, "phone");
        String address = text(request, "address");
        if (fullName.isEmpty() || fullName.length() > 100) throw new IllegalArgumentException("Họ tên phải từ 1 đến 100 ký tự.");
        if (!ValidationUtil.isValidEmail(email)) throw new IllegalArgumentException("Email không hợp lệ (tối đa 254 ký tự).");
        if (!ValidationUtil.isValidPhone(phone)) throw new IllegalArgumentException("Số điện thoại không hợp lệ.");
        if (address.length() > 500) throw new IllegalArgumentException("Địa chỉ tối đa 500 ký tự.");
        user.setFullName(fullName); user.setEmail(email); user.setPhone(phone); user.setAddress(address);
    }
    public static String newPassword(HttpServletRequest request) {
        String password = request.getParameter("password");
        if (!ValidationUtil.isValidPassword(password)) throw new IllegalArgumentException("Mật khẩu phải từ 8 ký tự và tối đa 72 byte UTF-8.");
        if (!password.equals(request.getParameter("confirmPassword"))) throw new IllegalArgumentException("Xác nhận mật khẩu không khớp.");
        return password;
    }
    public static int positiveId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) return id;
        } catch (NumberFormatException ignored) { }
        throw new IllegalArgumentException("Mã người dùng hoặc vai trò không hợp lệ.");
    }
    public static void databaseError(HttpServletRequest request, HttpServletResponse response, SQLException exception) {
        request.getServletContext().log("Person 1 database operation failed", exception);
        if (exception.getErrorCode() == 2601 || exception.getErrorCode() == 2627) {
            response.setStatus(400);
            request.setAttribute("error", "Username hoặc email đã được sử dụng.");
        } else {
            response.setStatus(503);
            request.setAttribute("error", "Không thể xử lý dữ liệu. Kiểm tra kết nối SQL Server và cấu trúc database; xem log Tomcat để biết chi tiết.");
        }
    }
}
