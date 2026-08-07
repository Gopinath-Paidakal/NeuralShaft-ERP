USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDespatchById]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDespatchById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetDespatchById]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetDespatchById]
(
	@DespatchId int
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
		

	SELECT [DespatchId]
		,[OrdClientHdr].[OrdClientHdrId]
		,[OrdClientHdr].[OrdClientName]
		,[JobOrderNo]
		,[DespatchNo]
		,[DespatchDate]
		,[DespatchPlannedDate]
		,[DespatchStage]
		,[DespatchDesciption]

		,[Allocated1]
		,[Allocated2]
		,[AllotmentDate]
		,[AllocationOrder]
		,[AllocatedDespatch]
			  
		,[PendingMaterials]
		,[DespatchStatus]
			  
	FROM [dbo].[DespatchAllocation]
	INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [DespatchAllocation].[OrdClientHdrId]

	Where DespatchId = @DespatchId

	FOR JSON PATH, ROOT('DespatchAllocation');

			
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


	




