package com.techgear.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.techgear.dao.OrderDAO;
import com.techgear.model.User;
import com.techgear.util.AuthUtil;
import java.sql.SQLException;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MyOrdersServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user=AuthUtil.currentUser(request);
        try { request.setAttribute("orders",new OrderDAO().getOrdersByUserId(user.getUserId())); }
        catch(SQLException e){ throw new ServletException("Không đọc được đơn hàng.",e); }
        request.getRequestDispatcher("/WEB-INF/views/user/my-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath()+"/my-orders");
    }
}
