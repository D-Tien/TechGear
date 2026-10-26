# Project structure và danh sách file

Luồng dự kiến: browser → filter → servlet → DAO → JDBC → SQL Server;
servlet forward JSP trong WEB-INF. Skeleton chỉ forward view, chưa gọi DAO.

`config`: cấu hình kết nối; `model`: JavaBeans khớp SQL; `dao`: signature TODO;
`controller`: servlet mapping theo contract; `filter`: UTF-8 và security TODO;
`util`: hàm tiện ích TODO. `webapp/assets`: CSS/JS comment và thư mục ảnh rỗng.

Không bổ sung module nghiệp vụ hoặc dependency ngoài yêu cầu. PROJECT_STRUCTURE.md
đồng thời là danh sách bàn giao đầy đủ, gồm cả file ẩn. Các thư mục được suy ra từ đường dẫn.

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
```
