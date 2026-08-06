USE [NSERPLIVE]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetReceiptById]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetReceiptById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetReceiptById]
(
    @ReceiptHdrId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @ReceiptHdr         NVARCHAR(MAX)
DECLARE @ReceiptDtl         NVARCHAR(MAX)
DECLARE @ReceiptHdrDtl      NVARCHAR(MAX)

BEGIN TRY

	Declare @OrdClientHdrId int

	SET @OrdClientHdrId = (Select OrdClientHdrId from ReceiptHdr where ReceiptHdrId = @ReceiptHdrId)
    
    SET @ReceiptHdr = (
      
        SELECT [ReceiptHdrId]
			  --,[CompanyId]
			  --,[BranchId]
			  ,[OrdClientHdrId]
			  ,[ReceiptNo]
			  ,[ReceiptDate]

			  ,[PaymentType]
			  ,[ChequeDeposited]
			  ,[BankName]
			  ,[ChequeNo]
			  ,[ChequeAmount]
			  ,[ChequeStatus]
			  ,[PaymentDetails]
			  ,[Amount]
			  ,[TotalAmount]
     
			FROM [dbo].[ReceiptHdr]
			

        WHERE ReceiptHdrId = @ReceiptHdrId
        FOR JSON PATH
    )

    SET @ReceiptDtl = (

			SELECT [ReceiptDtlId]
			  ,[ReceiptHdrId]
			  ,[TableName]
			  ,[TableId]
			  ,[OrdClientHdrId]

			  ,[OrdClientName]
			  ,[DocNo]
			  ,[Type]
			  ,[OrderAmount]
			  ,[DiscountAmount]
			  
			  ,[TaxAmount]
			  ,[TotalAmount]
			  ,[Paid]
			  --,[Balance]
			  ,[TotalAmount]-[Paid] as 'Balance'

			  --,[CreatedUserId]
			  --,[CreatedDate]

			  --,[ModifiedUserId]
			  --,[ModifiedDate]
		  FROM [dbo].[ReceiptDtl]
		  WHERE ReceiptHdrId = @ReceiptHdrId
		
        FOR JSON PATH    
    )

    SET @ReceiptHdrDtl = (
        SELECT
            JSON_QUERY(@ReceiptHdr)  AS  ReceiptHdr,
            JSON_QUERY(@ReceiptDtl) AS  ReceiptDtl
            
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )

    Select @ReceiptHdrDtl

END TRY

BEGIN CATCH
    DECLARE
        @ErrMsg       VARCHAR(4000),
        @ErrSeverity  INT,
        @ErrProcedure VARCHAR(100)
    SET @ErrMsg       = ERROR_MESSAGE()
    SET @ErrSeverity  = ERROR_SEVERITY()
    SET @ErrProcedure = ERROR_PROCEDURE()
    SET @ErrMsg       = @ErrMsg + ' / ' + ISNULL(@ErrProcedure, '')
    RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH



  --       SELECT *
		--	FROM
		--(
		--   SELECT 

		--	'SOHDr' as 'Table',
		--	SoHdrId as 'Id',
		--	OrdClientHdr.OrdClientHdrId,
		--	OrdClientHdr.OrdClientName,
		--	SOHSlNo as 'DocNo',

		--	SOHType as 'Type',
		--	OrdSubTotal as 'Order Amount',
		--	0 as 'DiscountAmount',
		--	OrdTax as 'GST Amount',
		--	OrdTotalAmount as 'Total Amount',

		--	OrdPayments as 'Paid',
		--	(OrdTotalAmount - OrdPayments) as 'Balance'

		--	from SOHDr 
		--	inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = SOHDr.OrdClientHdrId

		--	where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId --and OrdTotalAmount > 0

		--	union all

		--	select 
		--		'QuoteSOItemHdr' as 'Table',
		--		QuoteSOItemHdrId as 'Id',
		--		OrdClientHdr.OrdClientHdrId,
		--		OrdClientHdr.OrdClientName,
		--		QuoteSOItemSlNo  as 'DocNo',
				
		--		QuoteSOItemType as 'Type',
		--		QuoteSOItemAmount as 'Order Amount', 
		--		QuoteSOItemDiscountAmount as 'DiscountAmount', 
		--		QuoteSOItemTaxAmount 'GST Amount',
		--		QuoteSOItemTotalAmount,

		--		OrderSOItemPayments as 'Paid',  
		--		(QuoteSOItemTotalAmount - OrderSOItemPayments)  as 'Balance'

		--	from QuoteSOItemHdr 
		--	inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOItemHdr.OrdClientHdrId
		--	where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId ---and QuoteSOItemTotalAmount > 0

		--	union all

		--	select 
		--		'QuoteSOAMCHdr' as 'Table',
		--		QuoteSOAMCHdrId as 'Id',
		--		OrdClientHdr.OrdClientHdrId,
		--		OrdClientHdr.OrdClientName,
		--		QuoteSOAMCSlNo as 'DocNo',

		--		QuoteSOAMCType as 'Type',
		--		QuoteSOAMCAmount as 'Order Amount', 
		--		QuoteSOAMCDiscountAmount as 'DiscountAmount', 
		--		QuoteSOAMCTaxAmount 'GST Amount',
		--		QuoteSOAMCTotalAmount,

		--		OrderSOAMCPayments as 'Paid',
		--		(QuoteSOAMCTotalAmount - OrderSOAMCPayments) as 'Balance'

		--	from QuoteSOAMCHdr 
		--	inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOAMCHdr.OrdClientHdrId
		--	where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId 

		--	) Payments
          
  --      --WHERE StocksInwardHdrId = @StocksInwardHdrId
