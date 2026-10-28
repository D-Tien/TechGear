package com.techgear.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.techgear.dao.StatisticsDAO;
import java.time.LocalDateTime;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DashboardServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StatisticsDAO dao=new StatisticsDAO(); LocalDateTime now=LocalDateTime.now();
        request.setAttribute("revenue",dao.getTotalRevenue(now.withDayOfYear(1).withHour(0).withMinute(0).withSecond(0),now.plusSeconds(1)));
        request.setAttribute("orderCount",dao.getOrderCount(now.withDayOfYear(1).withHour(0).withMinute(0).withSecond(0),now.plusSeconds(1)));
        request.setAttribute("customerCount",dao.getCustomerCount()); request.setAttribute("monthlyRevenue",dao.getMonthlyRevenue(now.getYear()));
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath()+"/admin/dashboard");
    }
}
