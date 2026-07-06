USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertAssyItem]    Script Date: 06/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertAssyItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertAssyItem]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertAssyItem]    Script Date: 06/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertAssyItem]
(

    @AssyItem nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	Declare @AssemblyItemId int


	--INSERT INTO AssemblyHdr
	--	(
	--		--AssemblyHdrId,
	--		AssemblyName,
	--		UOM,
	--		AssemblyQty,
	--		CreatedUserId,
	--		CreatedDate
	--	)
	--	SELECT
	--		--AssemblyHdrId,
	--		AssemblyName,
	--		'NOS',
	--		1,
	--		CreatedUserId,
	--		CreatedDate

	--	FROM OPENJSON(@Assy, '$.AssemblyHdr')
	--	WITH
	--	(
	--		--AssemblyHdrId INT,
	--		AssemblyName NVARCHAR(200),
	--		CreatedUserId INT,
	--		CreatedDate Date
	--	)

	-- set @AssemblyHdrId = SCOPE_IDENTITY();

	 INSERT INTO AssemblyItem
		(
			--AssemblyItemId,
			AssemblyHdrId,
			ItemId,
			ItemQty,
			CreatedUserId,
			CreatedDate
		)
		SELECT
			--AssemblyItemId,
			AssemblyHdrId,
			ItemId,
			ItemQty,
			CreatedUserId,
			CreatedDate

		FROM OPENJSON(@AssyItem, '$.AssemblyItem')
		WITH
		(
			--AssemblyItemId INT,

			AssemblyHdrId INT,
			ItemId INT,
			ItemQty NUMERIC(18,2),
			
			CreatedUserId INT,
			CreatedDate Date
		);

	set @AssemblyItemId = SCOPE_IDENTITY();

    select @AssemblyItemId

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


  --DECLARE @Prefix VARCHAR(20);
  --  DECLARE @Number INT;

  --  set @ItemCode = JSON_VALUE(@Item, '$.ItemCode')      --AS ItemCode,

  --  SET @Prefix = LEFT(@ItemCode, CHARINDEX('-', @ItemCode));
  --  SET @Number = CAST(SUBSTRING(@ItemCode, CHARINDEX('-', @ItemCode) + 1, LEN(@ItemCode)) AS INT);


   --SELECT @NextItemAsyNumber = ISNULL(MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),0) + 1
       --FROM Item WHERE ItemCode LIKE 'ASSY-%';

  --     if @NextItemAsyNumber = 0 or @NextItemAsyNumber is NULL
		--set @NextItemAsyNumber = 3000
	 --   --else
		----set @NextItemAsyNumber = @NextItemAsyNumber + 1


        --     SELECT @NextItemRMNumber = ISNULL(MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),0) + 1
  --     FROM Item WHERE ItemCode LIKE 'RM-%';

  --     if @NextItemRMNumber = 0 or @NextItemRMNumber is NULL
		--set @NextItemRMNumber = 5000

	    --else
		--set @NextItemRMNumber = @NextItemRMNumber + 1