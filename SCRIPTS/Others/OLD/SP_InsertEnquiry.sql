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
	--================= Client Details

	INSERT INTO [dbo].[EnqClientDetails]
           (EnqClientGUID
		   ,EnqConsultant
           ,EnqClientName
           ,EnqClientMobileNo
		   ,EnqClientEmailId

           ,EnqClientAddress
           ,EnqClientCategory
           ,EnqLeadSource         
		   ,EnqSourceBy
           ,CreatedBy)
          
     Select
		   NEWID(),
		   EnqConsultant,
           EnqClientName, 
           EnqClientMobileNo, 
           EnqClientEmailId, 

           EnqClientAddress, 
		   EnqClientCategory,
           EnqLeadSource, 
		   EnqSourceBy,         
           CreatedBy

    FROM OPENJSON(@Enquiry, '$.EnqClientDetails')
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
           EnqSourceBy nvarchar(100),
           CreatedBy nvarchar(20)
    )

	SET @EnqClientId = IDENT_CURRENT('EnqClientDetails')
	select @EnqClientId

	--=================Shaft Details
	INSERT INTO EnqShaftDetails(
		ShaftType, 
		ShaftWidth, 
		ShaftDepth,
		EnqProduct,
		EnqProductType,
		Capacity,
		CreatedBy,
		CreatedDate)
    SELECT 
		ShaftType, 
		ShaftWidth, 
		ShaftDepth,
		EnqProduct,
		EnqProductType,
		Capacity,
		CreatedBy,
		GetDate()
    FROM OPENJSON(@Enquiry, '$.EnqShaftDetails')
    WITH
    (
        ShaftType NVARCHAR(100),
        ShaftWidth NVARCHAR(100),
        ShaftDepth NVARCHAR(100),
        ShaftDepth NVARCHAR(100),
		EnqProduct  NVARCHAR(100), 
		EnqProductType  NVARCHAR(100),
		Capacity  smallint,
		CreatedBy  NVARCHAR(20)
    )
	SET @EnqShaftDetailsId = IDENT_CURRENT('EnqShaftDetails')
	--============================================
	--================= Door Details
	INSERT INTO [dbo].[EnqDoorDetails]
           (DoorOpening
           ,DoorWidth
           ,DoorFinish
           ,DoubleEntrance
           ,CreatedBy
           ,CreatedDate)
     Select
           DoorOpening, 
           DoorWidth, 
           DoorFinish, 
           DoubleEntrance, 
           CreatedBy, 
           Getdate()
	FROM OPENJSON(@Enquiry, '$.EnqDoorDetails')
    WITH
    (
       DoorOpening nvarchar(100),
       DoorWidth nvarchar(100),
       DoorFinish nvarchar(100),
       DoubleEntrance nvarchar(100),
       CreatedBy nvarchar(20)
    )
	SET @EnqDoorTypeId = IDENT_CURRENT('EnqDoorDetails')
	--============================================

	--================= Floor Details
	INSERT INTO [dbo].[EnqFloorDetails]
           (FloorDetails
           ,NoOfStop
           ,NoStopDetails
           ,TotalStops
           ,CreatedBy
           ,CreatedDate)
     Select
           FloorDetails, 
           NoOfStop, 
           NoStopDetails, 
           TotalStops, 
           CreatedBy,
           Getdate()
	FROM OPENJSON(@Enquiry, '$.EnqFloorDetails')
    WITH
    (
      FloorDetails nvarchar(100),
      NoOfStop nvarchar(100),
      NoStopDetails nvarchar(100),
      TotalStops nvarchar(100),
      CreatedBy nvarchar(20)
    )
	SET @EnqFloorDetailsId= IDENT_CURRENT('EnqFloorDetails')
	--============================================
	------------ Cabin Type
	INSERT INTO [dbo].[EnqCabinType]
           (EnqCabinType
           ,Scaffolding
           ,ShaftLighting
           ,NumpadCop
           ,BioScanCop
           ,BioScanLop
           ,IntercomCop)
     Select
			EnqCabinType
           ,Scaffolding
           ,ShaftLighting
           ,NumpadCop
           ,BioScanCop
           ,BioScanLop
           ,IntercomCop
	FROM OPENJSON(@Enquiry, '$.EnqCabinType')
    WITH
    (
		EnqCabinType nvarchar(100),
        Scaffolding nvarchar(50),
        ShaftLighting nvarchar(50),
        NumpadCop nvarchar(50),
        BioScanCop nvarchar(50),
        BioScanLop nvarchar(50),
        IntercomCop nvarchar(50)
    )
	SET @EnqCabinTypeId  = IDENT_CURRENT('EnqCabinType')
	--============================================
	--- ============= Enquiry

	INSERT INTO [dbo].[Enquiry]
	(
		CompanyId,
		BranchId,
		EnqClientId,
		EnqShaftDetailsId,
		EnqDoorTypeId,

		EnqFloorDetailsId,
		EnqCabinTypeId,
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
		 @EnqClientId,
		 @EnqShaftDetailsId,
		 @EnqDoorTypeId,

		 @EnqFloorDetailsId,
		 @EnqCabinTypeId,
		 1,
		 1,

		 '2026-03-10',
		 EnqRefDetails,
		 EnqRemarks,
		 EnqStatus,
		 Latitude,

		 Longitude,
		 'Admin',
		  '2026-03-10'

	FROM OPENJSON(@Enquiry, '$.Enquiry')
	WITH
	(
		EnqRefDetails NVARCHAR(100),
		EnqRemarks NVARCHAR(500),
		EnqStatus NVARCHAR(5),
		Latitude NVARCHAR(50),
		Longitude NVARCHAR(50)
	)



	SET @EnquiryId = IDENT_CURRENT('Enquiry')

	Select @EnquiryId
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