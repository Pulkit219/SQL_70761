USE WideWorldImporters;
GO

SELECT 
LEFT(c.CustomerName,CHARINDEX(' ', c.CustomerName)-1) AS FirstName,
SUBSTRING(c.CustomerName,CHARINDEX(' ', c.CustomerName)+1,100) AS ln,
Cityname,
StateProvinceName,
DeliveryAddressLine1,
DeliveryAddressLine2,
DeliveryPostalCode
INTO CustomerStuffv2
FROM Sales.Customers AS C
JOIN Application.Cities ci ON c.DeliveryCityID=ci.CityID
JOIN Application.StateProvinces sp ON ci.StateProvinceID=sp.StateProvinceID
JOIN Application.DeliveryMethods dm ON c.DeliveryMethodID=dm.DeliveryMethodID
WHERE BuyingGroupID IS NULL;


--with truncate, transaction is not logged hence cannot be recovered
TRUNCATE TABLE CustomerStuff

--INSERT EXEC
INSERT INTO CustomerStuffv2
EXEC Website.SearchForCustomers 'ar', 20;