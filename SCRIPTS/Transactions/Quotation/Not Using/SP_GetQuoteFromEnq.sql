USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteFromEnq]    Script Date: 13/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteFromEnq]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteFromEnq]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteFromEnq]    Script Date: 13/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteFromEnq]
(
	@EnquiryId int

)
----With Encryption
as

SET NOCOUNT ON;

BEGIN TRY
	--BEGIN TRANSACTION

	SELECT 
	   ------ Enquiry
	   [Enquiry].[EnquiryId]
      ,[Enquiry].[CompanyId]
      ,[Enquiry].[BranchId]
      ,[Enquiry].[EnqNo]   -- -- as 'Enquiry No'
      ,[Enquiry].[EnqSlno] 
      ,[Enquiry].[EnqDate] -- as --'Enquiry Date'
	 
	   ------ Client
	  ,[EnqClientGUID]
      ,[EnqConsultant]
      ,[EnqClientName]
      ,[EnqClientMobileNo]
      ,[EnqClientEmailId]

      ,[EnqClientAddress]
      ,[EnqClientCategory]
      ,[EnqLeadSource]
      ,[EnqSourceBy]


	   ------ Shaft
	  ,[EnqShaft].[ShaftType] -- as 'Shaft Type'
      ,[EnqShaft].[ShaftWidth] -- as 'Shaft Width'
      ,[EnqShaft].[ShaftDepth] -- as 'Shaft Depth'
	  ,[EnqShaft].[OverheadHeight]
	  ,[EnqShaft].[ElevatorPit]

	  ,[EnqShaft].[ElevatorSpeed]
	  ,[EnqShaft].[EnqProduct] -- as 'Product'
	  ,[EnqShaft].[NoOfPassengers]     
      ,[EnqShaft].[EnqProductType] -- as 'Product Type'
      ,[EnqShaft].[Capacity] -- as 'Capacity'

      ,[EnqShaft].[TotalFloors] -- as 'Total Floors'
     

	  ------ Floor
      ,[EnqFloor].[FloorDetails] -- as 'Floor Details'
      ,[EnqFloor].[NoStop] -- as 'No Stop'
      ,[EnqFloor].[NoStopDetails] -- as 'No of Stops'
      ,[EnqFloor].[TotalStops] -- as 'Total Stops'
	  ,[EnqFloor].[NoOfOpenings] -- as 'Total Stops'
      ,[EnqFloor].[PriceLess] -- as 'Priceless'
	  ,[ApproxFloorHeight] -- as 'Approx Floor Height'

 
		-------- Door
      ,[EnqDoor].[DoorOpening] -- as 'Door Opening'
	  ,[EnqDoor].[DoorFinish] -- as 'Door Finish'
      ,[EnqDoor].[DoorWidth] -- as 'Door Width'
      ,[EnqDoor].[DoorHeight] -- as 'Door Height'
      ,[EnqDoor].[DoubleEntrance] -- as 'Door Entrance'

      ,[EnqDoor].[DoubleEntranceType] '-- as Door Entrance Type'
      ,[EnqDoor].[DoubleEntranceTypeDetails] -- as 'Door Entrance Type Details'
      ,[EnqDoor].[NoOfDoorOpenings] -- as 'No Of Door Openings'

	 --   ------ CabinType
	  ,[EnqCabinType].[EnqCabinType] -- as 'Cabin Type'
      ,[EnqCabinType].[CabinWidth]   -- as 'CarIn Width'
      ,[EnqCabinType].[CabinDepth]   -- as 'CarIn Depth'
      ,[EnqCabinType].[CabinHeight] -- as 'CarIn Height'
      ,[EnqCabinType].[FlooringType] -- as 'Flooring Type'
      ,[EnqCabinType].[Handrail] -- as 'Handrail'


	 -- ------ Additional Feature
	  ,[EnqAdditionalFeature].[AdditionalFeatureName] -- as 'Additional Feature Name'
      --,[EnqAdditionalFeature].[Price] 'Price'

	FROM [dbo].[Enquiry]
	INNER JOIN [EnqClient] ON [EnqClient].EnquiryId = [Enquiry].EnquiryId
	INNER JOIN [EnqShaft] ON [EnqShaft].EnquiryId = [Enquiry].EnquiryId
	INNER JOIN [EnqFloor] ON [EnqFloor].EnquiryId = [Enquiry].EnquiryId
	INNER JOIN [EnqDoor] ON [EnqDoor].EnquiryId = [Enquiry].EnquiryId
	INNER JOIN [EnqCabinType] ON [EnqCabinType].EnquiryId = [Enquiry].EnquiryId
	INNER JOIN [EnqAdditionalFeature] ON [EnqAdditionalFeature].EnquiryId = [Enquiry].EnquiryId

	where [Enquiry].EnquiryId = @EnquiryId

	--FOR JSON PATH, ROOT('Quote')  -- ROOT WITHOUT_ARRAY_WRAPPER

	--COMMIT TRANSACTION
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