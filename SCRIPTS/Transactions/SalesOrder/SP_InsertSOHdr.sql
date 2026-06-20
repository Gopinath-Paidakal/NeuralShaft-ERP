USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertSOHdr]    Script Date: 02/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertSOHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertSOHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertSOHdr]    Script Date: 02/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertSOHdr]
(
	----@QuoteHdrId int,
	--@EnqDtlId int,
	--@UserId int
	----@SalesOrder nvarchar(max)
	----@OrdApproveId int
	@SOHdr NVARCHAR(200)


)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	Declare @CompanyId int
	Declare @BranchId int
	Declare @SOHNo int
	Declare @SOHSlNo nvarchar(50)

	Declare @EnqHdrId int
	Declare @EnqDtlId int
	Declare @EnqClientId int
	Declare @QuoteHdrId int
	
	Declare @OrdClientHdrId int
	Declare @OrdClientAddrId int

	Declare @SOHdrId int
	Declare @SODtlId int

	Declare @UserId int
	Declare @CreatedDate date

	Declare @Prefix nvarchar(50)
	
	BEGIN TRANSACTION
		set @CompanyId = (Select CompanyId from Company)
		set @BranchId = (Select BranchId from Branch where CompanyId = @CompanyId)

			
		SET @EnqDtlId = JSON_VALUE(@SOHdr, '$.SOHdr.EnqDtlId');
		SET @UserId = JSON_VALUE(@SOHdr, '$.SOHdr.UserId');
		SET @CreatedDate = JSON_VALUE(@SOHdr, '$.SOHdr.CreatedDate');

		set @Prefix = (select DefaultDataName from DefaultData where FormType = 'Sales Order' and DefaultDataType = 'Prefix')

		select @SOHNo = max(SOHNo) from [SOHdr] where CompanyId = @CompanyId  and  BranchId = @BranchId
		if @SOHNo = 0 or @SOHNo is NULL
			set @SOHNo = 1
		else
			set @SOHNo =@SOHNo + 1

		--set @SOSlNo = 'SO'+ '/'
  --              + CONVERT(nvarchar(20), @SOHNo) + '/'
  --              + CONVERT(nvarchar(8), GETDATE(), 105)

		set @SOHSlNo = @Prefix + RIGHT('0000' + CAST(@SOHNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

					

	--set @EnqHdrId = (Select EnqHdrId from EnqDtl where QuoteHdrId = @QuoteHdrId)
	--set @OrdClientHdrId = (Select OrdClientHdrId  from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @QuoteHdrId = (Select QuoteHdrId  from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @EnqDtlId = (Select EnqDtlId from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @EnqHdrId = (Select EnqHdrId from OrdApprove where OrdApproveId = @OrdApproveId)

	set @EnqHdrId = (Select EnqHdrId from enqdtl where Enqdtlid = @enqdtlid)
	set @OrdClientHdrId = (Select OrdClientHdrId  from enqdtl where Enqdtlid = @enqdtlid)
	set @QuoteHdrId = (Select QuoteHdrId  from enqdtl where Enqdtlid = @enqdtlid)

	--set @EnqDtlId = (Select EnqDtlId from from enqdtl where Enqdtlid = @enqdtlid)
	

	
	------- To be checked
	--set @OrdClientAddrId = (Select OrdClientAddrId  from OrdApprove where OrdApproveId = @OrdApproveId)

	--- ============= Sales Order Header

	INSERT INTO [dbo].[SOHdr]
           ([CompanyId]
           ,[BranchId]
           ,[EnqHdrId]
           ,[QuoteHdrId]
           ,[OrdClientHdrId]
		   --,[OrdClientAddrId]

           ,[SOHNo]
		   ,[SOHSlNo]
           ,[SOHDate]
		   ,[SOConsultant]
		   ,[SOCustComp]
           ,[SOBillingAddr]
          
		  ,[SOContPerson]
          ,[SOMobileNo]
          ,[ProjectName]
          ,[ExpectedClosingDate]
		  ,[SOEmailId]
          ,[DeliveryBy]

          ,[QuoteValidity]
          ,[ComplementaryAMC]
          ,[GSTExempted]
		  ,[SOPaymentTerms]
          ,[OrdAmount]
		  
		  ,[OrdSubTotal]
          ,[OrdTax]
          ,[OrdTotalAmount]
          ,[OrdAdvance]
          ,[OrdPayments]

          ,[OrdStatus]

          ,[CreatedUserId]
          ,[CreatedDate])
	Values
		(@CompanyId
		,@BranchId
		,@EnqHdrId
		,@QuoteHdrId
		,@OrdClientHdrId
		--,@OrdClientAddrId

		,@SOHNo
		,@SOHSlNo

		,@CreatedDate   ------getdate()   --,(Select CreatedDate from OrdApprove where OrdApproveId = @OrdApproveId)

		---- Setting the values from QuoteHdr
	    ,(Select QuoteConsultant  from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuoteCustComp  from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuoteBillingAddr  from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuoteContPerson  from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuoteMobileNo  from QuoteHdr where QuoteHdrId = @QuoteHdrId)

		,(Select ProjectName from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select ExpectedClosingDate from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuoteEmailId  from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select DeliveryBy from QuoteHdr where QuoteHdrId = @QuoteHdrId)

		,(Select QuoteValidity from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select ComplementaryAMC from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select GSTExempted from QuoteHdr where QuoteHdrId = @QuoteHdrId)
		,(Select QuotePaymentTerms from QuoteHdr where QuoteHdrId = @QuoteHdrId)

		,0  --[OrdAmount]

		,0  --[OrdSubTotal]
		,0  --[OrdTax]
		,0  --[OrdTotalAmount]
		,0  --[OrdAdvance]
		,0  -- [OrdPayments]

		,0  --[OrdStatus]
		 
		,@UserId   --  (Select CreatedUserId from OrdApprove where OrdApproveId = @OrdApproveId)          ---- 1
		,@CreatedDate)     ----getdate())   --(Select CreatedDate from OrdApprove where OrdApproveId = @OrdApproveId))
	
	
	SET @SOHdrId = SCOPE_IDENTITY()	 
	--================= =================
		
	----------------------------
	-- Update EnqHdr 
	-------------------------------
	Update EnqDtl set SODtlId = @SODtlId where EnqHdrId = @EnqHdrId
	Update EnqDtl set SOGen = 1 where QuoteHdrId = @QuoteHdrId and EnqHdrId= @EnqHdrId and EnqDtlId = @EnqDtlId
	-------------------------------

	------------------------------------------
	-- Copy SODtl from EnqDtl and Update SOHdrId in EnqDtl
	----------------------------------------------
	INSERT INTO [dbo].[SoDtl]
           (
			 [EnqHdrId]			
			,[EnqDtlId]
			,[QuoteHdrId]
			,[SOHdrId]
			,[TaxId]
           
			,[ShaftType]
			,[ShaftWidth]
			,[ShaftDepth]
			,[OverheadHeight]
			,[ElevatorPit]          --10

			,[ElevatorSpeed]
			,[SOProduct]
			,[NoOfPassengers]
			,[SOProductType]
			,[Capacity]

			,[TotalFloors]
			,[FloorDetails]
			,[NoStop]
			,[NoStopDetails]
			,[TotalStops]        --20

			,[NoOfOpenings]
			,[PriceLess]
			,[ApproxFloorHeight]
			,[DoorOpening]
			,[DoorFinish]

			,[DoorWidth]
			,[DoorHeight]
			,[DoubleEntrance]
			,[DoubleEntranceType]
			,[DoubleEntranceTypeDetails]   --30

			,[NoOfDoorOpenings]
			,[EnqCabinType]
			,[CabinWidth]
			,[CabinDepth]
			,[CabinHeight]

			,[FlooringType]
			,[Handrail]
			--,[AdditionalFeatureName]
			,[CarDoorOpening]
			,[CarDoorFinish]
			,[CarDoorWidth]           -- 40

			,[CarDoorHeight]
			,[ProductAmount]
			,[FloorNameAmount]
			,[DoorTypeAmount]
			,[CarDoorTypeAmount]

			,[DoorFinishAmount]
			,[CabinTypeAmount]
			,[FlooringTypeAmount]
			,[AddnlFeatureAmount]
			,[PowerSupply]            --50

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
			,[GST]
			,[HSNCode]
			
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

			,[PassengerAmount]

			)           --60
		   
	SELECT 
			 [EnqHdrId]			
		 	,[EnqDtlId]
			  
			,[QuoteHdrId]
			,[SODtlId]
			,[TaxId]

			,[ShaftType]
			,[ShaftWidth]
			,[ShaftDepth]
			,[OverheadHeight]
			,[ElevatorPit]       --10

			,[ElevatorSpeed]
			,[EnqProduct]
			,[NoOfPassengers]
			,[EnqProductType]
			,[Capacity]

			,[TotalFloors]
			,[FloorDetails]
			,[NoStop]
			,[NoStopDetails]
			,[TotalStops]      --20

			,[NoOfOpenings]
			,[PriceLess]
			,[ApproxFloorHeight]
			,[DoorOpening]
			,[DoorFinish]

			,[DoorWidth]
			,[DoorHeight]
			,[DoubleEntrance]
			,[DoubleEntranceType]
			,[DoubleEntranceTypeDetails]  --30

			,[NoOfDoorOpenings]
			,[EnqCabinType]
			,[CabinWidth]
			,[CabinDepth]
			,[CabinHeight]

			,[FlooringType]
			,[Handrail]			
			,[CarDoorOpening]
			,[CarDoorFinish]      --40

			,[CarDoorWidth]
			,[CarDoorHeight]
			,[ProductAmount]
			,[FloorNameAmount]
			,[DoorTypeAmount]

			,[CarDoorTypeAmount]
			,[DoorFinishAmount]
			,[CabinTypeAmount]
			,[FlooringTypeAmount]
			,[AddnlFeatureAmount]    --50
      
			,[PowerSupply]
			,[Machine]
			,[Drive]
			,[Controller]
			,[Operation]
      
			,[GuideRails]
			,[Rope]
			--,[EnqQty]
			--,[EnqProductAmount]
			--,[EnqTaxAmount]           --60

			--,[EnqTotalAmount]
			,[EnqProdSplFeature]     
			,[EnqFalseCeilingType]
			,[GST]
			,[HSNCode]

			  ,[EnqQty]
			  ,[EnqRate]
			  ,[EnqProductAmount]
			  ,[IncreasePercentage]
			  ,[IncreaseAmount]

			  ,[DiscountPercentage]
			  ,[DiscountAmount]
			  ,[TaxableValue]
			  ,[TaxableCashAmount]
			  ,[TaxableChequeAmount]

			
			  ,[AMCPercentage]
			  ,[AMCAmount]
			  ,[EnqSubTotal]
			  ,[EnqTaxAmount]
      
			  ,[EnqTotalAmount]
			  ,[EnqGrandTotal]
			  ,[CustomerStatus]
			  ,[OrderStatus]
			  ,[ApprovalStatus1]
			  ,[ApprovalStatus2]

			  ,[PassengerAmount]

      
		  FROM [dbo].[EnqDtl]

		  where EnqDtl.EnqDtlId = @EnqDtlId

		  set @SODtlId = SCOPE_IDENTITY()

		  --==========================================
		  -- Inserting SOLandDoor
		  --==========================================
		  INSERT INTO [dbo].[SOLandDoor]
           (--[SODtlId]
			[SODtlId]
           ,[SOLandFloorType]
           ,[SOLandDoorType]
           ,[SOLandDoorFinishType]
           ,[SOLandDoorAngle]

           ,[SOLandDoorSide]
           ,[SOLandDoorHeight]
           ,[SOLandDoorWidth]
           ,[SOLandDoorDescription]
		   ,[SOLandDoorAmount]
		   ,[SOCrudType])

		SELECT 
			--[EnqLandDoorId]
			 [EnqDtlId]
			,[LandFloorType]
			,[LandDoorType]
			,[LandDoorFinishType]
			,[LandDoorAngle]

			,[LandDoorSide]
			,[LandDoorHeight]
			,[LandDoorWidth]
			,[LandDoorDescription]
			,[LandDoorAmount]
			,[CrudType]

		FROM [dbo].[EnqLandDoor]
		where EnqLandDoor.EnqDtlId = @EnqDtlId


		--==========================================
		-- Inserting SOCarDoor
		--==========================================
		INSERT INTO [dbo].[SOCarDoor]
           ([SODtlId]
           ,[SOCarFloorType]
           ,[SOCarDoorType]
           ,[SOCarDoorFinishType]
           ,[SOCarDoorAngle]

           ,[SOCarDoorSide]
           ,[SOCarDoorHeight]
           ,[SOCarDoorWidth]
           ,[SOCarDoorDescription]
           ,[SOCarDoorAmount]
		   ,[SOCrudType])

		Select 
			   --[EnqCarDoorId]
			   [EnqDtlId]
			  ,[CarFloorType]
			  ,[CarDoorType]
			  ,[CarDoorFinishType]
			  ,[CarDoorAngle]

			  ,[CarDoorSide]
			  ,[CarDoorHeight]
			  ,[CarDoorWidth]
			  ,[CarDoorDescription]
			  ,[CarDoorAmount]

			  ,[CrudType]


			FROM [dbo].[EnqCarDoor]
			where EnqCarDoor.EnqDtlId = @EnqDtlId


	---- ========================================
	--- Update SODtl with SOHdrId
	----- ======================================
	update SoDtl set SOHdrId = @SOHdrId where SODtlId = @SODtlId

	---- ========================================
	--- Update Ordapprove SO gen 1
	----- ======================================
	Update EnqDtl set SoGen = 1, ApprovalStatus2 = 'Approved-2' where EnqDtlId = @EnqDtlId

	------==============================================
	------- Inserting into Job Order
	----------------------------------------------------

	INSERT INTO [dbo].[JobOrder]
           (

		   [SOHdrId]
		   ,[SODtlId]
		   ,[SONo]
           ,[JobOrderNo]
		   ,[JobOrderDate]
           ,[ProjectName]
		   ,[SOConsultant]

           ,[JobOrderCustComp]
           ,[JobOrderContPerson]
           ,[JobOrderMobileNo]
           ,[CreatedUserId]
           ,[CreatedDate])

      SELECT
			 [SOHdr].[SOHdrId]
			,(Select SODtlId from SoDtl where SoHdrId = @SOHdrId)
            ,[SOHdr].[SOHNo]
			,Convert(nvarchar(100), 'JO' + RIGHT('0000' + Convert(nvarchar(20),[SOHdr].[SOHNo]),5) + 'BE') as 'Job Ord No'
			,[SOHdr].[SOHdate]
            ,[SOHdr].[ProjectName]    
			,[SOHdr].[SOConsultant]    
            ,[SOHdr].[SOCustComp]

            ,[SOHdr].[SOContPerson]
            ,[SOHdr].[SOMobileNo]
			,[SoHdr].[CreatedUserId]
			,GETDATE()
           
		  FROM SoHdr   

		  WHERE SoHdrId = @SOHdrId

	--- ==========================================	
	--- Return SOHdrId
	--- ==========================================
	Select @SOHdrId
	
	---- ================================================
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



---=== QuoteHdr
	--Declare @QuoteConsultant nvarchar(100)
 --   Declare @QuoteClientName nvarchar(100)
 --   Declare @QuoteClientAddress nvarchar(100)
 --   Declare @QuoteContactPerson nvarchar(100)
 --   Declare @QuoteClientMobileNo nvarchar(100)
 --   Declare @EnqClientEmailId nvarchar(100)
 --   Declare @EnqGSTExempted bit


--,(select OrdClientAddr1 + OrdClientAddr2 from OrdClientAddr where OrdClientAddrId = @OrdClientAddrId)    --[OrdInstAddress]
--		,(Select EnqLeadSource from EnqClient where EnqClientId = @EnqClientId)  --[LeadName]
--		,(select OrdClientGstNo from OrdClientAddr where OrdClientAddrId = @OrdClientAddrId)   --[OrdCompGST]

--		,(select OrdClientPriMailId from OrdClientAddr where OrdClientAddrId = @OrdClientAddrId)  --[OrdCompEmailId]
--		,(select OrdClientAdhaarNo from OrdClientAddr where OrdClientAddrId = @OrdClientAddrId)  ---[OrdClientAadhar]
--		,(select OrdClientPan from OrdClientAddr where OrdClientAddrId = @OrdClientAddrId)  ---[OrdClientPAN]

--select * from OrdApprove
	--set @EnqHdrId = (Select EnqHdrId from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @EnqDtlId = (Select EnqDtlId from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @EnqClientId = (Select EnqClientId from EnqClient where EnqHdrId = @EnqHdrId)
	--set @QuoteHdrId = (Select QuoteHdrId from OrdApprove where OrdApproveId = @OrdApproveId)
	--set @OrdClientAddrId = (Select OrdClientAddrId from OrdClientAddr where OrdClientHdrId = @OrdClientHdrId)

		







































--INSERT INTO [dbo].[SOHdr]
--           ([CompanyId]
--           ,[BranchId]
--           ,[EnqHdrId]
--           ,[QuoteHdrId]
--           ,[OrdClientHdrId]

--           ,[SOHNo]
--           ,[OrdDate]
--           ,[OrdInstAddress]
--           ,[LeadName]
--           ,[OrdCompGST]

--           ,[OrdCompEmailId]
--           ,[OrdClientAadhar]
--           ,[OrdClientPAN]
--           ,[OrdAmount]
--           ,[OrdSubTotal]
           
--           ,[OrdTax]
--           ,[OrdTotalAmount]
--           ,[OrdAdvance]
--           ,[OrdPayments]
--           ,[OrdStatus]

--           ,[CreatedBy]
--           ,[CreatedAt])
--	SELECT
--		 @CompId
--		,@BranchId
--		,@EnqHdrId
--		,@QuoteHdrId
--		,@OrdClientHdrId

--		,@SOHNo
--		,GETDATE()
--		,[OrdInstAddress]
--		,[LeadName]
--		,[OrdCompGST]

--		,[OrdCompEmailId]
--		,[OrdClientAadhar]
--		,[OrdClientPAN]
--		,[OrdAmount]
--		,[OrdSubTotal]
           
--		,[OrdTax]
--		,[OrdTotalAmount]
--		,[OrdAdvance]
--		,[OrdPayments]
--		,[OrdStatus]
		 
--		,'Admin',
--		 GETDATE()
	
--	FROM OPENJSON(@SalesOrder,  '$.SalesOrder')
--	WITH
--	(
--		   OrdInstAddress nvarchar(100),
--           LeadName nvarchar(100),
--           OrdCompGST nvarchar(100),

--           OrdCompEmailId nvarchar(100),
--           OrdClientAadhar nvarchar(100),
--           OrdClientPAN nvarchar(100),
--           OrdAmount numeric(18,2),
--           OrdSubTotal numeric(18,2),
           
--		   OrdTax numeric(18,2),
--           OrdTotalAmount numeric(18,2),
--           OrdAdvance numeric(18,2),
--           OrdPayments numeric(18,2),
--           OrdStatus nvarchar(5)

--	)




	-----------------------------
	-- Update EnqHdr with Client Id
	-------------------------------
	--Update EnqHdr set EnqClientId = @EnqClientId where EnqHdrId = @EnqHdrId
	-------------------------------

	------------------------------
	--  Inserting Enquiry Detail 
	------------------------------
	--EXEC [dbo].[SP_InsertEnqDtl] @EnqHdrId = @EnqHdrId, @EnqDtl = @EnqHdr

	------------------------------
	--  Inserting Enquiry FollowUp 
	------------------------------
	--INSERT INTO [dbo].[EnqFollowUp]
 --          (
	--	    [EnqHdrId]
	--	   ,[EnqClientId]
 --          --,[EnqNo]

 --          --,[EnqFollowUpDate]
 --          --,[EnqStatus]
		   
 --          ,[CreatedBy]
	--	   ,[CreatedAt])

	--	SELECT
	--		 @EnqHdrId,
	--		 @EnqClientId,
	--		 --@EnqNo,

	--		 --GETDATE() + 5,
	--		 --EnqStatus,
			 
	--		 'Admin',
	--		 GETDATE()

	--FROM OPENJSON(@EnqHdr, '$.EnqHdr')
	--WITH
	--(
	--	EnqStatus NVARCHAR(5)
           
	--)





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


 --======================================
	--- Insert OrdClientHdr data from SO form
	---========================================

	--INSERT INTO [dbo].[OrdClientHdr]
 --          ([OrdPrimContPerson]
 --          ,[OrdPrimContMobileNo]
 --          ,[OrdSecContPerson]
 --          ,[OrdSecContMobileNo])

	--SELECT
	--		[OrdPrimContPerson]
 --          ,[OrdPrimContMobileNo]
 --          ,[OrdSecContPerson]
 --          ,[OrdSecContMobileNo]

	--FROM OPENJSON(@SalesOrder,  '$.@SalesOrder')
	--WITH
	--(
	--	   OrdPrimContPerson nvarchar(100),
 --          OrdPrimContMobileNo nvarchar(100),
 --          OrdSecContPerson nvarchar(100),
 --          OrdSecContMobileNo nvarchar(100)
	--)
