package com.techgear.controller.cart;

import com.techgear.config.DBConnection;
import com.techgear.dao.DemoProductDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Reads current product data from SQL Server for the cart. */
public class CartProductLookup {
    public static final int DEMO_PRODUCT_ID = -1;

    public CartProduct find(int productId) throws SQLException {
        if (productId == DEMO_PRODUCT_ID) {
            try (Connection connection = DBConnection.getConnection()) {
                productId = new DemoProductDAO().findDemoProductId(connection);
            }
        }
        if (productId <= 0) {
            return null;
        }

        String sql = "SELECT p.productId, p.productName, p.price, p.stockQuantity, p.imageUrl "
                + "FROM dbo.Products p WHERE p.productId = ? AND p.active = 1";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                return new CartProduct(result.getInt("productId"),
                        result.getString("productName"), result.getBigDecimal("price"),
                        result.getInt("stockQuantity"), result.getString("imageUrl"));
            }
        }
    }
}
