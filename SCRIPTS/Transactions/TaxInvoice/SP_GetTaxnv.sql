USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTaxnv]    Script Date: 11/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetTaxnv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetTaxnv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTaxnv]    Script Date: 11/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetTaxnv]
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
			  [TaxInvHdrId]
			  ,[SOHdr].[SOHdrId]
			  ,[OrdClientHdr].[OrdClientHdrId]
			  ,[TaxInvType]
			  ,[TaxInvNo]
			  ,[TaxInvSLNo]
			  
			  --,[TaxInvInvDate]
			  ,FORMAT(TaxInvDate, 'dd-MM-yyyy') as TaxInvDate

			  ,[DeliveryAddress]
              ,[DeliveryContactPerson]
              ,[DeliveryMobileId]

			  ,[TaxInvProductAmount]
			  ,[TaxInvDiscountPercentage]
			  ,[TaxInvDiscountAmount]
			  ,[TaxInvTaxPercentage]
			  
			  ,[ItemTotalAmount]
			  ,[TaxInvSubTotal]
			  ,[TaxInvTaxAmount]
			  ,[TaxInvGrandTotal]

			  ,[SOHdr].[SOConsultant]
			  ,[SOHdr].[SOContPerson]
			  ,[SOHdr].[SOCustComp]
			  --,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]

			FROM [dbo].[TaxInvHdr]		
			INNER JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [TaxInvHdr].[SOHdrId]
			INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [TaxInvHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [TaxInvHdr].[TaxInvDate] >= @FromDate AND [TaxInvHdr].[TaxInvDate] < DATEADD(DAY, 1, @ToDate)

			Order by [TaxInvHdr].[TaxInvNo]

		
			FOR JSON PATH, ROOT('TaxInvHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS TaxInvHdr

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