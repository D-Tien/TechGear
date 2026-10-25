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

**2.** Tạo database bằng file `database/schema.sql`.

**3.** Cấu hình các biến môi trường `DB_URL`, `DB_USER`, `DB_PASSWORD`.

**4. Build project:**

```bash
mvn clean package
```

**5.** Deploy `target/techgear.war` lên Tomcat 10.1.

Truy cập: `http://localhost:8080/techgear/`

## 👥 Thành viên nhóm

| STT | Họ và tên |
|---|---|
| 1 | Vương Đức Tiến |
| 2 | Hà Trọng Minh Trường |
| 3 | Trần Đăng Thành |

---

**TechGear © 2026 – PRJ301 | FPT University**
