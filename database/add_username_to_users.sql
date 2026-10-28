USE TechGear;
GO

IF COL_LENGTH('dbo.Users', 'username') IS NULL
BEGIN
    ALTER TABLE dbo.Users
    ADD username NVARCHAR(30) NULL;
END;
GO

IF COL_LENGTH('dbo.Users', 'username') IS NOT NULL
BEGIN
    UPDATE dbo.Users
    SET username = LEFT(
        REPLACE(REPLACE(email, '@', '_'), '.', '_'),
        30
    )
    WHERE username IS NULL;
END;
GO

IF COL_LENGTH('dbo.Users', 'username') IS NOT NULL
BEGIN
    UPDATE dbo.Users
    SET username = CONCAT('user_', userId)
    WHERE username IS NULL
       OR LTRIM(RTRIM(username)) = '';
END;
GO

IF COL_LENGTH('dbo.Users', 'username') IS NOT NULL
BEGIN
    ALTER TABLE dbo.Users
    ALTER COLUMN username NVARCHAR(30) NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE name = N'UQ_Users_username'
)
BEGIN
    ALTER TABLE dbo.Users
    ADD CONSTRAINT UQ_Users_username UNIQUE (username);
END;
GO

IF EXISTS (
    SELECT 1
    FROM dbo.Users
    WHERE email = N'demo.checkout@techgear.local'
)
BEGIN
    UPDATE dbo.Users
    SET username = N'democheckout'
    WHERE email = N'demo.checkout@techgear.local';
END;
GO

SELECT userId, username, email
FROM dbo.Users;
GO