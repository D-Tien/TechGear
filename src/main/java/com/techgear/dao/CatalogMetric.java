package com.techgear.dao;

import java.math.BigDecimal;

/** Sales and on-hand inventory measures for one product, category, or brand. */
public class CatalogMetric {
    private final int stockQuantity;
    private final BigDecimal inventoryPercent;
    private final int soldQuantity;
    private final BigDecimal revenue;

    public CatalogMetric(int stockQuantity, BigDecimal inventoryPercent,
            int soldQuantity, BigDecimal revenue) {
        this.stockQuantity = stockQuantity;
        this.inventoryPercent = inventoryPercent;
        this.soldQuantity = soldQuantity;
        this.revenue = revenue;
    }

    public int getStockQuantity() { return stockQuantity; }
    public BigDecimal getInventoryPercent() { return inventoryPercent; }
    public int getSoldQuantity() { return soldQuantity; }
    public BigDecimal getRevenue() { return revenue; }
}
