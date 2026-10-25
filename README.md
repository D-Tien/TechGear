# TechGear — Java Web Project Skeleton

Assignment PRJ301, FPT University. Bộ khung MVC + DAO cho website phụ kiện công nghệ;
chỉ có placeholder, chưa có nghiệp vụ hay dữ liệu mẫu.

## Yêu cầu môi trường

- JDK 17, Apache Maven 3.8.7 trở lên, Apache Tomcat 10.1, Microsoft SQL Server.
- Servlet 6.0 (provided bởi Tomcat), JSP/JSTL 3, JDBC SQL Server, jBCrypt.
- Bootstrap 5.3.3 qua CDN; Chart.js 4.4.7 chỉ nạp tại dashboard placeholder.
- Không có Spring, Hibernate/JPA, frontend framework, Lombok hay thư viện gửi email.

## Mở và build

NetBeans: File → Open Project → chọn thư mục chứa pom.xml; chọn Java Platform JDK 17,
đăng ký Tomcat 10.1 ở Services → Servers rồi chọn server cho project nếu IDE hỗ trợ.
IntelliJ: Open pom.xml → Open as Project, đặt Project SDK và Maven runner JDK 17.
Nếu phiên bản IDE không hỗ trợ deploy Tomcat, build WAR và deploy thủ công.

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
mvn clean package
```

Maven cần có trong PATH và truy cập được Maven Central ở lần tải dependency đầu tiên.
WAR được tạo tại `target/techgear.war`.

Đã kiểm chứng ngày 25/10/2026: `clean package` BUILD SUCCESS với JDK 17 và Maven 3.8.7
đi kèm NetBeans. Do Maven chưa có trong PATH trên máy này, lệnh đã dùng là:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
& 'C:\Program Files\NetBeans-17\netbeans\java\maven\bin\mvn.cmd' '-Dmaven.repo.local=D:\TechGear\.tools\m2' clean package
```

`.tools/m2` chỉ là cache Maven cục bộ, đã được gitignore. Đã kiểm tra package/path Java,
20 URL không trùng, mọi đường dẫn forward JSP và XML cấu hình. Chưa có test nghiệp vụ;
chưa thử deploy/chạy JSP trên Tomcat hoặc thực thi schema/kết nối SQL Server.

## Database và environment

Làm theo [database/README.md](database/README.md), chạy schema trên database rỗng.
Tham khảo `.env.example` cho `DB_URL`, `DB_USER`, `DB_PASSWORD`; thay placeholder bằng
cấu hình riêng trong environment của tiến trình Tomcat hoặc cấu hình Run của IDE.
File `.env` không được tự đọc và không cần thêm thư viện dotenv.
SQL Server phải bật TCP/IP, cho phép kết nối tới cổng đã cấu hình và hỗ trợ SQL authentication
nếu dùng DB_USER/DB_PASSWORD. URL mặc định gợi ý dùng TLS và xác minh certificate;
cấu hình certificate phù hợp với máy SQL Server.

DBConnection chỉ mở kết nối khi được gọi; startup và trang placeholder không gọi database.
DAO sau này phải dùng try-with-resources và PreparedStatement. Không log credential.

## Deploy Tomcat 10.1

1. Chạy Tomcat bằng JDK 17. Nếu chạy Windows service, đặt Java/environment trong cấu hình service;
   biến môi trường ở terminal không tự truyền vào service đã chạy.
2. Copy `target/techgear.war` vào thư mục `webapps` của Tomcat, khởi động Tomcat.
3. Mở `http://localhost:8080/techgear/` để xem Welcome; `/techgear/home` để xem JSP placeholder.
4. Các GET route trong API contract chỉ hiển thị heading; POST trả 501.

JSP dùng CDN nên cần internet để tải Bootstrap/Chart.js; nội dung HTML placeholder vẫn có thể hiển thị khi offline.

## Đã tạo và còn TODO

Đã tạo đầy đủ package, model beans, DAO signatures, 20 servlet mapping, 3 filter,
JSP placeholder, assets comment, schema 11 bảng và tài liệu hợp đồng nhóm.
EncodingFilter và DBConnection là hạ tầng tối thiểu; không có login/CRUD/cart/checkout.
AuthenticationFilter/AdminFilter hiện pass-through; PasswordUtil, ValidationUtil, EmailUtil
chưa triển khai và ném UnsupportedOperationException để tránh báo thành công giả.
DAO chỉ trả empty/null/false/0; không thực thi SQL nghiệp vụ.

TODO: toàn bộ nghiệp vụ, UI, BCrypt, validation, bảo vệ route, email, transaction checkout,
thống kê, kiểm thử chức năng và cấu hình database thực tế. Không có admin mặc định hay seed.

## Tài liệu

- [Danh sách đầy đủ file và cấu trúc](docs/PROJECT_STRUCTURE.md)
- [Phân công 3 thành viên](docs/TEAM_GUIDELINES.md)
- [Servlet/session contract](docs/API_CONTRACT.md)
- [Database/model contract](docs/DATABASE_CONTRACT.md)

Servlet API 6.0 được chọn theo [Tomcat 10.1](https://tomcat.apache.org/migration-10.1.html).
JDBC 12.8 hỗ trợ JDK 17 theo [Microsoft](https://learn.microsoft.com/en-us/sql/connect/jdbc/release-notes-for-the-jdbc-driver).
