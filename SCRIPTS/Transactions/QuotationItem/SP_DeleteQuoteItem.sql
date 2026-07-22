USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteQuoteItem]    Script Date: 01/07/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteQuoteItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_DeleteQuoteItem]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteQuoteItem]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteQuoteItem]
(
	@QuoteItemDtlId int
)
----With Encryption
AS
SET NOCOUNT ON;
BEGIN TRY

       Declare @ItemQuoteHdrId int
       --Declare @ModifiedUserId int
       --Declare @ModifiedDate date

       --set @ItemQuoteHdrId = JSON_VALUE(@QuoteItemDtl, '$.ItemQuoteHdrId')
       set @ItemQuoteHdrId = (select ItemQuoteHdrId from QuoteDtlItem where  QuoteItemDtlId = @QuoteItemDtlId)
       --set @ModifiedUserId = JSON_VALUE(@QuoteItemDtl, '$.ModifiedUserId')
       --set @ModifiedDate = JSON_VALUE(@QuoteItemDtl, '$.ModifiedDate')

	BEGIN TRANSACTION

            Delete from QuoteDtlItem where QuoteItemDtlId = @QuoteItemDtlId

            ---==============================================
            ---- Updating the Hdr Amounts
            --===============================================

           UPDATE H
                SET
                    H.ItemQuoteAmount         = ISNULL(T.ItemAmount,0),
                    H.ItemDiscountAmount      = ISNULL(T.ItemDiscountAmount,0),
                    H.ItemQuoteTaxAmount      = ISNULL(T.ItemTaxAmount,0),
                    H.ItemQuoteTotalAmount    = ISNULL(T.ItemTotalAmount,0)
                    
                    FROM QuoteHdrItem H

                OUTER APPLY
                (
                    SELECT
                        SUM(ItemAmount)         AS ItemAmount,
                        SUM(ItemDiscountAmount) AS ItemDiscountAmount,
                        SUM(ItemTaxAmount)       AS ItemTaxAmount,
                        SUM(ItemTotalAmount)    AS ItemTotalAmount

                    FROM QuoteDtlItem D
                    WHERE D.ItemQuoteHdrId =  @ItemQuoteHdrId  -- H.ItemQuoteHdrId
                ) T

                WHERE H.ItemQuoteHdrId = @ItemQuoteHdrId;  
                --===============================================



    Select @QuoteItemDtlId
    
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
