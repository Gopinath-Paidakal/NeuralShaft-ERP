USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOItemHdr]    Script Date: 27/07//2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteSOItemHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteSOItemHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOItemHdr]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteSOItemHdr]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20),
	@Status nvarchar(50)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	DECLARE @QuoteSOItemHdr NVARCHAR(MAX)

	if (@Status = UPPER('EDIT'))
	BEGIN 

	  SET @QuoteSOItemHdr = (

		  SELECT 
		
			  [QuoteSOItemHdr].[QuoteSOItemHdrId]
			  --,[CompanyId]
			  --,[BranchId]
        
			  ,[QuoteSOItemHdr].[OrdClientHdrId]
			  ,[QuoteSOItemHdr].[QuoteSOItemType]
			  ,[QuoteSOItemHdr].[QuoteSOItemNo]
			   --[QuoteHdr].[QuoteDate]
			  ,FORMAT(QuoteSOItemDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
			  ,[QuoteSOItemHdr].[QuoteSOItemSlNo]

			  ,[QuoteSOItemHdr].[QuoteSOItemConsultant]
			  ,[QuoteSOItemHdr].[QuoteSOItemCustComp]
			  ,[QuoteSOItemHdr].[QuoteSOItemBillingAddr]
			  ,[QuoteSOItemHdr].[QuoteSOItemJobOrderNo]
			  ,[QuoteSOItemHdr].[QuoteSOItemContPerson]
			  ,[QuoteSOItemHdr].[QuoteSOItemMobileNo]

			  ,[QuoteSOItemHdr].[QuoteSOItemOrderStatus]

			  --,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  --,[Employee].[EmpMobileNo]

			  ,[QuoteSOItemHdr].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST([QuoteSOItemHdr].[QuoteSOItemValidity] AS INT) ,[QuoteSOItemHdr].CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteSOItemHdr]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			--INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOItemHdr].[CreatedUserId]

	    
			WHERE [QuoteSOItemHdr].[QuoteSOItemDate] >= @FromDate AND [QuoteSOItemHdr].[QuoteSOItemDate] < DATEADD(DAY, 1, @ToDate)
	    
			--Order by [QuoteSOItemHdr].[QuoteSOItemNo]

			FOR JSON PATH, ROOT('QuoteSOItemHdr'))

	END

	if (@Status = UPPER('SENTFORAPPROVAL'))
	BEGIN 

	  SET @QuoteSOItemHdr = (

		  SELECT 
		
			  [QuoteSOItemHdr].[QuoteSOItemHdrId]
			  --,[CompanyId]
			  --,[BranchId]
        
			  ,[QuoteSOItemHdr].[OrdClientHdrId]
			  ,[QuoteSOItemHdr].[QuoteSOItemType]
			  ,[QuoteSOItemHdr].[QuoteSOItemNo]
			   --[QuoteHdr].[QuoteDate]
			  ,FORMAT(QuoteSOItemDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
			  ,[QuoteSOItemHdr].[QuoteSOItemSlNo]

			  ,[QuoteSOItemHdr].[QuoteSOItemConsultant]
			  ,[QuoteSOItemHdr].[QuoteSOItemCustComp]
			  ,[QuoteSOItemHdr].[QuoteSOItemBillingAddr]
			  ,[QuoteSOItemHdr].[QuoteSOItemJobOrderNo]
			  ,[QuoteSOItemHdr].[QuoteSOItemContPerson]
			  ,[QuoteSOItemHdr].[QuoteSOItemMobileNo]

			  ,[QuoteSOItemHdr].[QuoteSOItemOrderStatus]

			  --,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  --,[Employee].[EmpMobileNo]

			  ,[QuoteSOItemHdr].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST([QuoteSOItemHdr].[QuoteSOItemValidity] AS INT) ,[QuoteSOItemHdr].CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteSOItemHdr]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			--INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOItemHdr].[CreatedUserId]
	    
			WHERE [QuoteSOItemHdr].[QuoteSOItemDate] >= @FromDate AND [QuoteSOItemHdr].[QuoteSOItemDate] < DATEADD(DAY, 1, @ToDate)
				  and [QuoteSOItemHdr].[QuoteSOItemOrderStatus] = UPPER('SENTFORAPPROVAL')
	    
			--Order by [QuoteSOItemHdr].[QuoteSOItemNo]

			FOR JSON PATH, ROOT('QuoteSOItemHdr'))

	END

	SELECT @QuoteSOItemHdr
    
	
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

  --,[QuoteSOItemHdr].[ItemProjectName]
	   --   ,[QuoteSOItemHdr].[ItemExpectedClosingDate]
	   --   ,[QuoteSOItemHdr].[QuoteSOItemEmailId]
    --      ,[QuoteSOItemHdr].[ItemDeliveryBy]
	      

    --      ,[QuoteSOItemHdr].[QuoteSOItemValidity]
    --      ,[QuoteSOItemHdr].[QuoteSOItemPaymentTerms]
	   --   ,[QuoteSOItemHdr].[ItemGSTExempted]
	   --   ,[QuoteSOItemHdr].[ItemProductCount]
		  --,[QuoteSOItemHdr].[QuoteSOItemStatus]

		  --,[QuoteSOItemHdr].[CreatedUserId]