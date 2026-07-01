USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSVR_ById]    Script Date: 01/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteItemDtl_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_GetQuoteItemDtl_ById
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetJOSVR_ById]    Script Date: 01/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].SP_GetQuoteItemDtl_ById
(
	@quoteItemHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @QuoteItemDtl   NVARCHAR(MAX)
 --DECLARE @Item_QuoteHdrId NVARCHAR(MAX)
--DECLARE @JobOrderPending NVARCHAR(MAX)
--DECLARE @TotJobOrderPending NVARCHAR(MAX)

--DECLARE @TotJobOrderSVR NVARCHAR(MAX)
--DECLARE @JobOrderId int

--set @JobOrderId = (select JobOrderId from JobOrderSVRHdr where JobOrderSVRHdrId = @JobOrderSVRHdrId)

 SET @QuoteItemDtl = (
       
       SELECT 
       
           [QuoteItemDtlId]
          ,[ItemQuoteHdrId]
          ,[ItemId]
          ,[ItemName]
          
          ,[ItemHSNCode]
          ,[ItemDesc]
          ,[ItemQuantity]
          ,[ItemRate]

          ,[ItemAmount]
          ,[ItemTaxValue]
          ,[ItemDiscountAmount]
          ,[ItemDiscountPercentage]
          ,[ItemTotalAmount]

          

       FROM [dbo].[QuoteDtlItem]
       where ItemQuoteHdrId = @quoteItemHdrId

        FOR JSON PATH   
    )



   Select @QuoteItemDtl

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

































































