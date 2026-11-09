package com.techgear.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.techgear.dao.OrderDAO;
import com.techgear.dao.OrderDetailDAO;
import com.techgear.model.Order;
import java.sql.SQLException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/orders")
public class OrderManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public OrderManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        if (!isAllowedStatus(status)) status = "ALL";
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";
        int page = parsePage(request.getParameter("page"));
        int pageSize = 5;
        try {
            OrderDAO orderDAO = new OrderDAO();
            int totalOrders = orderDAO.countAdminOrders(status, keyword);
            int totalPages = Math.max(1, (int) Math.ceil(totalOrders / (double) pageSize));
            page = Math.min(page, totalPages);
            List<Order> orders = orderDAO.getAdminOrders(status, keyword, (page - 1) * pageSize, pageSize);
            List<Integer> ids = new ArrayList<>();
            for (Order order : orders) ids.add(order.getOrderId());
            request.setAttribute("orders", orders);
            request.setAttribute("orderItems", new OrderDetailDAO().getAdminItemsByOrderIds(ids));
            request.setAttribute("statusCounts", orderDAO.getOrderStatusCounts());
            request.setAttribute("selectedStatus", status);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
        }
        catch(SQLException e){ throw new ServletException("Không đọc được đơn hàng.",e); }
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("orderId"));
            String nextStatus = request.getParameter("status");
            if (id <= 0 || !isAllowedStatus(nextStatus) || "ALL".equals(nextStatus)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thông tin cập nhật đơn hàng không hợp lệ.");
                return;
            }
            if (!new OrderDAO().updateOrderStatus(id, nextStatus)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
                return;
            }
            String filterStatus = safeStatus(request.getParameter("filterStatus"));
            String keyword = request.getParameter("keyword");
            int page = parsePage(request.getParameter("page"));
            String url = request.getContextPath() + "/admin/orders?status=" + filterStatus
                    + "&page=" + page + "&updated=1";
            if (keyword != null && !keyword.isBlank()) {
                url += "&keyword=" + URLEncoder.encode(keyword.trim(), StandardCharsets.UTF_8);
            }
            response.sendRedirect(url);
        } catch(NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ.");
        } catch(SQLException e) {
            throw new ServletException("Không cập nhật được đơn hàng.",e);
        }
    }

    private boolean isAllowedStatus(String status) {
        return "ALL".equals(status) || "PENDING".equals(status) || "CONFIRMED".equals(status)
                || "SHIPPING".equals(status) || "DELIVERED".equals(status) || "CANCELLED".equals(status);
    }

    private String safeStatus(String status) { return isAllowedStatus(status) ? status : "ALL"; }

    private int parsePage(String value) {
        try { return Math.max(1, Integer.parseInt(value)); }
        catch (NumberFormatException ignored) { return 1; }
    }
}
