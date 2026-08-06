USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateReceipt]    Script Date: 06/08/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateReceipt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateReceipt]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateReceipt]
(
	@ReceiptHdrId int,
    @Receipt NVARCHAR(MAX)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @ReceiptId INT

	BEGIN TRANSACTION

    ---=========================================
    ----- Updating the ReceiptDtl Amounts
    ----========================================
    UPDATE RH
        SET
            --RH.CompanyId        = J.CompanyId,
            --RH.BranchId         = J.BranchId,
            --RH.OrdClientHdrId   = J.OrdClientHdrId,

            RH.ReceiptNo        = J.ReceiptNo,
            RH.ReceiptDate      = J.ReceiptDate,
            RH.PaymentType      = J.PaymentType,
            RH.ChequeDeposited  = J.ChequeDeposited,
            RH.BankName         = J.BankName,
            
            RH.ChequeNo         = J.ChequeNo,
            RH.ChequeAmount     = J.ChequeAmount,
            RH.ChequeStatus     = J.ChequeStatus,
            RH.PaymentDetails   = J.PaymentDetails,
            RH.Amount           = J.Amount,
            
            RH.TotalAmount      = J.TotalAmount,
            RH.ModifiedUserId   = J.ModifiedUserId,
            RH.ModifiedDate     = J.ModifiedDate

        FROM dbo.ReceiptHdr RH
        INNER JOIN OPENJSON(@Receipt, '$.Receipt')
       WITH
        (
            --ReceiptHdrId      INT,
            --CompanyId         INT,
            --BranchId          INT,
            --OrdClientHdrId    INT,
            ReceiptNo         NVARCHAR(50),
            ReceiptDate       DATE,
            PaymentType       NVARCHAR(50),
            ChequeDeposited   DATE,
            BankName          NVARCHAR(200),

            ChequeNo          NVARCHAR(100),
            ChequeAmount      DECIMAL(18,2),
            ChequeStatus      NVARCHAR(50),
            PaymentDetails    NVARCHAR(MAX),
            Amount            DECIMAL(18,2),
            
            TotalAmount       DECIMAL(18,2),
            ModifiedUserId    INT,
            ModifiedDate      DATETIME
        ) J

        ON RH.ReceiptHdrId = @ReceiptHdrId    --J.ReceiptHdrId;

    ---=========================================
    ----- Updating the ReceiptDtl Amounts
    ----========================================

    UPDATE RD
    SET
        RD.ReceiptHdrId      = @ReceiptHdrId,
        --RD.TableName        = J.TableName,
        --RD.TableId          = J.TableId,
        --RD.OrdClientHdrId   = J.OrdClientHdrId,
        --RD.OrdClientName    = J.OrdClientName,
        --RD.DocNo            = J.DocNo,
        --RD.Type             = J.Type,
        --RD.OrderAmount      = J.OrderAmount,
        --RD.DiscountAmount   = J.DiscountAmount,
        --RD.TaxAmount        = J.TaxAmount,
        --RD.TotalAmount      = J.TotalAmount,
        RD.Paid             = J.Paid,
        --RD.Balance          = J.Balance,
        RD.ModifiedUserId   = J.ModifiedUserId,
        RD.ModifiedDate     = J.ModifiedDate

    FROM dbo.ReceiptDtl RD
    INNER JOIN OPENJSON(@Receipt, '$.ReceiptDtl')
    WITH
    (
        ReceiptDtlId      INT,
        --ReceiptHdId       INT,
        --TableName         NVARCHAR(100),
        --TableId           INT,
        --OrdClientHdrId    INT,
        --OrdClientName     NVARCHAR(200),
        --DocNo             NVARCHAR(100),
        --Type              NVARCHAR(50),
        --OrderAmount       DECIMAL(18,2),
        --DiscountAmount    DECIMAL(18,2),
        --TaxAmount         DECIMAL(18,2),
        --TotalAmount       DECIMAL(18,2),
        Paid              DECIMAL(18,2),
        --Balance           DECIMAL(18,2),
        ModifiedUserId    INT,
        ModifiedDate      DATETIME
    ) J
    ON RD.ReceiptDtlId = J.ReceiptDtlId;

    ---========================================================
    --- Update Amounts in SoHdr, SoItemHdr, SoAMCHDr
    ---========================================================
    Declare @ReceiptDtlId int
    Declare @TableName NVARCHAR(50)
    Declare @Id INT
    Declare @Paid numeric(18,2)

    DECLARE @OldPaid DECIMAL(18,2);
    DECLARE @Diff DECIMAL(18,2);


    --set @TableName = JSON_VALUE(@Receipt, '$.Payments.TableName')
    --set @Id = JSON_VALUE(@Receipt, '$.Payments.Id')
    --set @Paid = JSON_VALUE(@Receipt, '$.Payments.Paid')

    DECLARE CurPayment CURSOR LOCAL FAST_FORWARD FOR
       SELECT
            ReceiptDtlId,
            TableName,
            Id,
            Paid
        FROM OPENJSON(@Receipt, '$.ReceiptDtl')
        WITH
        (
            ReceiptDtlId VARCHAR(50) '$.ReceiptDtlId',
            TableName VARCHAR(50) '$.Table',
            Id        INT         '$.Id',
            Paid      DECIMAL(18,2) '$.Paid'
        );

    OPEN CurPayment;

    FETCH NEXT FROM CurPayment
    INTO @ReceiptDtlId, @TableName, @Id, @Paid;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @OldPaid = Paid FROM ReceiptDtl WHERE ReceiptDtlId = @ReceiptDtlId;
            SET @Diff = @Paid - ISNULL(@OldPaid,0);

            IF @TableName = 'SOHDr'
            BEGIN
                UPDATE SOHDr
                SET OrdPayments = ISNULL(OrdPayments,0) + @Diff
                WHERE SoHdrId = @Id;
            END
            ELSE IF @TableName = 'QuoteSOItemHdr'
            BEGIN
                UPDATE QuoteSOItemHdr
                SET OrderSOItemPayments = ISNULL(OrderSOItemPayments,0) + @Diff
                WHERE QuoteSOItemHdrId = @Id;
            END
            ELSE IF @TableName = 'QuoteSOAMCHdr'
            BEGIN
                UPDATE QuoteSOAMCHdr
                SET OrderSOAMCPayments = ISNULL(OrderSOAMCPayments,0) + @Diff
                WHERE QuoteSOAMCHdrId = @Id;
            END

            FETCH NEXT FROM CurPayment
            INTO @ReceiptDtlId, @TableName, @Id, @Paid;

        END

        CLOSE CurPayment;
        DEALLOCATE CurPayment;

    Select @ReceiptHdrId

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