declare @EnqUpdate nvarchar(max)

set @EnqUpdate = '

{
"EnqHdr": [
{
"EnqRefDetails": "test123",
"EnqRemarks": "test8976",
"EnqStatus": "HOT",
"Latitude": null,
"Longitude": null,
"CreatedBy": "Admin"
}
],
"EnqClient": {
"EnqConsultant": "Mr. Pavan Nagaraj",
"EnqClientName": "Jeevitha",
"EnqClientMobileNo": "9878987654",
"EnqClientEmailId": "neuralshaft@gmail.com",
"EnqClientAddress": null,
"EnqClientCategory": "Residential",
"EnqLeadSource": "Website",
"EnqSourceBy": "BDE_Akash",
"EnqContactPerson": "NeuralShaft"
},
"EnqDtl": [
{
"IsNew": true,
"EnqDtlId": null,
"ShaftType": "WALL RCC",
"ShaftWidth": 1500,
"ShaftDepth": 1500,
"OverheadHeight": 4500,
"ElevatorPit": 1500,
"ElevatorSpeed": 1,
"EnqProduct": "MRL - GLT",
"NoOfPassengers": 3,
"EnqProductType": null,
"Capacity": 204,
"TotalFloors": 3,
"FloorDetails": "G,B,1",
"NoStop": "No",
"NoStopDetails": null,
"TotalStops": 3,
"NoOfOpenings": 3,
"PriceLess": 0,
"ApproxFloorHeight": 3000,
"DoorOpening": "Auto Telescoping",
"DoorFinish": "SS Mirror Finish",
"DoorWidth": 800,
"DoorHeight": 2000,
"DoubleEntrance": null,
"DoubleEntranceType": "90",
"DoubleEntranceTypeDetails": null,
"NoOfDoorOpenings": 0,
"EnqCabinType": "Volta",
"CabinWidth": 1160,
"CabinDepth": 1250,
"CabinHeight": 2000,
"FlooringType": "Granite By Customer - 20mm Recessed Cabin Floor",
"EnqFalseCeilingType": "cvbcbc",
"Handrail": "Yes",
"AdditionalFeatureName": "Bio-Scan COP with Numlock",
"CarDoorOpening": "Auto Telescoping",
"CarDoorFinish": "SS Hairline Finish",
"CarDoorWidth": 800,
"CarDoorHeight": 2000,
"ProductAmount": 88000,
"FloorNameAmount": 17000,
"DoorTypeAmount": 7000,
"CarDoorTypeAmount": 7000,
"DoorFinishAmount": 117000,
"CabinTypeAmount": 7000,
"FlooringTypeAmount": 5000,
"LandingDoorFinishAmount": 45000,
"CarDoorFinishAmount": 72000,
"FalseCeilingType": 0,
"AddnlFeatureAmount": 5000,
"PowerSupply": "415 Volts, 3 Phase, 50 Hertz, Alternating Current.",
"Machine": "Gearless Motor located directly above the Lift Shaft",
"Drive": "A C Variable Voltage Variable Frequency ( Brisk Integrated - Closed Loop )",
"Controller": "Advanced Serial Integrated Communication With Intelligent Landing.",
"Operation": "Full Collective - Intelligently Analysis Landing Calls.",
"GuideRails": "9mm & 9 mm Machined Cold Drawn Guide Rails - 3 Kg/mt",
"Rope": "6.5 mm Dia Poly Eurethane Coated Steel Rope with Factor of Safety at 12 & 1.5 Million Cycle Tested",
"EnqProdSplFeature": "Testing MRL - GLT Special Features"
}
],
"EnqLandDoor": [
{
"FloorType": "G",
"LandDoorType": "Auto Telescoping",
"LandDoorFinishType": "SS Mirror Finish",
"LandDoorAngle": null,
"LandDoorSide": "Front",
"LandDoorHeight": 2000,
"LandDoorWidth": 800,
"LandDoorDepth": null,
"LandDoorDescription": null,
"LandDoorAmount": 15000
},
{
"FloorType": "B",
"LandDoorType": "Auto Telescoping",
"LandDoorFinishType": "SS Mirror Finish",
"LandDoorAngle": null,
"LandDoorSide": "Front",
"LandDoorHeight": 2000,
"LandDoorWidth": 800,
"LandDoorDepth": null,
"LandDoorDescription": null,
"LandDoorAmount": 15000
},
{
"FloorType": "1",
"LandDoorType": "Auto Telescoping",
"LandDoorFinishType": "SS Mirror Finish",
"LandDoorAngle": null,
"LandDoorSide": "Front",
"LandDoorHeight": 2000,
"LandDoorWidth": 800,
"LandDoorDepth": null,
"LandDoorDescription": null,
"LandDoorAmount": 15000
}
],
"EnqCarDoor": [
{
"FloorType": "G",
"CarDoorType": "Auto Telescoping",
"CarDoorFinishType": "SS Frameless Doors",
"CarDoorAngle": null,
"CarDoorSide": "Front",
"CarDoorHeight": 2000,
"CarDoorWidth": 800,
"CarDoorDepth": null,
"CarDoorDescription": null,
"CarDoorAmount": 45000
},
{
"FloorType": "B",
"CarDoorType": "Auto Telescoping",
"CarDoorFinishType": "SS Gold Mirror Finish",
"CarDoorAngle": null,
"CarDoorSide": "Front",
"CarDoorHeight": 2000,
"CarDoorWidth": 800,
"CarDoorDepth": null,
"CarDoorDescription": null,
"CarDoorAmount": 12000
},
{
"FloorType": "1",
"CarDoorType": "Auto Telescoping",
"CarDoorFinishType": "SS Mirror Finish",
"CarDoorAngle": null,
"CarDoorSide": "Front",
"CarDoorHeight": 2000,
"CarDoorWidth": 800,
"CarDoorDepth": null,
"CarDoorDescription": null,
"CarDoorAmount": 15000
}
]
}'

 IF ISJSON(@EnqUpdate) = 1
        SELECT 'Valid JSON' AS Result
    ELSE
        SELECT 'Invalid JSON' AS Result

