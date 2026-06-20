USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateEnquiry]    Script Date: 12/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_UpdateEnquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Sp_UpdateEnquiry]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateEnquiry]    Script Date: 12/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_UpdateEnquiry]
(
	
	@Enquiry nvarchar(Max)

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
	   DECLARE @EnquiryId INT

        -- Get EnquiryId
        SELECT @EnquiryId = EnquiryId
        FROM OPENJSON(@Json)
        WITH
        (
            EnquiryId INT
        )

        ----------------------------------
        -- Update Client Details
        ----------------------------------
        UPDATE C
        SET
            C.EnqClientName = J.EnqClientName,
            C.EnqClientMobileNo = J.EnqClientMobileNo
        FROM EnqClient C
        CROSS APPLY OPENJSON(@Enquiry,'$.EnqClient')
        WITH
        (
            EnqClientName NVARCHAR(100),
            EnqClientMobileNo NVARCHAR(20)
        ) J
        WHERE C.EnquiryId = @EnquiryId

        ----------------------------------
        -- Update Shaft Details
        ----------------------------------

        UPDATE S
        SET
            S.ShaftType = J.ShaftType,
            S.ShaftWidth = J.ShaftWidth,
            S.ShaftDepth = J.ShaftDepth
        FROM EnqShaft S
        INNER JOIN OPENJSON(@Enquiry,'$.EnqShaft')
        WITH
        (
            ShaftId INT,
            ShaftType NVARCHAR(50),
            ShaftWidth NVARCHAR(50),
            ShaftDepth NVARCHAR(50)
        ) J
        ON S.ShaftId = J.ShaftId
        WHERE S.EnquiryId = @EnquiryId

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