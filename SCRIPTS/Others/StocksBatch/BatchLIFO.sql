CREATE TABLE StockBatch
(
    BatchId              INT IDENTITY(1,1) PRIMARY KEY,

    CompanyId            INT NOT NULL,
    BranchId             INT NOT NULL,

    WareHouseId          INT NOT NULL,

    ItemId               INT NOT NULL,

    BatchNo              VARCHAR(50) NOT NULL,
    LotNo                VARCHAR(50) NULL,

    ManufactureDate      DATE NULL,
    ExpiryDate           DATE NULL,

    PurchaseDtlId        INT NOT NULL,

    PurchaseQty          DECIMAL(18,3) NOT NULL,

    BalanceQty           DECIMAL(18,3) NOT NULL,

    PurchaseRate         DECIMAL(18,2) NOT NULL,

    BatchStatus          VARCHAR(20) DEFAULT 'Open',

    CreatedUserId        INT,
    CreatedDate          DATETIME DEFAULT GETDATE(),

    ModifiedUserId       INT NULL,
    ModifiedDate         DATETIME NULL
);

CREATE TABLE StockPurchaseDtl
(
    StockPurchaseDtlId   INT IDENTITY(1,1) PRIMARY KEY,

    StockPurchaseHdrId   INT NOT NULL,

    ItemId               INT NOT NULL,

    PurchaseQty          DECIMAL(18,3) NOT NULL,

    PurchaseRate         DECIMAL(18,2) NOT NULL,

    Amount               DECIMAL(18,2) NOT NULL,

    BatchId              INT NULL,

    Remarks              NVARCHAR(250) NULL
);

CREATE TABLE StockIssueHdr
(
    StockIssueHdrId      INT IDENTITY(1,1) PRIMARY KEY,

    CompanyId            INT NOT NULL,
    BranchId             INT NOT NULL,
    WareHouseId          INT NOT NULL,

    StockIssueNo         VARCHAR(30) NOT NULL,
    StockIssueSLNo       VARCHAR(30) NOT NULL,

    StockIssueDate       DATE NOT NULL,

    IssueType            VARCHAR(30),

    Remarks              NVARCHAR(500),

    TotalAmount          DECIMAL(18,2) DEFAULT 0,

    CreatedUserId        INT,
    CreatedDate          DATETIME DEFAULT GETDATE(),

    ModifiedUserId       INT NULL,
    ModifiedDate         DATETIME NULL
);


CREATE TABLE StockIssueDtl
(
    StockIssueDtlId      INT IDENTITY(1,1) PRIMARY KEY,

    StockIssueHdrId      INT NOT NULL,

    ItemId               INT NOT NULL,

    BatchId              INT NOT NULL,

    StockPurchaseDtlId   INT NOT NULL,

    IssueQty             DECIMAL(18,3) NOT NULL,

    PurchaseRate         DECIMAL(18,2) NOT NULL,

    Amount               DECIMAL(18,2) NOT NULL,

    FOREIGN KEY (StockIssueHdrId)
        REFERENCES StockIssueHdr(StockIssueHdrId),

    FOREIGN KEY (BatchId)
        REFERENCES StockBatch(BatchId),

    FOREIGN KEY (StockPurchaseDtlId)
        REFERENCES StockPurchaseDtl(StockPurchaseDtlId)
);

--1. Current Stock Status (Warehouse-wise)

SELECT
    SB.CompanyId,
    SB.BranchId,
    SB.WareHouseId,
    SB.ItemId,

    SUM(SB.BalanceQty) AS StockQty,
    SUM(SB.BalanceQty * SB.PurchaseRate) AS StockValue

FROM StockBatch SB
WHERE SB.BalanceQty > 0
GROUP BY
    SB.CompanyId,
    SB.BranchId,
    SB.WareHouseId,
    SB.ItemId
ORDER BY
    SB.ItemId;

---======================================================

---2. Batch-wise Stock Status
SELECT
    SB.BatchId,
    SB.BatchNo,
    SB.ItemId,
    SB.PurchaseRate,
    --SB.PurchaseQty,
    SB.BalanceQty
    --SB.PurchaseQty - SB.BalanceQty AS IssuedQty
    --SB.ManufactureDate,
    --SB.ExpiryDate
FROM StockBatch SB
WHERE SB.BalanceQty > 0
ORDER BY
    SB.ItemId,
    SB.BatchId;

---======================================================

-- 3. FIFO Stock Status
SELECT
    BatchId,
    BatchNo,
    ItemId,
    BalanceQty,
    PurchaseRate
FROM StockBatch
WHERE BalanceQty > 0
ORDER BY
    ItemId,
    BatchId DESC;

---======================================================


--- 4. LIFO Stock Status

    SELECT
    BatchId,
    BatchNo,
    ItemId,
    BalanceQty,
    PurchaseRate
FROM StockBatch
WHERE BalanceQty > 0
ORDER BY
    ItemId,
    BatchId DESC;

---======================================================

---   5. FIFO Stock Status
    SELECT
    BatchId,
    BatchNo,
    ItemId,
    BalanceQty,
    PurchaseRate
FROM StockBatch
WHERE BalanceQty > 0
ORDER BY
    ItemId,
    BatchId;

---======================================================

---  6. Stock Ledger

