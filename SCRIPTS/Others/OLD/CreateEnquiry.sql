 SELECT
		  [EnqHdr].[EnqHdrId], 
          --[CompanyId],
          --[BranchId],
          [EnqHdr].[EnqNo],
          [EnqHdr].[EnqStatus],
          [EnqHdr].[QuoteNo],

          [EnqClient].EnqClientName,
          [EnqClient].EnqClientMobileNo,
          [EnqClient].EnqConsultant,


          --[EnqSlno],
          [EnqHdr].[EnqDate]
          --[EnqRefDetails],
          -- [EnqRemarks],
          
          --[Latitude],
          --[Longitude],
          --[CreatedBy],
          --[CreatedDate]

		 
		 
		


    FROM [dbo].[EnqHdr]
	INNER JOIN EnqClient ON EnqHdr.EnqHdrId = EnqClient.EnqHdrId 