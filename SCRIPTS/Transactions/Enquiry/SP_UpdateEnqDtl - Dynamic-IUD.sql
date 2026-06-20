USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateEnqDtl]    Script Date: 24/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateEnqDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateEnqDtl]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateEnqDtl]    Script Date: /03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateEnqDtl]
(
	@EnqDtlId int,
	@EnqDtl nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
	------------------------------------------------
	-- UPDATE ENQDTL
	------------------------------------------------
	UPDATE E
		
		SET
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
			--E.AdditionalFeatureName = J.AdditionalFeatureName,

			E.CarDoorOpening = J.CarDoorOpening,
			E.CarDoorFinish = J.CarDoorFinish,
			E.CarDoorWidth = J.carDoorWidth,
			E.CarDoorHeight = J.carDoorHeight,

			E.ProductAmount = J.ProductAmount,
			E.FloorNameAmount = J.FloorNameAmount,
			E.DoorTypeAmount = J.DoorTypeAmount,
			E.CarDoorTypeAmount = J.CarDoorTypeAmount,
			E.DoorFinishAmount = J.DoorFinishAmount,

			E.CabinTypeAmount = J.CabinTypeAmount,
			E.FlooringTypeAmount = J.FlooringTypeAmount,
			E.AddnlFeatureAmount = J.AddnlFeatureAmount,

			E.PowerSupply = J.PowerSupply, 
			E.Machine = J.Machine,
			E.Drive = J.Drive,
			E.Controller = J.Controller,
			E.Operation = J.Operation,
			
			E.GuideRails = J.GuideRails,
			E.Rope = J.Rope,
			E.EnqProdSplFeature = J.EnqProdSplFeature,
			E.EnqFalseCeilingType = J.EnqFalseCeilingType

			FROM EnqDtl E

			INNER JOIN OPENJSON(@EnqDtl, '$.EnqDtl')

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

				AdditionalFeatureName NVARCHAR(500),
				CarDoorOpening NVARCHAR(100),
				CarDoorFinish NVARCHAR(100),
				CarDoorWidth NVARCHAR(100),
				CarDoorHeight NVARCHAR(100),
				
				ProductAmount NUMERIC(18,2),
				FloorNameAmount NUMERIC(18,2),
				DoorTypeAmount NUMERIC(18,2),
				CarDoorTypeAmount NUMERIC(18,2),
				DoorFinishAmount NUMERIC(18,2),

				CabinTypeAmount NUMERIC(18,2),
				FlooringTypeAmount NUMERIC(18,2),
				AddnlFeatureAmount NUMERIC(18,2),

				PowerSupply NVARCHAR(200),
				Machine NVARCHAR(200),
				Drive NVARCHAR(200),
				Controller NVARCHAR(200),
				Operation NVARCHAR(200),
				
				GuideRails NVARCHAR(200),
				Rope NVARCHAR(200),
				EnqProdSplFeature NVARCHAR(500),
				EnqFalseCeilingType NVARCHAR(100)

			) J

		ON E.EnqDtlId = @EnqDtlId;

		---===================================================
		---- Update EnqLandDoor
		--====================================================
		
        DECLARE @SourceCount INT;

        ---------------------------------------------------
        -- Step 1: Parse JSON into table variable
        ---------------------------------------------------
       
        DECLARE @SourceLandDoor TABLE
        (
            EnqLandDoorId INT,
            EnqDtlId INT,
            LandFloorType NVARCHAR(50),
            LandDoorType NVARCHAR(50),
            LandDoorFinishType NVARCHAR(50),
            LandDoorAngle DECIMAL(10,2),
            LandDoorSide NVARCHAR(50),
            LandDoorHeight DECIMAL(10,2),
            LandDoorWidth DECIMAL(10,2),
            
            LandDoorDescription NVARCHAR(255),
            LandDoorAmount DECIMAL(18,2)
        );

        INSERT INTO @SourceLandDoor
        SELECT
            EnqLandDoorId,
            EnqDtlId, 

			LandFloorType,
            LandDoorType,
            LandDoorFinishType,
            LandDoorAngle,
            LandDoorSide,

            LandDoorHeight,
            LandDoorWidth,
         
            LandDoorDescription,
            LandDoorAmount
        FROM OPENJSON(@EnqDtl, '$.EnqLandDoor')
        WITH
        (
            EnqLandDoorId INT,
			EnqDtlId int,

            LandFloorType NVARCHAR(50),
            LandDoorType NVARCHAR(50),
            LandDoorFinishType NVARCHAR(50),
            LandDoorAngle DECIMAL(10,2),
            LandDoorSide NVARCHAR(50),

            LandDoorHeight DECIMAL(10,2),
            LandDoorWidth DECIMAL(10,2),
       
            LandDoorDescription NVARCHAR(255),
            LandDoorAmount DECIMAL(18,2)
        );

        --SELECT * FROM @SourceLandDoor;

        ---------------------------------------------------
        -- Step 2: Safety Check
        ---------------------------------------------------
        --SELECT @SourceCount = COUNT(*) FROM @SourceLandDoor;

        --IF @SourceCount = 0
        --BEGIN
        --    RAISERROR ('No Land Door data provided.', 16, 1);
        --    ROLLBACK TRANSACTION;
        --    RETURN;
        --END

        ---------------------------------------------------
        -- Step 3: MERGE
        ---------------------------------------------------
        MERGE INTO EnqLandDoor AS Target
        USING @SourceLandDoor AS Source
        ON Target.EnqLandDoorId = Source.EnqLandDoorId
           --AND Target.EnqDtlId = @EnqDtlId   -- 🔒 scope protection

        ---------------------------------------------------
        -- ✅ UPDATE
        ---------------------------------------------------
        WHEN MATCHED THEN
            UPDATE SET
                Target.LandFloorType       = Source.LandFloorType,
                Target.LandDoorType        = Source.LandDoorType,
                Target.LandDoorFinishType  = Source.LandDoorFinishType,
                Target.LandDoorAngle       = Source.LandDoorAngle,
                Target.LandDoorSide        = Source.LandDoorSide,

                Target.LandDoorHeight      = Source.LandDoorHeight,
                Target.LandDoorWidth       = Source.LandDoorWidth,
                
                Target.LandDoorDescription = Source.LandDoorDescription,
                Target.LandDoorAmount      = Source.LandDoorAmount

            ---------------------------------------------------
            -- ✅ INSERT
            ---------------------------------------------------
            WHEN NOT MATCHED BY TARGET THEN
                INSERT
                (
                    EnqDtlId,

                    LandFloorType,
                    LandDoorType,
                    LandDoorFinishType,
                    LandDoorAngle,
                    LandDoorSide,
                
				    LandDoorHeight,
                    LandDoorWidth,
               
                    LandDoorDescription,
                    LandDoorAmount
                )
                VALUES
                (
                    Source.EnqDtlId,

                    Source.LandFloorType,
                    Source.LandDoorType,
                    Source.LandDoorFinishType,
                    Source.LandDoorAngle,
                    Source.LandDoorSide,
                
				    Source.LandDoorHeight,
                    Source.LandDoorWidth,
            
                    Source.LandDoorDescription,
                    Source.LandDoorAmount
                );

        ---------------------------------------------------
        -- 🔒 SAFE DELETE
        ---------------------------------------------------
        --WHEN NOT MATCHED BY SOURCE
        --     AND Target.EnqDtlId = @EnqDtlId
        --     AND @SourceCount > 0
        --THEN DELETE;


		--DELETE T
		--FROM EnqLandDoor T
		--WHERE T.EnqDtlId = @EnqDtlId
		--AND NOT EXISTS
		--(
		--	SELECT 1
		--	FROM @SourceLandDoor S
		--	WHERE S.EnqLandDoorId = T.EnqLandDoorId
		--	AND S.EnqLandDoorId IS NOT NULL
		--	AND S.EnqLandDoorId > 0
		--);


		

		---===================================================
		---- Update EnqCarDoor
		--====================================================
		 ---------------------------------------------------
        -- Step 1: Parse JSON into table variable
        ---------------------------------------------------
        DECLARE @SourceCarDoor TABLE
        (
            EnqCarDoorId INT,
            EnqDtlId INT,

            CarFloorType NVARCHAR(50),
            CarDoorType NVARCHAR(50),
            CarDoorFinishType NVARCHAR(50),
            CarDoorAngle DECIMAL(10,2),
            CarDoorSide NVARCHAR(50),
            
			CarDoorHeight DECIMAL(10,2),
            CarDoorWidth DECIMAL(10,2),
            CarDoorDescription NVARCHAR(255),
            CarDoorAmount DECIMAL(18,2)
        );

        INSERT INTO @SourceCarDoor
        SELECT
            EnqCarDoorId,
            EnqDtlId, 

            CarFloorType,
            CarDoorType,
            CarDoorFinishType,
            CarDoorAngle,
            CarDoorSide,
            
			CarDoorHeight,
            CarDoorWidth,
            CarDoorDescription,
            CarDoorAmount

        FROM OPENJSON(@EnqDtl,'$.EnqCarDoor')
        WITH
        (
            EnqCarDoorId INT,
			EnqDtlId int,

            CarFloorType NVARCHAR(50),
            CarDoorType NVARCHAR(50),
            CarDoorFinishType NVARCHAR(50),
            CarDoorAngle DECIMAL(10,2),
            CarDoorSide NVARCHAR(50),

            CarDoorHeight DECIMAL(10,2),
            CarDoorWidth DECIMAL(10,2),
            CarDoorDescription NVARCHAR(255),
            CarDoorAmount DECIMAL(18,2)
        );

        ---------------------------------------------------
        -- Step 2: Safety Check
        ---------------------------------------------------
        --SELECT @SourceCount = COUNT(*) FROM @SourceCarDoor;

        --IF @SourceCount = 0
        --BEGIN
        --    RAISERROR ('No Car Door data provided.', 16, 1);
        --    ROLLBACK TRANSACTION;
        --    RETURN;
        --END

        ---------------------------------------------------
        -- Step 3: MERGE
        ---------------------------------------------------
        MERGE INTO EnqCarDoor AS Target
        USING @SourceCarDoor AS Source
        ON Target.EnqCarDoorId = Source.EnqCarDoorId
           --AND Target.EnqDtlId = @EnqDtlId   -- 🔒 scope protection

        ---------------------------------------------------
        -- ✅ UPDATE
        ---------------------------------------------------
        WHEN MATCHED THEN
            UPDATE SET
                Target.CarFloorType       = Source.CarFloorType,
                Target.CarDoorType        = Source.CarDoorType,
                Target.CarDoorFinishType  = Source.CarDoorFinishType,
                Target.CarDoorAngle       = Source.CarDoorAngle,
                Target.CarDoorSide        = Source.CarDoorSide,
                
				Target.CarDoorHeight      = Source.CarDoorHeight,
                Target.CarDoorWidth       = Source.CarDoorWidth,
                Target.CarDoorDescription = Source.CarDoorDescription,
                Target.CarDoorAmount      = Source.CarDoorAmount

        ---------------------------------------------------
        -- ✅ INSERT
        ---------------------------------------------------
        WHEN NOT MATCHED BY TARGET THEN
            INSERT
            (
                EnqDtlId,

                CarFloorType,
                CarDoorType,
                CarDoorFinishType,
                CarDoorAngle,
                CarDoorSide,
                
				CarDoorHeight,
                CarDoorWidth,
                CarDoorDescription,
                CarDoorAmount
            )
            VALUES
            (
                Source.EnqDtlId,
                Source.CarFloorType,
                Source.CarDoorType,
                Source.CarDoorFinishType,
                Source.CarDoorAngle,
                
				Source.CarDoorSide,
                Source.CarDoorHeight,
                Source.CarDoorWidth,
                Source.CarDoorDescription,
                Source.CarDoorAmount
            );

        ---------------------------------------------------
        -- 🔒 SAFE DELETE
        ---------------------------------------------------
        --WHEN NOT MATCHED BY SOURCE
        --     AND Target.EnqDtlId = @EnqDtlId
        --     AND @SourceCount > 0
        --THEN DELETE;



		--- Retun value Enq Dtl Id to api
		Select @EnqDtlId

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



