USE [NSERPLIVE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateVendorDtl]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateVendorDtl]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateVendorDtl]
(
    @VendorDtlId  int,
    @VendorDtl NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    UPDATE T
    SET
        T.VendorAddr1            = S.VendorAddr1,
        T.VendorAddr2            = S.VendorAddr2,
        T.VendorPostalCode       = S.VendorPostalCode,
        T.VendorState            = S.VendorState,

        T.VendorCity             = S.VendorCity,
        T.VendorPhNo             = S.VendorPhNo,
        T.VendorCompanyMailId    = S.VendorCompanyMailId,
        T.VendorWebsite          = S.VendorWebsite,
        T.VendorPan              = S.VendorPan,

        T.VendorGstNo            = S.VendorGstNo,
        T.VendorAdhaarNo         = S.VendorAdhaarNo,
        T.VendorAddrType         = S.VendorAddrType,
        T.VendorPriSalutation    = S.VendorPriSalutation,
        T.VendorPriContPerson    = S.VendorPriContPerson,

        T.VendorPriMailId        = S.VendorPriMailId,
        T.VendorPriMobileNo      = S.VendorPriMobileNo,
        T.VendorSecSalutation    = S.VendorSecSalutation,
        T.VendorSecContPerson    = S.VendorSecContPerson,
        T.VendorSecMailId        = S.VendorSecMailId,

        T.VendorSecMobileNo      = S.VendorSecMobileNo,
        T.VendorLatitude         = S.VendorLatitude,
        T.VendorLongitude        = S.VendorLongitude,
        T.VendorTravelDistance   = S.VendorTravelDistance
        --T.VendorDtlStatus        = S.VendorDtlStatus

    FROM dbo.VendorDtl T
    INNER JOIN OPENJSON(@VendorDtl, '$.VendorDtl')
    WITH
    (
        -- REQUIRED KEY FOR UPDATE
        VendorDtlId INT,
        VendorHdrId INT,

        VendorAddr1 NVARCHAR(100),
        VendorAddr2 NVARCHAR(100),
        VendorPostalCode NVARCHAR(100),
        VendorState NVARCHAR(100),

        VendorCity NVARCHAR(100),
        VendorPhNo NVARCHAR(100),
        VendorCompanyMailId NVARCHAR(100),
        VendorWebsite NVARCHAR(100),
        VendorPan NVARCHAR(100),

        VendorGstNo NVARCHAR(100),
        VendorAdhaarNo NVARCHAR(100),
        VendorAddrType NVARCHAR(100),
        VendorPriSalutation NVARCHAR(15),
        VendorPriContPerson NVARCHAR(100),

        VendorPriMailId NVARCHAR(100),
        VendorPriMobileNo NVARCHAR(100),
        VendorSecSalutation NVARCHAR(15),
        VendorSecContPerson NVARCHAR(100),
        VendorSecMailId NVARCHAR(100),

        VendorSecMobileNo NVARCHAR(100),
        VendorLatitude NVARCHAR(100),
        VendorLongitude NVARCHAR(100),
        VendorTravelDistance NVARCHAR(100),
        OrdStatus NVARCHAR(10)

    ) S
    ON T.VendorDtlId = @VendorDtlId     --- S.VendorDtlId;

    --  Return same ID (fixed field name)
    --SELECT 
    ---    JSON_VALUE(@VendorDtl, '$.VendorDtl[0].VendorDtlId') AS VendorHdrId;

    SELECT @VendorDtlId
    COMMIT TRANSACTION

END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION

    DECLARE 
        @ErrMsg VARCHAR(4000),
        @ErrSeverity INT,
        @ErrProcedure VARCHAR(100)

    SET @ErrMsg = ERROR_MESSAGE()
    SET @ErrSeverity = ERROR_SEVERITY()
    SET @ErrProcedure = ERROR_PROCEDURE()

    SET @ErrMsg = @ErrMsg + ' / ' + ISNULL(@ErrProcedure, '')

    RAISERROR(@ErrMsg, @ErrSeverity, 1)
    GOTO End_Prog

END CATCH

End_Prog: