Declare @QuoteDtl nvarchar(max)

Declare @QuoteQty DECIMAL(18,2)
Declare @QuoteRate DECIMAL(18,2)

Declare @QuoteTotalAmount DECIMAL(18,2) = 10000.00
Declare @QuoteTax DECIMAL(18,2) = 1800.00  
Declare @GrandTotalAmount DECIMAL(18,2) = 11800.00

-----------------------------------------------------------
Declare @IncreaseAmount DECIMAL(18,2) = 2000.00

set @QuoteTotalAmount = (@QuoteTotalAmount + @IncreaseAmount)
set @QuoteTax = (@QuoteTotalAmount * 18 / 100)   -- 2160.00

Select @QuoteTotalAmount as 'QuoteAmount With Increase Amount', @QuoteTax 'Tax Amount'

----------------------------------------------------------

Declare @DiscountAmount DECIMAL(18,2) = 500.00
set @QuoteTotalAmount = (@QuoteTotalAmount - @DiscountAmount)
set @QuoteTax = (@QuoteTotalAmount * 18 / 100)   -- 1710.00

Select @QuoteTotalAmount as 'QuoteAmount with Discount', @QuoteTax 'Tax Amount'
---------------------------------------------------------

Declare @TaxableValue DECIMAL(18,2) = 4800.00    --- 52.00%
set @QuoteTotalAmount = @TaxableValue
set @QuoteTax = (@QuoteTotalAmount * 18 / 100)   -- 864.00

Select @QuoteTotalAmount as 'QuoteAmount with Taxable Value', @QuoteTax 'Tax Amount'
---------------------------------------------------------


set @QuoteTotalAmount = (@QuoteTotalAmount * @TaxableValue/100)   -- 5200
select @QuoteTotalAmount

Declare @QuoteTaxNew DECIMAL(18,2)
Declare @TaxableValueNew DECIMAL(18,2)
Declare @IncreaseAmountNew DECIMAL(18,2)
Declare @DiscountAmountNew DECIMAL(18,2)
Declare @GrandTotalAmountNew DECIMAL(18,2)


set @QuoteTotalAmount = (@QuoteQty * @QuoteRate)





