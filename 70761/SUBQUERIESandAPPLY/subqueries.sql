USE AdventureWorks2017;
GO


--Scalar subquery  (SELECT CLAUSE)
SELECT ProductID, ProductNumber, Name AS ProductName,
Weight,
(SELECT AVG(Weight) FROM Production.Product) AS AverageWeight,
Weight-(SELECT AVG(Weight) FROM Production.Product) AS WeightDifference,
ListPrice,
(SELECT AVG(ListPrice) FROM Production.Product) AS AveragePrice,
DaysToManufacture-(SELECT AVG(ListPrice) FROM Production.Product) AS ListPriceDifference
FROM Production.Product
WHERE ListPrice>0 AND Weight>0;

--Scalar subquery  (WHERE CLAUSE)
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice >= (SELECT AVG(ListPrice) FROM Production.Product);

--multi-valued(WHERE CLAUSE)
SELECT ProductID, Name as ProductName, ListPrice
FROM Production.Product
WHERE ProductSubcategoryID IN (SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE Name LIKE '%bikes');


--multi-valued subquery(FROM clause, derived table)
--Over here we're generating a mini table using SUb query and then joining that table using ProductSubcategoryID
SELECT ProductID, P.Name AS ProctName, ps.Name AS Subcategory, ListPrice
FROM Production.Product p
JOIN(SELECT ProductCategoryID, Name FROM Production.ProductSubcategory WHERE Name LIKE '%bikes%') ps
ON p.ProductSubcategoryID= ps.ProductCategoryID;


SELECT ProductID, Name AS Productname, ListPrice, Color
FROM (SELECT * FROM Production.Product WHERE ListPrice >100)p
ORDER BY ListPrice DESC, ProductName;


--correlated subqueries, subquery dependent on outer query, EXISTS is used instead of IN 
SELECT ProductID, Name as ProductName
FROM Production.Product p
WHERE EXISTS(SELECT * FROM Production.ProductSubcategory psc 
			WHERE p.ProductSubcategoryID=psc.ProductSubcategoryID AND psc.Name='Road Bikes');



