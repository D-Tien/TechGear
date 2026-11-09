package com.techgear.controller.product;

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
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/catalog"})
public class ProductListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();

    public ProductListServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = clean(request.getParameter("keyword"));
        Integer categoryId = parseInteger(request.getParameter("categoryId"));
        Integer brandId = parseInteger(request.getParameter("brandId"));
        String priceRange = clean(request.getParameter("priceRange"));
        BigDecimal minPrice = parseBigDecimal(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseBigDecimal(request.getParameter("maxPrice"));
        String inStockParam = request.getParameter("inStock");
        Boolean inStockOnly = "1".equals(inStockParam) || "true".equalsIgnoreCase(inStockParam);
        String sortBy = clean(request.getParameter("sortBy"));
        if (sortBy.isEmpty()) {
            sortBy = "newest";
        }

        // Apply price range presets if specified
        if ("under-500k".equals(priceRange)) {
            minPrice = null;
            maxPrice = new BigDecimal("500000");
        } else if ("500k-1m".equals(priceRange)) {
            minPrice = new BigDecimal("500000");
            maxPrice = new BigDecimal("1000000");
        } else if ("1m-2m".equals(priceRange)) {
            minPrice = new BigDecimal("1000000");
            maxPrice = new BigDecimal("2000000");
        } else if ("over-2m".equals(priceRange)) {
            minPrice = new BigDecimal("2000000");
            maxPrice = null;
        }

        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            }
        } catch (NumberFormatException ignored) { }

        int pageSize = 12;

        List<Category> categories = categoryDAO.getAllCategories();
        List<Brand> brands = brandDAO.getAllBrands();

        int totalCount = productDAO.countFilteredProducts(
                keyword, categoryId, brandId, minPrice, maxPrice, inStockOnly, true
        );

        List<Product> products = productDAO.searchAndFilterProducts(
                keyword, categoryId, brandId, minPrice, maxPrice, inStockOnly, true,
                sortBy, page, pageSize
        );

        // Fallback for empty database / demo setup so UI never appears broken
        if (products == null || products.isEmpty()) {
            if (totalCount == 0 && (keyword == null || keyword.isEmpty()) && categoryId == null && brandId == null) {
                products = DemoProductCatalog.getProducts();
                totalCount = products.size();
            } else {
                products = java.util.Collections.emptyList();
            }
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        // Preserve active filter states for UI
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedBrand", brandId);
        request.setAttribute("priceRange", priceRange);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("inStockOnly", inStockOnly);
        request.setAttribute("sortBy", sortBy);

        request.setAttribute("pageTitle", "Cửa hàng sản phẩm - TechGear");
        request.setAttribute("activeNav", "products");

        request.getRequestDispatcher("/WEB-INF/views/product/product-list.jsp").forward(request, response);
    }

    private String clean(String val) {
        return val == null ? "" : val.trim();
    }

    private Integer parseInteger(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            int num = Integer.parseInt(val.trim());
            return num > 0 ? num : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            BigDecimal bd = new BigDecimal(val.trim());
            return bd.compareTo(BigDecimal.ZERO) >= 0 ? bd : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

}
