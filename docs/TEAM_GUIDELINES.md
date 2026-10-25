# Team guidelines

## Quy tắc bắt buộc

1. Mỗi người chỉ sửa file thuộc module của mình.
2. Không tự đổi package, class, field, method hoặc URL đã thống nhất.
3. Không tự sửa pom.xml, web.xml, schema.sql hoặc model chung.
4. Thông báo và thống nhất với cả nhóm trước khi sửa shared files.
5. Không xóa file do thành viên khác tạo.
6. Mỗi người làm việc trên branch riêng.
7. Không push trực tiếp vào main.
8. Chạy `mvn clean package` thành công trước khi merge.
9. Dùng Pull Request để review thay đổi.
10. Không commit password, credential hoặc file cấu hình chứa bí mật.

## Branch và phân công

`main` là nhánh tích hợp. Các tên branch dưới đây là quy ước; skeleton không tự tạo Git repository/branch.

| Thành viên | Branch | Java phụ trách | UI phụ trách |
| --- | --- | --- | --- |
| Person 1 | feature/auth-user | controller/auth/*; controller/user/ProfileServlet; controller/admin/UserManagementServlet; dao/UserDAO, RoleDAO; filter/*; util/* | views/auth/*; views/user/profile.jsp; views/admin/users.jsp; assets/css/auth.css |
| Person 2 | feature/product-home | controller/product/*; controller/admin/ProductManagementServlet, CategoryManagementServlet, BrandManagementServlet; dao/ProductDAO, CategoryDAO, BrandDAO, ReviewDAO | views/product/*; views/admin/products.jsp, product-form.jsp, categories.jsp, brands.jsp; views/common/*; assets/css/style.css, product.css; assets/js/product.js |
| Person 3 | feature/cart-order-stats | controller/cart/*; controller/user/MyOrdersServlet; controller/admin/OrderManagementServlet, DashboardServlet; dao/OrderDAO, OrderDetailDAO, StatisticsDAO | views/cart/*; views/user/my-orders.jsp; views/admin/orders.jsp, dashboard.jsp; assets/css/cart.css, admin.css; assets/js/cart.js, admin.js |

Person 1 điều phối cấu hình chung và thay đổi database theo thống nhất của cả nhóm.
Person 2 quản lý ảnh sản phẩm trong assets/images theo contract đã duyệt.

## Shared files

`model/*`, `config/*`, `pom.xml`, `WEB-INF/web.xml`, `database/schema.sql`, `index.jsp`,
`assets/js/main.js`, `views/error/*`, cấu hình gốc và tài liệu contract là tài nguyên dùng chung.
Không cá nhân nào có quyền tự ý sửa; Person 1 điều phối, cả nhóm review.

Trước PR: cập nhật contract nếu đổi signature/schema/URL, build bằng Java 17,
kiểm tra không trùng mapping và không có secrets. Với skeleton, không thêm nghiệp vụ hoặc seed.
