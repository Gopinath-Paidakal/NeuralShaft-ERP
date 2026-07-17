USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStocksInwardById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetStocksInwardById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStocksInwardById]
(
    @StocksInwardHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @StocksInwardHdr   NVARCHAR(MAX)
DECLARE @StocksInwardDtl   NVARCHAR(MAX)
DECLARE @StocksInward      NVARCHAR(MAX)

BEGIN TRY

    
    SET @StocksInwardHdr = (
      SELECT  
              [StocksInwardHdrId]
              --,[CompanyId]
              --,[BranchId]
              ,[VendorHdrId]
              ,[WareHouseId]
              ,[EmpId]
              ,[StockInwardType]

              ,[StockInwardNo]
              ,[StockInwardSLNo]
              ,[StockInwardDate]
              ,[InvoiceNo]
              ,[InvoiceDate]
              ,[DCNo]

              ,[OrderNo]
              ,[PONo]
              ,[ESugamNo]
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

        WHERE StocksInwardHdrId = @StocksInwardHdrId
        FOR JSON PATH
    )

    SET @StocksInwardDtl = (

           SELECT 
               [StocksInwardDtlId]
              ,[StocksInwardHdrId]
              ,[ItemId]
              ,[ItemDescription]

              ,[ItemQty]
              ,[InwardQty]
              ,[AcceptedQty]
              
              ,[ItemRate]

              ,[ItemAmount]
              ,[ItemDiscountPercentage]
              ,[ItemDiscountAmount]
              ,[TaxPercentage]
              ,[TaxAmount]
              ,[ItemTotalAmount]

              ,[CreatedUserId]
              ,[CreatedDate]
              ,[ModifiedUserId]
              ,[ModifiedDate]

        FROM [dbo].[StocksInwardDtl]
        WHERE StocksInwardHdrId = @StocksInwardHdrId
        FOR JSON PATH    
    )

   

    SET @StocksInward = (
        SELECT
            JSON_QUERY(@StocksInwardHdr)  AS StocksInwardHdr,
            JSON_QUERY(@StocksInwardDtl) AS  StocksInwardDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @StocksInward

END TRY

BEGIN CATCH
    DECLARE
        @ErrMsg       VARCHAR(4000),
        @ErrSeverity  INT,
        @ErrProcedure VARCHAR(100)
    SET @ErrMsg       = ERROR_MESSAGE()
    SET @ErrSeverity  = ERROR_SEVERITY()
    SET @ErrProcedure = ERROR_PROCEDURE()
    SET @ErrMsg       = @ErrMsg + ' / ' + ISNULL(@ErrProcedure, '')
    RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH