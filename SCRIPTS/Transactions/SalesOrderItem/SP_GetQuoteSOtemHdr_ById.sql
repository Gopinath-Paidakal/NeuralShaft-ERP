USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOtemHdr_ById]    Script Date: 27/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteSOtemHdr_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteSOtemHdr_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteSOtemHdr_ById]    Script Date: 27/07//2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteSOtemHdr_ById]
(
	@QuoteSOItemHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY
DECLARE @QuoteItemHdr   NVARCHAR(MAX)
DECLARE @QuoteItemDtl   NVARCHAR(MAX)
DECLARE @QuoteItem      NVARCHAR(MAX)

SET @QuoteItemHdr = (

    SELECT 
		
		[QuoteSOItemHdr].[QuoteSOItemHdrId]
          --,[CompanyId]
          --,[BranchId]
        
		  ,[QuoteSOItemHdr].[OrdClientHdrId]
          ,[QuoteSOItemHdr].[QuoteSOItemType]
          ,[QuoteSOItemHdr].[QuoteSOItemNo]
           --[QuoteHdr].[QuoteDate]

	      ,FORMAT(QuoteSOItemDate, 'dd-MM-yyyy') as QuoteDate   -- + ' ' + FORMAT(QuoteDate, 'HH:mm:ss') as QuoteDate
          ,[QuoteSOItemHdr].[QuoteSOItemSlNo]

	      ,[QuoteSOItemHdr].[QuoteSOItemConsultant]
          ,[QuoteSOItemHdr].[QuoteSOItemCustComp]
		  ,[QuoteSOItemHdr].[QuoteSOItemBillingAddr]
          ,[QuoteSOItemHdr].[QuoteSOItemJobOrderNo]
          ,[QuoteSOItemHdr].[QuoteSOItemContPerson]
          ,[QuoteSOItemHdr].[QuoteSOItemMobileNo]


	      ,[QuoteSOItemHdr].[QuoteSOItemExpectedClosingDate]
	      ,[QuoteSOItemHdr].[QuoteSOItemEmailId]
          ,[QuoteSOItemHdr].[QuoteSOItemDeliveryInDays]
	      

          ,[QuoteSOItemHdr].[QuoteSOItemValidity]
          ,[QuoteSOItemHdr].[QuoteSOItemPaymentTerms]
	      ,[QuoteSOItemHdr].[QuoteSOItemGSTExempted]
	      
		  ,[QuoteSOItemHdr].[QuoteSOItemOrderStatus]
          ,[QuoteSOItemHdr].[QuoteSOItemAmount]
          ,[QuoteSOItemHdr].[QuoteSOItemDiscountAmount]
          ,[QuoteSOItemHdr].[QuoteSOItemTaxAmount]
          ,[QuoteSOItemHdr].[QuoteSOItemTotalAmount]


		  --,[QuoteSOItemHdr].[CreatedUserId]

		  ,([Employee].[EmpFirstName] + ' ' +  [Employee].[EmpLastName]) as 'Employee Name'
		  ,[Employee].[EmpMobileNo]

		  ,[QuoteSOItemHdr].[CreatedDate]

		  ,FORMAT(DATEADD(DAY, TRY_CAST(QuoteSOItemHdr.QuoteSOItemValidity AS INT), QuoteSOItemHdr.CreatedDate),'dd-MM-yyyy') as 'Price Validity'


	    FROM [dbo].[QuoteSOItemHdr]
        INNER JOIN [Employee] ON [Employee].EmpId = [QuoteSOItemHdr].[CreatedUserId]

        where QuoteSOItemHdrId = @QuoteSOItemHdrId

        FOR JSON PATH   
    )

    SET @QuoteItemDtl = (
       
           SELECT 
       
               [QuoteSOItemDtlId]
              ,[QuoteSOItemHdrId]
              ,[ItemId]
              ,[ItemName]
          
              ,[ItemHSNCode]
              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]

              ,[ItemAmount]
              ,[ItemTaxPercentage]
              ,[ItemDiscountAmount]
              ,[ItemDiscountPercentage]
              ,[ItemTotalAmount]          

           FROM [dbo].[QuoteSOItemDtl]
           where QuoteSOItemHdrId = @QuoteSOItemHdrId

            FOR JSON PATH   
        )

    SET @QuoteItem = (
        SELECT
            JSON_QUERY(@QuoteItemHdr)  AS QuoteItemHdr,
            JSON_QUERY(@QuoteItemDtl) AS QuoteItemDtl
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
   )

Select @QuoteItem   

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

































































