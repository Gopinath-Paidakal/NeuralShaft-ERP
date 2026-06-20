USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqFollowUp_ByUserId]    Script Date: 23/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEnqFollowUp_ByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEnqFollowUp_ByUserId]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqFollowUp_ByUserId]    Script Date: 23/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEnqFollowUp_ByUserId]
(
	@CreatedUserId int

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	SELECT
(
   SELECT
		  [EnqFollowUp].[EnqFollowUpId],
		  [EnqFollowUp].[EnqHdrId], 
		  [EnqFollowUp].[EnqClientId], 
          
		  [EnqHdr].[EnqNo],
          --[EnqHdr].[EnqStatus],
		  --[EnqHdr].[EnqDate]  as [Follow Up Date],
		  --DATEADD(DAY, 5, [EnqHdr].[EnqDate]) AS [Follow Up Date],
		  FORMAT([EnqFollowUp].[EnqFollowUpDate], 'dd-MM-yyyy') as [EnqFollowUpDate],


		  [EnqHdr].[QuoteNo],

          [EnqClient].EnqClientName,
          [EnqClient].EnqClientMobileNo,
          [EnqClient].EnqConsultant,
         
          [EnqFollowUp].[EnqPurpose],
		  [EnqFollowUp].[EnqLastDiscussion],
		  [EnqFollowUp].[EnqFollowUpRemarks],
		  [EnqFollowUp].[EnqFollowUpStatus],
		  [EnqFollowUp].[CreatedUserId],
		  [EnqFollowUp].[CreatedDate]



    FROM [dbo].[EnqFollowUp]
	
	INNER JOIN EnqHdr ON [EnqFollowUp].[EnqHdrId] = [EnqHdr].[EnqHdrId] 
	INNER JOIN EnqClient ON [EnqFollowUp].[EnqClientId] = [EnqClient].[EnqClientId] 

	--where [EnqFollowUp].[EnqFollowUpDate] >= @FromDate and [EnqFollowUp].[EnqFollowUpDate] < @ToDate

    WHERE [EnqFollowUp].[CreatedUserId] = @CreatedUserId    ---[EnqHdr].[EnqHdrId] 

	Order by [EnqHdr].[EnqNo]
    
	FOR JSON PATH, ROOT('EnqFollowUp')  -- ROOT WITHOUT_ARRAY_WRAPPER
) AS EnqFollowUp

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