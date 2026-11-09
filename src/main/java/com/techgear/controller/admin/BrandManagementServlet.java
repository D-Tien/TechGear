package com.techgear.controller.admin;

import com.techgear.dao.BrandDAO;
import com.techgear.dao.CatalogMetricsDAO;
import com.techgear.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/brands")
public class BrandManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BrandDAO brandDAO = new BrandDAO();

    public BrandManagementServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        try {
            request.setAttribute("catalogMetrics", new CatalogMetricsDAO().getBrandMetrics());
        } catch (java.sql.SQLException error) {
            throw new ServletException("Không đọc được số liệu thương hiệu.", error);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/brands.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String name = clean(request.getParameter("brandName"));
        String description = clean(request.getParameter("description"));

        try {
            if ("create".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
                if (name.isEmpty() || name.length() > 100) {
                    throw new IllegalArgumentException("Tên thương hiệu phải có từ 1 đến 100 ký tự.");
                }
                if (description.length() > 1000) {
                    throw new IllegalArgumentException("Mô tả không được vượt quá 1000 ký tự.");
                }

                List<Brand> brands = brandDAO.getAllBrands();
                for (Brand brand : brands) {
                    boolean sameName = brand.getBrandName().equalsIgnoreCase(name);
                    boolean sameRecord = "update".equalsIgnoreCase(action)
                            && brand.getBrandId() == parseId(request.getParameter("brandId"));
                    if (sameName && !sameRecord) {
                        throw new IllegalArgumentException("Tên thương hiệu đã tồn tại.");
                    }
                }

                boolean saved;
                if ("create".equalsIgnoreCase(action)) {
                    saved = brandDAO.insertBrand(new Brand(0, name, description));
                } else {
                    int id = parseId(request.getParameter("brandId"));
                    saved = brandDAO.updateBrand(new Brand(id, name, description));
                }
                if (!saved) {
                    throw new IllegalArgumentException("Không lưu được thương hiệu. Kiểm tra database rồi thử lại.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/brands?saved=1");
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                int id = parseId(request.getParameter("brandId"));
                if (!brandDAO.deleteBrand(id)) {
                    throw new IllegalArgumentException(
                            "Không xóa được thương hiệu. Có thể thương hiệu đang được sản phẩm sử dụng.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/brands?deleted=1");
                return;
            }

            throw new IllegalArgumentException("Thao tác không hợp lệ.");
        } catch (IllegalArgumentException error) {
            request.setAttribute("error", error.getMessage());
            doGet(request, response);
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) { }
        throw new IllegalArgumentException("Mã thương hiệu không hợp lệ.");
    }
}
