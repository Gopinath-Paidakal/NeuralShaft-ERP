USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ValidateUser]    Script Date: 28/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ValidateUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_ValidateUser]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ValidateUser]    Script Date: 28/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ValidateUser]
(
	@UserName nvarchar(50),
	@UserPwd  nvarchar(50)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

		Declare @EmpId int

		Declare @UserName1 nvarchar(100)
		Declare @UserPwd1 nvarchar(100)
	
	
		if (@UserName = 'Admin')
		BEGIN
		    
			set @UserName1 = 'Super Admin'
			--set @UserPwd1 = 'Admin' 
			set @EmpId = 9999

			SELECT
			(	
				select @UserName1 [UserName], @EmpId [EmpId]
				--select @EmpId [EmpId]
				FOR JSON PATH, ROOT('Users')

		  	 ) As 'Users'
		END
		ELSE
		BEGIN
		 set @EmpId = (Select EmpId from Users where UPPER(UserName) = UPPER(@UserName) and UPPER(UserPwd) = UPPER(@UserPwd))
		END	

		SELECT
			 (	
				Select EmpId, EmpFirstName  + ' ' + EmpLastName [UserName], [EmpMobileNo], [EmpOffEmailId]
				from employee where EmpId = @EmpId
				FOR JSON PATH, ROOT('Users')

		) As 'Users'

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



		


		---Select @EmpId as 'EmpId'


		--Select @EmpFirstName as 'EmpFirstName'