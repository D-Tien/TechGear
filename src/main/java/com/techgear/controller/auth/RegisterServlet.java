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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = new User();
            String username = AuthUtil.text(request, "username");
            if (!ValidationUtil.isValidUsername(username)) throw new IllegalArgumentException("Username cần 4–30 ký tự: chữ không dấu, số, _, . hoặc -.");
            user.setUsername(username);
            AuthUtil.readProfile(request, user);
            String password = AuthUtil.newPassword(request);
            UserDAO dao = new UserDAO();
            if (dao.getUserByUsername(username) != null) throw new IllegalArgumentException("Username đã được sử dụng.");
            if (dao.getUserByEmail(user.getEmail()) != null) throw new IllegalArgumentException("Email đã được sử dụng.");
            // Never read roleId/roleName supplied by the registration form.
            Role customer = new RoleDAO().getRoleByName("CUSTOMER");
            if (customer == null) throw new IllegalArgumentException("Database chưa có role CUSTOMER. Hãy nhờ người quản lý khởi tạo role.");
            user.setRoleId(customer.getRoleId());
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            if (!dao.insertUser(user)) throw new SQLException("User insert did not create a row.");
            response.sendRedirect(request.getContextPath() + "/login?registered=1");
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }
}
