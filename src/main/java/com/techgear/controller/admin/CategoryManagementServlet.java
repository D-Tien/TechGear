package com.techgear.controller.admin;

import com.techgear.dao.CategoryDAO;
import com.techgear.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class CategoryManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CategoryDAO categoryDAO = new CategoryDAO();

    public CategoryManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Category> categories;
        if (keyword != null && !keyword.isBlank()) {
            categories = categoryDAO.searchCategories(keyword.trim());
        } else {
            categories = categoryDAO.getAllCategories();
        }

        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action)) {
                String name = request.getParameter("categoryName");
                String desc = request.getParameter("description");

                if (name == null || name.isBlank()) {
                    throw new IllegalArgumentException("Tên danh mục không được để trống.");
                }
                name = name.trim();
                if (name.length() > 100) {
                    throw new IllegalArgumentException("Tên danh mục không được vượt quá 100 ký tự.");
                }
                if (categoryDAO.getCategoryByName(name) != null) {
                    throw new IllegalArgumentException("Tên danh mục đã tồn tại trong hệ thống.");
                }

                Category c = new Category();
                c.setCategoryName(name);
                c.setDescription(desc != null ? desc.trim() : "");
                if (!categoryDAO.insertCategory(c)) {
                    throw new IllegalArgumentException("Không thể thêm danh mục. Vui lòng thử lại.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories?saved=1");
                return;

            } else if ("update".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                String name = request.getParameter("categoryName");
                String desc = request.getParameter("description");

                if (name == null || name.isBlank()) {
                    throw new IllegalArgumentException("Tên danh mục không được để trống.");
                }
                name = name.trim();
                Category existing = categoryDAO.getCategoryByName(name);
                if (existing != null && existing.getCategoryId() != id) {
                    throw new IllegalArgumentException("Tên danh mục đã tồn tại.");
                }

                Category c = new Category(id, name, desc != null ? desc.trim() : "");
                if (!categoryDAO.updateCategory(c)) {
                    throw new IllegalArgumentException("Không thể cập nhật danh mục.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories?saved=1");
                return;

            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                if (categoryDAO.countProducts(id) > 0) {
                    throw new IllegalArgumentException("Không thể xóa danh mục vì đang có sản phẩm thuộc danh mục này.");
                }
                if (!categoryDAO.deleteCategory(id)) {
                    throw new IllegalArgumentException("Xóa danh mục thất bại.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories?deleted=1");
                return;

            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            doGet(request, response);
        }
    }
}
