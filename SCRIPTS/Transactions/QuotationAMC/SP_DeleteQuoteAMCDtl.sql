USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteQuoteAMCDtl]    Script Date: 01/07/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteQuoteAMCDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_DeleteQuoteAMCDtl
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteQuoteAMCDtl]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteQuoteAMCDtl]
(
	@QuoteAMCDtlId int
)
----With Encryption
AS
SET NOCOUNT ON;
BEGIN TRY

    --Declare @EnqDtlId int

	BEGIN TRANSACTION

       Declare @QuoteAMCHdrId int
       --Declare @ItemQuoteHdrId int
       --Declare @ModifiedUserId int
       --Declare @ModifiedDate date

       --set @QuoteAMCHdrId = JSON_VALUE(@QuoteAMCDtl, '$.QuoteAMCHdrId')
       set @QuoteAMCHdrId = (Select QuoteAMCHdrId from QuoteAMCDtl where QuoteAMCDtlId = @QuoteAMCDtlId)
       --set @ModifiedUserId = JSON_VALUE(@QuoteAMCDtl, '$.ModifiedUserId')
       --set @ModifiedDate = JSON_VALUE(@QuoteAMCDtl, '$.ModifiedDate')

       --- ========= Deleting from dtl table

        Delete from QuoteAMCDtl where QuoteAMCDtlId = @QuoteAMCDtlId

        ---==============================================
        ---- Updating the Hdr Amounts
        --===============================================

          UPDATE H
                SET
                    H.QuoteAMCAmount             = ISNULL(T.QuoteAMCAmount,0),
                    H.QuoteAMCDiscountAmount     = ISNULL(T.QuoteAMCDiscountAmount,0),
                    H.QuoteAMCTaxAmount          = ISNULL(T.QuoteAMCTaxAmount,0),
                    H.QuoteAMCTotalAmount        = ISNULL(T.QuoteAMCTotalAmount,0)
                    
                    FROM QuoteAMCHdr H

                OUTER APPLY
                (
                    SELECT
                        SUM(ItemAmount)         AS ItemAmount,
                        SUM(ItemDiscountAmount) AS ItemDiscountAmount,
                        SUM(ItemTaxAmount)      AS ItemTaxAmount,
                        SUM(ItemTotalAmount)    AS ItemTotalAmount

                    FROM QuoteAMCDtl D
                    WHERE D.QuoteAMCHdrId =  @QuoteAMCHdrId  -- H.ItemQuoteHdrId
                ) T

                WHERE H.QuoteAMCHdrId = @QuoteAMCHdrId;  


    Select @QuoteAMCDtlId
    
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
