-- TECHGEAR / PRJ301 - FULL LOCAL SQL SERVER SETUP
-- Version: 1.0 | 27/10/2026
-- ONE FILE: creates TechGearDB, 8 tables and 40 illustrative demo products.
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
IF DB_ID(N'TechGearDB') IS NULL
    EXEC(N'CREATE DATABASE [TechGearDB]');
GO
USE [TechGearDB];
GO

-- Avoid touching an existing TechGear database or misaligning the Java/DAO contract.
IF EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dbo'))
    THROW 51000, 'Target database already contains dbo tables. Setup only works on an empty DB. Backup and use an approved migration instead.', 1;
GO

SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

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
        description NVARCHAR(MAX) NULL,
        price DECIMAL(18,2) NOT NULL CONSTRAINT CK_Products_price CHECK (price >= 0),
        stockQuantity INT NOT NULL CONSTRAINT CK_Products_stock CHECK (stockQuantity >= 0),
        imageUrl NVARCHAR(500) NULL,
        active BIT NOT NULL CONSTRAINT DF_Products_active DEFAULT (1),
        createdAt DATETIME2 NOT NULL CONSTRAINT DF_Products_createdAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Products_Categories FOREIGN KEY (categoryId) REFERENCES dbo.Categories(categoryId),
        CONSTRAINT FK_Products_Brands FOREIGN KEY (brandId) REFERENCES dbo.Brands(brandId)
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

    -- Demo catalog: use JOIN on category/brand names (never assume identity values).
    -- The image links deliberately represent CATEGORY imagery and can repeat across SKUs.
    INSERT INTO dbo.Products(categoryId,brandId,productName,description,price,stockQuantity,imageUrl,createdAt)
    SELECT c.categoryId,b.brandId,v.productName,
           N'Dữ liệu minh họa PRJ301 cho ' + v.productName + N'. Vui lòng kiểm tra thông số, giá và ảnh trước khi đăng bán.',
           v.price,v.stockQuantity,v.imageUrl,
           DATEADD(DAY,-v.daysAgo,SYSUTCDATETIME())
    FROM (VALUES
        (N'Logitech G Pro X TKL LIGHTSPEED',N'Bàn phím',N'Logitech',CAST(3290000 AS DECIMAL(18,2)),24,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',0),
        (N'Logitech G413 SE',N'Bàn phím',N'Logitech',CAST(1590000 AS DECIMAL(18,2)),38,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',7),
        (N'Logitech MX Keys S',N'Bàn phím',N'Logitech',CAST(2690000 AS DECIMAL(18,2)),19,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',14),
        (N'Razer BlackWidow V4 X',N'Bàn phím',N'Razer',CAST(2990000 AS DECIMAL(18,2)),30,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',21),
        (N'Razer Huntsman Mini',N'Bàn phím',N'Razer',CAST(2390000 AS DECIMAL(18,2)),18,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',28),
        (N'Corsair K70 RGB Pro',N'Bàn phím',N'Corsair',CAST(3490000 AS DECIMAL(18,2)),14,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',35),
        (N'Keychron K2 Pro',N'Bàn phím',N'Keychron',CAST(2190000 AS DECIMAL(18,2)),42,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',42),
        (N'Keychron K8 Pro',N'Bàn phím',N'Keychron',CAST(2490000 AS DECIMAL(18,2)),27,N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85',49),
        (N'Logitech G502 HERO',N'Chuột',N'Logitech',CAST(990000 AS DECIMAL(18,2)),58,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',56),
        (N'Logitech G304 LIGHTSPEED',N'Chuột',N'Logitech',CAST(790000 AS DECIMAL(18,2)),66,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',63),
        (N'Logitech MX Master 3S',N'Chuột',N'Logitech',CAST(2490000 AS DECIMAL(18,2)),37,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',70),
        (N'Razer DeathAdder V3',N'Chuột',N'Razer',CAST(1790000 AS DECIMAL(18,2)),35,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',77),
        (N'Razer Viper V3 HyperSpeed',N'Chuột',N'Razer',CAST(1890000 AS DECIMAL(18,2)),28,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',84),
        (N'Razer Basilisk V3',N'Chuột',N'Razer',CAST(1490000 AS DECIMAL(18,2)),43,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',91),
        (N'SteelSeries Rival 3',N'Chuột',N'SteelSeries',CAST(890000 AS DECIMAL(18,2)),39,N'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=900&q=85',98),
        (N'HyperX Cloud III',N'Tai nghe',N'HyperX',CAST(2190000 AS DECIMAL(18,2)),31,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',105),
        (N'HyperX Cloud Alpha',N'Tai nghe',N'HyperX',CAST(1890000 AS DECIMAL(18,2)),25,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',112),
        (N'Razer BlackShark V2 X',N'Tai nghe',N'Razer',CAST(1190000 AS DECIMAL(18,2)),46,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',119),
        (N'Razer Barracuda X',N'Tai nghe',N'Razer',CAST(2490000 AS DECIMAL(18,2)),22,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',126),
        (N'Logitech G435 LIGHTSPEED',N'Tai nghe',N'Logitech',CAST(1490000 AS DECIMAL(18,2)),50,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',133),
        (N'Sony WH-1000XM5',N'Tai nghe',N'Sony',CAST(7490000 AS DECIMAL(18,2)),15,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',140),
        (N'Sony WH-CH720N',N'Tai nghe',N'Sony',CAST(2790000 AS DECIMAL(18,2)),24,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',147),
        (N'Corsair HS80 RGB USB',N'Tai nghe',N'Corsair',CAST(2190000 AS DECIMAL(18,2)),19,N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',4),
        (N'Dell P2422H 24 inch',N'Màn hình',N'Dell',CAST(4190000 AS DECIMAL(18,2)),20,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',11),
        (N'Dell S2722QC 27 inch',N'Màn hình',N'Dell',CAST(7990000 AS DECIMAL(18,2)),12,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',18),
        (N'LG UltraGear 27GR75Q 27 inch',N'Màn hình',N'LG',CAST(6890000 AS DECIMAL(18,2)),17,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',25),
        (N'LG 24MP400 24 inch',N'Màn hình',N'LG',CAST(2590000 AS DECIMAL(18,2)),32,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',32),
        (N'ASUS TUF Gaming VG249Q3A',N'Màn hình',N'ASUS',CAST(3790000 AS DECIMAL(18,2)),26,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',39),
        (N'Samsung Odyssey G5 27 inch',N'Màn hình',N'Samsung',CAST(5990000 AS DECIMAL(18,2)),18,N'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85',46),
        (N'Logitech C920 HD Pro',N'Webcam',N'Logitech',CAST(1590000 AS DECIMAL(18,2)),21,N'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?auto=format&fit=crop&w=900&q=85',53),
        (N'Logitech Brio 500',N'Webcam',N'Logitech',CAST(2690000 AS DECIMAL(18,2)),18,N'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?auto=format&fit=crop&w=900&q=85',60),
        (N'Razer Kiyo X',N'Webcam',N'Razer',CAST(1590000 AS DECIMAL(18,2)),14,N'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?auto=format&fit=crop&w=900&q=85',67),
        (N'Anker 735 Charger 65W',N'Phụ kiện',N'Anker',CAST(1290000 AS DECIMAL(18,2)),64,N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=900&q=85',74),
        (N'Anker PowerCore 10000',N'Phụ kiện',N'Anker',CAST(890000 AS DECIMAL(18,2)),75,N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=900&q=85',81),
        (N'UGREEN USB-C Hub 6 in 1',N'Phụ kiện',N'UGREEN',CAST(790000 AS DECIMAL(18,2)),90,N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=900&q=85',88),
        (N'UGREEN USB-C Cable 100W 2m',N'Phụ kiện',N'UGREEN',CAST(290000 AS DECIMAL(18,2)),110,N'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=900&q=85',95),
        (N'JBL Flip 6',N'Loa',N'JBL',CAST(2890000 AS DECIMAL(18,2)),29,N'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=900&q=85',102),
        (N'JBL Go 3',N'Loa',N'JBL',CAST(890000 AS DECIMAL(18,2)),54,N'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=900&q=85',109),
        (N'Samsung T7 Shield 1TB',N'Ổ cứng',N'Samsung',CAST(2290000 AS DECIMAL(18,2)),24,N'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=900&q=85',116),
        (N'Kingston XS1000 1TB',N'Ổ cứng',N'Kingston',CAST(1690000 AS DECIMAL(18,2)),35,N'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&w=900&q=85',123)
    ) v(productName,categoryName,brandName,price,stockQuantity,imageUrl,daysAgo)
    JOIN dbo.Categories c ON c.categoryName=v.categoryName
    JOIN dbo.Brands b ON b.brandName=v.brandName;

    IF (SELECT COUNT_BIG(*) FROM dbo.Products) <> 40
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
