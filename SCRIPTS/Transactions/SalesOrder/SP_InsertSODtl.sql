USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertSODtl]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertSODtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertSODtl]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertSODtl]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertSODtl]
(
	@SOHdrId int,
	@SODtl nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	Declare @ProductAmount numeric(18,2) 
	Declare @FloorNameAmount	numeric(18,2)
	Declare @DoorTypeAmount	numeric(18,2)
	Declare @CarDoorTypeAmount	numeric(18,2)
	Declare @DoorFinishAmount	numeric(18,2)
	
	Declare @CabinTypeAmount numeric(18,2)
    Declare @FlooringTypeAmount numeric(18,2)
    Declare @AddnlFeatureAmount numeric(18,2)

	Declare @TaxableValue numeric(18,2) = 100.00
    Declare @PassengerAmount numeric(18,2)

	Declare @SOProductAmount numeric(18,2)
	Declare @TaxAmount  numeric(18,2)
	Declare @TotalAmount numeric(18,2)

	Declare @NoOfPassengers int = 0

	Declare @SODtlId int

	Declare @GetSODtl nvarchar(max)
	
	--=================SODtl
	Declare @ShaftType nvarchar(100)
	Declare @ShaftWidth smallint
	Declare @ShaftDepth smallint
	Declare @SOProduct nvarchar(100)


	------------------------------------------------
	----- getting the values from json string
	----- declare a variable nvarchar(max) assign 
	----- then the values get stored in the variables
	------------------------------------------------
	set @GetSODtl = @SODtl

	-----------------------------------------------------
	----  setting the values into variables validation
	------------------------------------------------------
	SELECT 
		@ShaftType = ShaftType,
		@ShaftWidth = ShaftWidth,
		@ShaftDepth = ShaftDepth,
		@SOProduct = SOProduct
	FROM OPENJSON(@SODtl, '$.SODtl')
	WITH (
		ShaftType NVARCHAR(50) '$.ShaftType',
		ShaftWidth INT          '$.ShaftWidth',
		ShaftDepth INT          '$.ShaftDepth',
		SOProduct NVARCHAR(50) '$.SOProduct'
	);

	--select @ShaftType,@ShaftWidth, @ShaftDepth, @SOProduct
	
	--if (len(@ShaftType is not null and @ShaftWidth is not null and @ShaftDepth is not null and @SOProduct is not null)
	if (len(@ShaftType) > 0 and @ShaftWidth > 0 and @ShaftDepth > 0  and len(@SOProduct) > 0)
	BEGIN
			--Select 'Inserting SODtl'

			INSERT INTO SODtl(
			SOHdrId,
	
			ShaftType, ShaftWidth, ShaftDepth, OverheadHeight, ElevatorPit,
			ElevatorSpeed, SOProduct, NoOfPassengers, SOProductType, Capacity,
			TotalFloors,

			FloorDetails, NoStop, NoStopDetails, TotalStops,
			NoOfOpenings, PriceLess, ApproxFloorHeight,
	
			DoorOpening, DoorFinish, DoorWidth, DoorHeight,
			DoubleEntrance, DoubleEntranceType, DoubleEntranceTypeDetails, NoOfDoorOpenings,
	
			CabinWidth, CabinDepth, CabinHeight,
			FlooringType, Handrail,

			CarDoorOpening, CarDoorFinish, CarDoorWidth, CarDoorHeight,

			ProductAmount, FloorNameAmount, DoorTypeAmount, CarDoorTypeAmount, DoorFinishAmount,
			CabinTypeAmount, FlooringTypeAmount, AddnlFeatureAmount,

			PowerSupply, Machine, Drive, Controller, Operation, GuideRails, Rope,

			SOProdSplFeature, SOFalseCeilingType, GST, HSNCode

			)
			SELECT 
				@SOHdrId,
	
				ShaftType, ShaftWidth, ShaftDepth, OverheadHeight, ElevatorPit,
				ElevatorSpeed, SOProduct, NoOfPassengers, SOProductType, Capacity,
				TotalFloors,
	
				FloorDetails, NoStop, NoStopDetails, TotalStops,
				NoOfOpenings, PriceLess, ApproxFloorHeight,
	
				DoorOpening, DoorFinish, DoorWidth, DoorHeight,
				DoubleEntrance, DoubleEntranceType, DoubleEntranceTypeDetails, NoOfDoorOpenings,
	
				CabinWidth, CabinDepth, CabinHeight,
				FlooringType, Handrail,

				CarDoorOpening, CarDoorFinish, CarDoorWidth, CarDoorHeight,
		
				ProductAmount, FloorNameAmount, DoorTypeAmount, CarDoorTypeAmount, DoorFinishAmount,
				CabinTypeAmount, FlooringTypeAmount, AddnlFeatureAmount,

				PowerSupply, Machine, Drive, Controller, Operation, GuideRails, Rope,

				SOProdSplFeature, SOFalseCeilingType, GST, HSNCode


			FROM OPENJSON(@SODtl, '$.SODtl')
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

				SOCabinType NVARCHAR(100),
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

				PowerSupply NVARCHAR(100),
				Machine NVARCHAR(100),
				Drive NVARCHAR(100),
				Controller NVARCHAR(100),
				Operation NVARCHAR(100),
				GuideRails NVARCHAR(100),
				Rope NVARCHAR(100),

				SOProdSplFeature NVARCHAR(500),
				SOFalseCeilingType NVARCHAR(100),
				GST Numeric(6,2),
				HSNCode NVARCHAR(50)

			)	

			SET @SODtlId = SCOPE_IDENTITY()	


			set @ProductAmount = (Select ProductAmount from SODtl where SODtlId = @SODtlId)
			set @FloorNameAmount = (Select FloorNameAmount from SODtl where SODtlId = @SODtlId)
			set @DoorTypeAmount = (Select DoorTypeAmount from SODtl where SODtlId = @SODtlId)
			set @CarDoorTypeAmount = (Select CarDoorTypeAmount from SODtl where SODtlId = @SODtlId)
			set @DoorFinishAmount = (Select DoorFinishAmount from SODtl where SODtlId = @SODtlId)

			set @CabinTypeAmount = (Select CabinTypeAmount from SODtl where SODtlId = @SODtlId)
			set @FlooringTypeAmount = (Select FlooringTypeAmount from SODtl where SODtlId = @SODtlId)
			set @AddnlFeatureAmount = (Select AddnlFeatureAmount from SODtl where SODtlId = @SODtlId)

			set @TaxableValue = (Select TaxableValue from SODtl where SODtlId = @SODtlId)
			set @PassengerAmount = (Select PassengerAmount from Passenger where NoOfPassengers = @NoOfPassengers)
	
			set @SOProductAmount = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
								 + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

			--set @TaxAmount = (@SOProductAmount * 18.00/100)
			set @TaxAmount = (@SOProductAmount * @TaxableValue/100)

			set @TotalAmount = @SOProductAmount + @TaxAmount

			update SODtl set SORate = @SOProductAmount, SOProductAmount = @SOProductAmount, SOSubTotal = @SOProductAmount, 
												 SOTaxAmount = @TaxAmount, SOTotalAmount = @TotalAmount, SOGrandTotal = @TotalAmount,
												 PassengerAmount = @PassengerAmount
				   where SODtl.SODtlId = @SODtlId

			
			-------------------------------------------
			---  Updating QuoteHdrId in SODtl 
			-------------------------------------------
			--Declare @QuoteHdrId int
	
			--set @QuoteHdrId = (Select QuoteHdrId from QuoteHdr where SOHdrId = @SOHdrId)

			--Update SODtl set QuoteHdrId = @QuoteHdrId where SOHdrId = @SOHdrId
	
			----------------------------------------------
			--- Sending the data from SODtl
			------------------------------------------------
			--Select * from SODtl where SOHdrId = @SOHdrId  and SODtl.Deleted = 0


			-----================================================
			---- Inserting into SOLandDoor
			------------------------------------------------------
			INSERT INTO [dbo].[SOLandDoor]
					(--SOHdrId
					SODtlId
					
					,SOLandFloorType
					,SOLandDoorType
					,SOLandDoorFinishType
					,SOLandDoorAngle
					,SOLandDoorSide

					,SOLandDoorHeight
					,SOLandDoorWidth
					,SOLandDoorDescription
					,SOLandDoorAmount
					,SOCrudType)

				Select	 
					 @SODtlId

				 	,SOLandFloorType
					,SOLandDoorType
					,SOLandDoorFinishType
					,SOLandDoorAngle
					,SOLandDoorSide

					,SOLandDoorHeight
					,SOLandDoorWidth
					,SOLandDoorDescription
					,SOLandDoorAmount
					,SOCrudType
			             
			FROM OPENJSON(@SODtl, '$.SOLandDoor')
			WITH
			(
				SOLandFloorType  nvarchar(100),
				SOLandDoorType nvarchar(100),
				SOLandDoorFinishType  nvarchar(100),
				SOLandDoorAngle nvarchar(100),
				SOLandDoorSide nvarchar(100),

				SOLandDoorHeight nvarchar(100),
				SOLandDoorWidth nvarchar(100),				
				SOLandDoorDescription  nvarchar(500),
				SOLandDoorAmount numeric(18,2),
				SOCrudType nvarchar(20)
			)

			-----================================================
			---- Inserting into SOCarDoor
			------------------------------------------------------
			INSERT INTO [dbo].[SOCarDoor]
					(--SOHdrId
					SODtlId
					
					,SOCarFloorType
					,SOCarDoorType
					,SOCarDoorFinishType
					,SOCarDoorAngle
					,SOCarDoorSide

					,SOCarDoorHeight
					,SOCarDoorWidth
					,SOCarDoorDescription
					,SOCarDoorAmount
					,SOCrudType)

				Select	
					 @SODtlId
				 	,SOCarFloorType
					,SOCarDoorType
					,SOCarDoorFinishType
					,SOCarDoorAngle
					,SOCarDoorSide

					,SOCarDoorHeight
					,SOCarDoorWidth
					,SOCarDoorDescription
					,SOCarDoorAmount
					,SOCrudType
			             
			FROM OPENJSON(@SODtl, '$.SOCarDoor')
			WITH
			(
				SOCarFloorType  nvarchar(100),
				SOCarDoorType nvarchar(100),
				SOCarDoorFinishType  nvarchar(100),
				SOCarDoorAngle nvarchar(100),
				SOCarDoorSide nvarchar(100),

				SOCarDoorHeight nvarchar(100),
				SOCarDoorWidth nvarchar(100),
				SOCarDoorDescription  nvarchar(500),
				SOCarDoorAmount numeric(18,2),
				SOCrudType nvarchar(20)
			)
		END

		set @SODtlId = SCOPE_IDENTITY()


		Select @SODtlId

		
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