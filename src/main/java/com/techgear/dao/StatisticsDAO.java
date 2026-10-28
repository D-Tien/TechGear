package com.techgear.dao;

import java.util.Map;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.techgear.config.DBConnection;
import java.sql.*;
import java.util.LinkedHashMap;

/** Skeleton only: return values do not represent database results. */
public class StatisticsDAO {
    public StatisticsDAO() { }

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
