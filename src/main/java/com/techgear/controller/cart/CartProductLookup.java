package com.techgear.controller.cart;

import com.techgear.controller.product.DemoProductCatalog;
import com.techgear.dao.ProductDAO;
import com.techgear.model.Product;
import java.math.BigDecimal;
import java.sql.SQLException;

/** Reads current product data from SQL Server or the shared sample catalog. */
public class CartProductLookup {
    private final ProductDAO productDAO = new ProductDAO();

    public CartProduct find(int productId) throws SQLException {
        if (productId <= -101) {
            Product sample = DemoProductCatalog.find(productId);
            return sample == null ? null : fromProduct(sample);
        }

        if (productId <= 0) {
            return null;
        }

        Product product = productDAO.getProductById(productId);
        if (product == null || !product.isActive()) {
            return null;
        }
        return fromProduct(product);
    }

    private CartProduct fromProduct(Product product) {
        BigDecimal price = product.getPrice() == null ? BigDecimal.ZERO : product.getPrice();
        return new CartProduct(product.getProductId(), product.getProductName(), price,
                product.getStockQuantity(), product.getImageUrl());
    }
}
