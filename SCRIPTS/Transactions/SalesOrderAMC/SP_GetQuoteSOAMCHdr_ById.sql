USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOAMCHdr_ById]    Script Date: 27/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteSOAMCHdr_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteSOAMCHdr_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOAMCHdr_ById]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteSOAMCHdr_ById]
(
	@QuoteSOAMCHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @QuoteAMCHdr   NVARCHAR(MAX)
DECLARE @QuoteAMCDtl   NVARCHAR(MAX)
DECLARE @QuoteAMC     NVARCHAR(MAX)

SET @QuoteAMCHdr = (

    SELECT 
		
		[QuoteSOAMCHdr].[QuoteSOAMCHdrId]
          --,[CompanyId]
          --,[BranchId]
        
		  ,[QuoteSOAMCHdr].[OrdClientHdrId]
          ,[QuoteSOAMCHdr].[QuoteSOAMCType]
          ,[QuoteSOAMCHdr].[QuoteSOAMCNo]
           --[QuoteHdr].[QuoteDate]

	      ,FORMAT(QuoteSOAMCDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
          ,[QuoteSOAMCHdr].[QuoteSOAMCSlNo]

	      ,[QuoteSOAMCHdr].[QuoteSOAMCConsultant]
          ,[QuoteSOAMCHdr].[QuoteSOAMCCustComp]
		  ,[QuoteSOAMCHdr].[QuoteSOAMCBillingAddr]
          ,[QuoteSOAMCHdr].[QuoteSOAMCJobOrderNo]
          ,[QuoteSOAMCHdr].[QuoteSOAMCContPerson]
          ,[QuoteSOAMCHdr].[QuoteSOAMCMobileNo]


	      ,[QuoteSOAMCHdr].[QuoteSOAMCExpectedClosingDate]
	      ,[QuoteSOAMCHdr].[QuoteSOAMCEmailId]
          ,[QuoteSOAMCHdr].[QuoteSOAMCDeliveryInDays]
	      

          ,[QuoteSOAMCHdr].[QuoteSOAMCValidity]
          ,[QuoteSOAMCHdr].[QuoteSOAMCPaymentTerms]
	      ,[QuoteSOAMCHdr].[QuoteSOAMCGSTExempted]

          ,[QuoteSOAMCHdr].[QuoteSOAMCStartDate]
          ,[QuoteSOAMCHdr].[QuoteSOAMCEndDate]
          ,[QuoteSOAMCHdr].[QuoteSOAMCRenewalCount]
	      
		  ,[QuoteSOAMCHdr].[QuoteSOAMCOrderStatus]
          ,[QuoteSOAMCHdr].[QuoteSOAMCAmount]
          ,[QuoteSOAMCHdr].[QuoteSOAMCDiscountAmount]
          ,[QuoteSOAMCHdr].[QuoteSOAMCTaxAmount]
          ,[QuoteSOAMCHdr].[QuoteSOAMCTotalAmount]


		  --,[QuoteSOAMCHdr].[CreatedUserId]

		  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
		  ,[Employee].[EmpMobileNo]

		  ,[QuoteSOAMCHdr].[CreatedDate]

		  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteSOAMCHdr.QuoteSOAMCValidity AS INT), QuoteSOAMCHdr.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


	    FROM [dbo].[QuoteSOAMCHdr]
        INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOAMCHdr].[CreatedUserId]

        where QuoteSOAMCHdrId = @QuoteSOAMCHdrId

        FOR JSON PATH   
    )

    SET @QuoteAMCDtl = (
       
           SELECT 
       
               [QuoteSOAMCDtlId]
              ,[QuoteSOAMCHdrId]
              ,[ItemId]
              ,[ItemName]
          
              ,[ItemHSNCode]
              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]

              ,[ItemAmount]
              ,[ItemTaxPercentage]
              ,[ItemDiscountAmount]
              ,[ItemDiscountPercentage]
              ,[ItemTotalAmount]          

           FROM [dbo].[QuoteSOAMCDtl]
           where QuoteSOAMCHdrId = @QuoteSOAMCHdrId

            FOR JSON PATH   
        )

    SET @QuoteAMC = (
        SELECT
            JSON_QUERY(@QuoteAMCHdr)  AS QuoteAMCHdr,
            JSON_QUERY(@QuoteAMCDtl) AS QuoteAMCDtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
   )

Select @QuoteAMC   

END TRY

	BEGIN CATCH

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



--SELECT ISNULL(@DefaultData, '{"DefaultData":[]}') AS DefaultData;
--END

































































