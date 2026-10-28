-- TECHGEAR / PRJ301 - FULL LOCAL SQL SERVER SETUP
-- Version: 2.0 | 27/10/2026
-- ONE FILE: creates TechGearDB_Local, 8 tables and 15 detailed demo products.
-- Run in Microsoft SQL Server Management Studio (SSMS) using Execute / F5.
-- Safe policy: NEVER drops/overwrites an existing schema or existing business data.
-- If dbo.Roles already exists, STOP with an error rather than silently alter it.
-- Intended for a NEW local development database; not a production migration.
-- Demo prices, stocks and descriptions are fictional illustrative data, not current retail offers.
-- Image URLs are PUBLIC WEB PHOTOS illustrative by CATEGORY, not verified product-specific photos.
-- External image hosts may change/block URLs or require internet. Replace with licensed local assets
-- or verified manufacturer images before publication. No image bytes are stored in SQL Server.
-- Includes 6 local demo accounts with BCrypt password hashes; no real customer information.

USE [master];
GO
IF DB_ID(N'TechGearDB_Local') IS NULL
    EXEC(N'CREATE DATABASE [TechGearDB_Local]');
GO
USE [TechGearDB_Local];
GO

SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dbo'))
        THROW 51000, 'Target database already has dbo tables; use a new empty database.', 1;

    -- 8 business tables: Roles, Users, PasswordResetTokens, Categories, Brands,
    -- Products, Orders, OrderDetails. Cart is HttpSession; no Reviews/ProductImages.
    CREATE TABLE dbo.Roles (
        roleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        roleName NVARCHAR(20) NOT NULL UNIQUE
            CONSTRAINT CK_Roles_roleName CHECK (roleName IN (N'ADMIN',N'CUSTOMER'))
    );

    CREATE TABLE dbo.Users (
        userId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        roleId INT NOT NULL,
        username NVARCHAR(30) NOT NULL,
        fullName NVARCHAR(100) NOT NULL,
        email NVARCHAR(254) NOT NULL,
        passwordHash NVARCHAR(255) NOT NULL,
        phone NVARCHAR(20) NULL,
        address NVARCHAR(500) NULL,
        active BIT NOT NULL CONSTRAINT DF_Users_active DEFAULT (1),
        createdAt DATETIME2 NOT NULL CONSTRAINT DF_Users_createdAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Users_Roles FOREIGN KEY (roleId) REFERENCES dbo.Roles(roleId),
        CONSTRAINT UQ_Users_username UNIQUE (username),
        CONSTRAINT UQ_Users_email UNIQUE (email),
        CONSTRAINT CK_Users_username_nonempty CHECK (LEN(LTRIM(RTRIM(username))) BETWEEN 4 AND 30)
    );

    CREATE TABLE dbo.PasswordResetTokens (
        tokenId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        userId INT NOT NULL,
        tokenHash NVARCHAR(255) NOT NULL UNIQUE,
        expiresAt DATETIME2 NOT NULL,
        used BIT NOT NULL CONSTRAINT DF_Reset_used DEFAULT (0),
        createdAt DATETIME2 NOT NULL CONSTRAINT DF_Reset_createdAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Reset_Users FOREIGN KEY (userId) REFERENCES dbo.Users(userId),
        CONSTRAINT CK_Reset_expiry CHECK (expiresAt > createdAt)
    );

    CREATE TABLE dbo.Categories (
        categoryId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        categoryName NVARCHAR(100) NOT NULL UNIQUE,
        description NVARCHAR(1000) NULL
    );

    CREATE TABLE dbo.Brands (
        brandId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        brandName NVARCHAR(100) NOT NULL UNIQUE,
        description NVARCHAR(1000) NULL
    );

    CREATE TABLE dbo.Products (
        productId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        categoryId INT NOT NULL,
        brandId INT NOT NULL,
        productName NVARCHAR(200) NOT NULL,
        sku NVARCHAR(50) NOT NULL,
        slug NVARCHAR(280) NOT NULL,
        shortDescription NVARCHAR(500) NULL,
        description NVARCHAR(MAX) NULL,
        specifications NVARCHAR(MAX) NULL,
        price DECIMAL(18,2) NOT NULL CONSTRAINT CK_Products_price CHECK (price >= 0),
        compareAtPrice DECIMAL(18,2) NULL,
        stockQuantity INT NOT NULL CONSTRAINT CK_Products_stock CHECK (stockQuantity >= 0),
        warrantyMonths INT NOT NULL CONSTRAINT DF_Products_warranty DEFAULT (12),
        imageUrl NVARCHAR(1000) NULL,
        imageGalleryJson NVARCHAR(MAX) NULL,
        colorsJson NVARCHAR(MAX) NULL,
        averageRating DECIMAL(2,1) NOT NULL CONSTRAINT DF_Products_rating DEFAULT (0),
        reviewCount INT NOT NULL CONSTRAINT DF_Products_reviews DEFAULT (0),
        status NVARCHAR(20) NOT NULL CONSTRAINT DF_Products_status DEFAULT (N'ACTIVE'),
        isFeatured BIT NOT NULL CONSTRAINT DF_Products_featured DEFAULT (0),
        isBestSeller BIT NOT NULL CONSTRAINT DF_Products_bestSeller DEFAULT (0),
        isNewArrival BIT NOT NULL CONSTRAINT DF_Products_newArrival DEFAULT (0),
        active BIT NOT NULL CONSTRAINT DF_Products_active DEFAULT (1),
        createdAt DATETIME2 NOT NULL CONSTRAINT DF_Products_createdAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Products_Categories FOREIGN KEY (categoryId) REFERENCES dbo.Categories(categoryId),
        CONSTRAINT FK_Products_Brands FOREIGN KEY (brandId) REFERENCES dbo.Brands(brandId),
        CONSTRAINT UQ_Products_sku UNIQUE (sku),
        CONSTRAINT UQ_Products_slug UNIQUE (slug),
        CONSTRAINT CK_Products_compareAtPrice CHECK (compareAtPrice IS NULL OR compareAtPrice >= price),
        CONSTRAINT CK_Products_warranty CHECK (warrantyMonths >= 0),
        CONSTRAINT CK_Products_rating CHECK (averageRating BETWEEN 0 AND 5),
        CONSTRAINT CK_Products_reviewCount CHECK (reviewCount >= 0),
        CONSTRAINT CK_Products_status CHECK (status IN (N'DRAFT',N'ACTIVE',N'OUT_OF_STOCK',N'DISCONTINUED')),
        CONSTRAINT CK_Products_specsJson CHECK (specifications IS NULL OR ISJSON(specifications) = 1),
        CONSTRAINT CK_Products_imagesJson CHECK (imageGalleryJson IS NULL OR ISJSON(imageGalleryJson) = 1),
        CONSTRAINT CK_Products_colorsJson CHECK (colorsJson IS NULL OR ISJSON(colorsJson) = 1)
    );

    CREATE TABLE dbo.Orders (
        orderId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        userId INT NOT NULL,
        recipientName NVARCHAR(100) NOT NULL,
        shippingAddress NVARCHAR(500) NOT NULL,
        phone NVARCHAR(20) NOT NULL,
        totalAmount DECIMAL(18,2) NOT NULL CONSTRAINT CK_Orders_total CHECK (totalAmount >= 0),
        status NVARCHAR(20) NOT NULL CONSTRAINT DF_Orders_status DEFAULT N'PENDING',
        paymentMethod NVARCHAR(50) NOT NULL,
        createdAt DATETIME2 NOT NULL CONSTRAINT DF_Orders_createdAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Orders_Users FOREIGN KEY (userId) REFERENCES dbo.Users(userId),
        CONSTRAINT CK_Orders_status CHECK (status IN (N'PENDING',N'CONFIRMED',N'SHIPPING',N'DELIVERED',N'CANCELLED')),
        CONSTRAINT CK_Orders_payment CHECK (paymentMethod IN (N'COD'))
    );

    CREATE TABLE dbo.OrderDetails (
        orderDetailId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        orderId INT NOT NULL,
        productId INT NOT NULL,
        quantity INT NOT NULL CONSTRAINT CK_OrderDetails_quantity CHECK (quantity > 0),
        unitPrice DECIMAL(18,2) NOT NULL CONSTRAINT CK_OrderDetails_price CHECK (unitPrice >= 0),
        CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (orderId) REFERENCES dbo.Orders(orderId),
        CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
        CONSTRAINT UQ_OrderDetails_order_product UNIQUE (orderId,productId)
    );

    CREATE INDEX IX_Products_catalog ON dbo.Products(active,categoryId,brandId,price);
    CREATE INDEX IX_Orders_user_date ON dbo.Orders(userId,createdAt DESC);
    CREATE INDEX IX_OrderDetails_product ON dbo.OrderDetails(productId);
    CREATE INDEX IX_ResetTokens_user ON dbo.PasswordResetTokens(userId);

    INSERT INTO dbo.Roles(roleName) VALUES (N'ADMIN'),(N'CUSTOMER');

    -- DEMO LOGIN ACCOUNTS (LOCAL ONLY; NEVER DEPLOY WITH THESE PASSWORDS)
    -- admin / Admin@123456 (ADMIN)
    -- customer1..customer5 / User@123456 (CUSTOMER)
    -- BCrypt hashes use $2a$ prefix, cost 10 (compatible with most Java BCrypt libraries).
    -- Change/remove demo credentials before exposing application outside local development.
    INSERT INTO dbo.Users(username,fullName,email,roleId,passwordHash)
    SELECT v.username,v.fullName,v.email,r.roleId,v.passwordHash
    FROM (VALUES
        (N'admin',N'TechGear Admin',N'admin@techgear.local',N'ADMIN',N'$2a$10$tuKpGQ6jdqtyApQ28ORtFesfEIkcgn2Qg91F9A4C0NqnUy9o5KmGG'),
        (N'customer1',N'Khach hang 01',N'customer1@techgear.local',N'CUSTOMER',N'$2a$10$krYSVBEUAou3tru/VQ7TNeu..LQm.xGlPyCrv965VT4o.J3NfIDUa'),
        (N'customer2',N'Khach hang 02',N'customer2@techgear.local',N'CUSTOMER',N'$2a$10$my86uQR5Kvluf4H6hIvXVeoS4eLjX00/PgAc9nh2IiDz5Bk7L5mVi'),
        (N'customer3',N'Khach hang 03',N'customer3@techgear.local',N'CUSTOMER',N'$2a$10$gyWq3PbNy9CfcDYAlm.J7eJJpGWNaerO77z6efsZ83GL0zvkCWWyC'),
        (N'customer4',N'Khach hang 04',N'customer4@techgear.local',N'CUSTOMER',N'$2a$10$Ud/SyEuCg.6SM9g.JxXXkeSiKkTgBb6c7ijbMx.d2jXm9AomJjaEu'),
        (N'customer5',N'Khach hang 05',N'customer5@techgear.local',N'CUSTOMER',N'$2a$10$sffmQb4E3OFYFY93uTn6UOaAzy243isNQp3Bo40XnpWmCHteMZUHK')
    ) AS v(username,fullName,email,roleName,passwordHash)
    INNER JOIN dbo.Roles r ON r.roleName=v.roleName;

    IF (SELECT COUNT_BIG(*) FROM dbo.Users) <> 6
        THROW 51002, 'User seed incomplete; rolling back.', 1;

    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Bàn phím',N'Danh mục bàn phím và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Chuột',N'Danh mục chuột và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Tai nghe',N'Danh mục tai nghe và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Màn hình',N'Danh mục màn hình và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Webcam',N'Danh mục webcam và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Phụ kiện',N'Danh mục phụ kiện và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Loa',N'Danh mục loa và thiết bị liên quan');
    INSERT INTO dbo.Categories(categoryName,description) VALUES (N'Ổ cứng',N'Danh mục ổ cứng và thiết bị liên quan');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'ASUS',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Anker',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Corsair',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Dell',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'HyperX',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'JBL',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Keychron',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Kingston',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'LG',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Logitech',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Razer',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Samsung',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'Sony',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'SteelSeries',N'Thương hiệu thiết bị công nghệ');
    INSERT INTO dbo.Brands(brandName,description) VALUES (N'UGREEN',N'Thương hiệu thiết bị công nghệ');

    -- Curated 15 products from the supplied 40-product SQL catalog.
    -- All product specs, comparison prices, ratings, and colors are DEMO data.
    -- External Unsplash photos are category illustrations, NOT exact SKU photos.
    INSERT INTO dbo.Products
        (categoryId, brandId, productName, sku, slug, shortDescription, description,
         specifications, price, compareAtPrice, stockQuantity, warrantyMonths,
         imageUrl, imageGalleryJson, colorsJson, averageRating, reviewCount,
         status, isFeatured, isBestSeller, isNewArrival, active, createdAt)
    SELECT c.categoryId, b.brandId, v.productName, v.sku, v.slug,
           v.shortDescription, v.description, v.specifications,
           v.price, v.compareAtPrice, v.stockQuantity, v.warrantyMonths,
           v.imageUrl, v.imageGalleryJson, v.colorsJson, v.averageRating,
           v.reviewCount, N'ACTIVE', v.isFeatured, v.isBestSeller,
           v.isNewArrival, 1, DATEADD(DAY, -v.daysAgo, SYSUTCDATETIME())
    FROM (VALUES
        (N'Logitech G Pro X TKL LIGHTSPEED', N'Bàn phím', N'Logitech', N'TG-DEMO-001', N'logitech-g-pro-x-tkl-lightspeed', N'Bàn phím chơi game TKL không dây LIGHTSPEED.', N'Bàn phím không dây dạng tenkeyless, phù hợp góc gaming gọn gàng.', N'{"Kiểu":"TKL","Kết nối":"LIGHTSPEED không dây","Công dụng":"Gaming"}', 3290000, 3790000, 24, 24, N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":14},{"name":"Trắng","hex":"#F8FAFC","stock":10}]', 4.8, 114, 1, 1, 0, 0),
        (N'Keychron K2 Pro', N'Bàn phím', N'Keychron', N'TG-DEMO-002', N'keychron-k2-pro', N'Bàn phím cơ 75% hỗ trợ tùy chỉnh.', N'Bàn phím cơ gọn gàng dành cho làm việc và lập trình.', N'{"Layout":"75%","Firmware":"QMK/VIA","Kết nối":"Bluetooth / USB-C"}', 2190000, 2490000, 42, 12, N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#1F2937","stock":24},{"name":"Trắng","hex":"#F8FAFC","stock":18}]', 4.7, 72, 1, 0, 1, 42),
        (N'Logitech G502 HERO', N'Chuột', N'Logitech', N'TG-DEMO-003', N'logitech-g502-hero', N'Chuột gaming có dây với cảm biến HERO.', N'Chuột chơi game nhiều nút tùy chỉnh và độ chính xác cao.', N'{"Kết nối":"USB có dây","Cảm biến":"HERO","Mục đích":"Gaming"}', 990000, 1190000, 58, 12, N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":58}]', 4.8, 189, 1, 1, 0, 56),
        (N'Logitech MX Master 3S', N'Chuột', N'Logitech', N'TG-DEMO-004', N'logitech-mx-master-3s', N'Chuột không dây công thái học dành cho làm việc.', N'Tối ưu năng suất và chuyển đổi giữa nhiều thiết bị.', N'{"DPI":"8000","Kết nối":"Bluetooth / Logi Bolt","Sạc":"USB-C"}', 2490000, 2790000, 37, 12, N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Graphite","hex":"#35393D","stock":22},{"name":"Xám","hex":"#CDD2D5","stock":15}]', 4.9, 318, 1, 1, 0, 70),
        (N'HyperX Cloud III', N'Tai nghe', N'HyperX', N'TG-DEMO-005', N'hyperx-cloud-iii', N'Tai nghe gaming over-ear với micro.', N'Thiết kế đệm tai thoải mái cho chơi game và họp trực tuyến.', N'{"Loại":"Over-ear","Micro":"Có","Mục đích":"Gaming"}', 2190000, 2490000, 31, 12, N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":20},{"name":"Đỏ-Đen","hex":"#BE123C","stock":11}]', 4.7, 95, 1, 0, 0, 105),
        (N'Sony WH-1000XM5', N'Tai nghe', N'Sony', N'TG-DEMO-006', N'sony-wh-1000xm5', N'Tai nghe chống ồn không dây cao cấp.', N'Âm thanh chi tiết và công nghệ chống ồn, phục vụ giải trí và công việc.', N'{"Kết nối":"Bluetooth","Chống ồn":"ANC","Kiểu":"Over-ear"}', 7490000, 8490000, 15, 12, N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#171717","stock":8},{"name":"Bạc","hex":"#D1D5DB","stock":7}]', 4.9, 246, 1, 1, 0, 140),
        (N'Razer BlackShark V2 X', N'Tai nghe', N'Razer', N'TG-DEMO-007', N'razer-blackshark-v2-x', N'Tai nghe chơi game nhẹ với micro.', N'Dành cho game thủ muốn giao tiếp rõ ràng trong trận đấu.', N'{"Loại":"Gaming headset","Micro":"Có","Kết nối":"Có dây"}', 1190000, 1390000, 46, 12, N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":46}]', 4.6, 76, 0, 0, 1, 119),
        (N'Dell P2422H 24 inch', N'Màn hình', N'Dell', N'TG-DEMO-008', N'dell-p2422h-24-inch', N'Màn hình 24 inch dành cho học tập và văn phòng.', N'Thiết kế tối giản, thuận tiện cho các tác vụ làm việc hằng ngày.', N'{"Kích thước":"24 inch","Độ phân giải":"Full HD","Mục đích":"Văn phòng"}', 4190000, 4590000, 20, 24, N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":20}]', 4.7, 44, 1, 0, 1, 11),
        (N'LG UltraGear 27GR75Q 27 inch', N'Màn hình', N'LG', N'TG-DEMO-009', N'lg-ultragear-27gr75q-27-inch', N'Màn hình gaming 27 inch.', N'Không gian hiển thị rộng cho game và nội dung đa phương tiện.', N'{"Kích thước":"27 inch","Độ phân giải":"QHD","Mục đích":"Gaming"}', 6890000, 7290000, 17, 24, N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":17}]', 4.8, 39, 1, 0, 1, 25),
        (N'Logitech C920 HD Pro', N'Webcam', N'Logitech', N'TG-DEMO-010', N'logitech-c920-hd-pro', N'Webcam Full HD cho học và họp online.', N'Giải pháp video call gọn nhẹ, phù hợp học trực tuyến và văn phòng.', N'{"Độ phân giải":"1080p","Kết nối":"USB","Mục đích":"Video call"}', 1590000, 1890000, 21, 12, N'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":21}]', 4.6, 65, 0, 0, 0, 53),
        (N'Anker 735 Charger 65W', N'Phụ kiện', N'Anker', N'TG-DEMO-011', N'anker-735-charger-65w', N'Củ sạc nhanh nhiều cổng công suất 65W.', N'Phụ kiện tiện dụng giúp sạc các thiết bị khi di chuyển.', N'{"Công suất":"65W","Công nghệ":"GaN","Loại":"Củ sạc"}', 1290000, 1490000, 64, 18, N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":32},{"name":"Trắng","hex":"#F8FAFC","stock":32}]', 4.8, 98, 1, 1, 0, 74),
        (N'UGREEN USB-C Hub 6 in 1', N'Phụ kiện', N'UGREEN', N'TG-DEMO-012', N'ugreen-usb-c-hub-6-in-1', N'Hub USB-C mở rộng cổng cho laptop.', N'Hữu ích khi kết nối chuột, bàn phím, màn hình và các thiết bị ngoại vi.', N'{"Kết nối":"USB-C","Số cổng":"6","Loại":"Hub"}', 790000, 990000, 90, 12, N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Xám","hex":"#6B7280","stock":90}]', 4.6, 82, 0, 1, 0, 88),
        (N'JBL Flip 6', N'Loa', N'JBL', N'TG-DEMO-013', N'jbl-flip-6', N'Loa Bluetooth di động nhỏ gọn.', N'Dễ mang theo khi đi chơi hoặc giải trí tại nhà.', N'{"Kết nối":"Bluetooth","Loại":"Loa di động","Chống nước":"IP67"}', 2890000, 3290000, 29, 12, N'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":17},{"name":"Xanh","hex":"#155DFC","stock":12}]', 4.8, 106, 1, 1, 0, 102),
        (N'Samsung T7 Shield 1TB', N'Ổ cứng', N'Samsung', N'TG-DEMO-014', N'samsung-t7-shield-1tb', N'SSD di động 1TB, thiết kế bền bỉ.', N'Ổ lưu trữ di động phù hợp sao lưu tài liệu và dữ liệu công việc.', N'{"Dung lượng":"1TB","Loại":"SSD di động","Kết nối":"USB-C"}', 2290000, 2590000, 24, 36, N'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":14},{"name":"Xanh","hex":"#1D4ED8","stock":10}]', 4.8, 67, 1, 0, 1, 116),
        (N'Kingston XS1000 1TB', N'Ổ cứng', N'Kingston', N'TG-DEMO-015', N'kingston-xs1000-1tb', N'SSD di động 1TB thiết kế gọn.', N'Giải pháp mở rộng dung lượng và truyền dữ liệu.', N'{"Dung lượng":"1TB","Loại":"SSD di động","Kết nối":"USB"}', 1690000, 1990000, 35, 36, N'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=1200&q=85', N'["https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=1200&q=85"]', N'[{"name":"Đen","hex":"#111827","stock":35}]', 4.7, 51, 0, 0, 1, 123)
    ) v(productName,categoryName,brandName,sku,slug,shortDescription,description,
        specifications,price,compareAtPrice,stockQuantity,warrantyMonths,
        imageUrl,imageGalleryJson,colorsJson,averageRating,reviewCount,
        isFeatured,isBestSeller,isNewArrival,daysAgo)
    JOIN dbo.Categories c ON c.categoryName = v.categoryName
    JOIN dbo.Brands b ON b.brandName = v.brandName;

    IF (SELECT COUNT_BIG(*) FROM dbo.Products) <> 15
        THROW 51001, 'Product seed incomplete; rolling back.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- Smoke checks (no mutations).
SELECT DB_NAME() AS DatabaseName;
SELECT N'Roles' AS TableName,COUNT(*) AS Total FROM dbo.Roles
UNION ALL SELECT N'Users',COUNT(*) FROM dbo.Users
UNION ALL SELECT N'PasswordResetTokens',COUNT(*) FROM dbo.PasswordResetTokens
UNION ALL SELECT N'Categories',COUNT(*) FROM dbo.Categories
UNION ALL SELECT N'Brands',COUNT(*) FROM dbo.Brands
UNION ALL SELECT N'Products',COUNT(*) FROM dbo.Products
UNION ALL SELECT N'Orders',COUNT(*) FROM dbo.Orders
UNION ALL SELECT N'OrderDetails',COUNT(*) FROM dbo.OrderDetails;

SELECT TOP (10) p.productId,p.productName,c.categoryName,b.brandName,p.price,p.stockQuantity,p.imageUrl
FROM dbo.Products p
JOIN dbo.Categories c ON c.categoryId=p.categoryId
JOIN dbo.Brands b ON b.brandId=p.brandId
ORDER BY p.productId;
GO
