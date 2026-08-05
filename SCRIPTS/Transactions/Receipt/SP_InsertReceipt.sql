USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertReceipt]    Script Date: 05/08/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertReceipt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertReceipt]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertReceipt]
(
	@Receipt NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @ReceiptId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @ReceiptNo int

    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    --set @Prefix = (select DefaultDataName from DefaultData where FormType = 'TaxInv' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
    ----set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @ReceiptNo = max(ReceiptNo) from Receipt where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @ReceiptNo = 0 or @ReceiptNo is NULL
		set @ReceiptNo = 1
	else
		set @ReceiptNo = @ReceiptNo + 1

	--set @ReceiptNo = @Prefix + RIGHT('00' + CAST(@TaxInvNo AS VARCHAR(10)), 5) + '/'            
	--                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO Receipt
    (
            CompanyId,
            BranchId,
            OrdClientHdrId,
            ReceiptNo,
            ReceiptDate,

            PaymentType,
            ChequeDeposited,
            BankName,
            ChequeNo,
            ChequeAmount,

            ChequeStatus,
            PaymentDetails,
            Amount,
            TotalAmount,

            CreatedUserId,
            CreatedDate
    )
    SELECT
          @CompanyId,
          @BranchId,
          OrdClientHdrId,
          @ReceiptNo,
          ReceiptDate,
          PaymentType,
          ChequeDeposited,

          BankName,
          ChequeNo,
          ChequeAmount,
          ChequeStatus,
          PaymentDetails,
          
          Amount,
          TotalAmount,
          CreatedUserId,
          CreatedDate

    FROM OPENJSON(@Receipt, '$.Receipt')
    WITH
    (
          ReceiptId          INT,
          OrdClientHdrId     INT,
          ReceiptDate        DATETIME,
          PaymentType        NVARCHAR(50),
          ChequeDeposited    DATETIME,

          BankName           NVARCHAR(200),
          ChequeNo           NVARCHAR(100),
          ChequeAmount       DECIMAL(18,2),
          ChequeStatus       NVARCHAR(50),
          PaymentDetails     NVARCHAR(MAX),
          
          Amount             DECIMAL(18,2),
          TotalAmount        DECIMAL(18,2),
          CreatedUserId      INT,
          CreatedDate        DATETIME

    );

    SET @ReceiptId = SCOPE_IDENTITY();

    ---========================================================
    --- Update Amounts in SoDtl, SoItemHdr, SoAMC
    ---========================================================
    Declare @TableName NVARCHAR(50)
    Declare @Id INT
    Declare @Paid numeric(18,2)

    --set @TableName = JSON_VALUE(@Receipt, '$.Payments.TableName')
    --set @Id = JSON_VALUE(@Receipt, '$.Payments.Id')
    --set @Paid = JSON_VALUE(@Receipt, '$.Payments.Paid')

    DECLARE CurPayment CURSOR LOCAL FAST_FORWARD FOR
       SELECT
            TableName,
            Id,
            Paid
        FROM OPENJSON(@Receipt, '$.Payments')
        WITH
        (
            TableName VARCHAR(50) '$.Table',
            Id        INT         '$.Id',
            Paid      DECIMAL(18,2) '$.Paid'
        );

    OPEN CurPayment;

    FETCH NEXT FROM CurPayment
    INTO @TableName, @Id, @Paid;

    WHILE @@FETCH_STATUS = 0
        BEGIN

            IF @TableName = 'SOHDr'
            BEGIN
                UPDATE SOHDr
                SET OrdPayments = ISNULL(OrdPayments,0) + @Paid
                WHERE SoHdrId = @Id;
            END
            ELSE IF @TableName = 'QuoteSOItemHdr'
            BEGIN
                UPDATE QuoteSOItemHdr
                SET OrderSOItemPayments = ISNULL(OrderSOItemPayments,0) + @Paid
                WHERE QuoteSOItemHdrId = @Id;
            END
            ELSE IF @TableName = 'QuoteSOAMCHdr'
            BEGIN
                UPDATE QuoteSOAMCHdr
                SET OrderSOAMCPayments = ISNULL(OrderSOAMCPayments,0) + @Paid
                WHERE QuoteSOAMCHdrId = @Id;
            END

            FETCH NEXT FROM CurPayment
            INTO @TableName, @Id, @Paid;

        END

        CLOSE CurPayment;
        DEALLOCATE CurPayment;

    Select @ReceiptId

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