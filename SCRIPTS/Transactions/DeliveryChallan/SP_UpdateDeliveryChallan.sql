USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDeliveryChallan]    Script Date: 13/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateDeliveryChallan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateDeliveryChallan]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDeliveryChallan]    Script Date: 13/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateDeliveryChallan]
(
    @DCHdrId int,
	@DeliveryChallanUpdate NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @DCHdrId INT

	BEGIN TRANSACTION

	UPDATE H
        SET
            H.SOHdrId                   = J.SOHdrId,
            H.OrdClientHdrId            = J.OrdClientHdrId,

            H.EmpId                     = J.EmpId,

            H.DCNo                      = J.DCNo,
            H.DCSLNo                    = J.DCSLNo,
            H.DCDate                    = J.DCDate,

            H.DeliveryAddress           = J.DeliveryAddress,
            H.DeliveryContactperson     = J.DeliveryContactperson,
            H.DeliveryMobileId          = J.DeliveryMobileId,

            H.OrdClientPONo             = J.OrdClientPONo,
            H.OrdClientPODate           = J.OrdClientPODate,
            H.DCRemarks                 = J.DCRemarks,

            H.DCProductAmount           = J.DCProductAmount,
            H.DCDiscountPercentage      = J.DCDiscountPercentage,
            H.DCDiscountAmount          = J.DCDiscountAmount,
            H.DCTaxPercentage           = J.DCTaxPercentage,
            
            H.ItemTotalAmount           = J.ItemTotalAmount,
            H.DCSubTotal                = J.DCSubTotal,
            H.DCTaxAmount               = J.DCTaxAmount,
            H.DCGrandTotal              = J.DCGrandTotal,

            H.ModifiedUserId            = J.ModifiedUserId,
            H.ModifiedDate              = J.ModifiedDate


        FROM dbo.DeliveryChallanHdr H
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@DeliveryChallanUpdate, '$.DeliveryChallanHdr')
            WITH
            (
                DCHdrId                 INT,
                SOHdrId                 INT,
                OrdClientHdrId          INT,
                EmpId                   INT,
                DCNo                    NVARCHAR(50),
                DCSLNo                  NVARCHAR(50),

                DCDate                  DATE,
                DeliveryAddress         NVARCHAR(200), 
                DeliveryContactPerson   NVARCHAR(100), 
                DeliveryMobileId        NVARCHAR(100), 

                OrdClientPONo           NVARCHAR(50),
                OrdClientPODate         DATE,
                DCRemarks               NVARCHAR(1000),

                DCProductAmount         DECIMAL(18,2),
                DCDiscountPercentage    DECIMAL(18,2),
                DCDiscountAmount        DECIMAL(18,2),
                DCTaxPercentage         DECIMAL(18,2),
                
                ItemTotalAmount         DECIMAL(18,2),
                DCSubTotal              DECIMAL(18,2),
                DCTaxAmount             DECIMAL(18,2),
                DCGrandTotal            DECIMAL(18,2),

                ModifiedUserId          INT,
                ModifiedDate            DATE

            )
        ) J
        ON H.DCHdrId =  @DCHdrId   --      J.DCHdrId;

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


        FROM dbo.DeliveryChallanDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@DeliveryChallanUpdate, '$.DeliveryChallanDtl')
            WITH
            (
                DCDtlId             INT,
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
        ON D.DCDtlId = J.DCDtlId;
    

    Select @DCHdrId

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