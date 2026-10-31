package com.techgear.controller.admin;

import com.techgear.dao.BrandDAO;
import com.techgear.dao.CategoryDAO;
import com.techgear.dao.ProductDAO;
import com.techgear.model.Brand;
import com.techgear.model.Category;
import com.techgear.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet("/admin/products")
public class ProductManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();

    public ProductManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("new".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);

            if ("edit".equalsIgnoreCase(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Product product = productDAO.getProductById(id);
                    if (product == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/products?error=not_found");
                        return;
                    }
                    request.setAttribute("product", product);
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    return;
                }
            }
            request.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(request, response);
            return;
        }

        // List view
        String keyword = request.getParameter("keyword");
        Integer categoryId = null;
        Integer brandId = null;
        try {
            if (request.getParameter("categoryId") != null && !request.getParameter("categoryId").isBlank()) {
                categoryId = Integer.parseInt(request.getParameter("categoryId"));
            }
        } catch (NumberFormatException ignored) { }

        try {
            if (request.getParameter("brandId") != null && !request.getParameter("brandId").isBlank()) {
                brandId = Integer.parseInt(request.getParameter("brandId"));
            }
        } catch (NumberFormatException ignored) { }

        List<Product> products = productDAO.searchProducts(keyword, categoryId, brandId, false, null);
        request.setAttribute("products", products);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("brands", brandDAO.getAllBrands());
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
                String name = request.getParameter("productName");
                if (name == null || name.isBlank()) {
                    throw new IllegalArgumentException("Tên sản phẩm không được để trống.");
                }

                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                BigDecimal price = new BigDecimal(request.getParameter("price").replaceAll("[^0-9.]", ""));
                
                BigDecimal compareAtPrice = null;
                String compareStr = request.getParameter("compareAtPrice");
                if (compareStr != null && !compareStr.isBlank()) {
                    String clean = compareStr.replaceAll("[^0-9.]", "");
                    if (!clean.isBlank()) {
                        compareAtPrice = new BigDecimal(clean);
                    }
                }

                int stock = Integer.parseInt(request.getParameter("stockQuantity").replaceAll("[^0-9]", ""));
                String sku = request.getParameter("sku");
                if (sku == null || sku.isBlank()) {
                    sku = "TG-" + (System.currentTimeMillis() % 100000);
                }
                String shortDesc = request.getParameter("shortDescription");
                String desc = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");
                boolean isFeatured = "true".equalsIgnoreCase(request.getParameter("isFeatured")) || "on".equalsIgnoreCase(request.getParameter("isFeatured"));
                boolean isBestSeller = "true".equalsIgnoreCase(request.getParameter("isBestSeller")) || "on".equalsIgnoreCase(request.getParameter("isBestSeller"));
                boolean isNewArrival = "true".equalsIgnoreCase(request.getParameter("isNewArrival")) || "on".equalsIgnoreCase(request.getParameter("isNewArrival"));
                boolean active = "true".equalsIgnoreCase(request.getParameter("active")) || "on".equalsIgnoreCase(request.getParameter("active"));

                Product p;
                if ("create".equalsIgnoreCase(action)) {
                    p = new Product();
                    p.setSlug(toSlug(name) + "-" + (System.currentTimeMillis() % 1000));
                } else {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    p = productDAO.getProductById(id);
                    if (p == null) {
                        throw new IllegalArgumentException("Không tìm thấy sản phẩm cần cập nhật.");
                    }
                }

                p.setProductName(name.trim());
                p.setCategoryId(categoryId);
                p.setBrandId(brandId);
                p.setPrice(price);
                p.setCompareAtPrice(compareAtPrice);
                p.setStockQuantity(stock);
                p.setSku(sku.trim());
                p.setShortDescription(shortDesc != null ? shortDesc.trim() : "");
                p.setDescription(desc != null ? desc.trim() : "");
                p.setImageUrl(imageUrl != null && !imageUrl.isBlank() ? imageUrl.trim() : "https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80");
                p.setFeatured(isFeatured);
                p.setBestSeller(isBestSeller);
                p.setNewArrival(isNewArrival);
                p.setActive(active);

                if ("create".equalsIgnoreCase(action)) {
                    if (!productDAO.insertProduct(p)) {
                        throw new IllegalArgumentException("Không thể tạo sản phẩm.");
                    }
                } else {
                    if (!productDAO.updateProduct(p)) {
                        throw new IllegalArgumentException("Không thể cập nhật sản phẩm.");
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/products?saved=1");
                return;

            } else if ("toggle".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("productId"));
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                productDAO.toggleActive(id, active);
                response.sendRedirect(request.getContextPath() + "/admin/products?saved=1");
                return;

            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("productId"));
                productDAO.deleteProduct(id);
                response.sendRedirect(request.getContextPath() + "/admin/products?deleted=1");
                return;
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(request, response);
        }
    }

    private static final Pattern NONLATIN = Pattern.compile("[^\\w-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s]");

    private String toSlug(String input) {
        if (input == null) return "";
        String nowhitespace = WHITESPACE.matcher(input.trim()).replaceAll("-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD);
        String slug = NONLATIN.matcher(normalized).replaceAll("");
        return slug.toLowerCase(Locale.ENGLISH);
    }
}
