package com.techgear.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.techgear.dao.StatisticsDAO;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DashboardServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StatisticsDAO dao = new StatisticsDAO();
        long totalOrders = dao.getAllOrderCount();
        long completedOrders = dao.getCompletedOrderCount();
        request.setAttribute("revenue", dao.getCompletedRevenue());
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("completionRate", totalOrders == 0 ? 0 : completedOrders * 100.0 / totalOrders);
        request.setAttribute("bestSelling", dao.getBestSellingProducts());
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath()+"/admin/dashboard");
    }
}
