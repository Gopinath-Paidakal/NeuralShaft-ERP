USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetItem]    Script Date: 08/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetItem]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetItem]    Script Date: 08/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetItem]
(
	@ItemType nvarchar(50) = ''
  
)
----With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY

 --  if upper(@ItemType) = 'PRODUCT'
	--BEGIN 

 --     SELECT (
 --       SELECT 
 --               --[ItemId],
 --               --ISNULL([ItemType], '') AS [ItemType],
 --               --ISNULL([ItemCode], '') AS [ItemCode],
 --               --ISNULL([ItemName], '') AS [ItemName],
 --               --ISNULL([HSNCode], '') AS [HSNCode]
 --              [ItemId]
 --             ,[CatgId]
 --             ,[ItemGrpId]
 --             ,[UomId]
 --             ,[WareHouseId]
 --             ,[Item].[TaxId]
 --             ,[DDTax].[TaxValue]
 --             ,[ItemType]
 --             ,[ItemCode]
 --             ,[Item].[HSNCode]
 --             ,[ItemName]
 --             ,[SuppItemName]
 --             ,[ItemDesc]
 --             ,[ItemRemarks]
 --             ,[ItemStockQty]
 --             ,[ItemMinQty]
 --             ,[ItemMaxQty]
 --             ,[ItemReOrderQty]
 --             ,[ItemOrdPriority]
 --             ,[ItemLocation]
 --             ,[ItemIsActive]
 --             ,[ItemSellingPrice]
 --             ,[ItemStage]
 --             ,[LevelNo]
 --             ,[Height]
 --             ,[Width]
 --             ,[Depth]
 --             ,[Speed]
 --             ,[TravelHeight]
 --             ,[Finish]
 --             ,[OpeningType]
 --             ,[Weight]
 --             ,[ParentItemId]
 --             ,[ChildItemId]

 --             ,[ItemWeight]
 --             ,[ItemSpeed]
 --             ,[ItemTravelHeight]
 --             ,[ItemHeight]
 --             ,[ItemWidth]
 --             ,[ItemDepth]
 --             ,[ItemCapacity]
 --             ,[ItemFinish]
 --             ,[ItemOpeningType]
 --             ,[ItemDBG]
 --             ,[ItemSubType]

 --             ,[DefaultData].[DefaultDataName] as 'UOM'

 --             ,[Item].[CreatedUserId]
 --             ,[Item].[CreatedDate]

 --           FROM [dbo].[Item]
 --           INNER JOIN [DefaultData] ON [DefaultData].DefaultDataId = [Item].[UomId]
 --           INNER JOIN [DefaultData] [DDTax] ON [DDTax].[DefaultDataId] = [Item].[TaxId]

 --           WHERE ItemType = upper('Item')

 --           Order By ItemType
 --           FOR JSON PATH, ROOT('Item')

 --       ) AS ItemData;
 --   END

    if upper(@ItemType) = 'RAW-MATERIAL'
	BEGIN 

      SELECT (
        SELECT 
               
               [ItemId]
              ,[CatgId]
              ,[ItemGrpId]
              ,[UomId]
              ,[WareHouseId]

              ,[TaxId]
              ,[DDTax].[TaxValue]
              ,[ItemType]
              ,[ItemCode]
              ,[Item].[HSNCode]
              ,[ItemName]
              
              ,[SuppItemName]
              ,[ItemDesc]
              ,[ItemRemarks]
              ,[ItemStockQty]
              ,[ItemMinQty]
              
              ,[ItemMaxQty]
              ,[ItemReOrderQty]
              ,[ItemOrdPriority]
              ,[ItemLocation]
              ,[ItemIsActive]
              
              ,[ItemSellingPrice]
              ,[ItemStage]
              ,[LevelNo]
              ,[Height]
              ,[Width]
              
              ,[Depth]
              ,[Speed]
              ,[TravelHeight]
              ,[Finish]
              ,[OpeningType]
              
              ,[Weight]
              ,[ParentItemId]
              ,[ChildItemId]

              ,[ItemWeight]
              ,[ItemSpeed]
              ,[ItemTravelHeight]
              ,[ItemHeight]
              ,[ItemWidth]

              ,[ItemDepth]
              ,[ItemCapacity]
              ,[ItemFinish]
              ,[ItemOpeningType]
              ,[ItemDBG]
              ,[ItemSubType]

              ,[DefaultData].[DefaultDataName] as 'UOM'

              ,[Item].[CreatedUserId]
              ,[Item].[CreatedDate]

            FROM [dbo].[Item]
            INNER JOIN [DefaultData] ON [DefaultData].DefaultDataId = [Item].[UomId]
            INNER JOIN [DefaultData] [DDTax] ON [DDTax].[DefaultDataId] = [Item].[TaxId]
            --WHERE ItemType = upper(@ItemType)

            Order By ItemType
            FOR JSON PATH, ROOT('Raw-Material')

        ) AS ItemData;
    END

 --   if upper(@ItemType) = 'ASSEMBLY'
	--BEGIN 

 --     SELECT (
 --       SELECT 
                
 --              [ItemId]
 --             ,[CatgId]
 --             ,[ItemGrpId]
 --             ,[UomId]
 --             ,[WareHouseId]
 --             ,[TaxId]
 --             ,[ItemType]
 --             ,[ItemCode]
 --             ,[HSNCode]
 --             ,[ItemName]
 --             ,[SuppItemName]
 --             ,[ItemDesc]
 --             ,[ItemRemarks]
 --             ,[ItemStockQty]
 --             ,[ItemMinQty]
 --             ,[ItemMaxQty]
 --             ,[ItemReOrderQty]
 --             ,[ItemOrdPriority]
 --             ,[ItemLocation]
 --             ,[ItemIsActive]
 --             ,[ItemSellingPrice]
 --             ,[ItemStage]
 --             ,[LevelNo]
 --             ,[Height]
 --             ,[Width]
 --             ,[Depth]
 --             ,[Speed]
 --             ,[TravelHeight]
 --             ,[Finish]
 --             ,[OpeningType]
 --             ,[Weight]
 --             ,[ParentItemId]
 --             ,[ChildItemId]
 --             ,[CreatedUserId]
 --             ,[CreatedDate]

 --           FROM [dbo].[Item]
 --            WHERE ItemType = upper('ASSEMBLY')
 --           Order By ItemType
 --           FOR JSON PATH, ROOT('Assembly')

 --       ) AS ItemData;
 --   END

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


 --[ItemId],
                --ISNULL([ItemType], '') AS [ItemType],
                --ISNULL([ItemCode], '') AS [ItemCode],
                --ISNULL([ItemName], '') AS [ItemName],
                --ISNULL([HSNCode], '') AS [HSNCode]


	--[ItemId],
                --ISNULL([ItemType], '') AS [ItemType],
                --ISNULL([ItemCode], '') AS [ItemCode],
                --ISNULL([ItemName], '') AS [ItemName],
                --ISNULL([HSNCode], '') AS [HSNCode]



    
                --ISNULL([DefaultDataName], '') AS [DefaultDataName],
                --ISNULL([DefaultDataDesc], '') AS [DefaultDataDesc],
                --ISNULL([DefaultDataStatus], '') AS [DefaultDataStatus],
                --ISNULL([Price], 0) AS [Price],
                --ISNULL([DefaultTotalStops], 0) AS [faultTotalStops],

                --ISNULL([DefaultCapacity], 0) AS [DefaultCapacity],
                --ISNULL([DefaultWeight], 0) AS [DefaultWeight],
                --ISNULL([DefaultNoStopPrice], 0) AS [DefaultNoStopPrice],
                --ISNULL([DouEntType], '') AS [DouEntType],
                --ISNULL([DouEntPrice901st], 0) AS [DouEntPrice901st],

                --ISNULL([DouEntPrice902nd], 0) AS [DouEntPrice902nd],
                --ISNULL([DouEntPrice1801st], 0) AS [DouEntPrice1801st],
                --ISNULL([DouEntPrice1802nd], 0) AS [DouEntPrice1802nd],
                --ISNULL([DouEntPrice1803rd], 0) AS [DouEntPrice1803rd],
                --ISNULL([DefaultCabinWidth], 0) AS [DefaultCabinWidth],

                --ISNULL([DefaultCabinDepth], 0) AS [DefaultCabinDepth],
                --ISNULL([DefaultCabinHeight], 0) AS [DefaultCabinHeight],
                --ISNULL([ShaftTypeWidth], 0) AS [ShaftTypeWidth],
                --ISNULL([ShaftTypeDepth], 0) AS [ShaftTypeDepth],
                --ISNULL([ElevatorSpeed], 0) AS [ElevatorSpeed],

                --ISNULL([DefaultOverheadHeight], 0) AS [DefaultOverheadHeight],
                --ISNULL([DefaultElevatorPit], 0) AS [DefaultElevatorPit],
                --ISNULL([DefaultMaxFloors], 0) AS [DefaultMaxFloors],
                --ISNULL([DefaultMinWidthSingle], 0) AS [DefaultMinWidthSingle],
                --ISNULL([DefaultMinDepthSingle], 0) AS [DefaultMinDepthSingle],

                --ISNULL([DefaultMinWidthDouble], 0) AS [DefaultMinWidthDouble],
                --ISNULL([DefaultMinDepthDouble], 0) AS [DefaultMinDepthDouble],

                --ISNULL([DefaultMinWidthTriple], 0) AS [DefaultMinWidthTriple],
                --ISNULL([DefaultMinDepthTriple], 0) AS [DefaultMinDepthTriple],

                --ISNULL([DefaultDoorHeight], 0) AS [DefaultDoorHeight],
                --ISNULL([DefaultDoorWidth], 0) AS [DefaultDoorWidth],
                --ISNULL([DefaultDoorMinShaftWidth], 0) AS [DefaultDoorMinShaftWidth],

                --ISNULL([DefaultDataOrderBy], 0) AS [DefaultDataOrderBy],
                
                --ISNULL([DefaultPowerSupply], 0) AS [DefaultPowerSupply],
                --ISNULL([DefaultMachine], 0) AS [DefaultMachine],
                --ISNULL([DefaultDrive], 0) AS [DefaultDrive],
                --ISNULL([DefaultController], 0) AS [DefaultController],
                --ISNULL([DefaultOperation], 0) AS [DefaultOperation],

                --ISNULL([DefaultGuideRails], 0) AS [DefaultGuideRails],
                --ISNULL([DefaultRope], 0) AS [DefaultRope],
                --ISNULL([DefaultSpecialFeatures], 0) AS [DefaultSpecialFeatures],
                --ISNULL([DoorFormulaMultiply], 0) AS [DoorFormulaMultiply],
                --ISNULL([DoorFormulaAdd], 0) AS [DoorFormulaAdd],

                --ISNULL([DoorTechWidth], 0) AS [DoorTechWidth],
                --ISNULL([DoorTechDepth], 0) AS [DoorTechDepth]

                ---- ISNULL([CreatedBy], '') AS [CreatedBy],
                ----ISNULL([CreatedDate], 0) AS [CreatedDat

 --SELECT 
            --    [FormDefaultDataId],
            --    ISNULL([FormType], '') AS [FormType],
            --    ISNULL([FormDefaultDataType], '') AS [FormDefaultDataType],
            --    ISNULL([FormDefaultProductWidth], 0) AS [FormDefaultProductWidth],
            --    ISNULL([FormDefaultProductDepth], 0) AS [FormDefaultProductDepth],
            --    ISNULL([FormDefaultDataName], '') AS [FormDefaultDataName],
            --    ISNULL([FormDefaultDataDesc], '') AS [FormDefaultDataDesc],
            --    ISNULL([FormDefaultDataStatus], '') AS [FormDefaultDataStatus],
            --    ISNULL([Price], 0) AS [Price],
            --    ISNULL([FormDefaultTotalStops], 0) AS [FormDefaultTotalStops],
            --    ISNULL([FormDefaultCapacity], 0) AS [FormDefaultCapacity],
            --    ISNULL([FormDefaultWeight], 0) AS [FormDefaultWeight],
            --    ISNULL([FormDefaultNoStopPrice], 0) AS [FormDefaultNoStopPrice],
            --    ISNULL([DoubleEntrancePrice901st], 0) AS [DoubleEntrancePrice901st],
            --    ISNULL([DoubleEntrancePrice902nd], 0) AS [DoubleEntrancePrice902nd],
            --    ISNULL([DoubleEntrancePrice1801st], 0) AS [DoubleEntrancePrice1801st],
            --    ISNULL([DoubleEntrancePrice1802nd], 0) AS [DoubleEntrancePrice1802nd],
            --    ISNULL([DoubleEntrancePrice1803rd], 0) AS [DoubleEntrancePrice1803rd],
            --    ISNULL([FormDefaultCabinWidth], 0) AS [FormDefaultCabinWidth],
            --    ISNULL([FormDefaultCabinDepth], 0) AS [FormDefaultCabinDepth],
            --    ISNULL([FormDefaultCabinHeight], 0) AS [FormDefaultCabinHeight],
            --    ISNULL([FormDefaultDataOrderBy], 0) AS [FormDefaultDataOrderBy]
            --FROM [dbo].[FormDefaultData]


            --     SELECT 
	--	(
	--	SELECT 
	--  [FormDefaultDataId]
 --     ,isnull([FormType], '') as [FormType]
 --     ,isnull([FormDefaultDataType], '') as [FormDefaultDataType]
 --     ,isnull([FormDefaultProductWidth], 0) as [FormDefaultProductWidth]
 --     ,isnull([FormDefaultProductDepth],0)  as [FormDefaultProductDepth]

 --     ,isnull([FormDefaultDataName], '') as [FormDefaultDataName]
 --     ,isnull([FormDefaultDataDesc], '') as [FormDefaultDataDesc]
 --     ,isnull([FormDefaultDataStatus], '') as [FormDefaultDataStatus]
 --     ,isnull([Price], 0) as [Price]
 --     ,isnull([FormDefaultTotalStops], 0) as [FormDefaultTotalStops]

 --     ,isnull([FormDefaultCapacity], 0) as [FormDefaultCapacity]
 --     ,isnull([FormDefaultWeight], 0)  as [FormDefaultWeight]
 --     ,isnull([FormDefaultNoStopPrice], 0) as [FormDefaultNoStopPrice]
 --     ,isnull([DoubleEntrancePrice901st], 0) as [DoubleEntrancePrice901st]
 --     ,isnull([DoubleEntrancePrice902nd], 0) as [DoubleEntrancePrice902nd]

 --     ,isnull([DoubleEntrancePrice1801st], 0) as [DoubleEntrancePrice1801st]
 --     ,isnull([DoubleEntrancePrice1802nd], 0) as [DoubleEntrancePrice1802nd]
 --     ,isnull([DoubleEntrancePrice1803rd], 0) as [DoubleEntrancePrice1803rd]
 --     ,isnull([FormDefaultCabinWidth], 0) as [FormDefaultCabinWidth]
 --     ,isnull([FormDefaultCabinDepth], 0) as [FormDefaultCabinDepth]

 --     ,isnull([FormDefaultCabinHeight], 0) as [FormDefaultCabinHeight]
 --     ,isnull([FormDefaultDataOrderBy], 0) as [FormDefaultDataOrderBy]
 --     --,[CreatedBy]
 --     --,[CreatedDate]

	--  FROM [dbo].[FormDefaultData]

	--  FOR JSON PATH, ROOT('FormDefaultData'))  --, WITHOUT_ARRAY_WRAPPER

	----) as NVARCHAR(max)) AS FormDefaultData