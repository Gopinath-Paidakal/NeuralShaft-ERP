USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertCRMDocs]    Script Date: 20/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertCRMDocs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertCRMDocs]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertCRMDocs]    Script Date: 20/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertCRMDocs]
(
	@CRMDocs nvarchar(Max)

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

    declare @JobOrderDocsId int
        
		INSERT INTO dbo.JobOrderDoc
        (
            JobOrderId,
            SODtlId,
            JobOrderDocPath,
            JobOrderDocName,
            JobOrderDocRemarks,

            CreatedUserId,
            CreatedUserDate
        )
        SELECT
            JobOrderId,
            SODtlId,

            '/uploads/crm/',       ---JobOrderDocPath,
            JobOrderDocName,
            JobOrderDocRemarks,
            
            CreatedUserId,
            CreatedUserDate

        FROM OPENJSON(@CRMDocs, '$.CRMDocs')
        WITH
        (
            JobOrderId INT,
            SODtlId INT,

            JobOrderDocPath NVARCHAR(200),
            JobOrderDocName NVARCHAR(200),
            JobOrderDocRemarks NVARCHAR(200),

            CreatedUserId INT,
            CreatedUserDate datetime
        );

        set @JobOrderDocsId = SCOPE_IDENTITY()

        select @JobOrderDocsId

	COMMIT TRANSACTION
END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		Declare 
		@ErrMsg varchar(4000),
		@ErrSeverity int,
		@ErrProcedure varchar(100)

		SET @ErrMsg = (Select Error_Message())
		SET @ErrSeverity = (Select Error_Severity())
		SET @ErrProcedure = (Select Error_Procedure())

		SET @ErrMsg = @ErrMsg + ' / ' + @ErrProcedure
		Raiserror(@ErrMsg,@ErrSeverity,1)
		GOTO End_Prog

	END CATCH

End_Prog: