USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderBOMUpdate]    Script Date: 09/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJobOrderBOMUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJobOrderBOMUpdate]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJobOrderBOMUpdate]    Script Date: 09/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJobOrderBOMUpdate]
(
   --@DDProductId Int,
   @SODtlId Int
 
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    DECLARE @SODetails NVARCHAR(MAX)
    DECLARE @JobOrderBOMDetails NVARCHAR(MAX)
    DECLARE @JobOrderBOM NVARCHAR(MAX)

   --============== JobOrderBOMDetails for Update
   SET @SODetails = (
       
        SELECT  

           --  [SODtl].[ApproxFloorHeight]
            [SODtl].[NoOfOpenings]
           -- ,[SODtl].[OverheadHeight]
            --,[SODtl].[ElevatorPit]
            ,[SODtl].[EnqCabinType]
            ,[SODtl].[FloorDetails]
            ,[SODtl].[SOProduct]
            --,(([SODtl].[ApproxFloorHeight] * [SODtl].[NoOfOpenings]) + ([SODtl].[OverheadHeight]) + ([SODtl].[ElevatorPit])) as 'TravelHeight'
            
            --,[SODtl].[ShaftWidth] as 'SoDtlWidth'
            --,[SODtl].[ShaftDepth] as 'SoDtlDepth'
           -- ,[SODtl].[CabinWidth] as 'SoDtlCabinWidth'
           -- ,[SODtl].[CabinDepth] as 'SoDtlCabinDepth'

            --,[JobOrderPTCDtl].[Width] as 'PTCDtlWidth'
            --,[JobOrderPTCDtl].[Depth] as 'PTCDtlDepth'
            --,([JobOrderPTCDtl].[Width] - [SODtl].[CabinWidth] - 260) as 'CarBracketRange'

            From [SoDtl]
            --INNER JOIN [JobOrder] ON [JobOrder].SoDtlId = [SoDtl].SoDtlId
            --INNER JOIN [JobOrderPTCDtl] ON [JobOrderPTCDtl].JobOrderPTCDtlId = [JobOrder].JobOrderPTCDtlId

            Where [SoDtl].[SODtlId] = @SODtlId

            FOR JSON PATH   
    )

    SET @JobOrderBOMDetails = (
       
        SELECT [JobOrderBOMId]
              ,[SODtlId]
              ,[JobOrderId]
              ,[ProductId]
              ,[AssemblyHdr].[AssemblyHdrId]
              ,[AssemblyHdr].[AssemblyName]

              ,[Item].[ItemId]
              ,[Item].[ItemName]

              ,[ItemQty]
              ,[ItemReqdQty]
              ,[ItemTotalQty]
      
              ,[JobOrderBOM].[CreatedUserId]
              ,[JobOrderBOM].[CreatedDate]

          FROM [dbo].[JobOrderBOM]
          INNER JOIN [Item] ON [Item].[ItemId] = [JobOrderBOM].[ItemId]
          LEFT JOIN [AssemblyHdr] ON [AssemblyHdr].AssemblyHdrId = [JobOrderBOM].AssemblyHdrId

          Where [JobOrderBOM].[SODtlId] = @SODtlId

           FOR JSON PATH   
    )

     SET @JobOrderBOM = (
            SELECT
                JSON_QUERY(@SODetails) AS SODetails,
                JSON_QUERY(@JobOrderBOMDetails)  AS JobOrderBOMDetails
            
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

         