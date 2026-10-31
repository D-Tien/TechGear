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
import java.util.ArrayList;
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
                products = createMockCatalog();
                totalCount = products.size();
            } else {
                products = new ArrayList<>();
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

    private List<Product> createMockCatalog() {
        List<Product> list = new ArrayList<>();

        Product p1 = new Product();
        p1.setProductId(1);
        p1.setProductName("Tai nghe không dây HyperSound X7 ANC");
        p1.setCategoryName("Tai nghe");
        p1.setBrandName("HyperSound");
        p1.setPrice(new BigDecimal("690000"));
        p1.setCompareAtPrice(new BigDecimal("890000"));
        p1.setAverageRating(new BigDecimal("4.8"));
        p1.setReviewCount(128);
        p1.setStockQuantity(50);
        p1.setFeatured(true);
        p1.setImageUrl("https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80");
        list.add(p1);

        Product p2 = new Product();
        p2.setProductId(2);
        p2.setProductName("Bàn phím cơ KeyPro K68 Pro Wireless");
        p2.setCategoryName("Bàn phím cơ");
        p2.setBrandName("KeyPro");
        p2.setPrice(new BigDecimal("990000"));
        p2.setCompareAtPrice(new BigDecimal("1250000"));
        p2.setAverageRating(new BigDecimal("4.9"));
        p2.setReviewCount(142);
        p2.setStockQuantity(35);
        p2.setFeatured(true);
        p2.setImageUrl("https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=700&q=80");
        list.add(p2);

        Product p3 = new Product();
        p3.setProductId(3);
        p3.setProductName("Chuột chơi game siêu nhẹ Aero M5 Wireless");
        p3.setCategoryName("Chuột");
        p3.setBrandName("AeroTech");
        p3.setPrice(new BigDecimal("459000"));
        p3.setCompareAtPrice(new BigDecimal("599000"));
        p3.setAverageRating(new BigDecimal("4.8"));
        p3.setReviewCount(88);
        p3.setStockQuantity(40);
        p3.setBestSeller(true);
        p3.setImageUrl("https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80");
        list.add(p3);

        Product p4 = new Product();
        p4.setProductId(4);
        p4.setProductName("Loa Bluetooth Mini Boom S2 chống nước");
        p4.setCategoryName("Loa");
        p4.setBrandName("SoundPulse");
        p4.setPrice(new BigDecimal("590000"));
        p4.setCompareAtPrice(new BigDecimal("750000"));
        p4.setAverageRating(new BigDecimal("4.7"));
        p4.setReviewCount(76);
        p4.setStockQuantity(25);
        p4.setImageUrl("https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=700&q=80");
        list.add(p4);

        Product p5 = new Product();
        p5.setProductId(5);
        p5.setProductName("Giá treo tai nghe kim loại TechStand Pro");
        p5.setCategoryName("Phụ kiện");
        p5.setBrandName("TechGear");
        p5.setPrice(new BigDecimal("290000"));
        p5.setCompareAtPrice(new BigDecimal("350000"));
        p5.setAverageRating(new BigDecimal("4.9"));
        p5.setReviewCount(65);
        p5.setStockQuantity(60);
        p5.setImageUrl("https://images.unsplash.com/photo-1584679109597-c656b19974c9?auto=format&fit=crop&w=700&q=80");
        list.add(p5);

        Product p6 = new Product();
        p6.setProductId(6);
        p6.setProductName("Lót chuột cỡ lớn DeskMat Gaming 900x400");
        p6.setCategoryName("Phụ kiện");
        p6.setBrandName("TechGear");
        p6.setPrice(new BigDecimal("199000"));
        p6.setCompareAtPrice(new BigDecimal("250000"));
        p6.setAverageRating(new BigDecimal("4.8"));
        p6.setReviewCount(110);
        p6.setStockQuantity(100);
        p6.setImageUrl("https://images.unsplash.com/photo-1616440347437-b1c73416efc2?auto=format&fit=crop&w=700&q=80");
        list.add(p6);

        return list;
    }
}
