USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetOrdClient]    Script Date: 20/03/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetOrdClient]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetOrdClient]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetOrdClient]
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

    SELECT (

        SELECT
            OrdClientHdrId,
            
            ISNULL(OrdConsultant, '') AS OrdConsultant,
            ISNULL(OrdClientTitle, '') AS OrdClientTitle,
            OrdClientTitle +  ' ' + OrdClientName as  'OrdClientName',
            --ISNULL(OrdClientName, '') AS OrdClientName,

            ISNULL(OrdGstTradeName, '') AS OrdGstTradeName,
            ISNULL(OrdGstNo, '') AS OrdGstNo,
            ISNULL(OrdClientStatus, '') AS OrdClientStatus,

        
            ISNULL(CreatedUserId, '') AS CreatedUserId,
            ISNULL(CreatedDate, '') AS CreatedDate

            
        FROM dbo.OrdClientHdr

        FOR JSON PATH, ROOT('OrdClient')

    ) AS OrdClient;

END TRY

BEGIN CATCH

    DECLARE 
        @ErrMsg VARCHAR(4000),
        @ErrSeverity INT,
        @ErrProcedure VARCHAR(100)

    SET @ErrMsg = ERROR_MESSAGE()
    SET @ErrSeverity = ERROR_SEVERITY()
    SET @ErrProcedure = ERROR_PROCEDURE()

    SET @ErrMsg = @ErrMsg + ' / ' + ISNULL(@ErrProcedure, '')
    RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH