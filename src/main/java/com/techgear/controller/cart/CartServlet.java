package com.techgear.controller.cart;

import com.techgear.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet(urlPatterns = {"/cart", "/cart/add"})
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_QUANTITY = 99;
    private final CartProductLookup products = new CartProductLookup();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CartItem> cart = getCart(request.getSession());
        List<CartRow> rows = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        try {
            for (CartItem item : cart) {
                CartProduct product = products.find(item.getProductId());
                if (product == null) {
                    rows.add(new CartRow(item.getProductId(), "Sản phẩm không còn bán",
                            "", item.getQuantity(), 0, "—", "—"));
                    continue;
                }

                BigDecimal lineTotal = product.getPrice().multiply(
                        BigDecimal.valueOf(item.getQuantity()));
                total = total.add(lineTotal);
                String imageUrl = product.getImageUrl();
                if (imageUrl == null) {
                    imageUrl = "";
                } else if (imageUrl.startsWith("/")) {
                    imageUrl = request.getContextPath() + imageUrl;
                }
                rows.add(new CartRow(item.getProductId(), product.getName(), imageUrl,
                        item.getQuantity(), product.getStock(),
                        formatPrice(product.getPrice()), formatPrice(lineTotal)));
            }
        } catch (Exception error) {
            error.printStackTrace();
        }

        updateCartCount(request.getSession(), cart);
        request.setAttribute("rows", rows);
        request.setAttribute("totalText", formatPrice(total));
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (request.getServletPath().equals("/cart/add")) {
            action = "add";
        }
        if (!"add".equals(action) && !"increase".equals(action)
                && !"decrease".equals(action) && !"remove".equals(action)
                && !"setQuantity".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thao tác không hợp lệ.");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        } catch (NumberFormatException error) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã sản phẩm không hợp lệ.");
            return;
        }

        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        CartItem item = findItem(cart, productId);

        if ("remove".equals(action)) {
            if (item != null) {
                cart.remove(item);
            }
        } else if ("decrease".equals(action)) {
            if (item != null && item.getQuantity() > 1) {
                item.setQuantity(item.getQuantity() - 1);
            }
        } else if ("setQuantity".equals(action)) {
            if (item == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Sản phẩm chưa có trong giỏ.");
                return;
            }
            int quantity;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException error) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng không hợp lệ.");
                return;
            }
            try {
                CartProduct product = products.find(productId);
                if (product == null || quantity < 1 || quantity > MAX_QUANTITY
                        || quantity > product.getStock()) {
                    response.sendError(HttpServletResponse.SC_CONFLICT,
                            "Số lượng phải từ 1 đến tồn kho hiện tại của sản phẩm.");
                    return;
                }
                item.setQuantity(quantity);
            } catch (SQLException error) {
                throw new ServletException("Không kiểm tra được tồn kho sản phẩm.", error);
            }
        } else {
            try {
                CartProduct product = products.find(productId);
                if (product == null || product.getStock() < 1) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                            "Sản phẩm không có sẵn.");
                    return;
                }
                if ("increase".equals(action) && item == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Sản phẩm chưa có trong giỏ.");
                    return;
                }

                int addQty = 1;
                String qtyParam = request.getParameter("quantity");
                if (qtyParam != null && !qtyParam.isBlank()) {
                    try {
                        addQty = Math.max(1, Integer.parseInt(qtyParam.trim()));
                    } catch (NumberFormatException ignored) { }
                }

                int currentQty = item == null ? 0 : item.getQuantity();
                int nextQuantity = "increase".equals(action) ? (currentQty + 1) : (currentQty + addQty);
                if (nextQuantity > MAX_QUANTITY || nextQuantity > product.getStock()) {
                    nextQuantity = Math.min(MAX_QUANTITY, product.getStock());
                }

                if (item == null) {
                    cart.add(new CartItem(0, 0, productId, Math.max(1, nextQuantity)));
                } else {
                    item.setQuantity(Math.max(1, nextQuantity));
                }
            } catch (Exception error) {
                error.printStackTrace();
            }
        }

        updateCartCount(session, cart);

        String buyNow = request.getParameter("buyNow");
        if ("true".equalsIgnoreCase(buyNow) || "1".equals(buyNow)) {
            response.sendRedirect(request.getContextPath() + "/checkout");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        // Remove the sample keyboard inserted by older versions of this page.
        cart.removeIf(item -> item.getProductId() == -1);
        updateCartCount(session, cart);
        return cart;
    }

    private void updateCartCount(HttpSession session, List<CartItem> cart) {
        int count = 0;
        if (cart != null) {
            for (CartItem ci : cart) {
                count += ci.getQuantity();
            }
        }
        session.setAttribute("cartCount", count);
    }

    private CartItem findItem(List<CartItem> cart, int productId) {
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                return item;
            }
        }
        return null;
    }

    private String formatPrice(BigDecimal amount) {
        NumberFormat format = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
        return format.format(amount) + " đ";
    }
}
