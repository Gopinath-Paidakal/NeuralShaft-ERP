USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateVendorHdr]    Script Date: 14/07/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateVendorHdr]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateVendorHdr]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateVendorHdr]
(
    @VendorHdrId int,
    @VendorHdrUpdate NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    UPDATE H
    SET
        H.VendorTitle             = J.VendorTitle,
        H.VendorName              = J.VendorName,
        H.VendorGstTradeName      = J.VendorGstTradeName,

        H.VendorGstNo             = J.VendorGstNo,
        H.VendorCreditLimit       = J.VendorCreditLimit,
        H.VendorStatus            = J.VendorStatus,

        H.ModifiedUserId          = J.ModifiedUserId,
        H.ModifiedDate            = J.ModifiedDate
        
    FROM dbo.VendorHdr H
    INNER JOIN OPENJSON(@VendorHdrUpdate, '$.VendorHdr')
    WITH
    (
        VendorHdrId INT,

        VendorTitle NCHAR(50),
        VendorName NCHAR(10),
        VendorGstTradeName NVARCHAR(100),
        
        VendorGstNo NVARCHAR(100),
        VendorCreditLimit NUMERIC(18,2),
        VendorStatus BIT,

        ModifiedUserId INT,
        ModifiedDate DATE
        
    ) J
    ON H.VendorHdrId = @VendorHdrId    -- J.VendorHdrId;

    --SELECT 
    --    JSON_VALUE(@VendorHdrUpdate, '$.VendorHdr[0].VendorHdrId') AS VendorHdrId;

    Select @VendorHdrId
    
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