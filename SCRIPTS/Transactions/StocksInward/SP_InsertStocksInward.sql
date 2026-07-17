USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertStocksInward]    Script Date: 16/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertStocksInward]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertStocksInward]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertStocksInward]    Script Date: 16/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertStocksInward]
(
	@StocksInwardHdr NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @StocksInwardHdrId INT
    DECLARE @StocksInwardDtlId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @StockInwardNo int
	Declare @StockInwardSLNo nvarchar(50)
    Declare @Prefix nvarchar(50)


    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'StocksInward' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
 --   --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @StockInwardNo = max(StockInwardNo) from StocksInwardHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @StockInwardNo = 0 or @StockInwardNo is NULL
		set @StockInwardNo = 1
	else
		set @StockInwardNo = @StockInwardNo + 1

	set @StockInwardSLNo = @Prefix + RIGHT('0' + CAST(@StockInwardSLNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO dbo.StocksInwardHdr
        (
            CompanyId,
            BranchId,
            VendorHdrId,
            WareHouseId,
            EmpId,

            StockInwardType,
            StockInwardNo,
            StockInwardSLNo,
            StockInwardDate,
            
            InvoiceNo,
            InvoiceDate,
            
            DCNo,
            OrderNo,
            PONo,
            ESugamNo,

            TransportName,
            VehicleType,
            VehicleNo,

            ContactPerson,
            ContactMobile,
            ContactEmailId,

            CreditDate,

            SIProductAmount,
            SIDiscountPercentage,
            SIDiscountAmount,
            SITaxPercentage,
            ItemTotalAmount,

            SISubTotal,
            SITaxAmount,
            SIGrandTotal,

            CreatedUserId,
            CreatedDate
        )
        SELECT
            @CompanyId,
            @BranchId,
            VendorHdrId,
            WareHouseId,
            EmpId,

            StockInwardType,
            @StockInwardNo,
            @StockInwardSLNo,
            StockInwardDate,

            InvoiceNo,
            InvoiceDate,
            DCNo,
            OrderNo,
            PONo,
            ESugamNo,

            TransportName,
            VehicleType,
            VehicleNo,

            ContactPerson,
            ContactMobile,
            ContactEmailId,
            CreditDate,

            SIProductAmount,
            SIDiscountPercentage,
            SIDiscountAmount,
            SITaxPercentage,
            ItemTotalAmount,

            SISubTotal,
            SITaxAmount,
            SIGrandTotal,
            CreatedUserId,

            CreatedDate

        FROM OPENJSON(@StocksInwardHdr, '$.StocksInwardHdr')
        WITH
        (
            CompanyId INT,
            BranchId INT,
            VendorHdrId INT,
            WareHouseId INT,
            EmpId INT,

            StockInwardType NVARCHAR(50),
            --StockInwardNo NVARCHAR(50),
            --StockInwardSLNo INT,
            StockInwardDate DATE,
            
            InvoiceNo NVARCHAR(50),
            InvoiceDate DATE,
            DCNo NVARCHAR(50),
            OrderNo NVARCHAR(50),
            PONo NVARCHAR(50),
            ESugamNo NVARCHAR(50),
            
            TransportName NVARCHAR(100),
            VehicleType NVARCHAR(50),
            VehicleNo NVARCHAR(50),
            
            ContactPerson NVARCHAR(100),
            ContactMobile NVARCHAR(20),
            ContactEmailId NVARCHAR(100),
            CreditDate DATE,
            
            SIProductAmount DECIMAL(18,2),
            SIDiscountPercentage DECIMAL(18,2),
            SIDiscountAmount DECIMAL(18,2),
            SITaxPercentage DECIMAL(18,2),
            ItemTotalAmount DECIMAL(18,2),
            
            SISubTotal DECIMAL(18,2),
            SITaxAmount DECIMAL(18,2),
            SIGrandTotal DECIMAL(18,2),
            CreatedUserId INT,
            CreatedDate DATE
        );

        set @StocksInwardHdrId = SCOPE_IDENTITY()

        ------------------------------------------------------------
        -- Insert Details
        ------------------------------------------------------------
        INSERT INTO dbo.StocksInwardDtl
        (
            StocksInwardHdrId,

            ItemId,
            ItemDescription,
            ItemQty,
            InwardQty,
            AcceptedQty,
            ItemRate,
            
            ItemAmount,
            ItemDiscountPercentage,
            ItemDiscountAmount,
            TaxPercentage,
            TaxAmount,

            ItemTotalAmount,
            CreatedUserId,
            CreatedDate
        )
        SELECT

            @StocksInwardHdrId,
            ItemId,
            ItemDescription,
            ItemQty,
            InwardQty,
            AcceptedQty,
            ItemRate,

            ItemAmount,
            ItemDiscountPercentage,
            ItemDiscountAmount,
            TaxPercentage,
            TaxAmount,

            ItemTotalAmount,
            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@StocksInwardHdr,'$.StocksInwardDtl')
        WITH
        (
            ItemId                     INT,
            ItemDescription            NVARCHAR(500),
            ItemQty                    DECIMAL(18,2),
            InwardQty                  DECIMAL(18,2),
            AcceptedQty                DECIMAL(18,2),
            ItemRate                   DECIMAL(18,2),
            ItemAmount                 DECIMAL(18,2),
            
            ItemDiscountPercentage     DECIMAL(18,2),
            ItemDiscountAmount         DECIMAL(18,2),
            TaxPercentage              DECIMAL(18,2),
            TaxAmount                  DECIMAL(18,2),
            ItemTotalAmount            DECIMAL(18,2),
            
            CreatedUserId               INT,
            CreatedDate                 DATE
        );

        set @StocksInwardDtlId = SCOPE_IDENTITY()

    ---=======================================================
    --- Inserting StockBatch
    --========================================================
    Declare @ItemId Numeric(18,2)
    Declare @ItemQty Numeric(18,2)
    Declare @ItemRate Numeric(18,2)
    Declare @WareHouseId int
    Declare @CreatedUserId int
    Declare @CreatedDate date
   
    Set @WareHouseId = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardHdr.WareHouseId')
    Set @CreatedUserId = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardHdr.CreatedUserId')
    Set @CreatedDate = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardHdr.CreatedDate')

    Set @ItemId = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardDtl[0].ItemId')
    Set @ItemQty = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardDtl[0].ItemQty')
    Set @ItemRate = JSON_VALUE(@StocksInwardHdr, '$.StocksInwardDtl[0].ItemRate')

        
    INSERT INTO dbo.StockBatch
        (
            CompanyId,
            BranchId,
            WareHouseId,
            ItemId,
            BatchNo,

            StocksInwardHdrId,
            StocksInwardDtlId,
            StocksInwardDate,
            
            ReceivedQty,
            BalanceQty,
            PurchaseRate,

            CreatedUserId,
            CreatedDate
        )
        VALUES
        (
            @CompanyId,
            @BranchId,
            @WareHouseId,
            @ItemId,
            '',

            @StocksInwardHdrId,
            @StocksInwardDtlId,
            @CreatedDate,
            
            @ItemQty,
            @ItemQty,
            @ItemRate,
            
            @CreatedUserId,
            @CreatedDate
        );

        DECLARE @BatchId INT = SCOPE_IDENTITY();

        UPDATE StockBatch
        SET BatchNo = 'B' + RIGHT('000000' + CAST(@BatchId AS VARCHAR(6)),6)
        WHERE BatchId = @BatchId;

     
    ---=======================================================
    --- Inserting StockTrn
    --========================================================
    INSERT INTO dbo.StockTrn
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
            @WareHouseId,

            @CreatedDate,
            'Purchase',

            'Stock Inward',
            @StocksInwardHdrId,
            @StocksInwardDtlId,

            @BatchId,
            @ItemId,

            @ItemQty,
            0,
            @ItemQty,

            @ItemRate,
            NULL,

            @ItemQty * @ItemRate,

            '',       ---@Remarks,

            @CreatedUserId,
            @CreatedDate
        );


    Select @StocksInwardHdrId

	COMMIT TRANSACTION
END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		Declare 
		@ErrMsg varchar(4000),
		@ErrSeverity int,
		@ErrProcedure varchar(100)

		SET @ErrMsg = (Select Error_Message())
		SET @ErrSeverity = (Select Error_Severity())
		SET @ErrProcedure = (Select Error_Procedure())

		SET @ErrMsg = @ErrMsg + ' / ' + @ErrProcedure
		Raiserror(@ErrMsg,@ErrSeverity,1)
		GOTO End_Prog

	END CATCH

End_Prog:


--INSERT INTO StockBatch
    --    (
    --        WareHouseId,
    --        ItemId,
    --        ReceivedQty,
    --        BalanceQty,
    --        PurchaseRate,
    --        CreatedUserId,
    --        CreatedDate
    --    )
    --    SELECT
    --        @WareHouseId,
    --        ItemId,
    --        ItemQty,
    --        ItemQty,
    --        ItemRate,
    --        @CreatedUserId,
    --        @CreatedDate
    --    FROM OPENJSON(@StocksInwardHdr, '$.StocksInwardDtl')
    --    WITH
    --    (
    --        ItemId      INT,
    --        ItemQty     DECIMAL(18,2),
    --        ItemRate    DECIMAL(18,2)
    --    );