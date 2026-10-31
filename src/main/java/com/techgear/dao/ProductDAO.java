package com.techgear.dao;

import com.techgear.config.DBConnection;
import com.techgear.model.Product;
import com.techgear.model.ProductImage;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ProductDAO {
    public ProductDAO() { }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setBrandId(rs.getInt("brandId"));
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStockQuantity(rs.getInt("stockQuantity"));
        p.setActive(rs.getBoolean("active"));

        Timestamp ts = rs.getTimestamp("createdAt");
        if (ts != null) {
            p.setCreatedAt(ts.toLocalDateTime());
        }

        // Extended fields
        p.setSku(rs.getString("sku"));
        p.setSlug(rs.getString("slug"));
        p.setShortDescription(rs.getString("shortDescription"));
        p.setSpecifications(rs.getString("specifications"));
        p.setCompareAtPrice(rs.getBigDecimal("compareAtPrice"));
        p.setWarrantyMonths(rs.getInt("warrantyMonths"));
        p.setImageUrl(rs.getString("imageUrl"));
        p.setAverageRating(rs.getBigDecimal("averageRating"));
        p.setReviewCount(rs.getInt("reviewCount"));
        p.setStatus(rs.getString("status"));
        p.setFeatured(rs.getBoolean("isFeatured"));
        p.setBestSeller(rs.getBoolean("isBestSeller"));
        p.setNewArrival(rs.getBoolean("isNewArrival"));

        try {
            p.setCategoryName(rs.getString("categoryName"));
        } catch (SQLException ignored) { }

        try {
            p.setBrandName(rs.getString("brandName"));
        } catch (SQLException ignored) { }

        return p;
    }

    private static final String SELECT_BASE =
            "SELECT p.productId, p.categoryId, p.brandId, p.productName, p.sku, p.slug, "
            + "p.shortDescription, p.description, p.specifications, p.price, p.compareAtPrice, "
            + "p.stockQuantity, p.warrantyMonths, p.imageUrl, p.averageRating, p.reviewCount, "
            + "p.status, p.isFeatured, p.isBestSeller, p.isNewArrival, p.active, p.createdAt, "
            + "c.categoryName, b.brandName "
            + "FROM dbo.Products p "
            + "LEFT JOIN dbo.Categories c ON c.categoryId = p.categoryId "
            + "LEFT JOIN dbo.Brands b ON b.brandId = p.brandId ";

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = SELECT_BASE + "ORDER BY p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.productId, p.categoryId, p.brandId, p.productName, p.sku, p.slug, "
                + "p.shortDescription, p.description, p.specifications, p.price, p.compareAtPrice, "
                + "p.stockQuantity, p.warrantyMonths, p.imageUrl, p.averageRating, p.reviewCount, "
                + "p.status, p.isFeatured, p.isBestSeller, p.isNewArrival, p.active, p.createdAt, "
                + "c.categoryName, b.brandName "
                + "FROM dbo.Products p "
                + "LEFT JOIN dbo.Categories c ON c.categoryId = p.categoryId "
                + "LEFT JOIN dbo.Brands b ON b.brandId = p.brandId "
                + "WHERE p.active = 1 "
                + "ORDER BY p.isFeatured DESC, p.averageRating DESC, p.productId ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit <= 0 ? 4 : limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getBestSellers(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.productId, p.categoryId, p.brandId, p.productName, p.sku, p.slug, "
                + "p.shortDescription, p.description, p.specifications, p.price, p.compareAtPrice, "
                + "p.stockQuantity, p.warrantyMonths, p.imageUrl, p.averageRating, p.reviewCount, "
                + "p.status, p.isFeatured, p.isBestSeller, p.isNewArrival, p.active, p.createdAt, "
                + "c.categoryName, b.brandName "
                + "FROM dbo.Products p "
                + "LEFT JOIN dbo.Categories c ON c.categoryId = p.categoryId "
                + "LEFT JOIN dbo.Brands b ON b.brandId = p.brandId "
                + "WHERE p.active = 1 "
                + "ORDER BY p.isBestSeller DESC, p.reviewCount DESC, p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit <= 0 ? 4 : limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = SELECT_BASE + "WHERE p.productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> searchProducts(String keyword) {
        return searchProducts(keyword, null, null, null, null);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return searchProducts(null, categoryId, null, null, null);
    }

    public List<Product> getProductsByBrand(int brandId) {
        return searchProducts(null, null, brandId, null, null);
    }

    public List<Product> searchProducts(String keyword, Integer categoryId, Integer brandId, Boolean activeOnly, String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE).append("WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (activeOnly != null && activeOnly) {
            sql.append("AND p.active = 1 ");
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (p.productName LIKE ? OR p.sku LIKE ? OR p.shortDescription LIKE ?) ");
            String term = "%" + keyword.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        if (brandId != null && brandId > 0) {
            sql.append("AND p.brandId = ? ");
            params.add(brandId);
        }

        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price ASC");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price DESC");
        } else if ("rating".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.averageRating DESC");
        } else {
            sql.append("ORDER BY p.productId DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getRelatedProducts(int categoryId, int excludeProductId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.productId, p.categoryId, p.brandId, p.productName, p.sku, p.slug, "
                + "p.shortDescription, p.description, p.specifications, p.price, p.compareAtPrice, "
                + "p.stockQuantity, p.warrantyMonths, p.imageUrl, p.averageRating, p.reviewCount, "
                + "p.status, p.isFeatured, p.isBestSeller, p.isNewArrival, p.active, p.createdAt, "
                + "c.categoryName, b.brandName "
                + "FROM dbo.Products p "
                + "LEFT JOIN dbo.Categories c ON c.categoryId = p.categoryId "
                + "LEFT JOIN dbo.Brands b ON b.brandId = p.brandId "
                + "WHERE p.active = 1 "
                + (categoryId > 0 ? "AND p.categoryId = ? " : "")
                + (excludeProductId > 0 ? "AND p.productId <> ? " : "")
                + "ORDER BY p.isFeatured DESC, p.averageRating DESC, p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, limit <= 0 ? 4 : limit);
            if (categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }
            if (excludeProductId > 0) {
                ps.setInt(idx++, excludeProductId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilteredProducts(String keyword, Integer categoryId, Integer brandId,
                                     BigDecimal minPrice, BigDecimal maxPrice,
                                     Boolean inStockOnly, Boolean activeOnly) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.Products p WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (activeOnly != null && activeOnly) {
            sql.append("AND p.active = 1 ");
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (p.productName LIKE ? OR p.sku LIKE ? OR p.shortDescription LIKE ?) ");
            String term = "%" + keyword.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        if (brandId != null && brandId > 0) {
            sql.append("AND p.brandId = ? ");
            params.add(brandId);
        }
        if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) >= 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }
        if (inStockOnly != null && inStockOnly) {
            sql.append("AND p.stockQuantity > 0 ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> searchAndFilterProducts(String keyword, Integer categoryId, Integer brandId,
                                                 BigDecimal minPrice, BigDecimal maxPrice,
                                                 Boolean inStockOnly, Boolean activeOnly,
                                                 String sortBy, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE).append("WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (activeOnly != null && activeOnly) {
            sql.append("AND p.active = 1 ");
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (p.productName LIKE ? OR p.sku LIKE ? OR p.shortDescription LIKE ?) ");
            String term = "%" + keyword.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        if (brandId != null && brandId > 0) {
            sql.append("AND p.brandId = ? ");
            params.add(brandId);
        }
        if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) >= 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }
        if (inStockOnly != null && inStockOnly) {
            sql.append("AND p.stockQuantity > 0 ");
        }

        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price ASC, p.productId DESC ");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price DESC, p.productId DESC ");
        } else if ("rating".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.averageRating DESC, p.reviewCount DESC, p.productId DESC ");
        } else if ("bestseller".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.isBestSeller DESC, p.reviewCount DESC, p.productId DESC ");
        } else if ("name_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.productName ASC, p.productId DESC ");
        } else {
            sql.append("ORDER BY p.productId DESC ");
        }

        int p = Math.max(1, page);
        int size = pageSize <= 0 ? 12 : pageSize;
        int offset = (p - 1) * size;

        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(size);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO dbo.Products "
                + "(categoryId, brandId, productName, sku, slug, shortDescription, description, specifications, "
                + "price, compareAtPrice, stockQuantity, warrantyMonths, imageUrl, averageRating, reviewCount, "
                + "status, isFeatured, isBestSeller, isNewArrival, active, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCategoryId());
            ps.setInt(2, p.getBrandId());
            ps.setString(3, p.getProductName());
            ps.setString(4, p.getSku() != null ? p.getSku() : "TG-" + System.currentTimeMillis() % 10000);
            ps.setString(5, p.getSlug() != null ? p.getSlug() : "prod-" + System.currentTimeMillis());
            ps.setString(6, p.getShortDescription());
            ps.setString(7, p.getDescription());
            ps.setString(8, p.getSpecifications());
            ps.setBigDecimal(9, p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO);
            if (p.getCompareAtPrice() != null) {
                ps.setBigDecimal(10, p.getCompareAtPrice());
            } else {
                ps.setNull(10, Types.DECIMAL);
            }
            ps.setInt(11, p.getStockQuantity());
            ps.setInt(12, p.getWarrantyMonths() > 0 ? p.getWarrantyMonths() : 12);
            ps.setString(13, p.getImageUrl());
            ps.setBigDecimal(14, p.getAverageRating() != null ? p.getAverageRating() : BigDecimal.valueOf(5.0));
            ps.setInt(15, p.getReviewCount());
            ps.setString(16, p.getStatus() != null ? p.getStatus() : "ACTIVE");
            ps.setBoolean(17, p.isFeatured());
            ps.setBoolean(18, p.isBestSeller());
            ps.setBoolean(19, p.isNewArrival());
            ps.setBoolean(20, p.isActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        p.setProductId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE dbo.Products SET "
                + "categoryId = ?, brandId = ?, productName = ?, sku = ?, slug = ?, "
                + "shortDescription = ?, description = ?, specifications = ?, price = ?, "
                + "compareAtPrice = ?, stockQuantity = ?, warrantyMonths = ?, imageUrl = ?, "
                + "status = ?, isFeatured = ?, isBestSeller = ?, isNewArrival = ?, active = ? "
                + "WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setInt(2, p.getBrandId());
            ps.setString(3, p.getProductName());
            ps.setString(4, p.getSku());
            ps.setString(5, p.getSlug());
            ps.setString(6, p.getShortDescription());
            ps.setString(7, p.getDescription());
            ps.setString(8, p.getSpecifications());
            ps.setBigDecimal(9, p.getPrice());
            if (p.getCompareAtPrice() != null) {
                ps.setBigDecimal(10, p.getCompareAtPrice());
            } else {
                ps.setNull(10, Types.DECIMAL);
            }
            ps.setInt(11, p.getStockQuantity());
            ps.setInt(12, p.getWarrantyMonths());
            ps.setString(13, p.getImageUrl());
            ps.setString(14, p.getStatus());
            ps.setBoolean(15, p.isFeatured());
            ps.setBoolean(16, p.isBestSeller());
            ps.setBoolean(17, p.isNewArrival());
            ps.setBoolean(18, p.isActive());
            ps.setInt(19, p.getProductId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleActive(int id, boolean active) {
        String sql = "UPDATE dbo.Products SET active = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int id) {
        // First check if orders exist for this product
        String checkSql = "SELECT COUNT(*) FROM dbo.OrderDetails WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Safe delete: set active = 0 to preserve order history
                    return toggleActive(id, false);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "DELETE FROM dbo.Products WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // fallback to soft delete
            return toggleActive(id, false);
        }
    }

    public List<ProductImage> getProductImages(int productId) {
        return Collections.emptyList();
    }

    public boolean insertProductImage(ProductImage image) {
        return false;
    }

    public boolean deleteProductImage(int imageId) {
        return false;
    }
}
