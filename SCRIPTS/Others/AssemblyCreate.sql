CREATE TABLE #TmpProduct
(
    [Landing Door] VARCHAR(200),
    [Car Door]     VARCHAR(200),
    [Cabin Type]   VARCHAR(200)
);

INSERT INTO #TmpProduct

select 

Convert(nvarchar(10),DoorHeight) + 'MM X ' + 
Convert(nvarchar(10),DoorWidth) + 'MM - ' +
Convert(nvarchar(100), ISNULL(rtrim(DoorOpening), '')) + ' - ' + 
Convert(nvarchar(100), ISNULL(rtrim(DoorFinish), '')) as 'Landing Door',

Convert(nvarchar(10),CarDoorHeight) + 'MM X ' + 
Convert(nvarchar(10),CarDoorWidth) + 'MM - ' +
Convert(nvarchar(100),ISNULL(rtrim(CarDoorOpening),'')) + ' - ' +
Convert(nvarchar(100),ISNULL(rtrim(CarDoorFinish), '')) as 'Car Door',

Convert(nvarchar(10),CabinHeight) + 'MM X ' + 
Convert(nvarchar(10),CabinWidth) + 'MM X ' +
Convert(nvarchar(10),CabinHeight) + 'MM -  ' +
Convert(nvarchar(100),ISNULL(rtrim(FlooringType), '')) + ' - ' + 
Convert(nvarchar(100),ISNULL(rtrim(SOFalseCeilingType), '')) + ' - ' + 
Convert(nvarchar(100),ISNULL(rtrim(EnqCabinType),''))  as 'Cabin Type'

from SoDtl

INSERT INTO Product (ProdName, ProdType)
SELECT 
    X.ProductName,
    'Assembly' AS ProductType
FROM #TmpProduct T
CROSS APPLY (VALUES
    (T.[Landing Door]),
    (T.[Car Door]),
    (T.[Cabin Type])
) X(ProductName)
WHERE X.ProductName IS NOT NULL
  AND X.ProductName <> '';

---- Check result
SELECT ProdId, ProdName, ProdType  FROM Product where ProdType = 'Assembly';

---- Drop temp table
DROP TABLE #TmpProduct;



----------------- Insert data from Stock_ImportToSql to Product
insert into [Product] 
(
    CatgId, CatgName, ProdGrpId, ProdGrpName, ProdType, ProdCode, HSNCode, ProdName  
)
select CategoryId, CATEGORY_NAME, ProductGroupId, PRODUCT_GROUP_NAME, PRODUCT_TYPE, PRODUCT_CODE, 
       HSN_Code, ITEM_NAME
     
from Stock_ImportToSql

--Select CatgId, CatgName, ProdGrpId, ProdGrpName, ProdType, ProdCode, HSNCode, ProdName from [Product]  
--select CategoryId, CATEGORY_NAME, ProductGroupId, PRODUCT_GROUP_NAME, PRODUCT_TYPE, PRODUCT_CODE, 
--       HSN_Code, ITEM_NAME from Stock_ImportToSql























--INSERT INTO Product (ProdName)
--SELECT ProductName
--FROM #TmpProduct T
--CROSS APPLY (VALUES
--    (T.[Landing Door]),
--    (T.[Car Door]),
--    (T.[Cabin Type])
--) X(ProductName)
--WHERE ProductName IS NOT NULL
--  AND ProductName <> '';

---- Check result
--SELECT * FROM Product;

---- Drop temp table
--DROP TABLE #TmpProduct;




--INSERT INTO Product (ProductName)
--SELECT V.ProductName
--FROM SourceTable S
--CROSS APPLY (VALUES
--    (S.[Landing Door]),
--    (S.[Car Door]),
--    (S.[Cabin Type])
--) V(ProductName)
--WHERE V.ProductName IS NOT NULL
--  AND V.ProductName <> '';




--SELECT Id, Value
--FROM SourceTable
--UNPIVOT
--(
--    Value FOR ColName IN (Col1, Col2, Col3)
--) u;

--- OR

--SELECT Id, Col1 AS Value FROM SourceTable
--UNION ALL
--SELECT Id, Col2 FROM SourceTable
--UNION ALL
--SELECT Id, Col3 FROM SourceTable;

