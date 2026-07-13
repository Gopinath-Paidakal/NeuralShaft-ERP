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

DECLARE @ProformaInvUpdate NVARCHAR(MAX)

BEGIN TRY

    
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

    SET @ProformaInvHdr = (
        SELECT [ProformaInvHdrId]
              ,[CompanyId]
              ,[ProformaInvHdr].[BranchId]
              ,[SOHdrId]
              ,[OrdClientHdrId]
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
              
              ,[ProformaProductAmount]
              ,[ProformaDiscountPercentage]
              ,[ProformaDiscountAmount]
              ,[ProformaTaxPercentage]
              ,[ItemTotalAmount]
              
              ,[ProformaSubTotal]
              ,[ProformaTaxAmount]
              ,[ProformaGrandTotal]

              ,[Employee].EmpFirstName + ' ' + [Employee].EmpFirstName as 'EmpName'
        
        FROM [dbo].[ProformaInvHdr]
        INNER JOIN [Employee] On [Employee].EmpId = [ProformaInvHdr].[EmpId]
        WHERE ProformaInvHdrId = @ProformaInvHdrId
        FOR JSON PATH
    )


    SET @ProformaInvDtl = (
        SELECT [ProformaInvDtlId]
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
          ,[CreatedUserId]
          ,[CreatedDate]
          ,[ModifiedUserId]
          ,[ModifiedDate]

        FROM [dbo].[ProformaInvDtl]
        WHERE ProformaInvHdrId = @ProformaInvHdrId
        FOR JSON PATH
    )

    SET @ProformaInvUpdate = (
        SELECT
            JSON_QUERY(@ProformaInvHdr) AS ProformaInvHdr,
            JSON_QUERY(@ProformaInvDtl) AS ProformaInvDtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @ProformaInvUpdate

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
