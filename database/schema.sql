-- TechGear: run once against an existing empty SQL Server database.

-- DDL only: no database creation, seed data or default accounts.

SET XACT_ABORT ON;
BEGIN TRANSACTION;

CREATE TABLE dbo.Roles (
    roleId INT IDENTITY(1,1) PRIMARY KEY,
    roleName NVARCHAR(20) NOT NULL UNIQUE CHECK (roleName IN (N'ADMIN', N'CUSTOMER'))
);

CREATE TABLE dbo.Users (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    roleId INT NOT NULL REFERENCES dbo.Roles(roleId),
    fullName NVARCHAR(100) NOT NULL,
    email NVARCHAR(254) NOT NULL UNIQUE,
    passwordHash NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) NULL,
    address NVARCHAR(500) NULL,
    active BIT NOT NULL DEFAULT 1,
    createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.Categories (
    categoryId INT IDENTITY(1,1) PRIMARY KEY,
    categoryName NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(1000) NULL
);

CREATE TABLE dbo.Brands (
    brandId INT IDENTITY(1,1) PRIMARY KEY,
    brandName NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(1000) NULL
);

CREATE TABLE dbo.Products (
    productId INT IDENTITY(1,1) PRIMARY KEY,
    categoryId INT NOT NULL REFERENCES dbo.Categories(categoryId),
    brandId INT NOT NULL REFERENCES dbo.Brands(brandId),
    productName NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NULL,
    price DECIMAL(18,2) NOT NULL CHECK (price >= 0),
    stockQuantity INT NOT NULL CHECK (stockQuantity >= 0),
    active BIT NOT NULL DEFAULT 1,
    createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.ProductImages (
    imageId INT IDENTITY(1,1) PRIMARY KEY,
    productId INT NOT NULL REFERENCES dbo.Products(productId),
    imageUrl NVARCHAR(500) NOT NULL,
    primaryImage BIT NOT NULL DEFAULT 0
);

CREATE TABLE dbo.Orders (
    orderId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL REFERENCES dbo.Users(userId),
    recipientName NVARCHAR(100) NOT NULL,
    shippingAddress NVARCHAR(500) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    totalAmount DECIMAL(18,2) NOT NULL CHECK (totalAmount >= 0),
    status NVARCHAR(20) NOT NULL DEFAULT N'PENDING' CHECK (status IN (N'PENDING', N'CONFIRMED', N'SHIPPING', N'DELIVERED', N'CANCELLED')),
    paymentMethod NVARCHAR(50) NOT NULL,
    createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.OrderDetails (
    orderDetailId INT IDENTITY(1,1) PRIMARY KEY,
    orderId INT NOT NULL REFERENCES dbo.Orders(orderId),
    productId INT NOT NULL REFERENCES dbo.Products(productId),
    quantity INT NOT NULL CHECK (quantity > 0),
    unitPrice DECIMAL(18,2) NOT NULL CHECK (unitPrice >= 0),
    CONSTRAINT UQ_OrderDetails UNIQUE (orderId, productId)
);

CREATE TABLE dbo.CartItems (
    cartItemId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL REFERENCES dbo.Users(userId),
    productId INT NOT NULL REFERENCES dbo.Products(productId),
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT UQ_CartItems UNIQUE (userId, productId)
);

CREATE TABLE dbo.Reviews (
    reviewId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL REFERENCES dbo.Users(userId),
    productId INT NOT NULL REFERENCES dbo.Products(productId),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(2000) NULL,
    createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Reviews UNIQUE (userId, productId)
);

CREATE TABLE dbo.PasswordResetTokens (
    tokenId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL REFERENCES dbo.Users(userId),
    tokenHash NVARCHAR(255) NOT NULL UNIQUE,
    expiresAt DATETIME2 NOT NULL,
    used BIT NOT NULL DEFAULT 0,
    createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_TokenExpiry CHECK (expiresAt > createdAt)
);

COMMIT TRANSACTION;
