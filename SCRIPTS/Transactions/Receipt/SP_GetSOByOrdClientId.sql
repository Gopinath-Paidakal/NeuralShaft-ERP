USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSOByOrdClientId]    Script Date: 05/08/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetSOByOrdClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetSOByOrdClientId]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetSOByOrdClientId]
(
	@OrdClientHdrId int
)

AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
	 
	--DROP TABLE IF EXISTS #ReceiptDtl;

	--CREATE TABLE #ReceiptDtl
	--	(
	--		--ReceiptDtlId      INT,
	--		--ReceiptHdId       INT,
	--		TableName         NVARCHAR(100),
	--		TableId           INT,
	--		OrdClientHdrId    INT,
	--		OrdClientName     NVARCHAR(200),
	--		DocNo             NVARCHAR(100),
	--		Type              NVARCHAR(50),
	--		OrderAmount       DECIMAL(18,2),
	--		DiscountAmount    DECIMAL(18,2),
	--		TaxAmount         DECIMAL(18,2),
	--		TotalAmount       DECIMAL(18,2),
	--		Paid              DECIMAL(18,2),
	--		Balance           DECIMAL(18,2),
	--		--CreatedUserId     INT,
	--		--CreatedDate       DATETIME,
	--		--ModifiedUserId    INT,
	--		--ModifiedDate      DATETIME
	--	);

	--   INSERT INTO [dbo].[#ReceiptDtl]
 --          (
	--	   --[ReceiptHdId]
 --           [TableName]
 --          ,[TableId]
 --          ,[OrdClientHdrId]
 --          ,[OrdClientName]
 --          ,[DocNo]

 --          ,[Type]
 --          ,[OrderAmount]
 --          ,[DiscountAmount]
 --          ,[TaxAmount]
	--	   ,[TotalAmount]

 --          ,[Paid]
 --          ,[Balance])

	   SELECT * FROM
		(
		   SELECT 

			'SOHDr' as 'TableName',
			SoHdrId as 'TableId',
			OrdClientHdr.OrdClientHdrId,
			OrdClientHdr.OrdClientName,
			SOHSlNo as 'DocNo',

			SOHType as 'Type',
			OrdSubTotal as 'OrderAmount',
			--0 as 'DiscountAmount',
			OrdTax as 'GSTAmount',
			OrdTotalAmount as 'TotalAmount',

			OrdPayments as 'Paid',
			(OrdTotalAmount - OrdPayments) as 'Balance'

			from SOHDr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = SOHDr.OrdClientHdrId
			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId 
				  and OrdTotalAmount > 0

			union all

			select 
				'QuoteSOItemHdr' as 'TableName',
				QuoteSOItemHdrId as 'TableId',
				OrdClientHdr.OrdClientHdrId,
				OrdClientHdr.OrdClientName,
				QuoteSOItemSlNo  as 'DocNo',
				
				QuoteSOItemType as 'Type',
				QuoteSOItemAmount as 'OrderAmount', 
				--QuoteSOItemDiscountAmount as 'DiscountAmount', 
				QuoteSOItemTaxAmount 'GSTAmount',
				QuoteSOItemTotalAmount,

				OrderSOItemPayments as 'Paid',  
				(QuoteSOItemTotalAmount - OrderSOItemPayments)  as 'Balance'

			from QuoteSOItemHdr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOItemHdr.OrdClientHdrId
			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId 
					and QuoteSOItemTotalAmount > 0

			union all

			select 
				'QuoteSOAMCHdr' as 'TableName',
				QuoteSOAMCHdrId as 'TableId',
				OrdClientHdr.OrdClientHdrId,
				OrdClientHdr.OrdClientName,
				QuoteSOAMCSlNo as 'DocNo',

				QuoteSOAMCType as 'Type',
				QuoteSOAMCAmount as 'OrderAmount', 
				--QuoteSOAMCDiscountAmount as 'DiscountAmount', 
				QuoteSOAMCTaxAmount 'GSTAmount',
				QuoteSOAMCTotalAmount,

				OrderSOAMCPayments as 'Paid',
				(QuoteSOAMCTotalAmount - OrderSOAMCPayments) as 'Balance'

			from QuoteSOAMCHdr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOAMCHdr.OrdClientHdrId
			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId 
				  and QuoteSOAMCTotalAmount > 0

			) SOData

			FOR JSON PATH, ROOT('ReceiptDtl');
			
			--SELECT *
			--	FROM #ReceiptDtl		
			--	FOR JSON PATH, ROOT('ReceiptDtl');

			--drop table #ReceiptDtl

	COMMIT TRANSACTION
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

 --,[CreatedUserId]
 --     ,[CreatedDate]
 --     ,[ModifiedUserId]
 --     ,[ModifiedDate]

 	--DECLARE @ReceiptDtl         NVARCHAR(MAX)
		--	DECLARE @ReceiptHdrDtl         NVARCHAR(MAX)

		--	SET @ReceiptDtl = (
		--		Select * from ReceiptDtl

		--		FOR JSON PATH
		--	)

		--	 SET @ReceiptHdrDtl = (
  --      SELECT
  --          --JSON_QUERY(@ReceiptHdr)  AS  ReceiptHdr,
  --          JSON_QUERY(@ReceiptDtl) AS  ReceiptDtl


  			--Payments


		
            
        --FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
   -- )

			--FOR JSON PATH, ROOT('OrdClientPayments')  -- ROOT WITHOUT_ARRAY_WRAPPER

