USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAssyHdr]    Script Date: 03/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAssyHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetAssyHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAssyHdr]    Script Date: 03/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetAssyHdr]
--(
--	@AssemblyHdrId int = 0 
--)
--With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	DECLARE @AssemblyHdr   NVARCHAR(MAX)
	--DECLARE @AssemblyItem NVARCHAR(MAX)
	DECLARE @TotAssembly NVARCHAR(MAX)
	
	 SET @AssemblyHdr = (
       
      SELECT [AssemblyHdrId]
              ,[AssemblyName]
              ,[UOM]
              ,[AssemblyQty]
              --,[CreatedUserId]
              --,[CreatedDate]
        FROM [dbo].[AssemblyHdr]

       --where AssemblyHdrId = @AssemblyHdrId

        FOR JSON PATH   
    )

  --  SET @AssemblyItem = (
  
  --    SELECT [AssemblyItemId]
		--	  ,[AssemblyHdrId]
		--	  ,[Item].[ItemId]
		--	  ,[Item].[ItemName]
		--	  ,[DefaultData].[DefaultDataName] as 'UOM'
		--	  ,[ItemQty]
		--	  --,[CreatedUserId]
		--	  --,[CreatedDate]

		--FROM [dbo].[AssemblyItem]
		--INNER JOIN [Item] On [Item].[ItemId] = [AssemblyItem].[ItemId]
		--INNER JOIN [DefaultData] ON [DefaultData].DefaultDataId = [Item].[UomId]

  --      where AssemblyHdrId = @AssemblyHdrId

  --      FOR JSON PATH   
  --      )

	 SET @TotAssembly = (
        SELECT
            JSON_QUERY(@AssemblyHdr)  AS AssemblyHdr
            --JSON_QUERY(@AssemblyItem) AS AssemblyItem
        FOR JSON PATH,  WITHOUT_ARRAY_WRAPPER
    )

   Select @TotAssembly


		

			
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


	




