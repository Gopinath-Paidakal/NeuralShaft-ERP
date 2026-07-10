Declare @SODtlId int = 11
Declare @SOHdrId int = 62
Declare @JobOrderId int = 9

Declare @OrdClientId int = 162

Declare @ProductId int
Declare @Product nvarchar(30)
Declare @NoOfLandings int = 0
Declare @CarDoors int = 0

Declare @Passengers int = 0
Declare @ApproxFloorHeight int = 0
Declare @BaseToLandingHeight int = 0

Declare @OverHeadHeight int = 0
Declare @Pit int = 0

Declare @Total int = 0

Declare @BracketCount int = 0

Declare @GuideRailLength int = 0
Declare @GuideRailCount int = 0
Declare @LandingDoors int = 0

Declare @SOLandDoorType varchar(100) 
Declare @SOLandDoorFinishType varchar(100) 
Declare @SOLandDoorWidth int = 0
Declare @SOLandDoorHeight int = 0



Set @OrdClientId = (Select OrdClientHdrId from SOHdr where SOHdrId = @SOHdrId)
Set @ProductId = (Select DDProductId from SODtl where SODtlId = @SODtlId)
Set @Product = (Select SOProduct from SODtl where SODtlId = @SODtlId)

Set @NoOfLandings = (Select NoOfOpenings from SODtl where SODtlId = @SODtlId)
Set @Passengers = (Select NoOfPassengers from SODtl where SODtlId = @SODtlId)
Set @Pit = (Select ElevatorPit from SODtl where SODtlId = @SODtlId)
Set @ApproxFloorHeight = (Select ApproxFloorHeight from SODtl where SODtlId = @SODtlId)
Set @OverHeadHeight = (Select OverheadHeight from SODtl where SODtlId = @SODtlId)

Set @BaseToLandingHeight = (@ApproxFloorHeight * @NoOfLandings)

Set @LandingDoors = (Select count(*) from SOLandDoor where SODtlId = @SODtlId)
Set @SOLandDoorType = (Select Top 1 SOLandDoorType from SOLandDoor where SODtlId = @SODtlId)
Set @SOLandDoorFinishType = (Select Top 1  SOLandDoorFinishType from SOLandDoor where SODtlId = @SODtlId)
Set @SOLandDoorWidth = (Select Top 1  SOLandDoorWidth from SOLandDoor where SODtlId = @SODtlId)
Set @SOLandDoorHeight = (Select Top 1   SOLandDoorHeight from SOLandDoor where SODtlId = @SODtlId)

--Set @CarDoors = (Select count(*) from SOCarDoor where SODtlId = @SODtlId)

Set @Total = (@BaseToLandingHeight + @OverHeadHeight + @Pit)

Set @BracketCount = (@Total / 1500)
Set @GuideRailCount = (@Total / 5000)

--Select @OrdClientId as 'OrdClientId',
--       @Product as 'Product', 
--       @NoOfLandings as 'No Of Landings', 
--       @Passengers as 'Passengers',
--       @BaseToLandingHeight as 'BaseToLandingHeight',

--       @OverHeadHeight as 'OverHeadHeight',
--       @Pit as 'Pit',

--       @Total as 'Total',
--       @BracketCount as 'BracketCount',
--       @GuideRailCount as 'GuideRailCount',
--       @LandingDoors as 'LandingDoors',

--       @SOLandDoorType as 'SOLandDoorType',
--       @SOLandDoorFinishType as 'SOLandDoorFinishType',
--       @SOLandDoorWidth as 'SOLandDoorWidth',
--       @SOLandDoorHeight as 'SOLandDoorHeight'

IF OBJECT_ID('tempdb..#BOMAssembly') IS NOT NULL
    DROP TABLE #BOMAssembly;

DROP TABLE IF EXISTS #BOMAssembly;

