# SQL Server setup

1. Tạo database rỗng `TechGear` bằng SSMS hoặc công cụ quản trị của bạn.
2. Chọn database đó, mở và chạy `schema.sql` một lần. Script dùng schema dbo và một transaction, không DROP dữ liệu và không tự tạo database.
3. Kiểm tra đủ 11 bảng. Script không idempotent: chạy lại sẽ báo bảng đã tồn tại.
4. Cấp quyền cần thiết cho tài khoản SQL Server dùng bởi ứng dụng; không commit thông tin đăng nhập.
5. Cấu hình DB_URL, DB_USER, DB_PASSWORD trong tiến trình Tomcat rồi khởi động lại.

Không có INSERT, seed, tài khoản admin hoặc sản phẩm mặc định. Các role cũng chưa được tạo dữ liệu.
Đọc [database contract](../docs/DATABASE_CONTRACT.md) trước khi thay đổi schema.
Chưa thực thi script trên SQL Server trong bước tạo skeleton; cần kiểm chứng tại môi trường database của nhóm.
