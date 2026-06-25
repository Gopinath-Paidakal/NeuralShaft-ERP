USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderPTCDtl]    Script Date: 19/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertJobOrderPTCDtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertJobOrderPTCDtl]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderPTCDtl]    Script Date: 19/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertJobOrderPTCDtl]
(
    @JobOrderPTCDtl NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

    BEGIN TRANSACTION

    Declare @JobOrderPTCHdrId int

    INSERT INTO dbo.JobOrderPTCDtl
        (
            JobOrderSVRHdrId,
            Width,
            Depth,
            Pit,
            Ovehead,

            TravelHeight,
            MRP,
            CarDbg,
            CounterDbf,
            GuiderailCar,

            GuiderailCounter,
            CarTop,
            CarBottom,
            CouterTop,
            CounterBottom
        )
        SELECT
            JobOrderSVRHdrId,
            Width,
            Depth,
            Pit,
            Ovehead,

            TravelHeight,
            MRP,
            CarDbg,
            CounterDbf,
            GuiderailCar,
        
            GuiderailCounter,
            CarTop,
            CarBottom,
            CouterTop,
            CounterBottom

        FROM OPENJSON(@JobOrderPTCDtl, '$.JobOrderPTCDtl')
        WITH
        (
            JobOrderSVRHdrId INT,
            Width DECIMAL(18,2),
            Depth DECIMAL(18,2),
            Pit DECIMAL(18,2),
            Ovehead DECIMAL(18,2),

            TravelHeight DECIMAL(18,2),
            MRP DECIMAL(18,2),
            CarDbg DECIMAL(18,2),
            CounterDbf DECIMAL(18,2),
            GuiderailCar DECIMAL(18,2),
        
            GuiderailCounter DECIMAL(18,2),
            CarTop DECIMAL(18,2),
            CarBottom DECIMAL(18,2),
            CouterTop DECIMAL(18,2),
            CounterBottom DECIMAL(18,2)
        );
    
    
    set @JobOrderPTCHdrId = SCOPE_IDENTITY()

    select @JobOrderPTCHdrId

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



 --set @JobOrderPTCDtlId = SCOPE_IDENTITY()

        -------===============================================
        ------ Updating [SVRDocName] with id, path, filename
        --------===============================================
        --Update [JobOrderSVRDtl] set [JobOrderSVRDtl].SVRDocName = 
        --                            Convert(nvarchar(10),[JobOrderSVRDtl].JobOrderSVRDtlId) + '_' +
        --                            Convert(nvarchar(50),[JobOrderSVRDtl].SVRDocPath) + 
        --                            Convert(nvarchar(100),[JobOrderSVRDtl].SVRDocName)

        --Where [JobOrderSVRDtl].JobOrderSVRDtlId = @JobOrderSVRDtlId




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

         