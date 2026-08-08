USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMPLById]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetMPLById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetMPLById]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetMPLById]
(
	@MPLHdrId int
)
----With Encryption
AS

SET NOCOUNT ON;

DECLARE @MPLHdrDtl         NVARCHAR(MAX)
DECLARE @MPLHdr            NVARCHAR(MAX)
DECLARE @MPLDtl            NVARCHAR(MAX)

Declare @JobOrderId int
Declare @ProductId int 


BEGIN TRY

        --set @JobOrderId = JSON_VALUE(@MPLHdr, '$.MPLHdr.JobOrderId')
		set @JobOrderId = (Select JobOrderId from MPLHdr where MPLHdrId = @MPLHdrId)

		set @ProductId = (SELECT SODtl.DDProductId
							FROM MPLHdr
							INNER JOIN joborder on joborder.joborderid = MPLHdr.JobOrderId
							INNER JOIN SODtl ON SODtl.SODtlId = JobOrder.SODtlId
							WHERE MPLHdr.JobOrderId = @JobOrderId)

	    SET @MPLHdr = (
            SELECT [MPLHdrId]
            ,[JobOrder].[JobOrderId]
            ,[JobOrder].[JobOrderNo]
            ,[JobOrder].[JobOrderCustComp]

            ,[SODtl].[NoStopDetails]
            ,[SODtl].[FloorDetails]
             
            ,[MPLStage]
            ,[MPLNo]
            ,[MPLDate]
            ,[MPLStatus]

        FROM [dbo].[MPLHdr]

        INNER JOIN [JobOrder] ON [JobOrder].JobOrderId = [MPLHdr].JobOrderId
        INNER JOIN [SoDtl] ON [SODtl].SODtlId = [JobOrder].SODtlId

        WHERE MPLHdrId = @MPLHdrId

        FOR JSON PATH
    )

    SET @MPLDtl = (

     SELECT
          MPLDtl.MPLDtlId,
          MPLDtl.ProductId,

          AssemblyHdr.AssemblyHdrId,
          AssemblyHdr.AssemblyName,

          Item.ItemId,
          Item.ItemType,
          
          Item.ItemName,
          DefaultData.DefaultDataName AS UOM,
          Item.ItemLength,

          MPLDtl.ItemReqdQty,
          MPLDtl.ItemTotalQty,
          Item.ItemStockQty

	    FROM MPLDtl

		LEFT JOIN AssemblyHdr ON AssemblyHdr.AssemblyHdrId = MPLDtl.AssemblyHdrId
		LEFT JOIN Item on Item.ItemId = MPLDtl.ItemId

		LEFT JOIN DefaultData ON DefaultData.DefaultDataId = Item.UomId

		WHERE MPLDtl.ProductId = @ProductId
    
        FOR JSON PATH    
    )
   

    SET @MPLHdrDtl = (
        SELECT
            JSON_QUERY(@MPLHdr)  AS MPLHdr,
            JSON_QUERY(@MPLDtl) AS  MPLDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @MPLHdrDtl
	
			
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

  -- SELECT
  --        MPLDtl.MPLDtlId,
  --        MPLDtl.ProductId,

  --        AssemblyHdr.AssemblyHdrId,
  --        AssemblyHdr.AssemblyName,

  --        Item.ItemId,
  --        Item.ItemType,

  --        CASE
  --             WHEN MPLDtl.AssemblyHdrId IS NULL
  --                  THEN MPLDtl.ItemQty
  --             ELSE AssemblyItem.ItemQty
  --        END AS ItemQty,

  --        Item.ItemName,
  --        DefaultData.DefaultDataName AS UOM,
  --        Item.ItemLength,

  --        MPLDtl.ItemReqdQty,
  --        MPLDtl.ItemTotalQty,
  --        MPLDTl.ItemStockQty

	 --   FROM MPLDtl

		--LEFT JOIN AssemblyHdr ON AssemblyHdr.AssemblyHdrId = MPLDtl.AssemblyHdrId
		--LEFT JOIN AssemblyItem ON AssemblyItem.AssemblyHdrId = AssemblyHdr.AssemblyHdrId
		--LEFT JOIN Item
		--		ON Item.ItemId =
		--			CASE
		--				WHEN MPLDtl.AssemblyHdrId IS NULL
		--					THEN MPLDtl.ItemId
		--				ELSE AssemblyItem.ItemId
		--			END

		--LEFT JOIN DefaultData ON DefaultData.DefaultDataId = Item.UomId

		--WHERE MPLDtl.ProductId = @ProductId

	 --   FOR JSON PATH)



 --      SELECT [MPLDtlId]
    --          ,[MPLHdrId]
    --          ,[SODtlId]
    --          ,[JobOrderId]
    --          ,[ProductId]
    --          ,[AssemblyHdrId]
    --          ,[ItemId]
    --          ,[ItemQty]
    --          ,[ItemReqdQty]
    --          ,[ItemTotalQty]
    --          ,[ItemStockQty]

    --          --,[CreatedUserId]
    --          --,[CreatedDate]

    --      FROM [dbo].[MPLDtl]

    --    WHERE MPLHdrId = @MPLHdrId

    --    FOR JSON PATH    
    --)


	




