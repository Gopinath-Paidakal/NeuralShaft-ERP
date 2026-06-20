Declare @enqstr nvarchar(max)

declare @EnqHdrId int = 141
declare @EnqDtlId int = 135

SELECT
    JSON_QUERY(
        (
            SELECT
                [CompanyId],
                [BranchId],
                [EnqNo],
                [EnqSlno],
                [EnqDate],
                [EnqRefDetails],
                [EnqRemarks],
                [EnqStatus],
                [Latitude],
                [Longitude],
                [CreatedBy],
                [CreatedDate]
            FROM [dbo].[EnqHdr]
            WHERE EnqHdrId = @EnqHdrId
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    ) AS EnqHdr,

    JSON_QUERY(
        (
            SELECT *
            FROM EnqClient
            WHERE EnqHdrId = @EnqHdrId
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    ) AS EnqClient,

    JSON_QUERY(
        (
            SELECT *
            FROM EnqDtl
            WHERE EnqHdrId = @EnqHdrId
              AND EnqDtlId = @EnqDtlId
              AND Deleted = 0
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    ) AS EnqDtl,

    JSON_QUERY(
        (
            SELECT *
            FROM EnqLandDoor
            WHERE EnqDtlId = @EnqDtlId
            FOR JSON PATH
        )
    ) AS EnqLandDoor,

    JSON_QUERY(
        (
            SELECT *
            FROM EnqCarDoor
            WHERE EnqDtlId = @EnqDtlId
            FOR JSON PATH
        )
    ) AS EnqCarDoor

FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

--SELECT
--    -- EnqHdr
--    (
--        SELECT
--            [CompanyId],
--            [BranchId],
--            [EnqNo],
--            [EnqSlno],
--            [EnqDate],
--            [EnqRefDetails],
--            [EnqRemarks],
--            [EnqStatus],
--            [Latitude],
--            [Longitude],
--            [CreatedBy],
--            [CreatedDate]
--        FROM [dbo].[EnqHdr]
--        WHERE EnqHdrId = @EnqHdrId
--        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--    ) AS EnqHdr,

--    -- EnqClient
--    (
--        SELECT
--            [EnqClientId],
--            [EnqHdrId],
--            [EnqClientGUID],
--            [EnqConsultant],
--            [EnqClientName],
--            [EnqClientMobileNo],
--            [EnqClientEmailId],
--            [EnqClientAddress],
--            [EnqClientCategory],
--            [EnqLeadSource],
--            [EnqSourceBy],
--            [EnqContactPerson]
--        FROM EnqClient
--        WHERE EnqHdrId = @EnqHdrId
--        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--    ) AS EnqClient,

--    -- EnqDtl
--    (
--        SELECT
--            *
--        FROM [dbo].[EnqDtl]
--        WHERE EnqHdrId = @EnqHdrId 
--          AND EnqDtlId = @EnqDtlId 
--          AND Deleted = 0
--        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--    ) AS EnqDtl,

--    -- EnqLandDoor (ARRAY)
--    (
--        SELECT
--            *
--        FROM [dbo].[EnqLandDoor]
--        WHERE EnqDtlId = @EnqDtlId
--        FOR JSON PATH
--    ) AS EnqLandDoor,

--    -- EnqCarDoor (ARRAY)
--    (
--        SELECT
--            *
--        FROM [dbo].[EnqCarDoor]
--        WHERE EnqDtlId = @EnqDtlId
--        FOR JSON PATH
--    ) AS EnqCarDoor

--FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

--{
--	SELECT
--          [CompanyId],
--          [BranchId],
--          [EnqNo],
--          [EnqSlno],
--          [EnqDate],
--          [EnqRefDetails],
--          [EnqRemarks],
--          [EnqStatus],
--          [Latitude],
--          [Longitude],
--          [CreatedBy],
--          [CreatedDate]
--    FROM [dbo].[EnqHdr] 
--    WHERE EnqHdrId = @EnqHdrId 
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER



---- =========== EnqClient
--    SELECT
--		   [EnqClientId]
--		  ,[EnqHdrId]
--		  ,[EnqClientGUID]
--		  ,[EnqConsultant]
--		  ,[EnqClientName]
--		  ,[EnqClientMobileNo]
--		  ,[EnqClientEmailId]
--		  ,[EnqClientAddress]
--		  ,[EnqClientCategory]
--		  ,[EnqLeadSource]
--		  ,[EnqSourceBy]
--          ,[EnqContactPerson]
--    FROM EnqClient
--    WHERE EnqHdrId = @EnqHdrId 
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

--    -----========== EnqDtl
--	SELECT [EnqDtlId]
--      ,[EnqHdrId]
--      ,[QuoteHdrId]
--      ,[ShaftType]
--      ,[ShaftWidth]
--      ,[ShaftDepth]
--      ,[OverheadHeight]

--      ,[ElevatorPit]
--      ,[ElevatorSpeed]
--      ,[EnqProduct]
--      ,[NoOfPassengers]
--      ,[EnqProductType]
      
--      ,[Capacity]
--      ,[TotalFloors]
--      ,[FloorDetails]
--      ,[NoStop]
--      ,[NoStopDetails]
      
--      ,[TotalStops]
--      ,[NoOfOpenings]
--      ,[PriceLess]
--      ,[ApproxFloorHeight]
--      ,[DoorOpening]
      
--      ,[DoorFinish]
--      ,[DoorWidth]
--      ,[DoorHeight]
--      ,[DoubleEntrance]
--      ,[DoubleEntranceType]
      
--      ,[DoubleEntranceTypeDetails]
--      ,[NoOfDoorOpenings]
--      ,[EnqCabinType]
--      ,[CabinWidth]
--      ,[CabinDepth]
      
--      ,[CabinHeight]
--      ,[FlooringType]
--      ,[Handrail]
--      ,[AdditionalFeatureName]

--      ,[CarDoorOpening]
--      ,[CarDoorFinish]
--      ,[CarDoorWidth]
--      ,[CarDoorHeight]
--      ,[PowerSupply]
      
--      ,[Machine]
--      ,[Drive]
--      ,[Controller]
--      ,[Operation]
--      ,[GuideRails]
--      ,[Rope]

--      ,[EnqQty]
--      ,[EnqProductAmount]
--      ,[EnqTaxAmount]
--      ,[EnqTotalAmount]

--      ,[EnqProdSplFeature]
--      ,[EnqFalseCeilingType]

--      ,[Deleted]
--      ,[SOGen]

--     FROM [dbo].[EnqDtl]
--     WHERE EnqHdrId = @EnqHdrId and  EnqDtlId = @EnqDtlId and EnqDtl.Deleted = 0
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

-- SELECT [EnqLandDoorId]
--      ,[EnqDtlId]
--      ,[LandFloorType]
--      ,[LandDoorType]
--      ,[LandDoorFinishType]

--      ,[LandDoorAngle]
--      ,[LandDoorSide]
--      ,[LandDoorHeight]
--      ,[LandDoorWidth]
--      ,[LandDoorDescription]
--      ,[LandDoorAmount]

--  FROM [dbo].[EnqLandDoor]

--  WHERE [EnqLandDoor].EnqDtlId = @EnqDtlId 
--  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

-- SELECT [EnqCarDoorId]
--      ,[EnqDtlId]
--      ,[CarFloorType]
--      ,[CarDoorType]
--      ,[CarDoorFinishType]
--      ,[CarDoorAngle]

--      ,[CarDoorSide]
--      ,[CarDoorHeight]
--      ,[CarDoorWidth]
--      ,[CarDoorDescription]
--      ,[CarDoorAmount]

--  FROM [dbo].[EnqCarDoor]

--  WHERE [EnqCarDoor].EnqDtlId = @EnqDtlId and EnqDtlId = @EnqDtlId
--  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER


----FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

----select @enqstr
