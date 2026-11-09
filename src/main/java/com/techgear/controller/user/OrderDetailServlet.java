package com.techgear.controller.user;

import com.techgear.dao.OrderDAO;
import com.techgear.dao.OrderDetailDAO;
import com.techgear.dao.ProductDAO;
import com.techgear.model.Order;
import com.techgear.model.OrderDetail;
import com.techgear.model.Product;
import com.techgear.model.User;
import com.techgear.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = AuthUtil.currentUser(request);
        int orderId = readOrderId(request, response);
        if (orderId <= 0) return;

        try {
            Order order = new OrderDAO().getOrderByIdAndUserId(orderId, user.getUserId());
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
                return;
            }
            List<OrderDetailRow> rows = makeRows(orderId, request);
            request.setAttribute("order", order);
            request.setAttribute("orderRows", rows);
            request.setAttribute("totalText", format(order.getTotalAmount()));
            if ("1".equals(request.getParameter("cancelled"))) {
                request.setAttribute("orderMessage", "Đơn hàng đã được hủy.");
            }
            request.getRequestDispatcher("/WEB-INF/views/user/order-detail.jsp").forward(request, response);
        } catch (SQLException error) {
            throw new ServletException("Không đọc được chi tiết đơn hàng.", error);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = AuthUtil.currentUser(request);
        int orderId = readOrderId(request, response);
        if (orderId <= 0) return;
        if (!"cancel".equals(request.getParameter("action"))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thao tác không hợp lệ.");
            return;
        }
        try {
            boolean cancelled = new OrderDAO().cancelPendingOrder(orderId, user.getUserId());
            if (!cancelled) {
                response.sendError(HttpServletResponse.SC_CONFLICT,
                        "Chỉ có thể hủy đơn hàng đang chờ xác nhận.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId + "&cancelled=1");
        } catch (SQLException error) {
            throw new ServletException("Không thể hủy đơn hàng.", error);
        }
    }

    private int readOrderId(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (id > 0) return id;
        } catch (NumberFormatException ignored) { }
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ.");
        return -1;
    }

    private List<OrderDetailRow> makeRows(int orderId, HttpServletRequest request)
            throws SQLException {
        List<OrderDetailRow> rows = new ArrayList<>();
        ProductDAO products = new ProductDAO();
        for (OrderDetail detail : new OrderDetailDAO().getOrderDetailsByOrderId(orderId)) {
            Product product = products.getProductById(detail.getProductId());
            String name = product == null ? "Sản phẩm #" + detail.getProductId()
                    : product.getProductName();
            String image = product == null ? "" : product.getImageUrl();
            if (image != null && image.startsWith("/")) {
                image = request.getContextPath() + image;
            }
            BigDecimal price = detail.getUnitPrice();
            BigDecimal lineTotal = price.multiply(BigDecimal.valueOf(detail.getQuantity()));
            rows.add(new OrderDetailRow(name, image, detail.getQuantity(),
                    format(price), format(lineTotal)));
        }
        return rows;
    }

    private String format(BigDecimal amount) {
        NumberFormat format = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
        return format.format(amount) + " đ";
    }
}
