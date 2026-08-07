USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertDespatch]    Script Date: 07/08/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertDespatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertDespatch]
GO

USE [NSERPLIVE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertDespatch]
(
    @DespatchAllocation nvarchar(max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	Declare @DespatchId int
	Declare @CompanyId int
	Declare @BranchId int
	Declare @DespatchNo int

BEGIN TRANSACTION;

		set @CompanyId = (Select CompanyId from Company)
		set @BranchId = (Select BranchId from Branch)

		select @DespatchNo = max(DespatchNo) from DespatchAllocation where CompanyId = @CompanyId  and  BranchId = @BranchId
		if @DespatchNo = 0 or @DespatchNo is NULL
			set @DespatchNo = 1
		else
			set @DespatchNo =@DespatchNo + 1

		--set @EnqDate = JSON_VALUE(@EnqHdr, '$.EnqHdr.CreatedDate')

		--set @EnqSlNo = 'Enq' + '/'
  --              + CONVERT(nvarchar(20), @EnqNo) + '/'
  --              --+ CONVERT(nvarchar(8), GETDATE(), 105)
		--		+ CONVERT(nvarchar(20), @EnqDate)
	
		  INSERT INTO dbo.DespatchAllocation
            (
				CompanyId,
				BranchId, 
                OrdClientHdrId,
                JobOrderNo,
				DespatchNo,
                DespatchDate,
				DespatchPlannedDate,
                DespatchStage,
                DespatchDesciption,

                Allocated1,
                Allocated2,
                AllotmentDate,
                AllocationOrder,
                AllocatedDespatch,
                
				PendingMaterials,
                DespatchStatus,

                CreatedUserId,
                CreatedDate
            )
            SELECT
				@CompanyId,	
				@BranchId,
                OrdClientHdrId,
                JobOrderNo,
				@DespatchNo,
                DespatchDate,
				DespatchPlannedDate,
                DespatchStage,
                DespatchDesciption,

                Allocated1,
                Allocated2,
                AllotmentDate,
                AllocationOrder,
                AllocatedDespatch,
                
				PendingMaterials,
                DespatchStatus,

                CreatedUserId,
                CreatedDate

            FROM OPENJSON(@DespatchAllocation, '$.DespatchAllocation')
            WITH
            (
                OrdClientHdrId      INT,
                JobOrderNo          NVARCHAR(50),
                DespatchDate        DATETIME,  
				DespatchPlannedDate DATE,
				DespatchStage       NVARCHAR(50),   
                DespatchDesciption  NVARCHAR(500),   

                Allocated1          DECIMAL(18,2), 
                Allocated2          DECIMAL(18,2),   
                AllotmentDate       DATE,            
                AllocationOrder     INT,             
                AllocatedDespatch   DECIMAL(18,2), 
				
                PendingMaterials    DECIMAL(18,2),   
				DespatchStatus      NVARCHAR(50),    
                
				CreatedUserId       INT,             
                CreatedDate         DATETIME        
            );

		set @DespatchId = SCOPE_IDENTITY()

		select @DespatchId
		
		

COMMIT TRANSACTION;

END TRY

	BEGIN CATCH

	    ROLLBACK TRANSACTION;

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

--select IDENT_CURRENT( 'Department' ) as 'Inserted'
	
	 --(@St_Code,
		--	@TalukFlag_No,
		--	@Language_No,
		--	@St_Name, 
		--	@Dist_No,
		--	@Dist_Name, 
		--	@Taluk_No,
		--	@Taluk_Name, 
		--	@Max_Revisions, 
		--	@AsstCommisoner_Name, 
		--	@AsstCommisoner_Place, 
		--	@Tahasildar_Name,
		--	@Tahasildar_Place, 
		--	@Vendor_Name, 
		--	dbo.fn_MMDDYYYY(@Scroll_Eligible_Date), 
		--	@Draft_Date,
		--	@Draft_Place, 
		--	@Amd1_Name, 
		--	@Amd1_Date, 
		--	@Amd2_Name, 
		--	@Amd2_Date, 
		--	@Amd3_Name,
		--	@Amd3_Date, 
		--	@Amd4_Name, 
		--	@Amd4_Date, 
		--	@Amd5_Name, 
		--	@Amd5_Date, 
		--	@Amd6_Name, 
		--	@Amd6_Date, 
		--	@LbPublication_Date,
		--	@LbPublication_Place, 
		--	@LbAuthorised_Person, 
		--	@LBdate, 
		--	@Created_By,
		--	getdate()
  --         )

 --        (@St_Code,
			--@TalukFlag_No,
			--@Language_No,
			--@St_Name, 
			--@Dist_No,
			--@Dist_Name, 
			--@Taluk_No,
			--@Taluk_Name, 
			--@Max_Revisions, 
			--@AsstCommisoner_Name, 
			--@AsstCommisoner_Place, 
			--@Tahasildar_Name,
			--@Tahasildar_Place, 
			--@Vendor_Name, 
			--convert(varchar,@Scroll_Eligible_Date,101), 
			--convert(varchar,@Draft_Date,101), 
			--@Draft_Place, 
			--@Amd1_Name, 
			--convert(varchar,@Amd1_Date,101),  
			--@Amd2_Name, 
			--convert(varchar,@Amd2_Date, 101), 
			--@Amd3_Name,
			--convert(varchar,@Amd3_Date, 101), 
			--@Amd4_Name, 
			--convert(varchar,@Amd4_Date, 101), 
			--@Amd5_Name, 
			--convert(varchar,@Amd5_Date, 101), 
			--@Amd6_Name, 
			--convert(varchar,@Amd6_Date, 101), 
			--convert(varchar,@LbPublication_Date,101), 
			--@LbPublication_Place, 
			--@LbAuthorised_Person, 
			--convert(varchar,@LBdate, 101), 
			--@Created_By,
			--getdate()
   --        )



