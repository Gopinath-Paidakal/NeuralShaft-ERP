USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteItemHdr]    Script Date: 01/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteItemHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteItemHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteItemHdr]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteItemHdr]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20),
	@Status nvarchar(50)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	DECLARE @QuoteHdrItem NVARCHAR(MAX)

	if (@Status = UPPER('EDIT'))
	BEGIN 

	  SET @QuoteHdrItem = (

		  SELECT 
		
			[QuoteHdrItem].[ItemQuoteHdrId]
			  --,[CompanyId]
			  --,[BranchId]
        
			  ,[QuoteHdrItem].[OrdClientHdrId]
			  ,[QuoteHdrItem].[ItemQuoteType]
			  ,[QuoteHdrItem].[ItemQuoteNo]
			   --[QuoteHdr].[QuoteDate]
			  ,FORMAT(ItemQuoteDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
			  ,[QuoteHdrItem].[ItemQuoteSlNo]

			  ,[QuoteHdrItem].[ItemQuoteConsultant]
			  ,[QuoteHdrItem].[ItemQuoteCustComp]
			  ,[QuoteHdrItem].[ItemQuoteBillingAddr]
			  ,[QuoteHdrItem].[ItemQuoteJobOrderNo]
			  ,[QuoteHdrItem].[ItemQuoteContPerson]
			  ,[QuoteHdrItem].[ItemQuoteMobileNo]

			  ,[QuoteHdrItem].[OrderStatus]

			  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  ,[Employee].[EmpMobileNo]

			  ,[QuoteHdrItem].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteHdrItem.ItemQuoteValidity AS INT), QuoteHdrItem.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteHdrItem]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			INNER JOIN [Employee] ON [Employee].EmpId = [QuoteHdrItem].[CreatedUserId]

	    
			WHERE [QuoteHdrItem].[ItemQuoteDate] >= @FromDate AND [QuoteHdrItem].[ItemQuoteDate] < DATEADD(DAY, 1, @ToDate)
	    
			Order by [QuoteHdrItem].[ItemQuoteNo]

			FOR JSON PATH, ROOT('QuoteHdrItem'))

	END

	if (@Status = UPPER('SENTFORAPPROVAL'))
	BEGIN 

	  SET @QuoteHdrItem = (

		  SELECT 
		
			[QuoteHdrItem].[ItemQuoteHdrId]
			  --,[CompanyId]
			  --,[BranchId]
        
			  ,[QuoteHdrItem].[OrdClientHdrId]
			  ,[QuoteHdrItem].[ItemQuoteType]
			  ,[QuoteHdrItem].[ItemQuoteNo]
			   --[QuoteHdr].[QuoteDate]
			  ,FORMAT(ItemQuoteDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
			  ,[QuoteHdrItem].[ItemQuoteSlNo]

			  ,[QuoteHdrItem].[ItemQuoteConsultant]
			  ,[QuoteHdrItem].[ItemQuoteCustComp]
			  ,[QuoteHdrItem].[ItemQuoteBillingAddr]
			  ,[QuoteHdrItem].[ItemQuoteJobOrderNo]
			  ,[QuoteHdrItem].[ItemQuoteContPerson]
			  ,[QuoteHdrItem].[ItemQuoteMobileNo]

			  ,[QuoteHdrItem].[ItemQuoteAmount]
			  ,[QuoteHdrItem].[ItemDiscountAmount]
			  ,[QuoteHdrItem].[ItemQuoteTaxAmount]
			  ,[QuoteHdrItem].[ItemQuoteTotalAmount]

			  ,[QuoteHdrItem].[OrderStatus]

			  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  ,[Employee].[EmpMobileNo]

			  ,[QuoteHdrItem].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteHdrItem.ItemQuoteValidity AS INT), QuoteHdrItem.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteHdrItem]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			INNER JOIN [Employee] ON [Employee].EmpId = [QuoteHdrItem].[CreatedUserId]
	    
			WHERE [QuoteHdrItem].[ItemQuoteDate] >= @FromDate AND [QuoteHdrItem].[ItemQuoteDate] < DATEADD(DAY, 1, @ToDate)
				  and [QuoteHdrItem].[OrderStatus] = UPPER('SENTFORAPPROVAL')
	    
			Order by [QuoteHdrItem].[ItemQuoteNo]

			FOR JSON PATH, ROOT('QuoteHdrItem'))

	END

	SELECT @QuoteHdrItem
    
	
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

  --,[QuoteHdrItem].[ItemProjectName]
	   --   ,[QuoteHdrItem].[ItemExpectedClosingDate]
	   --   ,[QuoteHdrItem].[ItemQuoteEmailId]
    --      ,[QuoteHdrItem].[ItemDeliveryBy]
	      

    --      ,[QuoteHdrItem].[ItemQuoteValidity]
    --      ,[QuoteHdrItem].[ItemQuotePaymentTerms]
	   --   ,[QuoteHdrItem].[ItemGSTExempted]
	   --   ,[QuoteHdrItem].[ItemProductCount]
		  --,[QuoteHdrItem].[ItemQuoteStatus]

		  --,[QuoteHdrItem].[CreatedUserId]