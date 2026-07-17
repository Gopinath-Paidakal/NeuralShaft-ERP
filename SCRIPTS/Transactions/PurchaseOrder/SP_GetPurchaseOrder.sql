USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPurchaseOrder]    Script Date: 16/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPurchaseOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetPurchaseOrder]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPurchaseOrder]    Script Date: 16/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetPurchaseOrder]
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

	SELECT [PurchaseOrderHdrId]
			  --,[CompanyId]
			  --,[BranchId]
			  --,[SOHdrId]
			  --,[OrdClientHdrId]

			  ,[Employee].[EmpId]
			  ,[Employee].EmpFirstName

			  ,[PurchaseOrderHdr].[VendorHdrId]
			  ,[VendorHdr].VendorName

			  ,[POType]
			  ,[PONo]
			  ,[POSLNo]
			  ,FORMAT(PODate, 'dd-MM-yyyy') as PODate

			,[QuoteNo]

			--,[BillingAddress]
			--,[DeliveryAddress]
			,[DeliveryContactPerson]
			,[DeliveryMobileId]
			--,[ProformaInvoiceNo]
			  
			--,[ProformaInvoiceDate]
			--,[OrdClientPONo]
			--,[OrdClientPODate]
			--,[PORemarks]

			  --,[POProductAmount]
			  --,[PODiscountPercentage]
			  --,[PODiscountAmount]
			  --,[POTaxPercentage]
			  --,[ItemTotalAmount]
			  --,[POSubTotal]
			  --,[POTaxAmount]
			  ,[POGrandTotal]

			  --,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]

			  --,[SOHdr].[SOConsultant]
			  --,[SOHdr].[SOContPerson]
			  --,[SOHdr].[SOCustComp]

			FROM [dbo].[PurchaseOrderHdr]
			INNER JOIN [Employee] ON [Employee].EmpId = [PurchaseOrderHdr].EmpId
			INNER JOIN [VendorHdr] ON [VendorHdr].VendorHdrId = [PurchaseOrderHdr].VendorHdrId
			--INNER JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [PurchaseOrderHdr].[SOHdrId]
			--INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [PurchaseOrderHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [PurchaseOrderHdr].[PODate] >= @FromDate AND [PurchaseOrderHdr].[PODate] < DATEADD(DAY, 1, @ToDate)

			Order by [PurchaseOrderHdr].[PONo]

		
			FOR JSON PATH, ROOT('POHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS POHdr

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

 


		
