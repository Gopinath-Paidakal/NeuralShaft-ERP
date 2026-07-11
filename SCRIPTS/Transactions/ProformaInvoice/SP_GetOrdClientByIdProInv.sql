USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetOrdClientByIdProInv]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetOrdClientByIdProInv]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetOrdClientByIdProInv]
(
    @OrdClientHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @OrdClientHdr   NVARCHAR(MAX)
DECLARE @OrdClientAddr  NVARCHAR(MAX)
DECLARE @SOHdr NVARCHAR(MAX)
--DECLARE @SODtl NVARCHAR(MAX)
DECLARE @ProformaInv NVARCHAR(MAX)
BEGIN TRY

    
    SET @OrdClientHdr = (
        SELECT

            OrdClientHdrId,
            ISNULL(OrdConsultant,   '') AS OrdConsultant,
            OrdClientTitle +  ' ' + OrdClientName as  'OrdClientName',
            --ISNULL(OrdClientTitle,  '') AS OrdClientTitle,

            ISNULL(OrdGstTradeName, '') AS OrdGstTradeName,
            ISNULL(OrdGstNo,        '') AS OrdGstNo,
            ISNULL(OrdClientStatus, '') AS OrdClientStatus

        FROM dbo.OrdClientHdr
        WHERE OrdClientHdrId = @OrdClientHdrId
        FOR JSON PATH
    )

    SET @OrdClientAddr = (
        SELECT
            ISNULL(OrdClientHdrId,          0) AS OrdClientHdrId,
            ISNULL(OrdClientAddrId,         0) AS OrdClientAddrId,
            ISNULL(OrdClientAddr1,         '') AS OrdClientAddr1,
            ISNULL(OrdClientAddr2,         '') AS OrdClientAddr2,
            ISNULL(OrdClientPostalCode,    '') AS OrdClientPostalCode,
            ISNULL(OrdClientState,         '') AS OrdClientState,

            ISNULL(OrdClientCity,          '') AS OrdClientCity,
            ISNULL(OrdClientPhNo,          '') AS OrdClientPhNo,
            ISNULL(OrdClientCompanyMailId, '') AS OrdClientCompanyMailId,
            ISNULL(OrdClientWebsite,       '') AS OrdClientWebsite,
            --ISNULL(OrdClientPan,           '') AS OrdClientPan,

            ISNULL(OrdClientGstNo,         '') AS OrdClientGstNo,
            ISNULL(OrdClientAdhaarNo,      '') AS OrdClientAdhaarNo,
            ISNULL(OrdClientAddrType,      '') AS OrdClientAddrType,
            --ISNULL(OrdClientPriSalutation, '') AS OrdClientPriSalutation,
            ISNULL(OrdClientPriContPerson, '') AS OrdClientPriContPerson,

            ISNULL(OrdClientPriMailId,     '') AS OrdClientPriMailId,
            ISNULL(OrdClientPriMobileNo,   '') AS OrdClientPriMobileNo
            --ISNULL(OrdClientSecSalutation, '') AS OrdClientSecSalutation,
            --ISNULL(OrdClientSecContPerson, '') AS OrdClientSecContPerson,
            --ISNULL(OrdClientSecMailId,     '') AS OrdClientSecMailId,

            --ISNULL(OrdClientSecMobileNo,   '') AS OrdClientSecMobileNo,
            --ISNULL(OrdClientLatitude,      '') AS OrdClientLatitude,
            --ISNULL(OrdClientLongitude,     '') AS OrdClientLongitude,
            --ISNULL(OrdClientTravelDistance,'') AS OrdClientTravelDistance,
            --ISNULL(OrdStatus,              '') AS OrdStatus


        FROM dbo.OrdClientAddr
        WHERE OrdClientHdrId = @OrdClientHdrId
        FOR JSON PATH    ----WITHOUT_ARRAY_WRAPPER
    )

    SET @SOHdr = (
        SELECT [SOHdrId]
              
              ,[SOHNo]
              ,[SOHSlNo]
              ,[SOHDate]

              ,[SOConsultant]
              ,[SOCustComp],
              
              [QuoteHdr].QuoteHdrId,
              [QuoteHdr].QuoteNo


        FROM dbo.SOHdr
        INNER JOIN [QuoteHdr] On [QuoteHdr].QuoteHdrId = [SOHdr].QuoteHdrId
        WHERE OrdClientHdrId = @OrdClientHdrId
        FOR JSON PATH
    )

    --SET @SODtl = (
    --  SELECT [SODtlId]
    --          --,[SOHdrId]
    --          --,[EnqHdrId]
    --          --,[EnqDtlId]
    --          --,[QuoteHdrId]
    --          --,[TaxId]
    --          --,[DDProductId]
    --          --,[ShaftType]
    --          --,[ShaftWidth]
    --          --,[ShaftDepth]
    --          --,[OverheadHeight]
    --          --,[ElevatorPit]
    --          --,[ElevatorSpeed]
    --          ,[SOProduct]
    --          ,[NoOfPassengers]
    --          ,[SOProductType]
    --          ,[Capacity]
    --          ,[TotalFloors]
    --          ,[FloorDetails]
    --          --,[NoStop]
    --          --,[NoStopDetails]
    --          --,[TotalStops]
    --          --,[NoOfOpenings]
    --          --,[PriceLess]
    --          --,[ApproxFloorHeight]
    --          --,[DoorOpening]
    --          --,[DoorFinish]
    --          --,[DoorWidth]
    --          --,[DoorHeight]
    --          --,[DoubleEntrance]
    --          --,[DoubleEntranceType]
    --          --,[DoubleEntranceTypeDetails]
    --          --,[NoOfDoorOpenings]
    --          --,[EnqCabinType]
    --          --,[CabinWidth]
    --          --,[CabinDepth]
    --          --,[CabinHeight]
    --          --,[FlooringType]
    --          --,[Handrail]
    --          --,[CarDoorOpening]
    --          --,[CarDoorFinish]
    --          --,[CarDoorWidth]
    --          --,[CarDoorHeight]
    --          --,[ProductAmount]
    --          --,[FloorNameAmount]
    --          --,[DoorTypeAmount]
    --          --,[CarDoorTypeAmount]
    --          --,[DoorFinishAmount]
    --          --,[CabinTypeAmount]
    --          --,[FlooringTypeAmount]
    --          --,[AddnlFeatureAmount]
    --          --,[PowerSupply]
    --          --,[Machine]
    --          --,[Drive]
    --          --,[Controller]
    --          --,[Operation]
    --          --,[GuideRails]
    --          --,[Rope]
    --          --,[SOProdSplFeature]
    --          --,[SOFalseCeilingType]
    --          --,[GST]
    --          --,[HSNCode]
    --          ,[SOQty]
    --          ,[SORate]
    --          ,[SOProductAmount]
    --          --,[IncreasePercentage]
    --          --,[IncreaseAmount]
    --          ,[DiscountPercentage]
    --          ,[DiscountAmount]
    --          --,[TaxableValue]
    --          --,[TaxableCashAmount]
    --          --,[TaxableChequeAmount]
    --          --,[AMCPercentage]
    --          --,[AMCAmount]
    --          ,[SOSubTotal]
    --          ,[SOTaxAmount]
    --          ,[SOTotalAmount]
    --          ,[SOGrandTotal]
    --          --,[Deleted]
    --          --,[CustomerStatus]
    --          --,[OrderStatus]
    --          --,[ApprovalStatus1]
    --          --,[ApprovalStatus2]
    --          --,[PassengerAmount]
    --      FROM [dbo].[SoDtl]
            
    --        INNER JOIN dbo.SOHdr ON SOHdr.SOHdrId = SODtl.SOHdrId
    --        WHERE SOHdr.OrdClientHdrId = @OrdClientHdrId
    --    FOR JSON PATH
    --)


    SET @ProformaInv = (
        SELECT
            JSON_QUERY(@OrdClientHdr)  AS OrdClientHdr,
            JSON_QUERY(@OrdClientAddr) AS OrdClientAddr,
            JSON_QUERY(@SOHdr) AS SOHdr
            --JSON_QUERY(@SODtl) AS SODtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @ProformaInv

END TRY
BEGIN CATCH
    DECLARE
        @ErrMsg       VARCHAR(4000),
        @ErrSeverity  INT,
        @ErrProcedure VARCHAR(100)
    SET @ErrMsg       = ERROR_MESSAGE()
    SET @ErrSeverity  = ERROR_SEVERITY()
    SET @ErrProcedure = ERROR_PROCEDURE()
    SET @ErrMsg       = @ErrMsg + ' / ' + ISNULL(@ErrProcedure, '')
    RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


--,[CompanyId]
              --,[BranchId]
              --,[EnqHdrId]
              --,[QuoteHdrId]
              --,[OrdClientHdrId]
              --,[OrdClientAddrId]
  --,[SOBillingAddr]
              --,[SOContPerson]
              --,[SOMobileNo]
              --,[ProjectName]
              --,[ExpectedClosingDate]
              --,[SOEmailId]
              --,[DeliveryBy]
              --,[QuoteValidity]
              --,[ComplementaryAMC]
              --,[GSTExempted]
              --,[SOPaymentTerms]
              --,[OrdAmount]
              --,[OrdSubTotal]
              --,[OrdTax]
              --,[OrdTotalAmount]
              --,[OrdAdvance]
              --,[OrdPayments]
              --,[OrdStatus]
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]
