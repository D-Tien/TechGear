# Người 1: cách chạy, kiểm thử và đọc code

## 1. Cấu hình và chạy

Yêu cầu: JDK 17, Maven, Tomcat 10.1, SQL Server.

1. Khởi tạo database theo [database/README.md](../database/README.md). Nguồn dùng là
   `TechGear_Full_Setup.sql`, database `TechGearDB_Local`. Nếu nhóm đã khởi tạo đúng
   database trên server chung thì không chạy lại file setup.
2. Cấu hình `DB_URL`, `DB_USER`, `DB_PASSWORD` cho tiến trình Tomcat, như ví dụ trong
   tài liệu database. `.env.example` chỉ là mẫu, ứng dụng không tự đọc `.env`.
   Nếu chạy từ NetBeans, cấu hình biến môi trường cho tiến trình khởi động Tomcat;
   chỉ đặt biến ở terminal khác sẽ không ảnh hưởng Tomcat đang chạy.
3. Build từ thư mục dự án:

```powershell
mvn clean package
```

Nếu PowerShell báo không nhận lệnh `mvn`, dùng **Clean and Build** trong NetBeans,
hoặc gọi Maven đi kèm NetBeans trên máy này:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
& 'C:\Program Files\NetBeans-17\netbeans\java\maven\bin\mvn.cmd' '-Dmaven.repo.local=D:\TechGear\.tools\m2' clean package
```

4. Dừng Tomcat, thay WAR cũ bằng `target/techgear.war` trong thư mục `webapps` của
   Tomcat. Nếu có thư mục triển khai `webapps/techgear` cũ, sao lưu/cất riêng bản đó
   để Tomcat bung WAR mới. Khởi động lại Tomcat trong môi trường có ba biến DB.
5. Mở `http://localhost:8080/techgear/login` (đổi cổng nếu cấu hình Tomcat khác).
   Link xem trước cũ ở cổng 18080 có thể vẫn chạy bản giao diện; hãy triển khai WAR mới
   để kiểm thử phiên bản này.

Tài khoản demo từ file setup mới:

| Username | Password | Vai trò |
| --- | --- | --- |
| admin | Admin@123456 | ADMIN |
| customer1 đến customer5 | User@123456 | CUSTOMER |

Chỉ dùng tài khoản demo trên môi trường học. Nếu tài khoản đã đổi mật khẩu/khóa trong
DB nhóm thì dùng giá trị hiện tại; ứng dụng không tự khôi phục tài khoản demo.

## 2. Kiểm thử bằng trình duyệt

Nên tạo tài khoản mới dành riêng cho bài test. Không đổi/khóa tài khoản người khác.
Để so sánh ADMIN và CUSTOMER, dùng hai trình duyệt hoặc một cửa sổ ẩn danh.

| Bước | Thao tác | Kết quả mong đợi |
| --- | --- | --- |
| 1 | Chưa login, mở `/techgear/profile` | Chuyển về login |
| 2 | Login sai mật khẩu | Có lỗi, không đăng nhập |
| 3 | Đăng ký `hocjdbc01`, email mới, password `LearnJdbc@123` và xác nhận giống nhau | Thành công, chuyển về login |
| 4 | Đăng ký lại cùng username hoặc email | Báo trùng; không thêm user |
| 5 | Username 3 ký tự, email sai, password dưới 8 ký tự hoặc không khớp | Form/backend từ chối |
| 6 | Login `hocjdbc01` | Tới profile; thấy đúng dữ liệu vừa nhập |
| 7 | CUSTOMER mở `/techgear/admin/users` | HTTP 403 |
| 8 | Sửa họ tên/địa chỉ tiếng Việt, nhập password hiện tại rồi lưu | Lưu thành công, tải lại vẫn đúng |
| 9 | Lưu profile với password sai hoặc email của người khác | Báo lỗi; dữ liệu không đổi |
| 10 | Đổi mật khẩu với password cũ sai hoặc mật khẩu mới giống cũ | Báo lỗi |
| 11 | Đổi sang `NewJdbc@123`, xác nhận đúng | Đăng xuất; password cũ không vào được, password mới vào được |
| 12 | Bấm Đăng xuất trong profile rồi mở lại profile | Về login |
| 13 | Login ADMIN, mở `/techgear/admin/users` | Danh sách lấy từ database |
| 14 | Tìm theo username/họ tên/email; bỏ trống từ khóa rồi tìm lại | Hiện kết quả phù hợp; tìm rỗng hiện tất cả |
| 15 | Bấm Thêm người dùng; điền thông tin, role và password xác nhận ADMIN | Tạo được user; login được bằng tài khoản mới |
| 16 | Sửa user thử nghiệm; bỏ chọn cho phép đăng nhập, nhập password ADMIN rồi lưu | User còn trong danh sách, trạng thái đã khóa |
| 17 | Tài khoản vừa khóa đăng nhập hoặc tải lại profile ở cửa sổ đang login | Bị chặn/đưa về login |
| 18 | ADMIN mở khóa user | User đăng nhập lại được |
| 19 | ADMIN đổi role user thử nghiệm; user tải lại trang được bảo vệ | Quyền mới có hiệu lực |
| 20 | ADMIN thử tự khóa hoặc tự hạ quyền | Bị từ chối |
| 21 | ADMIN nhập sai password xác nhận khi sửa | Bị từ chối |

