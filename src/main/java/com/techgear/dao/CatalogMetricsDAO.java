package com.techgear.dao;

import com.techgear.config.DBConnection;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/** Reads inventory share and sales totals for admin catalog pages. */
public class CatalogMetricsDAO {
    public Map<Integer, CatalogMetric> getProductMetrics() throws SQLException {
        String sql = "SELECT p.productId AS itemId, p.stockQuantity, "
                + "COALESCE(s.soldQuantity,0) AS soldQuantity, COALESCE(s.revenue,0) AS revenue, "
                + "totals.totalStock FROM dbo.Products p CROSS JOIN "
                + "(SELECT COALESCE(SUM(stockQuantity),0) AS totalStock FROM dbo.Products) totals "
                + "LEFT JOIN (SELECT d.productId, SUM(d.quantity) AS soldQuantity, "
                + "SUM(d.quantity * d.unitPrice) AS revenue FROM dbo.OrderDetails d "
                + "JOIN dbo.Orders o ON o.orderId=d.orderId WHERE o.status<>'CANCELLED' "
                + "GROUP BY d.productId) s ON s.productId=p.productId";
        return readMetrics(sql);
    }

    public Map<Integer, CatalogMetric> getCategoryMetrics() throws SQLException {
        String sql = "SELECT c.categoryId AS itemId, COALESCE(stock.stockQuantity,0) AS stockQuantity, "
                + "COALESCE(s.soldQuantity,0) AS soldQuantity, COALESCE(s.revenue,0) AS revenue, "
                + "totals.totalStock FROM dbo.Categories c CROSS JOIN "
                + "(SELECT COALESCE(SUM(stockQuantity),0) AS totalStock FROM dbo.Products) totals "
                + "LEFT JOIN (SELECT categoryId, SUM(stockQuantity) AS stockQuantity "
                + "FROM dbo.Products GROUP BY categoryId) stock ON stock.categoryId=c.categoryId "
                + "LEFT JOIN (SELECT p.categoryId, SUM(d.quantity) AS soldQuantity, "
                + "SUM(d.quantity*d.unitPrice) AS revenue FROM dbo.OrderDetails d "
                + "JOIN dbo.Orders o ON o.orderId=d.orderId JOIN dbo.Products p ON p.productId=d.productId "
                + "WHERE o.status<>'CANCELLED' GROUP BY p.categoryId) s ON s.categoryId=c.categoryId";
        return readMetrics(sql);
    }

    public Map<Integer, CatalogMetric> getBrandMetrics() throws SQLException {
        String sql = "SELECT b.brandId AS itemId, COALESCE(stock.stockQuantity,0) AS stockQuantity, "
                + "COALESCE(s.soldQuantity,0) AS soldQuantity, COALESCE(s.revenue,0) AS revenue, "
                + "totals.totalStock FROM dbo.Brands b CROSS JOIN "
                + "(SELECT COALESCE(SUM(stockQuantity),0) AS totalStock FROM dbo.Products) totals "
                + "LEFT JOIN (SELECT brandId, SUM(stockQuantity) AS stockQuantity "
                + "FROM dbo.Products GROUP BY brandId) stock ON stock.brandId=b.brandId "
                + "LEFT JOIN (SELECT p.brandId, SUM(d.quantity) AS soldQuantity, "
                + "SUM(d.quantity*d.unitPrice) AS revenue FROM dbo.OrderDetails d "
                + "JOIN dbo.Orders o ON o.orderId=d.orderId JOIN dbo.Products p ON p.productId=d.productId "
                + "WHERE o.status<>'CANCELLED' GROUP BY p.brandId) s ON s.brandId=b.brandId";
        return readMetrics(sql);
    }

    private Map<Integer, CatalogMetric> readMetrics(String sql) throws SQLException {
        Map<Integer, CatalogMetric> metrics = new LinkedHashMap<>();
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet rows = statement.executeQuery()) {
            while (rows.next()) {
                int stock = rows.getInt("stockQuantity");
                int totalStock = rows.getInt("totalStock");
                BigDecimal percent = totalStock == 0 ? BigDecimal.ZERO
                        : BigDecimal.valueOf(stock).multiply(BigDecimal.valueOf(100))
                                .divide(BigDecimal.valueOf(totalStock), 1, RoundingMode.HALF_UP);
                metrics.put(rows.getInt("itemId"), new CatalogMetric(stock, percent,
                        rows.getInt("soldQuantity"), rows.getBigDecimal("revenue")));
            }
        }
        return metrics;
    }
}
