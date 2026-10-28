-- Local demo data for the cart and COD checkout. Run in database TechGear.
-- Safe to run again: existing rows are reused, and stock is not reset.
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE roleName = N'CUSTOMER')
    INSERT INTO dbo.Roles (roleName) VALUES (N'CUSTOMER');

IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE categoryName = N'Bàn phím')
    INSERT INTO dbo.Categories (categoryName) VALUES (N'Bàn phím');

IF NOT EXISTS (SELECT 1 FROM dbo.Brands WHERE brandName = N'Razer')
    INSERT INTO dbo.Brands (brandName) VALUES (N'Razer');

DECLARE @categoryId INT = (SELECT categoryId FROM dbo.Categories WHERE categoryName = N'Bàn phím');
DECLARE @brandId INT = (SELECT brandId FROM dbo.Brands WHERE brandName = N'Razer');
DECLARE @productId INT = (
    SELECT TOP 1 productId FROM dbo.Products
    WHERE productName = N'Razer Huntsman V3 Pro' AND brandId = @brandId
    ORDER BY productId
);

IF @productId IS NULL
BEGIN
    INSERT INTO dbo.Products (categoryId, brandId, productName, description, price, stockQuantity, active)
    VALUES (@categoryId, @brandId, N'Razer Huntsman V3 Pro', N'Bàn phím mẫu để thử giỏ hàng và COD.', 5990000, 99, 1);
    SET @productId = SCOPE_IDENTITY();
END;

IF NOT EXISTS (SELECT 1 FROM dbo.ProductImages WHERE productId = @productId)
    INSERT INTO dbo.ProductImages (productId, imageUrl, primaryImage)
    VALUES (@productId, N'/assets/images/razerhuntsmanv3pro.jpg', 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = N'demo.checkout@techgear.local')
    INSERT INTO dbo.Users (roleId, fullName, email, passwordHash, phone, address, active)
    VALUES ((SELECT roleId FROM dbo.Roles WHERE roleName = N'CUSTOMER'),
            N'Khách thử nghiệm', N'demo.checkout@techgear.local', N'!DEMO_LOGIN_ONLY!',
            N'0900000000', N'Địa chỉ giao hàng thử', 1);

COMMIT TRANSACTION;

SELECT productId, productName, price, stockQuantity FROM dbo.Products WHERE productId = @productId;
SELECT userId, fullName, email FROM dbo.Users WHERE email = N'demo.checkout@techgear.local';
