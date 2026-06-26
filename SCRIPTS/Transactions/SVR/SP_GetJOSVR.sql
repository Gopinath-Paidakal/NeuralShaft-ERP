USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSVR]    Script Date: 20/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJOSVR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJOSVR]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSVR]    Script Date: 20/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJOSVR]
(
	@FromDate nvarchar(20),
	@ToDate nvarchar(20)
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @JobOrderSVR   NVARCHAR(MAX)

 SET @JobOrderSVR = (
    SELECT
        JobOrder.JobOrderId,

        JobOrder.SODtlId,
        JobOrder.JobOrderNo,
        
        JobOrder.JobOrderCustComp,
        JobOrder.JobOrderContPerson,
        JobOrder.JobOrderMobileNo,
        
        JobOrderSVRHdr.CreatedDate AS SVRCreatedDate,
        --JobOrderSVRHdr.SiteReady,
        JobOrderSVRHdr.JobOrderSVRHdrId

    FROM dbo.JobOrder

    INNER JOIN dbo.JobOrderSVRHdr
        ON dbo.JobOrderSVRHdr.JobOrderId = dbo.JobOrder.JobOrderId
    WHERE dbo.JobOrderSVRHdr.JobOrderId = JobOrder.JobOrderId
    
    and JobOrderSVRHdr.[CreatedDate] >= @FromDate AND JobOrderSVRHdr.[CreatedDate] < DATEADD(DAY, 1, @ToDate)

    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
);

SELECT @JobOrderSVR 

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

 --Declare @JobOrderSVRHdrId int = 0

    --set @JobOrderSVRHdrId = (Select JobOrderSVRHdrId from JobOrderSVRHdr where SODtlId = @SoDtlId)

    --SET @JobOrderSVRDtl = (
    --   SELECT [JobOrderSVRDtlId]
    --      ,[JobOrderSVRHdrId]
    --      ,[Description]
    --      ,[Status]
    --      ,[Remarks]

    --      ,[FFLMarking]
    --      ,[SVRDocPath]
    --      ,[SVRDocName]
    --      ,[CreatedUserId]
    --      ,[CreatedDate]

    --    FROM [dbo].[JobOrderSVRDtl]
    --    where JobOrderSVRHdrId = @JobOrderSVRHdrId

    --    FOR JSON PATH    
    --)

































































