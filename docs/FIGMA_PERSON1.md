# Giao diện Người 1

Nguồn thiết kế: Figma Make, phần tài khoản trong App.tsx và index.css.
Đã chuyển sang JSP/HTML/CSS/JavaScript thuần, không đưa React/TypeScript/Vite/Tailwind vào Java Web.

- Login, Register và Change Password: nền xanh phủ màn hình, thẻ form trắng bo góc;
  Register hai cột trên desktop, một cột trên điện thoại.
- Profile và Admin Users dùng dữ liệu thực từ Servlet/UserDAO.
- CSS riêng: `src/main/webapp/assets/css/auth.css`; JavaScript: `assets/js/auth.js`;
  font Inter và giấy phép tại `assets/fonts/inter`.
- Partial auth riêng: `_figma-start.jspf`, `_figma-end.jspf`, `_figma-visual.jspf`, `_figma-messages.jspf`.
- Giữ nguyên header/navbar/footer và style.css dùng chung.
- Form POST giữ tên tham số backend, token CSRF, thông báo validation và c:out để escape dữ liệu.
- Không có quên/reset mật khẩu hoặc ghi nhớ đăng nhập.

Backend Người 1 hiện đã triển khai Servlet/JDBC/SQL Server, BCrypt, session và phân quyền.
Đăng nhập CUSTOMER về `/profile`, ADMIN về `/admin/users`.
Database dùng `TechGear_Full_Setup.sql` (có username), không dùng schema khung cũ.
Hướng dẫn chạy và kiểm thử: [PERSON1_TESTING.md](PERSON1_TESTING.md).

Giao diện mới đã kiểm tra trên desktop/mobile; Maven build thành công.
Bản local được cấu hình riêng tại `http://localhost:18080/techgear/login`;
địa chỉ này chỉ truy cập được khi Tomcat trên máy đang chạy.
