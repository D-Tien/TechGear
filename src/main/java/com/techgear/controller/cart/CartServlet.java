package com.techgear.controller.cart;

import com.techgear.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Bàn phím mẫu trong giỏ, chưa liên kết database.
    private static final int DEMO_PRODUCT_ID = -1;
    private static final int DEMO_PRICE = 5990000;
    private static final int MAX_QUANTITY = 99;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CartItem> cart = getCart(request.getSession());
        CartItem product = findDemoProduct(cart);
        int quantity = product == null ? 0 : product.getQuantity();

        request.setAttribute("quantity", quantity);
        request.setAttribute("totalText", formatPrice((long) DEMO_PRICE * quantity));
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CartItem> cart = getCart(request.getSession());
        CartItem product = findDemoProduct(cart);
        String action = request.getParameter("action");

        if ("increase".equals(action)) {
            if (product != null && product.getQuantity() < MAX_QUANTITY) {
                product.setQuantity(product.getQuantity() + 1);
            }
        } else if ("decrease".equals(action)) {
            if (product != null && product.getQuantity() > 1) {
                product.setQuantity(product.getQuantity() - 1);
            }
        } else if ("remove".equals(action)) {
            if (product != null) {
                cart.remove(product);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thao tác không hợp lệ.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        // Chỉ đặt sẵn một bàn phím lần đầu, không thêm lại sau khi người dùng xóa.
        if (session.getAttribute("demoCartInitialized") == null) {
            if (findDemoProduct(cart) == null) {
                cart.add(new CartItem(0, 0, DEMO_PRODUCT_ID, 1));
            }
            session.setAttribute("demoCartInitialized", true);
        }
        return cart;
    }

    private CartItem findDemoProduct(List<CartItem> cart) {
        for (CartItem item : cart) {
            if (item.getProductId() == DEMO_PRODUCT_ID) {
                return item;
            }
        }
        return null;
    }

    private String formatPrice(long amount) {
        NumberFormat format = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
        return format.format(amount) + " đ";
    }
}

