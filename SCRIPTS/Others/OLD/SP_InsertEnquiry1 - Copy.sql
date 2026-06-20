USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_InsertEnquiry]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertEnquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Sp_InsertEnquiry]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_InsertEnquiry]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_InsertEnquiry]
(
	@Enquiry nvarchar(Max)

)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	Declare @CompId int
	Declare @BranchId int
	Declare @EnqNo int
	Declare @EnqSlNo nvarchar(50)

	Declare @EnqClientId int
	Declare @EnqShaftDetailsId int
	Declare @EnqDoorTypeId int
	Declare @EnqFloorDetailsId int
	Declare @EnqProductTypeId int
	Declare @EnqCabinTypeId int

	Declare @EnquiryId int

	BEGIN TRANSACTION
    set @CompId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

	select @EnqNo = max(@EnqNo) from Enquiry where CompanyId = @CompId  and  BranchId = @BranchId
	if @EnqNo = 0 or @EnqNo is NULL
		set @EnqNo = 1
	else
		set @EnqNo =@EnqNo + 1

	set @EnqSlNo = 'Enq' + CONVERT(nvarchar(20), @EnqNo) + CONVERT(nvarchar(10), GETDATE(), 10)


	--- ============= Enquiry

	INSERT INTO [dbo].[Enquiry]
	(
		CompanyId,
		BranchId,
		EnqNo,
		EnqSlno,
		
		EnqDate,
		EnqRefDetails,
		EnqRemarks,
		EnqStatus,
		Latitude,

		Longitude,
		CreatedBy,
		CreatedDate
	)
	SELECT
		 @CompId,
		 @BranchId,
		 @EnqNo,
		 101,

		 GETDATE(),
		 EnqRefDetails,
		 
		 EnqRemarks,
		 
		 EnqStatus,
		 
		 Latitude,
		 
		 Longitude,
		 
		 'Admin',
		 GETDATE()

	FROM OPENJSON(@Enquiry, '$.Enquiry')
	WITH
	(
		EnqRefDetails NVARCHAR(100),
		EnqRemarks NVARCHAR(500),
		EnqStatus NVARCHAR(5),
		Latitude NVARCHAR(50),
		Longitude NVARCHAR(50)
	)

	--SET @EnquiryId = IDENT_CURRENT('Enquiry')
	SELECT SCOPE_IDENTITY() as 'EnqNo'  
	--================= =================

	--================= Client Details

	INSERT INTO [dbo].[EnqClient]
           (EnquiryId, 
		   EnqClientGUID, 
		   EnqConsultant,
		   EnqClientName,
		   EnqClientMobileNo,

		   EnqClientEmailId,
           EnqClientAddress,
		   EnqClientCategory,
		   EnqLeadSource,
		   EnqSourceBy)
          
     Select
			@EnquiryId,
			NEWID(),
		   EnqConsultant,
           EnqClientName, 
           EnqClientMobileNo, 

           EnqClientEmailId, 
           EnqClientAddress, 
		   EnqClientCategory,
           EnqLeadSource, 
		   EnqSourceBy         
      

    FROM OPENJSON(@Enquiry, '$.EnqClient')
    WITH
    (
		   EnqClientGUID nvarchar(100),
		   EnqConsultant nvarchar(100),
		   EnqClientName nvarchar(100), 
           EnqClientMobileNo nvarchar(100),
           EnqClientEmailId nvarchar(100),
           
		   EnqClientAddress nvarchar(100),
		   EnqClientCategory nvarchar(100),
		   EnqLeadSource nvarchar(100),
           EnqSourceBy nvarchar(100)
          
    )

	--=================Shaft Details
	INSERT INTO EnqShaft(
	    EnquiryId,

		ShaftType, 
		ShaftWidth, 
		ShaftDepth,
		OverheadHeight,
		ElevatorPit,

		ElevatorSpeed,
		EnqProduct,
		NoOfPassengers,
		EnqProductType,
		Capacity,

		TotalFloors)

    SELECT 

	    @EnquiryId,	

		ShaftType, 
		ShaftWidth, 
		ShaftDepth,
		OverheadHeight,
		ElevatorPit,

		ElevatorSpeed,
		EnqProduct,
		NoOfPassengers,
		EnqProductType,
		Capacity,

		TotalFloors
	
		
    FROM OPENJSON(@Enquiry, '$.EnqShaft')
    WITH
    (
        ShaftType NVARCHAR(100),
        ShaftWidth NVARCHAR(100),
        ShaftDepth NVARCHAR(100),
        OverheadHeight NVARCHAR(100),
		ElevatorPit NVARCHAR(100),

		ElevatorSpeed numeric(8,2),
		EnqProduct NVARCHAR(100),
		NoOfPassengers smallint,
		EnqProductType NVARCHAR(100),
		Capacity  smallint,

		TotalFloors smallint
		
    )
	--============================================
	--================= Door Details
	INSERT INTO [dbo].[EnqDoor]
           (EnquiryId
		   ,DoorOpening
		   ,DoorFinish
           ,DoorWidth
		   ,DoorHeight

           ,DoubleEntrance
		   ,DoubleEntranceType
		   ,DoubleEntranceTypeDetails
		   ,NoOfDoorOpenings
          )
     Select	    	   
	       @EnquiryId,
           DoorOpening, 
		   DoorFinish, 
           DoorWidth, 
		   DoorHeight,

           DoubleEntrance, 
		   DoubleEntranceType,
		   DoubleEntranceTypeDetails,
		   NoOfDoorOpenings
          
	FROM OPENJSON(@Enquiry, '$.EnqDoor')
    WITH
    (
       DoorOpening nvarchar(100),
       DoorWidth nvarchar(100),
	   DoorHeight nvarchar(100),
       DoorFinish nvarchar(100),
       DoubleEntrance nvarchar(100),
       DoubleEntranceType nvarchar(100),
	   DoubleEntranceTypeDetails nvarchar(max),
	   NoOfDoorOpenings smallint
    )
	
	--============================================
	--================= Floor Details
	INSERT INTO [dbo].[EnqFloor]
           (EnquiryId

		   ,FloorDetails
           ,NoStop
           ,NoStopDetails
           ,TotalStops
		   ,NoOfOpenings
		   
		   ,PriceLess
		   
		   ,ApproxFloorHeight)
		   
     Select
		   @EnquiryId,
           
		   FloorDetails, 
           NoStop, 
           NoStopDetails, 
           TotalStops,
		   NoOfOpenings,
		   PriceLess,
		   
		   ApproxFloorHeight
		
         
	FROM OPENJSON(@Enquiry, '$.EnqFloor')
    WITH
    (
      FloorDetails nvarchar(max),
      NoStop nvarchar(100),
      NoStopDetails nvarchar(100),
      TotalStops nvarchar(100),
	  NoOfOpenings smallint,
	  PriceLess numeric(18,2),
	  ApproxFloorHeight smallint
	
      
    )

	--============================================
	------------ Cabin Type
	INSERT INTO [dbo].[EnqCabinType]
           (EnquiryId
		  
		   ,EnqCabinType
           ,CabinWidth
           ,CabinDepth
           ,CabinHeight

           ,FlooringType
           ,Handrail)
		   
     Select
		    @EnquiryId

		   ,EnqCabinType
           ,CabinWidth
           ,CabinDepth
           ,CabinHeight

           ,FlooringType
           ,Handrail
           
	FROM OPENJSON(@Enquiry, '$.EnqCabinType')
    WITH
    (
		EnqCabinType nvarchar(100),
        CabinWidth nvarchar(50),
        CabinDepth nvarchar(50),
        CabinHeight nvarchar(50),
        FlooringType nvarchar(50),

        Handrail nvarchar(50)
    )
	--============================================
	--=========== Additional Feature
	INSERT INTO [dbo].[EnqAdditionalFeature]
           ([EnquiryId]

           ,[AdditionalFeatureName])
           
     Select
			@EnquiryId,

            AdditionalFeatureName
          

	FROM OPENJSON(@Enquiry, '$.EnqAdditionalFeature')
    WITH
    (
           EnquiryId int,

           AdditionalFeatureName nvarchar(500)
          
	)


	Select @EnquiryId

	--Insert into EnqFollowUp (EnquiryId)  
	--	select @EnquiryId


	
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