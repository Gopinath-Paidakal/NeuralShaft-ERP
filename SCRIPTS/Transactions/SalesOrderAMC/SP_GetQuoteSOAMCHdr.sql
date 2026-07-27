USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOAMCHdr]    Script Date: 27/07//2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteSOAMCHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteSOAMCHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOAMCHdr]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteSOAMCHdr]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20),
	@Status nvarchar(50)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	DECLARE @QuoteSOAMCHdr NVARCHAR(MAX)

	if (@Status = UPPER('EDIT'))
	BEGIN 

	  SET @QuoteSOAMCHdr = (

		  SELECT 
		
			   [QuoteSOAMCHdr].[QuoteSOAMCHdrId]
			 
        
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

			  ,[QuoteSOAMCHdr].[QuoteSOAMCOrderStatus]

			  --,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  --,[Employee].[EmpMobileNo]

			  ,[QuoteSOAMCHdr].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST([QuoteSOAMCHdr].[QuoteSOAMCValidity] AS INT) ,[QuoteSOAMCHdr].CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteSOAMCHdr]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			--INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOAMCHdr].[CreatedUserId]

	    
			WHERE [QuoteSOAMCHdr].[QuoteSOAMCDate] >= @FromDate AND [QuoteSOAMCHdr].[QuoteSOAMCDate] < DATEADD(DAY, 1, @ToDate)
	    
			--Order by [QuoteSOAMCHdr].[QuoteSOAMCNo]

			FOR JSON PATH, ROOT('QuoteSOAMCHdr'))

	END

	if (@Status = UPPER('SENTFORAPPROVAL'))
	BEGIN 

	  SET @QuoteSOAMCHdr = (

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

			  ,[QuoteSOAMCHdr].[QuoteSOAMCOrderStatus]

			  --,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
			  --,[Employee].[EmpMobileNo]

			  ,[QuoteSOAMCHdr].[CreatedDate]

			  ,FORMAT(DATEADD(DAY, TRY_CAST([QuoteSOAMCHdr].[QuoteSOAMCValidity] AS INT) ,[QuoteSOAMCHdr].CreatedDate),'dd-MM-yyyy') as 'Price Validity'


			FROM [dbo].[QuoteSOAMCHdr]
			--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
			--INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOAMCHdr].[CreatedUserId]
	    
			WHERE [QuoteSOAMCHdr].[QuoteSOAMCDate] >= @FromDate AND [QuoteSOAMCHdr].[QuoteSOAMCDate] < DATEADD(DAY, 1, @ToDate)
				  and [QuoteSOAMCHdr].[QuoteSOAMCOrderStatus] = UPPER('SENTFORAPPROVAL')
	    
			--Order by [QuoteSOAMCHdr].[QuoteSOAMCNo]

			FOR JSON PATH, ROOT('QuoteSOAMCHdr'))

	END

	SELECT @QuoteSOAMCHdr
    
	
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

  --,[QuoteSOAMCHdr].[ItemProjectName]
	   --   ,[QuoteSOAMCHdr].[ItemExpectedClosingDate]
	   --   ,[QuoteSOAMCHdr].[QuoteSOItemEmailId]
    --      ,[QuoteSOAMCHdr].[ItemDeliveryBy]
	      

    --      ,[QuoteSOAMCHdr].[QuoteSOItemValidity]
    --      ,[QuoteSOAMCHdr].[QuoteSOItemPaymentTerms]
	   --   ,[QuoteSOAMCHdr].[ItemGSTExempted]
	   --   ,[QuoteSOAMCHdr].[ItemProductCount]
		  --,[QuoteSOAMCHdr].[QuoteSOItemStatus]

		  --,[QuoteSOAMCHdr].[CreatedUserId]