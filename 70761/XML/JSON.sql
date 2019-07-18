USE WideWorldImporters;
GO


--query and transform JSON data using JSON_value

SELECT Fullname,
		UserPreferences,
		JSON_VALUE(UserPreferences, '$.theme') AS AppTheme,
		JSON_VALUE(UserPreferences, '$.timeZone') AS TimeZone
FROM Application.People
WHERE ISJSON(UserPreferences) > 0 AND JSON_VALUE(UserPreferences, '$.timeZone') ='PST'
ORDER BY JSON_VALUE(UserPreferences, '$.theme')


--transform relational data to JSON
SELECT PersonID AS "id",
		FullName AS "person.name",
		EmailAddress AS "person.emailAddress",
		IsEmployee AS "system.isEmployee",
		IsSalesperson AS"system.isSalesPerson"
FROM Application.People
WHERE EmailAddress IS NOT NULL
FOR JSON PATH;


--insert JSON data into table

DECLARE @json NVARCHAR(MAX)
SET @json = N'[
{
	"id":1,
	"person":{
		"fullname":"john smith",
		"emailAddress":"testing@gail.com",
		"phone number: "23232q131"
		},
	"system":{
	"isEmployee": true,
	"isSales":false
	}
	}
]'
SELECT *
FROM OPENJSON(@json)
WITH
(
	PersonID int    '$.id',
	FullName nvarchar(100)   '$.person.fullname',
	EmailAddress nvarchar(100) '$.person.emailAddress',
	PhoneNumber nvarchar(10)    '$.person.phoneNumber',
	IsEmployee bit              '$.system.isEmployee',
	IsSales bit					'$.system.isSales'
);

/* A query to pull stockitems manufactured in China for Adults

Columns: StockItemName, Size, RecommendedRetailPrice
Table: Warehouse.StockItems


BONUS== Output results as XML formatted as the following:
<Stockitems>
	<Item Size="">
		<Name></Name>
		<RecommendedRetailPrice></RecommendedRetailPrice>
		<Country></Country>
	</Item>
</StockItems>


*/



SELECT StockItemName,
		Size,
		RecommendedRetailPrice,
		JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture
FROM Warehouse.StockItems
WHERE JSON_VALUE(CustomFields, '$.CountryOfManufacture')='China'
AND
JSON_VALUE(CustomFields, '$.Range') ='Adult';


--BoNUS

SELECT 
		Size AS "@Size",
		StockItemName AS "Name",
		RecommendedRetailPrice,
		JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture
FROM Warehouse.StockItems
WHERE JSON_VALUE(CustomFields, '$.CountryOfManufacture')='China'
AND
JSON_VALUE(CustomFields, '$.Range') ='Adult'
FOR XML PATH ('Item'), ROOT ('StockItems');
