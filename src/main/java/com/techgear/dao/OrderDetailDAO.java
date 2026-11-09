package com.techgear.dao;

import com.techgear.model.OrderDetail;
import com.techgear.controller.admin.AdminOrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class OrderDetailDAO {
    public OrderDetailDAO() { }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT orderDetailId, orderId, productId, quantity, unitPrice "
                + "FROM dbo.OrderDetails WHERE orderId = ? ORDER BY orderDetailId";
        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    details.add(new OrderDetail(result.getInt("orderDetailId"),
                            result.getInt("orderId"), result.getInt("productId"),
                            result.getInt("quantity"), result.getBigDecimal("unitPrice")));
                }
            }
        }
        return details;
    }

    public Map<Integer, List<AdminOrderItem>> getAdminItemsByOrderIds(List<Integer> orderIds) throws SQLException {
        Map<Integer, List<AdminOrderItem>> itemsByOrder = new LinkedHashMap<>();
        if (orderIds == null || orderIds.isEmpty()) return itemsByOrder;

        StringBuilder sql = new StringBuilder(
                "SELECT d.orderId, p.productName, d.quantity, d.unitPrice "
                + "FROM dbo.OrderDetails d JOIN dbo.Products p ON p.productId = d.productId WHERE d.orderId IN (");
        for (int i = 0; i < orderIds.size(); i++) {
            if (i > 0) sql.append(',');
            sql.append('?');
        }
        sql.append(") ORDER BY d.orderId, d.orderDetailId");

        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < orderIds.size(); i++) statement.setInt(i + 1, orderIds.get(i));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    int orderId = rows.getInt("orderId");
                    itemsByOrder.computeIfAbsent(orderId, key -> new ArrayList<>()).add(
                            new AdminOrderItem(rows.getString("productName"), rows.getInt("quantity"),
                                    rows.getBigDecimal("unitPrice")));
                }
            }
        }
        return itemsByOrder;
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
