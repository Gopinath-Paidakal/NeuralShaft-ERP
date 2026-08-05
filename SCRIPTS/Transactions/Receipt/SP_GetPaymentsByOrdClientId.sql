USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPaymentsByOrdClientId]    Script Date: 05/08/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPaymentsByOrdClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetPaymentsByOrdClientId]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetPaymentsByOrdClientId]
(
	@OrdClientHdrId int
)

AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION

	-- GET ALL BRANCHES AS JSON
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
		
			FOR JSON PATH, ROOT('OrdClientPayments')  -- ROOT WITHOUT_ARRAY_WRAPPER

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