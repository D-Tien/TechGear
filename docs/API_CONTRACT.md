# Servlet API contract

## Người 1 đã triển khai

Tất cả POST bên dưới cần `csrfToken` lấy từ biểu mẫu GET cùng session.
Validation lỗi: HTTP 400 + JSP hiện thông báo. Không có quyền: 403.
Kết nối database lỗi: 503, thông tin chi tiết chỉ ghi log Tomcat.

| Route | GET | POST / tham số |
| --- | --- | --- |
| `/login` | Form | `username`, `password`; tạo session mới; ADMIN → `/admin/users`, CUSTOMER → `/profile` |
| `/register` | Form | `username`, `fullName`, `email`, `phone`, `password`, `confirmPassword`; role luôn CUSTOMER |
| `/logout` | 405 | Hủy session, về `/login?logout=1` |
| `/profile` | Hồ sơ user đang đăng nhập | `fullName`, `email`, `phone`, `address`, `currentPassword`; bỏ qua userId/roleId/active từ client |
| `/change-password` | Form, yêu cầu đăng nhập | `currentPassword`, `password`, `confirmPassword`; đổi xong hủy session hiện tại |
| `/admin/users` | Danh sách thực tế, `keyword` tùy chọn | `action=create/update`, `adminPassword`, `fullName`, `email`, `phone`, `address`, `roleId`; create thêm `username/password/confirmPassword`, update thêm `userId/active=true` |

Session `currentUser`: User không chứa passwordHash; session `roleName`: tên role tra từ DB.
Filter nạp lại user/role từ DB trên mỗi request được bảo vệ, nên khóa/đổi quyền có hiệu lực
trên request tiếp theo. Không cache quyền lấy từ form. UserDAO/RoleDAO báo lỗi JDBC bằng SQLException.
Các query lấy chi tiết user có hash chỉ dùng cho xác thực phía server; danh sách JSP loại bỏ hash.
Username không thay đổi sau khi tạo; tài khoản không bị xóa vật lý để giữ lịch sử đơn hàng.
Không cho ADMIN tự khóa/hạ quyền; DAO dùng transaction và khóa khi bảo vệ ADMIN cuối cùng.
Đổi mật khẩu đăng xuất session hiện tại; các session khác của cùng user chưa bị thu hồi tự động.
Chưa có chức năng quên/reset mật khẩu (đã bỏ route và JSP theo yêu cầu).

## Module Người 2 và Người 3

Các module ngoài Người 1 do thành viên tương ứng phụ trách. Khi đồng bộ main,
đã giữ nguyên thay đổi Cart/Checkout và trang danh sách sản phẩm của nhóm.
Tài liệu này chỉ mô tả endpoint Người 1; xem code module khác để biết trạng thái thực tế.
AuthenticationFilter bảo vệ `/profile`, `/change-password`, `/checkout`, `/my-orders`, `/admin/*`;
AdminFilter bảo vệ `/admin/*` theo mapping đã có.
CSRF filter chỉ ánh xạ form Người 1. Khi triển khai module khác, các thành viên phải tự tích hợp CSRF.
Session `cart` vẫn là contract dự kiến `List<CartItem>`, chưa triển khai.
