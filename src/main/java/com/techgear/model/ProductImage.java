package com.techgear.model;


/** Shared model contract; coordinate field changes with the whole team. */
public class ProductImage {
    private int imageId;
    private int productId;
    private String imageUrl;
    private boolean primaryImage;

    public ProductImage() { }

    public ProductImage(int imageId, int productId, String imageUrl, boolean primaryImage) {
        this.imageId = imageId;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.primaryImage = primaryImage;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimaryImage() {
        return primaryImage;
    }

    public void setPrimaryImage(boolean primaryImage) {
        this.primaryImage = primaryImage;
    }
}
