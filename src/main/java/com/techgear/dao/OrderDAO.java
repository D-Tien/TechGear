package com.techgear.dao;

import com.techgear.model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {
    public OrderDAO() { }

    private Order read(ResultSet r) throws SQLException { return new Order(r.getInt("orderId"),r.getInt("userId"),r.getString("recipientName"),r.getString("shippingAddress"),r.getString("phone"),r.getBigDecimal("totalAmount"),r.getString("status"),r.getString("paymentMethod"),r.getTimestamp("createdAt").toLocalDateTime()); }
    private List<Order> query(String sql,int id,boolean hasId) throws SQLException { List<Order> list=new ArrayList<>(); try(Connection c=com.techgear.config.DBConnection.getConnection();PreparedStatement s=c.prepareStatement(sql)){if(hasId)s.setInt(1,id);try(ResultSet r=s.executeQuery()){while(r.next())list.add(read(r));}} return list; }
    public List<Order> getAllOrders() throws SQLException { return query("SELECT * FROM dbo.Orders ORDER BY createdAt DESC",0,false); }

    public List<Order> getAdminOrders(String status, String keyword, int offset, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM dbo.Orders WHERE 1=1");
        if (status != null && !status.isBlank() && !"ALL".equals(status)) {
            sql.append(" AND status = ?");
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CONVERT(NVARCHAR(20), orderId) LIKE ? OR recipientName LIKE ? OR phone LIKE ?)");
        }
        sql.append(" ORDER BY createdAt DESC, orderId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        List<Order> result = new ArrayList<>();
        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (status != null && !status.isBlank() && !"ALL".equals(status)) {
                statement.setString(index++, status);
            }
            if (keyword != null && !keyword.isBlank()) {
                String pattern = "%" + keyword.trim() + "%";
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
            }
            statement.setInt(index++, offset);
            statement.setInt(index, pageSize);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) result.add(read(rows));
            }
        }
        return result;
    }

    public int countAdminOrders(String status, String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.Orders WHERE 1=1");
        if (status != null && !status.isBlank() && !"ALL".equals(status)) sql.append(" AND status = ?");
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CONVERT(NVARCHAR(20), orderId) LIKE ? OR recipientName LIKE ? OR phone LIKE ?)");
        }
        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (status != null && !status.isBlank() && !"ALL".equals(status)) statement.setString(index++, status);
            if (keyword != null && !keyword.isBlank()) {
                String pattern = "%" + keyword.trim() + "%";
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
            }
            try (ResultSet rows = statement.executeQuery()) {
                rows.next();
                return rows.getInt(1);
            }
        }
    }

    public Map<String, Integer> getOrderStatusCounts() throws SQLException {
        Map<String, Integer> counts = new LinkedHashMap<>();
        counts.put("ALL", 0);
        counts.put("PENDING", 0);
        counts.put("CONFIRMED", 0);
        counts.put("SHIPPING", 0);
        counts.put("DELIVERED", 0);
        counts.put("CANCELLED", 0);
        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        "SELECT status, COUNT(*) AS total FROM dbo.Orders GROUP BY status");
                ResultSet rows = statement.executeQuery()) {
            while (rows.next()) {
                String status = rows.getString("status");
                int count = rows.getInt("total");
                counts.put(status, count);
                counts.put("ALL", counts.get("ALL") + count);
            }
        }
        return counts;
    }

    public Order getOrderById(int id) throws SQLException { List<Order> list=query("SELECT * FROM dbo.Orders WHERE orderId = ?",id,true); return list.isEmpty()?null:list.get(0); }

    public Order getOrderByIdAndUserId(int orderId, int userId) throws SQLException {
        String sql = "SELECT * FROM dbo.Orders WHERE orderId = ? AND userId = ?";
        try (Connection connection = com.techgear.config.DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            statement.setInt(2, userId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? read(result) : null;
            }
        }
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException { return query("SELECT * FROM dbo.Orders WHERE userId = ? ORDER BY createdAt DESC",userId,true); }

    public int insertOrder(Order order) throws SQLException { try(Connection c=com.techgear.config.DBConnection.getConnection()){return insertOrder(c,order);} }

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

    public boolean updateOrderStatus(int orderId,String status) throws SQLException { try(Connection c=com.techgear.config.DBConnection.getConnection();PreparedStatement s=c.prepareStatement("UPDATE dbo.Orders SET status=? WHERE orderId=?")){s.setString(1,status);s.setInt(2,orderId);return s.executeUpdate()==1;} }

    public boolean cancelPendingOrder(int orderId, int userId) throws SQLException {
        String cancelSql = "UPDATE dbo.Orders SET status = 'CANCELLED' "
                + "WHERE orderId = ? AND userId = ? AND status = 'PENDING'";
        try (Connection connection = com.techgear.config.DBConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement cancel = connection.prepareStatement(cancelSql)) {
                    cancel.setInt(1, orderId);
                    cancel.setInt(2, userId);
                    if (cancel.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                }

                String detailsSql = "SELECT productId, quantity FROM dbo.OrderDetails WHERE orderId = ?";
                try (PreparedStatement details = connection.prepareStatement(detailsSql)) {
                    details.setInt(1, orderId);
                    try (ResultSet result = details.executeQuery()) {
                        while (result.next()) {
                            String stockSql = "UPDATE dbo.Products SET stockQuantity = stockQuantity + ? "
                                    + "WHERE productId = ?";
                            try (PreparedStatement stock = connection.prepareStatement(stockSql)) {
                                stock.setInt(1, result.getInt("quantity"));
                                stock.setInt(2, result.getInt("productId"));
                                stock.executeUpdate();
                            }
                        }
                    }
                }
                connection.commit();
                return true;
            } catch (SQLException error) {
                connection.rollback();
                throw error;
            }
        }
    }
}
