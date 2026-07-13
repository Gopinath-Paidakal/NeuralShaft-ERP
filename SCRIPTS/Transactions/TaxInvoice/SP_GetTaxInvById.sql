USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetTaxInvById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetTaxInvById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetTaxInvById]
(
    @TaxInvHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @TaxInvHdr   NVARCHAR(MAX)
DECLARE @TaxInvDtl   NVARCHAR(MAX)
DECLARE @TaxInv NVARCHAR(MAX)
BEGIN TRY

    
    SET @TaxInvHdr = (
        SELECT [TaxInvHdrId]
              ,[SOHdrId]
              ,[OrdClientHdrId]
              ,[EmpId]
              ,[TaxInvType]
              ,[TaxInvNo]
              ,[TaxInvSLNo]

              ,[DeliveryAddress]
              ,[DeliveryContactPerson]
              ,[DeliveryMobileId]

              ,[OrdClientPONo]
              ,[OrdClientPODate]
              ,[TaxInvRemarks]

              ,[TaxInvDate]
              ,[TaxInvProductAmount]
              ,[TaxInvDiscountPercentage]
              ,[TaxInvDiscountAmount]
              ,[TaxInvTaxPercentage]
              
              ,[ItemTotalAmount]
              ,[TaxInvSubTotal]
              ,[TaxInvTaxAmount]
              ,[TaxInvGrandTotal]
              
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]

        FROM [dbo].[TaxInvHdr]
        WHERE TaxInvHdrId = @TaxInvHdrId
        FOR JSON PATH
    )

    SET @TaxInvDtl = (
                SELECT [TaxInvDtlId]
              ,[TaxInvHdrId]
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

              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]
        FROM [dbo].[TaxInvDtl]
        WHERE TaxInvHdrId = @TaxInvHdrId
        FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    )

   

    SET @TaxInv = (
        SELECT
            JSON_QUERY(@TaxInvHdr)  AS TaxInvHdr,
            JSON_QUERY(@TaxInvDtl) AS  TaxInvDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @TaxInv

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