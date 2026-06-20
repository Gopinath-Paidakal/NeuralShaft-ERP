INSERT INTO RoleMenuPermissions
(RoleId, MenuId, CanView, CanAdd, CanEdit, CanDelete, CanApprove)
SELECT
1,
MenuId,
1,1,1,1,1
FROM Menus;

INSERT INTO RoleMenuPermissions
(RoleId, MenuId, CanView, CanAdd, CanEdit, CanDelete, CanApprove)
VALUES

(2,1,1,0,0,0,0),

(2,2,1,1,1,1,0),
(2,3,1,1,1,1,0),
(2,4,1,1,1,1,0),
(2,5,1,1,1,1,0),

(2,6,1,1,1,1,1),
(2,7,1,1,1,1,1),
(2,8,1,1,1,1,1),
(2,9,1,1,1,1,1),

(2,13,1,0,0,0,0),
(2,14,1,0,0,0,0),
(2,15,1,0,0,0,0),

(2,16,1,1,1,1,0),
(2,17,1,1,1,1,0),
(2,18,1,1,1,1,0),
(2,19,1,1,1,1,0);


INSERT INTO RoleMenuPermissions
(RoleId, MenuId, CanView, CanAdd, CanEdit, CanDelete, CanApprove)
VALUES

(3,1,1,0,0,0,0),

(3,6,1,1,1,0,1),
(3,7,1,1,1,0,1),
(3,8,1,1,1,0,1),
(3,9,1,1,1,0,1),

(3,13,1,0,0,0,0),
(3,14,1,0,0,0,0);

INSERT INTO RoleMenuPermissions
(RoleId, MenuId, CanView, CanAdd, CanEdit, CanDelete, CanApprove)
VALUES

(4,1,1,0,0,0,0),

(4,6,1,0,0,0,0),
(4,7,1,1,0,0,0),
(4,8,1,0,0,0,0),

(4,13,1,0,0,0,0),
(4,14,1,0,0,0,0);


INSERT INTO RoleMenuPermissions
(RoleId, MenuId, CanView, CanAdd, CanEdit, CanDelete, CanApprove)
VALUES

(5,1,1,0,0,0,0);
