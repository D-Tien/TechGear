# Database contract

Tài nguyên dùng chung: cả nhóm phải thống nhất trước khi sửa; Person 1 điều phối thay đổi.

Schema `dbo`; identity INT là khóa chính. Java `int` ↔ INT, `boolean` ↔ BIT,
`BigDecimal` ↔ DECIMAL(18,2), `LocalDateTime` ↔ DATETIME2, `String` ↔ NVARCHAR.
DATETIME2 lưu UTC theo quy ước; JDBC cần giữ quy ước này khi đọc/ghi.
Các cột NULL dùng kiểu tham chiếu Java và có thể nhận null.

Nguồn đang dùng: `database/TechGear_Full_Setup.sql`, database `TechGearDB_Local`, phiên bản setup 2.0.
Có hai role ADMIN/CUSTOMER, sáu user demo, 15 sản phẩm.
`schema.sql` là bản khung cũ, không chạy kèm setup mới.
FK mặc định NO ACTION: không xóa dây chuyền lịch sử đơn hàng.
Tên field Java trùng tên cột SQL. Giá trị mặc định SQL chỉ áp dụng khi INSERT bỏ qua cột;
constructor Java không tự áp dụng default SQL.

## Roles (`Role`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| roleId | int | INT IDENTITY(1,1) PRIMARY KEY |
| roleName | String | NVARCHAR(20) NOT NULL UNIQUE CHECK (roleName IN (N'ADMIN', N'CUSTOMER')) |

## Users (`User`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| userId | int | INT IDENTITY(1,1) PRIMARY KEY |
| roleId | int | INT NOT NULL REFERENCES dbo.Roles(roleId) |
| username | String | NVARCHAR(30) NOT NULL UNIQUE; độ dài sau trim 4–30 |
| fullName | String | NVARCHAR(100) NOT NULL |
| email | String | NVARCHAR(254) NOT NULL UNIQUE |
| passwordHash | String | NVARCHAR(255) NOT NULL |
| phone | String | NVARCHAR(20) NULL |
| address | String | NVARCHAR(500) NULL |
| active | boolean | BIT NOT NULL DEFAULT 1 |
| createdAt | LocalDateTime | DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME() |

## Categories (`Category`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| categoryId | int | INT IDENTITY(1,1) PRIMARY KEY |
| categoryName | String | NVARCHAR(100) NOT NULL UNIQUE |
| description | String | NVARCHAR(1000) NULL |

## Brands (`Brand`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| brandId | int | INT IDENTITY(1,1) PRIMARY KEY |
| brandName | String | NVARCHAR(100) NOT NULL UNIQUE |
| description | String | NVARCHAR(1000) NULL |

## Products (`Product`)

Setup v2 lưu ảnh tại `Products.imageUrl NVARCHAR(1000) NULL`.
Model/DAO sản phẩm vẫn là khung cũ, Người 2 cần đồng bộ khi triển khai.

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| productId | int | INT IDENTITY(1,1) PRIMARY KEY |
| categoryId | int | INT NOT NULL REFERENCES dbo.Categories(categoryId) |
| brandId | int | INT NOT NULL REFERENCES dbo.Brands(brandId) |
| productName | String | NVARCHAR(200) NOT NULL |
| description | String | NVARCHAR(MAX) NULL |
| price | BigDecimal | DECIMAL(18,2) NOT NULL CHECK (price >= 0) |
| stockQuantity | int | INT NOT NULL CHECK (stockQuantity >= 0) |
| active | boolean | BIT NOT NULL DEFAULT 1 |
| createdAt | LocalDateTime | DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME() |

Các cột bổ sung của setup v2 (chưa được Product model/DAO khung đọc/ghi):

| Cột | SQL / ràng buộc |
| --- | --- |
| sku | NVARCHAR(50) NOT NULL UNIQUE |
| slug | NVARCHAR(280) NOT NULL UNIQUE |
| shortDescription | NVARCHAR(500) NULL |
| specifications | NVARCHAR(MAX) NULL, ISJSON khi có giá trị |
| compareAtPrice | DECIMAL(18,2) NULL hoặc >= price |
| warrantyMonths | INT NOT NULL DEFAULT 12, >= 0 |
| imageUrl | NVARCHAR(1000) NULL |
| imageGalleryJson, colorsJson | NVARCHAR(MAX) NULL, ISJSON khi có giá trị |
| averageRating | DECIMAL(2,1) NOT NULL DEFAULT 0, từ 0 đến 5 |
| reviewCount | INT NOT NULL DEFAULT 0, >= 0 |
| status | NVARCHAR(20) NOT NULL DEFAULT ACTIVE; DRAFT/ACTIVE/OUT_OF_STOCK/DISCONTINUED |
| isFeatured, isBestSeller, isNewArrival | BIT NOT NULL DEFAULT 0 |

Setup vẫn giữ `active BIT` độc lập với `status`; khi triển khai quản lý sản phẩm,
nhóm cần thống nhất quy tắc cập nhật cả hai. JSON màu/rating là dữ liệu minh họa,
chưa có bảng tồn kho theo màu hoặc đánh giá để đồng bộ tự động.
CartProductLookup đọc ảnh chính trực tiếp từ Products.imageUrl để tương thích setup v2.
Giữ điều kiện active = 1 và các xử lý giỏ hàng hiện tại.

