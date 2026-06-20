CREATE TABLE EmpRoles
(
    RoleId              INT IDENTITY(1,1) PRIMARY KEY,
    RoleCode            NVARCHAR(50),
    RoleName            NVARCHAR(200),
    RoleDesc            NVARCHAR(500),

    RoleStatus          BIT DEFAULT 1,

    CreatedUserId       INT,
    CreatedDate         DATETIME DEFAULT GETDATE(),
    ModifiedUserId      INT,
    ModifiedDate        DATETIME
);