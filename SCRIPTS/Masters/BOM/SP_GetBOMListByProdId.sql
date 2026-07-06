USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetBOMListByProdId]    Script Date: 05/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBOMListByProdId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetBOMListByProdId]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetBOMListByProdId]    Script Date: 05/05/2026  ******/
SET ANSI_NULLS ON
	GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetBOMListByProdId]
(
	@ProductId int

)
--With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	--BEGIN TRANSACTION

SELECT
(
	SELECT [BOMMstId]
	  --,[BOMMstType]
      ,[ProductId]
      ,[AssemblyHdr].[AssemblyHdrId]
      ,[AssemblyHdr].[AssemblyName]

      ,[Item].[ItemId]
      ,[AssemblyItem].[ItemQty]
      
	  ,[Item].[ItemName]
      ,[DefaultData].[DefaultDataName] as 'UOM'
      
	  FROM [dbo].[BOMMst]
	  INNER JOIN [AssemblyHdr] On [AssemblyHdr].[AssemblyHdrId] = [BOMMst].[AssemblyHdrId]
	  INNER JOIN [AssemblyItem] On [AssemblyItem].[AssemblyHdrId] = [AssemblyHdr].[AssemblyHdrId]
	  INNER JOIN [Item] On [Item].[ItemId] = [AssemblyItem].[ItemId]
	  INNER JOIN [DefaultData] ON [DefaultData].DefaultDataId = [Item].[UomId]

	  Where [BOMMst].ProductId = @ProductId

	  FOR JSON PATH, ROOT('BOMListByProdId')

)BOMListByProdId

	--COMMIT TRANSACTION
END TRY

	BEGIN CATCH
		--ROLLBACK TRANSACTION
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

--,[AssemblyHdrId]
      --,[ItemId]
      --,[ItemQty]
      --,[CreatedUserId]
      --,[CreatedDate]


--SELECT 
 --     B.BOMId,
 --     B.ParentItemId,
	--  P1.ItemType AS ParentItemType,
 --     P1.ItemName AS ParentItemName,
	--  --B.ItemQty,
   

 --     B.ChildItemId,
	  
	--  P2.ItemType AS ChildItemType,
 --     P2.ItemName AS ChildItemName,

 --     --B.ItemType,
 --     B.UOM

	--FROM dbo.BOM B

	--INNER JOIN [Item] P1 ON P1.ItemId = B.ParentItemId
	--INNER JOIN [Item] P2 ON P2.ItemId = B.ChildItemId

	--FOR JSON PATH, ROOT('BOM')


--SELECT 
	--  [BOM].[BOMId]
 --    ,[BOM].[ParentItemId]
 --    ,[BOM].[ChildItemId]
	-- ,[BOM].[ItemType]
	-- ,[BOM].[UOM]
      
 --    ,[Itemuct].ItemName 
	-- --,[Itemuct].ItemType
	  
      
 -- FROM [dbo].[BOM]
 -- inner join [Itemuct] ON [Itemuct].ItemId = [BOM].ParentItemId 

 -- union all

 -- SELECT   
	--  [BOM].[BOMId]
 --    ,[BOM].[ParentItemId]
 --    ,[BOM].[ChildItemId]
	-- ,[BOM].[ItemType]
	-- ,[BOM].[UOM]

 --    ,[Itemuct].ItemName 
	---- ,[Itemuct].ItemType 
	  
      
 -- FROM [dbo].[BOM]
 -- inner join [Itemuct] ON [Itemuct].ItemId = [BOM].ChildItemId