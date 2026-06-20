USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertHoliday]    Script Date: 11/05/20266 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertHoliday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertHoliday]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertHoliday]    Script Date: 11/05/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertHoliday]
(
    @Holiday nvarchar(max)
)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY

	Declare @HolidayId int

BEGIN TRANSACTION;

	INSERT INTO dbo.Holiday
	(
		BranchId,
		HolidayName,
		HolidayDate,
		HoidayYear,
		HolidayStatus,

		CreatedUserId,
		CreatedDate
    
	)
	SELECT
		BranchId,
		HolidayName,
		HolidayDate,
		HoidayYear,
		HolidayStatus,

		CreatedUserId,
		CreatedDate
  
	FROM OPENJSON(@Holiday, '$.Holiday')
	WITH
	(
		BranchId int,
		HolidayName NVARCHAR(200),
		HolidayDate DATE,
		HoidayYear INT,
		HolidayStatus BIT,

		CreatedUserId INT,
		CreatedDate DATE
    
	);

set @HolidayId = SCOPE_IDENTITY()

select @HolidayId

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



