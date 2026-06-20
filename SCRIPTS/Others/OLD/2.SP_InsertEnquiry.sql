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

	Declare @EnqClientId int
	Declare @EnqShaftDetailsId int
	Declare @EnqDoorTypeId int
	Declare @EnqFloorDetailsId int
	Declare @EnqProductTypeId int
	Declare @EnqCabinTypeId int

	Declare @EnquiryId int

	BEGIN TRANSACTION

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
		 1,
		 1,
		 1,
		 1,

		 GETDATE(),
		 --EnqRefDetails,
		 JSON_VALUE(@Enquiry, '$.Enquiry.EnqRefDetails') AS EnqRefDetails,
		 --EnqRemarks,
		  JSON_VALUE(@Enquiry, '$.Enquiry.EnqRemarks') AS EnqRemarks,
		 --EnqStatus,
		 JSON_VALUE(@Enquiry, '$.Enquiry.EnqStatus') AS EnqStatus,
		 --Latitude,
		  JSON_VALUE(@Enquiry, '$.Enquiry.Latitude') AS Latitude,
		 --Longitude,
		  JSON_VALUE(@Enquiry, '$.Enquiry.Longitude') AS Longitude,
		 'Admin',
		 GETDATE()

	--FROM OPENJSON(@Enquiry, '$.Enquiry')
	--WITH
	--(
	--	EnqRefDetails NVARCHAR(100),
	--	EnqRemarks NVARCHAR(500),
	--	EnqStatus NVARCHAR(5),
	--	Latitude NVARCHAR(50),
	--	Longitude NVARCHAR(50)
	--)

	SET @EnquiryId = IDENT_CURRENT('Enquiry')

	--================= Client Details

	INSERT INTO [dbo].[EnqClient]
           (EnquiryId, EnqClientGUID, EnqConsultant ,EnqClientName ,EnqClientMobileNo ,EnqClientEmailId
           ,EnqClientAddress,EnqClientCategory,EnqLeadSource,EnqSourceBy,CreatedBy)
          
     Select
			@EnquiryId,
			NEWID(),
			JSON_VALUE(@Enquiry, '$.EnqClient.EnqConsultant') AS EnqConsultant,
			jSON_VALUE(@Enquiry, '$.EnqClient.EnqClientName') AS EnqClientName,
			JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientMobileNo') AS EnqClientMobileNo,
			JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientEmailId') AS EnqClientEmailId,
		   --EnqConsultant,
     --      EnqClientName, 
     --      EnqClientMobileNo, 
     --      EnqClientEmailId, 

     --      EnqClientAddress, 
		   --EnqClientCategory,
     --      EnqLeadSource, 
		   --EnqSourceBy,         
     --      CreatedBy

		   	JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientAddress') AS EnqClientAddress,
			jSON_VALUE(@Enquiry, '$.EnqClient.EnqClientCategory') AS EnqClientCategory,
			JSON_VALUE(@Enquiry, '$.EnqClient.EnqLeadSource') AS EnqLeadSource,
			JSON_VALUE(@Enquiry, '$.EnqClient.EnqSourceBy') AS EnqSourceBy,
			JSON_VALUE(@Enquiry, '$.EnqClient.CreatedBy') AS CreatedBy

    --FROM OPENJSON(@Enquiry, '$.EnqClient')
    --WITH
    --(
		  -- EnqClientGUID nvarchar(100),
		  -- EnqConsultant nvarchar(100),
		  -- EnqClientName nvarchar(100), 
    --       EnqClientMobileNo nvarchar(100),
    --       EnqClientEmailId nvarchar(100),
           
		  -- EnqClientAddress nvarchar(100),
		  -- EnqClientCategory nvarchar(100),
		  -- EnqLeadSource nvarchar(100),
    --       EnqSourceBy nvarchar(100),
    --       CreatedBy nvarchar(20)
    --)

	--SET @EnqClientId = IDENT_CURRENT('EnqClientDetails')
	---select @EnqClientId
	
	--=================Shaft Details
	INSERT INTO EnqShaft(
	    EnquiryId,
		ShaftType, 
		ShaftWidth, 
		ShaftDepth,
		EnqProduct,

		EnqProductType,
		Capacity,
		CreatedBy,
		CreatedDate)

    SELECT 

	    @EnquiryId,
		JSON_VALUE(@Enquiry, '$.EnqShaft.ShaftType') AS ShaftType,
		jSON_VALUE(@Enquiry, '$.EnqShaft.ShaftWidth') AS ShaftWidth,
		JSON_VALUE(@Enquiry, '$.EnqShaft.ShaftDepth') AS ShaftDepth,
		JSON_VALUE(@Enquiry, '$.EnqShaft.EnqProduct') AS EnqProduct,

		JSON_VALUE(@Enquiry, '$.EnqShaft.EnqProductType') AS EnqProductType,
		JSON_VALUE(@Enquiry, '$.EnqShaft.Capacity') AS Capacity,
		jSON_VALUE(@Enquiry, '$.EnqShaft.CreatedBy') AS CreatedBy,
	
		--ShaftType, 
		--ShaftWidth, 
		--ShaftDepth,
		--EnqProduct,
		--EnqProductType,

		--Capacity,
		--CreatedBy,
		GetDate()
  --  FROM OPENJSON(@Enquiry, '$.EnqShaft')
  --  WITH
  --  (
  --      ShaftType NVARCHAR(100),
  --      ShaftWidth NVARCHAR(100),
  --      ShaftDepth NVARCHAR(100),
  --      ShaftDepth NVARCHAR(100),
		--EnqProduct  NVARCHAR(100), 
		--EnqProductType  NVARCHAR(100),
		--Capacity  smallint,
		--CreatedBy  NVARCHAR(20)
  --  )
	--SET @EnqShaftDetailsId = IDENT_CURRENT('EnqShaftDetails')
	--============================================
	--================= Door Details
	INSERT INTO [dbo].[EnqDoor]
           (EnquiryId
		   ,DoorOpening
           ,DoorWidth
		   ,DoorHeight
           ,DoorFinish

           ,DoubleEntrance
		   ,DoubleEntranceDegree
		   ,DoubleEntranceDetails
           ,CreatedBy
           ,CreatedDate)
     Select
	     @EnquiryId,
		JSON_VALUE(@Enquiry, '$.EnqDoor.DoorOpening') AS DoorOpening,
		jSON_VALUE(@Enquiry, '$.EnqDoor.DoorWidth') AS DoorWidth,
		JSON_VALUE(@Enquiry, '$.EnqDoor.DoorHeight') AS DoorHeight,
		JSON_VALUE(@Enquiry, '$.EnqDoor.DoorFinish') AS DoorFinish,

		JSON_VALUE(@Enquiry, '$.EnqDoor.DoubleEntrance') AS DoubleEntrance,
		JSON_VALUE(@Enquiry, '$.EnqDoor.DoubleEntranceDegree') AS DoubleEntranceDegree,
		JSON_VALUE(@Enquiry, '$.EnqDoor.DoubleEntranceDetails') AS DoubleEntranceDetails,
		jSON_VALUE(@Enquiry, '$.EnqDoor.CreatedBy') AS CreatedBy,
	   
	    --   @EnquiryId,
     --      DoorOpening, 
     --      DoorWidth, 
		   --DoorHeight,
     --      DoorFinish, 
     --      DoubleEntrance, 
		   --DoubleEntranceDegree,
		   --DoubleEntranceDetails,
     --      CreatedBy, 
           Getdate()
	--FROM OPENJSON(@Enquiry, '$.EnqDoor')
 --   WITH
 --   (
 --      DoorOpening nvarchar(100),
 --      DoorWidth nvarchar(100),
	--   DoorHeight nvarchar(100),
 --      DoorFinish nvarchar(100),
 --      DoubleEntrance nvarchar(100),
 --      DoubleEntranceDegree nvarchar(100),
	--   DoubleEntranceDetails nvarchar(max),
 --      CreatedBy nvarchar(20)
 --   )
	--SET @EnqDoorTypeId = IDENT_CURRENT('EnqDoorDetails')
	--============================================

	--================= Floor Details
	INSERT INTO [dbo].[EnqFloor]
           (EnquiryId
		   ,FloorDetails
           ,NoOfStop
           ,NoStopDetails
           ,TotalStops

           ,CreatedBy
           ,CreatedDate)
     Select
			 @EnquiryId,
			JSON_VALUE(@Enquiry, '$.EnqFloor.FloorDetails') AS FloorDetails,
			jSON_VALUE(@Enquiry, '$.EnqFloor.NoOfStop') AS NoOfStop,
			JSON_VALUE(@Enquiry, '$.EnqFloor.NoStopDetails') AS NoStopDetails,
			JSON_VALUE(@Enquiry, '$.EnqFloor.TotalStops') AS TotalStops,

			jSON_VALUE(@Enquiry, '$.EnqFloor.CreatedBy') AS CreatedBy,
				   
           --FloorDetails, 
           --NoOfStop, 
           --NoStopDetails, 
           --TotalStops, 
           --CreatedBy,
           Getdate()
	--FROM OPENJSON(@Enquiry, '$.EnqFloor')
 --   WITH
 --   (
 --     FloorDetails nvarchar(max),
 --     NoOfStop nvarchar(100),
 --     NoStopDetails nvarchar(100),
 --     TotalStops nvarchar(100),
 --     CreatedBy nvarchar(20)
 --   )
	--SET @EnqFloorDetailsId= IDENT_CURRENT('EnqFloorDetails')
	--============================================
	------------ Cabin Type
	INSERT INTO [dbo].[EnqCabinType]
           (EnquiryId
		   ,EnqCabinType
           ,Scaffolding
           ,ShaftLighting
           ,NumpadCop

           ,BioScanCop
           ,BioScanLop
           ,IntercomCop)
     Select
		    @EnquiryId,
			JSON_VALUE(@Enquiry, '$.EnqCabinType.EnqCabinType') AS EnqCabinType,
			jSON_VALUE(@Enquiry, '$.EnqCabinType.Scaffolding') AS Scaffolding,
			JSON_VALUE(@Enquiry, '$.EnqCabinType.ShaftLighting') AS ShaftLighting,
			JSON_VALUE(@Enquiry, '$.EnqCabinType.NumpadCop') AS NumpadCop,

			JSON_VALUE(@Enquiry, '$.EnqCabinType.BioScanCop') AS BioScanCop,
			JSON_VALUE(@Enquiry, '$.EnqCabinType.BioScanLop') AS BioScanLop,
			jSON_VALUE(@Enquiry, '$.EnqCabinType.IntercomCop') AS IntercomCop
			--,EnqCabinType
   --        ,Scaffolding
   --        ,ShaftLighting
   --        ,NumpadCop
   --        ,BioScanCop
   --        ,BioScanLop
   --        ,IntercomCop
	--FROM OPENJSON(@Enquiry, '$.EnqCabinType')
 --   WITH
 --   (
	--	EnqCabinType nvarchar(100),
 --       Scaffolding nvarchar(50),
 --       ShaftLighting nvarchar(50),
 --       NumpadCop nvarchar(50),
 --       BioScanCop nvarchar(50),
 --       BioScanLop nvarchar(50),
 --       IntercomCop nvarchar(50)
 --   )
	--SET @EnqCabinTypeId  = IDENT_CURRENT('EnqCabinType')
	--============================================
	

	Select @EnquiryId
	Insert into EnqFollowUp (EnquiryId)  
		select @EnquiryId


	--select 
	--	JSON_VALUE(@Enquiry, '$.Enquiry.EnqNo') AS EnqNo,
	--	--JSON_VALUE(@Enquiry, '$.Enquiry.Date') AS EnqDate,
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqConsultant') AS Consultant,
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientName') AS ClientName,	
	--	JSON_VALUE(@Enquiry, '$.EnqClient.EnqClientMobileNo') AS MobileNo
	--FOR JSON PATH, ROOT('Enquiry')
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