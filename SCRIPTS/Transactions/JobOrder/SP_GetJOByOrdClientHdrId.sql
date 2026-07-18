USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOByOrdClientHdrId]    Script Date: 01/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJOByOrdClientHdrId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJOByOrdClientHdrId]

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOByOrdClientHdrId]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJOByOrdClientHdrId]
(
	@OrdClientHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY

DECLARE @OrdClientHdr   NVARCHAR(MAX)
DECLARE @OrdClientAddr  NVARCHAR(MAX)
DECLARE @JobOrderDtl    NVARCHAR(MAX)
DECLARE @JobOrderNos    NVARCHAR(MAX)
 
DECLARE @SOHDrId Int

set @SOHDrId = (select SOHDrId from SOHdr where OrdClientHdrId = @OrdClientHdrId)

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

 SET @JobOrderDtl = (

       SELECT 
            [JobOrder].SOHdrId,
            [JobOrder].JobOrderNo

       FROM [dbo].[JobOrder]
       where SOHdrId = @SOHDrId

        FOR JSON PATH   
    )


      SET @JobOrderNos = (
        SELECT
            JSON_QUERY(@OrdClientHdr)  AS OrdClientHdr,
            JSON_QUERY(@OrdClientAddr) AS OrdClientAddr,
            JSON_QUERY(@JobOrderDtl)   AS JobOrderDtl
            --JSON_QUERY(@SODtl) AS SODtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @JobOrderNos

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

































































