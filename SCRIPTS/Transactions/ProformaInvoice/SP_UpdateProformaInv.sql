USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateProformaInv]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateProformaInv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateProformaInv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateProformaInv]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateProformaInv]
(
    @ProformaInvHdrId int,
	@ProformaInvUpdate NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @ProformaInvHdrId INT

	BEGIN TRANSACTION

	UPDATE H
        SET
            H.SOHdrId                    = J.SOHdrId,
            H.OrdClientHdrId             = J.OrdClientHdrId,

            H.EmpId                      = J.EmpId,

            H.ProformaInvNo              = J.ProformaInvNo,
            H.ProformaInvSLNo            = J.ProformaInvSLNo,
            H.ProformaInvDate            = J.ProformaInvDate,

            H.DeliveryAddress            = J.DeliveryAddress,
            H.DeliveryContactperson      = J.DeliveryContactperson,
            H.DeliveryMobileId           = J.DeliveryMobileId,

            H.OrdClientPONo              = J.OrdClientPONo,
            H.OrdClientPODate            = J.OrdClientPODate,
            H.ProformaInvRemarks         = J.ProformaInvRemarks,

            --H.ProformaItemAmount         = J.ProformaItemAmount,
            --H.ProformaDiscountAmount     = J.ProformaDiscountAmount,
            --H.ProformaTaxAmount          = J.ProformaTaxAmount,
            --H.ProformaTotalAmount        = J.ProformaTotalAmount,

            H.ModifiedUserId             = J.ModifiedUserId,
            H.ModifiedDate               = J.ModifiedDate


        FROM dbo.ProformaInvHdr H
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@ProformaInvUpdate, '$.ProformaInvHdr')
            WITH
            (
                ProformaInvHdrId           INT,
                SOHdrId                    INT,
                OrdClientHdrId             INT,
                EmpId                      INT,
                ProformaInvNo              NVARCHAR(50),
                ProformaInvSLNo            NVARCHAR(50),

                ProformaInvDate            DATE,
                DeliveryAddress            NVARCHAR(200), 
                DeliveryContactPerson      NVARCHAR(100), 
                DeliveryMobileId           NVARCHAR(100), 

                OrdClientPONo              NVARCHAR(50),
                OrdClientPODate            DATE,
                ProformaInvRemarks         NVARCHAR(1000),

                --ProformaProductAmount      DECIMAL(18,2),
                --ProformaDiscountPercentage DECIMAL(18,2),
                --ProformaDiscountAmount     DECIMAL(18,2),
                --ProformaTaxPercentage      DECIMAL(18,2),
                
                --ItemTotalAmount            DECIMAL(18,2),
                --ProformaSubTotal           DECIMAL(18,2),
                --ProformaTaxAmount          DECIMAL(18,2),
                --ProformaGrandTotal         DECIMAL(18,2),

                ModifiedUserId             INT,
                ModifiedDate               DATE

            )
        ) J
        ON H.ProformaInvHdrId =  @ProformaInvHdrId   --      J.ProformaInvHdrId;

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


        FROM dbo.ProformaInvDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@ProformaInvUpdate, '$.ProformaInvDtl')
            WITH
            (
                ProformaInvDtlId         INT,
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
        ON D.ProformaInvDtlId = J.ProformaInvDtlId;
    

    Select @ProformaInvHdrId

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