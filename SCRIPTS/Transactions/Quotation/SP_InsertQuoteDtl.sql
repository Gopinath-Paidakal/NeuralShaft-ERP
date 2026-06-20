USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteHdr]    Script Date: 26/03/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertQuoteHdr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertQuoteHdr]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertQuoteHdr]    Script Date: 26/03/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertQuoteHdr]
(
	@EnqHdrId nvarchar(Max)
    --@EnqDtlId int

)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY


	Declare @CompanyId int
	Declare @BranchId int
	Declare @QuoteNo int
	Declare @QuoteSlNo nvarchar(50)
    Declare @ClosingDays smallint
    Declare @QuoteHdrId int   
    
    --- default Data
    Declare @QuotePaymentTerms nvarchar(500)
    Declare @QuoteValidity smallint
    Declare @DeliveryBy smallint
    Declare @ComplementaryAMC smallint
    Declare @QuoteSpecialFeatures nvarchar(1000)
    
    Declare @Prefix nvarchar(50)

	BEGIN TRANSACTION
	
    set @CompanyId = (Select CompanyId from Company)
	set @BranchId = (Select BranchId from Branch)

    set @Prefix = (select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Prefix')

	select @QuoteNo = max(QuoteNo) from QuoteHdr where CompanyId = @CompanyId  and  BranchId = @BranchId
	if @QuoteNo = 0 or @QuoteNo is NULL
		set @QuoteNo = 1
	else
		set @QuoteNo =@QuoteNo + 1

	set @QuoteSlNo = @Prefix + RIGHT('0000' + CAST(@QuoteNo AS VARCHAR(10)), 5) + '/'            
	                 + RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

    --- Setting the values from default data for quotation Header
    set @QuotePaymentTerms = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'PaymentTerms' and DefaultDataOrderBy = 1)
    set @QuoteValidity = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'QuoteValidity' and DefaultDataOrderBy = 1)
    set @DeliveryBy = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'DeliveryBy' and DefaultDataOrderBy = 1)
    set @ComplementaryAMC = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'ComplementaryAMC' and DefaultDataOrderBy = 1)
    set @QuoteSpecialFeatures = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'SpecialFeatures' and DefaultDataOrderBy = 1)
     

    INSERT INTO [dbo].[QuoteHdr]
           ([CompanyId]
           ,[BranchId]
           ,[EnqHdrId]
           ,[QuoteNo]
           ,[QuoteDate]

           ,[QuoteSlNo]
           ,[QuoteConsultant]
           ,[QuoteCustComp]
           ,[QuoteBillingAddr]
           ,[QuoteContPerson]
           
           ,[QuoteMobileNo]
           ,[QuoteEmailId]
           ,[QuotePaymentTerms]
           ,[QuoteValidity]
           ,[DeliveryBy]

           ,[ComplementaryAMC]
           ,[GSTExempted]
           ,[CreatedUserId]
           ,[CreatedDate])

     VALUES
           (@CompanyId
           ,@BranchId 
           ,@EnqHdrId 
           ,@QuoteNo 
           ,getdate()         --CreatedDate

           ,@QuoteSlNo 
           ,(Select EnqConsultant from EnqClient where EnqHdrId = @EnqHdrId)
           ,(Select EnqClientName from EnqClient where EnqHdrId = @EnqHdrId)
           ,(Select EnqClientAddress from EnqClient where EnqHdrId = @EnqHdrId)
           ,(Select EnqContactPerson from EnqClient where EnqHdrId = @EnqHdrId)

           ,(Select EnqClientMobileNo EnqConsultant from EnqClient where EnqHdrId = @EnqHdrId)
           ,(Select EnqClientEmailId from EnqClient where EnqHdrId = @EnqHdrId)
           ,@QuotePaymentTerms 
           ,@QuoteValidity 
           ,@DeliveryBy
          
           ,@ComplementaryAMC
           ,0     -- GST Exempted
           ,(Select CreatedUserId from EnqHdr where EnqHdrId = @EnqHdrId)
           ,getdate() 
           ) 


           set @QuoteHdrId = SCOPE_IDENTITY()

           ----------------------------------------------
           -- Updating the Enq detail with Quote Header Id
           ----------------------------------------------
           Update EnqDtl set QuoteHdrId = @QuoteHdrId where EnqDtl.EnqHdrId = @EnqHdrId
           ----------------------------------------------

           -------------------------------------------
           -- Updating the Enq Header with quotation No
           -------------------------------------------
           Update EnqHdr set QuoteNo = @QuoteNo  where EnqHdr.EnqHdrId = @EnqHdrId                        
                            

           ----------------------------------------------------------------
           -- Updating Enquiry Client when Quote Header Updated 15/06/2026
           -----------------------------------------------------------------
           Update EnqClient Set EnqConsultant = (Select QuoteConsultant from QuoteHdr where QuoteHdrId = @QuoteHdrId),
                             EnqClientName = (Select QuoteCustComp from QuoteHdr where QuoteHdrId = @QuoteHdrId),
                             EnqClientAddress = (Select QuoteBillingAddr from QuoteHdr where QuoteHdrId = @QuoteHdrId),
                             EnqContactPerson = (Select QuoteContPerson from QuoteHdr where QuoteHdrId = @QuoteHdrId),
                             EnqClientMobileNo = (Select QuoteMobileNo from QuoteHdr where QuoteHdrId = @QuoteHdrId) 

           -------------------------------------------
           -- Updating Product Count from EnqHdr
           -------------------------------------------
           Update QuoteHdr set ProductCount = (select count(*) from Enqdtl where EnqHdrId = @EnqHdrId)

            -------------=====================================================
			------ Inserting Amount in Quote Header after adding Product
            ----------------=====================================================
            --Declare @QuoteAmount numeric(18,2)
            --Declare @QuoteTaxAmount numeric(18,2)
            --Declare @QuoteTotalAmount numeric(18,2)
            
            --set @QuoteAmount = (select QuoteAmount from QuoteHdr where 
            --QuoteTaxAmount
            --QuoteTotalAmount

            --Update QuoteAmount QuoteTaxAmount, QuoteTotalAmount

      Select @QuoteHdrId

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


  --Declare @ProductAmount numeric(18,2)
            --Declare @FloorNameAmount	numeric(18,2)
            --Declare @DoorTypeAmount	numeric(18,2)
            --Declare @CarDoorTypeAmount	numeric(18,2)
            --Declare @DoorFinishAmount	numeric(18,2)
	
            --Declare @CabinTypeAmount numeric(18,2)
            --Declare @FlooringTypeAmount numeric(18,2)
            --Declare @AddnlFeatureAmount numeric(18,2)

            --Declare @ProductAmount1 numeric(18,2)
            --Declare @TaxAmount  numeric(18,2)
            --Declare @TotalAmount numeric(18,2)

            -------- Calculate Quote amount with Tax
            --set @ProductAmount = (Select ProductAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @FloorNameAmount = (Select FloorNameAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @DoorTypeAmount = (Select DoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @CarDoorTypeAmount = (Select CarDoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @DoorFinishAmount = (Select DoorFinishAmount from EnqDtl where EnqHdrId = @EnqHdrId)

            --set @CabinTypeAmount = (Select CabinTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @FlooringTypeAmount = (Select FlooringTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
            --set @AddnlFeatureAmount = (Select AddnlFeatureAmount from EnqDtl where EnqHdrId = @EnqHdrId)


            --set @ProductAmount1 = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
            --                        + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

            --set @TaxAmount = (@ProductAmount1 + 18.00/100)

            --    set @TotalAmount = @ProductAmount1 + @TaxAmount

            --Select @ProductAmount1, @TotalAmount

            --update QuoteHdr set QuoteAmount = @ProductAmount1, 
            --                    QuoteTaxAmount = @TaxAmount, 
            --                    QuoteTotalAmount = @TotalAmount 

            --                    where QuoteHdrId = @QuoteHdrId




 -------  EnqClient
    --Declare @EnqConsultant nvarchar(100)
    --Declare @EnqClientName nvarchar(100)
    --Declare @EnqClientAddress nvarchar(100)
    --Declare @EnqContactPerson nvarchar(100)
    --Declare @EnqClientMobileNo nvarchar(100)
    --Declare @EnqClientEmailId nvarchar(100)
    --Declare @EnqGSTExempted bit

 -- Setting the values from EnqClient
    --set @EnqConsultant = (Select EnqConsultant from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqClientName = (Select EnqClientName from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqClientAddress = (Select EnqClientAddress from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqContactPerson = (Select EnqContactPerson from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqClientMobileNo = (Select EnqClientMobileNo EnqConsultant from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqClientEmailId = (Select EnqClientEmailId from EnqClient where EnqHdrId = @EnqHdrId)
    --set @EnqGSTExempted = (Select @EnqGSTExempted from EnqHdr where EnqHdrId = @EnqHdrId)


 	----------------=====================================================
			------ Inserting Amount in Quote Header after adding Product
            ----------------=====================================================
            	--Declare @ProductAmount numeric(18,2)
	            --Declare @FloorNameAmount	numeric(18,2)
	            --Declare @DoorTypeAmount	numeric(18,2)
	            --Declare @CarDoorTypeAmount	numeric(18,2)
	            --Declare @DoorFinishAmount	numeric(18,2)
	
	            --Declare @CabinTypeAmount numeric(18,2)
             --   Declare @FlooringTypeAmount numeric(18,2)
             --   Declare @AddnlFeatureAmount numeric(18,2)

             --   Declare @ProductAmount1 numeric(18,2)
             --   Declare @TaxAmount  numeric(18,2)
             --   Declare @TotalAmount numeric(18,2)



             --   ------ Calculate Quote amount with Tax
             --   set @ProductAmount = (Select ProductAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @FloorNameAmount = (Select FloorNameAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @DoorTypeAmount = (Select DoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @CarDoorTypeAmount = (Select CarDoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @DoorFinishAmount = (Select DoorFinishAmount from EnqDtl where EnqHdrId = @EnqHdrId)

             --   set @CabinTypeAmount = (Select CabinTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @FlooringTypeAmount = (Select FlooringTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
             --   set @AddnlFeatureAmount = (Select AddnlFeatureAmount from EnqDtl where EnqHdrId = @EnqHdrId)


	            --set @ProductAmount1 = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
             --                        + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

	            --set @TaxAmount = (@ProductAmount1 + 18.00/100)

             --   set @TotalAmount = @ProductAmount1 + @TaxAmount

	            --Select @ProductAmount1, @TotalAmount




















 --	Declare @ProductAmount numeric(18,2)
	--Declare @FloorNameAmount	numeric(18,2)
	--Declare @DoorTypeAmount	numeric(18,2)
	--Declare @CarDoorTypeAmount	numeric(18,2)
	--Declare @DoorFinishAmount	numeric(18,2)
	
	--Declare @CabinTypeAmount numeric(18,2)
 --   Declare @FlooringTypeAmount numeric(18,2)
 --   Declare @AddnlFeatureAmount numeric(18,2)

 --   Declare @ProductAmount1 numeric(18,2)
 --   Declare @TaxAmount  numeric(18,2)
 --   Declare @TotalAmount numeric(18,2)



 --   ------ Calculate Quote amount with Tax
 --   set @ProductAmount = (Select ProductAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @FloorNameAmount = (Select FloorNameAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @DoorTypeAmount = (Select DoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @CarDoorTypeAmount = (Select CarDoorTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @DoorFinishAmount = (Select DoorFinishAmount from EnqDtl where EnqHdrId = @EnqHdrId)

 --   set @CabinTypeAmount = (Select CabinTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @FlooringTypeAmount = (Select FlooringTypeAmount from EnqDtl where EnqHdrId = @EnqHdrId)
 --   set @AddnlFeatureAmount = (Select AddnlFeatureAmount from EnqDtl where EnqHdrId = @EnqHdrId)


	--set @ProductAmount1 = (@ProductAmount + @FloorNameAmount + @DoorTypeAmount + @CarDoorTypeAmount + @DoorFinishAmount
 --                        + @CabinTypeAmount + @FlooringTypeAmount + @AddnlFeatureAmount)

	--set @TaxAmount = (@ProductAmount1 + 18.00/100)

 --   set @TotalAmount = @ProductAmount1 + @TaxAmount

	--Select @ProductAmount1, @TotalAmount










 --Declare @Controller nvarchar(200)
    --Declare @Machine nvarchar(200)
    --Declare @Roping nvarchar(200)
    --Declare @PowerSupply nvarchar(200)
    --Declare @Drive nvarchar(200)   

      --set @Controller = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Controller')
    --set @Machine = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Machine')
    --set @Roping = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Roping')
    --set @PowerSupply = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'PowerSupply')
    --set @Drive = (Select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Drive')


          --,[Controller]
           --,[Machine]
           --,[Roping]
           --,[PowerSupply]
           --,[Drive]


           
           --,@Controller
           --,@Machine
           --,@Roping
           --,@PowerSupply
           --,@Drive





























  ---------------------------------------------------------
        ---- Inserting the data from Enq Detail to quotation detail
        ----------------------------------------------------------
        --INSERT INTO [dbo].[QuotDtl]
        --           (
        --           [ShaftType]
        --           ,[ShaftWidth]
        --           ,[ShaftDepth]
        --           ,[OverheadHeight]
        --           ,[ElevatorPit]
        --           ,[ElevatorSpeed]
        --           ,[EnqProduct]
        --           ,[NoOfPassengers]
        --           ,[EnqProductType]
        --           ,[Capacity]
        --           ,[TotalFloors]
        --           ,[FloorDetails]
        --           ,[NoStop]
        --           ,[NoStopDetails]
        --           ,[TotalStops]
        --           ,[NoOfOpenings]
        --           ,[PriceLess]
        --           ,[ApproxFloorHeight]
        --           ,[DoorOpening]
        --           ,[DoorFinish]
        --           ,[DoorWidth]
        --           ,[DoorHeight]
        --           ,[DoubleEntrance]
        --           ,[DoubleEntranceType]
        --           ,[DoubleEntranceTypeDetails]
        --           ,[NoOfDoorOpenings]
        --           ,[EnqCabinType]
        --           ,[CabinWidth]
        --           ,[CabinDepth]
        --           ,[CabinHeight]
        --           ,[FlooringType]
        --           ,[Handrail]
        --           ,[AdditionalFeatureName])
        --     Select
        --       [ShaftType]
        --      ,[ShaftWidth]
        --      ,[ShaftDepth]
        --      ,[OverheadHeight]
        --      ,[ElevatorPit]
        --      ,[ElevatorSpeed]
        --      ,[EnqProduct]
        --      ,[NoOfPassengers]
        --      ,[EnqProductType]
        --      ,[Capacity]
        --      ,[TotalFloors]
        --      ,[FloorDetails]
        --      ,[NoStop]
        --      ,[NoStopDetails]
        --      ,[TotalStops]
        --      ,[NoOfOpenings]
        --      ,[PriceLess]
        --      ,[ApproxFloorHeight]
        --      ,[DoorOpening]
        --      ,[DoorFinish]
        --      ,[DoorWidth]
        --      ,[DoorHeight]
        --      ,[DoubleEntrance]
        --      ,[DoubleEntranceType]
        --      ,[DoubleEntranceTypeDetails]
        --      ,[NoOfDoorOpenings]
        --      ,[EnqCabinType]
        --      ,[CabinWidth]
        --      ,[CabinDepth]
        --      ,[CabinHeight]
        --      ,[FlooringType]
        --      ,[Handrail]
        --      ,[AdditionalFeatureName]
        --      from dbo.EnqDtl


        --set @QuoteSlNo = 'Quote' + '/'
 --           + CONVERT(nvarchar(20), @QuoteNo) + '/'
 --           + CONVERT(nvarchar(8), GETDATE(), 105)
