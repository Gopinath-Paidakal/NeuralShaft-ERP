USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDefaultData]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateDefaultData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateDefaultData]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDefaultData]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateDefaultData]
(
    @DefaultDataId int,
	@DefaultData nvarchar(Max)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

    --Declare @DefaultDataId int

    --set @DefaultDataId = JSON_VALUE(@DefaultData, '$.@DefaultData.DefaultDataId')

	UPDATE T
    SET 
        T.FormType = S.FormType,
        T.DefaultDataType = S.DefaultDataType,
        T.DefaultProductWidth = S.DefaultProductWidth,
        T.DefaultProductDepth = S.DefaultProductDepth,
        T.DefaultDataName = S.DefaultDataName,

        T.DefaultDataDesc = S.DefaultDataDesc,
        T.DefaultDataStatus = S.DefaultDataStatus,
        T.Price = S.Price,
        T.DefaultTotalStops = S.DefaultTotalStops,
        T.DefaultCapacity = S.DefaultCapacity,
        
        T.DefaultWeight = S.DefaultWeight,
        T.DefaultNoStopPrice = S.DefaultNoStopPrice,
        T.DouEntType = S.DouEntType,
        T.DouEntPrice901st = S.DouEntPrice901st,
        T.DouEntPrice902nd = S.DouEntPrice902nd,
        
        T.DouEntPrice1801st = S.DouEntPrice1801st,
        T.DouEntPrice1802nd = S.DouEntPrice1802nd,
        T.DouEntPrice1803rd = S.DouEntPrice1803rd,
        T.DefaultCabinWidth = S.DefaultCabinWidth,
        T.DefaultCabinDepth = S.DefaultCabinDepth,
        
        T.DefaultCabinHeight = S.DefaultCabinHeight,
        T.ShaftTypeWidth = S.ShaftTypeWidth,
        T.ShaftTypeDepth = S.ShaftTypeDepth,
        T.ElevatorSpeed = S.ElevatorSpeed,
        T.DefaultOverheadHeight = S.DefaultOverheadHeight,
        
        T.DefaultElevatorPit = S.DefaultElevatorPit,
        T.DefaultMaxFloors = S.DefaultMaxFloors,
        T.DefaultMinWidthSingle = S.DefaultMinWidthSingle,
        T.DefaultMinDepthSingle = S.DefaultMinDepthSingle,
        T.DefaultMinWidthDouble = S.DefaultMinWidthDouble,
        
        T.DefaultMinDepthDouble = S.DefaultMinDepthDouble,
        T.DefaultMinWidthTriple = S.DefaultMinWidthTriple,
        T.DefaultMinDepthTriple = S.DefaultMinDepthTriple,
        T.DefaultDoorHeight = S.DefaultDoorHeight,
        T.DefaultDoorWidth = S.DefaultDoorWidth,

        T.DefaultDoorMinShaftWidth = S.DefaultDoorMinShaftWidth,
        T.DefaultDataOrderBy = S.DefaultDataOrderBy,
        
        T.DefaultPowerSupply = S.DefaultPowerSupply,
        T.DefaultMachine = S.DefaultMachine,
        T.DefaultDrive = S.DefaultDrive,
        T.DefaultController = S.DefaultController,
        T.DefaultOperation = S.DefaultOperation,
        T.DefaultGuideRails = S.DefaultGuideRails,
        T.DefaultRope = S.DefaultRope,

        T.DefaultSpecialFeatures = S.DefaultSpecialFeatures,
        T.DoorFormulaMultiply = S.DoorFormulaMultiply,
        T.DoorFormulaAdd = S.DoorFormulaAdd,
        T.DoorTechWidth = S.DoorTechWidth,
        T.DoorTechDepth = S.DoorTechDepth,

        T.GST = S.GST,
        T.HSNCode = S.HSNCode,
        
        T.CabinLeftPanel = S.CabinLeftPanel,
        T.CabinRightPanel = S.CabinRightPanel,
        T.CabinFrontPanel = S.CabinFrontPanel,
        T.CabinRarePanel = S.CabinRarePanel,

        T.TentativeDuration1 = S.TentativeDuration1,
        T.TentativeDuration2 = S.TentativeDuration2,
        T.TentativeDuration3 = S.TentativeDuration3,
        T.TentativeDuration4 = S.TentativeDuration4,
        T.TentativeDuration5 = S.TentativeDuration4,

        T.TentativeDuration6 = S.TentativeDuration6,
        T.TentativeDuration7 = S.TentativeDuration7,

        T.EnquirySource = S.EnquirySource,
        T.Stage         = S.Stage,

        T.ModifiedUserId = S.ModifiedUserId,   ---1,   --'Admin',
        T.ModifiedDate = S.ModifiedDate

    FROM dbo.DefaultData T
    INNER JOIN OPENJSON(@DefaultData, '$.DefaultData')
    WITH
    (
        DefaultDataId INT,  -- REQUIRED for update

        FormType NVARCHAR(100),
        DefaultDataType NVARCHAR(50),
        DefaultProductWidth INT,
        DefaultProductDepth INT,
        DefaultDataName NVARCHAR(100),
        
        DefaultDataDesc NVARCHAR(500),
        DefaultDataStatus bit,
        Price NUMERIC(10,2),
        DefaultTotalStops INT,
        DefaultCapacity INT,
        
        DefaultWeight INT,
        DefaultNoStopPrice INT,
        DouEntType NVARCHAR(5),
        DouEntPrice901st INT,
        DouEntPrice902nd INT,
        
        DouEntPrice1801st INT,
        DouEntPrice1802nd INT,
        DouEntPrice1803rd INT,
        DefaultCabinWidth INT,
        DefaultCabinDepth INT,
        
        DefaultCabinHeight INT,
        ShaftTypeWidth INT,
        ShaftTypeDepth INT,
        ElevatorSpeed NUMERIC(18,2),
        DefaultOverheadHeight INT,
        
        DefaultElevatorPit INT,
        DefaultMaxFloors INT,
        DefaultMinWidthSingle INT,
        DefaultMinDepthSingle INT,
        DefaultMinWidthDouble INT,
        
        DefaultMinDepthDouble INT,
        DefaultMinWidthTriple INT,
        DefaultMinDepthTriple INT,
        DefaultDoorHeight int,
        DefaultDoorWidth int, 

        DefaultDoorMinShaftWidth int,
        DefaultDataOrderBy SMALLINT,

        DefaultPowerSupply nvarchar(200),
        DefaultMachine nvarchar(200),
        DefaultDrive nvarchar(200),
        DefaultController nvarchar(200),
        DefaultOperation nvarchar(200),

        DefaultGuideRails nvarchar(200),
        DefaultRope nvarchar(200),
        DefaultSpecialFeatures nvarchar(500),
        DoorFormulaMultiply numeric(10,2),
        DoorFormulaAdd int,

        DoorTechWidth int,
        DoorTechDepth int,

        ---- Updated on 01-06-2026
        GST numeric(5,2),
        HSNCode nvarchar(50),

        [CabinLeftPanel] nvarchar(100),
        [CabinRightPanel] nvarchar(100),
        [CabinFrontPanel] nvarchar(100),
        [CabinRarePanel] nvarchar(100),
        
        [TentativeDuration1] smallint,
        [TentativeDuration2] smallint,
        [TentativeDuration3] smallint,
        [TentativeDuration4] smallint,
        [TentativeDuration5] smallint,

        [TentativeDuration6] smallint,
        [TentativeDuration7] smallint,

        [EnquirySource] nvarchar(100),
        [Stage] nvarchar(50),

        ModifiedUserId int,
        ModifiedDate nvarchar(20)

) S
    ON T.DefaultDataId = S.DefaultDataId;   -- KEY JOIN

    Select @DefaultDataId

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