package com.techgear.controller.user;

import com.techgear.dao.UserDAO;
import com.techgear.model.User;
import com.techgear.util.AuthUtil;
import com.techgear.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("profile", AuthUtil.currentUser(request));
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            // Use session userId; ignore any userId/roleId/active sent by a client.
            User user = dao.getUserById(AuthUtil.currentUser(request).getUserId());
            if (user == null || !user.isActive()) throw new IllegalArgumentException("Tài khoản không còn hoạt động.");
            if (!PasswordUtil.verifyPassword(request.getParameter("currentPassword"), user.getPasswordHash()))
                throw new IllegalArgumentException("Mật khẩu hiện tại không đúng.");
            AuthUtil.readProfile(request, user);
            User emailOwner = dao.getUserByEmail(user.getEmail());
            if (emailOwner != null && emailOwner.getUserId() != user.getUserId()) throw new IllegalArgumentException("Email đã được sử dụng.");
            if (!dao.updateProfile(user)) throw new IllegalArgumentException("Không lưu được hồ sơ. Vui lòng đăng nhập lại.");
            AuthUtil.saveSession(request, user, (String) request.getSession().getAttribute("roleName"));
            response.sendRedirect(request.getContextPath() + "/profile?saved=1");
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }
}
