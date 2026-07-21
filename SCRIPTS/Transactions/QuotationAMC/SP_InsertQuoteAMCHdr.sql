USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteAMCHdr]    Script Date: 20/07/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertQuoteAMCHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertQuoteAMCHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteAMCHdr]    Script Date: 20/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertQuoteAMCHdr]
(
	@QuoteHdrAMC  nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY


	Declare @CompanyId int
	Declare @BranchId int
	Declare @QuoteAMCNo int
	Declare @QuoteAMCSlNo nvarchar(50)
    Declare @AMCClosingDays smallint
    Declare @QuoteAMCHdrId int   
    
    --- default Data
    Declare @QuotePaymentTerms nvarchar(500)
    Declare @QuoteValidity smallint
    Declare @DeliveryBy smallint
    Declare @ComplementaryAMC smallint
    Declare @QuoteSpecialFeatures nvarchar(1000)
    
    Declare @Prefix nvarchar(50)

    --Declare @EnqDtlId int

	BEGIN TRANSACTION
	
        set @CompanyId = (Select CompanyId from Company)
	    set @BranchId = (Select BranchId from Branch)

        --set @Prefix = 'BE/QTN/'
        --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	    select @QuoteAMCNo = max(QuoteAMCNo) from QuoteAMCHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	    if @QuoteAMCNo = 0 or @QuoteAMCNo is NULL
		    set @QuoteAMCNo = 1
	    else
		    set @QuoteAMCNo =@QuoteAMCNo + 1

	    set @QuoteAMCSlNo = @Prefix + RIGHT('0000' + CAST(@QuoteAMCNo AS VARCHAR(10)), 5) + '/'            
	                     + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

        --- Setting the values from default data for quotation Header
        set @QuoteValidity = (Select DefaultDataName from DefaultData where FormType = 'QuotationAMC' and DefaultDataType = 'QuoteValidity' and DefaultDataOrderBy = 1)
        set @DeliveryBy = (Select DefaultDataName from DefaultData where FormType = 'QuotationAMC' and DefaultDataType = 'DeliveryBy' and DefaultDataOrderBy = 1)
      --  set @ComplementaryAMC = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'ComplementaryAMC' and DefaultDataOrderBy = 1)
        --set @QuoteSpecialFeatures = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'SpecialFeatures' and DefaultDataOrderBy = 1)
    
        INSERT INTO QuoteHdrAMC

               (CompanyId
               ,BranchId
               ,OrdClientHdrId
               ,QuoteAMCNo
               ,QuoteAMCDate
               ,QuoteAMCSlNo

               ,QuoteAMCConsultant
               ,QuoteAMCClientSalutation
               ,QuoteAMCCustComp
               ,QuoteAMCBillingAddr
               ,QuoteAMCContPerson

               ,QuoteAMCMobileNo
               ,AMCProjectName
               ,AMCExpectedClosingDate
               ,QuoteAMCEmailId
               ,AMCDeliveryBy

               ,QuoteAMCValidity
               ,AMCGSTExempted
               ,QuoteAMCPaymentTerms
               ,QuoteAMCAmount
               ,QuoteAMCTaxAmount
           
               ,QuoteAMCTotalAmount
               ,QuoteAMCRenewalCount
               ,QuoteAMCRevisionNo
               ,QuoteAMCStartDate
               ,QuoteAMCCloseDate

               ,QuoteAMCStatus


               ,CreatedUserId
               ,CreatedDate)

         SELECT
                @CompanyId
               ,@BranchId
               ,OrdClientHdrId
               ,@QuoteAMCNo
               ,QuoteAMCDate
               ,@QuoteAMCSlNo

               ,QuoteAMCConsultant
               ,QuoteAMCClientSalutation
               ,QuoteAMCCustComp
               ,QuoteAMCBillingAddr
               ,QuoteAMCContPerson

               ,QuoteAMCMobileNo
               ,AMCProjectName
               ,AMCExpectedClosingDate
               ,QuoteAMCEmailId
               ,@DeliveryBy

               ,@QuoteValidity
               ,AMCGSTExempted
               ,QuoteAMCPaymentTerms
               ,QuoteAMCAmount
               ,QuoteAMCTaxAmount
           
               ,QuoteAMCTotalAmount
               ,QuoteAMCRenewalCount
               ,QuoteAMCRevisionNo
               ,QuoteAMCStartDate
               ,QuoteAMCCloseDate

               ,QuoteAMCStatus
               ,CreatedUserId
               ,CreatedDate

            FROM OPENJSON(@QuoteHdrAMC,'$.QuoteHdrAMC')
            WITH
            (
                 OrdClientHdrId int,
	             QuoteAMCDate   date   ,
	             QuoteAMCSlNo   nvarchar (50)  ,

	             QuoteAMCConsultant   nvarchar (100),
	             QuoteAMCClientSalutation   nvarchar (15),
	             QuoteAMCCustComp   nvarchar (100),
	             QuoteAMCBillingAddr   nvarchar (100),
	             QuoteAMCContPerson   nvarchar (100),

	             QuoteAMCMobileNo   nvarchar (100),
	             AMCProjectName   nvarchar (100),
	             AMCExpectedClosingDate   date,
	             QuoteAMCEmailId   nvarchar (100),
	            -- AMCDeliveryBy   nvarchar (100),

	            -- QuoteAMCValidity   nvarchar (100),
	             AMCGSTExempted   bit   ,
	             QuoteAMCPaymentTerms   nvarchar (500),
	             QuoteAMCAmount   numeric (18, 2),
	             QuoteAMCTaxAmount   numeric (18, 2),

	             QuoteAMCTotalAmount   numeric (18, 2),

                 QuoteAMCRenewalCount smallint,
                 QuoteAMCRevisionNo smallint,
                 QuoteAMCStartDate date,
                 QuoteAMCCloseDate date,

	             QuoteAMCStatus   nvarchar (50),
	             CreatedUserId   int,
	             CreatedDate   date   

            );
    
        set @QuoteAMCHdrId = SCOPE_IDENTITY()

        ----======================== Insert Detail

           INSERT INTO QuoteAMCDtl
            (
                QuoteAMCHdrId

               ,ItemName
               ,ItemId
               ,ItemHSNCode
               ,ItemCode
               ,ItemDesc

               ,ItemQuantity
               ,ItemRate
               ,ItemAmount
               ,ItemTaxValue
               ,ItemDiscountAmount

               ,ItemDiscountPercentage
               ,ItemTotalAmount

               ,CrudType

               ,CreatedUserId
               ,CreatedDate
               --,ModifiedUserId
               --,ModifiedDate
             
            
            )
            SELECT

               @QuoteAMCHdrId

               ,ItemName
               ,ItemId
               ,ItemHSNCode
               ,ItemCode
               ,ItemDesc

               ,ItemQuantity
               ,ItemRate
               ,ItemAmount
               ,ItemTaxValue
               ,ItemDiscountAmount

               ,ItemDiscountPercentage
               ,ItemTotalAmount

               ,CrudType
               ,CreatedUserId
               ,CreatedDate
               --,ModifiedUserId
               --,ModifiedDate
             

            FROM OPENJSON(@QuoteHdrAMC,'$.QuoteAMCDtl')
            WITH
            (

                ItemId int ,
                ItemName nvarchar (100) ,
	            
	            ItemHSNCode nvarchar(100),
	            ItemCode int,
	            ItemDesc nvarchar(100) ,

	            ItemQuantity numeric(18, 2) ,
	            ItemRate numeric (18, 2),
	            ItemAmount numeric (18, 2) ,
	            ItemTaxValue numeric (10, 2) ,
	            ItemDiscountAmount numeric(18, 2) ,

	            ItemDiscountPercentage numeric(10, 2) ,
	            ItemTotalAmount numeric(18, 2) ,

                CrudType nvarchar(50),
	            CreatedUserId int ,
	            CreatedDate date
	            --ModifiedUserId int,
	            --ModifiedDate date 
            );

    Select @QuoteAMCHdrId

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
