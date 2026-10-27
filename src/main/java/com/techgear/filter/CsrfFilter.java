package com.techgear.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

/** Mapped only to Person 1 forms, so other team members can integrate separately. */
public class CsrfFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        res.setHeader("Cache-Control", "no-store");
        res.setHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options", "DENY");
        HttpSession session = req.getSession();
        String token = (String) session.getAttribute("csrfToken");
        if ("POST".equals(req.getMethod()) && (token == null || !token.equals(req.getParameter("csrfToken")))) {
            res.sendError(403, "CSRF token không hợp lệ. Hãy tải lại biểu mẫu.");
            return;
        }
        if (token == null) session.setAttribute("csrfToken", UUID.randomUUID().toString());
        chain.doFilter(request, response);
    }
}