Có thể dùng nút Hiện/Ẩn mật khẩu, bộ lọc role/trạng thái và phân trang để kiểm tra UI.
Không có luồng quên/reset mật khẩu. Trang Home/Product/Cart/Order của các thành viên khác
chưa được triển khai trong nhiệm vụ này.

## 3. Đối chiếu dữ liệu bằng SSMS

Chọn đúng database và chạy:

```sql
SELECT u.userId, u.username, u.fullName, u.email, r.roleName, u.active, u.createdAt
FROM dbo.Users u
JOIN dbo.Roles r ON r.roleId = u.roleId
ORDER BY u.userId;

-- Chỉ xem dạng hash để xác nhận không lưu plaintext, không chia sẻ kết quả hash.
SELECT username, LEFT(passwordHash, 7) AS HashPrefix, LEN(passwordHash) AS HashLength
FROM dbo.Users;
-- BCrypt hiện tại: prefix $2a$10$, chiều dài 60.

SELECT username, COUNT(*) AS Total FROM dbo.Users
GROUP BY username HAVING COUNT(*) > 1;
SELECT email, COUNT(*) AS Total FROM dbo.Users
GROUP BY email HAVING COUNT(*) > 1;
-- Hai truy vấn trùng phải không có dòng.

SELECT COUNT(*) AS ProductCount FROM dbo.Products;
SELECT COUNT(*) AS OrderCount FROM dbo.Orders;
SELECT COUNT(*) AS DetailCount FROM dbo.OrderDetails;
-- So sánh trước/sau bài test Người 1: các bảng này không thay đổi.
```

Database mới từ setup có 40 sản phẩm, 0 đơn và 0 chi tiết đơn.
Nếu database dùng chung đang được thành viên khác thao tác, số liệu có thể thay đổi bởi họ.

## 4. Kiểm thử bảo vệ bằng DevTools (trên môi trường thử)

- Mở form Register, Inspect phần tử hidden `csrfToken`, đổi value rồi Submit:
  nhận HTTP 403; tải lại trang để lấy token mới.
- Thêm hidden input `roleId` với giá trị role ADMIN vào form Register:
  user mới vẫn là CUSTOMER. Backend không đọc role từ đăng ký.
- Thêm hidden input `userId`/`roleId`/`active` vào form Profile:
  không sửa được tài khoản khác hoặc tự tăng quyền.
- Nhập tên có chuỗi `<script>alert(1)</script>` trên tài khoản thử:
  JSP hiển thị như văn bản, không chạy script.
- Quy tắc trên form chỉ hỗ trợ trải nghiệm; Servlet luôn kiểm tra lại dữ liệu.

Thử role CUSTOMER bị thiếu hoặc ADMIN cuối cùng chỉ nên làm trên database thử riêng.
Không xóa role/user trên database nhóm chỉ để test. Register phải báo thiếu CUSTOMER;
không tự gán roleId khác. UNIQUE trong SQL Server vẫn bảo vệ khi hai request đến đồng thời.

## 5. Cách đọc code để học

