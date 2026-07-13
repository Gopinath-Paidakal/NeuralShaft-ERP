USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDeliveryChallan]    Script Date: 11/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDeliveryChallan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetDeliveryChallan]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDeliveryChallan]    Script Date: 11/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetDeliveryChallan]
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
			  [DCHdrId]
			  --,[SOHdr].[SOHdrId]
			  ,[OrdClientHdr].[OrdClientHdrId]
			  --,[EmpId]
			  ,[DCType]
			 -- ,[DCNo]
			  ,[DCSLNo]
			  
			  --,[DCInvDate]
			  ,FORMAT(DCDate, 'dd-MM-yyyy') as DCDate

			  --,[DeliveryAddress]
     --         ,[DeliveryContactPerson]
     --         ,[DeliveryMobileId]
			  
     --         ,[OrdClientPONo]
     --         ,[OrdClientPODate]

			  --,[DCProductAmount]
			  --,[DCDiscountPercentage]
			  --,[DCDiscountAmount]
			  --,[DCTaxPercentage]
			  
			  --,[ItemTotalAmount]
			  --,[DCSubTotal]
			  --,[DCTaxAmount]
			  ,[DCGrandTotal]

			  ,[SOHdr].[SOConsultant]
			  ,[SOHdr].[SOContPerson]
			  ,[SOHdr].[SOCustComp]


			  --,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]

			FROM [dbo].[DeliveryChallanHdr]		
			INNER JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [DeliveryChallanHdr].[SOHdrId]
			INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [DeliveryChallanHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [DeliveryChallanHdr].[DCDate] >= @FromDate AND [DeliveryChallanHdr].[DCDate] < DATEADD(DAY, 1, @ToDate)

			Order by [DeliveryChallanHdr].[DCNo]

		
			FOR JSON PATH, ROOT('DeliveryChallanHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS DeliveryChallanHdr

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