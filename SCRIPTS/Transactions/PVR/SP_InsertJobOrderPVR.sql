USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderPVR]    Script Date: 19/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertJobOrderPVR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertJobOrderPVR]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderPVR]    Script Date: 19/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertJobOrderPVR]
(
    @JobOrderPVR NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    Declare @JobOrderPVRId int

    Declare @JobOrderId  int

    set @JobOrderId = JSON_VALUE(@JobOrderPVR, '$JobOrderPVR.JobOrderId')

    INSERT INTO JobOrderPVR
    (
        JobOrderId,
        SODtlId,
        ShaftType,
        ShaftWidth,
        ShaftDepth,

        ElevatorPit,
        Product,
        DoorOpening,
        DoorWidth,
        DoorHeight,
        
        NoStop,
        DoubleEntrance,
        PlastingStatus,
        Chipping,
        ChippingSize,
        Offset,
        
        OverheadWidth,
        OverheadDepth,
        OverheadHeight,
        ControlRoomPlacement,
        MotorAreaDetails,
        
        PVRDocPath,
        PVRDocName,

        CreatedUserId,
        CreatedDate
    )
    SELECT
        JobOrderId,
        SODtlId,
        ShaftType,
        ShaftWidth,
        ShaftDepth,
        
        ElevatorPit,
        Product,
        DoorOpening,
        DoorWidth,
        DoorHeight,
        
        NoStop,
        DoubleEntrance,
        PlastingStatus,
        Chipping,
        ChippingSize,

        Offset,
        OverheadWidth,
        OverheadDepth,
        OverheadHeight,
        ControlRoomPlacement,

        MotorAreaDetails,

        '/uploads/pvr/',
        PVRDocName,

        CreatedUserId,
        CreatedDate

    FROM OPENJSON(@JobOrderPVR, '$.JobOrderPVR')
    WITH
    (
        JobOrderId INT,
        SODtlId INT,
        ShaftType NVARCHAR(100),
        ShaftWidth INT,
        ShaftDepth INT,

        ElevatorPit INT,
        Product NVARCHAR(100),
        DoorOpening NVARCHAR(100),
        DoorWidth INT,
        DoorHeight INT,

        NoStop NVARCHAR(10),
        DoubleEntrance NVARCHAR(10),
        PlastingStatus NVARCHAR(50),
        Chipping NVARCHAR(10),
        ChippingSize NVARCHAR(100),

        Offset NVARCHAR(10),
        OverheadWidth INT,
        OverheadDepth INT,
        OverheadHeight INT,
        ControlRoomPlacement NVARCHAR(100),

        MotorAreaDetails NVARCHAR(100),
        PVRDocName NVARCHAR(100),

        CreatedUserId INT,
        CreatedDate DATETIME
    );

    set @JobOrderPVRId = SCOPE_IDENTITY()

    -- Insert Floor Details
    INSERT INTO JobOrderPVRFloor
    (
        JobOorderPVRId,
        FloorNo,
        FloorWidth,
        FloorDepth,
        FloorHeight,
        WaterProtection
    )
    SELECT
        @JobOrderPVRId,
        FloorNo,
        FloorWidth,
        FloorDepth,
        FloorHeight,
        WaterProtection

    FROM OPENJSON(@JobOrderPVR, '$.JobOrderPVR.FloorDetails')
    WITH
    (
        FloorNo VARCHAR(10),
        FloorWidth INT,
        FloorDepth INT,
        FloorHeight INT,
        WaterProtection nvarchar(50)
    );

     ---==================================================
    --- Updating the JobOrder
    --====================================================
    Update JobOrder set JobOrderPVRId = @JobOrderPVRId where JobOrder.JobOrderId = @JobOrderId
    --======================================================

    select @JobOrderPVRId

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




 --SELECT
 --            [SOHdr].[SOHdrId]
 --           --,[SoDtl].[SoDtlId]

 --           ,[SOHdr].[SOHNo]
 --           ,[SOHdr].[ProjectName]
 --           ,Convert(nvarchar(100), 'JO' + RIGHT('0000' + Convert(nvarchar(20),[SOHdr].[SOHNo]),5) + 'BE') as 'Job Ord No'
 --           --,[EnqHdr].[EnqNo]
 --          -- ,[QuoteHdr].[QuoteNo]

 --           ,FORMAT([SOHdr].[SOHDate], 'dd-MM-yyyy') as 'JOB Order Date'  --  + ' ' + FORMAT(SOHDate, 'HH:mm:ss') as SOHDate

 --           ,[SOHdr].[SOCustComp]
 --           ,[SOHdr].[SOContPerson]

 --           ,[SOHdr].[SOMobileNo]
           
	--	  FROM SoHdr   

--INNER JOIN SoDtl On SoDtl.SOHdrId = SOHdr.SOHdrId
          --INNER JOIN EnqHdr On EnqHdr.EnqHdrId = SOHdr.EnqHdrId
          --INNER JOIN QuoteHdr On QuoteHdr.QuoteHdrId = SOHdr.QuoteHdrId
          --INNER JOIN OrdClientHdr ON SOHdr.OrdClientHdrId = OrdClientHdr.OrdClientHdrId
          --INNER JOIN OrdClientAddr ON OrdClientHdr.OrdClientHdrId = OrdClientAddr.OrdClientHdrId


--where [SOHdr].[SOHDate] >= @FromDate and [SOHdr].[SOHDate] < @ToDate

 --,[SOHdr].[OrdTotalAmount]
               --,[SOSubTotal]
              --,[SOTaxAmount]
              --,[SOGrandTotal]
            --,(Select TaxableValue from sodtl where SoDtl.SOHdrId = SOHdr.SOHdrId) as 'TaxableValue' 
            --,(Select sum(SOSubTotal) from SoDtl where SoDtl.SOHdrId = SOHdr.SOHdrId) as 'SOSubTotal' 
            --,(Select sum(SOTaxAmount) from SoDtl where SoDtl.SOHdrId = SOHdr.SOHdrId) as 'SOSubTaxAmount' 
            --,(Select sum(SOGrandTotal) from SoDtl where SoDtl.SOHdrId = SOHdr.SOHdrId) as 'SOTotalAmount' 

            --,[OrdClientHdr].OrdClientName
            --,[OrdClientAddr].OrdClientPriContPerson
            --,[OrdClientAddr].OrdClientPhNo
			

          --WHERE dbo.fn_FormatDate([SOHdr].[SOHDate]) >= dbo.fn_FormatDate(@FromDate)
          --and  dbo.fn_FormatDate([SOHdr].[SOHDate]) <= dbo.fn_FormatDate(@ToDate)

 --,[CompanyId]
          --,[BranchId]
          --,[EnqHdrId]

          --,[QuoteHdrId]
          --,[OrdClientHdrId]

            --,dbo.fn_FormatDate([SOHdr].[SOHDate]) as [SOHDate]

            --,[SOHdr].[SOConsultant]

                 -- ,[SOHdr].[SOBillingAddr]

                    --,[SOHdr].[ProjectName]
          --,[SOHdr].[ExpectedClosingDate]
          --,[SOHdr].[SOEmailId]
          --,[SOHdr].[DeliveryBy]
          --,[SOHdr].[QuoteValidity]
          --,[SOHdr].[ComplementaryAMC]
          --,[SOHdr].[GSTExempted]
          --,[SOPaymentTerms]

          --,[SOHdr].[OrdAmount]
          --,[SOHdr].[OrdSubTotal]
          --,[SOHdr].[OrdTax]

            --,[SOHdr].[OrdAdvance]
          --,[SOHdr].[OrdPayments]
          --,[SOHdr].[OrdStatus]
          --,[SOHdr].[CreatedUserId]
          --,dbo.fn_FormatDate([SOHdr].[CreatedDate]) AS [CreatedDate]
          --,[SOHdr].[CreatedAt]

         