CREATE TABLE #BOMAssembly
(
    --SourceTable     NVARCHAR(20),
    BOMMstId        INT NULL,
    ProductId       INT NULL,

    AssemblyHdrId   INT NULL,
    AssemblyItemId  INT NULL,

    ItemId          INT,
    --ItemName        NVARCHAR(150),
    
    ItemQty         INT NULL,
    ReqItemQty      INT NULL,
    TotalQty        INT NULL

);

INSERT INTO #BOMAssembly
(
    BOMMstId,
    ProductId,

    AssemblyHdrId,
    AssemblyItemId,
    ItemId,

    ItemQty,
    ReqItemQty,
    TotalQty
)
SELECT
    
    BOMMst.BOMMstId,
    BOMMst.ProductId,

    BOMMst.AssemblyHdrId,
    NULL,

    [BOMMst].ItemId,
    
    BOMMst.ItemQty,
    0 AS ReqItemQty,
    0 AS TotalQty

FROM dbo.BOMMst
--INNER JOIN [ITEM] On [ITEM].[ItemId] = [BOMMst].[ItemId];

INSERT INTO #BOMAssembly
(
    BOMMstId,
    ProductId,
    AssemblyHdrId,
    AssemblyItemId,

    ItemId,
    
    ItemQty,
    ReqItemQty,
    TotalQty
)
SELECT

    NULL,
    NULL,
    [AssemblyItem].AssemblyHdrId,
    [AssemblyItem].AssemblyItemId,

    [AssemblyItem].ItemId,
    

    ItemQty,

    0  AS ReqItemQty,
    0  AS TotalQty

FROM dbo.AssemblyItem
INNER JOIN [ITEM] On [ITEM].[ItemId] = [AssemblyItem].[ItemId];


--select * from #BOMAssembly

 ----------- SO Landing Doors
 Declare @TotLandingDoors int

 set @TotLandingDoors = (select count(*) from [SOLandDoor] 

          LEFT JOIN [Item] On [Item].ItemOpeningType = [SOLandDoor].[SOLandDoorType] and 
                               [Item].ItemFinish = [SOLandDoor].[SOLandDoorFinishType] and
                               [Item].ItemWidth = [SOLandDoor].[SOLandDoorWidth] and
                               [Item].ItemHeight = [SOLandDoor].[SOLandDoorHeight] 
          where SODtlId = 12 and ItemType = 'Landing Doors') 

          --group by [SOLandDoor].[SOLandDoorType],[SOLandDoor].[SOLandDoorFinishType], [SOLandDoor].[SOLandDoorWidth],
          --                     [SOLandDoor].[SOLandDoorHeight])

 Select @TotLandingDoors

 Insert into #BOMAssembly (AssemblyHdrId, ItemId, ItemQty)
 SELECT 
              -- [SOLandDoorId]
               --[SODtlId]
              --[SOLandFloorType]
             --  [SOLandDoorType]
             -- ,[SOLandDoorFinishType]

              --,[SOLandDoorAngle]
             -- ,[SOLandDoorSide]
             -- ,[SOLandDoorHeight]
             -- ,[SOLandDoorWidth]
              --,[SOLandDoorDescription]

              --,[SOLandDoorAmount]
              14,
              [Item].ItemId as 'ItemId',
              [Item].ItemType as 'ItemType'
              --,[Item].ItemName as 'ItemName'    
              ,count(*) as 'Count'

          FROM [dbo].[SOLandDoor] 

          LEFT JOIN [Item] On [Item].ItemOpeningType = [SOLandDoor].SOLandDoorType and 
                               [Item].ItemFinish = [SOLandDoor].[SOLandDoorFinishType] and
                               [Item].ItemWidth = [SOLandDoor].[SOLandDoorWidth] and
                               [Item].ItemHeight = [SOLandDoor].[SOLandDoorHeight] 

          where SODtlId = 12 and ItemType = 'Landing Doors'

          group by [SOLandDoor].[SOLandDoorType],[SOLandDoor].[SOLandDoorFinishType], [SOLandDoor].[SOLandDoorWidth],
                                [SOLandDoor].[SOLandDoorHeight], [Item].ItemId

   
   select [Item].itemId, [Item].ItemName,  ItemQty, ReqItemQty
   
   from #BOMAssembly
   Inner join [Item] on [item].itemid = #BOMAssembly.ItemId

   --where AssemblyHdrId = 14 --order by AssemblyHdrId

   --update #BOMAssembly set ReqItemQty =  (ItemQty * @TotLandingDoors) where 



        ----------- SO Car Doors

          --  SELECT [SOCarDoorId]
          --    ,[SODtlId]
          --    ,[SOCarFloorType]
          --    ,[SOCarDoorType]
          --    ,[SOCarDoorFinishType]
          --    ,[SOCarDoorAngle]
           
          --    ,[SOCarDoorSide]
          --    ,[SOCarDoorHeight]
          --    ,[SOCarDoorWidth]
          --    ,[SOCarDoorDescription]
          --    --,[SOCarDoorAmount]
          --    --,[SOCrudType]
          --    ,[Item].ItemId as 'ItemId'
          --    ,[Item].ItemName as 'ItemName'          

          --FROM [dbo].[SOCarDoor]

          --LEFT JOIN [Item] On [Item].ItemOpeningType = [SOCarDoor].SOCarDoorType and 
          --                     [Item].ItemFinish = [SOCarDoor].[SOCarDoorFinishType] and
          --                     [Item].ItemWidth = [SOCarDoor].[SOCarDoorWidth] and
          --                     [Item].ItemHeight = [SOCarDoor].[SOCarDoorHeight] 

          --where SODtlId = @SODtlId


























