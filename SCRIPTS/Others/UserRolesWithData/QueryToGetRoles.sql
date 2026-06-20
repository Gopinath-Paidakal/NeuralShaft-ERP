SELECT
    m.MenuId,
    m.ParentMenuId,
    m.MenuName,
    m.MenuPath,

    rp.RoleId,
    rp.CanView,
    rp.CanAdd,
    rp.CanEdit,
    rp.CanDelete,
    rp.CanApprove

FROM Menus m
LEFT JOIN RoleMenuPermissions rp
    ON m.MenuId = rp.MenuId
WHERE rp.RoleId = 2
ORDER BY m.ParentMenuId, m.SortOrder;