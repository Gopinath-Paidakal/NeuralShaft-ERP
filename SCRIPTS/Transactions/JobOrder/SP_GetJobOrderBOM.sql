USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderBOM]    Script Date: 04/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJobOrderBOM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJobOrderBOM]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderBOM]    Script Date: 04/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJobOrderBOM]
(
	@SODtlId Int
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

--Declare @SODtlId int = 9
Declare @SOHdrId int = 0
Declare @JobOrderId int = 0

Declare @OrdClientId int = 0

Declare @Product nvarchar(30)
Declare @NoOfLandings int = 0
Declare @CarDoors int = 0

Declare @Passengers int = 0
Declare @ApproxFloorHeight int = 0
Declare @BaseToLandingHeight int = 0

Declare @OverHeadHeight int = 0
Declare @Pit int = 0

Declare @Total int = 0

Declare @BracketCount int = 0

Declare @GuideRailLength int = 0
Declare @GuideRailCount int = 0


--select * from sohdr
--select * from sodtl
--select * from SOLandDoor
--select * from SOCarDoor

Set @OrdClientId = (Select OrdClientHdrId from SOHdr where SOHdrId = @SOHdrId)
Set @Product = (Select SOProduct from SODtl where SODtlId = @SODtlId)

Set @NoOfLandings = (Select NoOfOpenings from SODtl where SODtlId = @SODtlId)
Set @Passengers = (Select NoOfPassengers from SODtl where SODtlId = @SODtlId)
Set @Pit = (Select ElevatorPit from SODtl where SODtlId = @SODtlId)
Set @ApproxFloorHeight = (Select ApproxFloorHeight from SODtl where SODtlId = @SODtlId)
Set @OverHeadHeight = (Select OverheadHeight from SODtl where SODtlId = @SODtlId)

Set @BaseToLandingHeight = (@ApproxFloorHeight * @NoOfLandings)

--Set @CarDoors = (Select count(*) from SOCarDoor where SODtlId = @SODtlId)

Set @Total = (@BaseToLandingHeight + @OverHeadHeight + @Pit)

Set @BracketCount = (@Total / 1500)
Set @GuideRailCount = (@Total / 5000)


DECLARE @SODetails   NVARCHAR(MAX)
DECLARE @BOMDetails NVARCHAR(MAX)
DECLARE @JobOrderBOM NVARCHAR(MAX)

 SET @SODetails = (
       
Select @OrdClientId as 'OrdClientId',
       @Product as 'Product', 
       @NoOfLandings as 'No Of Landings', 
       @Passengers as 'Passengers',
       @BaseToLandingHeight as 'BaseToLandingHeight',

       @OverHeadHeight as 'OverHeadHeight',
       @Pit as 'Pit',

       @Total as 'Total',
       @BracketCount as 'BracketCount',
       @GuideRailCount as 'GuideRailCount'

        FOR JSON PATH   
    )

IF OBJECT_ID('tempdb..#BOMAssembly') IS NOT NULL
    DROP TABLE #BOMAssembly;

DROP TABLE IF EXISTS #BOMAssembly;

CREATE TABLE #BOMAssembly
(
    SourceTable     NVARCHAR(20),
    BOMMstId        INT NULL,
    AssemblyItemId  INT NULL,
    ProductId       INT NULL,

    AssemblyHdrId   INT,
    ItemId          INT,
    ItemName        NVARCHAR(150),
    
    ItemQty         INT,
    ReqItemQty      INT,
    TotalQty        INT

);

INSERT INTO #BOMAssembly
(
    SourceTable,
    BOMMstId,
    AssemblyItemId,
    ProductId,

    AssemblyHdrId,
    ItemId,
    ItemName,
    
    ItemQty,
    ReqItemQty,
    TotalQty
)
SELECT
    'BOMMst',
    BOMMst.BOMMstId,
    NULL,
    BOMMst.ProductId,

    BOMMst.AssemblyHdrId,
    [BOMMst].ItemId,
    [ITEM].ItemName,
    
    BOMMst.ItemQty,
    0 AS ReqItemQty,
    0 AS TotalQty

FROM dbo.BOMMst
INNER JOIN [ITEM] On [ITEM].[ItemId] = [BOMMst].[ItemId];

INSERT INTO #BOMAssembly
(
    SourceTable,
    BOMMstId,
    AssemblyItemId,
    ProductId,

    AssemblyHdrId,
    [ITEM].ItemId,
    [ITEM].ItemName,
    
    ItemQty,
    ReqItemQty,
    TotalQty
)
SELECT
    'AssemblyItem',
    NULL,
    [AssemblyItem].AssemblyItemId,
    NULL,

    [AssemblyItem].AssemblyHdrId,
    [AssemblyItem].ItemId,
    [ITEM].ItemName,

    ItemQty,
    0  AS ReqItemQty,
    0  AS TotalQty

FROM dbo.AssemblyItem
INNER JOIN [ITEM] On [ITEM].[ItemId] = [AssemblyItem].[ItemId];

SET @BOMDetails = (
    select * from #BOMAssembly

    FOR JSON PATH   
 )

 SET @JobOrderBOM = (
        SELECT
            JSON_QUERY(@SODetails)  AS SODetails,
            JSON_QUERY(@BOMDetails) AS BOMDetails
        FOR JSON PATH,  WITHOUT_ARRAY_WRAPPER
        )

 Select @JobOrderBOM

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

         