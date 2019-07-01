USE AdventureWorks2017;
GO

--JOIN vs APPLY
SELECT ProductID, p.Name as ProductName, psc.Name AS SubcategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID =psc.ProductSubcategoryID;


--APPLY, it does the same as join but gets reult from derived table using SUBquery
SELECT ProductID, p.Name as ProductName, psc.Name AS SubcategoryName
FROM Production.Product p
CROSS APPLY (SELECT * FROM Production.ProductSubcategory psc WHERE p.ProductSubcategoryID = psc.ProductSubcategoryID)psc;
GO

--it's useful when using USER-defined function
CREATE FUNCTION dbo.GetSubCategory(@subcat int)
RETURNS TABLE
AS
RETURN(
SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategoryID= @subcat
)
GO
-- What this function is doing, it's going to match ProductSubcategoryID with ID from outer table JUST like JOINS

SELECT * FROM dbo.GetSubCategory(1);


--JOIN will fail here
SELECT*
FROM Production.Product p
JOIN dbo.GetSubCategory(p.ProductSubcategoryID )pscON p.ProductSubcategoryID=psc.ProductSubcategoryID


--CROSS APPLY will work here
SELECT *
FROM Production.Product p
CROSS APPLY dbo.GetSubCategory(p.ProductSubcategoryID) psc;

--OUTER APPLY, just like left , give all results from left table with NULL
SELECT *
FROM Production.Product p
OUTER APPLY dbo.GetSubCategory(p.ProductSubcategoryID) psc;


/* Challenge

Write a query using a subquery to return a list of products that have been ordered

Columns: ProductID, ProductName
Outer Table: Production.Product
Inner Table: Sales.SalesOrderDetail

Bonus: Re-work the query to return products that have not been ordered

*/

SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;


SELECT ProductID, Name AS ProductName  FROM Production.Product
WHERE ProductID IN(SELECT ProductID FROM Sales.SalesOrderDetail);




SELECT ProductID, Name AS ProductName  FROM Production.Product
WHERE ProductID NOT IN(SELECT ProductID FROM Sales.SalesOrderDetail);


