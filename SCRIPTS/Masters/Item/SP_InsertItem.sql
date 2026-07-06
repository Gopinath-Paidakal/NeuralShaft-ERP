USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertItem]    Script Date: 08/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertItem]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertItem]    Script Date: 08/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertItem]
(
	@ItemType nvarchar(50),
	@Item nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

    Declare @ItemId int = 0

    DECLARE @ItemCode VARCHAR(50)      -- = 'FIN-1000';

    DECLARE @NextItemRMNumber INT
    DECLARE @NextItemAsyNumber INT

    DECLARE @NextRMItemCode varchar(50)
    DECLARE @NextAssyItemCode varchar(50)
     
    -----========================================================================
    if upper(@ItemType) = 'ASSEMBLY'
	BEGIN
          SELECT @NextItemAsyNumber = ISNULL(
                MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),
                2999) + 1
                FROM Item
                WHERE ItemCode LIKE 'ASSY-%';

            set @NextAssyItemCode = (SELECT 'ASSY-' + CAST(@NextItemAsyNumber AS VARCHAR(20)));

	    INSERT INTO dbo.Item
        (
            ItemType, HSNCode, ItemName, Height, Width, Depth, Speed,
            TravelHeight, Finish, OpeningType, [Weight],  LevelNo, CreatedUserId, CreatedDate
        )
        SELECT *
        FROM OPENJSON(@Item, '$.Assembly')
        WITH
        (
            ItemType NVARCHAR(50),
            HSNCode NVARCHAR(50),
            ItemName NVARCHAR(MAX),

            Height INT,
            Width INT,
            Depth INT,
            Speed NUMERIC(10,2),
            TravelHeight INT,
   
            Finish NVARCHAR(100),
            OpeningType NVARCHAR(100),
            [Weight] numeric(18,2),
            LevelNo SMALLINT,

            CreatedUserId INT,
            CreatedDate DATE
        );

        set @ItemId = SCOPE_IDENTITY()

        update Item set ItemCode = @NextAssyItemCode where ItemId = @ItemId

        select @ItemId

	END

    -----========================================================================
	if upper(@ItemType) = 'RAW_MATERIAL'
	BEGIN

          SELECT @NextItemRMNumber = ISNULL(
            MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),
            4999) + 1
            FROM Item
            WHERE ItemCode LIKE 'RM-%';

            set @NextRMItemCode = (SELECT 'RM-' + CAST(@NextItemRMNumber AS VARCHAR(20)));

	    INSERT INTO dbo.Item
        (
            CatgId, ItemGrpId, UomId, WareHouseId, TaxId,
            ItemType, ItemCode, HSNCode, ItemName, SuppItemName, ItemDesc, ItemRemarks,
            ItemStockQty, ItemMinQty, ItemMaxQty, ItemReOrderQty,
            ItemOrdPriority, ItemLocation, ItemIsActive, ItemSellingPrice,
            ItemStage, LevelNo, ParentItemId, ChildItemId, 
            ItemWeight, ItemSpeed, ItemTravelHeight, ItemHeight, ItemWidth, ItemDepth,     -- Added on 2/7/2026
            ItemCapacity, ItemFinish, ItemOpeningType, ItemDBG, ItemSubType,
            ItemNoOfLandings, ItemNoOfPassengers, ItemRangeMin, ItemRangeMax, ItemLength, ItemThickness,    -- Added On 6/7/2026
            CreatedUserId, CreatedDate
        )
        SELECT *
        FROM OPENJSON(@Item, '$.Raw_Material')
        WITH
        (
            CatgId INT,
            ItemGrpId INT,
            UomId INT,
            WareHouseId INT,
            TaxId INT,
            ItemType NVARCHAR(50),

            ItemCode NVARCHAR(50),
            HSNCode NVARCHAR(50),
            ItemName NVARCHAR(MAX),
            SuppItemName NVARCHAR(50),
            ItemDesc NVARCHAR(500),
    
            ItemRemarks NVARCHAR(500),
            ItemStockQty NUMERIC(18,2),
            ItemMinQty NUMERIC(18,2),
            ItemMaxQty NUMERIC(18,2),
            ItemReOrderQty NUMERIC(18,2),
    
            ItemOrdPriority NVARCHAR(50),
            ItemLocation NVARCHAR(500),
            ItemIsActive BIT,
            ItemSellingPrice NUMERIC(18,2),
            ItemStage NVARCHAR(50),
    
            LevelNo SMALLINT,

            ParentItemId INT,
            ChildItemId INT,

            ItemWeight INT,
            ItemSpeed INT,
            ItemTravelHeight INT,
            ItemHeight INT,
            ItemWidth INT,

            ItemDepth INT,
            ItemCapacity INT,
            ItemFinish NVARCHAR(100),
            ItemOpeningType NVARCHAR(100),
            ItemDBG NVARCHAR(100),
            ItemSubType NVARCHAR(100),

            ItemNoOfLandings INT, 
            ItemNoOfPassengers INT, 
            ItemRangeMin INT,
            ItemRangeMax INT,
            ItemLength INT,       
            ItemThickness INT,

            CreatedUserId INT,
            CreatedDate DATE
        );

        set @ItemId = SCOPE_IDENTITY()

        update Item set ItemCode = @NextRMItemCode where ItemId = @ItemId

        select @ItemId
	END
    -----========================================================================

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