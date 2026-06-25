USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSCR_ById]    Script Date: 25/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJOSCR_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJOSCR_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSCR_ById]    Script Date: 25/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJOSCR_ById]
(
	@JobOrderSCRHdrId int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @JobOrderSCRHdr   NVARCHAR(MAX)
DECLARE @JobOrderSCRDtl NVARCHAR(MAX)

DECLARE @TotJobOrderSCRHdr NVARCHAR(MAX)


 SET @JobOrderSCRHdr = (
      SELECT 
          [JobOrderSCRHdrId]
          ,[Pit]
          ,[Width]
          ,[Depth]

          ,[TravelHeight]
          ,[SpaceForMatlStatus]
          ,[Remarks]
          ,[SCRDocPath]
          ,[SCRDocName]

      FROM [dbo].[JobOrderSCRHdr]

      where JobOrderSCRHdrId = @JobOrderSCRHdrId

      FOR JSON PATH   
    )

    --Declare @JobOrderSCRHdrId int = 0

    --set @JobOrderSVRHdrId = (Select JobOrderSVRHdrId from JobOrderSVRHdr where JobOrderSCRHdrId = @JobOrderSCRHdrId)

    SET @JobOrderSCRDtl = (

        SELECT 
           [JobOrderSCRDtlId]
          ,[JobOrderSCRHdrld]

          ,[Floor]
          ,[LeftWall]
          ,[RightWall]
          ,[FFLMarking]

       FROM [dbo].[JobOrderSCRDtl]
      
        where JobOrderSCRHdrld = @JobOrderSCRHdrId

        FOR JSON PATH    
    )

    SET @TotJobOrderSCRHdr = (
        SELECT
            JSON_QUERY(@JobOrderSCRHdr)  AS JobOrderSCRHdr,
            JSON_QUERY(@JobOrderSCRDtl) AS JobOrderSCRDtl

        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

   Select @TotJobOrderSCRHdr

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

































































