<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<footer class="customer-footer">
    <div class="footer-grid">
        <div>
            <a class="logo light" href="<c:url value='/home'/>" aria-label="Trang chủ TechGear">
                <img class="brand-logo-img light" src="<c:url value='/assets/images/techgear-logo.png?v=5'/>" alt="TechGear">
            </a>
            <p style="margin-top: 14px; max-width: 320px; line-height: 1.8;">
                Phụ kiện công nghệ chính hãng, nâng tầm trải nghiệm số và hiệu suất làm việc mỗi ngày.
            </p>
        </div>
        <div>
            <h4>Mua sắm</h4>
            <p><a href="<c:url value='/home#products'/>">Sản phẩm nổi bật</a><br>
               <a href="<c:url value='/home#categories'/>">Danh mục thiết bị</a><br>
               <a href="<c:url value='/home#deals'/>">Chương trình ưu đãi</a></p>
        </div>
        <div>
            <h4>Hỗ trợ</h4>
            <p><a href="<c:url value='/profile'/>">Chính sách bảo hành</a><br>
               <a href="<c:url value='/profile'/>">Giao hàng & đổi trả</a><br>
               <a href="<c:url value='/profile'/>">Câu hỏi thường gặp</a></p>
        </div>
        <div>
            <h4>Liên hệ</h4>
            <p>Hotline: 1900 6868<br>
               Email: support@techgear.vn<br>
               Địa chỉ: Quận 1, TP. Hồ Chí Minh</p>
        </div>
    </div>
    <div class="copyright">
        <span>© 2026 TechGear. Thiết kế cho trải nghiệm hiện đại.</span>
        <span>PRJ301 – FPT University</span>
    </div>
</footer>
