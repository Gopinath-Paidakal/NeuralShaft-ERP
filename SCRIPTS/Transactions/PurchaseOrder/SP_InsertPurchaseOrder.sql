USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertPurchaseOrder]    Script Date: 16/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertPurchaseOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertPurchaseOrder]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertPurchaseOrder]    Script Date: 16/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertPurchaseOrder]
(
	@PurchaseOrderHdr NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @PurchaseOrderHdrId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @PONo int
	Declare @POSlNo nvarchar(50)
    Declare @Prefix nvarchar(50)


    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'PurchaseOrder' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
 --   --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @PONo = max(PONo) from PurchaseOrderHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @PONo = 0 or @PONo is NULL
		set @PONo = 1
	else
		set @PONo = @PONo + 1

	set @POSlNo = @Prefix + RIGHT('00' + CAST(@PONo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO dbo.PurchaseOrderHdr
        (
            CompanyId,
            BranchId,

            SOHdrId,
            EmpId,
            VendorHdrId,
           
            POType,
            PONo,
            POSLNo,
            PODate,

            BillingAddress,
            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            ProformaInvoiceNo,
            ProformaInvoiceDate,
            PORemarks,
            PODeliveryTerms,
            
            POProductAmount,
            PODiscountPercentage,
            PODiscountAmount,
            POTaxPercentage,
            
            ItemTotalAmount,
            POSubTotal,
            POTaxAmount,
            POGrandTotal,
            
            CreatedUserId,
            CreatedDate

        )
        SELECT
            @CompanyId,
            @BranchId,

            SOHdrId,
            EmpId,
            VendorHdrId,
           
            POType,
            @PONo,
            @POSlNo,
            PODate,

            BillingAddress,
            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            ProformaInvoiceNo,
            ProformaInvoiceDate,
            PORemarks,
            PODeliveryTerms,
            
            POProductAmount,
            PODiscountPercentage,
            PODiscountAmount,
            POTaxPercentage,
            
            ItemTotalAmount,
            POSubTotal,
            POTaxAmount,
            POGrandTotal,
            
            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@PurchaseOrderHdr,'$.PurchaseOrderHdr')
        WITH
        (
            SOHdrId                     INT,
            EmpId                       INT,
            VendorHdrId                 INT,

            POType                      NVARCHAR(50), 
            --PONo                        NVARCHAR(50),
            --POSLNo                      INT,
            PODate                      DATE,

            BillingAddress              NVARCHAR(200), 
            DeliveryAddress             NVARCHAR(200), 
            DeliveryContactPerson       NVARCHAR(100), 
            DeliveryMobileId            NVARCHAR(100), 

            ProformaInvoiceNo           NVARCHAR(50), 
            ProformaInvoiceDate         Date, 
            PORemarks                   NVARCHAR(1000),
            PODeliveryTerms             NVARCHAR(100),

            POProductAmount             DECIMAL(18,2),
            PODiscountPercentage        DECIMAL(18,2),
            PODiscountAmount            DECIMAL(18,2),
            POTaxPercentage             DECIMAL(18,2),
            ItemTotalAmount             DECIMAL(18,2),

            POSubTotal                  DECIMAL(18,2),
            POTaxAmount                 DECIMAL(18,2),
            POGrandTotal                DECIMAL(18,2),

            CreatedUserId               INT,
            CreatedDate                 DATE
        );

        SET @PurchaseOrderHdrId = SCOPE_IDENTITY();

        ------------------------------------------------------------
        -- Insert Details
        ------------------------------------------------------------
        INSERT INTO dbo.PurchaseOrderDtl
        (
            PurchaseOrderHdrId,
            ItemId,
            ItemDescription,
            ItemQty,
            ItemRate,
            
            ItemAmount,
            ItemDiscountPercentage,
            ItemDiscountAmount,
            TaxPercentage,
            TaxAmount,

            ItemTotalAmount,
            CreatedUserId,
            CreatedDate
        )
        SELECT

            @PurchaseOrderHdrId,
            ItemId,
            ItemDescription,
            ItemQty,
            ItemRate,

            ItemAmount,
            ItemDiscountPercentage,
            ItemDiscountAmount,
            TaxPercentage,
            TaxAmount,

            ItemTotalAmount,
            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@PurchaseOrderHdr,'$.PurchaseOrderDtl')
        WITH
        (
            ItemId                     INT,
            ItemDescription            NVARCHAR(500),
            ItemQty                    DECIMAL(18,2),
            ItemRate                   DECIMAL(18,2),
            ItemAmount                 DECIMAL(18,2),
            
            ItemDiscountPercentage     DECIMAL(18,2),
            ItemDiscountAmount         DECIMAL(18,2),
            TaxPercentage              DECIMAL(18,2),
            TaxAmount                  DECIMAL(18,2),
            ItemTotalAmount            DECIMAL(18,2),
            
            CreatedUserId               INT,
            CreatedDate                 DATE
        );

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