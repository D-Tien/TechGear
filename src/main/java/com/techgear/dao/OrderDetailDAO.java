package com.techgear.dao;

import com.techgear.model.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

public class OrderDetailDAO {
    public OrderDetailDAO() { }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        return Collections.emptyList();
    }

    public boolean insertOrderDetail(OrderDetail detail) {
        return false;
    }

    // Uses the same connection as Orders and the stock updates.
    public void insertOrderDetail(Connection connection, OrderDetail detail) throws SQLException {
        String sql = "INSERT INTO dbo.OrderDetails (orderId, productId, quantity, unitPrice) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, detail.getOrderId());
            statement.setInt(2, detail.getProductId());
            statement.setInt(3, detail.getQuantity());
            statement.setBigDecimal(4, detail.getUnitPrice());
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Không lưu được chi tiết đơn hàng.");
            }
        }
    }
}