--MERGE dbo.EnqLandDoor WITH (HOLDLOCK) AS TARGET
--USING OPENJSON(@Json)
--WITH (
--    EnqLandDoorId INT,
--    EnqDtlId INT,
--    LandFloorType NVARCHAR(100),
--    LandDoorType NVARCHAR(100),
--    LandDoorFinishType NVARCHAR(100),
--    LandDoorAngle INT,
--    LandDoorSide NVARCHAR(50),
--    LandDoorHeight INT,
--    LandDoorWidth INT,
--    LandDoorDepth INT,
--    LandDoorDescription NVARCHAR(500),
--    LandDoorAmount NUMERIC(18,2)
--) AS SOURCE
--ON TARGET.EnqLandDoorId = SOURCE.EnqLandDoorId

---- ✅ UPDATE existing
--WHEN MATCHED THEN
--UPDATE SET
--    TARGET.EnqDtlId = SOURCE.EnqDtlId,
--    TARGET.LandFloorType = SOURCE.LandFloorType,
--    TARGET.LandDoorType = SOURCE.LandDoorType,
--    TARGET.LandDoorFinishType = SOURCE.LandDoorFinishType,
--    TARGET.LandDoorAngle = SOURCE.LandDoorAngle,
--    TARGET.LandDoorSide = SOURCE.LandDoorSide,
--    TARGET.LandDoorHeight = SOURCE.LandDoorHeight,
--    TARGET.LandDoorWidth = SOURCE.LandDoorWidth,
--    TARGET.LandDoorDepth = SOURCE.LandDoorDepth,
--    TARGET.LandDoorDescription = SOURCE.LandDoorDescription,
--    TARGET.LandDoorAmount = SOURCE.LandDoorAmount

