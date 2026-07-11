USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertProformaInv]    Script Date: 11/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertProformaInv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertProformaInv]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertProformaInv]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertProformaInv]
(
	@ProformaInv NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @ProformaInvHdrId INT

	BEGIN TRANSACTION

    Declare @CompanyId int
	Declare @BranchId int
	Declare @ProformaInvNo int
	Declare @ProformaInvSlNo nvarchar(50)
    Declare @Prefix nvarchar(50)


    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'ProformaInv' and DefaultDataType = 'Prefix' and DefaultDataOrderBy = 1 )
 --   --set @EnqDtlId = (Select EnqDtlId from EnqDtl where EnqHdrId = @EnqHdrId)

	select @ProformaInvNo = max(ProformaInvNo) from ProformaInvHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @ProformaInvNo = 0 or @ProformaInvNo is NULL
		set @ProformaInvNo = 1
	else
		set @ProformaInvNo = @ProformaInvNo + 1

	set @ProformaInvSlNo = @Prefix + RIGHT('00' + CAST(@ProformaInvNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	INSERT INTO dbo.ProformaInvHdr
        (
            CompanyId,
            BranchId,

            SOHdrId,
            OrdClientHdrId,
            
            EmpId,
            ProformaType,
            ProformaInvNo,
            ProformaInvSLNo,
            ProformaInvDate,

            BillingAddress,
            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            CustPONo,
            CustPODate,
            ProformaInvRemarks,

            ProformaProductAmount,
            ProformaDiscountPercentage,
            ProformaDiscountAmount,
            ProformaTaxPercentage,
            
            ItemTotalAmount,
            ProformaSubTotal,
            ProformaTaxAmount,
            ProformaGrandTotal,
            
            CreatedUserId,
            CreatedDate

        )
        SELECT
            @CompanyId,
            @BranchId,

            SOHdrId,
            OrdClientHdrId,
            EmpId,
            ProformaType,
            @ProformaInvNo,

            @ProformaInvSlNo,             --ProformaInvSLNo,
            ProformaInvDate,

            BillingAddress,
            DeliveryAddress,
            DeliveryContactPerson,
            DeliveryMobileId,

            CustPONo,
            CustPODate,
            ProformaInvRemarks,

            ProformaProductAmount,
            ProformaDiscountPercentage,
            ProformaDiscountAmount,
            ProformaTaxPercentage,
            ItemTotalAmount,
            
            ProformaSubTotal,
            ProformaTaxAmount,
            ProformaGrandTotal,

            CreatedUserId,
            CreatedDate

        FROM OPENJSON(@ProformaInv,'$.ProformaInvHdr')
        WITH
        (
            SOHdrId                     INT,
            OrdClientHdrId              INT,
            EmpId                       INT,
            ProformaType                NVARCHAR(50), 
            ProformaInvNo               NVARCHAR(50),
            ProformaInvSLNo             INT,
            ProformaInvDate             DATE,

            BillingAddress              NVARCHAR(200),
            DeliveryAddress             NVARCHAR(200), 
            DeliveryContactPerson       NVARCHAR(100), 
            DeliveryMobileId            NVARCHAR(100), 

            CustPONo                    NVARCHAR(50),
            CustPODate                  DATE,
            ProformaInvRemarks          NVARCHAR(1000),

            ProformaProductAmount       DECIMAL(18,2),
            ProformaDiscountPercentage  DECIMAL(18,2),
            ProformaDiscountAmount      DECIMAL(18,2),
            ProformaTaxPercentage       DECIMAL(18,2),
            ItemTotalAmount             DECIMAL(18,2),

            ProformaSubTotal            DECIMAL(18,2),
            ProformaTaxAmount           DECIMAL(18,2),
            ProformaGrandTotal          DECIMAL(18,2),

            CreatedUserId               INT,
            CreatedDate                 DATE
        );

        SET @ProformaInvHdrId = SCOPE_IDENTITY();

        ------------------------------------------------------------
        -- Insert Details
        ------------------------------------------------------------
        INSERT INTO dbo.ProformaInvDtl
        (
            ProformaInvHdrId,
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
            @ProformaInvHdrId,
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

        FROM OPENJSON(@ProformaInv,'$.ProformaInvDtl')
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