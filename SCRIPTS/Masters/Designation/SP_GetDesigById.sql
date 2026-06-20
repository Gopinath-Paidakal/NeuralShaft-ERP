USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDesigById.sql]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDesigById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetDesigById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDesigById]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetDesigById]
(
	@DesigId int
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
		
	SELECT 
		[DesigId],
		[CompanyId],
		[BranchId],
		[DesigCode],
		[DesigName],

		[DesigDesc],
		[DesigStatus],
		[CreatedUserId],
		[CreatedDate]
    
	
	FROM [dbo].[Designation]

	Where DesigId = @DesigId

	FOR JSON PATH, ROOT('Designation');
	
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


	




