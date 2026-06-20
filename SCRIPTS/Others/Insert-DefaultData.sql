USE [NSHAFTERPDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SP_InsertDefaultData]
		@DefaultData = N'{
  "DefaultData": [
    {
      "FormType": "Lift",
      "DefaultDataType": "Standard",
      "DefaultProductWidth": 1000,
      "DefaultProductDepth": 1200,
      "DefaultDataName": "Basic Lift",
      "DefaultDataDesc": "Standard model",
      "DefaultDataStatus": "A",
      "Price": 50000,
      "DefaultTotalStops": 5,
      "DefaultCapacity": 6,
      "DefaultWeight": 500,
      "DefaultNoStopPrice": 1000,
      "DouEntType": "Y",
      "DouEntPrice901st": 200,
      "DouEntPrice902nd": 300,
      "DouEntPrice1801st": 400,
      "DouEntPrice1802nd": 500,
      "DouEntPrice1803rd": 600,
      "DefaultCabinWidth": 1000,
      "DefaultCabinDepth": 1200,
      "DefaultCabinHeight": 2200,
      "ShaftTypeWidth": 1500,
      "ShaftTypeDepth": 1500,
      "ElevatorSpeed": 1.5,
      "DefaultOverheadHeight": 3000,
      "DefaultElevatorPit": 1500,
      "DefaultMaxFloors": 10,
      "DefaultMinWidthSingle": 900,
      "DefaultMinDepthSingle": 900,
      "DefaultMinWidthDouble": 1200,
      "DefaultMinDepthDouble": 1200,
      "DefaultMinWidthTriple": 1500,
      "DefaultMinDepthTriple": 1500,
      "DefaultDataOrderBy": 1
    }
  ]
}'

SELECT	'Return Value' = @return_value

GO
