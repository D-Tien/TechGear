package com.techgear.controller.product;

import com.techgear.dao.ProductDAO;
import com.techgear.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/product", "/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            idParam = request.getParameter("productId");
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException error) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            return;
        }

        Product product;
        if (productId <= -101) {
            product = DemoProductCatalog.find(productId);
        } else if (productId > 0) {
            product = productDAO.getProductById(productId);
            if (product != null && !product.isActive()) {
                product = null;
            }
        } else {
            product = null;
        }

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            return;
        }

        List<Product> related;
        if (productId <= -101) {
            related = DemoProductCatalog.getRelatedProducts(productId, 4);
        } else {
            related = productDAO.getRelatedProducts(product.getCategoryId(), productId, 4);
        }

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", related);
        request.setAttribute("pageTitle", product.getProductName() + " - TechGear");
        request.setAttribute("activeNav", "products");
        request.getRequestDispatcher("/WEB-INF/views/product/product-detail.jsp").forward(request, response);
    }
}
