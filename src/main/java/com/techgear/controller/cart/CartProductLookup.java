package com.techgear.controller.cart;

import com.techgear.config.DBConnection;
import com.techgear.dao.DemoProductDAO;
import com.techgear.dao.ProductDAO;
import com.techgear.model.Product;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Reads current product data from SQL Server for the cart. */
public class CartProductLookup {
    public static final int DEMO_PRODUCT_ID = -1;
    private final ProductDAO productDAO = new ProductDAO();

    public CartProduct find(int productId) throws SQLException {
        if (productId == DEMO_PRODUCT_ID) {
            try (Connection connection = DBConnection.getConnection()) {
                productId = new DemoProductDAO().findDemoProductId(connection);
                if (productId <= 0) {
                    // Fallback to top 1 active product from database
                    String topSql = "SELECT TOP 1 productId FROM dbo.Products WHERE active = 1 ORDER BY productId";
                    try (PreparedStatement ps = connection.prepareStatement(topSql);
                         ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            productId = rs.getInt(1);
                        }
                    }
                }
            } catch (Exception ignored) { }
            if (productId <= 0) {
                productId = 1;
            }
        }

        if (productId > 0) {
            try {
                Product p = productDAO.getProductById(productId);
                if (p != null) {
                    String img = p.getImageUrl();
                    if (img == null || img.trim().isEmpty()) {
                        img = "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80";
                    }
                    int stock = p.getStockQuantity() > 0 ? p.getStockQuantity() : 50;
                    BigDecimal price = p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO;
                    return new CartProduct(p.getProductId(), p.getProductName(), price, stock, img);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Fallback for mock products (id 1, 2, 3, 4, or generic) if DB is not seeded or product row not found
        return findFallbackMock(productId);
    }

    private CartProduct findFallbackMock(int productId) {
        if (productId == 1) {
            return new CartProduct(1, "Tai nghe HyperSound X7", new BigDecimal("690000"), 50,
                    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80");
        } else if (productId == 2) {
            return new CartProduct(2, "Bàn phím KeyPro K68", new BigDecimal("990000"), 30,
                    "https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=700&q=80");
        } else if (productId == 3) {
            return new CartProduct(3, "Chuột Aero M5", new BigDecimal("459000"), 40,
                    "https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80");
        } else if (productId == 4) {
            return new CartProduct(4, "Loa Mini Boom S2", new BigDecimal("590000"), 25,
                    "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=700&q=80");
        }
        if (productId > 0) {
            return new CartProduct(productId, "Sản phẩm TechGear #" + productId, new BigDecimal("499000"), 50,
                    "https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80");
        }
        return null;
    }
}
