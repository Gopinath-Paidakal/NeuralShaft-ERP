	Declare @QuoteNo int

	Declare @QuoteSlNo nvarchar(50)

	Declare @Prefix nvarchar(50)

	set @Prefix = (select DefaultDataName from DefaultData where FormType = 'Quotation' and DefaultDataType = 'Prefix')


select @QuoteNo = max(QuoteNo) from QuoteHdr where CompanyId = 1  and  BranchId = 1
	if @QuoteNo = 0 or @QuoteNo is NULL
		set @QuoteNo = 1
	else
		set @QuoteNo =@QuoteNo + 1

	set @QuoteSlNo = @Prefix + RIGHT('0000' + CAST(@QuoteNo AS VARCHAR(10)), 5) + '/'
            --+ CONVERT(nvarchar(20), @QuoteNo) + '/'
            -- + CONVERT(nvarchar(8), GETDATE(), 105)
			+ RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)

	select @QuoteSlNo

	--SELECT RIGHT('0000' + CAST(@QuoteNo AS VARCHAR(10)), 5)

	SELECT 
    RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR), 2) 
    + '-' + 
    RIGHT(CAST(YEAR(GETDATE()) + 1 AS VARCHAR), 2)
