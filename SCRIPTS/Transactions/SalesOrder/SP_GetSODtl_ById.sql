USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSODtl_ById]    Script Date: 11/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetSODtl_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetSODtl_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSODtl_ById]    Script Date: 11/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetSODtl_ById]
(
	@SODtlId int
    --@SODtlId int

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
        

        Declare @SOstr nvarchar(max)
        --Declare @SODtlId int

        --set @SODtlId = (Select SODtlId from SODtl where EnqHdrId = @SODtlId)

        set @SOstr = (SELECT
        (
         -----========== SODtl
        SELECT [SODtlId]
              ,[EnqHdrId]
              --,[SODtlId]
              ,[QuoteHdrId]
            ,[SOHdrId]

              ,[TaxId]
              ,[ShaftType]
              ,[ShaftWidth]
              ,[ShaftDepth]
              ,[OverheadHeight]
      
              ,[ElevatorPit]
              ,[ElevatorSpeed]
              ,[SOProduct]
              ,[NoOfPassengers]
              ,[SOProductType]
      
              ,[Capacity]
              ,[TotalFloors]
              ,[FloorDetails]
              ,[NoStop]
              ,[NoStopDetails]
      
              ,[TotalStops]
              ,[NoOfOpenings]
              ,[PriceLess]
              ,[ApproxFloorHeight]
              ,[DoorOpening]
      
              ,[DoorFinish]
              ,[DoorWidth]
              ,[DoorHeight]
              ,[DoubleEntrance]
              ,[DoubleEntranceType]
      
              ,[DoubleEntranceTypeDetails]
              ,[NoOfDoorOpenings]
              ,[EnqCabinType]
              ,[CabinWidth]
              ,[CabinDepth]
      
              ,[CabinHeight]
              ,[FlooringType]
              ,[Handrail]
              ,[CarDoorOpening]
      
              ,[CarDoorFinish]
              ,[CarDoorWidth]
              ,[CarDoorHeight]
              ,[ProductAmount]
              ,[FloorNameAmount]
      
              ,[DoorTypeAmount]
              ,[CarDoorTypeAmount]
              ,[DoorFinishAmount]
              ,[CabinTypeAmount]
              ,[FlooringTypeAmount]
      
              ,[AddnlFeatureAmount]
              ,[PowerSupply]
              ,[Machine]
              ,[Drive]
              ,[Controller]
      
              ,[Operation]
              ,[GuideRails]
              ,[Rope]
              --,[SOQty]
              --,[SOProductAmount]
      
              --,[SOTaxAmount]
              --,[SOTotalAmount]
              ,[SOProdSplFeature]
              ,[SOFalseCeilingType]

              ,[SOQty]
              ,[SORate]
              ,[SOProductAmount]
              ,[IncreasePercentage]
              ,[IncreaseAmount]
              
              ,[DiscountPercentage]
              ,[DiscountAmount]
              ,[TaxableValue]
              ,[TaxableCashAmount]
              ,[TaxableChequeAmount]
              
              ,[GST]
              ,[AMCPercentage]
              ,[AMCAmount]
              ,[SOSubTotal]
              ,[SOTaxAmount]
              
              ,[SOTotalAmount]
              ,[SOGrandTotal]
              ,[CustomerStatus]
              ,[OrderStatus]
              ,[ApprovalStatus1]
              ,[ApprovalStatus2]

              --,[CreatedUserId]
              --,[CreatedDate]

          FROM [dbo].[SoDtl]
          WHERE SODtlId = @SODtlId   --and SODtl.Deleted = 0
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS SODtl,

        (
         SELECT 
               [SOLandDoorId]
              ,[SODtlId]
              ,[SOLandFloorType]
              ,[SOLandDoorType]
              ,[SOLandDoorFinishType]

              ,[SOLandDoorAngle]
              ,[SOLandDoorSide]
              ,[SOLandDoorHeight]
              ,[SOLandDoorWidth]
              ,[SOLandDoorDescription]

              ,[SOLandDoorAmount]

          FROM [dbo].[SOLandDoor]


          WHERE [SOLandDoor].SODtlId = @SODtlId 
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS SOLandDoor,

        (
         SELECT 
               [SOCarDoorId]
              ,[SODtlId]
              ,[SOCarFloorType]
              ,[SOCarDoorType]
              ,[SOCarDoorFinishType]

              ,[SOCarDoorAngle]
              ,[SOCarDoorSide]
              ,[SOCarDoorHeight]
              ,[SOCarDoorWidth]
              ,[SOCarDoorDescription]

              ,[SOCarDoorAmount]

          FROM [dbo].[SOCarDoor]
          WHERE [SOCarDoor].SODtlId = @SODtlId 
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS SOCarDoor

        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

        ---- Return value json string  with hdr, dtl, doors
        select @SOstr

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





-- Declare @SOstr nvarchar(max)

--set @SOstr = (SELECT
--(
--    -- =========== EnqHdr
--	SELECT 
--       [SOHdrId]
--      ,[CompanyId]
--      ,[BranchId]
--      ,[EnqHdrId]
--      ,[QuoteHdrId]

--      ,[OrdClientHdrId]
--      ,[SOHNo]
--      ,[SOHDate]
--      ,[OrdInstAddress]
--      ,[LeadName]
      
--      ,[OrdCompGST]
--      ,[OrdCompEmailId]
--      ,[OrdClientAadhar]
--      ,[OrdClientPAN]
--      ,[OrdAmount]

--      ,[OrdSubTotal]
--      ,[OrdTax]
--      ,[OrdTotalAmount]
--      ,[OrdAdvance]
--      ,[OrdPayments]

--      ,[OrdStatus]
--      ,[CreatedBy]
--      ,[CreatedAt]

--    FROM [dbo].[SOHdr]
--    WHERE SOHdrId = @SOHdrId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS SOHdr,

--(
--	-- =========== EnqClient
--   SELECT 
--       [OrdClientHdrId]
--      ,[OrdConsultant]
--      ,[OrdClientName]
--      ,[OrdClientTitle]
--      ,[OrdGstTradeName]

--      ,[OrdGstNo]
--      ,[OrdClientStatus]
--      ,[CreatedBy]
--      ,[CreatedAt]

--    FROM [dbo].[OrdClientHdr]
--    WHERE OrdClientHdrId = @SOHdrId
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqClient,

--(
--    -----========== SODtl
--SELECT [SODtlId]
--      ,[EnqHdrId]
--      ,[EnqDtlId]
--      ,[QuoteHdrId]
--      ,[SOHdrId]

--      ,[TaxId]
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
--      ,[ProductAmount]
--      ,[FloorNameAmount]
      
--      ,[DoorTypeAmount]
--      ,[CarDoorTypeAmount]
--      ,[DoorFinishAmount]
--      ,[CabinTypeAmount]
--      ,[FlooringTypeAmount]
      
--      ,[AddnlFeatureAmount]
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
--      ,[CreatedBy]
--      ,[CreatedAt]

--  FROM [dbo].[SoDtl]
--  WHERE SOHdrId = @SOHdrId   --and SODtl.Deleted = 0
--    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS EnqDtl,

--(
-- SELECT 
--       [SOLandDoorId]
--      ,[SODtlId]
--      ,[SOLandFloorType]
--      ,[SOLandDoorType]
--      ,[SOLandDoorFinishType]

--      ,[SOLandDoorAngle]
--      ,[SOLandDoorSide]
--      ,[SOLandDoorHeight]
--      ,[SOLandDoorWidth]
--      ,[SOLandDoorDescription]

--      ,[SOLandDoorAmount]

--  FROM [dbo].[SOLandDoor]


--  WHERE [SOLandDoor].SODtlId = @SODtlId 
--  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS SOLandDoor,

--(
-- SELECT 
--       [SOCarDoorId]
--      ,[EnqDtlId]
--      ,[SOCarFloorType]
--      ,[SOCarDoorType]
--      ,[SOCarDoorFinishType]

--      ,[SOCarDoorAngle]
--      ,[SOCarDoorSide]
--      ,[SOCarDoorHeight]
--      ,[SOCarDoorWidth]
--      ,[SOCarDoorDescription]

--      ,[SOCarDoorAmount]

--  FROM [dbo].[SOCarDoor]
--  WHERE [SOCarDoor].SODtlId = @SODtlId 
--  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
--) AS SOCarDoor

--FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

--select @SOstr




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