## ProductImages (`ProductImage`) — chỉ có trong schema cũ, không có trong setup mới

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| imageId | int | INT IDENTITY(1,1) PRIMARY KEY |
| productId | int | INT NOT NULL REFERENCES dbo.Products(productId) |
| imageUrl | String | NVARCHAR(500) NOT NULL |
| primaryImage | boolean | BIT NOT NULL DEFAULT 0 |

## Orders (`Order`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| orderId | int | INT IDENTITY(1,1) PRIMARY KEY |
| userId | int | INT NOT NULL REFERENCES dbo.Users(userId) |
| recipientName | String | NVARCHAR(100) NOT NULL |
| shippingAddress | String | NVARCHAR(500) NOT NULL |
| phone | String | NVARCHAR(20) NOT NULL |
| totalAmount | BigDecimal | DECIMAL(18,2) NOT NULL CHECK (totalAmount >= 0) |
| status | String | NVARCHAR(20) NOT NULL DEFAULT N'PENDING' CHECK (status IN (N'PENDING', N'CONFIRMED', N'SHIPPING', N'DELIVERED', N'CANCELLED')) |
| paymentMethod | String | NVARCHAR(50) NOT NULL; setup mới CHECK chỉ COD |
| createdAt | LocalDateTime | DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME() |

## OrderDetails (`OrderDetail`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| orderDetailId | int | INT IDENTITY(1,1) PRIMARY KEY |
| orderId | int | INT NOT NULL REFERENCES dbo.Orders(orderId) |
| productId | int | INT NOT NULL REFERENCES dbo.Products(productId) |
| quantity | int | INT NOT NULL CHECK (quantity > 0) |
| unitPrice | BigDecimal | DECIMAL(18,2) NOT NULL CHECK (unitPrice >= 0) |

Unique: `orderId, productId`.

## CartItems (`CartItem`) — chỉ có trong schema cũ, không có trong setup mới

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| cartItemId | int | INT IDENTITY(1,1) PRIMARY KEY |
| userId | int | INT NOT NULL REFERENCES dbo.Users(userId) |
| productId | int | INT NOT NULL REFERENCES dbo.Products(productId) |
| quantity | int | INT NOT NULL CHECK (quantity > 0) |

Unique: `userId, productId`.

## Reviews (`Review`) — chỉ có trong schema cũ, không có trong setup mới

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| reviewId | int | INT IDENTITY(1,1) PRIMARY KEY |
| userId | int | INT NOT NULL REFERENCES dbo.Users(userId) |
| productId | int | INT NOT NULL REFERENCES dbo.Products(productId) |
| rating | int | INT NOT NULL CHECK (rating BETWEEN 1 AND 5) |
| comment | String | NVARCHAR(2000) NULL |
| createdAt | LocalDateTime | DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME() |

Unique: `userId, productId`.

## PasswordResetTokens (`PasswordResetToken`)

| Cột | Java | SQL / PK / FK / constraint |
| --- | --- | --- |
| tokenId | int | INT IDENTITY(1,1) PRIMARY KEY |
| userId | int | INT NOT NULL REFERENCES dbo.Users(userId) |
| tokenHash | String | NVARCHAR(255) NOT NULL UNIQUE |
| expiresAt | LocalDateTime | DATETIME2 NOT NULL |
| used | boolean | BIT NOT NULL DEFAULT 0 |
| createdAt | LocalDateTime | DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME() |

CHECK `expiresAt > createdAt`. Lưu hash token, không lưu token thô.

## Quy ước nghiệp vụ cho giai đoạn sau

- `OrderDetails.unitPrice` là giá tại thời điểm đặt hàng; `Orders` lưu địa chỉ/người nhận tại thời điểm đặt.
- Thanh toán hiện chỉ có cột phương thức và tổng tiền; giao dịch checkout/stock phải được thiết kế và thống nhất sau.
- Reviews chỉ có trong schema cũ; setup mới không hỗ trợ bảng đánh giá.
- Setup mới không có CartItems; dự kiến dùng session `cart` kiểu `List<CartItem>`, Người 3 triển khai.
- Giá dùng một đơn vị tiền tệ do cả nhóm thống nhất trước khi viết nghiệp vụ.
- Đổi schema phải đi cùng cập nhật model, DAO signature và contract trong cùng PR.

## Quy tắc Người 1

- User.username đã thêm vào model, giữ constructor cũ và bổ sung constructor có username.
- Java int ↔ INT, String ↔ NVARCHAR, boolean ↔ BIT; Timestamp.toLocalDateTime ↔ DATETIME2 (UTC).
- INSERT bỏ userId/active/createdAt để SQL Server sinh identity và dùng default.
- Database UNIQUE bảo vệ username/email kể cả khi hai request đăng ký đồng thời.
- Validation Java dùng username `[A-Za-z0-9_.-]{4,30}`, email tối đa 254, password từ 8 ký tự/tối đa 72 byte UTF-8.
- Mật khẩu hash BCrypt cost 10. Không đưa hash vào session hoặc danh sách JSP.
- Chỉ Register tra role CUSTOMER; roleId gửi từ client không được dùng trong đăng ký.
- Không thay đổi cấu trúc SQL trong đợt triển khai Java này.
