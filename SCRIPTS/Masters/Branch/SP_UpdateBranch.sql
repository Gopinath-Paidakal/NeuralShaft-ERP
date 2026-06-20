USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateBranch]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateBranch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateBranch]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateBranch]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateBranch]
(
    @BranchId int, 
	@Branch nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	UPDATE B
SET
    CompanyId = J.CompanyId,
    BranchHead = J.BranchHead,
    BranchCode = J.BranchCode,
    BranchAddr1 = J.BranchAddr1,
    BranchAddr2 = J.BranchAddr2,

    BranchCity = J.BranchCity,
    BranchPostalCode = J.BranchPostalCode,
    BranchWebsite = J.BranchWebsite,
    BranchPanNo = J.BranchPanNo,
    BranchMobile = J.BranchMobile,
    
    BranchEmail = J.BranchEmail,
    BranchOfficeNo = J.BranchOfficeNo,
    BranchVatNo = J.BranchVatNo,
    BranchCstNo = J.BranchCstNo,
    BranchServiceTax = J.BranchServiceTax,
    
    BranchStatus = J.BranchStatus,
    BranchChapterNo = J.BranchChapterNo,
    BranchExempNotification = J.BranchExempNotification,
    BranchRange = J.BranchRange,
    BranchDivision = J.BranchDivision,
    
    BranchBankName = J.BranchBankName,
    BranchBankBranch = J.BranchBankBranch,
    BranchBankAccNo = J.BranchBankAccNo,
    BranchIfscCode = J.BranchIfscCode,
    
    ModifiedUserId = J.ModifiedUserId,
    ModifiedDate = J.ModifiedDate
    
    FROM dbo.Branch B
        INNER JOIN OPENJSON(@Branch,'$.Branch')
        WITH
        (
        BranchId INT,
        CompanyId INT,
        BranchHead NVARCHAR(200),
        BranchCode NVARCHAR(50),
        BranchAddr1 NVARCHAR(500),

        BranchAddr2 NVARCHAR(500),
        BranchCity NVARCHAR(100),
        BranchPostalCode NVARCHAR(20),
        BranchWebsite NVARCHAR(200),
        BranchPanNo NVARCHAR(50),

        BranchMobile NVARCHAR(50),
        BranchEmail NVARCHAR(200),
        BranchOfficeNo NVARCHAR(50),
        BranchVatNo NVARCHAR(50),
        BranchCstNo NVARCHAR(50),
        
        BranchServiceTax NVARCHAR(50),
        BranchStatus BIT,
        BranchChapterNo NVARCHAR(100),
        BranchExempNotification NVARCHAR(500),
        BranchRange NVARCHAR(100),
        
        BranchDivision NVARCHAR(100),
        BranchBankName NVARCHAR(200),
        BranchBankBranch NVARCHAR(200),
        BranchBankAccNo NVARCHAR(100),
        BranchIfscCode NVARCHAR(50),

        ModifiedUserId INT,
        ModifiedDate DATE

    ) J
    ON B.BranchId = @BranchId;

    Select @BranchId


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