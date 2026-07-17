USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetVendor]    Script Date: 14/07/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetVendor]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetVendor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetVendor]
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

    SELECT (

        SELECT
            VendorHdrId,
           
            ISNULL(VendorTitle, '') AS VendorTitle,
            VendorTitle +  ' ' + VendorName as  'VendorName',

            --ISNULL(VendorName, '') AS VendorName,

            ISNULL(VendorGstTradeName, '') AS OrdGstTradeName,
            ISNULL(VendorGstNo, '') AS OrdGstNo,

            ISNULL(VendorCreditLimit, 0) AS VendorCreditLimit,
            ISNULL(VendorStatus, 0) AS VendorStatus,

        
            ISNULL(CreatedUserId, '') AS CreatedUserId,
            ISNULL(CreatedDate, '') AS CreatedDate

            
        FROM dbo.VendorHdr

        FOR JSON PATH, ROOT('VendorHdr')

    ) AS VendorHdr;

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