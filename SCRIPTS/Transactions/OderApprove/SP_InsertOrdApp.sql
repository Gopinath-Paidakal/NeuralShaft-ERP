USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertOrdApp]    Script Date: 04/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertOrdApp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_InsertOrdApp
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertOrdApp]    Script Date: 04/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].SP_InsertOrdApp
(
	@OrdApprove nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION

	Declare @OrdClientHdrId int
	Declare @OrdApproveId int
	Declare @OrdStatus nvarchar(50)

	Declare @EnqDtlId int
	
	SET @EnqDtlId = JSON_VALUE(@OrdApprove, '$.OrdApprove.EnqDtlId');
	SET @OrdStatus = JSON_VALUE(@OrdApprove, '$.OrdApprove.OrdStatus');

	-------------------------------------------
	-------- Inserting Into OrdApprove
	-------------------------------------------
	INSERT INTO [dbo].[OrdApprove]
    (
		OrdClientHdrId,
		EnqHdrId,
		EnqDtlId,
		QuoteHdrId,

		OrdApproved,
		CreatedUserId,
		CreatedDate
	)
	Select
		OrdClientHdrId,
		EnqHdrId,
		EnqDtlId,
		QuoteHdrId,

		OrdApproved, 
		CreatedUserId, 
		CreatedDate

	FROM OPENJSON(@OrdApprove, '$.OrdApprove')
    WITH
	(
		OrdClientHdrId int,
		EnqHdrId int,
		EnqDtlId int,
		QuoteHdrId int,

		OrdApproved nvarchar(50),
		CreatedUserId int, 
		CreatedDate nvarchar(20)
	)

	set @OrdApproveId = SCOPE_IDENTITY();

	--SELECT CAST(SCOPE_IDENTITY() AS INT) AS SOApproveId;

	--- ====================================================================
	----- Update Approve Id in Enq Detail Approval Status 1 and SO Generated
	------------------------------------------------------------------------
	
	Update EnqDtl set OrderStatus = @OrdStatus where EnqDtlId = @EnqDtlId
	

	Select @OrdApproveId 

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


--Update EnqDtl set OrderStatus = @OrdStatus, SoGen = 1 where EnqDtlId = @EnqDtlId
			
	-- Select 'SentForApproval' as [SentForApproval]



--SET @QuoteHdrId = JSON_VALUE(@OrdApprove, '$.OrdApprove.QuoteHdrId');
--set @EnqNo = (select EnqNo from EnqHdr where Enqhdrid =  @EnqHdrId)
	--set @QuoteNo = (Select QuoteNo from QuoteHdr where QuoteHdrId = @QuoteHdrId)




--DECLARE @EnqDtlId int
	--DECLARE @EnqHdrId int
	--DECLARE @QuoteHdrId int

	--DECLARE @EnqNo int
	--DECLARE @QuoteNo int


	---- Extract primary key (important for UPDATE)
	--SET @EnqHdrId = JSON_VALUE(@OrdApprove, '$.OrdApprove.EnqHdrId');
	--SET @EnqDtlId = JSON_VALUE(@OrdApprove, '$.OrdApprove.EnqDtlId');


--Update OrdApprove set SOGen = 0 where OrdApprove.OrdApproveId = @OrdApproveId
--Update EnqDtl set OrdClientHdrId = @OrdClientHdrId, CustomerStatus = 'Created' where EnqDtlId = @EnqDtlId

-------------------------------------------
	----- Inserting the OrdClient Header
	-------------------------------------------
	--Exec @OrdClientHdrId = SP_InsertOrdClientHdr @OrdApprove 

	--INSERT INTO [dbo].[OrdClientHdr]
 --   (
  
 --       OrdConsultant,
 --       OrdClientName,
 --       OrdClientTitle,
 --       OrdGstTradeName,
 --       OrdGstNo,

 --       OrdClientStatus,
 --       CreatedUserId,
 --       CreatedDate
       
 --   )
 --   SELECT
       
 --       OrdConsultant,
 --       OrdClientName,
 --       OrdClientTitle,
 --       OrdGstTradeName,
 --       OrdGstNo,

 --       OrdClientStatus,
 --       CreateUserId,                  ---1,
 --       CreatedDate

 --   FROM OPENJSON(@OrdApprove, '$.OrdClientHdr')
 --   WITH
 --   (
       
 --       OrdClientGUID NVARCHAR(100),
 --       OrdConsultant NVARCHAR(100),
 --       OrdClientName NVARCHAR(100),
 --       OrdClientTitle NCHAR(10),

 --       OrdGstTradeName NVARCHAR(100),
 --       OrdGstNo NVARCHAR(100),
 --       OrdClientStatus NVARCHAR(100),

	--	CreateUserId int,
	--	CreatedDate nvarchar(20)
       
 --   );

 --   set @OrdClientHdrId = SCOPE_IDENTITY();

	-------------------------------------------
	----- Inserting the OrdClient Address
	-------------------------------------------
	--- Exec SP_InsertOrdClientAddr @OrdClientHdrId, @OrdApprove
