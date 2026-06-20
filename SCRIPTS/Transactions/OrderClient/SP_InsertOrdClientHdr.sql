USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertOrdClientHdr]    Script Date: 02/04/2026 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertOrdClientHdr]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertOrdClientHdr]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertOrdClientHdr]
(
    @OrdClientHdr NVARCHAR(MAX),
    @EnqDtlId int = 0
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    Declare @OrdClientHdrId int


        INSERT INTO [dbo].[OrdClientHdr]
        (
  
            OrdConsultant,
            OrdClientName,
            OrdClientTitle,
            OrdGstTradeName,
            OrdGstNo,

            OrdClientStatus,
            CreatedUserId,
            CreatedDate
       
        )
        SELECT
       
            OrdConsultant,
            OrdClientName,
            OrdClientTitle,
            OrdGstTradeName,
            OrdGstNo,

            OrdClientStatus,
            CreatedUserId,             --'Admin',
            CreatedDate                --getdate()
       

        FROM OPENJSON(@OrdClientHdr, '$.OrdClientHdr')
        WITH
        (
       
            OrdClientGUID NVARCHAR(100),
            OrdConsultant NVARCHAR(100),
            OrdClientName NVARCHAR(100),
            OrdClientTitle NCHAR(10),

            OrdGstTradeName NVARCHAR(100),
            OrdGstNo NVARCHAR(100),
            OrdClientStatus bit,
            CreatedUserId int,
            CreatedDate date
       
        );

        set @OrdClientHdrId = SCOPE_IDENTITY();

        ----------------------------------------------
        ---- Inserting address 
        ----------------------------------------------
        Exec SP_InsertOrdClientAddr @OrdClientHdrId, @OrdClientHdr   --, @EnqDtlId

        -----------------------------------------------
        ------ Update EnqDql Customer Status
        -----------------------------------------------
        if (@EnqDtlId > 0)
        BEGIN
           Update EnqDtl set OrdClientHdrId = @OrdClientHdrId, CustomerStatus = 'Created' where EnqDtlId = @EnqDtlId
        END
        
        select @OrdClientHdrId 

    --SELECT CAST(SCOPE_IDENTITY() AS INT) AS OrdClientHdrId;

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