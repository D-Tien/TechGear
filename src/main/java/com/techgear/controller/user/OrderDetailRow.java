package com.techgear.controller.user;

/** Display values for one product in a customer's order detail page. */
public class OrderDetailRow {
    private final String name;
    private final String imageUrl;
    private final int quantity;
    private final String priceText;
    private final String lineTotalText;

    public OrderDetailRow(String name, String imageUrl, int quantity,
            String priceText, String lineTotalText) {
        this.name = name;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.priceText = priceText;
        this.lineTotalText = lineTotalText;
    }

    public String getName() { return name; }
    public String getImageUrl() { return imageUrl; }
    public int getQuantity() { return quantity; }
    public String getPriceText() { return priceText; }
    public String getLineTotalText() { return lineTotalText; }
}
