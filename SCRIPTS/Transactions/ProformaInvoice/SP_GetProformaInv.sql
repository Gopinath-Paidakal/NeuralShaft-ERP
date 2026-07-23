USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetProformaInv]    Script Date: 10/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetProformaInv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetProformaInv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetProformaInv]    Script Date: 10/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetProformaInv]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20)
)

AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	-- GET ALL BRANCHES AS JSON
		  SELECT
		(

		SELECT 
			  [ProformaInvHdr].[ProformaInvHdrId]
			  --,[SOHdr].[SOHdrId]
			  --,[OrdClientHdr].[OrdClientHdrId]
			  ,[ProformaType]
			  --,[ProformaInvNo]
			  ,[ProformaInvSLNo]
			  
			  --,[ProformaInvDate]
			  ,FORMAT(ProformaInvDate, 'dd-MM-yyyy') as ProformaInvDate
			  ,[ProformaTotalAmount]

			  --- for SO Product
			  ,[SOHdr].[SOConsultant]
			  ,[SOHdr].[SOContPerson]
			  ,[SOHdr].[SOCustComp]
			  
			  --- for QuoteItem
			  ,[QuoteHdrItem].[ItemQuoteContPerson]
			  ,[QuoteHdrItem].[ItemQuoteCustComp]
			  ,[QuoteHdrItem].[ItemQuoteMobileNo]

			  --- for QuoteAMC
			  ,[QuoteAMCHdr].[QuoteAMCCustComp]
			  ,[QuoteAMCHdr].[QuoteAMCContPerson]
			  ,[QuoteAMCHdr].[QuoteAMCMobileNo]

			FROM [dbo].[ProformaInvHdr]	
			LEFT JOIN [QuoteHdrItem] ON [QuoteHdrItem].[ItemQuoteHdrId] = [ProformaInvHdr].[ItemQuoteHdrId]
			LEFT JOIN [QuoteAMCHdr] ON [QuoteAMCHdr].[QuoteAMCHdrId] = [QuoteAMCHdr].[QuoteAMCHdrId]
			LEFT JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [ProformaInvHdr].[SOHdrId]
			INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [ProformaInvHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [ProformaInvHdr].[ProformaInvDate] >= @FromDate AND [ProformaInvHdr].[ProformaInvDate] < DATEADD(DAY, 1, @ToDate)

			Order by [ProformaInvHdr].[ProformaInvNo]

		
			FOR JSON PATH, ROOT('ProformaInvHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS ProformaInvHdr

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


--,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]


			  			  --,[DeliveryAddress]
     --         ,[DeliveryContactPerson]
     --         ,[DeliveryMobileId]

			  --,[ProformaProductAmount]
			  --,[ProformaDiscountPercentage]
			  --,[ProformaDiscountAmount]
			  --,[ProformaTaxPercentage]
			  
			  --,[ItemTotalAmount]
			  --,[ProformaSubTotal]
			  --,[ProformaTaxAmount]