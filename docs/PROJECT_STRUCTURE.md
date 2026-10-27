# Project structure và danh sách file

Luồng Người 1 đã triển khai: browser → filter → servlet → DAO → JDBC → SQL Server;
Servlet forward JSP trong WEB-INF hoặc redirect sau khi POST thành công.

`config`: cấu hình kết nối môi trường; `model`: JavaBeans; `dao`: JDBC User/Role;
`controller`: xử lý Login/Register/Logout/Change Password/Profile/Admin Users;
`filter`: UTF-8, session, quyền ADMIN và CSRF cho Người 1;
`util`: BCrypt, validation, form/session helper. CSS/JS/font Người 1 độc lập.
Module Người 2/3 được giữ theo main của nhóm, gồm các thay đổi Cart/Checkout mới.
Chi tiết chạy và kiểm thử: `docs/PERSON1_TESTING.md`.

```text
.env.example
.gitignore
README.md
database/README.md
database/schema.sql
docs/API_CONTRACT.md
docs/DATABASE_CONTRACT.md
docs/PROJECT_STRUCTURE.md
docs/TEAM_GUIDELINES.md
pom.xml
src/main/java/com/techgear/config/DBConnection.java
src/main/java/com/techgear/controller/admin/BrandManagementServlet.java
src/main/java/com/techgear/controller/admin/CategoryManagementServlet.java
src/main/java/com/techgear/controller/admin/DashboardServlet.java
src/main/java/com/techgear/controller/admin/OrderManagementServlet.java
src/main/java/com/techgear/controller/admin/ProductManagementServlet.java
src/main/java/com/techgear/controller/admin/UserManagementServlet.java
src/main/java/com/techgear/controller/auth/ChangePasswordServlet.java
src/main/java/com/techgear/controller/auth/LoginServlet.java
src/main/java/com/techgear/controller/auth/LogoutServlet.java
src/main/java/com/techgear/controller/auth/RegisterServlet.java
src/main/java/com/techgear/controller/cart/CartServlet.java
src/main/java/com/techgear/controller/cart/CheckoutServlet.java
src/main/java/com/techgear/controller/product/HomeServlet.java
src/main/java/com/techgear/controller/product/ProductDetailServlet.java
src/main/java/com/techgear/controller/product/ProductListServlet.java
src/main/java/com/techgear/controller/product/SearchServlet.java
src/main/java/com/techgear/controller/user/MyOrdersServlet.java
src/main/java/com/techgear/controller/user/ProfileServlet.java
src/main/java/com/techgear/dao/BrandDAO.java
src/main/java/com/techgear/dao/CategoryDAO.java
src/main/java/com/techgear/dao/OrderDAO.java
src/main/java/com/techgear/dao/OrderDetailDAO.java
src/main/java/com/techgear/dao/ProductDAO.java
src/main/java/com/techgear/dao/ReviewDAO.java
src/main/java/com/techgear/dao/RoleDAO.java
src/main/java/com/techgear/dao/StatisticsDAO.java
src/main/java/com/techgear/dao/UserDAO.java
src/main/java/com/techgear/filter/AdminFilter.java
src/main/java/com/techgear/filter/AuthenticationFilter.java
src/main/java/com/techgear/filter/EncodingFilter.java
src/main/java/com/techgear/model/Brand.java
src/main/java/com/techgear/model/CartItem.java
src/main/java/com/techgear/model/Category.java
src/main/java/com/techgear/model/Order.java
src/main/java/com/techgear/model/OrderDetail.java
src/main/java/com/techgear/model/PasswordResetToken.java
src/main/java/com/techgear/model/Product.java
src/main/java/com/techgear/model/ProductImage.java
src/main/java/com/techgear/model/Review.java
src/main/java/com/techgear/model/Role.java
src/main/java/com/techgear/model/User.java
src/main/java/com/techgear/util/EmailUtil.java
src/main/java/com/techgear/util/PasswordUtil.java
src/main/java/com/techgear/util/ValidationUtil.java
src/main/webapp/WEB-INF/views/admin/brands.jsp
src/main/webapp/WEB-INF/views/admin/categories.jsp
src/main/webapp/WEB-INF/views/admin/dashboard.jsp
src/main/webapp/WEB-INF/views/admin/orders.jsp
src/main/webapp/WEB-INF/views/admin/product-form.jsp
src/main/webapp/WEB-INF/views/admin/products.jsp
src/main/webapp/WEB-INF/views/admin/users.jsp
src/main/webapp/WEB-INF/views/auth/change-password.jsp
src/main/webapp/WEB-INF/views/auth/login.jsp
src/main/webapp/WEB-INF/views/auth/register.jsp
src/main/webapp/WEB-INF/views/cart/cart.jsp
src/main/webapp/WEB-INF/views/cart/checkout.jsp
src/main/webapp/WEB-INF/views/common/footer.jsp
src/main/webapp/WEB-INF/views/common/header.jsp
src/main/webapp/WEB-INF/views/common/navbar.jsp
src/main/webapp/WEB-INF/views/error/404.jsp
src/main/webapp/WEB-INF/views/error/500.jsp
src/main/webapp/WEB-INF/views/product/home.jsp
src/main/webapp/WEB-INF/views/product/product-detail.jsp
src/main/webapp/WEB-INF/views/product/product-list.jsp
src/main/webapp/WEB-INF/views/user/my-orders.jsp
src/main/webapp/WEB-INF/views/user/profile.jsp
src/main/webapp/WEB-INF/web.xml
src/main/webapp/assets/css/admin.css
src/main/webapp/assets/css/auth.css
src/main/webapp/assets/css/cart.css
src/main/webapp/assets/css/product.css
src/main/webapp/assets/css/style.css
src/main/webapp/assets/images/.gitkeep
src/main/webapp/assets/js/admin.js
src/main/webapp/assets/js/cart.js
src/main/webapp/assets/js/main.js
src/main/webapp/assets/js/product.js
src/main/webapp/index.jsp
database/TechGear_Full_Setup.sql
docs/PERSON1_TESTING.md
src/main/java/com/techgear/filter/CsrfFilter.java
src/main/java/com/techgear/util/AuthUtil.java
src/main/webapp/WEB-INF/views/auth/_figma-start.jspf
src/main/webapp/WEB-INF/views/auth/_figma-end.jspf
src/main/webapp/WEB-INF/views/auth/_figma-messages.jspf
src/main/webapp/WEB-INF/views/auth/_figma-visual.jspf
src/main/webapp/assets/js/auth.js
src/main/webapp/assets/fonts/inter/Inter-variable.ttf
src/main/webapp/assets/fonts/inter/OFL.txt
```
