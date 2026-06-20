USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateEmp]    Script Date: 21/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateEmp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateEmp]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateEmp]    Script Date: 21/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateEmp]
(
	@EmpId int,
    @UpdateEmpData nvarchar(100),
	@Emp nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	    ---------------------------------------------------
        -- 🔹 1. UPDATE EMPLOYEE (FULL)
        ---------------------------------------------------
        if (@UpdateEmpData = upper('EMPLOYEE'))
        BEGIN
            UPDATE E
            SET
                E.EmpTitle        = J.EmpTitle,
                E.EmpFirstName    = J.EmpFirstName,
                E.EmpLastName     = J.EmpLastName,
                E.EmpDOB          = J.EmpDOB,
                E.EmpGender       = J.EmpGender,

                E.EmpBloodGroup   = J.EmpBloodGroup,
                E.EmpMaritalStatus= J.EmpMaritalStatus,
                E.EmpFatherName   = J.EmpFatherName,
                E.EmpMotherName   = J.EmpMotherName,
                E.EmpPersEmailId  = J.EmpPersEmailId,
            
                E.EmpOffEmailId   = J.EmpOffEmailId,
                E.EmpMobileNo     = J.EmpMobileNo,
                E.EmpAltMobileNo  = J.EmpAltMobileNo,
                E.EmpEmerNo       = J.EmpEmerNo,
                E.EmpNationality  = J.EmpNationality,
            
                E.EmpPresAddr1    = J.EmpPresAddr1,
                E.EmpPresAddr2    = J.EmpPresAddr2,
                E.EmpPresState    = J.EmpPresState,
                E.EmpPresCity     = J.EmpPresCity,
                E.EmpPresPinCode  = J.EmpPresPinCode,
            
                E.EmpPermAddr1    = J.EmpPermAddr1,
                E.EmpPermsAddr2   = J.EmpPermsAddr2,
                E.EmpPermState    = J.EmpPermState,
                E.EmpPermCity     = J.EmpPermCity,
                E.EmpPermPinCode  = J.EmpPermPinCode,
            
                --E.EmpBranch       = J.EmpBranch,
                --E.EmpDept         = J.EmpDept,
                --E.EmpDesig        = J.EmpDesig,
                --E.EmpGrade        = J.EmpGrade,
                E.EmpType         = J.EmpType,
            
                E.EmpPunch        = J.EmpPunch,
                E.EmpLeaveGrroup  = J.EmpLeaveGrroup,
                E.EmpBioId        = J.EmpBioId,
                E.EmpDOC          = J.EmpDOC,
                E.EmpDOJ          = J.EmpDOJ,
            
                E.EmpDOR          = J.EmpDOR,
                E.EmpAttendance   = J.EmpAttendance,
                E.EmpESIC         = J.EmpESIC,
                E.EmpPF           = J.EmpPF,
                E.EmpPanNo        = J.EmpPanNo,
            
                E.EmpAadhar       = J.EmpAadhar,
                E.EmpInsPolicyNo  = J.EmpInsPolicyNo,
                E.EmpPFNo         = J.EmpPFNo,
                E.EmpUANNo        = J.EmpUANNo,
                E.EmpESICNo       = J.EmpESICNo,
            
                E.EmpPrevLeave    = J.EmpPrevLeave,
                E.EmpCasualLeave  = J.EmpCasualLeave,
                E.EmpSickLeave    = J.EmpSickLeave,
                E.EmpLeaveYear    = J.EmpLeaveYear,            
                E.EmpSalGross     = J.EmpSalGross,

                E.EmpOverTime     = J.EmpOverTime,
                E.EmpAssets       = J.EmpAssets,
                E.EmpDocuments    = J.EmpDocuments,
                E.EmpLogin        = J.EmpLogin

            FROM Employee E
            CROSS APPLY OPENJSON(@Emp, '$.Employee')
            WITH (
                EmpTitle NVARCHAR(50),
                EmpFirstName NVARCHAR(100),
                EmpLastName NVARCHAR(100),
                EmpDOB DATE,
                EmpGender NVARCHAR(10),

                EmpBloodGroup NVARCHAR(100),
                EmpMaritalStatus NVARCHAR(20),
                EmpFatherName NVARCHAR(100),
                EmpMotherName NVARCHAR(100),
                EmpPersEmailId NVARCHAR(100),

                EmpOffEmailId NVARCHAR(100),
                EmpMobileNo NVARCHAR(100),
                EmpAltMobileNo NVARCHAR(100),
                EmpEmerNo NVARCHAR(100),
                EmpNationality NVARCHAR(100),

                EmpPresAddr1 NVARCHAR(100),
                EmpPresAddr2 NVARCHAR(100),
                EmpPresState NVARCHAR(100),
                EmpPresCity NVARCHAR(100),
                EmpPresPinCode NVARCHAR(100),

                EmpPermAddr1 NVARCHAR(100),
                EmpPermsAddr2 NVARCHAR(100),
                EmpPermState NVARCHAR(100),
                EmpPermCity NVARCHAR(100),
                EmpPermPinCode NVARCHAR(100),

                EmpBranch NVARCHAR(100),
                EmpDept NVARCHAR(100),
                EmpDesig NVARCHAR(100),
                EmpGrade NVARCHAR(100),
                EmpType NVARCHAR(100),

                EmpPunch NVARCHAR(100),
                EmpLeaveGrroup NVARCHAR(100),
                EmpBioId NVARCHAR(50),
                EmpDOC DATE,
                EmpDOJ DATE,
                EmpDOR DATE,

                EmpAttendance NVARCHAR(100),
                EmpESIC NVARCHAR(100),
                EmpPF NVARCHAR(100),
                EmpPanNo NVARCHAR(100),
                EmpAadhar NVARCHAR(100),

                EmpInsPolicyNo NVARCHAR(100),
                EmpPFNo NVARCHAR(100),
                EmpUANNo NVARCHAR(100),
                EmpESICNo NVARCHAR(100),
                EmpPrevLeave INT,

                EmpCasualLeave INT,
                EmpSickLeave INT,
                EmpLeaveYear DATE,
                EmpSalGross NUMERIC(18,2),
                EmpOverTime INT,

                EmpAssets NVARCHAR(500),
                EmpDocuments NVARCHAR(500),
                EmpLogin bit
            ) J

            WHERE E.EmpId = @EmpId;

            Select @EmpId

        END

        ---------------------------------------------------
        -- 🔹 2. EMP ACADEMIC (FULL SYNC)
        ---------------------------------------------------
        if (@UpdateEmpData = upper('EMPACADEMIC'))
        BEGIN
            Declare @EmpAcadId int
            set @EmpAcadId = JSON_VALUE(@Emp, '$.EmpAcademic.EmpAcadId') 

            MERGE EmpAcademic AS T
            USING (
                SELECT *
                FROM OPENJSON(@Emp, '$.EmpAcademic')
                WITH (
                    EmpAcadId INT,
                    EmpQual NVARCHAR(100),
                    EmpClass NVARCHAR(100),
                    EmpInstitution NVARCHAR(100),
                    EmpUniversity NVARCHAR(100),
                    EmpPercent NUMERIC(18,2),
                    EmpYearOfPass NVARCHAR(100),
                    EmpAcadStatus NVARCHAR(100),
                    EmpAcadQuery NVARCHAR(100),
                    EmpAcaCrudType NVARCHAR(20)
                )
            ) S
            ON T.EmpAcadId = S.EmpAcadId AND T.EmpId = @EmpId

            WHEN MATCHED THEN UPDATE SET
                T.EmpQual = S.EmpQual,
                T.EmpClass = S.EmpClass,
                T.EmpInstitution = S.EmpInstitution,
                T.EmpUniversity = S.EmpUniversity,
                T.EmpPercent = S.EmpPercent,
                T.EmpYearOfPass = S.EmpYearOfPass,
                T.EmpAcadStatus = S.EmpAcadStatus,
                T.EmpAcadQuery = S.EmpAcadQuery,
                T.EmpAcaCrudType = S.EmpAcaCrudType

            WHEN NOT MATCHED THEN
                INSERT (EmpId, EmpQual, EmpClass, EmpInstitution, EmpUniversity, EmpPercent, EmpYearOfPass, EmpAcadStatus, EmpAcadQuery, EmpAcaCrudType)
                VALUES (@EmpId, S.EmpQual, S.EmpClass, S.EmpInstitution, S.EmpUniversity, S.EmpPercent, S.EmpYearOfPass, S.EmpAcadStatus, S.EmpAcadQuery, S.EmpAcaCrudType)

            WHEN NOT MATCHED BY SOURCE AND T.EmpId = @EmpId THEN DELETE;

            Select @EmpAcadId

        END

        ---------------------------------------------------
        -- 🔹 3. EMP PAST EMPLOYMENT (FULL SYNC)
        ---------------------------------------------------
        if (@UpdateEmpData = upper('EMPPASTEMPLOYMENT'))
        BEGIN
            Declare @EmpPastEmployId int
            set @EmpPastEmployId = JSON_VALUE(@Emp, '$.EmpPastEmployment.EmpPastEmployId') 

                MERGE EmpPastEmployment AS T
                USING (
                    SELECT *
                    FROM OPENJSON(@Emp, '$.EmpPastEmployment')
                    WITH (
                        EmpPastEmployId INT,
                        EmpCompName NVARCHAR(100),
                        EmpDesig NVARCHAR(100),
                        EmpLastDrnSal NVARCHAR(100),
                        EmpFromDate DATE,
                        EmpToDate DATE,
                        EmpPastActive BIT,
                        EmpPastQuery NVARCHAR(100),
                        EmpPastCrudType NVARCHAR(20)
                    )
                ) S
                ON T.EmpPastEmployId = S.EmpPastEmployId AND T.EmpId = @EmpId

                WHEN MATCHED THEN UPDATE SET
                    T.EmpCompName = S.EmpCompName,
                    T.EmpDesig = S.EmpDesig,
                    T.EmpLastDrnSal = S.EmpLastDrnSal,
                    T.EmpFromDate = S.EmpFromDate,
                    T.EmpToDate = S.EmpToDate,
                    T.EmpPastActive = S.EmpPastActive,
                    T.EmpPastQuery = S.EmpPastQuery,
                    T.EmpPastCrudType = S.EmpPastCrudType

                WHEN NOT MATCHED THEN
                    INSERT (EmpId, EmpCompName, EmpDesig, EmpLastDrnSal, EmpFromDate, EmpToDate, EmpPastActive, EmpPastQuery, EmpPastCrudType)
                    VALUES (@EmpId, S.EmpCompName, S.EmpDesig, S.EmpLastDrnSal, S.EmpFromDate, S.EmpToDate, S.EmpPastActive, S.EmpPastQuery,  S.EmpPastCrudType)

                WHEN NOT MATCHED BY SOURCE AND T.EmpId = @EmpId THEN DELETE;

                Select @EmpPastEmployId
        END
        ---------=====================================
        
        ---------------------------------------------------
        -- 🔹 4. EMP Assets
        ---------------------------------------------------
        if (@UpdateEmpData = upper('EMPASSETS'))
        BEGIN
            Declare @EmpAssetId int
            set @EmpAssetId = JSON_VALUE(@Emp, '$.EmpAssets.EmpAssetId') 

            MERGE EmpAssets AS T
            USING (
                SELECT *
                FROM OPENJSON(@Emp, '$.EmpAssets')
                WITH (
                    EmpAssetId INT,
                    EmpAssetName NVARCHAR(100),
                    EmpAssetDesc NVARCHAR(500),
                    EmpAssetSlNo NVARCHAR(100),
                    EmpAssetValue Numeric(18,2),
                    EmpAssetCondition NVARCHAR(100),
                    EmpAssetCrudType NVARCHAR(20)
                )
            ) S
            ON T.EmpAssetId = S.EmpAssetId AND T.EmpId = @EmpId

            WHEN MATCHED THEN UPDATE SET
                T.EmpAssetName      = S.EmpAssetName,
                T.EmpAssetDesc      = S.EmpAssetDesc,
                T.EmpAssetSlNo      = S.EmpAssetSlNo,
                T.EmpAssetValue     = S.EmpAssetValue,
                T.EmpAssetCondition = S.EmpAssetCondition,
                T.EmpAssetCrudType  = S.EmpAssetCrudType

            WHEN NOT MATCHED THEN
                INSERT (EmpId,  EmpAssetName,   EmpAssetDesc,   EmpAssetSlNo,   EmpAssetValue,   EmpAssetCondition,   EmpAssetCrudType)
                VALUES (@EmpId, S.EmpAssetName, S.EmpAssetDesc, S.EmpAssetSlNo, S.EmpAssetValue, S.EmpAssetCondition, S.EmpAssetCrudType)

            WHEN NOT MATCHED BY SOURCE AND T.EmpId = @EmpId THEN DELETE;

            select @EmpAssetId

        END

        ---------------------------------------------------
        -- 🔹 4. EMP Docs
        ---------------------------------------------------
        if (@UpdateEmpData = upper('EMPDOCS'))
        BEGIN
            Declare @EmpDocId int
            set @EmpDocId = JSON_VALUE(@Emp, '$.EmpDocs.EmpDocId') 

        MERGE EmpDocs AS T
        USING (
            SELECT *
            FROM OPENJSON(@Emp, '$.EmpDocs')
            WITH (
                EmpDocId INT,
                EmpDocName NVARCHAR(100),
                EmpDocDesc NVARCHAR(500),
                EmpDocRemarks NVARCHAR(100),
                EmpDocCrudType NVARCHAR(20)
            )
        ) S
        ON T.EmpDocId = S.EmpDocId AND T.EmpId = @EmpId

        WHEN MATCHED THEN UPDATE SET
            T.EmpDocName        = S.EmpDocName,
            T.EmpDocDesc        = S.EmpDocDesc,
            T.EmpDocRemarks     = S.EmpDocRemarks,
            T.EmpDocCrudType    = S.EmpDocCrudType

        WHEN NOT MATCHED THEN
            INSERT (EmpId,  EmpDocName,   EmpDocDesc,   EmpDocRemarks,    EmpDocCrudType)
            VALUES (@EmpId, S.EmpDocName, S.EmpDocDesc, S.EmpDocRemarks,  S.EmpDocCrudType)

        WHEN NOT MATCHED BY SOURCE AND T.EmpId = @EmpId THEN DELETE;

        Select @EmpDocId
    END

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


	 --  DECLARE @EmpId INT

		 --  set @EmpId = JSON_VALUE(@Emp, '$.Employee.EmpId');

		 --   IF @EmpId IS NULL
			--BEGIN
			--	RAISERROR('EmpId is required for update',16,1);
			--	ROLLBACK TRAN;
			--	RETURN;
			--END