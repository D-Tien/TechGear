package com.techgear.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MyOrdersServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Implement request handling; no DAO calls in this skeleton.
        request.getRequestDispatcher("/WEB-INF/views/user/my-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Agree on request parameters and implement this action.
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "TODO: Implement action.");
    }
}
