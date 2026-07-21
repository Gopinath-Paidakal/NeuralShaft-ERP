USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateQuoteHdr]    Script Date: 09/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateQuoteHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateQuoteHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateQuoteHdr]    Script Date: 09/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateQuoteHdr]
(
    @QuoteHdrId int,
	@QuoteHdr nvarchar(max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION
    	
        UPDATE Q
            SET 

                Q.QuoteConsultant    = J.QuoteConsultant,
                Q.QuoteClientSalutation = J.QuoteClientSalutation,
                Q.QuoteCustComp      = J.QuoteCustComp,
                Q.QuoteBillingAddr   = J.QuoteBillingAddr,
                Q.QuoteContPerson    = J.QuoteContPerson,

                Q.QuoteMobileNo      = J.QuoteMobileNo,
                Q.ProjectName         = J.ProjectName,
                Q.ExpectedClosingDate = J.ExpectedClosingDate,
                Q.QuoteEmailId        = J.QuoteEmailId,
                Q.QuotePaymentTerms   = J.QuotePaymentTerms,

                Q.QuoteValidity       = J.QuoteValidity,
                Q.DeliveryBy          = J.DeliveryBy,
                Q.ComplementaryAMC    = J.ComplementaryAMC,
                Q.GSTExempted         = J.GSTExempted,
                Q.QuoteContSalutation = J.QuoteContSalutation,

                Q.ModifiedUserId      = J.ModifiedUserId,     --1,
                Q.ModifiedDate        = J.ModifiedDate

            FROM dbo.QuoteHdr Q
            CROSS APPLY OPENJSON(@QuoteHdr)
            WITH (
                
                QuoteConsultant      NVARCHAR(100),
                QuoteClientSalutation NVARCHAR(15),
                QuoteCustComp        NVARCHAR(100),
                QuoteBillingAddr     NVARCHAR(100),
                QuoteContPerson      NVARCHAR(100),

                QuoteMobileNo        NVARCHAR(100),
                ProjectName           NVARCHAR(100),
                ExpectedClosingDate   DATE,
                QuoteEmailId          NVARCHAR(100),
                QuotePaymentTerms     NVARCHAR(500),

                QuoteValidity         SMALLINT,
                DeliveryBy            SMALLINT,
                ComplementaryAMC      SMALLINT,
                GSTExempted           BIT,
                QuoteContSalutation   NVARCHAR(15),

                ModifiedUserId        int,
                ModifiedDate          DATETIME
            ) J
            WHERE Q.QuoteHdrId = @QuoteHdrId;

            -----------------------------------------------------
            ----- Update EnqClient when Quote Header Updated
            -----------------------------------------------------
            Declare @EnqHdrId int

            Declare @QuoteConsultant nvarchar(100)
            Declare @QuoteCustComp nvarchar(100)
            Declare @QuoteBillingAddr nvarchar(100)
            Declare @QuoteContPerson nvarchar(100)
            Declare @QuoteMobileNo nvarchar(100)

            ----SET @EnqDtlId = JSON_VALUE(@OrdApprove, '$.OrdApprove.EnqDtlId');

            set @QuoteConsultant   = JSON_VALUE(@QuoteHdr,'$.QuoteConsultant'); 
            set @QuoteCustComp     = JSON_VALUE(@QuoteHdr,'$.QuoteCustComp'); 
            set @QuoteBillingAddr  = JSON_VALUE(@QuoteHdr,'$.QuoteBillingAddr'); 
            set @QuoteContPerson   = JSON_VALUE(@QuoteHdr,'$.QuoteContPerson'); 
            set @QuoteMobileNo     = JSON_VALUE(@QuoteHdr,'$.QuoteMobileNo'); 

            set @EnqHdrId = (Select EnqHdrId from QuoteHdr where QuoteHdrId = @QuoteHdrId)

            Update EnqClient set EnqConsultant = @QuoteConsultant,
                                 EnqClientName = @QuoteCustComp,
                                 EnqClientAddress = @QuoteBillingAddr,
                                 EnqContactPerson = @QuoteContPerson,
                                 EnqClientMobileNo = @QuoteMobileNo
                    Where EnqHdrId = @EnqHdrId

           -------=========================================================================

            select @QuoteHdrId
      
		

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


  ---- Update statement
        --UPDATE Q
        --SET 
        --    --QuoteDate           = JSON_VALUE(@QuoteHdr, '$.QuoteDate'),
        --    ProjectName         = JSON_VALUE(@QuoteHdr, '$.ProjectName'),
        --    ExpectedClosingDate = JSON_VALUE(@QuoteHdr, '$.ExpectedClosingDate'),
        --    QuotePaymentTerms   = JSON_VALUE(@QuoteHdr, '$.QuotePaymentTerms'),
        --    QuoteValidity       = JSON_VALUE(@QuoteHdr, '$.QuoteValidity'),

        --    DeliveryBy          = JSON_VALUE(@QuoteHdr, '$.DeliveryBy'),
        --    ComplementaryAMC    = JSON_VALUE(@QuoteHdr, '$.ComplementaryAMC'),
        --    GSTExempted         = JSON_VALUE(@QuoteHdr, '$.GSTExempted'),
        --    ModifiedUserId      = 1,    --JSON_VALUE(@QuoteHdr, '$.ModifiedUserId'),
        --    ModifiedDate        = JSON_VALUE(@QuoteHdr, '$.ModifiedDate')     --GETDATE()

        --FROM dbo.QuoteHdr Q

        --WHERE Q.QuoteHdrId = @QuoteHdrId;

            --CompanyId = JSON_VALUE(@QuoteHdr, '$.CompanyId'),
            --BranchId = JSON_VALUE(@QuoteHdr, '$.BranchId'),
            --EnqHdrId = JSON_VALUE(@QuoteHdr, '$.EnqHdrId'),
            --QuoteNo = JSON_VALUE(@QuoteHdr, '$.QuoteNo'),

                --QuoteSlNo = JSON_VALUE(@QuoteHdr, '$.QuoteSlNo'),
            --QuoteAmount = JSON_VALUE(@QuoteHdr, '$.QuoteAmount'),
            --QuoteTaxAmount = JSON_VALUE(@QuoteHdr, '$.QuoteTaxAmount'),
            --QuoteTotalAmount = JSON_VALUE(@ QuoteHdr, '$.QuoteTotalAmount'),

            --QuoteSpecialFeatures = JSON_VALUE(@QuoteHdr, '$.QuoteSpecialFeatures'),

             --ModifiedDate = JSON_VALUE(@QuoteHdr, '$.CreatedDate')






--DECLARE @QuoteHdrId INT;

  --      -- Extract primary key (important for UPDATE)
  --      SET @QuoteHdrId = JSON_VALUE(@QuoteHdr, '$.QuoteHdrId');

  --      -- Validate
  --      IF @QuoteHdrId IS NULL
  --      BEGIN
  --          RAISERROR('QuoteHdrId is required for update.', 16, 1);
  --          RETURN;
  --      END