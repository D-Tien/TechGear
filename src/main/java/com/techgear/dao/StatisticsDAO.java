package com.techgear.dao;

import java.util.Map;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.techgear.config.DBConnection;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/** Skeleton only: return values do not represent database results. */
public class StatisticsDAO {
    public StatisticsDAO() { }

    /** Lifetime dashboard revenue from completed orders only. */
    public BigDecimal getCompletedRevenue() {
        String sql = "SELECT COALESCE(SUM(totalAmount), 0) FROM dbo.Orders WHERE status = 'DELIVERED'";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet result = statement.executeQuery()) {
            result.next();
            return result.getBigDecimal(1);
        } catch (SQLException error) {
            return BigDecimal.ZERO;
        }
    }

    /** Total order count, including every status. */
    public long getAllOrderCount() {
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement("SELECT COUNT_BIG(*) FROM dbo.Orders");
                ResultSet result = statement.executeQuery()) {
            result.next();
            return result.getLong(1);
        } catch (SQLException error) {
            return 0;
        }
    }

    /** Number of orders that have reached DELIVERED status. */
    public long getCompletedOrderCount() {
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        "SELECT COUNT_BIG(*) FROM dbo.Orders WHERE status = 'DELIVERED'");
                ResultSet result = statement.executeQuery()) {
            result.next();
            return result.getLong(1);
        } catch (SQLException error) {
            return 0;
        }
    }

    /** Top ten products by quantity in delivered orders, including inactive products. */
    public List<Map<String, Object>> getBestSellingProducts() {
        String sql = "SELECT TOP (10) p.productName, "
                + "SUM(CAST(d.quantity AS BIGINT)) AS unitsSold, "
                + "SUM(d.unitPrice * CAST(d.quantity AS DECIMAL(18,0))) AS revenue "
                + "FROM dbo.OrderDetails d "
                + "JOIN dbo.Orders o ON o.orderId = d.orderId "
                + "JOIN dbo.Products p ON p.productId = d.productId "
                + "WHERE o.status = 'DELIVERED' "
                + "GROUP BY p.productId, p.productName "
                + "ORDER BY SUM(CAST(d.quantity AS BIGINT)) DESC, p.productId";
        List<Map<String, Object>> products = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productName", result.getString("productName"));
                product.put("unitsSold", result.getLong("unitsSold"));
                product.put("revenue", result.getBigDecimal("revenue"));
                products.add(product);
            }
        } catch (SQLException ignored) {
            // Keep the dashboard available with an empty ranking if the query fails.
        }
        return products;
    }

    public BigDecimal getTotalRevenue(LocalDateTime fromInclusive, LocalDateTime toExclusive) {
        try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("SELECT COALESCE(SUM(totalAmount),0) FROM dbo.Orders WHERE createdAt>=? AND createdAt<? AND status<>'CANCELLED'")){s.setTimestamp(1,Timestamp.valueOf(fromInclusive));s.setTimestamp(2,Timestamp.valueOf(toExclusive));try(ResultSet r=s.executeQuery()){r.next();return r.getBigDecimal(1);}}catch(SQLException e){return BigDecimal.ZERO;}
    }

    public int getOrderCount(LocalDateTime fromInclusive, LocalDateTime toExclusive) {
        try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("SELECT COUNT(*) FROM dbo.Orders WHERE createdAt>=? AND createdAt<?")){s.setTimestamp(1,Timestamp.valueOf(fromInclusive));s.setTimestamp(2,Timestamp.valueOf(toExclusive));try(ResultSet r=s.executeQuery()){r.next();return r.getInt(1);}}catch(SQLException e){return 0;}
    }

    public int getCustomerCount() {
        try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("SELECT COUNT(*) FROM dbo.Users WHERE roleId=2")){try(ResultSet r=s.executeQuery()){r.next();return r.getInt(1);}}catch(SQLException e){return 0;}
    }

    public Map<String, BigDecimal> getMonthlyRevenue(int year) {
        Map<String,BigDecimal> result=new LinkedHashMap<>(); try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("SELECT MONTH(createdAt),COALESCE(SUM(totalAmount),0) FROM dbo.Orders WHERE YEAR(createdAt)=? AND status<>'CANCELLED' GROUP BY MONTH(createdAt) ORDER BY MONTH(createdAt)")){s.setInt(1,year);try(ResultSet r=s.executeQuery()){while(r.next())result.put(String.valueOf(r.getInt(1)),r.getBigDecimal(2));}}catch(SQLException ignored){} return result;
    }
}
