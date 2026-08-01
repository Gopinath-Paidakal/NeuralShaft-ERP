USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStockInwardDtl]    Script Date: 30/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateStocksInwardDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateStocksInwardDtl]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateStocksInwardDtl]
(
	@StocksInwardDtlId int,	
	@StocksInwardDtl nvarchar(Max)
   
)
----With Encryption
AS
SET NOCOUNT ON;
BEGIN TRY

      Declare @StocksInwardHdrId int
      Declare @itemId int
      Declare @SIDtlItemQuantity decimal(18,2)

      set @StocksInwardHdrId = JSON_VALUE(@StocksInwardDtl, '$.StocksInwardDtl.StocksInwardHdrId')
      set @ItemId            = (Select ItemId from StocksInwardDtl where StocksInwardDtlId = @StocksInwardDtlId)
      set @SIDtlItemQuantity = (Select ItemQuantity from StocksInwardDtl where ItemId = @ItemId)

	BEGIN TRANSACTION

      UPDATE D
        SET
            D.ItemId                   = J.ItemId,
            D.ItemDesc                 = J.ItemDesc,

            D.ItemQuantity             = J.ItemQuantity,
            D.InwardQty                = J.InwardQty,
            D.AcceptedQty              = J.AcceptedQty,

            D.ItemRate                 = J.ItemRate,
            D.ItemAmount               = J.ItemAmount,

            D.ItemDiscountPercentage   = J.ItemDiscountPercentage,
            D.ItemDiscountAmount       = J.ItemDiscountAmount,
            D.ItemTaxPercentage        = J.ItemTaxPercentage,
            D.ItemTaxAmount            = J.ItemTaxAmount,
            D.ItemTotalAmount          = J.ItemTotalAmount,

            D.ModifiedUserId           = J.ModifiedUserId,
            D.ModifiedDate             = J.ModifiedDate


        FROM dbo.StocksInwardDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@StocksInwardDtl, '$.StocksInwardDtl')
            WITH
            (
                StocksInwardDtlId       INT,
                ItemId                  INT,
                ItemDesc                NVARCHAR(500),
                ItemQuantity            DECIMAL(18,2),
                InwardQty               DECIMAL(18,2),
                AcceptedQty             DECIMAL(18,2),
                ItemRate                DECIMAL(18,2),
                
                ItemAmount              DECIMAL(18,2),
                ItemDiscountPercentage  DECIMAL(18,2),
                ItemDiscountAmount      DECIMAL(18,2),
                ItemTaxPercentage           DECIMAL(18,2),

                ItemTaxAmount               DECIMAL(18,2),
                ItemTotalAmount         DECIMAL(18,2),

                ModifiedUserId          INT,
                ModifiedDate            DATE
            )
        ) J
        ON D.StocksInwardDtlId = J.StocksInwardDtlId;
    

        ------------------------------------------------------------------
        ------ Updating the totals in InvHdr
        ------------------------------------------------------------------
        
            UPDATE H
                SET
                    H.SIProductAmount    = ISNULL(T.ItemAmount,0),
                    H.SIDiscountAmount   = ISNULL(T.ItemDiscountAmount,0),
                    H.SITaxAmount        = ISNULL(T.ItemTaxAmount,0),
                    H.SITotalAmount      = ISNULL(T.ItemTotalAmount,0)
                    
                    FROM StocksInwardHdr H

                OUTER APPLY
                (
                    SELECT
                        SUM(ItemAmount)          AS ItemAmount,
                        SUM(ItemDiscountAmount)  AS ItemDiscountAmount,
                        SUM(ItemTaxAmount)       AS ItemTaxAmount,
                        SUM(ItemTotalAmount)     AS ItemTotalAmount

                    FROM StocksInwardDtl D
                    WHERE D.StocksInwardHdrId =  @StocksInwardHdrId  
                ) T

                WHERE H.StocksInwardHdrId = @StocksInwardHdrId;  
                --===============================================

                -----=======================================================
                ----- Updating the ItemStockQty in item master
                -----=======================================================
                   Declare @AcceptedQty decimal(18,2)
                   Declare @ItemStockQty decimal(18,2)
                   Declare @ItemInwardQty decimal(18,2)
                   Declare @ItemDespatchQty decimal(18,2)

                --- deducting the stock before update
                set @ItemStockQty = (Select ItemStockQty from item where ItemId = @ItemId)
                set @ItemInwardQty = (Select ItemInwardQty from item where ItemId = @ItemId)
                set @ItemDespatchQty = (Select ItemDespatchQty from item where ItemId = @ItemId)

                Update item set ItemInwardQty = (@ItemInwardQty - @SIDtlItemQuantity),
                                ItemStockQty = (@ItemStockQty - @SIDtlItemQuantity) 
                                where ItemId = @ItemId

                --- Adding the stock after update
                set @AcceptedQty = JSON_VALUE(@StocksInwardDtl,'$.StocksInwardDtl.AcceptedQty')
                Update item set ItemDespatchQty = (@ItemDespatchQty + @AcceptedQty),                
                                ItemStockQty = (@ItemStockQty + @AcceptedQty) 
                                where ItemId = @ItemId


    Select @StocksInwardDtlId
    
    COMMIT 

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
        
        --set @ItemId = JSON_VALUE(@StocksInwardDtl,'$.ItemId')
        --set @ItemId = (Select ItemId from StocksInwardDtl where StocksInwardDtlId = @StocksInwardDtlId)

         --QDI.ItemQuoteHdrId          = J.ItemQuoteHdrId,
              --QDI.ItemName                = J.ItemName,
              --QDI.ItemId                  = J.ItemId,
              --QDI.ItemHSNCode             = J.ItemHSNCode,
              --QDI.ItemCode                = J.ItemCode,
              --QDI.ItemDesc                = J.ItemDesc,

                --ItemQuoteHdrId             INT,
            --ItemName                   NVARCHAR(500),
            --ItemId                     INT,
            --ItemHSNCode                NVARCHAR(100),
            --ItemCode                   NVARCHAR(100),
            --ItemDesc                   NVARCHAR(MAX),

           ----------------------------------------------
           -- Updating the Enq detail with Quote Header Id
           ----------------------------------------------
       --    Update EnqDtl set QuoteHdrId = @QuoteHdrId where EnqDtl.EnqHdrId = @EnqHdrId
           ----------------------------------------------

           -------------------------------------------
           -- Updating the Enq Header with quotation No
           -------------------------------------------
          -- Update EnqHdr set QuoteNo = @QuoteNo where EnqHdr.EnqHdrId = @EnqHdrId

           -------------------------------------------
           -- Updating Product Count from EnqHdr
           -------------------------------------------
          -- Update QuoteHdr set ProductCount = (select count(*) from Enqdtl where EnqHdrId = @EnqHdrId)

            -------------=====================================================
			------ Inserting Amount in Quote Header after adding Product
            ----------------=====================================================
            --Declare @ProductAmount numeric(18,2)
            --Declare @FloorNameAmount	numeric(18,2)
            --Declare @DoorTypeAmount	numeric(18,2)
            --Declare @CarDoorTypeAmount	numeric(18,2)
            --Declare @DoorFinishAmount	numeric(18,2)
	
            --Declare @CabinTypeAmount numeric(18,2)
            --Declare @FlooringTypeAmount numeric(18,2)
            --Declare @AddnlFeatureAmount numeric(18,2)

            --Declare @ProductAmount1 numeric(18,2)
            --Declare @TaxAmount  numeric(18,2)
            --Declare @TotalAmount numeric(18,2)

            -------- Calculate Quote amount with Tax
            --set @ProductAmount = (Select ProductAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @FloorNameAmount = (Select FloorNameAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @DoorTypeAmount = (Select DoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @CarDoorTypeAmount = (Select CarDoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @DoorFinishAmount = (Select DoorFinishAmount from EnqDtl where EnqHdrId = @EnqHdrId)

            --set @CabinTypeAmount = (Select CabinTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @FlooringTypeAmount = (Select FlooringTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @AddnlFeatureAmount = (Select AddnlFeatureAmount from EnqDtl where EnqHdrId = @EnqHdrId)


            --set @ProductAmount1 = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
            --                        + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

            --set @TaxAmount = (@ProductAmount1 + 18.00/100)

            --    set @TotalAmount = @ProductAmount1 + @TaxAmount

            --Select @ProductAmount1, @TotalAmount

            --update QuoteHdr set QuoteAmount = @ProductAmount1, 
            --                    QuoteTaxAmount = @TaxAmount, 
            --                    QuoteTotalAmount = @TotalAmount 

            --                    where QuoteHdrId = @QuoteHdrId

            ----------------========================================================================
