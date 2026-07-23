USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteAMC_ById]    Script Date: 18/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetQuoteAMC_ById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetQuoteAMC_ById]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuoteAMC_ById]    Script Date: 18/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetQuoteAMC_ById]
(
	@QuoteAMCHdrId  int = 0
  
)
With Encryption
AS

SET NOCOUNT ON;
BEGIN TRY

DECLARE @QuoteAMCHdr NVARCHAR(MAX)
DECLARE @QuoteAMCDtl   NVARCHAR(MAX)
DECLARE @QuoteAMC   NVARCHAR(MAX)

     SET @QuoteAMCHdr = (
       
         SELECT [QuoteAMCHdrId]
          --,[CompanyId]
          --,[BranchId]
          ,[OrdClientHdrId]
          ,[QuoteAMCNo]
          ,[QuoteAMCSlNo]
          --,[QuoteAMCDate]
          ,FORMAT([QuoteAMCDate], 'dd-MM-yyyy') as [QuoteAMCDate]    -- + ' ' + FORMAT(SOHDate, 'HH:mm:ss') 
          ,[QuoteAMCConsultant]

          --,[QuoteAMCClientSalutation]
          ,[QuoteAMCCustComp]
          ,[QuoteAMCBillingAddr]
          ,[QuoteAMCJobOrderNo]
          ,[QuoteAMCContPerson]
      
          ,[QuoteAMCMobileNo]
        --  ,[QuoteAMCProjectName]
          ,[AMCExpectedClosingDate]
          ,[QuoteAMCEmailId]
          ,[QuoteAMCDeliveryInDays]
      
          ,[QuoteAMCValidity]
          ,[QuoteAMCGSTExempted]
          ,[QuoteAMCPaymentTerms]
          ,[QuoteAMCAmount]
          ,[QuoteAMCTaxAmount]
        
          ,[QuoteAMCRenewalCount]
         -- ,[QuoteAMCRevisionNo]
          ,[QuoteAMCStartDate]
          ,[QuoteAMCEndDate]
          ,[QuoteAMCStatus]

          --,[CreatedUserId]
          --,[CreatedDate]
          --,[ModifiedUserId]
          --,[ModifiedDate]
       FROM [dbo].[QuoteAMCHdr]

           where QuoteAMCHdrId = @QuoteAMCHdrId

            FOR JSON PATH   
        )

     SET @QuoteAMCDtl = (
       
          SELECT [QuoteAMCDtlId]
              ,[QuoteAMCHdrId]
              ,[ItemId]
              ,[ItemName]
              ,[ItemHSNCode]
              ,[ItemCode]

              ,[ItemDesc]
              ,[ItemQuantity]
              ,[ItemRate]
              ,[ItemAmount]
              ,[ItemDiscountAmount]

              ,[ItemDiscountPercentage]
              ,[ItemTaxPercentage]
              ,[ItemTotalAmount]
              --,[CrudType]
              
              --,[CreatedUserId]
              --,[CreatedDate]
              --,[ModifiedUserId]
              --,[ModifiedDate]
          FROM [dbo].[QuoteAMCDtl]
          
          where QuoteAMCHdrId = @QuoteAMCHdrId

            FOR JSON PATH   
        )


       SET @QuoteAMC = (
            SELECT
                JSON_QUERY(@QuoteAMCHdr)  AS QuoteAMCHdr,
                JSON_QUERY(@QuoteAMCDtl) AS QuoteAMCDtl
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
       )

    Select @QuoteAMC   

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

































































