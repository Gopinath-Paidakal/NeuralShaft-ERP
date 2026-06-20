USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqHdr]    Script Date: 11/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEnqHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEnqHdr]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqHdr]    Script Date: 11/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEnqHdr]
--(
--	@EnqHdrId int

--)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	SELECT
(
    SELECT
		  [EnqHdr].[EnqHdrId], 
          --[CompanyId],
          --[BranchId],
          [EnqHdr].[EnqNo],
          --[EnqSlno],
          [EnqHdr].[EnqDate],
          --[EnqRefDetails],
          -- [EnqRemarks],
          --[EnqStatus],
          [Latitude],
          [Longitude],
          --[CreatedBy],
          --[CreatedDate]

		  [EnqClient].EnqConsultant,
		  [EnqClient].EnqClientName,
		  [EnqClient].EnqClientMobileNo


    FROM [dbo].[EnqHdr]
	INNER JOIN EnqClient ON EnqHdr.EnqHdrId = EnqClient.EnqHdrId 
    --WHERE EnqHdrId = @EnqHdrId
    FOR JSON PATH, ROOT('EnqHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER
) AS EnqHdr

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