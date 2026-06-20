USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEmployee]    Script Date: 10/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEmployee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEmployee]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEmployee]    Script Date: 10/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEmployee]
--(
--	@Enquiry nvarchar(Max)

--)
----With Encryption
AS

SET NOCOUNT ON;



BEGIN TRY
	--BEGIN TRANSACTION
	DECLARE @Employee NVARCHAR(MAX);

	SET @Employee = (
		SELECT (
		(
			SELECT 
				[Employee].[EmpId],
				[Employee].[DeptId],
				[Employee].[DesigId],
				[Employee].[GradeId],
				[Employee].[EmpFirstName],
				[Employee].[EmpLastName],

				--[Designation].[DesigName],
				--[EmpDesig],
				[Employee].[EmpBloodGroup],
				[Employee].[EmpOffEmailId],
				[Employee].[EmpMobileNo],
				[Employee].[EmpEmerNo]

				--[Users].UserId
      
		  FROM [dbo].[Employee]
		  INNER JOIN Branch on Branch.BranchId = Employee.BranchId
		  --INNER JOIN Designation on Designation.DesigId = Employee.DesigId
		  --INNER JOIN Users on Users.EmpId = Employee.empid

		  FOR JSON PATH, ROOT('Employee'))

		) As 'Employee')

		SELECT ISNULL(@Employee, '{"Employee":[]}') AS DefaultData;


	--COMMIT TRANSACTION
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


--ISNULL([DefaultDataName], '') AS [DefaultDataName],