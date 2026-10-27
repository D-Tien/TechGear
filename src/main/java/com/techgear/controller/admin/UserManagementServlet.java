package com.techgear.controller.admin;

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

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String keyword = AuthUtil.text(request, "keyword");
            if (keyword.length() > 254) keyword = keyword.substring(0, 254);
            request.setAttribute("users", new UserDAO().searchUsers(keyword));
            request.setAttribute("roles", new RoleDAO().getAllRoles());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            User admin = dao.getUserById(AuthUtil.currentUser(request).getUserId());
            RoleDAO roles = new RoleDAO();
            Role adminRole = admin == null ? null : roles.getRoleById(admin.getRoleId());
            if (admin == null || !admin.isActive() || adminRole == null || !"ADMIN".equals(adminRole.getRoleName())) {
                response.sendError(403); return;
            }
            if (!PasswordUtil.verifyPassword(request.getParameter("adminPassword"), admin.getPasswordHash()))
                throw new IllegalArgumentException("Mật khẩu xác nhận của ADMIN không đúng.");
            String action = AuthUtil.text(request, "action");
            if (!"create".equals(action) && !"update".equals(action)) throw new IllegalArgumentException("Thao tác không hợp lệ.");
            User user;
            if ("create".equals(action)) {
                user = new User();
                String username = AuthUtil.text(request, "username");
                if (!ValidationUtil.isValidUsername(username)) throw new IllegalArgumentException("Username cần 4–30 ký tự: chữ không dấu, số, _, . hoặc -.");
                if (dao.getUserByUsername(username) != null) throw new IllegalArgumentException("Username đã được sử dụng.");
                user.setUsername(username);
                user.setPasswordHash(PasswordUtil.hashPassword(AuthUtil.newPassword(request)));
            } else {
                user = dao.getUserById(AuthUtil.positiveId(request.getParameter("userId")));
                if (user == null) throw new IllegalArgumentException("Không tìm thấy người dùng.");
            }
            AuthUtil.readProfile(request, user);
            User emailOwner = dao.getUserByEmail(user.getEmail());
            if (emailOwner != null && emailOwner.getUserId() != user.getUserId()) throw new IllegalArgumentException("Email đã được sử dụng.");
            Role role = roles.getRoleById(AuthUtil.positiveId(request.getParameter("roleId")));
            if (role == null) throw new IllegalArgumentException("Vai trò không tồn tại.");
            user.setRoleId(role.getRoleId());
            if ("create".equals(action)) {
                if (!dao.insertUser(user)) throw new SQLException("User insert did not create a row.");
            } else {
                user.setActive("true".equals(request.getParameter("active")));
                if (user.getUserId() == admin.getUserId() && (!user.isActive() || !"ADMIN".equals(role.getRoleName())))
                    throw new IllegalArgumentException("Không thể tự khóa hoặc tự hạ quyền ADMIN.");
                if (!dao.updateUser(user)) throw new IllegalArgumentException("Người dùng không còn tồn tại.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/users?saved=1");
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }
}
