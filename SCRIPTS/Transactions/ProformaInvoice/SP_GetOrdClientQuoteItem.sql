USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetOrdClientQuoteItem]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetOrdClientQuoteItem]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetOrdClientQuoteItem]
(
    @ItemQuoteHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
--DECLARE @OrdClientHdr   NVARCHAR(MAX)
--DECLARE @OrdClientAddr  NVARCHAR(MAX)
--DECLARE @SOHdr NVARCHAR(MAX)
DECLARE @QuoteDtlItem NVARCHAR(MAX)
DECLARE @ProformaInvQuoteDtlItem NVARCHAR(MAX)
BEGIN TRY

    SET @QuoteDtlItem = (
            
            SELECT [QuoteItemDtlId]
              ,[QuoteHdrItem].[ItemQuoteHdrId]

              ,[ItemName]
              ,[ItemId]
              ,[ItemHSNCode]
              ,[ItemCode]

              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]
              ,[ItemAmount]
              ,[ItemDiscountAmount]
              
              ,[ItemDiscountPercentage]
              ,[ItemTaxValue]
              ,[ItemTotalAmount]

              --,[CrudType]
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]

            FROM [dbo].[QuoteDtlItem]


            INNER JOIN dbo.[QuoteHdrItem] ON [QuoteHdrItem].[ItemQuoteHdrId] = [QuoteDtlItem].[ItemQuoteHdrId]

            WHERE QuoteHdrItem.ItemQuoteHdrId = @ItemQuoteHdrId

        FOR JSON PATH
    )


    SET @ProformaInvQuoteDtlItem = (
        SELECT
            JSON_QUERY(@QuoteDtlItem) AS QuoteDtlItem
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @ProformaInvQuoteDtlItem

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