package com.techgear.controller.cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        boolean success = session != null
                && Boolean.TRUE.equals(session.getAttribute("checkoutDemoSuccess"));
        if (success) {
            session.removeAttribute("checkoutDemoSuccess");
        }
        request.setAttribute("success", success);
        request.getRequestDispatcher("/WEB-INF/views/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Object savedCart = session.getAttribute("cart");
        if (!(savedCart instanceof List<?>)) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<?> cart = (List<?>) savedCart;
        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Thanh toán mô phỏng: xóa giỏ, chưa tạo đơn hàng trong database.
        cart.clear();
        session.setAttribute("demoCartInitialized", true);
        session.setAttribute("checkoutDemoSuccess", true);
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
