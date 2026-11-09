package com.techgear.controller.auth;

import com.techgear.dao.UserDAO;
import com.techgear.dao.RoleDAO;
import com.techgear.model.User;
import com.techgear.model.Role;
import com.techgear.model.CartItem;
import com.techgear.util.AuthUtil;
import com.techgear.util.PasswordUtil;
import com.techgear.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
                request.getSession().setAttribute("csrfToken", UUID.randomUUID().toString());
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
            User user = new UserDAO().getUserByUsername(username);
            if (user == null || !PasswordUtil.verifyPassword(request.getParameter("password"), user.getPasswordHash()))
                throw new IllegalArgumentException("Username hoặc mật khẩu không đúng.");
            if (!user.isActive()) throw new IllegalArgumentException("Tài khoản đã bị khóa. Vui lòng liên hệ ADMIN.");
            Role role = new RoleDAO().getRoleById(user.getRoleId());
            if (role == null) throw new IllegalArgumentException("Tài khoản chưa được cấu hình vai trò hợp lệ.");
            HttpSession oldSession = request.getSession(false);
            List<CartItem> savedCart = copyCart(oldSession);
            boolean returnToCheckout = oldSession != null
                    && "checkout".equals(oldSession.getAttribute("afterLoginRedirect"));
            if (oldSession != null) {
                oldSession.invalidate(); // Start a fresh authenticated session.
            }
            AuthUtil.saveSession(request, user, role.getRoleName());
            HttpSession newSession = request.getSession();
            newSession.setAttribute("csrfToken", UUID.randomUUID().toString());
            newSession.setAttribute("cart", savedCart);
            int cartCount = 0;
            for (CartItem item : savedCart) {
                cartCount += item.getQuantity();
            }
            newSession.setAttribute("cartCount", cartCount);

            String destination;
            if ("ADMIN".equals(role.getRoleName())) {
                destination = "/admin/users";
            } else if (returnToCheckout) {
                destination = "/checkout";
            } else {
                destination = "/profile";
            }
            response.sendRedirect(request.getContextPath() + destination);
            return;
        } catch (IllegalArgumentException exception) {
            response.setStatus(400); request.setAttribute("error", exception.getMessage());
        } catch (SQLException exception) { AuthUtil.databaseError(request, response, exception); }
        doGet(request, response);
    }

    private List<CartItem> copyCart(HttpSession session) {
        if (session == null || !(session.getAttribute("cart") instanceof List<?>)) {
            return new ArrayList<>();
        }
        List<CartItem> savedCart = new ArrayList<>();
        for (Object value : (List<?>) session.getAttribute("cart")) {
            if (value instanceof CartItem) {
                CartItem item = (CartItem) value;
                // Discard the old automatically inserted sample keyboard.
                if (item.getProductId() != -1) {
                    savedCart.add(new CartItem(item.getCartItemId(), item.getUserId(),
                            item.getProductId(), item.getQuantity()));
                }
            }
        }
        return savedCart;
    }
}
