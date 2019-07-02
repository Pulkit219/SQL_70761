USE AdventureWorks2017;
GO


--product sales aggreagte query

SELECT
	ProductID,
	SUM(LineTotal)AS TotalSales,
	COUNT(*) AS NumberSales,
	MIN(OrderDate) AS FirstOrderDate,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY ProductID
ORDER BY TotalSales DESC;

--agggregate query into derived table
SELECT p.Name as ProductName, psc.Name AS ProductSubcategory, soa.*
FROM Production.Product p
JOIN(SELECT
	ProductID,
	SUM(LineTotal)AS TotalSales,
	COUNT(*) AS NumberSales,
	MIN(OrderDate) AS FirstOrderDate,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY ProductID)soa ON p.ProductID=soa.ProductID
JOIN
	Production.ProductSubcategory psc ON p.ProductSubcategoryID=psc.ProductSubcategoryID
ORDER BY TotalSales DESC;


/* 
Return Sales information on orders with a quantity greater than 30 using a derived table.

Columns: SalesOrderID, OrderDate, ProductID, OrderQty
Tables: Sales.SalesOrderHeader, Sales.SalesOrderDetail

Bonus: Re-write the query using a Common Table Expression

*/
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesOrderDetail;



--using CTE
WITH SOD_CTE  AS(
SELECT  SalesOrderID, ProductID, OrderQty
FROM Sales.SalesOrderDetail WHERE OrderQty >30)
--the technique used here, getting the items with more than 30 order quantity in CTE table and then using concept of JOIN
SELECT SOD_CTE.SalesOrderID, OrderDate, ProductID, OrderQty
FROM Sales.SalesOrderHeader SOH
JOIN SOD_CTE ON soh.SalesOrderID = SOD_CTE.SalesOrderID;



--using derived table
SELECT  soh.SalesOrderID, OrderDate, ProductID, OrderQty
FROM Sales.SalesOrderheader soh JOIN
(SELECT SalesOrderID, ProductID,OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty>30) so 
ON soh.SalesOrderID =so.SalesOrderID;
--the technique used here, getting the items with more than 30 order quantity in derived table and then using concept of JOIN