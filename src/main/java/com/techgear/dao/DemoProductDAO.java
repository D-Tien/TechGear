package com.techgear.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Finds the database row behind the temporary keyboard shown in the UI. */
public class DemoProductDAO {
    public int findDemoProductId(Connection connection) throws SQLException {
        String sql = "SELECT TOP 1 p.productId FROM dbo.Products p "
                + "JOIN dbo.Brands b ON b.brandId = p.brandId "
                + "WHERE p.productName = ? AND b.brandName = ? AND p.active = 1 "
                + "ORDER BY p.productId";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, "Razer Huntsman V3 Pro");
            statement.setString(2, "Razer");
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getInt(1) : 0;
            }
        }
    }
}
