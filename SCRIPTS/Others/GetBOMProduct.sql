WITH BOM_CTE AS (
    -- Level 1 (Top Parent)
    SELECT 
        ParentProdId,
        ChildProdId,
        ProdQty,
        --CAST(ProdQty AS DECIMAL(18,4)) AS TotalQty,
        1 AS Level
    FROM BOMProduct
    WHERE ParentProdId = 2  -- Car

    UNION ALL

    -- Recursive part
    SELECT 
        b.ParentProdId,
        b.ChildProdId,
        b.ProdQty,
        --cte.TotalQty * b.ProdQty AS TotalQty,
        cte.Level + 1
    FROM BOMProduct b
    INNER JOIN BOM_CTE cte 
        ON b.ParentProdId = cte.ChildProdId
)

SELECT 
    Level,
    p.ProdId,
    p.ProdName AS Parent,
    c.ProdName AS Child,
    ProdQty,
    c.ProdSellingPrice,
    (ProdQty * c.ProdSellingPrice) as [TotalAmount]
    --SUM(ProdQty * c.ProdSellingPrice) as 'ProductAmount'

FROM BOM_CTE 
JOIN Product p ON p.ProdId = BOM_CTE.ParentProdId
JOIN Product c ON c.ProdId = BOM_CTE.ChildProdId
--group by p.ProdId
order by p.ProdId


--=================================













--SELECT 
--    Level,
--    p.ProdId,
--    p.ProdName AS Parent,
--    c.ProdName AS Child,
--    cte.ProdQty,
--    cte.TotalQty,  -- 🔥 important
--    c.ProdSellingPrice,
--    (cte.TotalQty * c.ProdSellingPrice) AS TotalAmount
--FROM BOM_CTE cte
--JOIN Product p ON p.ProdId = cte.ParentProdId
--JOIN Product c ON c.ProdId = cte.ChildProdId
--ORDER BY Level;




