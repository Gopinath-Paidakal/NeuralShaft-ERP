USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[`]    Script Date: 27/07//20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertQuoteSOAMCHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertQuoteSOAMCHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteSOAMCHdr]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertQuoteSOAMCHdr]
(
	@QuoteSOAMCHdr  nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY


	Declare @CompanyId int
	Declare @BranchId int
	Declare @QuoteSOAMCNo int
	Declare @QuoteSOAMCSlNo nvarchar(50)
    Declare @ItemClosingDays smallint
    Declare @QuoteSOAMCHdrId int   
    
    --- default Data
    Declare @QuotePaymentTerms nvarchar(500)
    Declare @QuoteValidity smallint
    Declare @DeliveryBy smallint
    Declare @ComplementaryAMC smallint
    Declare @QuoteSOAMCSpecialFeatures nvarchar(1000)
    Declare @QuoteAMCHdrId int     -- for updation approval
    
    Declare @Prefix nvarchar(50)

    --Declare @EnqDtlId int

	BEGIN TRANSACTION
	
        set @CompanyId = (Select CompanyId from Company)
	    set @BranchId = (Select BranchId from Branch)

        set @QuoteAMCHdrId = JSON_VALUE(@QuoteSOAMCHdr, '$.QuoteSOAMCHdr.QuoteAMCHdrId')
      

        set @Prefix = 'BE/SO/'
        --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	    select @QuoteSOAMCSlNo = max(QuoteSOAMCNo) from QuoteSOAMCHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	    if @QuoteSOAMCSlNo = 0 or @QuoteSOAMCSlNo is NULL
		    set @QuoteSOAMCSlNo = 1
	    else
		    set @QuoteSOAMCSlNo = @QuoteSOAMCSlNo + 1

	    set @QuoteSOAMCSlNo = @Prefix + RIGHT('00' + CAST(@QuoteSOAMCSlNo AS VARCHAR(10)), 5) + '/'            
	                     + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

        --- Setting the values from default data for quotation Header
        --set @QuoteValidity = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'QuoteSOItemValidity' and DefaultDataOrderBy = 1)
        --set @DeliveryBy = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'DeliveryBy' and DefaultDataOrderBy = 1)
      --  set @ComplementaryAMC = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'ComplementaryAMC' and DefaultDataOrderBy = 1)
        --set @QuoteSpecialFeatures = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'SpecialFeatures' and DefaultDataOrderBy = 1)
    
        INSERT INTO QuoteSOAMCHdr

               (CompanyId
               ,BranchId
               ,OrdClientHdrId
               ,QuoteSOAMCType
               ,QuoteSOAMCNo
               ,QuoteSOAMCSlNo
               ,QuoteSOAMCDate

               ,QuoteSOAMCConsultant
               
               ,QuoteSOAMCCustComp
               ,QuoteSOAMCBillingAddr
               ,QuoteSOAMCJobOrderNo
               ,QuoteSOAMCContPerson

               ,QuoteSOAMCMobileNo
               ,QuoteSOAMCExpectedClosingDate
               ,QuoteSOAMCEmailId
               ,QuoteSOAMCDeliveryInDays

               ,QuoteSOAMCValidity
               ,QuoteSOAMCGSTExempted
               ,QuoteSOAMCStartDate
               ,QuoteSOAMCEndDate
               ,QuoteSOAMCRenewalCount

               ,QuoteSOAMCPaymentTerms
               ,QuoteSOAMCAmount
               ,QuoteSOAMCTaxAmount
           
               ,QuoteSOAMCTotalAmount
               ,QuoteSOAMCOrderStatus
               ,QuoteSOAMCApprovalStatus 
               ,CreatedUserId
               ,CreatedDate)

         SELECT
                @CompanyId
               ,@BranchId
               ,OrdClientHdrId
               ,'SO_AMC'
               ,@QuoteSOAMCNo
               ,@QuoteSOAMCSlNo
               ,QuoteSOAMCDate

               ,QuoteSOAMCConsultant
               ,QuoteSOAMCCustComp
               ,QuoteSOAMCBillingAddr
               ,QuoteSOAMCJobOrderNo
               ,QuoteSOAMCContPerson

               ,QuoteSOAMCMobileNo
               ,QuoteSOAMCExpectedClosingDate
               ,QuoteSOAMCEmailId
               ,QuoteSOAMCDeliveryInDays

               ,QuoteSOAMCValidity
               ,QuoteSOAMCGSTExempted
               ,QuoteSOAMCStartDate
               ,QuoteSOAMCEndDate
               ,QuoteSOAMCRenewalCount

               ,QuoteSOAMCPaymentTerms
               ,QuoteSOAMCAmount
               ,QuoteSOAMCTaxAmount
           
               ,QuoteSOAMCTotalAmount
               ,QuoteSOAMCOrderStatus
               ,QuoteSOAMCApprovalStatus
               ,CreatedUserId
               ,CreatedDate

            FROM OPENJSON(@QuoteSOAMCHdr,'$.QuoteSOAMCHdr')
            WITH
            (
                 OrdClientHdrId          int,
	             QuoteSOAMCDate          date,
	             QuoteSOAMCSlNo          nvarchar (50),

	             QuoteSOAMCConsultant    nvarchar (100),
	             
	             QuoteSOAMCCustComp      nvarchar (100),
	             QuoteSOAMCBillingAddr   nvarchar (100),
                 QuoteSOAMCJobOrderNo    nvarchar (50),
	             QuoteSOAMCContPerson    nvarchar (100),

	             QuoteSOAMCMobileNo      nvarchar (100),
	             QuoteSOAMCExpectedClosingDate   date,
	             QuoteSOAMCEmailId       nvarchar (100),
	             QuoteSOAMCDeliveryInDays  smallint,

	             QuoteSOAMCValidity      nvarchar (100),
                 QuoteSOAMCGSTExempted   bit,
                 QuoteSOAMCStartDate     date,
                 QuoteSOAMCEndDate       date,
                 QuoteSOAMCRenewalCount  smallint,

	             QuoteSOAMCPaymentTerms  nvarchar (500),
	             QuoteSOAMCAmount        numeric (18, 2),
	             QuoteSOAMCTaxAmount     numeric (18, 2),

	             QuoteSOAMCTotalAmount   numeric (18, 2),
	             QuoteSOAMCOrderStatus   nvarchar (50),
                 QuoteSOAMCApprovalStatus nvarchar (50),

	             CreatedUserId   int,
	             CreatedDate   date   

            );
    
           set @QuoteSOAMCHdrId = SCOPE_IDENTITY()

           INSERT INTO QuoteSOAMCDtl
            (
                QuoteSOAMCHdrId

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

                @QuoteSOAMCHdrId

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
             

            FROM OPENJSON(@QuoteSOAMCHdr,'$.QuoteSOAMCDtl')
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
                    H.QuoteSOAMCAmount               = ISNULL(T.ItemAmount,0),
                    H.QuoteSOAMCDiscountAmount       = ISNULL(T.ItemDiscountAmount,0),
                    H.QuoteSOAMCTaxAmount            = ISNULL(T.ItemTaxAmount,0),
                    H.QuoteSOAMCTotalAmount          = ISNULL(T.ItemTotalAmount,0)
                    
                    FROM QuoteSOAMCHdr H

                OUTER APPLY
                (
                    SELECT
                        SUM(ItemAmount)         AS ItemAmount,
                        SUM(ItemDiscountAmount) AS ItemDiscountAmount,
                        SUM(ItemTaxAmount)       AS ItemTaxAmount,
                        SUM(ItemTotalAmount)    AS ItemTotalAmount

                    FROM QuoteSOAMCDtl D
                    WHERE D.QuoteSOAMCHdrId =  @QuoteSOAMCHdrId  -- H.ItemQuoteHdrId
                ) T

                WHERE H.QuoteSOAMCHdrId = @QuoteSOAMCHdrId;  
                --===============================================

                ----=====================================================
                ------ Updating QuoteHdrAMC approval status - approved
                ----=====================================================

                Update QuoteAMCHdr set ApprovalStatus = 'Approved' where QuoteAMCHdrId = @QuoteAMCHdrId



    Select @QuoteSOAMCHdrId

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
