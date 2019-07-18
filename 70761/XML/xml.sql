USE AdventureWorks2017;
GO

--query xml data type using xquery

SELECT p.Name,
		p.ProductNumber,
		pm.Instructions.query('declare namespace AW="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions";AW:root/AW:Location[@LaborHours > 3]') AS Locations
FROM Production.Product p
JOIN Production	.ProductModel pm ON p.ProductModelID=pm.ProductModelID
WHERE pm.Instructions IS NOT NULL;



--transform relational data to XML using FOR XML RAW
SELECT  c.CustomerID,
		FirstName,
		LastName,
		(SELECT SUM(Subtotal) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS TotalSales,
		(SELECT MIN(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS FirstorderDate,
		(SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS LastorderDate
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE LastName = 'Smith'
ORDER BY CustomerID
FOR XML RAW--, ELEMENTS

SELECT  c.CustomerID,
		FirstName,
		LastName,
		(SELECT SUM(Subtotal) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS TotalSales,
		(SELECT MIN(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS FirstorderDate,
		(SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS LastorderDate
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE LastName = 'Smith'
ORDER BY CustomerID
FOR XML RAW, ELEMENTS



--transform relational data to XML using FOR XML AUTO
--XML AUTO actually structures data according to query, like creating child element like HTML
SELECT  c.CustomerID,
		FirstName,
		LastName,
		(SELECT SUM(Subtotal) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS TotalSales,
		(SELECT MIN(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS FirstorderDate,
		(SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS LastorderDate
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE LastName = 'Smith'
ORDER BY CustomerID
FOR XML AUTO;


--a bit different structure with XML AUTO
SELECT  c.CustomerID,
		FirstName,
		LastName,
		TotalSales,
		FirstOrderDate,
		LastOrderDate
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN (SELECT CustomerID, SUM(SubTotal) AS TotalSales, MIN(OrderDate) AS FirstOrderDate, MAX(OrderDate) AS LastOrderDate 
		FROM Sales.SalesOrderHeader 
		GROUP BY CustomerID)soh ON c.CustomerID = soh.CustomerID
WHERE LastName = 'Smith'
ORDER BY CustomerID
FOR XML AUTO;


--transform relational data to XML using FOR XML PATH
SELECT c.CustomerID AS "@CustomerID",
		FirstName,
		LastName,
		TotalSales AS "SalesInfo/@TotalSales",
		FirstOrderDate AS "SalesInfo/FirstOrderDate",
		LastOrderDate AS "SalesInfo/RecentOrderDate"
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN (SELECT CustomerID	, SUM(Subtotal) as TotalSales,MIN(OrderDate) AS FirstOrderDate, MAX(OrderDate) AS LastOrderDate 
		FROM Sales.SalesOrderHeader
		GROUP BY CustomerID) soh ON c.CustomerID =soh.CustomerID
WHERE LastName ='Smith'
ORDER BY c.CustomerID
FOR XML PATH('Customer'), ROOT('CustomerSalesInfo');