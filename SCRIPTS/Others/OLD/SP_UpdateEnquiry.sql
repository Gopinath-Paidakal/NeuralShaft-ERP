USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateEnquiry]    Script Date: 12/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_UpdateEnquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Sp_UpdateEnquiry]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateEnquiry]    Script Date: 12/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_UpdateEnquiry]
(
	@EnqHdrId int,
	@EnqHdr nvarchar(Max)

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
	  --DECLARE @EnquiryId INT

    --    -- Get EnquiryId
    --    SELECT @EnquiryId = EnquiryId
    --    FROM OPENJSON(@Enquiry)
    --    WITH
    --    (
    --        EnquiryId INT
    --    )

	------------------------------------------------
    -- UPDATE ENQUIRY
    ------------------------------------------------
		UPDATE E
		SET
			EnqDate = J.EnqDate,
			EnqRefDetails = J.EnqRefDetails,
			EnqRemarks = J.EnqRemarks,
			Latitude = J.Latitude,
			Longitude = J.Longitude
		FROM Enquiry E
		CROSS APPLY OPENJSON(@EnqHdr,'$.EnqHdr')
		WITH
		(
			EnqDate DATE,
			EnqRefDetails NVARCHAR(200),
			EnqRemarks NVARCHAR(500),
			Latitude NVARCHAR(50),
			Longitude NVARCHAR(50)
		) J
		WHERE E.EnquiryId = @EnqHdrId

        ----------------------------------
        -- Update Client Details
        ----------------------------------
        UPDATE C
		SET

			C.EnqConsultant = J.EnqConsultant,
			C.EnqClientName = J.EnqClientName,
			C.EnqClientMobileNo = J.EnqClientMobileNo,
			C.EnqClientEmailId = J.EnqClientEmailId,
			C.EnqClientAddress = J.EnqClientAddress,
			
			C.EnqClientCategory = J.EnqClientCategory,
			C.EnqLeadSource = J.EnqLeadSource,
			C.EnqSourceBy = J.EnqSourceBy

		FROM EnqClient C
		CROSS APPLY OPENJSON(@EnqHdr,'$.EnqClient')
		WITH
		(
			EnqClientId int,

			EnqConsultant NVARCHAR(100),
			EnqClientName NVARCHAR(100),
			EnqClientMobileNo NVARCHAR(100),
			EnqClientEmailId NVARCHAR(100),
			EnqClientAddress NVARCHAR(100),
			EnqClientCategory NVARCHAR(100),
			
			EnqLeadSource NVARCHAR(100),
			EnqSourceBy NVARCHAR(100)

		) J
		WHERE C.EnqClientId = J.EnqClientId and C.EnqHdrId = @EnqHdrId


	------------------------------------------------
    -- UPDATE ENQUIRY
    ------------------------------------------------
	UPDATE EnqDtl
		SET
			-- EnqShaft
			E.ShaftType = J.ShaftType,
			E.ShaftWidth = J.ShaftWidth,
			E.ShaftDepth = J.ShaftDepth,
			E.OverheadHeight = J.OverheadHeight,
			E.ElevatorPit = J.ElevatorPit,
			
			E.ElevatorSpeed = J.ElevatorSpeed,
			E.EnqProduct = J.EnqProduct,
			E.NoOfPassengers = J.NoOfPassengers,
			E.EnqProductType = J.EnqProductType,
			E.Capacity = J.Capacity,
			E.TotalFloors = J.TotalFloors,

			-- Floor
			E.FloorDetails = J.FloorDetails,
			E.NoStop = J.NoStop,
			E.NoStopDetails = J.NoStopDetails,
			E.TotalStops = J.TotalStops,
			E.NoOfOpenings = J.NoOfOpenings,
			E.PriceLess = J.PriceLess,
			E.ApproxFloorHeight = J.ApproxFloorHeight,

			-- Door
			E.DoorOpening = J.DoorOpening,
			E.DoorFinish = J.DoorFinish,
			E.DoorWidth = J.DoorWidth,
			E.DoorHeight = J.DoorHeight,
			E.DoubleEntrance = J.DoubleEntrance,
			E.DoubleEntranceType = J.DoubleEntranceType,
			E.DoubleEntranceTypeDetails = J.DoubleEntranceTypeDetails,
			E.NoOfDoorOpenings = J.NoOfDoorOpenings,

			-- Cabin
			E.EnqCabinType = J.EnqCabinType,
			E.CabinWidth = J.CabinWidth,
			E.CabinDepth = J.CabinDepth,
			E.CabinHeight = J.CabinHeight,
			E.FlooringType = J.FlooringType,
			E.Handrail = J.Handrail,

			-- Additional
			E.AdditionalFeatureName = J.AdditionalFeatureName

		FROM EnqDtl E

		INNER JOIN OPENJSON(@EnqHdr, '$.EnqDtl')

		WITH (
			ShaftType NVARCHAR(100),
			ShaftWidth NVARCHAR(100),
			ShaftDepth NVARCHAR(100),
			OverheadHeight NVARCHAR(100),
			ElevatorPit NVARCHAR(100),

			ElevatorSpeed NUMERIC(8,2),
			EnqProduct NVARCHAR(100),
			NoOfPassengers SMALLINT,
			EnqProductType NVARCHAR(100),
			Capacity SMALLINT,
			TotalFloors SMALLINT,

			FloorDetails NVARCHAR(MAX),
			NoStop NVARCHAR(100),
			NoStopDetails NVARCHAR(100),
			TotalStops NVARCHAR(100),
			NoOfOpenings SMALLINT,
			PriceLess NUMERIC(18,2),
			ApproxFloorHeight SMALLINT,

			DoorOpening NVARCHAR(100),
			DoorFinish NVARCHAR(100),
			DoorWidth NVARCHAR(100),
			DoorHeight NVARCHAR(100),

			DoubleEntrance NVARCHAR(100),
			DoubleEntranceType NVARCHAR(100),
			DoubleEntranceTypeDetails NVARCHAR(MAX),
			NoOfDoorOpenings SMALLINT,

			EnqCabinType NVARCHAR(100),
			CabinWidth NVARCHAR(50),
			CabinDepth NVARCHAR(50),
			CabinHeight NVARCHAR(50),
			FlooringType NVARCHAR(50),
			Handrail NVARCHAR(50),

			AdditionalFeatureName NVARCHAR(500)
		) J
		ON E.EnqHdrId = @EnqHdrId;
					   
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


	--UPDATE E
		--SET
		--	EnqDate = J.EnqDate,
		--	EnqRefDetails = J.EnqRefDetails,
		--	EnqRemarks = J.EnqRemarks,
		--	Latitude = J.Latitude,
		--	Longitude = J.Longitude
		--FROM Enquiry E
		--CROSS APPLY OPENJSON(@Enquiry,'$.Enquiry')
		--WITH
		--(
		--	EnqDate DATE,
		--	EnqRefDetails NVARCHAR(200),
		--	EnqRemarks NVARCHAR(500),
		--	Latitude NVARCHAR(50),
		--	Longitude NVARCHAR(50)
		--) J
		--WHERE E.EnquiryId = @EnquiryId

  --      ----------------------------------
  --      -- Update Client Details
  --      ----------------------------------
  --      UPDATE C
		--SET

		--	C.EnqConsultant = J.EnqConsultant,
		--	C.EnqClientName = J.EnqClientName,
		--	C.EnqClientMobileNo = J.EnqClientMobileNo,
		--	C.EnqClientEmailId = J.EnqClientEmailId,
		--	C.EnqClientAddress = J.EnqClientAddress,
			
		--	C.EnqClientCategory = J.EnqClientCategory,
		--	C.EnqLeadSource = J.EnqLeadSource,
		--	C.EnqSourceBy = J.EnqSourceBy

		--FROM EnqClient C
		--CROSS APPLY OPENJSON(@Enquiry,'$.EnqClient')
		--WITH
		--(
		--	EnqClientId int,

		--	EnqConsultant NVARCHAR(100),
		--	EnqClientName NVARCHAR(100),
		--	EnqClientMobileNo NVARCHAR(100),
		--	EnqClientEmailId NVARCHAR(100),
		--	EnqClientAddress NVARCHAR(100),
		--	EnqClientCategory NVARCHAR(100),
			
		--	EnqLeadSource NVARCHAR(100),
		--	EnqSourceBy NVARCHAR(100)

		--) J
		--WHERE C.EnqClientId = J.EnqClientId and C.EnquiryId = @EnquiryId

  --      ----------------------------------
  --      -- Update Shaft Details
  --      ----------------------------------
		--UPDATE S
		--SET
		--	S.ShaftType = J.ShaftType,
		--	S.ShaftWidth = J.ShaftWidth,
		--	S.ShaftDepth = J.ShaftDepth,
		--	S.OverheadHeight = J.OverheadHeight,
		--	S.ElevatorPit = J.ElevatorPit,

		--	S.ElevatorSpeed = J.ElevatorSpeed,
		--	S.EnqProduct = J.EnqProduct,
		--	S.EnqProductType = J.EnqProductType,
		--	S.Capacity = J.Capacity,
		--	S.TotalFloors = J.TotalFloors
			

		--FROM EnqShaft S
		--CROSS APPLY OPENJSON(@Enquiry,'$.EnqShaftDetails')
		--WITH
		--(
		--	EnqShaftId int,

		--	ShaftType NVARCHAR(50),
		--	ShaftWidth NVARCHAR(50),
		--	ShaftDepth NVARCHAR(50),
		--	OverheadHeight NVARCHAR(50),
		--	ElevatorPit NVARCHAR(50),

		--	ElevatorSpeed NUMERIC(8,2),
		--	EnqProduct NVARCHAR(100),
		--	EnqProductType NVARCHAR(100),
		--	Capacity SMALLINT,
		--	TotalFloors SMALLINT
			
		--) J
		--WHERE S.EnqShaftId = J.EnqShaftId and S.EnquiryId = @EnquiryId

		------------------------------------
  --      -- Update Floor Details
  --      ----------------------------------
		--UPDATE F
		--	SET
		--		F.FloorDetails = J.FloorDetails,
		--		F.NoStop = J.NoStop,
		--		F.NoStopDetails = J.NoStopDetails,
		--		F.TotalStops = J.TotalStops,
		--		F.NoOfOpenings = J.NoOfOpenings,

		--		F.PriceLess = J.PriceLess,
		--		F.ApproxFloorHeight = J.ApproxFloorHeight

		--	FROM EnqFloor F
		--	INNER JOIN OPENJSON(@Enquiry,'$.EnqFloorDetails')
		--	WITH
		--	(
		--		EnqFloorId INT,

		--		FloorDetails NVARCHAR(MAX),
		--		NoStop NVARCHAR(100),
		--		NoStopDetails NVARCHAR(100),
		--		TotalStops NVARCHAR(100),
		--		NoOfOpenings smallint,

		--		PriceLess NUMERIC(18,2),
		--		ApproxFloorHeight SMALLINT
		--	) J
		--	ON F.EnqFloorId = J.EnqFloorId and F.EnquiryId = @EnquiryId
		------------------------------------
  --      -- Update Door Details
  --      ----------------------------------
		--UPDATE D
		--SET
		--	D.DoorOpening = J.DoorOpening,
		--	D.DoorFinish = J.DoorFinish,
		--	D.DoorWidth = J.DoorWidth,
		--	D.DoorHeight = J.DoorHeight,
		--	D.DoubleEntrance = J.DoubleEntrance,

		--	D.DoubleEntranceType = J.DoubleEntranceType,
		--	D.DoubleEntranceTypeDetails = J.DoubleEntranceTypeDetails,
		--	D.NoOfDoorOpenings = J.NoOfDoorOpenings

		--FROM EnqDoor D
		--INNER JOIN OPENJSON(@Enquiry,'$.EnqDoorDetails')
		--WITH
		--(
		--	EnqDoorTypeId INT,

		--	DoorOpening NVARCHAR(100),
		--	DoorFinish NVARCHAR(100),
		--	DoorWidth NVARCHAR(100),
		--	DoorHeight NVARCHAR(100),
		--	DoubleEntrance NVARCHAR(100),

		--	DoubleEntranceType NVARCHAR(100),
		--	DoubleEntranceTypeDetails NVARCHAR(MAX),
		--	NoOfDoorOpenings SMALLINT

		--) J
		--ON D.EnqDoorTypeId = J.EnqDoorTypeId and D.EnquiryId = @EnquiryId

		------------------------------------
  --      -- Update Cabin Details
  --      ----------------------------------
		--UPDATE C
		--SET
		--	C.EnqCabinType = J.EnqCabinType,
		--	C.CabinWidth = J.CabinWidth,
		--	C.CabinDepth = J.CabinDepth,
		--	C.CabinHeight = J.CabinHeight,
		--	C.FlooringType = J.FlooringType,

		--	C.Handrail = J.Handrail

		--FROM EnqCabinType C
		--INNER JOIN OPENJSON(@Enquiry,'$.EnqCabinDetails')
		--WITH
		--(
		--	EnqCabinTypeId int,

		--	EnqCabinType NVARCHAR(100),
		--	CabinWidth NVARCHAR(50),
		--	CabinDepth NVARCHAR(50),
		--	CabinHeight NVARCHAR(50),
		--	FlooringType NVARCHAR(50),

		--	Handrail NVARCHAR(50)
		--) J
		--ON C.EnqCabinTypeId = J.EnqCabinTypeId and C.EnquiryId = @EnquiryId
		------------------------------------
  --      -- Update Additional Feature Details
  --      ----------------------------------
		--UPDATE A
		--	SET
		--		A.AdditionalFeatureName = J.AdditionalFeatureName
		--		--A.Price = J.Price
		--	FROM EnqAdditionalFeature A
		--	INNER JOIN OPENJSON(@Enquiry,'$.AdditionalFeatures')
		--	WITH
		--	(
		--		AdditionalFeatureId INT,
		--		AdditionalFeatureName NVARCHAR(500)
		--		--Price NUMERIC(18,2)
		--	) J
		--	ON A.AdditionalFeatureId = J.AdditionalFeatureId and A.EnquiryId = @EnquiryId