# Servlet API contract

Đây là contract cho skeleton; chưa có endpoint nghiệp vụ hoạt động.
GET chỉ forward JSP placeholder. POST trả HTTP 501 và không sửa dữ liệu.
Logout GET/POST cũng trả 501; chưa hủy session.

| Route | Servlet | GET placeholder | POST | Owner |
| --- | --- | --- | --- | --- |
| `/login` | `auth.LoginServlet` | `auth/login.jsp` | 501 | Person 1 |
| `/register` | `auth.RegisterServlet` | `auth/register.jsp` | 501 | Person 1 |
| `/logout` | `auth.LogoutServlet` | 501 | 501 | Person 1 |
| `/forgot-password` | `auth.ForgotPasswordServlet` | `auth/forgot-password.jsp` | 501 | Person 1 |
| `/reset-password` | `auth.ResetPasswordServlet` | `auth/reset-password.jsp` | 501 | Person 1 |
| `/change-password` | `auth.ChangePasswordServlet` | `auth/change-password.jsp` | 501 | Person 1 |
| `/profile` | `user.ProfileServlet` | `user/profile.jsp` | 501 | Person 1 |
| `/my-orders` | `user.MyOrdersServlet` | `user/my-orders.jsp` | 501 | Person 3 |
| `/home` | `product.HomeServlet` | `product/home.jsp` | 501 | Person 2 |
| `/products` | `product.ProductListServlet` | `product/product-list.jsp` | 501 | Person 2 |
| `/product-detail` | `product.ProductDetailServlet` | `product/product-detail.jsp` | 501 | Person 2 |
| `/search` | `product.SearchServlet` | `product/product-list.jsp` | 501 | Person 2 |
| `/cart` | `cart.CartServlet` | `cart/cart.jsp` | 501 | Person 3 |
| `/checkout` | `cart.CheckoutServlet` | `cart/checkout.jsp` | 501 | Person 3 |
| `/admin/dashboard` | `admin.DashboardServlet` | `admin/dashboard.jsp` | 501 | Person 3 |
| `/admin/products` | `admin.ProductManagementServlet` | `admin/products.jsp` | 501 | Person 2 |
| `/admin/categories` | `admin.CategoryManagementServlet` | `admin/categories.jsp` | 501 | Person 2 |
| `/admin/brands` | `admin.BrandManagementServlet` | `admin/brands.jsp` | 501 | Person 2 |
| `/admin/users` | `admin.UserManagementServlet` | `admin/users.jsp` | 501 | Person 1 |
| `/admin/orders` | `admin.OrderManagementServlet` | `admin/orders.jsp` | 501 | Person 3 |

## Quy ước dùng chung

- Session `currentUser`: `com.techgear.model.User`; không chứa passwordHash trong đối tượng đưa vào session ở bản triển khai sau.
- Session `cart`: `java.util.List<com.techgear.model.CartItem>`; chưa triển khai lưu, tải hoặc đồng bộ với DB.
- Roles: `ADMIN`, `CUSTOMER`, tra qua `User.roleId` → `Roles.roleName`.
- Trạng thái đơn: `PENDING`, `CONFIRMED`, `SHIPPING`, `DELIVERED`, `CANCELLED`; chưa có logic chuyển trạng thái.
- Request/response dùng UTF-8, URL luôn ghép context path; JSP nằm trong WEB-INF.
- Query parameter cho giai đoạn sau: `id` (product-detail), `keyword` (search). Chưa đọc/xử lý ở skeleton.
- Tham số POST, phân trang, lỗi validation và response JSON cho Chart.js cần thống nhất trước khi triển khai.
- `admin/product-form.jsp` được tạo sẵn; luồng add/edit trên `/admin/products` vẫn TODO.
- Các filter xác thực và quyền admin hiện chỉ pass-through; chưa bảo vệ route.
- DAO trả empty/null/false/0 chỉ để biên dịch; không dùng để kết luận nghiệp vụ. `insertOrder` dự kiến trả identity > 0 sau khi triển khai.
- Statistics: khoảng thời gian UTC `[fromInclusive, toExclusive)`; doanh thu theo đơn DELIVERED là quy ước dự kiến, chưa truy vấn.
- Checkout cần dùng một transaction JDBC chung cho Orders, OrderDetails và tồn kho; thiết kế API transaction phải được cả nhóm thống nhất trước khi code.
