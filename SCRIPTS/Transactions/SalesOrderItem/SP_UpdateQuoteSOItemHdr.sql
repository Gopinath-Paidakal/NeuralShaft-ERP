USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateQuoteSOItemHdr]    Script Date: 27/07//20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateQuoteSOItemHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateQuoteSOItemHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateQuoteSOItemHdr]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateQuoteSOItemHdr]
(
	@QuoteSOItemHdrId int,
	@QuoteSOItemHdr nvarchar(Max)
   
)
----With Encryption
AS
SET NOCOUNT ON;
BEGIN TRY

    --Declare @EnqDtlId int

	BEGIN TRANSACTION


    ------------------------------------------------
    -- UPDATE QuoteSOHdrItem
    ------------------------------------------------
	  UPDATE H
        SET
           
            H.QuoteSOItemValidity             = J.QuoteSOItemValidity,
            H.QuoteSOItemDeliveryInDays       = J.QuoteSOItemDeliveryInDays,
            H.QuoteSOItemPaymentTerms         = J.QuoteSOItemPaymentTerms,
            H.QuoteSOItemExpectedClosingDate  = J.QuoteSOItemExpectedClosingDate,
            H.QuoteSOItemConsultant           = J.QuoteSOItemConsultant,

            H.QuoteSOItemGSTExempted          = J.QuoteSOItemGSTExempted
            
        FROM QuoteSOItemHdr H

        CROSS APPLY OPENJSON(@QuoteSOItemHdr,'$.QuoteSOItemHdr')
        WITH
        (
            QuoteSOItemValidity NVARCHAR(100),
            QuoteSOItemDeliveryInDays NVARCHAR(100),
            QuoteSOItemPaymentTerms NVARCHAR(100),
            QuoteSOItemExpectedClosingDate date,
            QuoteSOItemConsultant NVARCHAR(100),

            QuoteSOItemGSTExempted bit
        ) J
        WHERE H.QuoteSOItemHdrId = @QuoteSOItemHdrId;

    Select @QuoteSOItemHdrId
    
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
        

        --H.QuoteSOItemAmount               = J.QuoteSOItemAmount,
            --H.QuoteSOItemTaxAmount            = J.QuoteSOItemTaxAmount,
            --H.QuoteSOItemOrderStatus          = J.QuoteSOItemOrderStatus

              --QuoteSOItemAmount  numeric(18, 2) ,
            --QuoteSOItemTaxAmount  numeric(18, 2) ,
            --QuoteSOItemTotalAmount  numeric(18, 2),

            --QuoteSOItemOrderStatus NVARCHAR(50)


          --------------------------------------------------------
		--- UPdating Detail QuoteDtlItem
		-----====================================================

		--UPDATE D
		--	SET
		--		D.[ItemQuantity] = J.[ItemQuantity],
		--		D.[ItemRate] = J.[ItemRate],
  --              D.[ItemDiscountAmount] = J.[ItemDiscountAmount],
  --              D.[ItemDiscountPercentage] = J.[ItemDiscountPercentage],
  --              D.[ItemTotalAmount] = J.[ItemTotalAmount]

		--	FROM QuoteDtlItem D
		--	INNER JOIN OPENJSON(@QuoteItemHdrDtl, '$.QuoteDtlItem')
		--	WITH
		--	(
		--		QuoteItemDtlId INT,

		--		[ItemQuantity] numeric(18, 2) ,
		--		[ItemRate] numeric(18, 2) ,
  --              [ItemDiscountAmount] numeric(10, 2) ,
		--		[ItemDiscountPercentage] numeric(10, 2) ,
  --              [ItemTotalAmount] numeric(18, 2) 
		--	) J
		--	ON D.QuoteItemDtlId = J.QuoteItemDtlId;

			--------------------------------------------------
   --         --=========================================
   --         -- INSERT + UPDATE
   --         --=========================================

   --         MERGE QuoteDtlItem AS T
   --         USING
   --         (
                 
   --             SELECT [QuoteItemDtlId]
   --                   ,[QuoteSOItemHdrId]
   --                   ,[ItemName]
   --                   ,[ItemId]
   --                   ,[ItemHSNCode]

   --                   ,[ItemCode]
   --                   ,[ItemDesc]
   --                   ,[ItemQuantity]
   --                   ,[ItemRate]
   --                   ,[ItemAmount]
                      
   --                   ,[ItemDiscountAmount]
   --                   ,[ItemDiscountPercentage]
   --                   ,[ItemTaxValue]
   --                   ,[ItemTotalAmount]
   --                   ,UPPER(CrudType) AS CrudType
                      
   --                   ,[CreatedUserId]
   --                   ,[CreatedDate]
   --                   ,[ModifiedUserId]
   --                   ,[ModifiedDate]

   --             FROM OPENJSON(@QuoteItemHdrDtl, '$.QuoteDtlItem')
   --             WITH
   --             (
   --                 QuoteItemDtlId            INT,
   --                 QuoteSOItemHdrId            INT,
   --                 ItemName                  NVARCHAR(200),
   --                 ItemId                    INT,
   --                 ItemHSNCode               NVARCHAR(100),
   --                 ItemCode                  NVARCHAR(100),
   --                 ItemDesc                  NVARCHAR(200),
   --                 ItemQuantity              DECIMAL(18,2),
   --                 ItemRate                  DECIMAL(18,2),
   --                 ItemAmount                DECIMAL(18,2),
   --                 ItemDiscountAmount        DECIMAL(18,2),
   --                 ItemDiscountPercentage    DECIMAL(18,2),
   --                 ItemTaxValue              DECIMAL(18,2),
   --                 ItemTotalAmount           DECIMAL(18,2),
   --                 CreatedUserId             INT,
   --                 CreatedDate               Date,
   --                 ModifiedUserId            INT,
   --                 ModifiedDate              Date,
   --                 CrudType                  NVARCHAR(50) 
   --             )
   --         ) AS S
   --         ON T.QuoteItemDtlId = S.QuoteItemDtlId

   --         -- 1. Action: DELETE (If matched and incoming status is 'DELETE')
		 --   WHEN MATCHED AND S.CrudType = 'DELETE' THEN
			--DELETE

   --        -- 2. Action: UPDATE (If matched and NOT marked for deletion)
   --         WHEN MATCHED THEN
   --         UPDATE SET
   --             --T.ItemName               = S.ItemName,
   --             --T.ItemId                 = S.ItemId,
   --             --T.ItemHSNCode            = S.ItemHSNCode,
   --             --T.ItemCode               = S.ItemCode,
   --             --T.ItemDesc               = S.ItemDesc,
   --             T.ItemQuantity           = S.ItemQuantity,
   --             T.ItemRate               = S.ItemRate,
   --             T.ItemAmount             = S.ItemAmount,
   --             T.ItemDiscountAmount     = S.ItemDiscountAmount,
   --             T.ItemDiscountPercentage = S.ItemDiscountPercentage,
   --             T.ItemTaxValue           = S.ItemTaxValue,
   --             T.ItemTotalAmount        = S.ItemTotalAmount,
   --             T.ModifiedUserId         = S.ModifiedUserId,
   --             T.CrudType               = S.CrudType
                

   --        	-- 3. Action: INSERT (If new record and not flagged as a phantom delete)
		 --   WHEN NOT MATCHED BY TARGET AND S.CrudType <> 'DELETE' THEN
   --             INSERT
   --             (
   --                 QuoteSOItemHdrId,
   --                 ItemName,
   --                 ItemId,
   --                 ItemHSNCode,
   --                 ItemCode,
   --                 ItemDesc,
   --                 ItemQuantity,
   --                 ItemRate,
   --                 ItemAmount,
   --                 ItemDiscountAmount,
   --                 ItemDiscountPercentage,
   --                 ItemTaxValue,
   --                 ItemTotalAmount,
   --                 CreatedUserId,
   --                 CreatedDate,
   --                 CrudType
   --             )
   --             VALUES
   --             (
   --                 S.QuoteSOItemHdrId,
   --                 S.ItemName,
   --                 S.ItemId,
   --                 S.ItemHSNCode,
   --                 S.ItemCode,
   --                 S.ItemDesc,
   --                 S.ItemQuantity,
   --                 S.ItemRate,
   --                 S.ItemAmount,
   --                 S.ItemDiscountAmount,
   --                 S.ItemDiscountPercentage,
   --                 S.ItemTaxValue,
   --                 S.ItemTotalAmount,
   --                 S.CreatedUserId,
   --                 S.CreatedDate,
   --                 S.CrudType
   --             );

            ----=========================================
            ---- DELETE
            ----=========================================
            --DECLARE @QuoteItemDtlId INT;

            --SELECT @QuoteItemDtlId = QuoteItemDtlId
            --FROM OPENJSON(@QuoteItemHdrDtl, '$.QuoteDtlItem')
            --WITH
            --(
            --    QuoteItemDtlId INT
            --);

            --DELETE D
            --FROM QuoteDtlItem D
            --WHERE D.QuoteItemDtlId = @QuoteItemDtlId
            --AND NOT EXISTS
            --(
            --    SELECT 1
            --    FROM OPENJSON(@QuoteItemHdrDtl, '$.QuoteDtlItem')
            --    WITH
            --    (
            --        QuoteItemDtlId INT
            --    ) J
            --    WHERE J.QuoteItemDtlId = D.QuoteItemDtlId
            --);

            ----========================================

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
