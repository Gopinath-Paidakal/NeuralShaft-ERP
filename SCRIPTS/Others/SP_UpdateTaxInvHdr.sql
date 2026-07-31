USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTaxInv]    Script Date: 13/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateTaxInv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateTaxInv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTaxInv]    Script Date: 13/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateTaxInv]
(
    @TaxInvHdrId int,
	@TaxInvUpdate NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @TaxInvHdrId INT

	BEGIN TRANSACTION

	UPDATE H
        SET
            H.SOHdrId                   = J.SOHdrId,
            H.OrdClientHdrId            = J.OrdClientHdrId,

            H.EmpId                     = J.EmpId,

            H.TaxInvNo                  = J.TaxInvNo,
            H.TaxInvSLNo                = J.TaxInvSLNo,
            H.TaxInvDate                = J.TaxInvDate,

            H.DeliveryAddress           = J.DeliveryAddress,
            H.DeliveryContactperson     = J.DeliveryContactperson,
            H.DeliveryMobileId          = J.DeliveryMobileId,

            H.OrdClientPONo             = J.OrdClientPONo,
            H.OrdClientPODate           = J.OrdClientPODate,
            H.TaxInvRemarks             = J.TaxInvRemarks,

            H.TaxInvProductAmount       = J.TaxInvProductAmount,
            H.TaxInvDiscountPercentage  = J.TaxInvDiscountPercentage,
            H.TaxInvDiscountAmount      = J.TaxInvDiscountAmount,
            H.TaxInvTaxPercentage       = J.TaxInvTaxPercentage,
            
            H.ItemTotalAmount           = J.ItemTotalAmount,
            H.TaxInvSubTotal            = J.TaxInvSubTotal,
            H.TaxInvTaxAmount           = J.TaxInvTaxAmount,
            H.TaxInvGrandTotal          = J.TaxInvGrandTotal,

            H.ModifiedUserId             = J.ModifiedUserId,
            H.ModifiedDate               = J.ModifiedDate


        FROM dbo.TaxInvHdr H
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@TaxInvUpdate, '$.TaxInvHdr')
            WITH
            (
                TaxInvHdrId             INT,
                SOHdrId                 INT,
                OrdClientHdrId          INT,
                EmpId                   INT,
                TaxInvNo                NVARCHAR(50),
                TaxInvSLNo              NVARCHAR(50),

                TaxInvDate              DATE,
                DeliveryAddress         NVARCHAR(200), 
                DeliveryContactPerson   NVARCHAR(100), 
                DeliveryMobileId        NVARCHAR(100), 

                OrdClientPONo           NVARCHAR(50),
                OrdClientPODate         DATE,
                TaxInvRemarks           NVARCHAR(1000),

                TaxInvProductAmount      DECIMAL(18,2),
                TaxInvDiscountPercentage DECIMAL(18,2),
                TaxInvDiscountAmount     DECIMAL(18,2),
                TaxInvTaxPercentage      DECIMAL(18,2),
                
                ItemTotalAmount          DECIMAL(18,2),
                TaxInvSubTotal           DECIMAL(18,2),
                TaxInvTaxAmount          DECIMAL(18,2),
                TaxInvGrandTotal         DECIMAL(18,2),

                ModifiedUserId           INT,
                ModifiedDate             DATE

            )
        ) J
        ON H.TaxInvHdrId =  @TaxInvHdrId   --      J.TaxInvHdrId;

        ----------- Update Detail

        UPDATE D
        SET
            D.ItemId                   = J.ItemId,
            D.ItemDescription          = J.ItemDescription,
            D.ItemQty                  = J.ItemQty,
            D.ItemRate                 = J.ItemRate,
            D.ItemAmount               = J.ItemAmount,

            D.ItemDiscountPercentage   = J.ItemDiscountPercentage,
            D.ItemDiscountAmount       = J.ItemDiscountAmount,
            D.TaxPercentage            = J.TaxPercentage,
            D.TaxAmount                = J.TaxAmount,
            D.ItemTotalAmount          = J.ItemTotalAmount,

            D.ModifiedUserId           = J.ModifiedUserId,
            D.ModifiedDate             = J.ModifiedDate


        FROM dbo.TaxInvDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@TaxInvUpdate, '$.TaxInvDtl')
            WITH
            (
                TaxInvDtlId             INT,
                ItemId                  INT,
                ItemDescription         NVARCHAR(500),
                ItemQty                 DECIMAL(18,2),
                ItemRate                DECIMAL(18,2),
                
                ItemAmount              DECIMAL(18,2),
                ItemDiscountPercentage  DECIMAL(18,2),
                ItemDiscountAmount      DECIMAL(18,2),
                TaxPercentage           DECIMAL(18,2),

                TaxAmount               DECIMAL(18,2),
                ItemTotalAmount         DECIMAL(18,2),

                ModifiedUserId          INT,
                ModifiedDate            DATE
            )
        ) J
        ON D.TaxInvDtlId = J.TaxInvDtlId;
    

    Select @TaxInvHdrId

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