USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertDeliveryChallan]    Script Date: 13/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertDeliveryChallan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertDeliveryChallan]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertDeliveryChallan]    Script Date: 13/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertDeliveryChallan]
(
	@DeliveryChallan NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @DCHdrId INT
    DECLARE @DCDtlId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @DCNo int
	Declare @DCSlNo nvarchar(50)
    Declare @Prefix nvarchar(50)


    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'DeliveryChallan' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
 --   --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @DCNo = max(DCNo) from DeliveryChallanHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @DCNo = 0 or @DCNo is NULL
		set @DCNo = 1
	else
		set @DCNo = @DCNo + 1

	set @DCSlNo = @Prefix + RIGHT('00' + CAST(@DCNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO dbo.DeliveryChallanHdr
        (
            CompanyId,
            BranchId,

            SOHdrId,
            OrdClientHdrId,
            EmpId,
           
            DCType,
            DCNo,
            DCSLNo,
            DCDate,

            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            OrdClientPONo,
            OrdClientPODate,
            DCRemarks,
            
            DCProductAmount,
            DCDiscountPercentage,
            DCDiscountAmount,
            DCTaxPercentage,
            
            ItemTotalAmount,
            DCSubTotal,
            DCTaxAmount,
            DCGrandTotal,
            
            CreatedUserId,
            CreatedDate

        )
        SELECT
            @CompanyId,
            @BranchId,

            SOHdrId,
            OrdClientHdrId,
            EmpId,
            DCType,
            @DCNo,

            @DCSlNo,             --DCSLNo,
            DCDate,

            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            OrdClientPONo,
            OrdClientPODate,
            DCRemarks,

            DCProductAmount,
            DCDiscountPercentage,
            DCDiscountAmount,
            DCTaxPercentage,
            ItemTotalAmount,
            
            DCSubTotal,
            DCTaxAmount,
            DCGrandTotal,

            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@DeliveryChallan,'$.DeliveryChallanHdr')
        WITH
        (
            SOHdrId                     INT,
            OrdClientHdrId              INT,
            EmpId                       INT,
            DCType                      NVARCHAR(50), 
            DCNo                        NVARCHAR(50),
            DCSLNo                      INT,
            DCDate                      DATE,

            DeliveryAddress             NVARCHAR(200), 
            DeliveryContactPerson       NVARCHAR(100), 
            DeliveryMobileId            NVARCHAR(100), 

            OrdClientPONo               NVARCHAR(50), 
            OrdClientPODate             Date, 
            DCRemarks                   NVARCHAR(1000),

            DCProductAmount             DECIMAL(18,2),
            DCDiscountPercentage        DECIMAL(18,2),
            DCDiscountAmount            DECIMAL(18,2),
            DCTaxPercentage             DECIMAL(18,2),
            ItemTotalAmount             DECIMAL(18,2),

            DCSubTotal                  DECIMAL(18,2),
            DCTaxAmount                 DECIMAL(18,2),
            DCGrandTotal                DECIMAL(18,2),

            CreatedUserId               INT,
            CreatedDate                 DATE
        );

        SET @DCHdrId = SCOPE_IDENTITY();

        ------------------------------------------------------------
        -- Insert Details
        ------------------------------------------------------------
        INSERT INTO dbo.DeliveryChallanDtl
        (
            DCHdrId,
            ItemId,
            ItemDescription,
            ItemQty,
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
            @DCHdrId,
            ItemId,
            ItemDescription,
            ItemQty,
            ItemRate,

            ItemAmount,
            ItemDiscountPercentage,
            ItemDiscountAmount,
            TaxPercentage,
            TaxAmount,

            ItemTotalAmount,
            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@DeliveryChallan,'$.DeliveryChallanDtl')
        WITH
        (
            ItemId                     INT,
            ItemDescription            NVARCHAR(500),
            ItemQty                    DECIMAL(18,2),
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

        Set @DCDtlId = SCOPE_IDENTITY()

    ------====================================================
    ------ Insert in StockTrn
    ----------------------------------------------------------
    Declare @ItemId Numeric(18,2)
    Declare @ItemQty Numeric(18,2)
    Declare @ItemRate Numeric(18,2)
    Declare @WareHouseId int
    Declare @CreatedUserId int
    Declare @CreatedDate date
    Declare @BatchId int

    --Set @WareHouseId = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanHdr.WareHouseId')
    Set @CreatedUserId = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanHdr.CreatedUserId')
    Set @CreatedDate = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanHdr.CreatedDate')

    Set @ItemId = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanDtl[0].ItemId')
    Set @ItemQty = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanDtl[0].ItemQty')
    Set @ItemRate = JSON_VALUE(@DeliveryChallan, '$.DeliveryChallanDtl[0].ItemRate')

    ---====================================================
    ---- Setting the BatchId for LIFO
    ---=====================================================
    Set @BatchId = (SELECT TOP (1) BatchId           --, BalanceQty, PurchaseRate
            FROM StockBatch
            WHERE ItemId = @ItemId
              --AND WareHouseId = @WareHouseId
              AND BalanceQty > 0
            ORDER BY StocksInwardDate DESC,
                     BatchId DESC)
     ---====================================================
     ---====================================================
    ---- Setting the WarehouseId for LIFO
    ---=====================================================
    Set @WareHouseId = (SELECT TOP (1) WareHouseId           --, BalanceQty, PurchaseRate
            FROM StockBatch
            WHERE ItemId = @ItemId
              --AND WareHouseId = @WareHouseId
              AND BalanceQty > 0
            ORDER BY StocksInwardDate DESC,
                     BatchId DESC)
     ---====================================================

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
            'DC',

            'Stock Outward',
            @DCHdrId,
            @DCDtlId,

            @BatchId,
            @ItemId,

            0,               --@ItemQty,
            @ItemQty,
            0,

            @ItemRate,
            NULL,

            @ItemQty * @ItemRate,

            '',       ---@Remarks,

            @CreatedUserId,
            @CreatedDate
        );

        ----- ======================================================
        ------ Updating BalanceQty in StockBatch
        ----========================================================
         UPDATE StockBatch
                SET BalanceQty = BalanceQty - @ItemQty
                WHERE BatchId = @BatchId;

        ----- =====================================================


    Select @DCHdrId

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