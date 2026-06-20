
    DECLARE @NextItemRMNumber INT
    DECLARE @NextItemAsyNumber INT

    DECLARE @NextRMItemCode varchar(50)
    DECLARE @NextAssyItemCode varchar(50)
     
     SELECT @NextItemRMNumber =
       ISNULL(
            MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),
            4999
       ) + 1
FROM Item
WHERE ItemCode LIKE 'RM-%';

--select @NextItemRMNumber

 --SELECT @NextItemRMNumber = ISNULL(MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),0) + 1
 --      FROM Item WHERE ItemCode LIKE 'RM-%';

 --      if @NextItemRMNumber = 0 or @NextItemRMNumber is NULL
	--	set @NextItemRMNumber = 5000
	--        else
	--	set @NextItemRMNumber = @NextItemRMNumber + 1

       set @NextRMItemCode = (SELECT 'RM-' + CAST(@NextItemRMNumber AS VARCHAR(20)));

       select @NextRMItemCode


         SELECT @NextItemAsyNumber =
       ISNULL(
            MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),
            2999
       ) + 1
FROM Item
WHERE ItemCode LIKE 'ASSY-%';

  --        SELECT @NextItemAsyNumber = ISNULL(MAX(CAST(SUBSTRING(ItemCode, CHARINDEX('-', ItemCode) + 1, LEN(ItemCode)) AS INT)),0) + 1
  --     FROM Item WHERE ItemCode LIKE 'ASSY-%';

  --     if @NextItemAsyNumber = 0 or @NextItemAsyNumber is NULL
		--set @NextItemAsyNumber = 3000
	 --   else
		--set @NextItemAsyNumber = @NextItemAsyNumber + 1

       set @NextAssyItemCode = (SELECT 'ASSY-' + CAST(@NextItemAsyNumber AS VARCHAR(20)));

          select @NextAssyItemCode