1. `User.java`: mỗi thuộc tính tương ứng cột Users, có getter/setter để JSP EL đọc.
2. `DBConnection.java`: lấy cấu hình từ môi trường rồi gọi DriverManager.getConnection.
3. `RoleDAO.java`: ví dụ JDBC đơn giản nhất: mở kết nối, prepareStatement, set tham số,
   executeQuery, result.next và tạo Role.
4. `UserDAO.java`: SELECT/INSERT/UPDATE; setNString cho NVARCHAR tiếng Việt;
   getGeneratedKeys lấy identity; try-with-resources tự đóng JDBC.
5. `RegisterServlet.java`: đọc form → validation → kiểm tra trùng → tìm CUSTOMER →
   BCrypt → DAO.insertUser → redirect. Login tương tự nhưng dùng verifyPassword.
6. `ProfileServlet.java`: lấy userId từ session, không tin userId của trình duyệt.
7. `UserManagementServlet.java`: xử lý create/update; không xóa vật lý tài khoản.
8. `AuthenticationFilter`, `AdminFilter`, `CsrfFilter`: kiểm tra trước khi vào Servlet.
9. JSP dùng JSTL/EL và c:out để hiển thị; không chứa SQL hoặc code Java scriptlet.

Không dùng Spring/Hibernate, không có tầng service hoặc ORM. AuthUtil chỉ gom vài hàm
đọc/kiểm tra form và session. Transaction trong updateUser dùng để giữ ADMIN cuối cùng
an toàn khi có yêu cầu cập nhật đồng thời.

## 6. Khi lỗi

- HTTP 503 khi login/profile: xem log Tomcat, kiểm tra SQL Server đang chạy, TCP/port,
  SQL login, tên database và quyền đọc/ghi. Sau khi sửa môi trường phải restart Tomcat.
- Lỗi cột username: đang kết nối schema cũ; dùng database từ setup mới, không tự xóa DB cũ.
- HTTP 403 CSRF: mở lại form GET rồi gửi lại; không dùng tab/form cũ sau logout/login.
- HTTP 501 trên Product/Order: module đó vẫn là skeleton của thành viên phụ trách.

Giới hạn: đổi password chỉ đăng xuất session hiện tại, chưa thu hồi tất cả session khác.
Đây là phiên bản học tập cơ bản, chưa có rate limiting hoặc xác minh email.

## 7. Kết quả đã chạy khi triển khai (27/10/2026)

- `mvn clean package`: BUILD SUCCESS, WAR `target/techgear.war`.
- 79 kiểm tra HTTP/JDBC qua Tomcat 10.1 + SQL Server Express trên database tạm độc lập:
  demo credentials, đăng ký, trùng dữ liệu, validation, CSRF, HTML escaping, profile,
  đổi password, khóa/mở user, quyền và role CUSTOMER có identity thay đổi.
- 2 kiểm tra lỗi kết nối: login và trang bảo vệ trả 503; không bỏ qua phân quyền.
- 15 kiểm tra Java/DAO trực tiếp: mapping, BCrypt, biên validation, transaction
  bảo vệ ADMIN cuối cùng và rollback khi role không hợp lệ.
- Tổng 96 kiểm tra đạt. Đây là harness chạy ngoài Maven trong `.tools`, không phải
  JUnit test tự động của dự án; Maven hiện báo No tests to run.
- Database/login tạm được dọn sau kiểm thử; không cập nhật dữ liệu database nhóm.
- Chưa kiểm thử từ máy thành viên khác hoặc database server chung; chưa kiểm tra
  bố cục bằng trình duyệt ở đợt này (JSP được biên dịch và xác minh qua HTTP).

Log local (thư mục `.tools` bị Git ignore): `person1-build.log`,
`person1-http-tests.log`, `person1-db-failure-tests.log`, `person1-java-checks.log`.

Các file thay đổi: User model; UserDAO/RoleDAO; 4 Servlet auth; ProfileServlet;
UserManagementServlet; AuthenticationFilter/AdminFilter/CsrfFilter; PasswordUtil,
ValidationUtil/AuthUtil; web.xml; 5 JSP cùng 4 partial auth; auth.css/auth.js/font Inter;
README và tài liệu database/API/cấu trúc/kiểm thử. Đã bỏ hai Servlet và hai JSP
forgot/reset password. Không sửa SQL setup/schema, DAO/Servlet module Người 2/3,
header/navbar/footer hoặc style.css chung.
