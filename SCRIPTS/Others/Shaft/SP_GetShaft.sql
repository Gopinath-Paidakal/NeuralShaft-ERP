USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_Shaft]    Script Date: 18/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Shaft]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Shaft]
GO

USE [NSHAFTERPDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_Shaft]    Script Date: 18/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Shaft]
--(
--	@EnquiryId int

--)
With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	SELECT
(
  SELECT [EnqShaftId]
      ,[EnquiryId]
      ,[ShaftType]
      ,[ShaftWidth]
      ,[ShaftDepth]
      ,[EnqProduct]
      ,[EnqProductType]
      ,[Capacity]
      ,[TotalFloors]
      ,[ElevatorSpeed]
  FROM [dbo].[EnqShaft]
  
  FOR JSON PATH, ROOT('Shaft')  -- ROOT WITHOUT_ARRAY_WRAPPER
) AS Shaft

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


  --FROM [dbo].[Enquiry]
	--INNER JOIN EnqClient ON Enquiry.EnquiryId = EnqClient.EnquiryId 
    --WHERE EnquiryId = @EnquiryId