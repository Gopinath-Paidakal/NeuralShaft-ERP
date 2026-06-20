USE [NSHAFTERPDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SP_UpdateDefaultData]
		@DefaultDataId = 76,
		@DefaultData = N'{
  "DefaultData": [
    {
      "DefaultDataId": 1,
      "FormType": "Lift",
      "DefaultDataType": "Professional",
      "DefaultProductWidth": 1000,
      "DefaultProductDepth": 1200,
      "DefaultDataName": "Premium order Lift",
      "DefaultDataDesc": "Updated order model",
      "DefaultDataStatus": "A",
      "Price": 85000,
      "DefaultTotalStops": 6,
      "DefaultCapacity": 8,
      "DefaultWeight": 600,
      "DefaultNoStopPrice": 200,
      "DouEntType": "Y",
      "DouEntPrice901st": 250,
      "DouEntPrice902nd": 350,
      "DouEntPrice1801st": 450,
      "DouEntPrice1802nd": 550,
      "DouEntPrice1803rd": 650,
      "DefaultCabinWidth": 100,
      "DefaultCabinDepth": 300,
      "DefaultCabinHeight": 300,
      "ShaftTypeWidth": 600,
      "ShaftTypeDepth": 600,
      "ElevatorSpeed": 1.75,
      "DefaultOverheadHeight": 3200,
      "DefaultElevatorPit": 1600,
      "DefaultMaxFloors": 12,
      "DefaultMinWidthSingle": 950,
      "DefaultMinDepthSingle": 950,
      "DefaultMinWidthDouble": 250,
      "DefaultMinDepthDouble": 250,
      "DefaultMinWidthTriple": 550,
      "DefaultMinDepthTriple": 550,
      "DefaultDataOrderBy": 1
    }
  ]
}'

SELECT	'Return Value' = @return_value

GO
