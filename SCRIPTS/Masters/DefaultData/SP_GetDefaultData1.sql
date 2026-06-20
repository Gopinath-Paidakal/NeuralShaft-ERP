USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDefaultData]    Script Date: 20/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDefaultData1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetDefaultData1]
GO

USE [NSERPLIVE]
GO


/****** Object:  StoredProcedure [dbo].[SP_GetDefaultData]    Script Date: 20/03/2026  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetDefaultData1]
--(
--	@FormType nvarchar(100) = ''
  
--)
--With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY

DECLARE @DefaultData NVARCHAR(MAX);

--if upper(@FormType) = 'ALL'
--BEGIN
----SET @DefaultData = (


      SELECT (
        SELECT 
                [DefaultDataId],
                ISNULL([FormType], '') AS [FormType],
                ISNULL([DefaultDataType], '') AS [DefaultDataType],
                ISNULL([DefaultProductWidth], 0) AS [DefaultProductWidth],
                ISNULL([DefaultProductDepth], 0) AS [DefaultProductDepth],

                ISNULL([DefaultDataName], '') AS [DefaultDataName],
                ISNULL([DefaultDataDesc], '') AS [DefaultDataDesc],
                ISNULL([DefaultDataStatus], '') AS [DefaultDataStatus],
                ISNULL([Price], 0) AS [Price],
                ISNULL([DefaultTotalStops], 0) AS [faultTotalStops],

                ISNULL([DefaultCapacity], 0) AS [DefaultCapacity],
                ISNULL([DefaultWeight], 0) AS [DefaultWeight],
                ISNULL([DefaultNoStopPrice], 0) AS [DefaultNoStopPrice],
                ISNULL([DouEntType], '') AS [DouEntType],
                ISNULL([DouEntPrice901st], 0) AS [DouEntPrice901st],

                ISNULL([DouEntPrice902nd], 0) AS [DouEntPrice902nd],
                ISNULL([DouEntPrice1801st], 0) AS [DouEntPrice1801st],
                ISNULL([DouEntPrice1802nd], 0) AS [DouEntPrice1802nd],
                ISNULL([DouEntPrice1803rd], 0) AS [DouEntPrice1803rd],
                ISNULL([DefaultCabinWidth], 0) AS [DefaultCabinWidth],

                ISNULL([DefaultCabinDepth], 0) AS [DefaultCabinDepth],
                ISNULL([DefaultCabinHeight], 0) AS [DefaultCabinHeight],
                ISNULL([ShaftTypeWidth], 0) AS [ShaftTypeWidth],
                ISNULL([ShaftTypeDepth], 0) AS [ShaftTypeDepth],
                ISNULL([ElevatorSpeed], 0) AS [ElevatorSpeed],

                ISNULL([DefaultOverheadHeight], 0) AS [DefaultOverheadHeight],
                ISNULL([DefaultElevatorPit], 0) AS [DefaultElevatorPit],
                ISNULL([DefaultMaxFloors], 0) AS [DefaultMaxFloors],
                ISNULL([DefaultMinWidthSingle], 0) AS [DefaultMinWidthSingle],
                ISNULL([DefaultMinDepthSingle], 0) AS [DefaultMinDepthSingle],

                ISNULL([DefaultMinWidthDouble], 0) AS [DefaultMinWidthDouble],
                ISNULL([DefaultMinDepthDouble], 0) AS [DefaultMinDepthDouble],

                ISNULL([DefaultMinWidthTriple], 0) AS [DefaultMinWidthTriple],
                ISNULL([DefaultMinDepthTriple], 0) AS [DefaultMinDepthTriple],

                ISNULL([DefaultDoorHeight], 0) AS [DefaultDoorHeight],
                ISNULL([DefaultDoorWidth], 0) AS [DefaultDoorWidth],
                ISNULL([DefaultDoorMinShaftWidth], 0) AS [DefaultDoorMinShaftWidth],

                ISNULL([DefaultDataOrderBy], 0) AS [DefaultDataOrderBy],
                
                ISNULL([DefaultPowerSupply], '') AS [DefaultPowerSupply],
                ISNULL([DefaultMachine], '') AS [DefaultMachine],
                ISNULL([DefaultDrive], '') AS [DefaultDrive],
                ISNULL([DefaultController], '') AS [DefaultController],
                ISNULL([DefaultOperation], '') AS [DefaultOperation],

                ISNULL([DefaultGuideRails], '') AS [DefaultGuideRails],
                ISNULL([DefaultRope], '') AS [DefaultRope],
                ISNULL([DefaultSpecialFeatures], '') AS [DefaultSpecialFeatures],
                ISNULL([DoorFormulaMultiply], 0) AS [DoorFormulaMultiply],
                ISNULL([DoorFormulaAdd], 0) AS [DoorFormulaAdd],

                ISNULL([DoorTechWidth], 0) AS [DoorTechWidth],
                ISNULL([DoorTechDepth], 0) AS [DoorTechDepth],

                --- Updated on 01-06-2026
                ISNULL([GST], 0) AS [GST],
                ISNULL([HSNCode], '') AS [HSNCode],

                ISNULL([CabinLeftPanel], '') AS [CabinLeftPanel],
                ISNULL([CabinRightPanel], '') AS [CabinRightPanel],
                ISNULL([CabinFrontPanel], '') AS [CabinFrontPanel],
                ISNULL([CabinRarePanel], '') AS [CabinRarePanel],

                ISNULL([TentativeDuration1], 0) AS [TentativeDuration1],
                ISNULL([TentativeDuration2], 0) AS [TentativeDuration2],
                ISNULL([TentativeDuration3], 0) AS [TentativeDuration3],
                ISNULL([TentativeDuration4], 0) AS [TentativeDuration4],
                ISNULL([TentativeDuration5], 0) AS [TentativeDuration5],
                ISNULL([TentativeDuration6], 0) AS [TentativeDuration6],
                ISNULL([TentativeDuration7], 0) AS [TentativeDuration7],

                ISNULL([EnquirySource], 0) AS [EnquirySource]


                -- ISNULL([CreatedBy], '') AS [CreatedBy],
                --ISNULL([CreatedDate], 0) AS [CreatedDate]


     FROM [dbo].[DefaultData]
         
     Order By FormType, DefaultDataType, DefaultDataOrderBy 

     FOR JSON PATH, ROOT('DefaultData')

     ) AS DefaultData,

    JSON_QUERY(

        (     

        SELECT top 1
        
        [NoOfPassengers],
        [PassengerAmount]

        FROM [dbo].[Passenger]
        
        FOR JSON PATH

        )
        
        ) AS Passenger 

    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;


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

