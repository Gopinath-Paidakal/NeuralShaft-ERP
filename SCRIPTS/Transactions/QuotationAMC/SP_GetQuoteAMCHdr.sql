USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteAMCHdr]    Script Date: 20/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteAMCHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteAMCHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteAMCHdr]    Script Date: 20/07/2026  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteAMCHdr]

(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

    
	SELECT
(
        SELECT 
		
		  [QuoteAMCHdr].[QuoteAMCHdrId]
          --,[CompanyId]
          --,[BranchId]
        
		  ,[QuoteAMCHdr].[OrdClientHdrId]
          ,[QuoteAMCHdr].[QuoteAMCNo]
           --[QuoteHdr].[QuoteDate]
	      ,FORMAT(QuoteAMCDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
          ,[QuoteAMCHdr].[QuoteAMCSlNo]

	      ,[QuoteAMCHdr].[QuoteAMCConsultant]
          ,[QuoteAMCHdr].[QuoteAMCCustComp]
		  --,[QuoteAMCHdr].[QuoteAMCBillingAddr]
          ,[QuoteAMCHdr].[QuoteAMCContPerson]
          ,[QuoteAMCHdr].[QuoteAMCMobileNo]

	      --,[QuoteAMCHdr].[QuoteAMCProjectName]
	      ,[QuoteAMCHdr].[AMCExpectedClosingDate]
	      ,[QuoteAMCHdr].[QuoteAMCEmailId]
          ,[QuoteAMCHdr].[QuoteAMCDeliveryInDays]
	      

          ,[QuoteAMCHdr].[QuoteAMCValidity]
          ,[QuoteAMCHdr].[QuoteAMCPaymentTerms]
	      ,[QuoteAMCHdr].[QuoteAMCGSTExempted]
	      
		  ,[QuoteAMCHdr].[QuoteAMCRenewalCount]
		  --,[QuoteAMCHdr].[QuoteAMCRevisionNo]
		  ,[QuoteAMCHdr].[QuoteAMCStartDate]
	      ,[QuoteAMCHdr].[QuoteAMCEndDate]

		  ,[QuoteAMCHdr].[QuoteAMCStatus]

		  ,[QuoteAMCHdr].[CreatedUserId]

		  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
		  ,[Employee].[EmpMobileNo]

		  ,[QuoteAMCHdr].[CreatedDate]

		  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteAMCHdr.QuoteAMCValidity AS INT), QuoteAMCHdr.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


	    FROM [dbo].[QuoteAMCHdr]
		--INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
		INNER JOIN [Employee] ON [Employee].EmpId = [QuoteAMCHdr].[CreatedUserId]

	    
		WHERE [QuoteAMCHdr].[QuoteAMCDate] >= @FromDate AND [QuoteAMCHdr].[QuoteAMCDate] < DATEADD(DAY, 1, @ToDate)
	    
		Order by [QuoteAMCHdr].[QuoteAMCNo]
		 
	    FOR JSON PATH, ROOT('QuoteAMCHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER


    ) AS QuoteAMCHdr

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

