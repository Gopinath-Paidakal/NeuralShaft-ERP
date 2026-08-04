--SELECT DISTINCT
--    ProductId,
--    ItemId,
--    ItemTotalQty
--FROM JobOrderBOM
--WHERE ProductId = 222
--ORDER BY ProductId, ItemId, ItemTotalQty;


--SELECT
--    ProductId,
--    ItemId,
--    SUM(ItemTotalQty) AS TotalQty
--FROM JobOrderBOM
--WHERE ProductId = 222
--GROUP BY
--    ProductId,
--    ItemId
--ORDER BY
--    ProductId,
--    ItemId;

    ------------------

--    SELECT
--    j.ProductId,
--    j.ItemId,
--    i.ItemName,
--    SUM(j.ItemTotalQty) AS TotalQty
--    --[StockBatch].BalanceQty
--FROM JobOrderBOM j
--INNER JOIN Item i ON j.ItemId = i.ItemId
----INNER JOIN StockBatch on StockBatch.ItemId = i.ItemId
--WHERE j.ProductId = 222
--GROUP BY
--    j.ProductId,
--    j.ItemId,
--    i.ItemName
--ORDER BY
--    j.ProductId,
--    j.ItemId,
--    i.ItemName;


--    -----------------------------------------
--;WITH BatchCTE AS
--(
--    SELECT
--        BatchId,
--        ItemId,
--        ROW_NUMBER() OVER
--        (
--            PARTITION BY ItemId
--            ORDER BY StocksInwardDate,
--                     StocksInwardHdrId,
--                     StocksInwardDtlId,
--                     BatchId
--        ) AS RN
--    FROM StockBatch
--)
--UPDATE C
--SET ParentBatchId = P.BatchId
--FROM BatchCTE C
--INNER JOIN BatchCTE P
--    ON C.ItemId = P.ItemId
--   AND C.RN = P.RN + 1
--INNER JOIN StockBatch SB
--    ON SB.BatchId = C.BatchId;

---------------
--;WITH BatchChain AS
--(
--    SELECT
--        BatchId,
--        ItemId,
--        LAG(BatchId) OVER
--        (
--            PARTITION BY ItemId
--            ORDER BY StocksInwardDate,
--                     StocksInwardHdrId,
--                     StocksInwardDtlId,
--                     BatchId
--        ) AS ParentBatchId
--    FROM StockBatch
--)
--UPDATE SB
--SET ParentBatchId = BC.ParentBatchId
--FROM StockBatch SB
--INNER JOIN BatchChain BC
--    ON SB.BatchId = BC.BatchId;


--    SELECT *
--FROM StockBatch
--WHERE ItemId = @ItemId
--  AND BalanceQty > 0
--ORDER BY StocksInwardDate DESC, BatchId DESC;   -- LIFO


--SELECT
--    j.ProductId,
--    j.ItemId,
--    i.ItemName,
--    SUM(j.ItemTotalQty) AS TotalQty,
--    sb.BatchNo,
--    sb.BatchId,
--    sb.BalanceQty,
--    sb.PurchaseRate
--FROM JobOrderBOM j
--INNER JOIN Item i
--    ON j.ItemId = i.ItemId
--INNER JOIN StockBatch sb
--    ON sb.ItemId = j.ItemId
--WHERE j.ProductId = 222
--GROUP BY
--    j.ProductId,
--    j.ItemId,
--    i.ItemName,
--    sb.BatchId,
--    sb.BatchNo,
--    sb.BalanceQty,
--    sb.PurchaseRate
--ORDER BY
--    j.ItemId,
--    sb.BatchId;

    -------------------------------
    ;WITH BOM AS
(
    SELECT
        j.ProductId,
        j.ItemId,
        i.ItemName,
        SUM(j.ItemTotalQty) AS RequiredQty
    FROM JobOrderBOM j
    INNER JOIN Item i
        ON i.ItemId = j.ItemId
    WHERE j.ProductId = 222
    GROUP BY
        j.ProductId,
        j.ItemId,
        i.ItemName
)
SELECT
    b.ProductId,
    b.ItemId,
    b.ItemName,
    b.RequiredQty,
    sb.BatchId,
    sb.BatchNo,
    sb.BalanceQty,
    sb.PurchaseRate
