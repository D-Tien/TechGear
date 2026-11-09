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
            featured = productDAO.searchAndFilterProducts(
                    null, null, null, null, null, null, true, "newest", 1, 4);
        }
        if (featured == null || featured.isEmpty()) {
            featured = DemoProductCatalog.getProducts();
        }
        if (bestSellers == null || bestSellers.isEmpty()) {
            bestSellers = featured;
        }

        request.setAttribute("featuredProducts", featured);
        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/product/home.jsp").forward(request, response);
    }
}
