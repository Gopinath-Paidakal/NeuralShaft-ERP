USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertVendorDtl]    Script Date: 14/07/2026 ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertVendorDtl]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertVendorDtl]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertVendorDtl]
(
    @VendorHdrId int,
    @VendorDtl NVARCHAR(MAX)

    --@EnqDtlId int 
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    Declare @VendorAddrId int

    INSERT INTO [dbo].[VendorDtl]
    (
        VendorHdrId,
        VendorAddr1,
        VendorAddr2,
        VendorPostalCode,
        VendorState,

        VendorCity,
        VendorPhNo,
        VendorCompanyMailId,
        VendorWebsite,
        VendorPan,

        VendorGstNo,
        VendorAdhaarNo,
        VendorAddrType,
        VendorPriSalutation,
        VendorPriContPerson,

        VendorPriMailId,
        VendorPriMobileNo,
        VendorSecSalutation,
        VendorSecContPerson,
        VendorSecMailId,        

        VendorSecMobileNo,
        VendorLatitude,
        VendorLongitude,
        VendorTravelDistance,
        VendorDtlStatus
    )
    SELECT
        @VendorHdrId,
        VendorAddr1,
        VendorAddr2,
        VendorPostalCode,
        VendorState,

        VendorCity,
        VendorPhNo,
        VendorCompanyMailId,
        VendorWebsite,
        VendorPan,

        VendorGstNo,
        VendorAdhaarNo,
        VendorAddrType,
        VendorPriSalutation,
        VendorPriContPerson,

        VendorPriMailId,
        VendorPriMobileNo,
        VendorSecSalutation,
        VendorSecContPerson,
        VendorSecMailId,

        VendorSecMobileNo,
        VendorLatitude,
        VendorLongitude,
        VendorTravelDistance,
        VendorDtlStatus

    FROM OPENJSON(@VendorDtl, '$.VendorDtl')
    WITH
    (
        --VendorId INT,
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

        VendorDtlStatus NVARCHAR(10)
    );

    set @VendorAddrId  = SCOPE_IDENTITY()

    SELECT @VendorHdrId;

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


 -------------------------------------------------
    -------- Update EnqDql Customer Status
    -------------------------------------------------
    --if (@EnqDtlId > 0)
    --BEGIN
    --    Update EnqDtl set VendorId = @VendorId, CustomerStatus = 'Created' where EnqDtlId = @EnqDtlId
    --END