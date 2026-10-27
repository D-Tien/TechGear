package com.techgear.controller.cart;

import com.techgear.dao.CheckoutOrderDAO;
import com.techgear.model.CartItem;
import com.techgear.model.User;
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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartProductLookup products = new CartProductLookup();
    private final CheckoutOrderDAO orders = new CheckoutOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("currentUser");
        List<CartItem> cart = readCart(session);
        String name = clean(request.getParameter("recipientName"));
        String address = clean(request.getParameter("shippingAddress"));
        String phone = clean(request.getParameter("phone"));
        request.setAttribute("recipientName", name);
        request.setAttribute("shippingAddress", address);
        request.setAttribute("phone", phone);

        if (user == null || user.getUserId() <= 0) {
            request.setAttribute("checkoutError", "Bạn cần đăng nhập trước khi đặt hàng.");
        } else if (cart.isEmpty()) {
            request.setAttribute("checkoutError", "Giỏ hàng đang trống.");
        } else if (name.isEmpty() || name.length() > 100 || address.isEmpty()
                || address.length() > 500 || phone.isEmpty() || phone.length() > 20) {
            request.setAttribute("checkoutError", "Vui lòng nhập đúng tên, địa chỉ và số điện thoại.");
        } else {
            try {
                int orderId = orders.placeOrder(user.getUserId(), name, address, phone, cart);
                cart.clear();
                session.setAttribute("demoCartInitialized", true);
                session.setAttribute("checkoutOrderId", orderId);
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            } catch (IllegalArgumentException error) {
                request.setAttribute("checkoutError", error.getMessage());
            } catch (SQLException error) {
                request.setAttribute("checkoutError", "Không lưu được đơn hàng. Vui lòng thử lại.");
                getServletContext().log("Checkout failed", error);
            }
        }
        showPage(request, response);
    }

    private void showPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("currentUser");
        if (session != null && session.getAttribute("checkoutOrderId") != null) {
            request.setAttribute("orderId", session.getAttribute("checkoutOrderId"));
            session.removeAttribute("checkoutOrderId");
        }
        request.setAttribute("loggedIn", user != null && user.getUserId() > 0);
        if (user != null) {
            if (request.getAttribute("recipientName") == null) {
                request.setAttribute("recipientName", user.getFullName());
            }
            if (request.getAttribute("shippingAddress") == null) {
                request.setAttribute("shippingAddress", user.getAddress());
            }
            if (request.getAttribute("phone") == null) {
                request.setAttribute("phone", user.getPhone());
            }
        }

        List<CartItem> cart = readCart(session);
        List<CartRow> rows = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        boolean canOrder = user != null && user.getUserId() > 0 && !cart.isEmpty();
        try {
            for (CartItem item : cart) {
                if ((item.getProductId() <= 0 && item.getProductId() != CartProductLookup.DEMO_PRODUCT_ID)
                        || item.getQuantity() < 1) {
                    canOrder = false;
                    if (request.getAttribute("checkoutError") == null) {
                        request.setAttribute("checkoutError", "Sản phẩm trong giỏ không hợp lệ.");
                    }
                    continue;
                }
                CartProduct product = products.find(item.getProductId());
                if (product == null || product.getStock() < item.getQuantity()) {
                    canOrder = false;
                    if (request.getAttribute("checkoutError") == null) {
                        request.setAttribute("checkoutError", "Sản phẩm đã hết hàng hoặc không còn bán. Hãy kiểm tra giỏ hàng.");
                    }
                    continue;
                }
                BigDecimal lineTotal = product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
                total = total.add(lineTotal);
                rows.add(new CartRow(item.getProductId(), product.getName(), "",
                        item.getQuantity(), product.getStock(),
                        formatPrice(product.getPrice()), formatPrice(lineTotal)));
            }
        } catch (SQLException error) {
            throw new ServletException("Không đọc được sản phẩm trong giỏ.", error);
        }
        request.setAttribute("rows", rows);
        request.setAttribute("totalText", formatPrice(total));
        request.setAttribute("canOrder", canOrder);
        request.getRequestDispatcher("/WEB-INF/views/cart/checkout.jsp").forward(request, response);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> readCart(HttpSession session) {
        if (session == null || !(session.getAttribute("cart") instanceof List<?>)) {
            return new ArrayList<>();
        }
        return (List<CartItem>) session.getAttribute("cart");
    }

    private String formatPrice(BigDecimal amount) {
        NumberFormat format = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
        return format.format(amount) + " đ";
    }
}
