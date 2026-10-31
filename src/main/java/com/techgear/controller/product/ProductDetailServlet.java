package com.techgear.controller.product;

import com.techgear.dao.ProductDAO;
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

@WebServlet(urlPatterns = {"/product", "/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();

    public ProductDetailServlet() { }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            idParam = request.getParameter("productId");
        }

        int productId = 0;
        try {
            if (idParam != null && !idParam.isBlank()) {
                productId = Integer.parseInt(idParam.trim());
            }
        } catch (NumberFormatException ignored) { }

        Product product = null;
        if (productId > 0) {
            product = productDAO.getProductById(productId);
        }

        // Fallback for mock/demo testing if database row is not present or offline
        if (product == null) {
            product = createMockProduct(productId > 0 ? productId : 1);
        }

        List<Product> related = productDAO.getRelatedProducts(product.getCategoryId(), product.getProductId(), 4);
        if (related == null || related.isEmpty()) {
            related = createMockRelated(product.getProductId());
        }

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", related);
        request.setAttribute("pageTitle", product.getProductName() + " - TechGear");
        request.setAttribute("activeNav", "products");

        request.getRequestDispatcher("/WEB-INF/views/product/product-detail.jsp").forward(request, response);
    }

    private Product createMockProduct(int id) {
        Product p = new Product();
        p.setProductId(id);
        if (id == 2) {
            p.setProductName("Bàn phím cơ không dây KeyPro K68 Pro");
            p.setCategoryName("Bàn phím cơ");
            p.setBrandName("KeyPro");
            p.setPrice(new BigDecimal("990000"));
            p.setCompareAtPrice(new BigDecimal("1250000"));
            p.setAverageRating(new BigDecimal("4.9"));
            p.setReviewCount(142);
            p.setStockQuantity(35);
            p.setSku("TG-KB-K68P");
            p.setWarrantyMonths(24);
            p.setShortDescription("Bàn phím cơ 3 chế độ kết nối (Bluetooth 5.1 / 2.4GHz / Type-C), switch Gateron Pro hot-swap, keycap PBT doubleshot bền bỉ.");
            p.setDescription("Bàn phím cơ KeyPro K68 Pro mang lại trải nghiệm gõ phím tuyệt đỉnh cho cả lập trình viên và game thủ. Thiết kế layout 68 phím nhỏ gọn, tối ưu không gian bàn làm việc nhưng vẫn giữ trọn vẹn cụm phím điều hướng.\n\n"
                    + "Đặc điểm nổi bật:\n"
                    + "- Kết nối linh hoạt: Bluetooth 5.1 hỗ trợ 3 thiết bị, Wireless 2.4GHz độ trễ siêu thấp và cáp USB Type-C có thể tháo rời.\n"
                    + "- Mạch xuôi Hot-swap 5-pin tương thích mọi loại switch Cherry, Gateron, Kailh.\n"
                    + "- Đèn LED RGB 16.8 triệu màu với 20+ hiệu ứng ánh sáng bắt mắt.\n"
                    + "- Dung lượng pin khủng 4000mAh cho thời lượng sử dụng lên đến 200 giờ khi tắt LED.");
            p.setSpecifications("Thương hiệu: KeyPro\nModel: K68 Pro\nLayout: 68 phím (65%)\nKết nối: Bluetooth 5.1, 2.4GHz, Type-C\nSwitch: Gateron Pro Yellow / Red / Brown (Hot-swap)\nKeycap: PBT Double-shot Cherry Profile\nPin: 4000mAh\nTrọng lượng: 850g");
            p.setImageUrl("https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80");
        } else if (id == 3) {
            p.setProductName("Chuột chơi game công thái học Aero M5 Wireless");
            p.setCategoryName("Chuột gaming");
            p.setBrandName("AeroTech");
            p.setPrice(new BigDecimal("459000"));
            p.setCompareAtPrice(new BigDecimal("599000"));
            p.setAverageRating(new BigDecimal("4.8"));
            p.setReviewCount(88);
            p.setStockQuantity(50);
            p.setSku("TG-MO-AERO5");
            p.setWarrantyMonths(12);
            p.setShortDescription("Chuột không dây siêu nhẹ 58g, cảm biến quang học PixArt 3395 lên đến 26.000 DPI, switch quang học 80 triệu lần bấm.");
            p.setDescription("Aero M5 Wireless là lựa chọn hàng đầu cho game thủ FPS và người làm việc cường độ cao. Trọng lượng siêu nhẹ chỉ 58g kết hợp form cầm công thái học giúp giảm mỏi cổ tay khi sử dụng cả ngày dài.");
            p.setSpecifications("Cảm biến: PixArt PAW3395\nDPI tối đa: 26.000 DPI\nIPS: 650 IPS\nTrọng lượng: 58g\nThời lượng pin: 80 giờ\nKết nối: 2.4GHz Wireless, Type-C");
            p.setImageUrl("https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=800&q=80");
        } else {
            p.setProductName("Tai nghe chống ồn không dây HyperSound X7 ANC");
            p.setCategoryName("Tai nghe");
            p.setBrandName("HyperSound");
            p.setPrice(new BigDecimal("690000"));
            p.setCompareAtPrice(new BigDecimal("890000"));
            p.setAverageRating(new BigDecimal("4.8"));
            p.setReviewCount(128);
            p.setStockQuantity(42);
            p.setSku("TG-HP-HSX7");
            p.setWarrantyMonths(12);
            p.setShortDescription("Tai nghe over-ear chống ồn chủ động Hybrid ANC -38dB, âm thanh Hi-Res Audio với driver Titanium 40mm, thời lượng pin 50 giờ.");
            p.setDescription("HyperSound X7 ANC là mẫu tai nghe đa năng đáp ứng xuất sắc nhu cầu nghe nhạc chất lượng cao, học tập và hội họp trực tuyến. Công nghệ chống ồn chủ động Hybrid ANC loại bỏ tới 95% tiếng ồn xung quanh.\n\n"
                    + "Đặc điểm nổi bật:\n"
                    + "- Âm thanh chuẩn Hi-Res Audio với màng loa Titanium 40mm tái tạo âm bass sâu và dải treble tách bạch.\n"
                    + "- Micro đàm thoại tích hợp AI ENC lọc gió và tạp âm rõ nét.\n"
                    + "- Đệm tai bọc da Protein mềm mại, không gây đau tai khi đeo kính.\n"
                    + "- Hỗ trợ sạc nhanh Type-C: 10 phút sạc cho 5 giờ nghe nhạc liên tục.");
            p.setSpecifications("Driver: 40mm Dynamic Titanium\nChống ồn: Hybrid ANC -38dB\nBluetooth: 5.3 (SBC, AAC, LDAC)\nPin: 50 giờ (tắt ANC) / 38 giờ (bật ANC)\nCổng sạc: USB Type-C\nTrọng lượng: 245g");
            p.setImageUrl("https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80");
        }
        return p;
    }

    private List<Product> createMockRelated(int currentId) {
        List<Product> list = new ArrayList<>();
        if (currentId != 1) {
            list.add(createMockProduct(1));
        }
        if (currentId != 2) {
            list.add(createMockProduct(2));
        }
        if (currentId != 3) {
            list.add(createMockProduct(3));
        }
        return list;
    }
}
