package com.techgear.controller.auth;

import com.techgear.dao.UserDAO;
import com.techgear.model.User;
import com.techgear.util.AuthUtil;
import com.techgear.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            User user = dao.getUserById(AuthUtil.currentUser(request).getUserId());
            if (user == null || !user.isActive()) throw new IllegalArgumentException("Tài khoản không còn hoạt động.");
            if (!PasswordUtil.verifyPassword(request.getParameter("currentPassword"), user.getPasswordHash()))
                throw new IllegalArgumentException("Mật khẩu hiện tại không đúng.");
            String password = AuthUtil.newPassword(request);
            if (PasswordUtil.verifyPassword(password, user.getPasswordHash())) throw new IllegalArgumentException("Mật khẩu mới phải khác mật khẩu cũ.");
            if (!dao.updatePasswordHash(user.getUserId(), PasswordUtil.hashPassword(password), user.getPasswordHash()))
                throw new IllegalArgumentException("Tài khoản vừa thay đổi. Vui lòng đăng nhập lại.");
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login?changed=1");
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }
}
