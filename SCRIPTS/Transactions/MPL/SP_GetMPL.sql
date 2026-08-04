USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMPL]    Script Date: 04/08/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetMPL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetMPL]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetMPL]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20)
)

AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	-- GET ALL BRANCHES AS JSON
		  SELECT
		(

		SELECT 

			  [MPLHdrId]
			  ,[MPLHdr].[JobOrderId]
			  ,[MPLStage]
			  ,[MPLDate]
			  ,[MPLStatus]

			  ,[SOHdr].SOCustComp

			  --,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]


			FROM [dbo].[MPLHdr]			 
			INNER JOIN [JobOrder] ON [JobOrder].[JobOrderId] = [MPLHdr].[JobOrderId]
			INNER JOIN [SOHdr] ON [SOHdr].[SOHdrId] = [JobOrder].[SOHdrId]
			INNER JOIN [OrdClientHdr] ON [OrdClientHdr].[OrdClientHdrId] = [SOHdr].[OrdClientHdrId]

			--- Both Date and Time-- best practice
			WHERE [MPLHdr].[MPLDate] >= @FromDate AND [MPLHdr].[MPLDate] < DATEADD(DAY, 1, @ToDate)

			--Order by [DeliveryChallanHdr].[DCNo]

		
			FOR JSON PATH, ROOT('DeliveryChallanHdr')  -- ROOT WITHOUT_ARRAY_WRAPPER

		) AS DeliveryChallanHdr

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


	  --,[SOHdr].[SOConsultant]
			  --,[SOHdr].[SOContPerson]
			  --,[SOHdr].[SOCustComp]


			  --,[CreatedUserId]
			  --,[CreatedDate]
			  --,[ModifiedUserId]
			  --,[ModifiedDate]