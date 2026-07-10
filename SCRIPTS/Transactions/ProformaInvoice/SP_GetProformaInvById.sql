USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetProformaInvById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetProformaInvById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetProformaInvById]
(
    @ProformaInvHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @ProformaInvHdr   NVARCHAR(MAX)
DECLARE @ProformaInvDtl   NVARCHAR(MAX)
DECLARE @ProformaInv NVARCHAR(MAX)
BEGIN TRY

    
    SET @ProformaInvHdr = (
        SELECT [ProformaInvHdrId]
              ,[SOHdrId]
              ,[OrdClientHdrId]
              ,[ProformaType]
              ,[ProformaInvNo]
              ,[ProformaInvSLNo]

              ,[DeliveryAddress]
              ,[DeliveryContactPerson]
              ,[DeliveryMobileId]

              ,[ProformaInvDate]
              ,[ProformaProductAmount]
              ,[ProformaDiscountPercentage]
              ,[ProformaDiscountAmount]
              ,[ProformaTaxPercentage]
              
              ,[ItemTotalAmount]
              ,[ProformaSubTotal]
              ,[ProformaTaxAmount]
              ,[ProformaGrandTotal]
              
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]

        FROM [dbo].[ProformaInvHdr]
        WHERE ProformaInvHdrId = @ProformaInvHdrId
        FOR JSON PATH
    )

    SET @ProformaInvDtl = (
                SELECT [ProformInvDtlId]
              ,[ProformaInvHdrId]
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
        FROM [dbo].[ProformaInvDtl]
        WHERE ProformaInvHdrId = @ProformaInvHdrId
        FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    )

   

    SET @ProformaInv = (
        SELECT
            JSON_QUERY(@ProformaInvHdr)  AS ProformaInvHdr,
            JSON_QUERY(@ProformaInvDtl) AS  ProformaInvDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @ProformaInv

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