package com.techgear.controller.auth;

import com.techgear.config.DBConnection;
import com.techgear.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DEMO_EMAIL = "demo.checkout@techgear.local";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("demoLoginEnabled", demoLoginEnabled());
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Temporary local checkout login. Real account login belongs to the auth module.
        if (!demoLoginEnabled() || !"demo".equals(request.getParameter("action"))) {
            response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "Đăng nhập thật chưa được triển khai.");
            return;
        }
        try {
            User user = findDemoUser();
            if (user == null) {
                request.setAttribute("error", "Chưa có tài khoản demo trong database. Hãy chạy database/demo_seed.sql.");
                doGet(request, response);
                return;
            }
            request.getSession().setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/checkout");
        } catch (SQLException error) {
            throw new ServletException("Không đọc được tài khoản demo.", error);
        }
    }

    private boolean demoLoginEnabled() {
        return "true".equalsIgnoreCase(System.getenv("TECHGEAR_DEMO_LOGIN"));
    }

    private User findDemoUser() throws SQLException {
        String sql = "SELECT userId, roleId, fullName, email, phone, address "
                + "FROM dbo.Users WHERE email = ? AND active = 1";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, DEMO_EMAIL);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                User user = new User();
                user.setUserId(result.getInt("userId"));
                user.setRoleId(result.getInt("roleId"));
                user.setFullName(result.getString("fullName"));
                user.setEmail(result.getString("email"));
                user.setPhone(result.getString("phone"));
                user.setAddress(result.getString("address"));
                user.setActive(true);
                return user;
            }
        }
    }
}