---- ✅ INSERT new
--WHEN NOT MATCHED BY TARGET THEN
--INSERT (
--    EnqLandDoorId,
--    EnqDtlId,
--    LandFloorType,
--    LandDoorType,
--    LandDoorFinishType,
--    LandDoorAngle,
--    LandDoorSide,
--    LandDoorHeight,
--    LandDoorWidth,
--    LandDoorDepth,
--    LandDoorDescription,
--    LandDoorAmount
--)
--VALUES (
--    SOURCE.EnqLandDoorId,
--    SOURCE.EnqDtlId,
--    SOURCE.LandFloorType,
--    SOURCE.LandDoorType,
--    SOURCE.LandDoorFinishType,
--    SOURCE.LandDoorAngle,
--    SOURCE.LandDoorSide,
--    SOURCE.LandDoorHeight,
--    SOURCE.LandDoorWidth,
--    SOURCE.LandDoorDepth,
--    SOURCE.LandDoorDescription,
--    SOURCE.LandDoorAmount
--)

---- ✅ DELETE missing (very important)
--WHEN NOT MATCHED BY SOURCE THEN
--DELETE;





 --MERGE dbo.EnqLandDoor AS TARGET
 --   USING (
 --       SELECT *
 --       FROM OPENJSON(@Json)
 --       WITH (
 --           EnqLandDoorId INT,
 --           EnqDtlId INT,
 --           LandFloorType NVARCHAR(100),
 --           LandDoorType NVARCHAR(100),
 --           LandDoorFinishType NVARCHAR(100),
 --           LandDoorAngle INT,
 --           LandDoorSide NVARCHAR(50),
 --           LandDoorHeight INT,
 --           LandDoorWidth INT,
 --           LandDoorDepth INT,
 --           LandDoorDescription NVARCHAR(500),
 --           LandDoorAmount NUMERIC(18,2)
 --       )
 --   ) AS SOURCE
 --   ON TARGET.EnqLandDoorId = SOURCE.EnqLandDoorId

 --   -- ✅ UPDATE if exists
 --   WHEN MATCHED THEN
 --       UPDATE SET
 --           TARGET.EnqDtlId = SOURCE.EnqDtlId,
 --           TARGET.LandFloorType = SOURCE.LandFloorType,
 --           TARGET.LandDoorType = SOURCE.LandDoorType,
 --           TARGET.LandDoorFinishType = SOURCE.LandDoorFinishType,
 --           TARGET.LandDoorAngle = SOURCE.LandDoorAngle,
 --           TARGET.LandDoorSide = SOURCE.LandDoorSide,
 --           TARGET.LandDoorHeight = SOURCE.LandDoorHeight,
 --           TARGET.LandDoorWidth = SOURCE.LandDoorWidth,
 --           TARGET.LandDoorDepth = SOURCE.LandDoorDepth,
 --           TARGET.LandDoorDescription = SOURCE.LandDoorDescription,
 --           TARGET.LandDoorAmount = SOURCE.LandDoorAmount

 --   -- ✅ INSERT if not exists
 --   WHEN NOT MATCHED BY TARGET THEN
 --       INSERT (
 --           EnqLandDoorId,
 --           EnqDtlId,
 --           LandFloorType,
 --           LandDoorType,
 --           LandDoorFinishType,
 --           LandDoorAngle,
 --           LandDoorSide,
 --           LandDoorHeight,
 --           LandDoorWidth,
 --           LandDoorDepth,
 --           LandDoorDescription,
 --           LandDoorAmount
 --       )
 --       VALUES (
 --           SOURCE.EnqLandDoorId,
 --           SOURCE.EnqDtlId,
 --           SOURCE.LandFloorType,
 --           SOURCE.LandDoorType,
 --           SOURCE.LandDoorFinishType,
 --           SOURCE.LandDoorAngle,
 --           SOURCE.LandDoorSide,
 --           SOURCE.LandDoorHeight,
 --           SOURCE.LandDoorWidth,
 --           SOURCE.LandDoorDepth,
 --           SOURCE.LandDoorDescription,
 --           SOURCE.LandDoorAmount
 --       );































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



			--MERGE dbo.EnqLandDoor AS TARGET
			--USING (
			--	SELECT *
			--	FROM OPENJSON(@EnqDtl)
			--	WITH (
			--		EnqLandDoorId INT,
			--		EnqDtlId INT,
			--		LandFloorType NVARCHAR(100),
			--		LandDoorType NVARCHAR(100),
			--		LandDoorFinishType NVARCHAR(100),
			--		LandDoorAngle INT,
			--		LandDoorSide NVARCHAR(50),
			--		LandDoorHeight INT,
			--		LandDoorWidth INT,
			--		LandDoorDepth INT,
			--		LandDoorDescription NVARCHAR(500),
			--		LandDoorAmount NUMERIC(18,2)
			--	)
			--) AS SOURCE
			--ON TARGET.EnqLandDoorId = SOURCE.EnqLandDoorId

			----  UPDATE if exists
			--WHEN MATCHED THEN
			--	UPDATE SET
			--		TARGET.EnqDtlId = SOURCE.EnqDtlId,
			--		TARGET.LandFloorType = SOURCE.LandFloorType,
			--		TARGET.LandDoorType = SOURCE.LandDoorType,
			--		TARGET.LandDoorFinishType = SOURCE.LandDoorFinishType,
			--		TARGET.LandDoorAngle = SOURCE.LandDoorAngle,
			--		TARGET.LandDoorSide = SOURCE.LandDoorSide,
			--		TARGET.LandDoorHeight = SOURCE.LandDoorHeight,
			--		TARGET.LandDoorWidth = SOURCE.LandDoorWidth,
			--		TARGET.LandDoorDepth = SOURCE.LandDoorDepth,
			--		TARGET.LandDoorDescription = SOURCE.LandDoorDescription,
			--		TARGET.LandDoorAmount = SOURCE.LandDoorAmount

			----  INSERT if not exists
			--WHEN NOT MATCHED BY TARGET THEN
			--	INSERT (
			--		--EnqLandDoorId,
			--		EnqDtlId,
			--		LandFloorType,
			--		LandDoorType,
			--		LandDoorFinishType,
			--		LandDoorAngle,
			--		LandDoorSide,
			--		LandDoorHeight,
			--		LandDoorWidth,
			--		LandDoorDepth,
			--		LandDoorDescription,
			--		LandDoorAmount
			--	)
			--	VALUES (
			--		--SOURCE.EnqLandDoorId,
			--		SOURCE.EnqDtlId,
			--		SOURCE.LandFloorType,
			--		SOURCE.LandDoorType,
			--		SOURCE.LandDoorFinishType,
			--		SOURCE.LandDoorAngle,
			--		SOURCE.LandDoorSide,
			--		SOURCE.LandDoorHeight,
			--		SOURCE.LandDoorWidth,
			--		SOURCE.LandDoorDepth,
			--		SOURCE.LandDoorDescription,
			--		SOURCE.LandDoorAmount
			--	);

		--UPDATE ELD
		--SET 
			
		--	--ELD.EnqDtlId = J.EnqDtlId,

		--	ELD.LandFloorType = J.LandFloorType,
		--	ELD.LandDoorType = J.LandDoorType,
		--	ELD.LandDoorFinishType = J.LandDoorFinishType,
		--	ELD.LandDoorAngle = J.LandDoorAngle,
		--	ELD.LandDoorSide = J.LandDoorSide,

		--	ELD.LandDoorHeight = J.LandDoorHeight,
		--	ELD.LandDoorWidth = J.LandDoorWidth,
		--	ELD.LandDoorDepth = J.LandDoorDepth,
		--	ELD.LandDoorDescription = J.LandDoorDescription,
		--	ELD.LandDoorAmount = J.LandDoorAmount

		--FROM dbo.EnqLandDoor ELD
		--INNER JOIN OPENJSON(@EnqDtl, '$.EnqLandDoor')
		--WITH (
		--		EnqLandDoorId INT,
		--		EnqDtlId INT,

		--		LandFloorType NVARCHAR(100),
		--		LandDoorType NVARCHAR(100),
		--		LandDoorFinishType NVARCHAR(100),
		--		LandDoorAngle INT,
		--		LandDoorSide NVARCHAR(50),

		--		LandDoorHeight INT,
		--		LandDoorWidth INT,
		--		LandDoorDepth INT,
		--		LandDoorDescription NVARCHAR(500),
		--		LandDoorAmount NUMERIC(18,2)
		--) J
		--ON ELD.EnqLandDoorId = J.EnqLandDoorId and ELD.EnqDtlId = J.EnqDtlId;


		
		--MERGE dbo.EnqCarDoor AS TARGET
		--	USING (
		--		SELECT *
		--		FROM OPENJSON(@EnqDtl)
		--		WITH (
		--			EnqCarDoorId INT,
		--			EnqDtlId INT,
		--			CarFloorType NVARCHAR(100),
		--			CarDoorType NVARCHAR(100),
		--			CarDoorFinishType NVARCHAR(100),
		--			CarDoorAngle INT,
		--			CarDoorSide NVARCHAR(50),
		--			CarDoorHeight INT,
		--			CarDoorWidth INT,
		--			CarDoorDepth INT,
		--			CarDoorDescription NVARCHAR(500),
		--			CarDoorAmount NUMERIC(18,2)
		--		)
		--	) AS SOURCE
		--	ON TARGET.EnqCarDoorId = SOURCE.EnqCarDoorId

		--	-- ✅ UPDATE if exists
		--	WHEN MATCHED THEN
		--		UPDATE SET
		--			TARGET.EnqDtlId = SOURCE.EnqDtlId,
		--			TARGET.CarFloorType = SOURCE.CarFloorType,
		--			TARGET.CarDoorType = SOURCE.CarDoorType,
		--			TARGET.CarDoorFinishType = SOURCE.CarDoorFinishType,
		--			TARGET.CarDoorAngle = SOURCE.CarDoorAngle,
		--			TARGET.CarDoorSide = SOURCE.CarDoorSide,
		--			TARGET.CarDoorHeight = SOURCE.CarDoorHeight,
		--			TARGET.CarDoorWidth = SOURCE.CarDoorWidth,
		--			TARGET.CarDoorDepth = SOURCE.CarDoorDepth,
		--			TARGET.CarDoorDescription = SOURCE.CarDoorDescription,
		--			TARGET.CarDoorAmount = SOURCE.CarDoorAmount

		--	-- ✅ INSERT if not exists
		--	WHEN NOT MATCHED BY TARGET THEN
		--		INSERT (
		--			--EnqCarDoorId,
		--			EnqDtlId,
		--			CarFloorType,
		--			CarDoorType,
		--			CarDoorFinishType,
		--			CarDoorAngle,
		--			CarDoorSide,
		--			CarDoorHeight,
		--			CarDoorWidth,
		--			CarDoorDepth,
		--			CarDoorDescription,
		--			CarDoorAmount
		--		)
		--		VALUES (
		--			--SOURCE.EnqCarDoorId,
		--			SOURCE.EnqDtlId,
		--			SOURCE.CarFloorType,
		--			SOURCE.CarDoorType,
		--			SOURCE.CarDoorFinishType,
		--			SOURCE.CarDoorAngle,
		--			SOURCE.CarDoorSide,
		--			SOURCE.CarDoorHeight,
		--			SOURCE.CarDoorWidth,
		--			SOURCE.CarDoorDepth,
		--			SOURCE.CarDoorDescription,
		--			SOURCE.CarDoorAmount
		--		);


		--UPDATE ELD
		--SET 
			
		--	--ELD.EnqDtlId = J.EnqDtlId,
		--	ELD.CarFloorType = J.CarFloorType,
		--	ELD.CarDoorType = J.CarDoorType,
		--	ELD.CarDoorFinishType = J.CarDoorFinishType,
		--	ELD.CarDoorAngle = J.CarDoorAngle,
		--	ELD.CarDoorSide = J.CarDoorSide,

		--	ELD.CarDoorHeight = J.CarDoorHeight,
		--	ELD.CarDoorWidth = J.CarDoorWidth,
		--	ELD.CarDoorDepth = J.CarDoorDepth,
		--	ELD.CarDoorDescription = J.CarDoorDescription,
		--	ELD.CarDoorAmount = J.CarDoorAmount

		--FROM dbo.EnqCarDoor ELD
		--INNER JOIN OPENJSON(@EnqDtl, '$.EnqCarDoor')
		--WITH (
		--		EnqCarDoorId INT,
		--		EnqDtlId INT,

		--		CarFloorType NVARCHAR(100),
		--		CarDoorType NVARCHAR(100),
		--		CarDoorFinishType NVARCHAR(100),
		--		CarDoorAngle INT,
		--		CarDoorSide NVARCHAR(50),

		--		CarDoorHeight INT,
		--		CarDoorWidth INT,
		--		CarDoorDepth INT,
		--		CarDoorDescription NVARCHAR(500),
		--		CarDoorAmount NUMERIC(18,2)
		--) J
		--ON ELD.EnqCarDoorId = J.EnqCarDoorId and ELD.EnqDtlId = J.EnqDtlId;