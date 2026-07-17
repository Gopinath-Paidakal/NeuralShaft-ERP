USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdatePurchaseOrder]    Script Date: 16/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdatePurchaseOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdatePurchaseOrder]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdatePurchaseOrder]    Script Date: 16/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdatePurchaseOrder]
(
    @PurchaseOrderHdrId int,
	@PurchaseOrderUpdate NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @POHdrId INT

	BEGIN TRANSACTION

	UPDATE H
        SET
            H.SOHdrId                   = J.SOHdrId,
            H.EmpId                     = J.EmpId,
            H.VendorHdrId               = J.VendorHdrId,

            --H.PONo                      = J.PONo,
            --H.POSLNo                    = J.POSLNo,
            H.PODate                    = J.PODate,

            H.BillingAddress            = J.BillingAddress,
            H.DeliveryAddress           = J.DeliveryAddress,
            H.DeliveryContactperson     = J.DeliveryContactperson,
            H.DeliveryMobileId          = J.DeliveryMobileId,

            H.ProformaInvoiceNo         = J.ProformaInvoiceNo,
            H.ProformaInvoiceDate       = J.ProformaInvoiceDate,
            H.PORemarks                 = J.PORemarks,
            H.PODeliveryTerms           = J.PODeliveryTerms,

            H.POProductAmount           = J.POProductAmount,
            H.PODiscountPercentage      = J.PODiscountPercentage,
            H.PODiscountAmount          = J.PODiscountAmount,
            H.POTaxPercentage           = J.POTaxPercentage,
            
            H.ItemTotalAmount           = J.ItemTotalAmount,
            H.POSubTotal                = J.POSubTotal,
            H.POTaxAmount               = J.POTaxAmount,
            H.POGrandTotal              = J.POGrandTotal,

            H.ModifiedUserId            = J.ModifiedUserId,
            H.ModifiedDate              = J.ModifiedDate


        FROM dbo.PurchaseOrderHdr H
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@PurchaseOrderUpdate, '$.PurchaseOrderHdr')
            WITH
            (
                PurchaseOrderHdrId      INT,
                SOHdrId                 INT,
                EmpId                   INT,
                VendorHdrId             INT,

                --PONo                    NVARCHAR(50),
                --POSLNo                  NVARCHAR(50),

                PODate                  DATE,
                BillingAddress          NVARCHAR(200), 
                DeliveryAddress         NVARCHAR(200), 
                DeliveryContactPerson   NVARCHAR(100), 
                DeliveryMobileId        NVARCHAR(100), 

                ProformaInvoiceNo       NVARCHAR(50),
                ProformaInvoiceDate     DATE,
                PORemarks               NVARCHAR(1000),
                PODeliveryTerms         NVARCHAR(100),

                POProductAmount         DECIMAL(18,2),
                PODiscountPercentage    DECIMAL(18,2),
                PODiscountAmount        DECIMAL(18,2),
                POTaxPercentage         DECIMAL(18,2),
                
                ItemTotalAmount         DECIMAL(18,2),
                POSubTotal              DECIMAL(18,2),
                POTaxAmount             DECIMAL(18,2),
                POGrandTotal            DECIMAL(18,2),

                ModifiedUserId          INT,
                ModifiedDate            DATE

            )
        ) J
        ON H.PurchaseOrderHdrId =  @PurchaseOrderHdrId  --      J.POHdrId;

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


        FROM dbo.PurchaseOrderDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@PurchaseOrderUpdate, '$.PurchaseOrderDtl')
            WITH
            (
                PurchaseOrderDtlId             INT,
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
        ON D.PurchaseOrderDtlId = J.PurchaseOrderDtlId;
    

    Select @PurchaseOrderHdrId

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