USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnquiryHdr_ById]    Script Date: 11/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEnquiryHdr_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEnquiryHdr_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnquiryHdr_ById]    Script Date: 11/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEnquiryHdr_ById]
(
	@EnqHdrId int
    --@EnqDtlId int

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

Declare @enqstr nvarchar(max)
Declare @EnqDtlId int

   -- set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

    set @enqstr = (
    SELECT
    (
        -- =========== EnqHdr
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
              
              [CreatedUserId],
              [CreatedDate]

        FROM [dbo].[EnqHdr]
        WHERE EnqHdrId = @EnqHdrId
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS EnqHdr,

    (
	    -- =========== EnqClient
        SELECT
		       [EnqClientId]
		      ,[EnqHdrId]
		      ,[EnqClientGUID]
		      ,[EnqConsultant]
		      ,[EnqClientName]
		      ,[EnqClientMobileNo]
		      ,[EnqClientEmailId]
		      ,[EnqClientAddress]
		      ,[EnqClientCategory]
		      ,[EnqLeadSource]
		      ,[EnqSourceBy]
              ,[EnqContactPerson]
        FROM EnqClient
        WHERE EnqHdrId = @EnqHdrId
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS EnqClient,

    (
        -----========== EnqDtl
	    SELECT [EnqDtlId]
          ,[EnqHdrId]
          ,[QuoteHdrId]
          ,[EnqProduct]
          ,[NoOfPassengers]
          ,[TotalStops]

          ,[DoorOpening]
          ,[DoorFinish]
          ,[DoorWidth]
          ,[EnqProdSplFeature]

          ,[Deleted]
          ,[CustomerStatus]
          ,[OrderStatus]
          ,[ApprovalStatus1]
          ,[ApprovalStatus2]

          ,[SOGen] 
             

         FROM [dbo].[EnqDtl]
         WHERE EnqHdrId = @EnqHdrId and EnqDtl.Deleted = 0
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS EnqDtl

        
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

    select @enqstr


END TRY

	BEGIN CATCH
		
		--ROLLBACK TRANSACTION
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














 --(
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
    --) AS EnqLandDoor,

    --(
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

    --  WHERE [EnqCarDoor].EnqDtlId = @EnqDtlId 
    --  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    --) AS EnqCarDoor
   


-- set @enqstr = (SELECT 
--    *,
    

--    (SELECT * 
--     FROM EnqClient C 
--     WHERE C.EnqHdrId = H.EnqHdrId
--     FOR JSON PATH) AS Clients,

--    (SELECT * 
--     FROM EnqDtl D 
--     WHERE D.EnqHdrId = H.EnqHdrId
--     FOR JSON PATH) AS Details

--FROM EnqHdr H
--WHERE EnqHdrId = 29

--FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

--select @enqstr



--set @enqstr = (SELECT 
--    *,
    

--    (SELECT * 
--     FROM EnqClient C 
--     WHERE C.EnqHdrId = H.EnqHdrId
--     FOR JSON PATH) AS Clients,

--    (SELECT * 
--     FROM EnqDtl D 
--     WHERE D.EnqHdrId = H.EnqHdrId
--     FOR JSON PATH) AS Details

--FROM EnqHdr H
--WHERE EnqHdrId = 29

--FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

--select @enqstr


















































    -----========== EnqShaft
--	SELECT [EnqShaftId]
--      ,[EnquiryId]
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
--    FROM [dbo].[EnqShaft]
--    WHERE EnquiryId = @EnquiryId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqShaft,

--(
--    --- =========== EnqDoor
--SELECT [EnqDoorTypeId]
--      ,[EnquiryId]
--      ,[DoorOpening]
--      ,[DoorFinish]
--      ,[DoorWidth]
--      ,[DoorHeight]
--      ,[DoubleEntrance]
--      ,[DoubleEntranceType]
--      ,[DoubleEntranceTypeDetails]
--      ,[NoOfDoorOpenings]
--    FROM [dbo].[EnqDoor]
--    WHERE EnquiryId = @EnquiryId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqDoor,

--(
--   ---========== EnqFloor
-- SELECT [EnqFloorId]
--      ,[EnquiryId]
--      ,[FloorDetails]
--      ,[NoStop]
--      ,[NoStopDetails]
--      ,[TotalStops]
--      ,[NoOfOpenings]
--      ,[PriceLess]
--      ,[ApproxFloorHeight]
--    FROM [dbo].[EnqFloor]
--    WHERE EnquiryId = @EnquiryId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqFloor,
-----========== Cabin Type
--(
--    SELECT [EnqCabinTypeId]
--      ,[EnquiryId]
--      ,[EnqCabinType]
--      ,[CabinWidth]
--      ,[CabinDepth]
--      ,[CabinHeight]
--      ,[FlooringType]
--      ,[Handrail]
--    FROM [dbo].[EnqCabinType]
--    WHERE EnquiryId = @EnquiryId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqCabinType,

--(
--	SELECT [AdditionalFeatureId]
--      ,[EnquiryId]
--      ,[AdditionalFeatureName]     
--	FROM [dbo].[EnqAdditionalFeature]
--	WHERE EnquiryId = @EnquiryId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) As AdditionalFeature
