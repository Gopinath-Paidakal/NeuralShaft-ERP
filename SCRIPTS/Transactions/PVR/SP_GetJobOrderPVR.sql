USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderPVR]    Script Date: 20/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJobOrderPVR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJobOrderPVR]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderPVR]    Script Date: 20/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJobOrderPVR]
(
	@SODtlId int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @JobOrderPVR   NVARCHAR(MAX)
DECLARE @JobOrderPVRFloor NVARCHAR(MAX)

DECLARE @TotJobOrderPVR NVARCHAR(MAX)


 SET @JobOrderPVR = (
       
        SELECT [JobOorderPVRId]
              ,[JobOrderId]
              ,[SODtlId]
              ,[ShaftType]
              ,[ShaftWidth]

              ,[ShaftDepth]
              ,[ElevatorPit]
              ,[Product]
              ,[DoorOpening]
              ,[DoorWidth]
              
              ,[DoorHeight]
              ,[NoStop]
              ,[NoStopFloors]
              ,[DoubleEntrance]
              ,[PlastingStatus]
              
              ,[Chipping]
              ,[ChippingSize]
              ,[Offset]
              ,[OverHeadWidth]
              ,[OverHeadDepth]

              ,[OverHeadHeight]
              ,[ControlRoomPlacement]
              ,[MotorAreaDetails]
              ,[CreatedUserId]
              ,[CreatedDate]

          FROM [dbo].[JobOrderPVR]
          where SodtlId = @SODtlId

        FOR JSON PATH   
    )

    Declare @JobOorderPVRId int = 0

    set @JobOorderPVRId = (Select JobOorderPVRId from JobOrderPVR where SODtlId = @SoDtlId)

    SET @JobOrderPVRFloor = (
       SELECT [JobOrderPVRFloorId]
              ,[JobOorderPVRId]
              ,[FloorNo]
              ,[FloorWidth]
              ,[FloorDepth]
              ,[FloorHeight]
        FROM [dbo].[JobOrderPVRFloor]
        where JobOorderPVRId = @JobOorderPVRId

        FOR JSON PATH    
    )

    SET @TotJobOrderPVR = (
        SELECT
            JSON_QUERY(@JobOrderPVR)  AS DefaultData,
            JSON_QUERY(@JobOrderPVRFloor) AS Passenger
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

   Select @TotJobOrderPVR

END TRY

	BEGIN CATCH

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



--SELECT ISNULL(@DefaultData, '{"DefaultData":[]}') AS DefaultData;
--END

































































