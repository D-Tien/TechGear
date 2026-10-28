package com.techgear.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.techgear.dao.OrderDAO;
import java.sql.SQLException;

@WebServlet("/admin/orders")
public class OrderManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public OrderManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try { request.setAttribute("orders",new OrderDAO().getAllOrders()); }
        catch(SQLException e){ throw new ServletException("Không đọc được đơn hàng.",e); }
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try { int id=Integer.parseInt(request.getParameter("orderId")); String status=request.getParameter("status");
            if(!"PENDING".equals(status)&&!"CONFIRMED".equals(status)&&!"SHIPPING".equals(status)&&!"DELIVERED".equals(status)&&!"CANCELLED".equals(status)) { response.sendError(400,"Trạng thái không hợp lệ."); return; }
            new OrderDAO().updateOrderStatus(id,status); response.sendRedirect(request.getContextPath()+"/admin/orders");
        } catch(Exception e){ throw new ServletException("Không cập nhật được đơn hàng.",e); }
    }
}
