package com.techgear.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/** AuthenticationFilter runs first and refreshes roleName from SQL Server. */
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("roleName"))) {
            res.sendError(403, "Chỉ ADMIN được truy cập chức năng này.");
            return;
        }
        chain.doFilter(request, response);
    }
}
