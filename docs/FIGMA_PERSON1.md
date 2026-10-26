# Giao diện Người 1 — chỉ giữ phần JSP/CSS/JavaScript

Backend, model, schema.sql, pom.xml, web.xml, .env.example và README gốc đã khôi phục
đúng origin/main (commit 2b44114). Không còn phần triển khai Authentication/User Management
được bổ sung trước đó. Không commit, push hoặc merge.

## Giao diện được giữ

- Login: src/main/webapp/WEB-INF/views/auth/login.jsp
- Register: src/main/webapp/WEB-INF/views/auth/register.jsp
- Change Password: src/main/webapp/WEB-INF/views/auth/change-password.jsp
- Profile: src/main/webapp/WEB-INF/views/user/profile.jsp
- Admin Users: src/main/webapp/WEB-INF/views/admin/users.jsp
- CSS: src/main/webapp/assets/css/auth.css
- JavaScript thuần: src/main/webapp/assets/js/auth.js
- Partial riêng: auth/_figma-start.jspf, _figma-end.jspf, _figma-visual.jspf, _figma-messages.jspf
- Font Inter cục bộ và giấy phép: src/main/webapp/assets/fonts/inter/

Các trang giữ bố cục, màu, typography và responsive đã chuyển từ Figma Make.
Không có React, TypeScript, Vite hoặc Tailwind trong Java Web.
Không thay header/navbar/footer chung, style.css hoặc giao diện Người 2–3.
Bộ lọc/pagination/dialog/toggle password chỉ là hành vi giao diện bằng JavaScript.

## Trạng thái sau khi khôi phục

Servlet gốc chỉ forward JSP khi GET; POST vẫn trả 501 theo main.
Đăng ký, đăng nhập, đổi mật khẩu, sửa hồ sơ và quản trị chưa hoạt động.
Đã bỏ luồng quên/đặt lại mật khẩu: không còn trang JSP, Servlet hoặc liên kết tương ứng.
Đổi mật khẩu trong tài khoản vẫn giữ giao diện.
Main chưa có username trong User/schema. Profile/Admin chưa được Servlet cấp dữ liệu,
nên để trống/trạng thái rỗng; không dùng tài khoản hoặc danh sách người dùng giả.

Giữ tên form/action và vị trí thông báo/CSRF trong JSP để nối backend về sau;
main chưa sinh CSRF token hoặc kiểm tra quyền thực tế. Đây chỉ là bộ giao diện,
không phải ứng dụng xác thực đã hoàn chỉnh. Tài khoản demo của bản xem thử cũ đã mất
khi database H2 tạm được dừng.

## Đã bỏ

- Mã backend bổ sung, helper xác thực/bảo mật, kiểm thử backend và helper database tạm.
- Seed/migration/test SQL đã thêm; schema.sql gốc vẫn giữ nguyên theo main.
- Tài liệu backend: docs/PERSON1.md, docs/API_CONTRACT.md,
  docs/DATABASE_CONTRACT.md, database/README.md.
- Partial/layout/logout JSP thuộc lần triển khai backend cũ, không thuộc bộ Figma.
- Các thư viện SMTP/JUnit/H2 đã thêm trong pom.xml.

Không thay đổi hoặc xóa dữ liệu SQL Server thật. Việc khôi phục chỉ áp dụng source project.
Đã chạy lại mvn clean package sau khi khôi phục: BUILD SUCCESS; Maven báo không có test.
Sau khi bỏ quên/đặt lại mật khẩu, bộ giao diện còn 5 trang: Login, Register,
Change Password, Profile và Admin Users; không cần database để xem giao diện.
Backend/config/schema được đối chiếu không có diff với origin/main; WAR không còn
Angus Mail, JUnit, H2 hoặc các helper backend đã bổ sung.
Các kết quả 37/50 test của backend trước đó không áp dụng cho phiên bản này.

Bản xem giao diện local: http://localhost:18080/techgear/login.
Profile và Admin có thể mở trực tiếp để xem trạng thái rỗng; POST không xử lý nghiệp vụ.
