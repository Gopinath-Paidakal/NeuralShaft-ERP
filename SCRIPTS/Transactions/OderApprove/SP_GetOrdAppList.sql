USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetOrdAppList]    Script Date: 04/04/2026 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetOrdAppList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetOrdAppList]
GO

USE [NSERPLIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetOrdAppList]    Script Date: 04/04/2026  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetOrdAppList]
--(
--	--@FromDate date,
--	--@ToDate date
--	--@Status nvarchar(50)
--)
----With Encryption
AS

SET NOCOUNT ON;

BEGIN TRY
	-- BEGIN TRANSACTION
			
		
		Declare @Status nvarchar(50)

		set @Status = 'SentForApproval'

		if (@Status = upper('SENTFORAPPROVAL'))
		BEGIN
			SELECT
			  -- [OrdApprove].[OrdApproveId]
			  --,[OrdApprove].[OrdClientHdrId]
			  [EnqDtl].[EnqHdrId]
			  ,[EnqDtl].[EnqDtlId]
			  ,[EnqDtl].[QuoteHdrId]

			  ,[OrdClientHdr].[OrdClientHdrId]
			  ,[OrdClientHdr].[OrdConsultant]
			  ,[OrdClientHdr].[OrdClientName]
			  ,[OrdClientHdr].[OrdClientTitle]
			  ,[OrdClientHdr].[OrdGstTradeName]
			  ,[OrdClientHdr].[OrdGstNo]

			  ----,[OrdApprove].[OrdStatus]    
			  --,[OrdApprove].[OrdApproved]    

			 , [EnqDtl].[TaxableValue]
			  ,[EnqDtl].[EnqSubTotal]
			  ,[EnqDtl].[EnqTaxAmount]
			  ,[EnqDtl].[EnqGrandTotal]

			  ,[EnqDtl].[CustomerStatus]
			  ,[EnqDtl].[OrderStatus]
			  ,[EnqDtl].[ApprovalStatus1]
			  ,[EnqDtl].[ApprovalStatus2]

			  ,[EnqHdr].EnqNo
			  ,[QuoteHdr].QuoteNo
			  ,FORMAT([OrdApprove].[CreatedDate], 'dd-MM-yyyy') as [CreatedDate]
      
		  FROM [dbo].[OrdApprove]
  
		  Inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = OrdApprove.OrdClientHdrId
		  Inner Join EnqDtl On Enqdtl.EnqDtlId = OrdApprove.EnqDtlId
		  Inner Join EnqHdr on EnqDtl.EnqHdrId = EnqHdr.EnqHdrId
		  Inner Join QuoteHdr on QuoteHdr.QuoteHdrId = OrdApprove.QuoteHdrId

		  --WHERE [OrdApprove].[CreatedDate] >= @FromDate AND [OrdApprove].[CreatedDate] < DATEADD(DAY, 1, @ToDate)

		  and [EnqDtl].[OrderStatus] = 'SentForApproval' and [EnqDtl].[SOGen] = 0
  
		  FOR JSON PATH, ROOT('OrdAprList')
		END


		

  -- COMMIT TRANSACTION


END TRY

	BEGIN CATCH
		--  ROLLBACK TRANSACTION
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



--if (@Status = upper('APPROVED'))
		--BEGIN
		--	SELECT
		--	   [OrdApprove].[OrdApproveId]
		--	  ,[OrdApprove].[OrdClientHdrId]
		--	  ,[OrdApprove].[EnqHdrId]
		--	  ,[OrdApprove].[EnqDtlId]
		--	  ,[OrdApprove].[QuoteHdrId]

		--	   --[OrdClientHdrId]
		--	  ,[OrdClientHdr].[OrdConsultant]
		--	  ,[OrdClientHdr].[OrdClientName]
		--	  ,[OrdClientHdr].[OrdClientTitle]
		--	  ,[OrdClientHdr].[OrdGstTradeName]
		--	  ,[OrdClientHdr].[OrdGstNo]

		--	  --,[OrdApprove].[OrdStatus]    
		--	  ,[OrdApprove].[OrdApproved]    

		--	  ,[EnqDtl].[CustomerStatus]
		--	  ,[EnqDtl].[OrderStatus]
		--	  ,[EnqDtl].[ApprovalStatus1]
		--	  ,[EnqDtl].[ApprovalStatus2]

		--	   ,[EnqHdr].EnqNo
		--	   ,[QuoteHdr].QuoteNo

		--	  ,FORMAT([OrdApprove].[CreatedDate], 'dd-MM-yyyy') as [CreatedDate]
      
		--  FROM [dbo].[OrdApprove]
  
		--  Inner join OrdClientHdr on OrdClientHdr.OrdClientHdrId = OrdApprove.OrdClientHdrId
		--  Inner Join EnqDtl On Enqdtl.EnqDtlId = OrdApprove.EnqDtlId
		--  Inner Join EnqHdr on EnqDtl.EnqHdrId = EnqHdr.EnqHdrId
		--  Inner Join QuoteHdr on QuoteHdr.QuoteHdrId = OrdApprove.QuoteHdrId

		--  WHERE [OrdApprove].[CreatedDate] >= @FromDate AND [OrdApprove].[CreatedDate] < DATEADD(DAY, 1, @ToDate)

		--  and [EnqDtl].[OrderStatus] = 'Approved' and [OrdApprove].[SOGen] = 0
  
		--  FOR JSON PATH, ROOT('OrdAprList')
		--END





  --where [OrdApprove].[CreatedDate] >= @FromDate and [OrdApprove].[CreatedDate] < @ToDate


  --WHERE dbo.fn_FormatDate([OrdApprove].[CreatedDate]) >= dbo.fn_FormatDate(@FromDate)
  --and  dbo.fn_FormatDate([OrdApprove].[CreatedDate]) <= dbo.fn_FormatDate(@ToDate)


--Declare @SOGen int

	--set @SOGen = (select sogen from OrdApprove where OrdApprove.OrdApproveId = @OrdApproveId and
	--				EnqHdr.EnqHdrId = OrdApprove.EnqHdrId 
	--				and EnqDtl.EnqDtlId = OrdApprove.EnqDtlId)
