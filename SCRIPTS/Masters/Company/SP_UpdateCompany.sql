USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateCompany]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateCompany]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateCompany]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateCompany]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateCompany]
(
    @CompanyId int, 
	@Company nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	UPDATE C
    SET
        CompName = J.CompName,
        CompAddr1 = J.CompAddr1,
        CompAddr2 = J.CompAddr2,
        CompCode = J.CompCode,
        CompHead = J.CompHead,

        CompCity = J.CompCity,
        CompPostalCode = J.CompPostalCode,
        CompWebsite = J.CompWebsite,
        CompPan = J.CompPan,
        CompMobile = J.CompMobile,

        CompEmailId = J.CompEmailId,
        CompOfficeNo = J.CompOfficeNo,
        CompVatNo = J.CompVatNo,
        CompCstNo = J.CompCstNo,
        CompServiceTax = J.CompServiceTax,
    
        CompExciseDuty = J.CompExciseDuty,
        CompanyCinNo = J.CompanyCinNo,
        CompBankName = J.CompBankName,
        CompBankBranchName = J.CompBankBranchName,
        CompBankAccNo = J.CompBankAccNo,
    
        CompBankIfscCode = J.CompBankIfscCode,
        --CompHeader = J.CompHeader,
        CompHeaderHeight = J.CompHeaderHeight,
        ModifiedDate = J.ModifiedDate

    FROM dbo.Company C
    INNER JOIN OPENJSON(@Company, '$.Company')
    WITH
    (
        CompanyId INT,
        CompName NVARCHAR(200),
        CompAddr1 NVARCHAR(500),
        CompAddr2 NVARCHAR(500),
        CompCode NVARCHAR(50),

        CompHead NVARCHAR(200),
        CompCity NVARCHAR(100),
        CompPostalCode NVARCHAR(20),
        CompWebsite NVARCHAR(200),
        CompPan NVARCHAR(50),
        
        CompMobile NVARCHAR(50),
        CompEmailId NVARCHAR(200),
        CompOfficeNo NVARCHAR(50),
        CompVatNo NVARCHAR(50),
        CompCstNo NVARCHAR(50),
        
        CompServiceTax NVARCHAR(50),
        CompExciseDuty NVARCHAR(50),
        CompanyCinNo NVARCHAR(100),
        CompBankName NVARCHAR(200),
        CompBankBranchName NVARCHAR(200),
        
        CompBankAccNo NVARCHAR(100),
        CompBankIfscCode NVARCHAR(50),
        --CompHeader NVARCHAR(MAX),
        CompHeaderHeight INT,
        ModifiedDate date


    ) J
    ON C.CompanyId = @CompanyId;

    Select @CompanyId

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