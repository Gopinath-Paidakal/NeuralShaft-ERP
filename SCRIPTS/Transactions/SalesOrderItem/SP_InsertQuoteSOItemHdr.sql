USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteSOItemHdr]    Script Date: 27/07//20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertQuoteSOItemHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertQuoteSOItemHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteSOItemHdr]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertQuoteSOItemHdr]
(
	@QuoteSOItemHdr  nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY


	Declare @CompanyId int
	Declare @BranchId int
	Declare @QuoteSOItemNo int
	Declare @QuoteSOItemSlNo nvarchar(50)
    Declare @ItemClosingDays smallint
    Declare @QuoteSOItemHdrId int   
    
    --- default Data
    Declare @QuotePaymentTerms nvarchar(500)
    Declare @QuoteValidity smallint
    Declare @DeliveryBy smallint
    Declare @ComplementaryAMC smallint
    Declare @QuoteSOItemSpecialFeatures nvarchar(1000)
    
    Declare @Prefix nvarchar(50)
    Declare @ItemQuoteHdrId int     -- for updation approval

    --Declare @EnqDtlId int

	BEGIN TRANSACTION
	
        set @CompanyId = (Select CompanyId from Company)
	    set @BranchId = (Select BranchId from Branch)
        --set @ItemQuoteHdrId = JSON_VALUE(@QuoteSOItemHdr, '$.QuoteSOItemHdr.ItemQuoteHdrId')
        set @ItemQuoteHdrId = JSON_VALUE(@QuoteSOItemHdr, '$.QuoteSOItemHdr.ItemQuoteHdrId')


        set @Prefix = 'BE/SO/'
        --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	    select @QuoteSOItemSlNo = max(QuoteSOItemNo) from QuoteSOItemHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	    if @QuoteSOItemSlNo = 0 or @QuoteSOItemSlNo is NULL
		    set @QuoteSOItemSlNo = 1
	    else
		    set @QuoteSOItemSlNo = @QuoteSOItemSlNo + 1

	    set @QuoteSOItemSlNo = @Prefix + RIGHT('00' + CAST(@QuoteSOItemSlNo AS VARCHAR(10)), 5) + '/'            
	                     + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

        --- Setting the values from default data for quotation Header
        --set @QuoteValidity = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'QuoteSOItemValidity' and DefaultDataOrderBy = 1)
        --set @DeliveryBy = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'DeliveryBy' and DefaultDataOrderBy = 1)
      --  set @ComplementaryAMC = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'ComplementaryAMC' and DefaultDataOrderBy = 1)
        --set @QuoteSpecialFeatures = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'SpecialFeatures' and DefaultDataOrderBy = 1)
    
        INSERT INTO QuoteSOItemHdr

               (CompanyId
               ,BranchId
               ,OrdClientHdrId
               ,QuoteSOItemType
               ,QuoteSOItemNo
               ,QuoteSOItemSlNo
               ,QuoteSOItemDate

               ,QuoteSOItemConsultant
               
               ,QuoteSOItemCustComp
               ,QuoteSOItemBillingAddr
               ,QuoteSOItemJobOrderNo
               ,QuoteSOItemContPerson

               ,QuoteSOItemMobileNo
               ,QuoteSOItemExpectedClosingDate
               ,QuoteSOItemEmailId
               ,QuoteSOItemDeliveryInDays

               ,QuoteSOItemValidity
               ,QuoteSOItemGSTExempted
               ,QuoteSOItemPaymentTerms
               ,QuoteSOItemAmount
               ,QuoteSOItemTaxAmount
           
               ,QuoteSOItemTotalAmount
               ,QuoteSOItemOrderStatus
               ,QuoteSOItemApprovalStatus 
               ,CreatedUserId
               ,CreatedDate)

         SELECT
                @CompanyId
               ,@BranchId
               ,OrdClientHdrId
               ,'SOItem_Spare'
               ,@QuoteSOItemNo
               ,@QuoteSOItemSlNo
               ,QuoteSOItemDate

               ,QuoteSOItemConsultant
               ,QuoteSOItemCustComp
               ,QuoteSOItemBillingAddr
               ,QuoteSOItemJobOrderNo
               ,QuoteSOItemContPerson

               ,QuoteSOItemMobileNo
               ,QuoteSOItemExpectedClosingDate
               ,QuoteSOItemEmailId
               ,QuoteSOItemDeliveryInDays

               ,QuoteSOItemValidity
               ,QuoteSOItemGSTExempted
               ,QuoteSOItemPaymentTerms
               ,QuoteSOItemAmount
               ,QuoteSOItemTaxAmount
           
               ,QuoteSOItemTotalAmount
               ,QuoteSOItemOrderStatus
               ,QuoteSOItemApprovalStatus
               ,CreatedUserId
               ,CreatedDate

            FROM OPENJSON(@QuoteSOItemHdr,'$.QuoteSOItemHdr')
            WITH
            (
                 OrdClientHdrId int,
	             QuoteSOItemDate   date   ,
	             QuoteSOItemSlNo   nvarchar (50)  ,

	             QuoteSOItemConsultant   nvarchar (100),
	             
	             QuoteSOItemCustComp   nvarchar (100),
	             QuoteSOItemBillingAddr   nvarchar (100),
                 QuoteSOItemJobOrderNo nvarchar (50),
	             QuoteSOItemContPerson   nvarchar (100),

	             QuoteSOItemMobileNo   nvarchar (100),
	             QuoteSOItemExpectedClosingDate   date,
	             QuoteSOItemEmailId   nvarchar (100),
	             QuoteSOItemDeliveryInDays   smallint,

	             QuoteSOItemValidity   nvarchar (100),
	             QuoteSOItemGSTExempted   bit   ,
	             QuoteSOItemPaymentTerms   nvarchar (500),
	             QuoteSOItemAmount   numeric (18, 2),
	             QuoteSOItemTaxAmount   numeric (18, 2),

	             QuoteSOItemTotalAmount   numeric (18, 2),
	             QuoteSOItemOrderStatus   nvarchar (50),
                 QuoteSOItemApprovalStatus nvarchar (50),

	             CreatedUserId   int,
	             CreatedDate   date   

            );
    
        set @QuoteSOItemHdrId = SCOPE_IDENTITY()

           INSERT INTO QuoteSOItemDtl
            (
                QuoteSOItemHdrId

               ,ItemId
               ,ItemName
               ,ItemHSNCode
               ,ItemCode
               ,ItemDesc

               ,ItemQuantity
               ,ItemRate
               ,ItemAmount
               ,ItemTaxPercentage
            

               ,ItemDiscountAmount
               ,ItemDiscountPercentage
               ,ItemTotalAmount

               ,ItemTaxAmount

               ,CreatedUserId
               ,CreatedDate
            
            )
            SELECT

                @QuoteSOItemHdrId

               ,ItemId
               ,ItemName
               ,ItemHSNCode
               ,ItemCode
               ,ItemDesc

               ,ItemQuantity
               ,ItemRate
               ,ItemAmount
               ,ItemTaxPercentage

               ,ItemDiscountAmount
               ,ItemDiscountPercentage
               ,ItemTotalAmount

               ,(ItemTotalAmount * ItemDiscountPercentage/100)   ----ItemTaxAmount
                           
               ,CreatedUserId
               ,CreatedDate
             

            FROM OPENJSON(@QuoteSOItemHdr,'$.QuoteSOItemDtl')
            WITH
            (

                ItemId int ,
                ItemName nvarchar (100) ,
	            ItemHSNCode nvarchar(100),
	            ItemCode nvarchar(50),
	            ItemDesc nvarchar(100) ,

	            ItemQuantity numeric(18, 2),
	            ItemRate numeric (18, 2),
	            ItemAmount numeric (18, 2),
	            ItemTaxPercentage numeric (10, 2),
	            ItemDiscountAmount numeric(18, 2),

	            ItemDiscountPercentage numeric(10, 2),
	            ItemTotalAmount numeric(18, 2),

	            CreatedUserId int ,
	            CreatedDate date
	           
            );


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
                        SUM(ItemAmount)          AS ItemAmount,
                        SUM(ItemDiscountAmount)  AS ItemDiscountAmount,
                        SUM(ItemTaxAmount)       AS ItemTaxAmount,
                        SUM(ItemTotalAmount)     AS ItemTotalAmount

                    FROM QuoteDtlItem D
                    WHERE D.ItemQuoteHdrId =  @QuoteSOItemHdrId  -- H.ItemQuoteHdrId
                ) T

                WHERE H.ItemQuoteHdrId = @QuoteSOItemHdrId;  
                --===============================================

                ----=====================================================
                ------ Updating QuoteHdrItem approval status - approved
                ----=====================================================

                Update QuoteHdrItem set ApprovalStatus = 'Approved' where ItemQuoteHdrId = @ItemQuoteHdrId



    Select @QuoteSOItemHdrId

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
