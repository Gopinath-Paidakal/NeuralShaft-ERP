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
    @ReceiptId INT
)
----With Encryption
AS
SET NOCOUNT ON;
DECLARE @Receipt           NVARCHAR(MAX)
DECLARE @Payments          NVARCHAR(MAX)
DECLARE @ReceiptHdrDtl      NVARCHAR(MAX)

BEGIN TRY

	Declare @OrdClientHdrId int

	SET @OrdClientHdrId = (Select OrdClientHdrId from Receipt where ReceiptId = @ReceiptId)
    
    SET @Receipt = (
      
        SELECT [ReceiptId]
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
     
			FROM [dbo].[Receipt]
			

        WHERE ReceiptId = @ReceiptId
        FOR JSON PATH
    )

    SET @Payments = (

         SELECT *
			FROM
		(
		   SELECT 

			'SOHDr' as 'Table',
			SoHdrId as 'Id',
			OrdClientHdr.OrdClientHdrId,
			OrdClientHdr.OrdClientName,
			SOHSlNo as 'DocNo',

			SOHType as 'Type',
			OrdSubTotal as 'Order Amount',
			0 as 'DiscountAmount',
			OrdTax as 'GST Amount',
			OrdTotalAmount as 'Total Amount',

			OrdPayments as 'Paid',
			(OrdTotalAmount - OrdPayments) as 'Balance'

			from SOHDr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = SOHDr.OrdClientHdrId

			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId --and OrdTotalAmount > 0

			union all

			select 
				'QuoteSOItemHdr' as 'Table',
				QuoteSOItemHdrId as 'Id',
				OrdClientHdr.OrdClientHdrId,
				OrdClientHdr.OrdClientName,
				QuoteSOItemSlNo  as 'DocNo',
				
				QuoteSOItemType as 'Type',
				QuoteSOItemAmount as 'Order Amount', 
				QuoteSOItemDiscountAmount as 'DiscountAmount', 
				QuoteSOItemTaxAmount 'GST Amount',
				QuoteSOItemTotalAmount,

				OrderSOItemPayments as 'Paid',  
				(QuoteSOItemTotalAmount - OrderSOItemPayments)  as 'Balance'

			from QuoteSOItemHdr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOItemHdr.OrdClientHdrId
			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId ---and QuoteSOItemTotalAmount > 0

			union all

			select 
				'QuoteSOAMCHdr' as 'Table',
				QuoteSOAMCHdrId as 'Id',
				OrdClientHdr.OrdClientHdrId,
				OrdClientHdr.OrdClientName,
				QuoteSOAMCSlNo as 'DocNo',

				QuoteSOAMCType as 'Type',
				QuoteSOAMCAmount as 'Order Amount', 
				QuoteSOAMCDiscountAmount as 'DiscountAmount', 
				QuoteSOAMCTaxAmount 'GST Amount',
				QuoteSOAMCTotalAmount,

				OrderSOAMCPayments as 'Paid',
				(QuoteSOAMCTotalAmount - OrderSOAMCPayments) as 'Balance'

			from QuoteSOAMCHdr 
			inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = QuoteSOAMCHdr.OrdClientHdrId
			where OrdClientHdr.OrdClientHdrId = @OrdClientHdrId 

			) Payments
          
        --WHERE StocksInwardHdrId = @StocksInwardHdrId

        FOR JSON PATH    
    )

   

    SET @ReceiptHdrDtl = (
        SELECT
            JSON_QUERY(@Receipt)  AS  Receipt,
            JSON_QUERY(@Payments) AS  Payments
            
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