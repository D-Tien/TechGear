package com.techgear.controller.auth;

import com.techgear.dao.UserDAO;
import com.techgear.dao.RoleDAO;
import com.techgear.model.User;
import com.techgear.model.Role;
import com.techgear.util.AuthUtil;
import com.techgear.util.PasswordUtil;
import com.techgear.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = AuthUtil.text(request, "username");
            if (!ValidationUtil.isValidUsername(username)) throw new IllegalArgumentException("Username hoặc mật khẩu không đúng.");
            // Tài khoản quản trị viên dùng để demo trên máy local, không phụ thuộc database.
            if ("admin".equals(username) && "Admin@123456".equals(request.getParameter("password"))) {
                User admin = new User(0, 1, "admin", "Quản trị viên", "admin@techgear.local", null,
                        "", "", true, LocalDateTime.now());
                request.getSession().invalidate();
                AuthUtil.saveSession(request, admin, "ADMIN");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
            User user = new UserDAO().getUserByUsername(username);
            if (user == null || !PasswordUtil.verifyPassword(request.getParameter("password"), user.getPasswordHash()))
                throw new IllegalArgumentException("Username hoặc mật khẩu không đúng.");
            if (!user.isActive()) throw new IllegalArgumentException("Tài khoản đã bị khóa. Vui lòng liên hệ ADMIN.");
            Role role = new RoleDAO().getRoleById(user.getRoleId());
            if (role == null) throw new IllegalArgumentException("Tài khoản chưa được cấu hình vai trò hợp lệ.");
            request.getSession().invalidate(); // Start a new session after successful login.
            AuthUtil.saveSession(request, user, role.getRoleName());
            response.sendRedirect(request.getContextPath() + ("ADMIN".equals(role.getRoleName()) ? "/admin/users" : "/profile"));
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }
}
