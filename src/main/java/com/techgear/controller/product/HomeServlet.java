package com.techgear.controller.product;

import com.techgear.dao.CategoryDAO;
import com.techgear.dao.ProductDAO;
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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    public HomeServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> featured = productDAO.getFeaturedProducts(4);
        List<Product> bestSellers = productDAO.getBestSellers(4);
        List<Category> categories = categoryDAO.getAllCategories();

        if (featured == null || featured.isEmpty()) {
            featured = createMockFeatured();
        }
        if (bestSellers == null || bestSellers.isEmpty()) {
            bestSellers = featured;
        }

        request.setAttribute("featuredProducts", featured);
        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/product/home.jsp").forward(request, response);
    }

    private List<Product> createMockFeatured() {
        List<Product> list = new ArrayList<>();
        Product p1 = new Product();
        p1.setProductId(1);
        p1.setProductName("Tai nghe HyperSound X7");
        p1.setCategoryName("Tai nghe");
        p1.setPrice(new BigDecimal("690000"));
        p1.setCompareAtPrice(new BigDecimal("890000"));
        p1.setAverageRating(new BigDecimal("4.8"));
        p1.setReviewCount(128);
        p1.setImageUrl("https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80");
        list.add(p1);

        Product p2 = new Product();
        p2.setProductId(2);
        p2.setProductName("Bàn phím KeyPro K68");
        p2.setCategoryName("Bàn phím");
        p2.setPrice(new BigDecimal("990000"));
        p2.setCompareAtPrice(new BigDecimal("1250000"));
        p2.setAverageRating(new BigDecimal("4.9"));
        p2.setReviewCount(128);
        p2.setFeatured(true);
        p2.setImageUrl("https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=700&q=80");
        list.add(p2);

        Product p3 = new Product();
        p3.setProductId(3);
        p3.setProductName("Chuột Aero M5");
        p3.setCategoryName("Chuột");
        p3.setPrice(new BigDecimal("459000"));
        p3.setAverageRating(new BigDecimal("4.8"));
        p3.setReviewCount(128);
        p3.setImageUrl("https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=700&q=80");
        list.add(p3);

        Product p4 = new Product();
        p4.setProductId(4);
        p4.setProductName("Loa Mini Boom S2");
        p4.setCategoryName("Loa");
        p4.setPrice(new BigDecimal("590000"));
        p4.setAverageRating(new BigDecimal("4.7"));
        p4.setReviewCount(128);
        p4.setImageUrl("https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=700&q=80");
        list.add(p4);

        return list;
    }
}