--SELECT
--    'BOMMst' AS SourceTable,
--    BOMMstId,
--    NULL AS AssemblyItemId,
--    ProductId,
--    AssemblyHdrId,
--    ItemId,
--    ItemQty
--INTO #BOMAssembly
--FROM dbo.BOMMst

--UNION ALL

--SELECT
--    'AssemblyItem',
--    NULL,
--    AssemblyItemId,
--    NULL,
--    AssemblyHdrId,
--    ItemId,
--    ItemQty
--FROM dbo.AssemblyItem;


































--CREATE TABLE #SODTLBOM
--(
--    --JobOrderBOMId INT,
--    --SODtlId INT,
--    --SOHdrId INT,
--    --OrdClientHdrId INT,
--    --JobOrderId INT,

--    ProductId INT,
--    AssemblyHdrId INT,
--    AssemblyItemId  INT NULL,

--    ItemId INT,
--    ItemQty INT,
--    ReqItemQty INT,
--    TotalQty INT

  
--);

--Insert into #SODTLBOM (AssemblyHdrId, ItemId, ItemQty) select AssemblyHdrId, ItemId, ItemQty From AssemblyItem
--Insert into #SODTLBOM (ProductId, ItemId, ItemQty) select ItemId, ItemQty From BOMMst

--Select * from #SODTLBOM


  --BOMMstId        INT NULL,
  --  AssemblyItemId  INT NULL,
  --  ProductId       INT NULL,
  --  AssemblyHdrId   INT,
  --  ItemId          INT,
  --  ItemQty         DECIMAL(18,2)






















       --@CarDoors,

--DROP TABLE #JobOrderBOM;

--CREATE TABLE #JobOrderBOM
--(
--    --JobOrderBOMId INT,
--    SODtlId INT,
--    SOHdrId INT,
--    OrdClientHdrId INT,
--    JobOrderId INT,

--    ProductId INT,
--    AssemblyHdrId INT,
--    ItemId INT,
--    ItemQty DECIMAL(18,2),   

--    CreatedUserId INT,
--    CreatedDate DATETIME
--);

--INSERT INTO #JobOrderBOM
--INSERT INTO JobOrderBOM
--SELECT
--    @SODtlId,
--    @SOHdrId,
--    @JobOrderId,
--    @OrdClientId,

--    ProductId,
--    AssemblyHdrId,
--    ItemId,
--    ItemQty,
--    CreatedUserId,
--    CreatedDate

--FROM BOMMst
--Where ProductId = 226

--Select * from JobOrderBOM










