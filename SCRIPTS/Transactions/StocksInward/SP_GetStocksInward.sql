USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStocksInward]    Script Date: 16/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStocksInward]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetStocksInward]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStocksInward]    Script Date: 16/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetStocksInward]
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
              [StocksInwardHdrId]
              --,[CompanyId]
              --,[BranchId]
              ,[StocksInwardHdr].[VendorHdrId]
              ,[VendorHdr].[VendorName]
              --,[WareHouseId]
              ,[Employee].[EmpId]
              ,[Employee].[EmpFirstName]

               [StockInwardType]
              ,[StockInwardNo]
              ,[StockInwardSLNo]
              --,[StockInwardDate]
              ,FORMAT([StockInwardDate], 'dd-MM-yyyy') as [StockInwardDate]

              ,[InvoiceNo]
              --,[InvoiceDate]
              ,FORMAT([InvoiceDate], 'dd-MM-yyyy') as [InvoiceDate]

              --,[OrderNo]
              --,[PONo]
              --,[ESugamNo]
              
              ,[TransportName]
              ,[VehicleType]
              ,[VehicleNo]
              
              ,[ContactPerson]
              ,[ContactMobile]
              ,[ContactEmailId]
              ,[CreditDate]
              
              --,[SIProductAmount]
              --,[SIDiscountPercentage]
              --,[SIDiscountAmount]
              --,[SITaxPercentage]
              --,[ItemTotalAmount]
              --,[SISubTotal]
              --,[SITaxAmount]
              --,[SIGrandTotal]
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]


            FROM [dbo].[StocksInwardHdr]

			INNER JOIN [Employee] ON [Employee].EmpId = [StocksInwardHdr].EmpId
			INNER JOIN [VendorHdr] ON [VendorHdr].VendorHdrId = [StocksInwardHdr].VendorHdrId
			--INNER JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [StocksInwardHdr].[SOHdrId]
			--INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [StocksInwardHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [StocksInwardHdr].[StockInwardDate] >= @FromDate AND [StocksInwardHdr].[StockInwardDate] < DATEADD(DAY, 1, @ToDate)

			Order by [StocksInwardHdr].[StockInwardNo]

		
			FOR JSON PATH, ROOT('StockInwardHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS StockInwardHdr

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

 


		
