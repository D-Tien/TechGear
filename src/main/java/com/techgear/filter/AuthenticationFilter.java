package com.techgear.filter;

import com.techgear.dao.UserDAO;
import com.techgear.dao.RoleDAO;
import com.techgear.model.User;
import com.techgear.model.Role;
import com.techgear.util.AuthUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class AuthenticationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        res.setHeader("Cache-Control", "no-store");
        HttpSession session = req.getSession(false);
        User current = session == null ? null : (User) session.getAttribute("currentUser");
        if (current == null) { res.sendRedirect(req.getContextPath() + "/login"); return; }
        try {
            // Reload each request: locked accounts and changed permissions take effect immediately.
            User fresh = new UserDAO().getUserById(current.getUserId());
            Role role = fresh == null ? null : new RoleDAO().getRoleById(fresh.getRoleId());
            if (fresh == null || !fresh.isActive() || role == null) {
                session.invalidate();
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            AuthUtil.saveSession(req, fresh, role.getRoleName());
        } catch (SQLException exception) {
            req.getServletContext().log("Authentication database check failed", exception);
            res.sendError(503, "Không thể kiểm tra tài khoản. Vui lòng kiểm tra kết nối database.");
            return;
        }
        chain.doFilter(request, response);
    }
}
