CREATE OR ALTER PROCEDURE dbo.SP_AllocateStock
(
      @CompanyId              INT,
      @BranchId               INT,
      @WareHouseId            INT = NULL,              -- NULL = Search All Warehouses
      @ItemId                 INT,
      @IssueQty               DECIMAL(18,3),

      @IssueMethod            VARCHAR(10)='LIFO',      -- FIFO / LIFO

      @RefType                VARCHAR(30),            -- DC / SI / Transfer / Adjustment
      @RefHdrId               INT,
      @RefDtlId               INT,

      @AllowMultiWarehouse    BIT = 0,
      @AllowNegativeStock     BIT = 0,

      @IssueRate              DECIMAL(18,2)=0,

      @Remarks                NVARCHAR(250)=NULL,

      @CreatedUserId          INT
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

BEGIN TRANSACTION;

--------------------------------------------------------
-- Variables
--------------------------------------------------------

DECLARE @AvailableQty       DECIMAL(18,3)=0
DECLARE @RemainingQty       DECIMAL(18,3)

DECLARE @BatchId            INT
DECLARE @CurrentWH          INT
DECLARE @BatchQty           DECIMAL(18,3)
DECLARE @PurchaseRate       DECIMAL(18,2)

DECLARE @IssueFromBatch     DECIMAL(18,3)

DECLARE @RowNo              INT=1
DECLARE @TotalRows          INT

SET @RemainingQty=@IssueQty

--------------------------------------------------------
-- Validation
--------------------------------------------------------

IF @IssueQty<=0
BEGIN
    THROW 50001,'Issue Qty should be greater than zero.',1;
END

--------------------------------------------------------
-- Temporary Batch List
--------------------------------------------------------

DECLARE @Batch TABLE
(
      RowNo           INT IDENTITY(1,1),

      BatchId         INT,

      WareHouseId     INT,

      ItemId          INT,

      BalanceQty      DECIMAL(18,3),

      PurchaseRate    DECIMAL(18,2),

      StocksInwardDate DATE
)

--------------------------------------------------------
-- Load Batches
--------------------------------------------------------

IF @AllowMultiWarehouse=0
BEGIN

    IF @IssueMethod='FIFO'
    BEGIN

        INSERT INTO @Batch
        (
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        )

        SELECT
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        FROM StockBatch
        WHERE CompanyId=@CompanyId
        AND BranchId=@BranchId
        AND WareHouseId=@WareHouseId
        AND ItemId=@ItemId
        AND BalanceQty>0
        ORDER BY StocksInwardDate,
                 BatchId;

    END
    ELSE
    BEGIN

        INSERT INTO @Batch
        (
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        )

        SELECT
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        FROM StockBatch
        WHERE CompanyId=@CompanyId
        AND BranchId=@BranchId
        AND WareHouseId=@WareHouseId
        AND ItemId=@ItemId
        AND BalanceQty>0
        ORDER BY StocksInwardDate DESC,
                 BatchId DESC;

    END

END
ELSE
BEGIN

    IF @IssueMethod='FIFO'
    BEGIN

        INSERT INTO @Batch
        (
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        )

        SELECT
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        FROM StockBatch
        WHERE CompanyId=@CompanyId
        AND BranchId=@BranchId
        AND ItemId=@ItemId
        AND BalanceQty>0
        ORDER BY StocksInwardDate,
                 BatchId;

    END
    ELSE
    BEGIN

        INSERT INTO @Batch
        (
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        )

        SELECT
            BatchId,
            WareHouseId,
            ItemId,
            BalanceQty,
            PurchaseRate,
            StocksInwardDate
        FROM StockBatch
        WHERE CompanyId=@CompanyId
        AND BranchId=@BranchId
        AND ItemId=@ItemId
        AND BalanceQty>0
        ORDER BY StocksInwardDate DESC,
                 BatchId DESC;

    END

END

--------------------------------------------------------
-- Available Qty
--------------------------------------------------------

SELECT
    @AvailableQty=SUM(BalanceQty)
FROM @Batch

IF ISNULL(@AvailableQty,0)=0
BEGIN
    THROW 50002,'Stock not available.',1;
END

IF @AllowNegativeStock=0
BEGIN

    IF @AvailableQty<@IssueQty
    BEGIN
        THROW 50003,'Insufficient Stock.',1;
    END

END

--------------------------------------------------------
-- Allocation Table
--------------------------------------------------------

DECLARE @Allocation TABLE
(
      RowNo           INT IDENTITY(1,1),

      BatchId         INT,

      WareHouseId     INT,

      ItemId          INT,

      IssueQty        DECIMAL(18,3),

      PurchaseRate    DECIMAL(18,2),

      Amount          DECIMAL(18,2)
)

--------------------------------------------------------
-- Loop
--------------------------------------------------------

SELECT @TotalRows=COUNT(*)
FROM @Batch

WHILE @RemainingQty>0
AND @RowNo<=@TotalRows
BEGIN

    SELECT

        @BatchId=BatchId,

        @CurrentWH=WareHouseId,

        @BatchQty=BalanceQty,

        @PurchaseRate=PurchaseRate

    FROM @Batch
    WHERE RowNo=@RowNo

    SET @IssueFromBatch=
    CASE
        WHEN @RemainingQty<=@BatchQty
        THEN @RemainingQty
        ELSE @BatchQty
    END

    --------------------------------------
    -- Allocation
    --------------------------------------

    INSERT INTO @Allocation
    (
        BatchId,
        WareHouseId,
        ItemId,
        IssueQty,
        PurchaseRate,
        Amount
    )
    VALUES
    (
        @BatchId,
        @CurrentWH,
        @ItemId,
        @IssueFromBatch,
        @PurchaseRate,
        @IssueFromBatch*@PurchaseRate
    )

    --------------------------------------
    -- Update Batch
    --------------------------------------

    UPDATE StockBatch
    SET
        BalanceQty=BalanceQty-@IssueFromBatch,

        ModifiedUserId=@CreatedUserId,

        ModifiedDate=GETDATE()

    WHERE BatchId=@BatchId

    --------------------------------------
    -- Stock Transaction
    --------------------------------------

    INSERT INTO StockTrn
    (
        CompanyId,
        BranchId,
        WareHouseId,

        TrnDate,

        TrnType,

        RefType,

        RefHdrId,

        RefDtlId,

        BatchId,

        ItemId,

        RecdQty,

        IssuedQty,

        BalanceQty,

        PurchaseRate,

        IssueRate,

        Amount,

        Remarks,

        CreatedUserId,

        CreatedDate
    )

    VALUES
    (
        @CompanyId,

        @BranchId,

        @CurrentWH,

        GETDATE(),

        'Issue',

        @RefType,

        @RefHdrId,

        @RefDtlId,

        @BatchId,

        @ItemId,

        0,

        @IssueFromBatch,

        @BatchQty-@IssueFromBatch,

        @PurchaseRate,

        @IssueRate,

        @IssueFromBatch*@PurchaseRate,

        @Remarks,

        @CreatedUserId,

        GETDATE()
    )

    SET @RemainingQty=@RemainingQty-@IssueFromBatch

    SET @RowNo=@RowNo+1

END

--------------------------------------------------------
-- Result
--------------------------------------------------------

SELECT
    *
FROM @Allocation

COMMIT TRANSACTION

END TRY

BEGIN CATCH

    IF @@TRANCOUNT>0
        ROLLBACK TRANSACTION

    DECLARE @ErrMsg NVARCHAR(MAX)
    DECLARE @ErrNo INT

    SELECT
        @ErrMsg=ERROR_MESSAGE(),
        @ErrNo=ERROR_NUMBER()

    RAISERROR(@ErrMsg,16,1)

END CATCH

END
GO