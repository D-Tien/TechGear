package com.techgear.controller.cart;

import java.math.BigDecimal;

/** Product information needed to show one row in the cart. */
public class CartProduct {
    private final int productId;
    private final String name;
    private final BigDecimal price;
    private final int stock;
    private final String imageUrl;

    public CartProduct(int productId, String name, BigDecimal price, int stock, String imageUrl) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.stock = stock;
        this.imageUrl = imageUrl;
    }

    public int getProductId() { return productId; }
    public String getName() { return name; }
    public BigDecimal getPrice() { return price; }
    public int getStock() { return stock; }
    public String getImageUrl() { return imageUrl; }
}
