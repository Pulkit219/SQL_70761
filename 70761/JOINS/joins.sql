USE WideWorldImporters;
GO


--Inner join: customers with categories, it is a simple join which matches only available values PK=FK, no null values

SELECT cust.CustomerName, cat.CustomerCategoryName FROM Sales.Customers cust JOIN Sales.CustomerCategories cat 
ON cust.CustomerCategoryID =cat.CustomerCategoryID;

--Inner join: old SCHOOL way
SELECT cust.CustomerName, cat.CustomerCategoryName FROM Sales.Customers cust, Sales.CustomerCategories cat 
WHERE cust.CustomerCategoryID =cat.CustomerCategoryID;



USE AdventureWorks2017;
GO

--MULTIPLE JOINS, first start with base table then join it with corresponding FK table as required and then keep joining one by one
SELECT PROD.Name, psub.Name, pcat.Name, pinv.Quantity FROM Production.Product AS prod
INNER JOIN Production.ProductSubcategory AS psub ON prod.ProductsubCategoryID= psub.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pcat ON psub.ProductCategoryID=pcat.ProductCategoryID
INNER JOIN Production.ProductInventory AS pinv ON prod.ProductID=PINV.ProductID;

--MULTIPLE JOIN
--RIGHT JOIN, LEFT JOIN, FULL JOIN

/*
a challenge
a query that returns employee and personal information.
tables: human resources.Employee, person.person, person.emailAddress
Columns: FirstName, LastName, Jobtitle, Hiredate, Emailaddress
*/

SELECT pp.FirstName, pp.LastName, hre.JobTitle, hre.HireDate, pea.EmailAddress FROM HumanResources.Employee AS hre
JOIN Person.Person AS pp ON hre.BusinessEntityID=pp.BusinessEntityID
JOIN Person.EmailAddress as pea ON pp.BusinessEntityID=pea.BusinessEntityID;