--- from the json object

SELECT JSON_VALUE(@EnqUpdate, '$.EnqHdr[0].EnqStatus') AS EnqStatus

SELECT JSON_VALUE(@EnqUpdate, '$.EnqClient.EnqClientMobileNo') AS MobileNo

---- from the json array enq dtl
SELECT JSON_VALUE(@EnqUpdate, '$.EnqDtl[0].ShaftType') AS ShaftType
SELECT JSON_VALUE(@EnqUpdate, '$.EnqDtl[0].OverheadHeight') AS OverheadHeight
SELECT JSON_VALUE(@EnqUpdate, '$.EnqDtl[0].Rope') AS Rope

---- from the json array land door
SELECT JSON_VALUE(@EnqUpdate, '$.EnqLandDoor[0].LandDoorFinishType') AS LandDoorFinishType
SELECT JSON_VALUE(@EnqUpdate, '$.EnqLandDoor[1].LandDoorFinishType') AS LandDoorFinishType
SELECT JSON_VALUE(@EnqUpdate, '$.EnqLandDoor[2].LandDoorAmount') AS LandDoorAmount

SELECT JSON_VALUE(@EnqUpdate, '$.EnqCarDoor[0].LandDoorFinishType') AS CarDoorFinishType
SELECT JSON_VALUE(@EnqUpdate, '$.EnqCarDoor[1].LandDoorFinishType') AS CarDoorFinishType


SELECT 
    JSON_VALUE(value, '$.FloorType') AS FloorType,
    JSON_VALUE(value, '$.LandDoorType') AS LandDoorType,
    JSON_VALUE(value, '$.LandDoorFinishType') AS LandDoorFinishType,
    JSON_VALUE(value, '$.LandDoorAmount') AS LandDoorAmount
FROM OPENJSON(@EnqUpdate, '$.EnqLandDoor');


SELECT 
    JSON_VALUE(value, '$.FloorType') AS FloorType,
    JSON_VALUE(value, '$.CarDoorType') AS LandDoorType,
    JSON_VALUE(value, '$.CarDoorFinishType') AS LandDoorFinishType,
    JSON_VALUE(value, '$.CarDoorAmount') AS LandDoorAmount
FROM OPENJSON(@EnqUpdate, '$.EnqCarDoor');













