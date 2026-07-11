USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTaxInv]    Script Date: 11/07/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertTaxInv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertTaxInv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTaxInv]    Script Date: 11/07/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertTaxInv]
(
	@TaxInv NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @TaxInvHdrId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @TaxInvNo int
	Declare @TaxInvSlNo nvarchar(50)
    Declare @Prefix nvarchar(50)


    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'TaxInv' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
 --   --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @TaxInvNo = max(TaxInvNo) from TaxInvHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @TaxInvNo = 0 or @TaxInvNo is NULL
		set @TaxInvNo = 1
	else
		set @TaxInvNo = @TaxInvNo + 1

	set @TaxInvSlNo = @Prefix + RIGHT('0000' + CAST(@TaxInvNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO dbo.TaxInvHdr
        (
            CompanyId,
            BranchId,

            SOHdrId,
            OrdClientHdrId,
           
            TaxInvType,
            TaxInvNo,
            TaxInvSLNo,
            TaxInvDate,

            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,
            
            TaxInvProductAmount,
            TaxInvDiscountPercentage,
            TaxInvDiscountAmount,
            TaxInvTaxPercentage,
            
            ItemTotalAmount,
            TaxInvSubTotal,
            TaxInvTaxAmount,
            TaxInvGrandTotal,
            
            CreatedUserId,
            CreatedDate

        )
        SELECT
            @CompanyId,
            @BranchId,

            SOHdrId,
            OrdClientHdrId,
            TaxType,
            @TaxInvNo,

            @TaxInvSlNo,             --TaxInvSLNo,
            TaxInvDate,

            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            TaxProductAmount,
            TaxDiscountPercentage,
            TaxDiscountAmount,
            TaxTaxPercentage,
            ItemTotalAmount,
            
            TaxSubTotal,
            TaxTaxAmount,
            TaxGrandTotal,

            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@TaxInv,'$.TaxInvHdr')
        WITH
        (
            SOHdrId                INT,
            OrdClientHdrId         INT,
            TaxType                NVARCHAR(50), 
            TaxInvNo               NVARCHAR(50),
            TaxInvSLNo             INT,
            TaxInvDate             DATE,

            DeliveryAddress        NVARCHAR(200), 
            DeliveryContactPerson  NVARCHAR(100), 
            DeliveryMobileId       NVARCHAR(100), 

            TaxProductAmount       DECIMAL(18,2),
            TaxDiscountPercentage  DECIMAL(18,2),
            TaxDiscountAmount      DECIMAL(18,2),
            TaxTaxPercentage       DECIMAL(18,2),
            ItemTotalAmount             DECIMAL(18,2),

            TaxSubTotal            DECIMAL(18,2),
            TaxTaxAmount           DECIMAL(18,2),
            TaxGrandTotal          DECIMAL(18,2),

            CreatedUserId          INT,
            CreatedDate            DATE
        );

        SET @TaxInvHdrId = SCOPE_IDENTITY();

        ------------------------------------------------------------
        -- Insert Details
        ------------------------------------------------------------
        INSERT INTO dbo.TaxInvDtl
        (
            TaxInvHdrId,
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
            @TaxInvHdrId,
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

        FROM OPENJSON(@TaxInv,'$.TaxInvDtl')
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