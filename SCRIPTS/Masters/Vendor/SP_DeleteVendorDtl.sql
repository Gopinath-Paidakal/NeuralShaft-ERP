USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteVendorDtl]    Script Date: 14/07/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteVendorDtl]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_DeleteVendorDtl]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteVendorDtl]
(
    @OrdClientDtl NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    --UPDATE A
    --SET
    --    A.Deleted = 1
    --FROM dbo.OrdClientAddr A
    --INNER JOIN OPENJSON(@OrdClientAddr, '$.OrdClientAddr')
    --WITH
    --(
    --    OrdHdrId INT
    --) J
    --ON A.OrdHdrId = J.OrdHdrId;

    ---- Return same header id (consistent with your pattern)
    --SELECT 
    --    JSON_VALUE(@OrdClientAddr, '$.OrdClientAddr[0].OrdHdrId') AS OrdHdrId;

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