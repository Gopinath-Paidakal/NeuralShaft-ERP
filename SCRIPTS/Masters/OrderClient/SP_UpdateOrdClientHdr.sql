USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateOrdClientHdr]    Script Date: 03/04/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateOrdClientHdr]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateOrdClientHdr]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateOrdClientHdr]
(
    @OrdClientHdr NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    UPDATE H
    SET
        H.OrdConsultant        = J.OrdConsultant,
        H.OrdClientName        = J.OrdClientName,
        H.OrdClientTitle       = J.OrdClientTitle,
        H.OrdGstTradeName      = J.OrdGstTradeName,
        H.OrdGstNo             = J.OrdGstNo,
        H.OrdClientStatus      = J.OrdClientStatus
        
    FROM dbo.OrdClientHdr H
    INNER JOIN OPENJSON(@OrdClientHdr, '$.OrdClientHdr')
    WITH
    (
        OrdClientHdrId INT,
        OrdConsultant NVARCHAR(100),
        OrdClientName NVARCHAR(100),
        OrdClientTitle NCHAR(10),
        OrdGstTradeName NVARCHAR(100),
        OrdGstNo NVARCHAR(100),
        OrdClientStatus NVARCHAR(100)
        
    ) J
    ON H.OrdClientHdrId = J.OrdClientHdrId;

    SELECT 
        JSON_VALUE(@OrdClientHdr, '$.OrdClientHdr[0].OrdHdrId') AS OrdHdrId;

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