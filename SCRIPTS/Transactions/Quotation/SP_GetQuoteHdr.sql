USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteHdr]    Script Date: 11/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteHdr]    Script Date: 11/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteHdr]
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
        SELECT [QuoteHdrId]
          --,[CompanyId]
          --,[BranchId]
          ,[QuoteHdr].[EnqHdrId]
		  ,[EnqHdr].[EnqNo]
          ,[QuoteHdr].[QuoteNo]
           --[QuoteHdr].[QuoteDate]
	      ,FORMAT(QuoteDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
          ,[QuoteHdr].[QuoteSlNo]

	      ,[QuoteHdr].[QuoteConsultant]
		  ,[QuoteHdr].[QuoteClientSalutation]
          ,[QuoteHdr].[QuoteCustComp]
		  ,[QuoteHdr].[QuoteBillingAddr]
          ,[QuoteHdr].[QuoteContPerson]

          ,[QuoteHdr].[QuoteMobileNo]
	      ,[QuoteHdr].[ProjectName]
	      ,[QuoteHdr].[ExpectedClosingDate]
	      ,[QuoteHdr].[QuoteEmailId]
          ,[QuoteHdr].[DeliveryBy]

	      ,[QuoteHdr].[ComplementaryAMC]
          ,[QuoteHdr].[QuoteValidity]
          ,[QuoteHdr].[QuotePaymentTerms]
	      ,[QuoteHdr].[GSTExempted]
	      ,[QuoteHdr].[ProductCount]

		  ,[QuoteHdr].[QuoteStatus]
		  ,[QuoteHdr].[QuoteContSalutation]
		  ,[QuoteHdr].[CreatedUserId]
		  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
		  ,[Employee].[EmpMobileNo]

		  ,[QuoteHdr].[CreatedDate]
		  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteHdr.QuoteValidity AS INT), QuoteHdr.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


	    FROM [dbo].[QuoteHdr]
		INNER JOIN [EnqHdr] ON [EnqHdr].EnqHdrId = [QuoteHdr].[EnqHdrId]
		INNER JOIN [Employee] ON [Employee].EmpId = [QuoteHdr].[CreatedUserId]

	    
		WHERE [QuoteHdr].[QuoteDate] >= @FromDate AND [QuoteHdr].[QuoteDate] < DATEADD(DAY, 1, @ToDate)
	    
		Order by [QuoteHdr].[QuoteNo]

	    FOR JSON PATH, ROOT('QuoteHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER


    ) AS QuoteHdr

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

--   ,[QuoteHdr].[QuoteAmount]
       --   ,[QuoteHdr].[QuoteTaxAmount]
       --   ,[QuoteHdr].[QuoteTotalAmount]

	   
    -- ProductDtlCount

	      --,[EnqClient].[EnqConsultant]
       --   ,[EnqClient].[EnqClientName]
       --   ,[EnqClient].[EnqClientMobileNo]
       --   ,[EnqClient].[EnqClientEmailId]
       --   ,[EnqClient].[EnqClientAddress]

       --   ,[EnqClient].[EnqClientCategory]
       --   ,[EnqClient].[EnqLeadSource]
       --   ,[EnqClient].[EnqSourceBy]
       --   ,[EnqClient].[EnqContactPerson]
	  

          --,[CreatedyBy]
          --,[CreatedDate]


  --INNER JOIN EnqHdr ON [QuoteHdr].EnqHdrId = EnqHdr.EnqHdrId 
	    --INNER JOIN EnqClient ON EnqHdr.EnqClientId = EnqClient.EnqClientId
	
	    ---WHERE [QuoteHdr].[QuoteDate] >= @FromDate AND [QuoteHdr].[QuoteDate] < DATEADD(DAY, 1, @ToDate)

	    --where [QuoteHdr].[QuoteDate] >= @FromDate and [QuoteHdr].[QuoteDate] < @ToDate

	    ---Order by [QuoteHdr].[QuoteNo]

	    --WHERE dbo.fn_FormatDate([QuoteHdr].[QuoteDate]) >= dbo.fn_FormatDate(@FromDate)
	    --and  dbo.fn_FormatDate([QuoteHdr].[QuoteDate]) <= dbo.fn_FormatDate(@ToDate)

   
	--WHERE EnqHdrId = @EnqHdrId

	--WHERE [QuoteHdr].QuoteDate >= cast(@FromDate as datetime)  
	--and  [QuoteHdr].QuoteDate <= cast(@ToDate as datetime) 