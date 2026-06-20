USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSODtl]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateSODtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateSODtl]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSODtl]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateSODtl]
(
	@SODtlId int,
	@SoDtl nvarchar(Max)

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
			E.SOProduct = J.SOProduct,
			E.NoOfPassengers = J.NoOfPassengers,
			E.SOProductType = J.SOProductType,
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
			E.SOProdSplFeature = J.SOProdSplFeature,
			E.SOFalseCeilingType = J.SOFalseCeilingType

			FROM SODtl E

			INNER JOIN OPENJSON(@SODtl, '$.SODtl')

			WITH (
				ShaftType NVARCHAR(100),
				ShaftWidth NVARCHAR(100),
				ShaftDepth NVARCHAR(100),
				OverheadHeight NVARCHAR(100),
				ElevatorPit NVARCHAR(100),

				ElevatorSpeed NUMERIC(8,2),
				SOProduct NVARCHAR(100),
				NoOfPassengers SMALLINT,
				SOProductType NVARCHAR(100),
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
				SOProdSplFeature NVARCHAR(500),
				SOFalseCeilingType NVARCHAR(100)

			) J

		ON E.SODtlId = @SODtlId;

		  ---------------------------------------------------
		   -- Modifying the prices in Sodtl
		   ---------------------------------------------------
		   	Declare @ProductAmount numeric(18,2) = 0
			Declare @FloorNameAmount	numeric(18,2) = 0
			Declare @DoorTypeAmount	numeric(18,2) = 0
			Declare @CarDoorTypeAmount	numeric(18,2) = 0
			Declare @DoorFinishAmount	numeric(18,2) = 0
	
			Declare @CabinTypeAmount numeric(18,2) = 0
			Declare @FlooringTypeAmount numeric(18,2) = 0
			Declare @AddnlFeatureAmount numeric(18,2) = 0

			Declare @SOProductAmount numeric(18,2) = 0
			Declare @TaxableValue  numeric(18,2) = 0
			Declare @TaxAmount  numeric(18,2) = 0
			Declare @TotalAmount numeric(18,2) = 0
			Declare @PassengerAmount numeric(18,2) = 0

			set @ProductAmount = (Select ProductAmount from SODtl where SODtlId = @SODtlId)
			set @FloorNameAmount = (Select FloorNameAmount from SODtl where SODtlId = @SODtlId)
			set @DoorTypeAmount = (Select DoorTypeAmount from SODtl where SODtlId = @SODtlId)
			set @CarDoorTypeAmount = (Select CarDoorTypeAmount from SODtl where SODtlId = @SODtlId)
			set @DoorFinishAmount = (Select DoorFinishAmount from SODtl where SODtlId = @SODtlId)

			set @CabinTypeAmount = (Select CabinTypeAmount from SODtl where SODtlId = @SODtlId)
			set @FlooringTypeAmount = (Select FlooringTypeAmount from SODtl where SODtlId = @SODtlId)
			set @AddnlFeatureAmount = (Select AddnlFeatureAmount from SODtl where SODtlId = @SODtlId)

			set @TaxableValue = (Select TaxableValue from SODtl where SODtlId = @SODtlId)
			set @PassengerAmount = (Select PassengerAmount from SODtl where SODtlId = @SODtlId)
	
			set @SOProductAmount = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
								 + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

			--set @TaxAmount = (@SOProductAmount * 18.00/100)
			set @TaxAmount = (@SOProductAmount * @TaxableValue/100)

			set @TotalAmount = @SOProductAmount + @TaxAmount

			update SODtl set SORate = @SOProductAmount, SOProductAmount = @SOProductAmount, SOSubTotal = @SOProductAmount, 
												 SOTaxAmount = @TaxAmount, SOTotalAmount = @TotalAmount, SOGrandTotal = @TotalAmount,
												 PassengerAmount = @PassengerAmount
				   where SODtl.SODtlId = @SODtlId

		 ---------------------------------------------------
        --  Extract SODtlId
        ---------------------------------------------------
		   SELECT @SODtlId = SODtlId
		   FROM OPENJSON(@SODtl)
		   WITH (SODtlId INT);

		   ---------------------------------------------------
		   -- LAND DOOR MERGE
		   ---------------------------------------------------
		   MERGE INTO SOLandDoor AS Target
		   USING (
			   SELECT *
			   FROM OPENJSON(@SODtl, '$.SOLandDoor')
			   WITH (
				   SOLandDoorId INT,
				   SODtlId int,

				   SOLandFloorType NVARCHAR(50),
				   SOLandDoorType NVARCHAR(50),
				   SOLandDoorFinishType NVARCHAR(50),
				   SOLandDoorAngle DECIMAL(10,2),
				   SOLandDoorSide NVARCHAR(50),

				   SOLandDoorHeight DECIMAL(10,2),
				   SOLandDoorWidth DECIMAL(10,2),
				   SOLandDoorDescription NVARCHAR(255),
				   SOLandDoorAmount DECIMAL(18,2),
				   SOCrudType NVARCHAR(20)
			   )
		   ) AS Source
		   ON Target.SOLandDoorId = Source.SOLandDoorId
		   --AND Source.SOLandDoorId IS NOT NULL
		   ----   Matched
		   WHEN MATCHED THEN
			   UPDATE SET
				   Target.SOLandFloorType       = Source.SOLandFloorType,
				   Target.SOLandDoorType        = Source.SOLandDoorType,
				   Target.SOLandDoorFinishType  = Source.SOLandDoorFinishType,
				   Target.SOLandDoorAngle       = Source.SOLandDoorAngle,
				   Target.SOLandDoorSide        = Source.SOLandDoorSide,

				   Target.SOLandDoorHeight      = Source.SOLandDoorHeight,
				   Target.SOLandDoorWidth       = Source.SOLandDoorWidth,
				   Target.SOLandDoorDescription = Source.SOLandDoorDescription,
				   Target.SOLandDoorAmount      = Source.SOLandDoorAmount,
				   Target.SOCrudType              = Source.SOCrudType
		   ----  Not Matched
		   WHEN NOT MATCHED BY TARGET THEN
			   INSERT
			   (
				   SODtlId,
				   SOLandFloorType,
				   SOLandDoorType,
				   SOLandDoorFinishType,
				   SOLandDoorAngle,
				   SOLandDoorSide,
				   SOLandDoorHeight,
				   SOLandDoorWidth,
				   SOLandDoorDescription,
				   SOLandDoorAmount,
				   SOCrudType
			   )
			   VALUES
			   (
				   Source.SODtlId,
				   Source.SOLandFloorType,
				   Source.SOLandDoorType,
				   Source.SOLandDoorFinishType,
				   Source.SOLandDoorAngle,
				   Source.SOLandDoorSide,
				   Source.SOLandDoorHeight,
				   Source.SOLandDoorWidth,
           
				   Source.SOLandDoorDescription,
				   Source.SOLandDoorAmount,
				   Source.SOCrudType
			   );

		   ---------------------------------------------------
		   -- SAFE DELETE LAND DOOR
		   ---------------------------------------------------
		   DELETE T
		   FROM SOLandDoor T
		   WHERE T.SODtlId = @SODtlId and T.SOCrudType = UPPER('Delete')
		   AND NOT EXISTS (
			   SELECT 1
			   FROM OPENJSON(@SODtl, '$.SOLandDoor')
			   WITH (SOLandDoorId INT)
			   WHERE SOLandDoorId = T.SOLandDoorId
			   AND SOLandDoorId IS NOT NULL
		   );

		   ---------------------------------------------------
		   -- CAR DOOR MERGE
		   ---------------------------------------------------
		   MERGE INTO SOCarDoor AS Target
		   USING (
			   SELECT *
			   FROM OPENJSON(@SODtl, '$.SOCarDoor')
			   WITH (
				   SOCarDoorId INT,
				   SODtlId int,
				   SOCarFloorType NVARCHAR(50),
				   SOCarDoorType NVARCHAR(50),
				   SOCarDoorFinishType NVARCHAR(50),
				   SOCarDoorAngle DECIMAL(10,2),
				   SOCarDoorSide NVARCHAR(50),
				   SOCarDoorHeight DECIMAL(10,2),
				   SOCarDoorWidth DECIMAL(10,2),
          
				   SOCarDoorDescription NVARCHAR(255),
				   SOCarDoorAmount DECIMAL(18,2),
				   SOCrudType NVARCHAR(20)
			   )
		   ) AS Source
		   ON Target.SOCarDoorId = Source.SOCarDoorId
		   --AND Source.SOCarDoorId IS NOT NULL

		   WHEN MATCHED THEN
			   UPDATE SET
				   Target.SOCarFloorType       = Source.SOCarFloorType,
				   Target.SOCarDoorType        = Source.SOCarDoorType,
				   Target.SOCarDoorFinishType  = Source.SOCarDoorFinishType,
				   Target.SOCarDoorAngle       = Source.SOCarDoorAngle,
				   Target.SOCarDoorSide        = Source.SOCarDoorSide,
				   Target.SOCarDoorHeight      = Source.SOCarDoorHeight,
				   Target.SOCarDoorWidth       = Source.SOCarDoorWidth,
				   Target.SOCarDoorDescription = Source.SOCarDoorDescription,
				   Target.SOCarDoorAmount      = Source.SOCarDoorAmount,
				   Target.SOCrudType            = Source.SOCrudType

		   WHEN NOT MATCHED BY TARGET THEN
			   INSERT
			   (
				   SODtlId,
				   SOCarFloorType,
				   SOCarDoorType,
				   SOCarDoorFinishType,
				   SOCarDoorAngle,
				   SOCarDoorSide,
				   SOCarDoorHeight,
				   SOCarDoorWidth,
          
				   SOCarDoorDescription,
				   SOCarDoorAmount,
				   SOCrudType
			   )
			   VALUES
			   (
				   Source.SODtlId,
				   Source.SOCarFloorType,
				   Source.SOCarDoorType,
				   Source.SOCarDoorFinishType,
				   Source.SOCarDoorAngle,
				   Source.SOCarDoorSide,
				   Source.SOCarDoorHeight,
				   Source.SOCarDoorWidth,
        
				   Source.SOCarDoorDescription,
				   Source.SOCarDoorAmount,
				   Source.SOCrudType
			   );

		   ---------------------------------------------------
		   -- SAFE DELETE SOCar DOOR
		   ---------------------------------------------------
		   DELETE T
		   FROM SOCarDoor T
		   WHERE T.SODtlId = @SODtlId and T.SOCrudType = UPPER('Delete')
		   AND NOT EXISTS (
			   SELECT 1
			   FROM OPENJSON(@SODtl, '$.SOCarDoor')
			   WITH (SOSOCarDoorId INT)
			   WHERE SOCarDoorId = T.SOCarDoorId
			   AND SOCarDoorId IS NOT NULL
		   ); 

		 

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