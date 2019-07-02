--TABLE expression that produce temporary result
/* 
Virtually, not physically stored

Simplifying and modularizing code
4 types
Common table expressions
Inline table-values functions
derived tables
Views


*/
USE AdventureWorks2017;
GO

--Basic CTE
WITH BikeProducts_CTE AS(
SELECT p.*
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID=psc.ProductSubcategoryID
WHERE psc.Name LIKE '%bike%'
)

SELECT * FROM BikeProducts_CTE;


--Standard CTE, make sure while creating CTE if you're specifying columns then it must align with columns of(subquery inside)
WITH SalesTotals_CTE (SalesPerson, TotalSales) AS
(
	SELECT SalesPersonID, ROUND(SUM(SubTotal),2)
	FROM Sales.SalesOrderHeader
	WHERE SalesPersonID IS NOT NULL
	GROUP BY SalesPersonID)

SELECT sp.FirstName, sp.LastName, TotalSales
FROM Sales.vSalesPerson sp
JOIN SalesTotals_CTE st ON sp.BusinessEntityID=st.SalesPerson
ORDER BY TotalSales DESC;


--Multiple CTE, defining multiple seperated by comma
WITH Person_CTE (Person, FirstName, LastName)
AS(SELECT BusinessEntityID, FirstName, LastName FROM Person.Person),
Email_CTE(Person, EmailAddress)
AS(SELECT BusinessEntityID,EmailAddress FROM Person.EmailAddress)

SELECT FirstName, LastName, EmailAddress
FROM Person_CTE p
JOIN Email_CTE e ON p.Person=e.Person
WHERE FirstName LIKE 's%' AND LastName LIKE 's%';

--Recursive CTE
WITH Materials_CTE(ProductID, ProductName, Quantity, Level, Sort)
AS(

--anchor memeber
SELECT ProductID, CAST(Name AS VARCHAR(100)), 1, 1, CAST(Name as VARCHAR(100))
FROM Production.Product p
JOIN Production.BillOfMaterials bm ON p.ProductID=bm.ComponentID AND bm.ProductAssemblyID IS NULL

UNION ALL

--recursive member

SELECT
	p.ProductID, CAST(REPLICATE('-->',cte.Level) + p.Name AS VARCHAR(100)),
	CAST(bm.PerAssemblyQty AS INT),
	cte.Level +1,
	CAST(cte.Sort + '>' + p.Name AS VARCHAR(100))
FROM Materials_CTE cte
JOIN Production.BillOfMaterials bm ON bm.ProductAssemblyID = cte.ProductID
JOIN Production.Product p ON bm.ComponentID =p.ProductID
)

SELECT * FROM Materials_CTE ORDER BY Sort;