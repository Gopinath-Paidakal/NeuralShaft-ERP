USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnquiry_ById]    Script Date: 11/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetEnquiry_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetEnquiry_ById]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEnquiry_ById]    Script Date: 11/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetEnquiry_ById]
(
	@EnquiryId int

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	SELECT
(
    -- =========== Enquiry
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
    FROM [dbo].[Enquiry]
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS Enquiry,

(
	-- =========== EnqClient
    SELECT
		   [EnqClientId]
		  ,[EnquiryId]
		  ,[EnqClientGUID]
		  ,[EnqConsultant]
		  ,[EnqClientName]
		  ,[EnqClientMobileNo]
		  ,[EnqClientEmailId]
		  ,[EnqClientAddress]
		  ,[EnqClientCategory]
		  ,[EnqLeadSource]
		  ,[EnqSourceBy]
    FROM EnqClient
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS EnqClient,

(
    -----========== EnqShaft
	SELECT [EnqShaftId]
      ,[EnquiryId]
      ,[ShaftType]
      ,[ShaftWidth]
      ,[ShaftDepth]
      ,[OverheadHeight]
      ,[ElevatorPit]
      ,[ElevatorSpeed]
      ,[EnqProduct]
      ,[NoOfPassengers]
      ,[EnqProductType]
      ,[Capacity]
      ,[TotalFloors]
    FROM [dbo].[EnqShaft]
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS EnqShaft,

(
    --- =========== EnqDoor
SELECT [EnqDoorTypeId]
      ,[EnquiryId]
      ,[DoorOpening]
      ,[DoorFinish]
      ,[DoorWidth]
      ,[DoorHeight]
      ,[DoubleEntrance]
      ,[DoubleEntranceType]
      ,[DoubleEntranceTypeDetails]
      ,[NoOfDoorOpenings]
    FROM [dbo].[EnqDoor]
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS EnqDoor,

(
   ---========== EnqFloor
 SELECT [EnqFloorId]
      ,[EnquiryId]
      ,[FloorDetails]
      ,[NoStop]
      ,[NoStopDetails]
      ,[TotalStops]
      ,[NoOfOpenings]
      ,[PriceLess]
      ,[ApproxFloorHeight]
    FROM [dbo].[EnqFloor]
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS EnqFloor,
---========== Cabin Type
(
    SELECT [EnqCabinTypeId]
      ,[EnquiryId]
      ,[EnqCabinType]
      ,[CabinWidth]
      ,[CabinDepth]
      ,[CabinHeight]
      ,[FlooringType]
      ,[Handrail]
    FROM [dbo].[EnqCabinType]
    WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS EnqCabinType,

(
	SELECT [AdditionalFeatureId]
      ,[EnquiryId]
      ,[AdditionalFeatureName]     
	FROM [dbo].[EnqAdditionalFeature]
	WHERE EnquiryId = @EnquiryId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) As AdditionalFeature

FOR JSON PATH, WITHOUT_ARRAY_WRAPPER 

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