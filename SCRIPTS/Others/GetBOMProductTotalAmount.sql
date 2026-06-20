WITH BOM_CTE_1 AS (
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
    INNER JOIN BOM_CTE_1 cte 
        ON b.ParentProdId = cte.ChildProdId
)

SELECT 
    SUM(cte.ProdQty * p.ProdSellingPrice) AS FinalProductCost
FROM BOM_CTE_1 cte
JOIN Product p 
    ON p.ProdId = cte.ChildProdId;