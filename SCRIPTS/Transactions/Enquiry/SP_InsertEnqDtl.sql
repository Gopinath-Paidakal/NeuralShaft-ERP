USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertEnqDtl]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertEnqDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertEnqDtl]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertEnqDtl]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertEnqDtl]
(
	@EnqHdrId int,
	@EnqDtl nvarchar(Max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	
BEGIN TRANSACTION

	Declare @ProductAmount numeric(18,2) = 0
	Declare @FloorNameAmount	numeric(18,2) = 0
	Declare @DoorTypeAmount	numeric(18,2) = 0
	Declare @CarDoorTypeAmount	numeric(18,2) = 0
	Declare @DoorFinishAmount	numeric(18,2) = 0
	
	Declare @CabinTypeAmount numeric(18,2) = 0
    Declare @FlooringTypeAmount numeric(18,2) = 0
    Declare @AddnlFeatureAmount numeric(18,2) = 0

	Declare @EnqProductAmount numeric(18,2) = 0
	Declare @TaxableValue numeric(18,2) = 100.00
	Declare @TaxableAmount numeric(18,2) = 0
	Declare @TaxAmount  numeric(18,2) = 0
	Declare @TotalAmount numeric(18,2) = 0

	Declare @EnqDtlId int = 0

	Declare @GetEnqDtl nvarchar(max) = ''

	Declare @NoOfPassengers int = 0
	Declare @PassengerAmount numeric(18,2) = 0
	
	--=================EnqDtl
	Declare @ShaftType nvarchar(100)
	Declare @ShaftWidth smallint
	Declare @ShaftDepth smallint
	Declare @EnqProduct nvarchar(100)

	------------------------------------------------
	----- getting the values from json string
	----- declare a variable nvarchar(max) assign 
	----- then the values get stored in the variables
	------------------------------------------------
	set @GetEnqDtl = @EnqDtl

	----------------------------------------
	----  setting the values into variables
	--------------------------------------
	SELECT 
		@ShaftType = ShaftType,
		@ShaftWidth = ShaftWidth,
		@ShaftDepth = ShaftDepth,
		@EnqProduct = EnqProduct
	FROM OPENJSON(@EnqDtl, '$.EnqDtl')
	WITH (
		ShaftType NVARCHAR(50) '$.ShaftType',
		ShaftWidth INT          '$.ShaftWidth',
		ShaftDepth INT          '$.ShaftDepth',
		EnqProduct NVARCHAR(50) '$.EnqProduct'
	);

	--set @NoOfPassengers = JSON_VALUE(@EnqDtl, '$.EnqDtl.NoOfPassengers')

	--set @PassengerAmount = (Select PassengerAmount from Passenger where NoOfPassengers = @NoOfPassengers)


	--select @ShaftType,@ShaftWidth, @ShaftDepth, @EnqProduct
	
	--if (len(@ShaftType is not null and @ShaftWidth is not null and @ShaftDepth is not null and @EnqProduct is not null)
	if (len(@ShaftType) > 0 and @ShaftWidth > 0 and @ShaftDepth > 0  and len(@EnqProduct) > 0)
	BEGIN
			--Select 'Inserting EnqDtl'

			INSERT INTO EnqDtl(
			EnqHdrId,
	
			DDProductId, ShaftType, ShaftWidth, ShaftDepth, OverheadHeight, ElevatorPit,
			ElevatorSpeed, EnqProduct, NoOfPassengers, EnqProductType, Capacity,
			TotalFloors,

			FloorDetails, NoStop, NoStopDetails, TotalStops,
			NoOfOpenings, PriceLess, ApproxFloorHeight,
	
			DoorOpening, DoorFinish, DoorWidth, DoorHeight,
			DoubleEntrance, DoubleEntranceType, DoubleEntranceTypeDetails, NoOfDoorOpenings,
	
			EnqCabinType, CabinWidth, CabinDepth, CabinHeight,
			FlooringType, Handrail,

			CarDoorOpening, CarDoorFinish, CarDoorWidth, CarDoorHeight,

			ProductAmount, FloorNameAmount, DoorTypeAmount, CarDoorTypeAmount, DoorFinishAmount,
			CabinTypeAmount, FlooringTypeAmount, AddnlFeatureAmount,

			PowerSupply, Machine, Drive, Controller, Operation, GuideRails, Rope,

			EnqProdSplFeature, EnqFalseCeilingType, GST, HSNCode, TaxableValue, PassengerAmount

			)
			SELECT 
				@EnqHdrId,
	
				DDProductId, ShaftType, ShaftWidth, ShaftDepth, OverheadHeight, ElevatorPit,
				ElevatorSpeed, EnqProduct, NoOfPassengers, EnqProductType, Capacity,
				TotalFloors,
	
				FloorDetails, NoStop, NoStopDetails, TotalStops,
				NoOfOpenings, PriceLess, ApproxFloorHeight,
	
				DoorOpening, DoorFinish, DoorWidth, DoorHeight,
				DoubleEntrance, DoubleEntranceType, DoubleEntranceTypeDetails, NoOfDoorOpenings,
	
				EnqCabinType, CabinWidth, CabinDepth, CabinHeight,
				FlooringType, Handrail,

				CarDoorOpening, CarDoorFinish, CarDoorWidth, CarDoorHeight,
		
				ProductAmount, FloorNameAmount, DoorTypeAmount, CarDoorTypeAmount, DoorFinishAmount,
				CabinTypeAmount, FlooringTypeAmount, AddnlFeatureAmount,

				PowerSupply, Machine, Drive, Controller, Operation, GuideRails, Rope,

				EnqProdSplFeature, EnqFalseCeilingType,GST, HSNCode, @TaxableValue, @PassengerAmount


			FROM OPENJSON(@EnqDtl, '$.EnqDtl')
			WITH (

				DDProductId INT,
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

				EnqProdSplFeature NVARCHAR(500),
				EnqFalseCeilingType NVARCHAR(100),
				GST Numeric(6,2),
				HSNCode NVARCHAR(50)
				
			)	

			SET @EnqDtlId = SCOPE_IDENTITY()	

			set @ProductAmount = (Select ProductAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @FloorNameAmount = (Select FloorNameAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @DoorTypeAmount = (Select DoorTypeAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @CarDoorTypeAmount = (Select CarDoorTypeAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @DoorFinishAmount = (Select DoorFinishAmount from EnqDtl where EnqDtlId = @EnqDtlId)

			set @CabinTypeAmount = (Select CabinTypeAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @FlooringTypeAmount = (Select FlooringTypeAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @AddnlFeatureAmount = (Select AddnlFeatureAmount from EnqDtl where EnqDtlId = @EnqDtlId)
			set @NoOfPassengers = (Select NoOfPassengers from EnqDtl where EnqDtlId = @EnqDtlId)

			set @PassengerAmount = (Select PassengerAmount from Passenger where NoOfPassengers = @NoOfPassengers)
	
			set @EnqProductAmount = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
								 + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount + @PassengerAmount)

			set @TaxableAmount = (@EnqProductAmount * @TaxableValue/100)
			set @TaxAmount = (@TaxableAmount * 18.00/100)

			set @TotalAmount = @EnqProductAmount + @TaxAmount

			update EnqDtl set EnqRate = @EnqProductAmount, EnqProductAmount = @EnqProductAmount, EnqSubTotal = @EnqProductAmount, 
												 EnqTaxAmount = @TaxAmount, EnqTotalAmount = @TotalAmount, EnqGrandTotal = @TotalAmount,
												 PassengerAmount = @PassengerAmount
				   where EnqDtl.EnqDtlId = @EnqDtlId

			-------------------------------------------
			---  Updating QuoteHdrId in EnqDtl 
			-------------------------------------------
			Declare @QuoteHdrId int
	
			set @QuoteHdrId = (Select QuoteHdrId from QuoteHdr where EnqHdrId = @EnqHdrId)

			Update EnqDtl set QuoteHdrId = @QuoteHdrId where EnqHdrId = @EnqHdrId
	
			----================================================
			---- Inserting into EnqLandDoor
			------------------------------------------------------
			INSERT INTO [dbo].[EnqLandDoor]
					(--EnqHdrId
					EnqDtlId
					
					,LandFloorType
					,LandDoorType
					,LandDoorFinishType
					,LandDoorAngle
					,LandDoorSide

					,LandDoorHeight
					,LandDoorWidth
					,LandDoorDescription
					,LandDoorAmount
					,CrudType)

				Select	 
					 @EnqDtlId

				 	,LandFloorType
					,LandDoorType
					,LandDoorFinishType
					,LandDoorAngle
					,LandDoorSide

					,LandDoorHeight
					,LandDoorWidth
					,LandDoorDescription
					,LandDoorAmount,

					CrudType
			             
			FROM OPENJSON(@EnqDtl, '$.EnqLandDoor')
			WITH
			(
				LandFloorType  nvarchar(100),
				LandDoorType nvarchar(100),
				LandDoorFinishType  nvarchar(100),
				LandDoorAngle nvarchar(100),
				LandDoorSide nvarchar(100),

				LandDoorHeight nvarchar(100),
				LandDoorWidth nvarchar(100),				
				LandDoorDescription  nvarchar(500),
				LandDoorAmount numeric(18,2),

				CrudType nvarchar(20)
			)

			-----================================================
			---- Inserting into EnqLandDoor
			------------------------------------------------------
			INSERT INTO [dbo].[EnqCarDoor]
					(--EnqHdrId
					EnqDtlId
					
					,CarFloorType
					,CarDoorType
					,CarDoorFinishType
					,CarDoorAngle
					,CarDoorSide

					,CarDoorHeight
					,CarDoorWidth
					,CarDoorDescription
					,CarDoorAmount,
					CrudType)

				Select	
					 @EnqDtlId
				 	,CarFloorType
					,CarDoorType
					,CarDoorFinishType
					,CarDoorAngle
					,CarDoorSide

					,CarDoorHeight
					,CarDoorWidth
					,CarDoorDescription
					,CarDoorAmount
					,CrudType
			             
			FROM OPENJSON(@EnqDtl, '$.EnqCarDoor')
			WITH
			(
				CarFloorType  nvarchar(100),
				CarDoorType nvarchar(100),
				CarDoorFinishType  nvarchar(100),
				CarDoorAngle nvarchar(100),
				CarDoorSide nvarchar(100),

				CarDoorHeight nvarchar(100),
				CarDoorWidth nvarchar(100),
				CarDoorDescription  nvarchar(500),
				CarDoorAmount numeric(18,2),

				CrudType nvarchar(20)
			)

			--select @EnqHdrId

			----------------------------------------------
			--- Addint Product Count
			------------------------------------------------
		    -- Updating the product count in EnqHdr
			Update Enqhdr  set ProductCount = (select count(*) from Enqdtl where EnqHdrId = @EnqHdrId)

			-- Updating the product count in Quotehdr
			Update QuoteHdr set ProductCount = (select count(*) from Enqdtl where EnqHdrId = @EnqHdrId)



			select @EnqHdrId

			

	END

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


--------------------------------------------------
			-----  Insert into QuoteDtl
			--------------------------------------------------
			--INSERT INTO [dbo].[QuoteDtl]
   --        (
			--    [EnqHdrId]
			--   ,[EnqDtlId]
			--   ,[EnqProduct]
			--   --,[HSNCode]
			--   ,[CarDoorFinish]
			--   ,[CarDoorWidth]
			--   ,[CarDoorHeight]

			--   ,[NoOfPassengers]
			--   --,[AMCValue]
			--   ,[QuoteQty]
			--   ,[QuoteRate]
			--   ,[QuoteTax]
			--   ,[QuoteTotalAmount]

			--   --,[NegotiableAmount]
			--   --,[GrandTotalAmount]
			--   )

		 --  select 
			--	  @EnqHdrId,
			--	  @EnqDtlId,
			--      [EnqProduct], 
			--	  [CarDoorFinish], 
			--	  [CarDoorWidth], 
			--	  [CarDoorHeight], 

			--	  [NoOfPassengers],
			--	  --0,
			--	  1,
			--	  [EnqProductAmount],
			--	  [EnqTaxAmount],
			--	  [EnqTotalAmount]

		 --  from enqdtl
		 --  where enqdtl.EnqDtlId = @EnqDtlId

--Select * from EnqDtl where EnqHdrId = @EnqHdrId  and EnqDtl.Deleted = 0


--COMMIT TRANSACTION



	--============================================
	--================= Door Details
	--INSERT INTO [dbo].[EnqDoor]
 --          (EnquiryId
	--	   ,DoorOpening
	--	   ,DoorFinish
 --          ,DoorWidth
	--	   ,DoorHeight

 --          ,DoubleEntrance
	--	   ,DoubleEntranceType
	--	   ,DoubleEntranceTypeDetails
	--	   ,NoOfDoorOpenings
 --         )
 --    Select	    	   
	--       @EnquiryId,
 --          DoorOpening, 
	--	   DoorFinish, 
 --          DoorWidth, 
	--	   DoorHeight,

 --          DoubleEntrance, 
	--	   DoubleEntranceType,
	--	   DoubleEntranceTypeDetails,
	--	   NoOfDoorOpenings
          
	--FROM OPENJSON(@Enquiry, '$.EnqDoor')
 --   WITH
 --   (
 --      DoorOpening nvarchar(100),
 --      DoorWidth nvarchar(100),
	--   DoorHeight nvarchar(100),
 --      DoorFinish nvarchar(100),
 --      DoubleEntrance nvarchar(100),
 --      DoubleEntranceType nvarchar(100),
	--   DoubleEntranceTypeDetails nvarchar(max),
	--   NoOfDoorOpenings smallint
 --   )
	
	--============================================
	--================= Floor Details
	--INSERT INTO [dbo].[EnqFloor]
 --          (EnquiryId

	--	   ,FloorDetails
 --          ,NoStop
 --          ,NoStopDetails
 --          ,TotalStops
	--	   ,NoOfOpenings
		   
	--	   ,PriceLess
		   
	--	   ,ApproxFloorHeight)
		   
 --    Select
	--	   @EnquiryId,
           
	--	   FloorDetails, 
 --          NoStop, 
 --          NoStopDetails, 
 --          TotalStops,
	--	   NoOfOpenings,
	--	   PriceLess,
		   
	--	   ApproxFloorHeight
		
         
	--FROM OPENJSON(@Enquiry, '$.EnqFloor')
 --   WITH
 --   (
 --     FloorDetails nvarchar(max),
 --     NoStop nvarchar(100),
 --     NoStopDetails nvarchar(100),
 --     TotalStops nvarchar(100),
	--  NoOfOpenings smallint,
	--  PriceLess numeric(18,2),
	--  ApproxFloorHeight smallint
	
      
 --   )

	--============================================
	------------ Cabin Type
	--INSERT INTO [dbo].[EnqCabinType]
 --          (EnquiryId
		  
	--	   ,EnqCabinType
 --          ,CabinWidth
 --          ,CabinDepth
 --          ,CabinHeight

 --          ,FlooringType
 --          ,Handrail)
		   
 --    Select
	--	    @EnquiryId

	--	   ,EnqCabinType
 --          ,CabinWidth
 --          ,CabinDepth
 --          ,CabinHeight

 --          ,FlooringType
 --          ,Handrail
           
	--FROM OPENJSON(@Enquiry, '$.EnqCabinType')
 --   WITH
 --   (
	--	EnqCabinType nvarchar(100),
 --       CabinWidth nvarchar(50),
 --       CabinDepth nvarchar(50),
 --       CabinHeight nvarchar(50),
 --       FlooringType nvarchar(50),

 --       Handrail nvarchar(50)
 --   )
	--============================================
	--=========== Additional Feature
	--INSERT INTO [dbo].[EnqAdditionalFeature]
 --          ([EnquiryId]

 --          ,[AdditionalFeatureName])
           
 --    Select
	--		@EnquiryId,

 --           AdditionalFeatureName
          

	--FROM OPENJSON(@Enquiry, '$.EnqAdditionalFeature')
 --   WITH
 --   (
 --          EnquiryId int,

 --          AdditionalFeatureName nvarchar(500)
          
	--)













--	INSERT INTO [dbo].[Enquiry]
--(
--    CompanyId,
--    BranchId,
--    EnqClientId,
--    EnqShaftDetailsId,
--    EnqDoorTypeId,

--    EnqFloorDetailsId,
--    EnqProductTypeId,
--    EnqCabinTypeId,
--    EnqNo,
--    EnqSlno,

--    EnqDate,
--    EnqRefDetails,
--    EnqRemarks,
--    EnqStatus,
--    Latitude,
    
--	Longitude,
--    CreatedBy,
--    CreatedDate
--)
--SELECT
--     1,
--     1,
--     @EnqClientId,
--     @EnqShaftDetailsId,
--     @EnqDoorTypeId,

--     @EnqFloorDetailsId,
--     @EnqProductTypeId,
--     @EnqCabinTypeId,
--     1,
--     1,

--     GETDATE(),                -- better than hardcoded date
--     EnqRefDetails,
--     EnqRemarks,
--     EnqStatus,
--     Latitude,

--     Longitude,
--     'Admin',
--     GETDATE()
--FROM OPENJSON(@Enquiry, '$.Enquiry')
--WITH
--(
--    EnqRefDetails NVARCHAR(100), 
--    EnqRemarks    NVARCHAR(500),
--    EnqStatus     NVARCHAR(5),   
--    Latitude      NVARCHAR(50),  
--    Longitude     NVARCHAR(50)  
--);

--INSERT INTO [dbo].[EnqClientDetails]
 --          ([EnqClientGUID]
 --          ,[EnqClientCategory]
 --          ,[EnqClientName]
 --          ,[EnqClientMobileNo]
 --          ,[EnqClientEmailId]

 --          ,[EnqClientAddress1]
 --          --,[EnqClientAddress2]
 --          ,[EnqLeadSource]
 --          ,[EnqRefDetails]
 --          ,[EnqRemarks]
           
	--	   ,[CreatedBy]
 --          ,[CreatedDate])
 --   Values
 --          (NEWID()
 --          ,@EnqClientCategory
 --          ,@EnqClientName
 --          ,@EnqClientMobileNo
 --          ,@EnqClientEmailId
 --          ,@EnqClientAddress1

 --          --,@EnqClientAddress2
 --          ,@EnqLeadSource
 --          ,@EnqRefDetails
 --          ,@EnqRemarks
 --          ,@CreatedBy
 --          ,getdate())
	--@EnqClientDetails nvarchar(Max),
 --   @EnqShaftDetails nvarchar(Max),
	--@EnqFloorDetails nvarchar(Max),
	--@EnqDoorDetails nvarchar(Max),

	--@EnqCabinType nvarchar(Max),
	--@EnqPanelType nvarchar(Max),
	--@EnqProductType nvarchar(Max)	


	--INSERT INTO [dbo].[Enquiry]
 --          ([CompanyId]
 --          ,[BranchId]
 --          ,[EnqClientId]
 --          ,[EnqShaftDetailsId]
	--	   ,[EnqDoorTypeId]
           
	--	   ,[EnqFloorDetailsId]
	--	   ,[EnqProductTypeId]
 --          ,[EnqCabinTypeId]
 --          ,[EnqNo]
 --          ,[EnqSlno]

 --          ,[EnqDate]
	--	   --,[EnqRefDetails]
 --          --,[EnqRemarks]
 --          ,[EnqStatus]
 --          ,[Lattitude]
           
	--	   ,[Longitude]
 --          ,[CreatedBy]
 --          ,[CreatedDate])
 --    Select
 --           1
 --          ,1
 --          ,@EnqClientId
 --          ,@EnqShaftDetailsId
	--	   ,@EnqDoorTypeId

	--	   ,@EnqFloorDetailsId
 --          ,@EnqProductTypeId
 --          ,@EnqCabinTypeId
 --          ,1
 --          ,1

 --          ,'2026-03-10'         
 --          ,CreatedBy
	--	   ,Getdate()
	--FROM OPENJSON(@Enquiry, '$.Enquiry')
 --   WITH
 --   (
	--	  EnqRefDetails nvarchar(100),
 --         EnqRemarks nvarchar(500),
 --         EnqStatus nvarchar(5),
 --         Lattitude nvarchar(50),
 --         Longitude nvarchar(50)


 --	INSERT INTO [dbo].[EnqClientDetails]
--(
--    EnqClientGUID,
--    EnqConsultant,
--    EnqClientName,
--    EnqClientMobileNo,
--    EnqClientEmailId,
--    EnqClientAddress,
--    EnqClientCategory,
--    EnqLeadSource,
--    EnqSourceBy,
--    CreatedBy
--)

--SELECT
--    NEWID(),
--    EnqConsultant,
--    EnqClientName,
--    EnqClientMobileNo,
--    EnqClientEmailId,
--    EnqClientAddress,
--    EnqClientCategory,
--    EnqLeadSource,
--    EnqSourceBy,
--    CreatedBy

--FROM OPENJSON(@Enquiry, '$.EnqClientDetails')
--WITH
--(
--    EnqConsultant      NVARCHAR(100) '$.EnqConsultant',
--    EnqClientName      NVARCHAR(100) '$.EnqClientName',
--    EnqClientMobileNo  NVARCHAR(100) '$.EnqClientMobileNo',
--    EnqClientEmailId   NVARCHAR(100) '$.EnqClientEmailId',
--    EnqClientAddress   NVARCHAR(100) '$.EnqClientAddress',
--    EnqClientCategory  NVARCHAR(100) '$.EnqClientCategory',
--    EnqLeadSource      NVARCHAR(100) '$.EnqLeadSource',
--    EnqSourceBy        NVARCHAR(100) '$.EnqSourceBy',
--    CreatedBy          NVARCHAR(20)  '$.CreatedBy'
--)


---=============Product Type
	--INSERT INTO [dbo].[EnqProductType]
 --          (EnquiryId
 --          ,ProductType
 --          ,ProductVariant
 --          ,NoOfPassengers
 --          ,TotalLandings
 --          ,CreatedBy
 --          ,CreatedDate)
 --    Select
 --          EnquiryId, 
 --          ProductType, 
 --          ProductVariant, 
 --          NoOfPassengers, 
 --          TotalLandings, 
 --          CreatedBy,
	--	   Getdate()
	--FROM OPENJSON(@Enquiry, '$.EnqProductType')
 --   WITH
 --   (
	--	  EnquiryId int,
 --         ProductType nvarchar(100),
 --         ProductVariant nvarchar(100),
 --         NoOfPassengers nvarchar(100),
 --         TotalLandings nvarchar(100),
 --         CreatedBy nvarchar(20)
 --   )
	--SET @EnqProductTypeId  = IDENT_CURRENT('EnqProductType')
	----=============================================

	--select 
	--	JSON_VALUE(@Enquiry, '$.Enquiry.EnqNo') AS EnqNo,
	--	--JSON_VALUE(@Enquiry, '$.Enquiry.Date') AS EnqDate,
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqConsultant') AS Consultant,
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientName') AS ClientName,	
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientMobileNo') AS MobileNo
	--FOR JSON PATH, ROOT('Enquiry')

	
	--INSERT INTO EnqDtl(
	--    EnquiryId,

	--	ShaftType, 
	--	ShaftWidth, 
	--	ShaftDepth,
	--	OverheadHeight,
	--	ElevatorPit,

	--	ElevatorSpeed,
	--	EnqProduct,
	--	NoOfPassengers,
	--	EnqProductType,
	--	Capacity,

	--	TotalFloors,    -- 12

	--	--================ Floor Details
	--	FloorDetails,
	--	NoStop,
 --       NoStopDetails,
 --       TotalStops,
 --       NoOfOpenings,
 --       PriceLess,
 --       ApproxFloorHeight,   --- 27

	--	--========  Door Details
	--	 DoorOpening,
	--	 DoorFinish,
 --        DoorWidth,
	--	 DoorHeight,

 --        DoubleEntrance,
	--	 DoubleEntranceType,
	--	 DoubleEntranceTypeDetails,
	--	 NoOfDoorOpenings,    --- 20	

	--	 ---================= Cabin details
	--	  EnqCabinType,
 --         CabinWidth,
 --         CabinDepth,
 --         CabinHeight,

 --         FlooringType,
 --         Handrail,    -- 33

	--	 ---- Additional Features
	--	 AdditionalFeatureName   ---- 34

	--	)

 --   SELECT 

	--    @EnquiryId,	
	--	------======= Shaft
	--	ShaftType, 
	--	ShaftWidth, 
	--	ShaftDepth,
	--	OverheadHeight,
	--	ElevatorPit,

	--	ElevatorSpeed,
	--	EnqProduct,
	--	NoOfPassengers,
	--	EnqProductType,
	--	Capacity,

	--	TotalFloors,   -- 12

	--	--============= Floor
	--	 FloorDetails, 
 --        NoStop, 
 --        NoStopDetails, 
 --        TotalStops,

	--	 NoOfOpenings,
	--	 PriceLess,
		   
	--	 ApproxFloorHeight   -- 27

	--	--===== Door
	--	 DoorOpening, 
	--	 DoorFinish, 
 --        DoorWidth, 
	--	 DoorHeight,

 --        DoubleEntrance, 
	--	 DoubleEntranceType,
	--	 DoubleEntranceTypeDetails,
	--	 NoOfDoorOpenings,    -- 20
		 
	--	 --========== Cabin
	--	 EnqCabinType,
 --        CabinWidth,
 --        CabinDepth,
 --        CabinHeight,

 --        FlooringType,
 --        Handrail,      -- 33 

	--	 --- ======= Additional Features
 --        AdditionalFeatureName  - 34

		
 --   FROM OPENJSON(@Enquiry, '$.Enquiry')
 --   WITH
 --   (
	--	----  Shaft
 --       ShaftType NVARCHAR(100),
 --       ShaftWidth NVARCHAR(100),
 --       ShaftDepth NVARCHAR(100),
 --       OverheadHeight NVARCHAR(100),
	--	ElevatorPit NVARCHAR(100),
	
	--	ElevatorSpeed numeric(8,2),
	--	EnqProduct NVARCHAR(100),
	--	NoOfPassengers smallint,
	--	EnqProductType NVARCHAR(100),
	--	Capacity  smallint,
	--	TotalFloors smallint,

	--	--=======Floor
	--	FloorDetails nvarchar(max),
	--	NoStop nvarchar(100),
 --       NoStopDetails nvarchar(100),
 --       TotalStops nvarchar(100),
	--    NoOfOpenings smallint,
	--    PriceLess numeric(18,2),
	--    ApproxFloorHeight smallint,

	--	--==== Door
	--	DoorOpening nvarchar(100),
 --       DoorWidth nvarchar(100),
	--    DoorHeight nvarchar(100),
 --       DoorFinish nvarchar(100),
 --       DoubleEntrance nvarchar(100),
 --       DoubleEntranceType nvarchar(100),
	--    DoubleEntranceTypeDetails nvarchar(max),
	--    NoOfDoorOpenings smallint,
		
	--	--=== Cabin
	--	EnqCabinType nvarchar(100),
 --       CabinWidth nvarchar(50),
 --       CabinDepth nvarchar(50),
 --       CabinHeight nvarchar(50),
 --       FlooringType nvarchar(50),
 --       Handrail nvarchar(50),

	--	--=== Addtional Features
	--	AdditionalFeatureName nvarchar(500)
		
 --   )



 --SELECT 
 --   @ShaftType    = ShaftType,
 --   @ShaftWidth   = ShaftWidth,
 --   @ShaftDepth   = ShaftDepth,
 --   @EnqProduct = EnqProduct
	--	FROM OPENJSON(@EnqHdr)
	--WITH (
	--	ShaftType NVARCHAR(50),
	--	ShaftWidth Int,
	--	ShaftDepth Int,
	--	EnqProduct NVARCHAR(100)
	--);

	--IF (COALESCE(@ShaftType, @ShaftWidth, @ShaftDepth, @EnqProduct) IS NOT NULL)


	--	SELECT 
--    @ShaftType  = ShaftType,
--    @ShaftWidth = ShaftWidth,
--    @ShaftDepth = ShaftDepth,
--    @EnqProduct = EnqProduct
--FROM OPENJSON(@EnqHdr)
--WITH (
--    ShaftType NVARCHAR(100),
--    ShaftWidth INT,
--    ShaftDepth INT,
--    EnqProduct NVARCHAR(100)
--);

    --SET @ShaftType = TRY_CAST(JSON_VALUE(@EnqHdr, '$.EnqDtl.ShaftType') AS NVARCHAR(50));

	--set @ShaftType    = JSON_VALUE(@EnqHdr, '$.EnqDtl.ShaftType') 
	--set @ShaftWidth   = JSON_VALUE(@EnqHdr, '$.EnqDtl.ShaftWidth') 
	--set @ShaftDepth   = JSON_VALUE(@EnqHdr, '$.EnqDtl.ShaftDepth') 
	--set @EnqProduct	  = JSON_VALUE(@EnqHdr, '$.EnqDtl.EnqProduct') 

	--SET @ShaftType = ISNULL(JSON_VALUE(@EnqHdr, '$.EnqDtl.ShaftType'), 'Unknown');

--	SELECT
--    ISNULL(JSON_VALUE(e.value, '$.EnqDtl.ShaftType'), 'Unknown') AS ShaftType,
--    TRY_CAST(JSON_VALUE(e.value, '$.EnqDtl.ShaftWidth') AS INT)      AS ShaftWidth,
--	TRY_CAST(JSON_VALUE(e.value, '$.EnqDtl.ShaftDepth') AS INT)      AS ShaftDepth,
--    ISNULL(JSON_VALUE(e.value, '$.EnqDtl.EnqProduct'), 'NotSpecified') AS EnqProduct
--FROM OPENJSON(@EnqHdr) e;