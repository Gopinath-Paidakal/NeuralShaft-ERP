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
--DECLARE @OrdClientHdr   NVARCHAR(MAX)
--DECLARE @OrdClientAddr  NVARCHAR(MAX)

DECLARE @ProformaInvHdr NVARCHAR(MAX)
DECLARE @ProformaInvDtl NVARCHAR(MAX)
DECLARE @ProformaInv NVARCHAR(MAX)

DECLARE @ProformaType NVARCHAR(100)
DECLARE @ItemQuoteHdrId INT
DECLARE @QuoteAMCHdrId INT

BEGIN TRY

    SET @ProformaType = (Select ProformaType from ProformaInvHdr where ProformaInvHdrId = @ProformaInvHdrId)
    SET @ItemQuoteHdrId = (Select ItemQuoteHdrId from ProformaInvHdr where ProformaInvHdrId = @ProformaInvHdrId)
    SET @QuoteAMCHdrId = (Select QuoteAMCHdrId from ProformaInvHdr where ProformaInvHdrId = @ProformaInvHdrId)

    --SELECT @ProformaType, @ItemQuoteHdrId, @QuoteAMCHdrId

    SET @ProformaInvHdr = (
        SELECT 
               [ProformaInvHdr].[ProformaInvHdrId]
              ,[SOHdrId]
              ,[ProformaInvHdr].[OrdClientHdrId]
              ,[ProformaInvHdr].[ItemQuoteHdrId]
              ,[ProformaInvHdr].[QuoteAMCHdrId]

              ,[QuoteHdrItem].[ItemQuoteNo]
              ,[QuoteHdrItem].[ItemQuoteSlNo]

              ,[QuoteAMCHdr].[QuoteAMCNo]
              ,[QuoteAMCHdr].[QuoteAMCSlNo]

              ,[ProformaInvHdr].[EmpId]

              ,[ProformaType]
              ,[ProformaInvNo]
              ,[ProformaInvSLNo]
              ,[ProformaInvDate]
              ,[BillingAddress]
              ,[DeliveryAddress]
              
              ,[DeliveryContactPerson]
              ,[DeliveryMobileId]
              ,[OrdClientPONo]
              ,[OrdClientPODate]
              ,[ProformaInvRemarks]
              
              ,[ProformaItemAmount]
              ,[ProformaDiscountAmount]
              ,[ProformaTaxAmount]
              ,[ProformaTotalAmount]

              ,[Employee].EmpFirstName + ' ' + [Employee].EmpFirstName as 'EmpName'
        
        FROM [dbo].[ProformaInvHdr]
        INNER JOIN [Employee] On [Employee].EmpId = [ProformaInvHdr].[EmpId]
        LEFT JOIN [QuoteHdrItem] On [QuoteHdrItem].[ItemQuoteHdrId] = [ProformaInvHdr].[ItemQuoteHdrId]
        LEFT JOIN [QuoteAMCHdr] On [QuoteAMCHdr].[QuoteAMCHdrId] = [ProformaInvHdr].[QuoteAMCHdrId]

        WHERE [ProformaInvHdr].[ProformaInvHdrId] = @ProformaInvHdrId
        FOR JSON PATH
    )

    --=============================================================================
    -- Proforma Invoice Dtl will be selected from 3 dtl tables, product, spare, AMC
    -- and assigned to @ProformaInvDtl 
    -- ============================================================================

    if (@ProformaType = UPPER('QUOTE_SPARE'))
    BEGIN
         SET @ProformaInvDtl = (
            SELECT [QuoteItemDtlId]
              ,[ItemQuoteHdrId]
              ,[ItemId]
              ,[ItemName]
              ,[ItemHSNCode]
              ,[ItemCode]

              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]
              ,[ItemAmount]
              ,[ItemDiscountPercentage]

              ,[ItemDiscountAmount]
              ,[ItemTaxPercentage]
              ,[ItemTaxAmount]
              ,[ItemTotalAmount]
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]
          FROM [dbo].[QuoteDtlItem]

        WHERE ItemQuoteHdrId = @ItemQuoteHdrId
        FOR JSON PATH )
    END

    else if (@ProformaType = UPPER('QUOTE_AMC'))
        BEGIN
         SET @ProformaInvDtl = (
            SELECT [QuoteAMCDtlId]
              ,[QuoteAMCHdrId]
              ,[ItemId]
              ,[ItemName]
              ,[ItemHSNCode]
              ,[ItemCode]

              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]
              ,[ItemAmount]
              ,[ItemDiscountPercentage]
              
              ,[ItemDiscountAmount]
              ,[ItemTaxPercentage]
              ,[ItemTaxAmount]
              ,[ItemTotalAmount]

              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]

          FROM [dbo].[QuoteAMCDtl]

        WHERE QuoteAMCHdrId = @QuoteAMCHdrId
        FOR JSON PATH )
    END


    SET @ProformaInv = (
        SELECT
            JSON_QUERY(@ProformaInvHdr) AS ProformaInvHdr,
            JSON_QUERY(@ProformaInvDtl) AS ProformaInvDtl
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



--SET @ProformaInvDtl = (
    --    SELECT [ProformaInvDtlId]
    --      ,[ProformaInvHdrId]
    --      ,[ItemId]
    --      ,[ItemDescription]
    --      ,[ItemQty]
          
    --      ,[ItemRate]
    --      ,[ItemAmount]
    --      ,[ItemDiscountPercentage]
    --      ,[ItemDiscountAmount]
    --      ,[TaxPercentage]
    --      ,[TaxAmount]

    --      ,[ItemTotalAmount]
    --      ,[CreatedUserId]
    --      ,[CreatedDate]
    --      ,[ModifiedUserId]
    --      ,[ModifiedDate]

    --    FROM [dbo].[ProformaInvDtl]
    --    WHERE ProformaInvHdrId = @ProformaInvHdrId
    --    FOR JSON PATH
    --)

 --SET @OrdClientHdr = (
    --    SELECT

    --        OrdClientHdrId,
    --        ISNULL(OrdConsultant,   '') AS OrdConsultant,
    --        OrdClientTitle +  ' ' + OrdClientName as  'OrdClientName',
    --        --ISNULL(OrdClientTitle,  '') AS OrdClientTitle,

    --        ISNULL(OrdGstTradeName, '') AS OrdGstTradeName,
    --        ISNULL(OrdGstNo,        '') AS OrdGstNo,
    --        ISNULL(OrdClientStatus, '') AS OrdClientStatus

    --    FROM dbo.OrdClientHdr
    --    WHERE OrdClientHdrId = (Select OrdClientHdrId from ProformaInvHdr where ProformaInvHdrId = @ProformaInvHdrId)
    --    FOR JSON PATH
    --)

    --SET @OrdClientAddr = (
    --    SELECT
    --        ISNULL(OrdClientHdrId,          0) AS OrdClientHdrId,
    --        ISNULL(OrdClientAddrId,         0) AS OrdClientAddrId,
    --        ISNULL(OrdClientAddr1,         '') AS OrdClientAddr1,
    --        ISNULL(OrdClientAddr2,         '') AS OrdClientAddr2,
    --        ISNULL(OrdClientPostalCode,    '') AS OrdClientPostalCode,
    --        ISNULL(OrdClientState,         '') AS OrdClientState,

    --        ISNULL(OrdClientCity,          '') AS OrdClientCity,
    --        ISNULL(OrdClientPhNo,          '') AS OrdClientPhNo,
    --        ISNULL(OrdClientCompanyMailId, '') AS OrdClientCompanyMailId,
    --        ISNULL(OrdClientWebsite,       '') AS OrdClientWebsite,
    --        --ISNULL(OrdClientPan,           '') AS OrdClientPan,

    --        ISNULL(OrdClientGstNo,         '') AS OrdClientGstNo,
    --        ISNULL(OrdClientAdhaarNo,      '') AS OrdClientAdhaarNo,
    --        ISNULL(OrdClientAddrType,      '') AS OrdClientAddrType,
    --        --ISNULL(OrdClientPriSalutation, '') AS OrdClientPriSalutation,
    --        ISNULL(OrdClientPriContPerson, '') AS OrdClientPriContPerson,

    --        ISNULL(OrdClientPriMailId,     '') AS OrdClientPriMailId,
    --        ISNULL(OrdClientPriMobileNo,   '') AS OrdClientPriMobileNo
    --        --ISNULL(OrdClientSecSalutation, '') AS OrdClientSecSalutation,
    --        --ISNULL(OrdClientSecContPerson, '') AS OrdClientSecContPerson,
    --        --ISNULL(OrdClientSecMailId,     '') AS OrdClientSecMailId,

    --        --ISNULL(OrdClientSecMobileNo,   '') AS OrdClientSecMobileNo,
    --        --ISNULL(OrdClientLatitude,      '') AS OrdClientLatitude,
    --        --ISNULL(OrdClientLongitude,     '') AS OrdClientLongitude,
    --        --ISNULL(OrdClientTravelDistance,'') AS OrdClientTravelDistance,
    --        --ISNULL(OrdStatus,              '') AS OrdStatus


    --    FROM dbo.OrdClientAddr
    --    WHERE OrdClientHdrId = (Select OrdClientHdrId from ProformaInvHdr where ProformaInvHdrId = @ProformaInvHdrId)
    --    FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    --)
 --JSON_QUERY(@OrdClientHdr)  AS OrdClientHdr,
            --JSON_QUERY(@OrdClientAddr) AS OrdClientAddr,

--,[CompanyId]
              --,[BranchId]
              --,[EnqHdrId]
              --,[QuoteHdrId]
              --,[OrdClientHdrId]
              --,[OrdClientAddrId]
  --,[SOBillingAddr]
              --,[SOContPerson]
              --,[SOMobileNo]
              --,[ProjectName]
              --,[ExpectedClosingDate]
              --,[SOEmailId]
              --,[DeliveryBy]
              --,[QuoteValidity]
              --,[ComplementaryAMC]
              --,[GSTExempted]
              --,[SOPaymentTerms]
              --,[OrdAmount]
              --,[OrdSubTotal]
              --,[OrdTax]
              --,[OrdTotalAmount]
              --,[OrdAdvance]
              --,[OrdPayments]
              --,[OrdStatus]
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]
