USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetVendorById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetVendorById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetVendorById]
(
    @VendorHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @VendorHdr   NVARCHAR(MAX)
DECLARE @VendorDtl  NVARCHAR(MAX)
DECLARE @Vendor NVARCHAR(MAX)
BEGIN TRY

    
    SET @VendorHdr = (
        SELECT

            VendorHdrId,
            ISNULL(VendorTitle,  '') AS VendorTitle,
            ISNULL(VendorName,   '') AS VendorName,
            ISNULL(VendorGstTradeName, '') AS OrdGstTradeName,
            ISNULL(VendorGstNo,        '') AS OrdGstNo,
            ISNULL(VendorCreditLimit, '') AS VendorCreditLimit,
            ISNULL(VendorStatus, '') AS VendorStatus

        FROM dbo.VendorHdr
        WHERE VendorHdrId = @VendorHdrId
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    SET @VendorDtl = (
        SELECT
            ISNULL(VendorDtlId,          0) AS VendorDtlId,
            ISNULL(VendorHdrId,          0) AS VendorHdrId,

            ISNULL(VendorAddrType,         0) AS VendorType,
            ISNULL(VendorAddr1,         '') AS VendorAddr1,
            ISNULL(VendorAddr2,         '') AS VendorAddr2,
            ISNULL(VendorPostalCode,    '') AS VendorPostalCode,
            ISNULL(VendorState,         '') AS VendorState,

            ISNULL(VendorCity,          '') AS VendorCity,
            ISNULL(VendorPhNo,          '') AS VendorPhNo,
            ISNULL(VendorCompanyMailId, '') AS VendorCompanyMailId,
            ISNULL(VendorWebsite,       '') AS VendorWebsite,
            ISNULL(VendorPan,           '') AS VendorPan,

            ISNULL(VendorGstNo,         '') AS VendorGstNo,
            ISNULL(VendorAdhaarNo,      '') AS VendorAdhaarNo,
            ISNULL(VendorAddrType,      '') AS VendorAddrType,
            ISNULL(VendorPriSalutation, '') AS VendorPriSalutation,
            ISNULL(VendorPriContPerson, '') AS VendorPriContPerson,

            ISNULL(VendorPriMailId,     '') AS VendorPriMailId,
            ISNULL(VendorPriMobileNo,   '') AS VendorPriMobileNo,
            ISNULL(VendorSecSalutation, '') AS VendorSecSalutation,
            ISNULL(VendorSecContPerson, '') AS VendorSecContPerson,
            ISNULL(VendorSecMailId,     '') AS VendorSecMailId,

            ISNULL(VendorSecMobileNo,   '') AS VendorSecMobileNo,
            ISNULL(VendorLatitude,      '') AS VendorLatitude,
            ISNULL(VendorLongitude,     '') AS VendorLongitude,
            ISNULL(VendorTravelDistance,'') AS VendorTravelDistance,
            ISNULL(VendorDtlStatus, '') AS VendorDtlStatus


        FROM dbo.VendorDtl
        WHERE VendorHdrId = @VendorHdrId
        FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    )

    SET @Vendor = (
        SELECT
            JSON_QUERY(@VendorHdr)  AS VendorHdr,
            JSON_QUERY(@VendorDtl) AS VendorDtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @Vendor

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