USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDeliveryChallanById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetDeliveryChallanById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetDeliveryChallanById]
(
    @DCHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @DCHdr   NVARCHAR(MAX)
DECLARE @DCDtl   NVARCHAR(MAX)
DECLARE @DC NVARCHAR(MAX)
BEGIN TRY

    
    SET @DCHdr = (
        SELECT [DCHdrId]
              ,[SOHdrId]
              ,[OrdClientHdrId]
              ,[EmpId]
              ,[DCType]
              ,[DCNo]
              ,[DCSLNo]

              ,[DeliveryAddress]
              ,[DeliveryContactPerson]
              ,[DeliveryMobileId]

              ,[OrdClientPONo]
              ,[OrdClientPODate]
              ,[DCRemarks]

              ,[DCDate]
              ,[DCProductAmount]
              ,[DCDiscountPercentage]
              ,[DCDiscountAmount]
              ,[DCTaxPercentage]
              
              ,[ItemTotalAmount]
              ,[DCSubTotal]
              ,[DCTaxAmount]
              ,[DCGrandTotal]
              
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]

        FROM [dbo].[DeliveryChallanHdr]
        WHERE DCHdrId = @DCHdrId
        FOR JSON PATH
    )

    SET @DCDtl = (
                SELECT [DCDtlId]
              ,[DCHdrId]
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
        FROM [dbo].[DeliveryChallanDtl]
        WHERE DCHdrId = @DCHdrId
        FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    )

   

    SET @DC = (
        SELECT
            JSON_QUERY(@DCHdr)  AS DCHdr,
            JSON_QUERY(@DCDtl) AS  DCDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @DC

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