--    SELECT
--    P.StockPurchaseDtlId,
--    P.ItemId,
--    B.BatchNo,
--    P.PurchaseQty,
--    B.BalanceQty,
--    P.PurchaseRate,
--    P.PurchaseQty * P.PurchaseRate AS PurchaseValue,
--    B.BalanceQty * P.PurchaseRate AS BalanceValue
--FROM StockPurchaseDtl P
--INNER JOIN StockBatch B
--    ON P.StockPurchaseDtlId = B.PurchaseDtlId
--ORDER BY
--    P.ItemId,
--    P.StockPurchaseDtlId;

---======================================================

 ----   7.Complete Stock Status (Recommended ERP Report)

    SELECT
    I.ItemCode,
    I.ItemName,

    W.WareHouseName,

    SUM(B.BalanceQty) AS StockQty,

    AVG(B.PurchaseRate) AS AvgRate,

    SUM(B.BalanceQty * B.PurchaseRate) AS StockValue,

    COUNT(B.BatchId) AS NoOfBatches

FROM StockBatch B

INNER JOIN Item I
ON I.ItemId = B.ItemId

INNER JOIN WareHouse W
ON W.WareHouseId = B.WareHouseId

WHERE B.BalanceQty > 0

GROUP BY
    I.ItemCode,
    I.ItemName,
    W.WareHouseName

ORDER BY
    I.ItemName;

---======================================================


--========================================================
--- With 2 tables 
--========================================================

-- 1. StockTrn (All Inventory Movements)

StockTrn
--------
StockTrnId (PK)

CompId
BranchId
WareHouseId

TrnType          -- Inward, Issue, TransferIn, TransferOut, Adjustment+, Adjustment-

RefHdrId
RefDtlId

BatchId

ItemId

TrnDate

RecdQty
IssuedQty
BalanceQty        -- Running balance after this transaction (optional)

PurchaseRate
IssueRate

Amount

CreatedDate
CreatedUserId

---======================================================

--- 2. StockBatch (Current Batch Status)
StockBatch
----------
BatchId (PK)

ItemId

WareHouseId

BatchNo

PurchaseRate

ReceivedQty

BalanceQty

PurchaseDate

ExpiryDate

Status

---======================================================

1. Current Stock

SELECT
    ItemId,
    WareHouseId,
    SUM(BalanceQty) StockQty,
    SUM(BalanceQty * PurchaseRate) StockValue
FROM StockBatch
GROUP BY
    ItemId,
    WareHouseId;
---======================================================

-- LIFO Query
SELECT *
FROM StockBatch
WHERE ItemId = 234
AND WareHouseId = 1
AND BalanceQty > 0
ORDER BY StocksInwardDate DESC,
         BatchId DESC;

----- FIFO is simply:
ORDER BY PurchaseDate,
         BatchId;

---======================================================
CREATE TABLE dbo.StockBatch
(
    BatchId             INT IDENTITY(1,1) PRIMARY KEY,

    CompanyId              INT             NOT NULL,
    BranchId            INT             NOT NULL,
    WareHouseId         INT             NOT NULL,

    ItemId              INT             NOT NULL,

    BatchNo             VARCHAR(50)     NOT NULL,
    LotNo               VARCHAR(50)     NULL,

    PurchaseHdrId       INT             NULL,
    PurchaseDtlId       INT             NULL,

    PurchaseDate        DATE            NOT NULL,

    ---ManufactureDate     DATE            NULL,
    ---ExpiryDate          DATE            NULL,

    ReceivedQty         DECIMAL(18,3)   NOT NULL,
    BalanceQty          DECIMAL(18,3)   NOT NULL,

    PurchaseRate        DECIMAL(18,2)   NOT NULL,

    BatchStatus         VARCHAR(20)     NOT NULL DEFAULT 'Open',

    CreatedUserId       INT             NULL,
    CreatedDate         DATETIME        NOT NULL DEFAULT(GETDATE()),

    ModifiedUserId      INT             NULL,
    ModifiedDate        DATETIME        NULL
);

CREATE TABLE dbo.StockTrn
(
    StockTrnId          INT IDENTITY(1,1) PRIMARY KEY,

    CompanyId              INT             NOT NULL,
    BranchId            INT             NOT NULL,

    WareHouseId         INT             NOT NULL,

    TrnDate             DATETIME        NOT NULL DEFAULT(GETDATE()),

    TrnType             VARCHAR(30)     NOT NULL,
    -- Purchase
    -- Issue
    -- TransferIn
    -- TransferOut
    -- PurchaseReturn
    -- SalesReturn
    -- AdjustmentPlus
    -- AdjustmentMinus

    RefType             VARCHAR(30)     NOT NULL,
    -- Purchase
    -- Sales
    -- Transfer
    -- Adjustment
    -- Production

    RefHdrId            INT             NULL,
    RefDtlId            INT             NULL,

    BatchId             INT             NOT NULL,

    ItemId              INT             NOT NULL,

    RecdQty             DECIMAL(18,3)   NOT NULL DEFAULT(0),

    IssuedQty           DECIMAL(18,3)   NOT NULL DEFAULT(0),

    BalanceQty          DECIMAL(18,3)   NOT NULL,

    PurchaseRate        DECIMAL(18,2)   NOT NULL,

    IssueRate           DECIMAL(18,2)   NULL,

    Amount              DECIMAL(18,2)   NOT NULL,

    Remarks             NVARCHAR(250)   NULL,

    CreatedUserId       INT             NULL,
    CreatedDate         DATETIME        NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_StockTrn_Batch
        FOREIGN KEY(BatchId)
        REFERENCES StockBatch(BatchId)
);








