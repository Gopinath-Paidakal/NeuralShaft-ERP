SELECT *
FROM
(
    SELECT DISTINCT
    
        m.MenuId,
        m.ParentMenuId,
        m.MenuName,
        m.MenuPath,
        m.SortOrder,

        rp.UserId,
        rp.CanView,
        rp.CanAdd,
        rp.CanEdit,
        rp.CanDelete,
        rp.CanApprove

    FROM Menus m

    LEFT JOIN MenuPermissions rp
        ON m.MenuId = rp.MenuId
        AND rp.UserId = 26

    WHERE

        EXISTS (
            SELECT 1
            FROM MenuPermissions mp
            WHERE mp.MenuId = m.MenuId
              AND mp.UserId = 26
        )

        OR

        m.MenuId IN (
            SELECT DISTINCT cm.ParentMenuId
            FROM Menus cm
            INNER JOIN MenuPermissions mp
                ON cm.MenuId = mp.MenuId
            WHERE mp.UserId = 26
              AND cm.ParentMenuId IS NOT NULL
        )
) x

--ORDER BY 
--    ISNULL(x.ParentMenuId, x.MenuId),
--    x.SortOrder;