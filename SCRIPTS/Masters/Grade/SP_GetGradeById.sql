USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGradeById.sql]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetGradeById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetGradeById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGradeById]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetGradeById]
(
	@GradeId int
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
		

		SELECT 
		[GradeId],
		[GradeCode],
		[GradeName],
		[GradeDesc],
		[GradeStatus],

		[CreatedUserId],
		[CreatedDate],
		[ModifiedUserId],
		[ModifiedDate]

	FROM [dbo].[Grade]
	Where GradeId = @GradeId

	FOR JSON PATH, ROOT('Grade');
	
END TRY

	BEGIN CATCH

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


	




