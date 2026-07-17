USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertVendorHdr]    Script Date: 14/07/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertVendorHdr]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertVendorHdr]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertVendorHdr]
(
    @VendorHdr NVARCHAR(MAX)
    
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    Declare @VendorHdrId int


        INSERT INTO [dbo].[VendorHdr]
        (
            VendorTitle,
            VendorName,
           
            VendorGstTradeName,
            VendorGstNo,
            VendorCreditLimit,

            VendorStatus,
            CreatedUserId,
            CreatedDate
       
        )
        SELECT

            VendorTitle,
            VendorName,
           
            VendorGSTTradeName,
            VendorGSTNo,
            VendorCreditLimit,

            VendorStatus,
            CreatedUserId,             --'Admin',
            CreatedDate                --getdate()
       

        FROM OPENJSON(@VendorHdr, '$.VendorHdr')
        WITH
        ( 
            VendorTitle NVARCHAR(50),
            VendorName NVARCHAR(100),

            VendorGSTTradeName NVARCHAR(100),
            VendorGSTNo NVARCHAR(100),
            VendorCreditLimit NUMERIC(18,2),

            VendorStatus bit,

            CreatedUserId int,
            CreatedDate date
       
        );

        set @VendorHdrId = SCOPE_IDENTITY();

        ----------------------------------------------
        ---- Inserting address 
        ----------------------------------------------
        Exec SP_InsertVendorDtl @VendorHdrId, @VendorHdr  

     
        
        select @VendorHdrId 

    --SELECT CAST(SCOPE_IDENTITY() AS INT) AS VendorHdrId;

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
        --   Update EnqDtl set VendorHdrId = @VendorHdrId, CustomerStatus = 'Created' where EnqDtlId = @EnqDtlId
        --END