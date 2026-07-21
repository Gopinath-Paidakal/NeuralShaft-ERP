USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteItemHdr_ById]    Script Date: 01/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteItemHdr_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteItemHdr_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteItemHdr_ById]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteItemHdr_ById]
(
	@quoteItemHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @QuoteItemHdr   NVARCHAR(MAX)
DECLARE @QuoteItemDtl   NVARCHAR(MAX)
DECLARE @QuoteItem      NVARCHAR(MAX)

SET @QuoteItemHdr = (

    SELECT 
		
		[QuoteHdrItem].[ItemQuoteHdrId]
          --,[CompanyId]
          --,[BranchId]
        
		  ,[QuoteHdrItem].[OrdClientHdrId]
          ,[QuoteHdrItem].[ItemQuoteNo]
           --[QuoteHdr].[QuoteDate]
	      ,FORMAT(ItemQuoteDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
          ,[QuoteHdrItem].[ItemQuoteSlNo]

	      ,[QuoteHdrItem].[ItemQuoteConsultant]
          ,[QuoteHdrItem].[ItemQuoteCustComp]
		  ,[QuoteHdrItem].[ItemQuoteBillingAddr]
          ,[QuoteHdrItem].[ItemQuoteContPerson]
          ,[QuoteHdrItem].[ItemQuoteMobileNo]


	      ,[QuoteHdrItem].[ItemExpectedClosingDate]
	      ,[QuoteHdrItem].[ItemQuoteEmailId]
          ,[QuoteHdrItem].[ItemDeliveryBy]
	      

          ,[QuoteHdrItem].[ItemQuoteValidity]
          ,[QuoteHdrItem].[ItemQuotePaymentTerms]
	      ,[QuoteHdrItem].[ItemGSTExempted]
	      ,[QuoteHdrItem].[ItemProductCount]
		  ,[QuoteHdrItem].[ItemQuoteStatus]

		  --,[QuoteHdrItem].[CreatedUserId]

		  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
		  ,[Employee].[EmpMobileNo]

		  ,[QuoteHdrItem].[CreatedDate]

		  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteHdrItem.ItemQuoteValidity AS INT), QuoteHdrItem.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


	    FROM [dbo].[QuoteHdrItem]
        INNER JOIN [Employee] ON [Employee].EmpId = [QuoteHdrItem].[CreatedUserId]

        where ItemQuoteHdrId = @quoteItemHdrId

        FOR JSON PATH   
    )

    SET @QuoteItemDtl = (
       
           SELECT 
       
               [QuoteItemDtlId]
              ,[ItemQuoteHdrId]
              ,[ItemId]
              ,[ItemName]
          
              ,[ItemHSNCode]
              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]

              ,[ItemAmount]
              ,[ItemTaxValue]
              ,[ItemDiscountAmount]
              ,[ItemDiscountPercentage]
              ,[ItemTotalAmount]

          

           FROM [dbo].[QuoteDtlItem]
           where ItemQuoteHdrId = @quoteItemHdrId

            FOR JSON PATH   
        )

    SET @QuoteItem = (
        SELECT
            JSON_QUERY(@QuoteItemHdr)  AS QuoteItemHdr,
            JSON_QUERY(@QuoteItemDtl) AS QuoteItemDtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
   )

Select @QuoteItem   

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

































































