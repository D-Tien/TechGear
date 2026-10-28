# 🛒 TechGear – Website Bán Phụ Kiện Công Nghệ

**TechGear** là dự án Java Web được xây dựng cho môn **PRJ301 – FPT University**, sử dụng mô hình MVC kết hợp DAO Pattern.

## 🛠️ Công nghệ sử dụng

- **Backend:** Java Servlet, JSP, JSTL, JDBC
- **Frontend:** HTML, CSS, JavaScript, Bootstrap 5
- **Database:** Microsoft SQL Server
- **Server:** Apache Tomcat 10.1
- **Build Tool:** Maven
- **Java:** JDK 17

## ✨ Chức năng chính

**Người dùng (Customer)**
- Đăng ký, đăng nhập, quản lý tài khoản.
- Xem, tìm kiếm và lọc sản phẩm.
- Thêm sản phẩm vào giỏ hàng, đặt hàng.
- Theo dõi đơn hàng và đánh giá sản phẩm.

**Quản trị viên (Admin)**
- Quản lý sản phẩm, danh mục, thương hiệu.
- Quản lý tài khoản và đơn hàng.
- Thống kê doanh thu, sản phẩm bán chạy.

## 📁 Cấu trúc dự án

```text
TechGear/
├── database/          # Cấu trúc CSDL
├── docs/              # Tài liệu dự án
├── src/main/
│   ├── java/com/techgear/
│   │   ├── config/
│   │   ├── model/
│   │   ├── dao/
│   │   ├── controller/
│   │   ├── filter/
│   │   └── util/
│   └── webapp/         # JSP, CSS, JS
├── pom.xml
└── README.md
```

## 🚀 Cài đặt và chạy

**Yêu cầu:** JDK 17, Maven, Tomcat 10.1 và SQL Server.

**1. Clone repository:**

```bash
git clone https://github.com/D-Tien/TechGear.git
cd TechGear
```

**2.** Với phiên bản Người 1 hiện tại, chạy `database/TechGear_Full_Setup.sql` trên SQL Server để tạo `TechGearDB_Local` (chỉ database rỗng). Không chạy thêm schema cũ. Xem [hướng dẫn database](database/README.md).

**3.** Cấu hình các biến môi trường `DB_URL`, `DB_USER`, `DB_PASSWORD`.

**4. Build project:**

```bash
mvn clean package
```

**5.** Deploy `target/techgear.war` lên Tomcat 10.1.

Truy cập Người 1: `http://localhost:8080/techgear/login`.

Cấu hình SQL Server chi tiết: [database/README.md](database/README.md).
Nếu PowerShell chưa nhận `mvn`, dùng **Clean and Build** trong NetBeans.
Tomcat phải được khởi động với các biến DB; dự án không tự đọc `.env`.
Bản chạy local trên máy phát triển hiện dùng `http://localhost:18080/techgear/login`.

## Kiểm thử tài khoản

Tài khoản demo từ SQL setup: `admin / Admin@123456` (ADMIN),
`customer1` đến `customer5 / User@123456` (CUSTOMER), nếu chưa bị đổi mật khẩu/khóa.

1. Đăng ký tài khoản thử bằng username 4–30 ký tự, email mới, mật khẩu từ 8 ký tự
   và tối đa 72 byte UTF-8; xác nhận phải trùng. Thử lại username/email trùng để xem lỗi.
2. Login CUSTOMER: tới `/profile`; kiểm tra họ tên/email đúng dữ liệu đã lưu.
   Sửa thông tin kèm mật khẩu hiện tại, tải lại để xác nhận đã lưu vào SQL Server.
3. Đổi mật khẩu: thử mật khẩu cũ sai rồi thử đúng; thành công sẽ đăng xuất.
   Mật khẩu cũ không vào được, mật khẩu mới vào được.
4. CUSTOMER mở `/admin/users`: phải bị chặn 403. Chưa login mở profile: về login.
5. Login ADMIN: tìm kiếm, tạo/sửa, khóa/mở tài khoản thử; thao tác cần mật khẩu ADMIN.
   User bị khóa không đăng nhập được. Không tự khóa/hạ quyền ADMIN.
6. Bấm Đăng xuất rồi mở lại profile: phải về login.

Kiểm tra SSMS để đối chiếu Users và Roles. Không thử khóa/đổi mật khẩu tài khoản người khác
trong database chung. Không có luồng quên/reset mật khẩu.

Luồng code: JSP → Servlet → UserDAO/RoleDAO → PreparedStatement → SQL Server.
Session `currentUser` giữ người đang login; filter kiểm tra đăng nhập/quyền;
JSP dùng JSTL/EL để hiển thị và gửi form POST có CSRF token.

## 👥 Thành viên nhóm

| STT | Họ và tên |
|---|---|
| 1 | Vương Đức Tiến |
| 2 | Hà Trọng Minh Trường |
| 3 | Trần Đăng Thành |

---

**TechGear © 2026 – PRJ301 | FPT University**
