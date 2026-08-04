USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertMPL]    Script Date: 08/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertMPL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertMPL]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertMPL]
(
	@MPLHdr nvarchar(Max)

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	Declare @MPLHdrId int
	--Declare @CreatedUserId int
	--Declare @CreatedDate date

	BEGIN TRANSACTION

		--set @CreatedUserId = JSON_VALUE(@MPLHdr, '$.MPLHdr.CreatedUserId')
		--set @CreatedDate = JSON_VALUE(@MPLHdr, '$.MPLHdr.CreatedDate')
		
		INSERT INTO dbo.MPLHdr
		(
			JobOrderId,
			MPLStage,
			MPLDate,
			MPLStatus,

			CreatedUserId,
			CreatedDate
		
		)
			SELECT
				JobOrderId,
				MPLStage,
				MPLDate,
				MPLStatus,

				CreatedUserId,
				CreatedDate
			
			FROM OPENJSON(@MPLHdr, '$.MPLHdr')
			WITH
			(
				JobOrderId int,
				MPLStage NVARCHAR(50),
				MPLDate Date,
				MPLStatus bit,

				CreatedUserId INT,
				CreatedDate DATETIME
			);

			set @MPLHdrId = SCOPE_IDENTITY()


			------=================================================
			--- Inserting MPLDtl from JobOrderBOM
			----===================================================

			INSERT INTO [dbo].[MPLDtl]
				   ([MPLHdrId]
				   ,[SODtlId]
				   ,[JobOrderId]
				   ,[ProductId]
				   ,[AssemblyHdrId]

				   ,[ItemId]
				   ,[ItemQty]
				   ,[ItemReqdQty]
				   ,[ItemTotalQty]
				   ,[ItemStockQty]
				   
				   ,[CreatedUserId]
				   ,[CreatedDate])

			SELECT 
				   --[JobOrderBOMId]
				   @MPLHdrId
				  ,[SODtlId]
				  ,[JobOrderId]
				  ,[ProductId]
				  ,[AssemblyHdrId]

				  ,[ItemId]
				  ,[ItemQty]
				  ,[ItemReqdQty]
				  ,[ItemTotalQty]
				  ,(Select ItemStockQty from item where ItemId = [JobOrderBOM].ItemId)
				  ,[CreatedUserId]
				  ,[CreatedDate]

			FROM [dbo].[JobOrderBOM]
		

	select @MPLHdrId

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