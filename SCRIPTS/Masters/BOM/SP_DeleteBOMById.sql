USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteBOMMstById]    Script Date: 04/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteBOMMstById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_DeleteBOMMstById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteBOMMstById]    Script Date: 04/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteBOMMstById]
(
	@BOMMstId int

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	Delete from BOMMst where BOMMstId = @BOMMstId

	Select @BOMMstId

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