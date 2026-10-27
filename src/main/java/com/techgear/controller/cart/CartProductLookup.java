package com.techgear.controller.cart;

import com.techgear.config.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Reads products for the cart without changing the catalog module. */
public class CartProductLookup {
    public static final int DEMO_PRODUCT_ID = -1;

    public CartProduct find(int productId) throws SQLException {
        if (productId == DEMO_PRODUCT_ID) {
            return new CartProduct(DEMO_PRODUCT_ID, "Razer Huntsman V3 Pro",
                    new BigDecimal("5990000"), 99,
                    "/assets/images/razerhuntsmanv3pro.jpg");
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
