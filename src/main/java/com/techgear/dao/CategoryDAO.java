package com.techgear.dao;

import com.techgear.config.DBConnection;
import com.techgear.model.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public CategoryDAO() { }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.categoryId, c.categoryName, c.description, "
                + "(SELECT COUNT(*) FROM dbo.Products p WHERE p.categoryId = c.categoryId AND p.active = 1) AS productCount "
                + "FROM dbo.Categories c ORDER BY c.categoryName";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getString("description"),
                        rs.getInt("productCount")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Category> searchCategories(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return getAllCategories();
        }
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.categoryId, c.categoryName, c.description, "
                + "(SELECT COUNT(*) FROM dbo.Products p WHERE p.categoryId = c.categoryId AND p.active = 1) AS productCount "
                + "FROM dbo.Categories c "
                + "WHERE c.categoryName LIKE ? OR c.description LIKE ? "
                + "ORDER BY c.categoryName";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword.trim() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Category(
                            rs.getInt("categoryId"),
                            rs.getString("categoryName"),
                            rs.getString("description"),
                            rs.getInt("productCount")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT c.categoryId, c.categoryName, c.description, "
                + "(SELECT COUNT(*) FROM dbo.Products p WHERE p.categoryId = c.categoryId) AS productCount "
                + "FROM dbo.Categories c WHERE c.categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("categoryId"),
                            rs.getString("categoryName"),
                            rs.getString("description"),
                            rs.getInt("productCount")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Category getCategoryByName(String name) {
        if (name == null) return null;
        String sql = "SELECT categoryId, categoryName, description FROM dbo.Categories WHERE categoryName = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(rs.getInt("categoryId"), rs.getString("categoryName"), rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertCategory(Category category) {
        String sql = "INSERT INTO dbo.Categories (categoryName, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        category.setCategoryId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE dbo.Categories SET categoryName = ?, description = ? WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countProducts(int categoryId) {
        String sql = "SELECT COUNT(*) FROM dbo.Products WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
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

    public boolean deleteCategory(int id) {
        if (countProducts(id) > 0) {
            // Cannot delete category that currently has products
            return false;
        }
        String sql = "DELETE FROM dbo.Categories WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
