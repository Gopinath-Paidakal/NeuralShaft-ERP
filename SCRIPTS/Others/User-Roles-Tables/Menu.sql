CREATE TABLE Menu
(
    MenuId              INT IDENTITY(1,1) PRIMARY KEY,

    ParentMenuId        INT NULL,

    MenuName            NVARCHAR(200),
    MenuCode            NVARCHAR(100),

    MenuUrl             NVARCHAR(500),
    MenuIcon            NVARCHAR(100),

    MenuOrder           INT,

    IsVisible           BIT DEFAULT 1,
    IsActive            BIT DEFAULT 1,

    CreatedUserId       INT,
    CreatedDate         DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Menu_Parent
        FOREIGN KEY (ParentMenuId)
        REFERENCES Menu(MenuId)
);