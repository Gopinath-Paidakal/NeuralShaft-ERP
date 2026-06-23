USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderSVR]    Script Date: 19/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertJobOrderSVR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertJobOrderSVR]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertJobOrderSVR]    Script Date: 19/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertJobOrderSVR]
(
    @JobOrderSVR NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION

    Declare @JobOrderSVRHdrId int
    Declare @JobOrderSVRDtlId int

    INSERT INTO JobOrderSVRHdr
        (
            JobOrderId,
            SODtlId,
            DrgSubmittedTo,
            PhoneNumber,
            DrgStatus,
            NextDate,

            Progress,
            Lattitude,
            Longitude,
            CreatedUserId,
            CreatedDate
        )
        SELECT
            JobOrderId,
            SODtlId,
            DrgSubmittedTo,
            PhoneNumber,
            DrgStatus,
            NextDate,

            Progress,
            Lattitude,
            Longitude,
            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@JobOrderSVR,'$.JobOrderSVR')
        WITH
        (
            JobOrderId INT,
            SODtlId INT,
            DrgSubmittedTo NVARCHAR(200),
            PhoneNumber NVARCHAR(50),
            DrgStatus NVARCHAR(100),
            NextDate DATETIME,
            Progress NVARCHAR(100),
            Lattitude NVARCHAR(50),
            Longitude NVARCHAR(50),
            CreatedUserId INT,
            CreatedDate DATETIME
        );
    
    set @JobOrderSVRHdrId = SCOPE_IDENTITY()

    INSERT INTO JobOrderSVRDtl
        (
            JobOrderSVRHdrId,
            [Description],
            [Status],
            Remarks,
            FFLMarking,
            SVRDocPath,
            SVRDocName
            
        )
        SELECT
            @JobOrderSVRHdrId,
            [Description],
            [Status],
            Remarks,
            FFLMarking,
            '/uploads/svr/',
            SVRDocName

        FROM OPENJSON(@JobOrderSVR,'$.SVRDetails')
        WITH
        (
            Description NVARCHAR(MAX),
            Status NVARCHAR(100),
            Remarks NVARCHAR(MAX),
            FFLMarking NVARCHAR(50),
            SVRDocName NVARCHAR(100),
            CreatedUserId INT,
            CreatedDate DATETIME
        );

    select @JobOrderSVRHdrId

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



 --set @JobOrderSVRDtlId = SCOPE_IDENTITY()

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

         