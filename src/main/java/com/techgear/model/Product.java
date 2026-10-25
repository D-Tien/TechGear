package com.techgear.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Shared model contract; coordinate field changes with the whole team. */
public class Product {
    private int productId;
    private int categoryId;
    private int brandId;
    private String productName;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private boolean active;
    private LocalDateTime createdAt;

    public Product() { }

    public Product(int productId, int categoryId, int brandId, String productName, String description, BigDecimal price, int stockQuantity, boolean active, LocalDateTime createdAt) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.active = active;
        this.createdAt = createdAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
