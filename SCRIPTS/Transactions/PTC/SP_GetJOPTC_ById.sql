USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOPTC_ById]    Script Date: 20/06/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJOPTC_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetJOPTC_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOPTC_ById]    Script Date: 20/06/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetJOPTC_ById]
(
	@JobOrderPTCDtlId int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY

DECLARE @JobOrderPTCDtl NVARCHAR(MAX)

 SET @JobOrderPTCDtl = (

     SELECT 
       [JobOrderPTCDtlId]
      --,[JobOrderSVRHdrId]
      ,[Width]
      ,[Depth]
      ,[Pit]

      ,[Ovehead]
      ,[TravelHeight]
      ,[MRP]
      ,[CarDbg]
      ,[CounterDbf]

      ,[GuiderailCar]
      ,[GuiderailCounter]
      ,[CarTop]
      ,[CarBottom]
      ,[CouterTop]

      ,[CounterBottom]

      FROM [dbo].[JobOrderPTCDtl]   

      where JobOrderPTCDtlId = @JobOrderPTCDtlId

      FOR JSON PATH, ROOT('JobOrderPTCDtl'));

    Select @JobOrderPTCDtl

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

































































