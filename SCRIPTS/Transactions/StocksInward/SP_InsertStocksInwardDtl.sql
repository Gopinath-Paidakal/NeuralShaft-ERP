USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertStocksInwardDtl]    Script Date: 30/07/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertStocksInwardDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertStocksInwardDtl]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertStocksInwardDtl]
(
	@StocksInwardDtl  nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

       Declare @StocksInwardDtlId int
       Declare @StocksInwardHdrId int
       --Declare @ModifiedUserId int
       --Declare @ModifiedDate date

       set @StocksInwardHdrId = JSON_VALUE(@StocksInwardDtl, '$.StocksInwardDtl.StocksInwardHdrId')
       --set @ModifiedUserId = JSON_VALUE(@TaxInvDtl, '$.ModifiedUserId')
       --set @ModifiedDate = JSON_VALUE(@TaxInvDtl, '$.ModifiedDate')

    BEGIN TRANSACTION

            INSERT INTO dbo.StocksInwardDtl
        (
            StocksInwardHdrId,

            ItemId,
            ItemName,
            ItemHSNCode,
            ItemCode,
            ItemDesc,

            ItemQuantity,
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
            ItemName,
            ItemHSNCode,
            ItemCode,

            ItemDesc,
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

        FROM OPENJSON(@StocksInwardDtl,'$.StocksInwardDtl')
        WITH
        (
            ItemId                     INT,
            ItemName                   NVARCHAR(100),
            ItemHSNCode                NVARCHAR(50),
            ItemCode                   NVARCHAR(50),
            ItemDesc                   NVARCHAR(500),

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

        ------------------------------------------------------------------
        ------ Updating the totals in StocksInward Hdr
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
         
               

    Select @StocksInwardDtlId

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
        

        --Declare @CompanyId int
	--Declare @BranchId int
	--Declare @ItemQuoteNo int
	--Declare @ItemQuoteSlNo nvarchar(50)
 --   Declare @ItemClosingDays smallint
 --   Declare @ItemQuoteHdrId int   
    
 --   --- default Data
 --   Declare @QuotePaymentTerms nvarchar(500)
 --   Declare @QuoteValidity smallint
 --   Declare @DeliveryBy smallint
 --   Declare @ComplementaryAMC smallint
 --   Declare @QuoteSpecialFeatures nvarchar(1000)
    
 --   Declare @Prefix nvarchar(50)

 --   --Declare @EnqDtlId int

	--BEGIN TRANSACTION
	
 --       set @CompanyId = (Select CompanyId from Company)
	--    set @BranchId = (Select BranchId from Branch)

 --       set @Prefix = 'BE/QTN/'
 --       --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	--    select @ItemQuoteNo = max(ItemQuoteNo) from QuoteHdrItem where CompanyId = @CompanyId  and  BranchId = @BranchId
	--    if @ItemQuoteNo = 0 or @ItemQuoteNo is NULL
	--	    set @ItemQuoteNo = 1
	--    else
	--	    set @ItemQuoteNo =@ItemQuoteNo + 1

	--    set @ItemQuoteSlNo = @Prefix + RIGHT('0000' + CAST(@ItemQuoteNo AS VARCHAR(10)), 5) + '/'            
	--                     + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

 --       --- Setting the values from default data for quotation Header
 --       set @QuoteValidity = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'QuoteValidity' and DefaultDataOrderBy = 1)
 --       set @DeliveryBy = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'DeliveryBy' and DefaultDataOrderBy = 1)
 --     --  set @ComplementaryAMC = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'ComplementaryAMC' and DefaultDataOrderBy = 1)
 --       --set @QuoteSpecialFeatures = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'SpecialFeatures' and DefaultDataOrderBy = 1)
    
 --       INSERT INTO QuoteHdrItem

 --              (CompanyId
 --              ,BranchId
 --              ,OrdClientHdrId
 --              ,ItemQuoteNo
 --              ,ItemQuoteDate
 --              ,ItemQuoteSlNo

 --              ,ItemQuoteConsultant
 --              ,ItemQuoteClientSalutation
 --              ,ItemQuoteCustComp
 --              ,ItemQuoteBillingAddr
 --              ,ItemQuoteContPerson

 --              ,ItemQuoteMobileNo
 --              ,ItemProjectName
 --              ,ItemExpectedClosingDate
 --              ,ItemQuoteEmailId
 --              ,ItemDeliveryBy

 --              ,ItemQuoteValidity
 --              ,ItemGSTExempted
 --              ,ItemQuotePaymentTerms
 --              ,ItemQuoteAmount
 --              ,ItemQuoteTaxAmount
           
 --              ,ItemQuoteTotalAmount
 --              ,ItemQuoteStatus
 --              ,CreatedUserId
 --              ,CreatedDate)

 --        SELECT
 --               @CompanyId
 --              ,@BranchId
 --              ,OrdClientHdrId
 --              ,@ItemQuoteNo
 --              ,ItemQuoteDate
 --              ,@ItemQuoteSlNo

 --              ,ItemQuoteConsultant
 --              ,ItemQuoteClientSalutation
 --              ,ItemQuoteCustComp
 --              ,ItemQuoteBillingAddr
 --              ,ItemQuoteContPerson

 --              ,ItemQuoteMobileNo
 --              ,ItemProjectName
 --              ,ItemExpectedClosingDate
 --              ,ItemQuoteEmailId
 --              ,@DeliveryBy

 --              ,@QuoteValidity
 --              ,ItemGSTExempted
 --              ,ItemQuotePaymentTerms
 --              ,ItemQuoteAmount
 --              ,ItemQuoteTaxAmount
           
 --              ,ItemQuoteTotalAmount
 --              ,ItemQuoteStatus
 --              ,CreatedUserId
 --              ,CreatedDate

 --           FROM OPENJSON(@QuoteHdrItem,'$.QuoteHdrItem')
 --           WITH
 --           (
 --                OrdClientHdrId int,
	--             ItemQuoteDate   date   ,
	--             ItemQuoteSlNo   nvarchar (50)  ,

	--             ItemQuoteConsultant   nvarchar (100),
	--             ItemQuoteClientSalutation   nvarchar (15),
	--             ItemQuoteCustComp   nvarchar (100),
	--             ItemQuoteBillingAddr   nvarchar (100),
	--             ItemQuoteContPerson   nvarchar (100),

	--             ItemQuoteMobileNo   nvarchar (100),
	--             ItemProjectName   nvarchar (100),
	--             ItemExpectedClosingDate   date,
	--             ItemQuoteEmailId   nvarchar (100),
	--            -- ItemDeliveryBy   nvarchar (100),

	--            -- ItemQuoteValidity   nvarchar (100),
	--             ItemGSTExempted   bit   ,
	--             ItemQuotePaymentTerms   nvarchar (500),
	--             ItemQuoteAmount   numeric (18, 2),
	--             ItemQuoteTaxAmount   numeric (18, 2),

	--             ItemQuoteTotalAmount   numeric (18, 2),
	--             ItemQuoteStatus   nvarchar (50),
	--             CreatedUserId   int,
	--             CreatedDate   date   

 --           );
    
 --       set @ItemQuoteHdrId = SCOPE_IDENTITY()


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
