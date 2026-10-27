package com.techgear.dao;

import com.techgear.config.DBConnection;
import com.techgear.model.CartItem;
import com.techgear.model.Order;
import com.techgear.model.OrderDetail;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** Creates one COD order, its details and stock changes in one transaction. */
public class CheckoutOrderDAO {
    public int placeOrder(int userId, String name, String address, String phone,
            List<CartItem> cart) throws SQLException {
        if (userId <= 0 || cart == null || cart.isEmpty()) {
            throw new IllegalArgumentException("Cần đăng nhập và chọn sản phẩm trước khi đặt hàng.");
        }

        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                List<OrderDetail> details = new ArrayList<>();
                Set<Integer> productIds = new HashSet<>();
                BigDecimal total = BigDecimal.ZERO;

                for (CartItem item : cart) {
                    int productId = item.getProductId();
                    if (productId == -1) {
                        productId = new DemoProductDAO().findDemoProductId(connection);
                    }
                    int quantity = item.getQuantity();
                    if (productId <= 0 || quantity < 1 || quantity > 99
                            || !productIds.add(productId)) {
                        throw new IllegalArgumentException("Giỏ hàng có sản phẩm không hợp lệ. Vui lòng kiểm tra lại.");
                    }

                    String selectSql = "SELECT price, stockQuantity FROM dbo.Products WITH (UPDLOCK, HOLDLOCK) "
                            + "WHERE productId = ? AND active = 1";
                    BigDecimal price;
                    int stock;
                    try (PreparedStatement select = connection.prepareStatement(selectSql)) {
                        select.setInt(1, productId);
                        try (ResultSet result = select.executeQuery()) {
                            if (!result.next()) {
                                throw new IllegalArgumentException("Sản phẩm trong giỏ không còn bán.");
                            }
                            price = result.getBigDecimal("price");
                            stock = result.getInt("stockQuantity");
                        }
                    }
                    if (stock < quantity) {
                        throw new IllegalArgumentException("Sản phẩm không đủ tồn kho. Vui lòng giảm số lượng.");
                    }

                    String updateSql = "UPDATE dbo.Products SET stockQuantity = stockQuantity - ? "
                            + "WHERE productId = ? AND stockQuantity >= ? AND active = 1";
                    try (PreparedStatement update = connection.prepareStatement(updateSql)) {
                        update.setInt(1, quantity);
                        update.setInt(2, productId);
                        update.setInt(3, quantity);
                        if (update.executeUpdate() != 1) {
                            throw new IllegalArgumentException("Sản phẩm không đủ tồn kho. Vui lòng thử lại.");
                        }
                    }

                    total = total.add(price.multiply(BigDecimal.valueOf(quantity)));
                    details.add(new OrderDetail(0, 0, productId, quantity, price));
                }

                Order order = new Order();
                order.setUserId(userId);
                order.setRecipientName(name);
                order.setShippingAddress(address);
                order.setPhone(phone);
                order.setTotalAmount(total);
                order.setStatus("PENDING");
                order.setPaymentMethod("COD");
                int orderId = new OrderDAO().insertOrder(connection, order);

                OrderDetailDAO detailDAO = new OrderDetailDAO();
                for (OrderDetail detail : details) {
                    detail.setOrderId(orderId);
                    detailDAO.insertOrderDetail(connection, detail);
                }

                connection.commit();
                return orderId;
            } catch (SQLException | IllegalArgumentException error) {
                connection.rollback();
                throw error;
            }
        }
    }
}
