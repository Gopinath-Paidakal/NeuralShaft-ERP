USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetBranchById]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBranchById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetBranchById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetBranchById]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetBranchById]
(
	@BranchId int

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	-- GET ALL BRANCHES AS JSON

        SELECT 
            [BranchId],
            [CompanyId],
            [BranchHead],
            [BranchCode],
            [BranchName],
            [BranchAddr1],

            [BranchAddr2],
            [BranchCity],
            [BranchPostalCode],
            [BranchWebsite],
            [BranchPanNo],
            
            [BranchMobile],
            [BranchEmail],
            [BranchOfficeNo],
            [BranchVatNo],
            [BranchCstNo],
            
            [BranchServiceTax],
            [BranchStatus],
            [BranchChapterNo],
            [BranchExempNotification],
            [BranchRange],
            
            [BranchDivision],
            [BranchBankName],
            [BranchBankBranch],
            [BranchBankAccNo],
            [BranchIfscCode]

        FROM [dbo].[Branch]
        
        Where BranchId = @BranchId

        FOR JSON PATH, ROOT('Branch');

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