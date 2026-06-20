USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqClientByEnqHdrId]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEnqClientByEnqHdrId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEnqClientByEnqHdrId]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnqClientByEnqHdrId]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEnqClientByEnqHdrId]
(
	@EnqHdrId int
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	SELECT 
	   [EnqClientId]
      ,[EnqHdrId]

      ,[EnqClientGUID]
      ,[EnqConsultant]
      ,[EnqClientName]

      ,[EnqClientMobileNo]
      ,[EnqClientEmailId]
      ,[EnqClientAddress]
      ,[EnqClientCategory]
      ,[EnqLeadSource]
      
	  ,[EnqSourceBy]
      ,[EnqContactPerson]

	  from EnqClient


	  Where [EnqHdrId] = @EnqHdrId

    -- Return result
    SELECT @EnqHdrId AS EnqHdrId
	
	
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





--Insert into OrdClientHdr (OrdClientName)

	--	select EnqClientName from EnqClient

	--	where  EnqHdrId = @EnqHdrId and EnqClientId = @EnqClientId

	--    set @OrdClientHdrId = SCOPE_IDENTITY();


	--Insert into OrdClientAddr (OrdClientHdrId, OrdClientAddr1, OrdClientPriMobileNo)

	--	select  @OrdClientHdrId, EnqClientAddress, EnqClientMobileNo from EnqClient

	--	where EnqHdrId = @EnqHdrId and EnqClientId = @EnqClientId


	--Select @EnqHdrId