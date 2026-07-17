USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPurchaseOrderById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetPurchaseOrderById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetPurchaseOrderById]
(
    @PurchaseOrderHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @PurchaseOrderHdr   NVARCHAR(MAX)
DECLARE @PurchaseOrderDtl   NVARCHAR(MAX)
DECLARE @PurchaseOrder      NVARCHAR(MAX)

BEGIN TRY

    
    SET @PurchaseOrderHdr = (
       SELECT [PurchaseOrderHdrId]
            --,[CompanyId]
            --,[BranchId]
            --,[SOHdrId]
            ,[EmpId]
            ,[VendorHdrId]
            ,[POType]
            --,[PONo]
            --,[POSLNo]
            --,[PODate]
           -- ,[QuoteNo]
            ,[BillingAddress]
            ,[DeliveryAddress]
            ,[DeliveryContactPerson]
            ,[DeliveryMobileId]
            ,[ProformaInvoiceNo]
            ,[ProformaInvoiceDate]
            ,[PORemarks]

            ,[PODeliveryTerms]

            --,[POProductAmount]
            --,[PODiscountPercentage]
            --,[PODiscountAmount]
            --,[POTaxPercentage]
            --,[ItemTotalAmount]
            --,[POSubTotal]
            --,[POTaxAmount]
            --,[POGrandTotal]
            --,[CreatedUserId]
            --,[CreatedDate]
            --,[ModifiedUserId]
            --,[ModifiedDate]

    FROM [dbo].[PurchaseOrderHdr]
        WHERE PurchaseOrderHdrId = @PurchaseOrderHdrId
        FOR JSON PATH
    )

    SET @PurchaseOrderDtl = (

           SELECT [PurchaseOrderDtlId]
              ,[PurchaseOrderHdrId]
              ,[ItemId]
              ,[ItemDescription]
              ,[ItemQty]
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

        FROM [dbo].[PurchaseOrderDtl]
        WHERE PurchaseOrderHdrId = @PurchaseOrderHdrId
        FOR JSON PATH    
    )
   

    SET @PurchaseOrder = (
        SELECT
            JSON_QUERY(@PurchaseOrderHdr)  AS PurchaseOrderHdr,
            JSON_QUERY(@PurchaseOrderDtl) AS  PurchaseOrderDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @PurchaseOrder

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