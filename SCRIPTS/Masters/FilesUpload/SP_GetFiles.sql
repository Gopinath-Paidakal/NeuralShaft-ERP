USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetFiles]    Script Date: 22/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetFiles]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetFiles]    Script Date: 22/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetFiles]
(
	@DocFileId int
	--@DocType nvarchar(100)
	--@DocPath nvarchar(100)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	--BEGIN TRANSACTION

		DECLARE @Files NVARCHAR(MAX);

	SET @Files = (
		SELECT (
		(
			SELECT [FilesId]
				  ,[DocFileId]
				  --,[DocType]
				  --,[DocPath]
				  ,[DocFileName]
			FROM [dbo].[FilePath]
		    where DocFileId = @DocFileId    --and upper(DocPath) = upper(@DocPath)

			FOR JSON PATH, ROOT('Files'))

		) As 'Files')

		SELECT ISNULL(@Files, '{"Files":[]}') AS DefaultData;

	--COMMIT TRANSACTION
END TRY

	BEGIN CATCH
		--ROLLBACK TRANSACTION
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