USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateItem]    Script Date: 06/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateItem]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateItem]    Script Date: 06/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateItem]
(
	@ItemId int,
	@Item nvarchar(max)	
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @ItemJson NVARCHAR(MAX) = -- Your JSON

        UPDATE I

        SET
            I.CatgId            = J.CatgId,
            I.ItemGrpId         = J.ItemGrpId,
            I.UomId             = J.UomId,
            I.WareHouseId       = J.WareHouseId,
            I.TaxId             = J.TaxId,

            I.ItemType          = J.ItemType,
            I.ItemCode          = J.ItemCode,
            I.HSNCode           = J.HSNCode,
            I.ItemName          = J.ItemName,
            I.SuppItemName      = J.SuppItemName,
            
            I.ItemDesc          = J.ItemDesc,
            I.ItemRemarks       = J.ItemRemarks,
            I.ItemStockQty      = J.ItemStockQty,
            I.ItemMinQty        = J.ItemMinQty,
            I.ItemMaxQty        = J.ItemMaxQty,
            
            I.ItemReOrderQty    = J.ItemReOrderQty,
            I.ItemOrdPriority   = J.ItemOrdPriority,
            I.ItemLocation      = J.ItemLocation,
            I.ItemIsActive      = J.ItemIsActive,
            
            I.ItemSellingPrice  = J.ItemSellingPrice,
            I.ItemStage         = J.ItemStage,
            I.LevelNo           = J.LevelNo,
            I.Height            = J.Height,
            I.Width             = J.Width,
            
            I.Depth             = J.Depth,
            I.Speed             = J.Speed,
            I.TravelHeight      = J.TravelHeight,
            I.Finish            = J.Finish,
            I.OpeningType       = J.OpeningType,
            
            I.[Weight]            = J.[Weight],
            I.ParentItemId      = J.ParentItemId,
            I.ChildItemId       = J.ChildItemId,
            I.ItemWeight        = J.ItemWeight,
            I.ItemSpeed         = J.ItemSpeed,
           
            I.ItemTravelHeight  = J.ItemTravelHeight,
            I.ItemHeight        = J.ItemHeight,
            I.ItemWidth         = J.ItemWidth,
            I.ItemDepth         = J.ItemDepth,
            I.ItemCapacity      = J.ItemCapacity,
            
            I.ItemFinish        = J.ItemFinish,
            I.ItemOpeningType   = J.ItemOpeningType,
            I.ItemDBG           = J.ItemDBG,
            I.ItemSubType       = J.ItemSubType,

            I.ItemNoOfLandings   = J.ItemNoOfLandings,
            I.ItemNoOfPassengers = J.ItemNoOfPassengers,
            I.ItemRangeMin       = J.ItemRangeMin,
            I.ItemRangeMax       = J.ItemRangeMax,
            I.ItemLength         = J.ItemLength,
            I.ItemThickness      = J.ItemThickness,

            I.ModifiedUserId     = J.ModifiedUserId,
            I.ModifiedDate       = J.ModifiedDate

        FROM dbo.Item I
        INNER JOIN OPENJSON(@Item, '$.Item')
        WITH
        (
            ItemId              INT,
            CatgId              INT,
            ItemGrpId           INT,
            UomId               INT,
            WareHouseId         INT,

            TaxId               INT,
            ItemType            NVARCHAR(100),
            ItemCode            NVARCHAR(100),
            HSNCode             NVARCHAR(100),
            ItemName            NVARCHAR(200),
            
            SuppItemName        NVARCHAR(200),
            ItemDesc            NVARCHAR(MAX),
            ItemRemarks         NVARCHAR(MAX),
            ItemStockQty        DECIMAL(18,2),
            ItemMinQty          DECIMAL(18,2),
            
            ItemMaxQty          DECIMAL(18,2),
            ItemReOrderQty      DECIMAL(18,2),
            ItemOrdPriority     INT,
            ItemLocation        NVARCHAR(100),
            ItemIsActive        BIT,
            
            ItemSellingPrice    DECIMAL(18,2),
            ItemStage           NVARCHAR(100),
            LevelNo             INT,
            Height              DECIMAL(18,2),
            Width               DECIMAL(18,2),
            
            Depth               DECIMAL(18,2),
            Speed               DECIMAL(18,2),
            TravelHeight        DECIMAL(18,2),
            Finish              NVARCHAR(100),
            OpeningType         NVARCHAR(100),
            
            [Weight]            DECIMAL(18,2),
            ParentItemId        INT,
            ChildItemId         INT,
            ItemWeight          DECIMAL(18,2),
            ItemSpeed           DECIMAL(18,2),

            ItemTravelHeight    DECIMAL(18,2),
            ItemHeight          DECIMAL(18,2),
            ItemWidth           DECIMAL(18,2),
            ItemDepth           DECIMAL(18,2),
            ItemCapacity        DECIMAL(18,2),
            
            ItemFinish          NVARCHAR(100),
            ItemOpeningType     NVARCHAR(100),
            ItemDBG             NVARCHAR(100),
            ItemSubType         NVARCHAR(100),

            ItemNoOfLandings INT, 
            ItemNoOfPassengers INT, 
            ItemRangeMin INT,
            ItemRangeMax INT,
            ItemLength INT,       
            ItemThickness INT,

            ModifiedUserId INT,
            ModifiedDate DATE

        ) J
        ON I.ItemId = @ItemId                      --J.ItemId;

		select @ItemId

	  
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


	
	 --(@St_Code,
		--	@TalukFlag_No,
		--	@Language_No,
		--	@St_Name, 
		--	@Dist_No,
		--	@Dist_Name, 
		--	@Taluk_No,
		--	@Taluk_Name, 
		--	@Max_Revisions, 
		--	@AsstCommisoner_Name, 
		--	@AsstCommisoner_Place, 
		--	@Tahasildar_Name,
		--	@Tahasildar_Place, 
		--	@Vendor_Name, 
		--	dbo.fn_MMDDYYYY(@Scroll_Eligible_Date), 
		--	@Draft_Date,
		--	@Draft_Place, 
		--	@Amd1_Name, 
		--	@Amd1_Date, 
		--	@Amd2_Name, 
		--	@Amd2_Date, 
		--	@Amd3_Name,
		--	@Amd3_Date, 
		--	@Amd4_Name, 
		--	@Amd4_Date, 
		--	@Amd5_Name, 
		--	@Amd5_Date, 
		--	@Amd6_Name, 
		--	@Amd6_Date, 
		--	@LbPublication_Date,
		--	@LbPublication_Place, 
		--	@LbAuthorised_Person, 
		--	@LBdate, 
		--	@Created_By,
		--	getdate()
  --         )

 --        (@St_Code,
			--@TalukFlag_No,
			--@Language_No,
			--@St_Name, 
			--@Dist_No,
			--@Dist_Name, 
			--@Taluk_No,
			--@Taluk_Name, 
			--@Max_Revisions, 
			--@AsstCommisoner_Name, 
			--@AsstCommisoner_Place, 
			--@Tahasildar_Name,
			--@Tahasildar_Place, 
			--@Vendor_Name, 
			--convert(varchar,@Scroll_Eligible_Date,101), 
			--convert(varchar,@Draft_Date,101), 
			--@Draft_Place, 
			--@Amd1_Name, 
			--convert(varchar,@Amd1_Date,101),  
			--@Amd2_Name, 
			--convert(varchar,@Amd2_Date, 101), 
			--@Amd3_Name,
			--convert(varchar,@Amd3_Date, 101), 
			--@Amd4_Name, 
			--convert(varchar,@Amd4_Date, 101), 
			--@Amd5_Name, 
			--convert(varchar,@Amd5_Date, 101), 
			--@Amd6_Name, 
			--convert(varchar,@Amd6_Date, 101), 
			--convert(varchar,@LbPublication_Date,101), 
			--@LbPublication_Place, 
			--@LbAuthorised_Person, 
			--convert(varchar,@LBdate, 101), 
			--@Created_By,
			--getdate()
   --        )



