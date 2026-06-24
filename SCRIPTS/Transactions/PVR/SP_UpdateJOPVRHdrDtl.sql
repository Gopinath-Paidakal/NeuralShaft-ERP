USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateJOPVRHdrDtl]    Script Date: 24/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateJOPVRHdrDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateJOPVRHdrDtl]

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateJOPVRHdrDtl]    Script Date: /03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateJOPVRHdrDtl]
(
	@JobOrderPVRId int,	
	@JobOrderPVR nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
	
	------------------------------------------------
    -- UPDATE PVR
    ------------------------------------------------
	UPDATE P
			SET
				P.JobOrderId = J.JobOrderId,
				
				P.SODtlId = J.SODtlId,
				P.ShaftType = J.ShaftType,
				P.ShaftWidth = J.ShaftWidth,
				P.ShaftDepth = J.ShaftDepth,
				P.ElevatorPit = J.ElevatorPit,

				P.[Product] = J.[Product],
				P.DoorOpening = J.DoorOpening,
				P.DoorWidth = J.DoorWidth,
				P.DoorHeight = J.DoorHeight,
				P.NoStop = J.NoStop,

				P.NoStopFloors = J.NoStopFloors,
				P.DoubleEntrance = J.DoubleEntrance,
				P.PlastingStatus = J.PlastingStatus,
				P.Chipping = J.Chipping,
				P.ChippingSize = J.ChippingSize,
				
				P.Offset = J.Offset,
				P.OverHeadWidth = J.OverHeadWidth,
				P.OverHeadDepth = J.OverHeadDepth,
				P.OverHeadHeight = J.OverHeadHeight,
				P.ControlRoomPlacement = J.ControlRoomPlacement,
				
				P.MotorAreaDetails = J.MotorAreaDetails,

				--P.PVRDocPath = J.PVRDocPath,
				P.PVRDocName = J.PVRDocName,

				P.ModifiedUserId = J.ModifiedUserId,
				P.ModifiedDate = J.ModifiedDate

			FROM JobOrderPVR P
			INNER JOIN OPENJSON(@JobOrderPVR, '$.JobOrderPVR')
			WITH
			(
				JobOrderPVRId INT,
				JobOrderId INT,
				SODtlId INT,

				ShaftType NVARCHAR(100),
				ShaftWidth INT,
				ShaftDepth INT,
				ElevatorPit INT,
				[Product] NVARCHAR(100),
				
				DoorOpening NVARCHAR(100),
				DoorWidth DECIMAL(18,2),
				DoorHeight DECIMAL(18,2),
				NoStop NVARCHAR(200),
				NoStopFloors NVARCHAR(200),

				DoubleEntrance NVARCHAR(50),
				PlastingStatus NVARCHAR(100),
				Chipping NVARCHAR(50),
				ChippingSize NVARCHAR(100),
				Offset NVARCHAR(100),
				
				OverHeadWidth INT,
				OverHeadDepth INT,
				OverHeadHeight INT,
				ControlRoomPlacement NVARCHAR(200),
				MotorAreaDetails NVARCHAR(100),

				PVRDocName NVARCHAR(100),

				ModifiedUserId INT,
				ModifiedDate DATETIME
			) J
			ON P.JobOrderPVRId = J.JobOrderPVRId;
	
		---------------------------------------------------------
		--- UPdating Detail JobOrderPVRFloor
		-----====================================================

		UPDATE F
			SET
				F.FloorNo = J.FloorNo,
				F.FloorWidth = J.FloorWidth,
				F.FloorDepth = J.FloorDepth,
				F.FloorHeight = J.FloorHeight,
				F.WaterProtection = J.WaterProtection

			FROM JobOrderPVRFloor F

			INNER JOIN OPENJSON(@JobOrderPVR, '$.JobOrderPVR.JobOrderPVRFloor')
			WITH
			(
				JobOrderPVRFloorId int,

				FloorNo NVARCHAR(50),

				FloorWidth INT,
				FloorDepth INT,
				FloorHeight INT,
				WaterProtection nvarchar(50)
			) J

			ON F.JobOrderPVRFloorId = J.JobOrderPVRFloorId
			--AND F.FloorNo = J.FloorNo;

		Select @JobOrderPVRId
					   
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



  










	