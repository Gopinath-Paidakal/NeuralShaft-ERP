CREATE TABLE RoleMenuPermissions
(
    RoleMenuId          INT IDENTITY(1,1) PRIMARY KEY,

    RoleId              INT,
    MenuId              INT,

    CanView             BIT DEFAULT 0,
    CanAdd              BIT DEFAULT 0,
    CanEdit             BIT DEFAULT 0,
    CanDelete           BIT DEFAULT 0,
    CanApprove          BIT DEFAULT 0,
    CanExport           BIT DEFAULT 0,

    CreatedUserId       INT,
    CreatedDate         DATETIME DEFAULT GETDATE(),

    --CONSTRAINT FK_RoleMenu_Role
    --    FOREIGN KEY (RoleId)
    --    REFERENCES Roles(RoleId),

    --CONSTRAINT FK_RoleMenu_Menu
    --    FOREIGN KEY (MenuId)
    --    REFERENCES Menu(MenuId)
);