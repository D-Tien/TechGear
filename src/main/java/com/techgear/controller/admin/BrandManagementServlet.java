package com.techgear.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/brands")
public class BrandManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BrandManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Implement request handling; no DAO calls in this skeleton.
        request.getRequestDispatcher("/WEB-INF/views/admin/brands.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Agree on request parameters and implement this action.
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "TODO: Implement action.");
    }
}
