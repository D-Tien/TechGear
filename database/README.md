# Database cho phiên bản Người 1

Nguồn SQL đang dùng: `TechGear_Full_Setup.sql` phiên bản 2.0, database `TechGearDB_Local`.
File này tạo 8 bảng, hai role, sáu tài khoản demo và 15 sản phẩm.
`schema.sql` là schema khung cũ 11 bảng, chưa có username; giữ để tham khảo,
không chạy cùng file setup mới và không dùng cho module Người 1 hiện tại.

## Khởi tạo

1. Mở SQL Server Management Studio, kết nối đúng SQL Server.
2. Mở `database/TechGear_Full_Setup.sql`, chạy Execute/F5 một lần.
3. File tự tạo `TechGearDB_Local` nếu chưa tồn tại. Database đích phải rỗng;
   nếu đã có bảng thì không chạy lại toàn bộ setup. Không xóa dữ liệu để chạy lại.
4. Kiểm tra:

```sql
USE TechGearDB_Local;
SELECT roleId, roleName FROM dbo.Roles ORDER BY roleId;
SELECT userId, username, email, roleId, active FROM dbo.Users ORDER BY userId;
SELECT COUNT(*) AS ProductCount FROM dbo.Products;
```

Có 2 role, 6 user demo và 15 sản phẩm ở database mới khởi tạo.
Đăng ký luôn tra CUSTOMER theo roleName; ứng dụng không tự seed role hoặc tạo admin.
Nếu database đang dùng đã đúng cấu trúc và có dữ liệu thì chỉ cấu hình kết nối,
không cần chạy lại setup.

## Kết nối ứng dụng

Tomcat cần `DB_URL`, `DB_USER`, `DB_PASSWORD`. Dự án không tự đọc file `.env`.
Ví dụ cho SQL Server local có TCP ở cổng 1433 (thay HOST/PORT theo máy thực tế):

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
$env:DB_URL = 'jdbc:sqlserver://localhost:1433;databaseName=TechGearDB_Local;encrypt=true;trustServerCertificate=true'
$env:DB_USER = Read-Host 'SQL login'
$env:DB_PASSWORD = [System.Net.NetworkCredential]::new('', (Read-Host 'SQL password' -AsSecureString)).Password
& 'C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin\catalina.bat' run
```

`trustServerCertificate=true` dành cho môi trường local dùng chứng chỉ tự ký.
Nếu dùng database chung, cả nhóm đặt cùng HOST, PORT, tên database; chỉ người phụ trách
khởi tạo một lần trên server chung. Không dùng localhost để trỏ tới máy thành viên khác.
JDBC hiện dùng SQL Server Authentication, cần SQL login được cấp quyền trên database.
Nếu SSMS dùng Windows Authentication thì không có nghĩa JDBC hiện đã tự dùng tài khoản Windows.
Không ghi mật khẩu vào Java, SQL hay Git. SQL Server phải bật TCP/IP; kiểm tra cổng thực tế
và firewall nếu kết nối từ máy khác. Khởi động lại Tomcat sau khi đổi biến môi trường.

Các bước kiểm thử tài khoản: [README dự án](../README.md#kiểm-thử-tài-khoản).

## Thay đổi ở SQL v2.0

Products có SKU/slug duy nhất, mô tả ngắn, thông số JSON, giá so sánh, bảo hành,
ảnh chính/gallery JSON, màu JSON, rating/review count, status và các cờ nổi bật.
Vẫn giữ `active BIT` để tương thích các truy vấn đang dùng cột này.
`imageUrl` tăng lên NVARCHAR(1000). Users/Roles không đổi cấu trúc so với v1.

File chỉ khởi tạo database rỗng, không nâng cấp database v1 đã có dữ liệu.
Database đang chạy không tự thay đổi khi thay file SQL trong Git.

Giỏ hàng: `CartProductLookup` đã đọc trực tiếp `Products.imageUrl`, không cần bảng
`ProductImages`. SQL login của ứng dụng cần quyền SELECT trên dbo.Products.
Model/DAO sản phẩm cũng cần đồng bộ nếu sử dụng các trường mới;
INSERT sản phẩm mới phải cung cấp `sku` và `slug`.
