USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStocksInward]    Script Date: 16/05/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateStocksInward]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_UpdateStocksInward]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStocksInward]    Script Date: 16/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateStocksInward]
(
    @StocksInwardHdrId int,
	@StocksInwardUpdate NVARCHAR(MAX)

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	--DECLARE @POHdrId INT

	BEGIN TRANSACTION

	UPDATE SIH
        SET
            --SIH.CompanyId              = J.CompanyId
            --, SIH.BranchId               = J.BranchId
              SIH.VendorHdrId            = J.VendorHdrId
            , SIH.WareHouseId            = J.WareHouseId
            , SIH.EmpId                  = J.EmpId
            , SIH.StockInwardType        = J.StockInwardType
            , SIH.StockInwardNo          = J.StockInwardNo

            , SIH.StockInwardSLNo        = J.StockInwardSLNo
            , SIH.StockInwardDate        = J.StockInwardDate
            , SIH.InvoiceNo              = J.InvoiceNo
            , SIH.InvoiceDate            = J.InvoiceDate
            
            , SIH.DCNo                   = J.DCNo
            , SIH.OrderNo                = J.OrderNo
            
            , SIH.PONo                   = J.PONo
            , SIH.ESugamNo               = J.ESugamNo

            , SIH.TransportName          = J.TransportName
            , SIH.VehicleType            = J.VehicleType
            , SIH.VehicleNo              = J.VehicleNo
            
            , SIH.ContactPerson          = J.ContactPerson
            , SIH.ContactMobile          = J.ContactMobile
            , SIH.ContactEmailId         = J.ContactEmailId
            , SIH.CreditDate             = J.CreditDate
            
            , SIH.SIProductAmount        = J.SIProductAmount
            , SIH.SIDiscountPercentage   = J.SIDiscountPercentage
            , SIH.SIDiscountAmount       = J.SIDiscountAmount
            , SIH.SITaxPercentage        = J.SITaxPercentage
            , SIH.ItemTotalAmount        = J.ItemTotalAmount
            , SIH.SISubTotal             = J.SISubTotal
            , SIH.SITaxAmount            = J.SITaxAmount
            , SIH.SIGrandTotal           = J.SIGrandTotal

            , SIH.ModifiedUserId         = J.ModifiedUserId
            , SIH.ModifiedDate           = J.ModifiedDate

        FROM dbo.StocksInwardHdr SIH

        INNER JOIN OPENJSON(@StocksInwardUpdate, '$.StocksInwardHdr')
        WITH
        (
              StocksInwardHdrId        INT
            --, CompanyId                INT
            --, BranchId                 INT
            , VendorHdrId              INT
            , WareHouseId              INT
            , EmpId                    INT
            , StockInwardType          NVARCHAR(50)
            , StockInwardNo            NVARCHAR(50)
            , StockInwardSLNo          NVARCHAR(50)
            , StockInwardDate          DATE

            , InvoiceNo                NVARCHAR(100)
            , InvoiceDate              DATE

            , DCNo                     NVARCHAR(100)
            , OrderNo                  NVARCHAR(100)
            , PONo                     NVARCHAR(100)
            , ESugamNo                 NVARCHAR(100)
            
            , TransportName            NVARCHAR(200)
            , VehicleType              NVARCHAR(50)
            , VehicleNo                NVARCHAR(50)
            
            , ContactPerson            NVARCHAR(100)
            , ContactMobile            NVARCHAR(20)
            , ContactEmailId           NVARCHAR(100)
            , CreditDate               DATE
            
            , SIProductAmount          DECIMAL(18,2)
            , SIDiscountPercentage     DECIMAL(18,2)
            , SIDiscountAmount         DECIMAL(18,2)
            , SITaxPercentage          DECIMAL(18,2)
            , ItemTotalAmount          DECIMAL(18,2)
            , SISubTotal               DECIMAL(18,2)
            , SITaxAmount              DECIMAL(18,2)
            , SIGrandTotal             DECIMAL(18,2)
            , ModifiedUserId           INT
            , ModifiedDate             DATE
        ) J

        ON SIH.StocksInwardHdrId = J.StocksInwardHdrId;

        ----------- Update Detail

        UPDATE D
        SET
            D.ItemId                   = J.ItemId,
            D.ItemDescription          = J.ItemDescription,

            D.ItemQty                  = J.ItemQty,
            D.InwardQty                = J.InwardQty,
            D.AcceptedQty              = J.AcceptedQty,

            D.ItemRate                 = J.ItemRate,
            D.ItemAmount               = J.ItemAmount,

            D.ItemDiscountPercentage   = J.ItemDiscountPercentage,
            D.ItemDiscountAmount       = J.ItemDiscountAmount,
            D.TaxPercentage            = J.TaxPercentage,
            D.TaxAmount                = J.TaxAmount,
            D.ItemTotalAmount          = J.ItemTotalAmount,

            D.ModifiedUserId           = J.ModifiedUserId,
            D.ModifiedDate             = J.ModifiedDate


        FROM dbo.StocksInwardDtl D
        INNER JOIN
        (
            SELECT *
            FROM OPENJSON(@StocksInwardUpdate, '$.StocksInwardDtl')
            WITH
            (
                StocksInwardDtlId       INT,
                ItemId                  INT,
                ItemDescription         NVARCHAR(500),
                ItemQty                 DECIMAL(18,2),
                InwardQty               DECIMAL(18,2),
                AcceptedQty             DECIMAL(18,2),
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
        ON D.StocksInwardDtlId = J.StocksInwardDtlId;
    

    Select @StocksInwardHdrId

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