FROM BOM b
LEFT JOIN StockBatch sb
    ON sb.ItemId = b.ItemId
   AND sb.BalanceQty > 0
ORDER BY
    b.ItemId,
    sb.StocksInwardDate,
    sb.BatchId;

    ---------------------------------------------
--    DECLARE @IssueQty DECIMAL(18,2) = 224;

--;WITH Batches AS
--(
--    SELECT
--        BatchId,
--        BatchNo,
--        BalanceQty,
--        SUM(BalanceQty) OVER
--        (
--            ORDER BY StocksInwardDate, BatchId
--        ) AS RunningQty
--    FROM StockBatch
--    WHERE ItemId = 74
--      AND BalanceQty > 0
--)
--SELECT
--    BatchId,
--    BatchNo,
--    BalanceQty,

--    CASE
--        WHEN RunningQty - BalanceQty >= @IssueQty
--            THEN 0

--        WHEN RunningQty >= @IssueQty
--            THEN @IssueQty - (RunningQty - BalanceQty)

--        ELSE BalanceQty
--    END AS IssueQty,

--    BalanceQty -
--    CASE
--        WHEN RunningQty - BalanceQty >= @IssueQty
--            THEN 0

--        WHEN RunningQty >= @IssueQty
--            THEN @IssueQty - (RunningQty - BalanceQty)

--        ELSE BalanceQty
--    END AS RemainingBatchQty
--FROM Batches;


-------------------------------------------
DECLARE @RequiredQty DECIMAL(18,2) = 224;

;WITH BatchCTE AS
(
    SELECT
        BatchId,
        BatchNo,
        BalanceQty,
        SUM(BalanceQty) OVER
        (
            ORDER BY StocksInwardDate, BatchId
        ) AS RunningQty
    FROM StockBatch
    WHERE ItemId = 76
      AND BalanceQty > 0
)
SELECT
    BatchId,
    BatchNo,
    BalanceQty,
    IssueQty =
    CASE
        WHEN RunningQty <= @RequiredQty
            THEN BalanceQty
        WHEN RunningQty - BalanceQty < @RequiredQty
            THEN @RequiredQty - (RunningQty - BalanceQty)
        ELSE 0
    END,
    RemainingQty =
    BalanceQty -
    CASE
        WHEN RunningQty <= @RequiredQty
            THEN BalanceQty
        WHEN RunningQty - BalanceQty < @RequiredQty
            THEN @RequiredQty - (RunningQty - BalanceQty)
        ELSE 0
    END
FROM BatchCTE
--ORDER BY BatchId DESC;


---=======================================
DECLARE @ItemId INT = 76;
DECLARE @RequiredQty DECIMAL(18,2) = 650;

;WITH BatchCTE AS
(
    SELECT
        BatchId,
        BatchNo,
        ItemId,
        BalanceQty,
        PurchaseRate,
        StocksInwardDate,

        SUM(BalanceQty) OVER
        (
            ORDER BY StocksInwardDate DESC, BatchId DESC
        ) AS RunningQty
    FROM StockBatch
    WHERE ItemId=@ItemId
      AND BalanceQty>0
)
SELECT
    BatchId,
    BatchNo,
    BalanceQty,

    AllocateQty =
    CASE
        WHEN RunningQty <= @RequiredQty
            THEN BalanceQty

        WHEN RunningQty - BalanceQty < @RequiredQty
            THEN @RequiredQty - (RunningQty - BalanceQty)

        ELSE 0
    END,

    NewBalance =
    BalanceQty -
    CASE
        WHEN RunningQty <= @RequiredQty
            THEN BalanceQty

        WHEN RunningQty - BalanceQty < @RequiredQty
            THEN @RequiredQty - (RunningQty - BalanceQty)

        ELSE 0
    END,

    PurchaseRate,
    Amount =
    PurchaseRate *
    CASE
        WHEN RunningQty <= @RequiredQty
            THEN BalanceQty

        WHEN RunningQty - BalanceQty < @RequiredQty
            THEN @RequiredQty - (RunningQty - BalanceQty)

        ELSE 0
    END

FROM BatchCTE
WHERE
CASE
    WHEN RunningQty <= @RequiredQty
        THEN BalanceQty

    WHEN RunningQty - BalanceQty < @RequiredQty
        THEN @RequiredQty - (RunningQty - BalanceQty)

    ELSE 0
END > 0;