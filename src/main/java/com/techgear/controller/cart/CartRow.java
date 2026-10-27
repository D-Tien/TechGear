package com.techgear.controller.cart;

/** Values prepared for one table row in cart.jsp. */
public class CartRow {
    private final int productId;
    private final String name;
    private final String imageUrl;
    private final int quantity;
    private final int stock;
    private final String priceText;
    private final String lineTotalText;

    public CartRow(int productId, String name, String imageUrl, int quantity,
            int stock, String priceText, String lineTotalText) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.stock = stock;
        this.priceText = priceText;
        this.lineTotalText = lineTotalText;
    }

    public int getProductId() { return productId; }
    public String getName() { return name; }
    public String getImageUrl() { return imageUrl; }
    public int getQuantity() { return quantity; }
    public int getStock() { return stock; }
    public String getPriceText() { return priceText; }
    public String getLineTotalText() { return lineTotalText; }
}
