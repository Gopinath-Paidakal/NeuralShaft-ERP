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

        --Declare @SODtlId int
        Declare @SOHdrId int
        Declare @JobOrderId INT
        Declare @OrdClientId INT

        Declare @Product nvarchar(30)
        Declare @ProductId int
        Declare @LandingDoors int = 0
        Declare @CarDoors int = 0

        --select * from sohdr
        --select * from sodtl
        --select * from SOLandDoor
        --select * from SOCarDoor

        Set @OrdClientId = (Select OrdClientHdrId from SOHdr where SOHdrId = @SOHdrId)
        Set @Product = (Select SOProduct from SODtl where SODtlId = @SODtlId)
        Set @ProductId = (Select DefaultDataId from DefaultData where DefaultDataName = @Product)
        Set @LandingDoors = (Select count(*) from SOLandDoor where SODtlId = @SODtlId)
        Set @CarDoors = (Select count(*) from SOCarDoor where SODtlId = @SODtlId)

        --Select @OrdClientId, @Product, @LandingDoors, @CarDoors

        --DROP TABLE #JobOrderBOM;

        --CREATE TABLE #JobOrderBOM
        --(
        --    --JobOrderBOMId INT,
        --    SODtlId INT,
        --    SOHdrId INT,
        --    OrdClientHdrId INT,
        --    JobOrderId INT,

        --    ProductId INT,
        --    AssemblyHdrId INT,
        --    ItemId INT,
        --    ItemQty DECIMAL(18,2),   

        --    CreatedUserId INT,
        --    CreatedDate DATETIME
        --);

        --INSERT INTO #JobOrderBOM
        INSERT INTO JobOrderBOM
        SELECT
            @SODtlId,
            @SOHdrId,
            @JobOrderId,
            @OrdClientId,

            ProductId,
            AssemblyHdrId,
            ItemId,
            ItemQty,
            CreatedUserId,
            CreatedDate

        FROM BOMMst
        Where ProductId = @ProductId

        Select * from JobOrderBOM

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

         