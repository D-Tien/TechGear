package com.techgear.dao;

import com.techgear.model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    public OrderDAO() { }

    private Order read(ResultSet r) throws SQLException { return new Order(r.getInt("orderId"),r.getInt("userId"),r.getString("recipientName"),r.getString("shippingAddress"),r.getString("phone"),r.getBigDecimal("totalAmount"),r.getString("status"),r.getString("paymentMethod"),r.getTimestamp("createdAt").toLocalDateTime()); }
    private List<Order> query(String sql,int id,boolean hasId) throws SQLException { List<Order> list=new ArrayList<>(); try(Connection c=com.techgear.config.DBConnection.getConnection();PreparedStatement s=c.prepareStatement(sql)){if(hasId)s.setInt(1,id);try(ResultSet r=s.executeQuery()){while(r.next())list.add(read(r));}} return list; }
    public List<Order> getAllOrders() throws SQLException { return query("SELECT * FROM dbo.Orders ORDER BY createdAt DESC",0,false); }

    public Order getOrderById(int id) throws SQLException { List<Order> list=query("SELECT * FROM dbo.Orders WHERE orderId = ?",id,true); return list.isEmpty()?null:list.get(0); }

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
}
