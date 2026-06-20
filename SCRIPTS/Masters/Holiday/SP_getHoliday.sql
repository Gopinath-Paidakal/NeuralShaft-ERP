USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_getHoliday]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_getHoliday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_getHoliday]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_getHoliday]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_getHoliday]
--(
--	--@TalukFlag_No int,
--	--@Language_No int,
--	--@Display_Type varchar(20)
--)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
		
	-- GET DEPARTMENT AS JSON
	SELECT
	(
		SELECT 
			
			[Holiday].[HolidayId],
			[Branch].[BranchId],
			[Branch].[BranchName],

			[Holiday].[HolidayName],
			[Holiday].[HolidayDate],
			[Holiday].[HoidayYear],
			[Holiday].[HolidayStatus],
		
			[Holiday].[CreatedUserId],
			[Holiday].[CreatedDate],

			[Holiday].[ModifiedUserId],
			[Holiday].[ModifiedDate]

		FROM [dbo].[Holiday]
		INNER JOIN [Branch] On Branch.BranchId = Holiday.BranchId

		FOR JSON PATH, ROOT('Holiday')

	) As 'Holiday'
	
			
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


	




