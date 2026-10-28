package com.techgear.dao;

import com.techgear.model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

public class OrderDAO {
    public OrderDAO() { }

    public List<Order> getAllOrders() {
        return Collections.emptyList();
    }

    public Order getOrderById(int id) {
        return null;
    }

    public List<Order> getOrdersByUserId(int userId) {
        return Collections.emptyList();
    }

    public int insertOrder(Order order) {
        return 0;
    }

    // Checkout passes its connection so this insert shares the stock transaction.
    public int insertOrder(Connection connection, Order order) throws SQLException {
        String sql = "INSERT INTO dbo.Orders "
                + "(userId, recipientName, shippingAddress, phone, totalAmount, status, paymentMethod) "
                + "OUTPUT INSERTED.orderId VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, order.getUserId());
            statement.setString(2, order.getRecipientName());
            statement.setString(3, order.getShippingAddress());
            statement.setString(4, order.getPhone());
            statement.setBigDecimal(5, order.getTotalAmount());
            statement.setString(6, order.getStatus());
            statement.setString(7, order.getPaymentMethod());
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    throw new SQLException("Không tạo được đơn hàng.");
                }
                return result.getInt(1);
            }
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        return false;
    }
}
