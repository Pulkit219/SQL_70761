
--Functions, take parameters and return a result
-- Scalar valued means returns single value VS Table-Valued returns a table
--Deterministic YEAR('20170131')= 2017 vs NOn-deterministic GETDATE()


--SARG-ability & Performance

USE AdventureWorks2017;
GO

SELECT EmailAddress
FROM person.EmailAddress
WHERE left(EmailAddress,2) = 'As'
/*
From the query plan output we can see that this query does an index scan, which means it reviews all rows before returning the results.  
This is because of the LEFT function that is being used.

*/


--VS


SELECT EmailAddress
FROM person.EmailAddress	
WHERE EmailAddress like 'As%'

/*
Another version of this same query which will return the same results uses the LIKE clause instead.  This query uses the like clause to get all data that begins with "As".
Since there is an index on the the EmailAddress column SQL Server can do an index seek which is much more efficient then an index scan.

*/

--IMP thing to note here is 1st query , function is applied to whole column while in 2nd query it is not!



--CONVERSION functions--USING CAST & CONVERT, CAST is good for portability

SELECT 'Today''s date is ' + GETDATE(); -- an error because of conversion
SELECT 'Today''s date is ' + CAST(GETDATE() AS NVARCHAR);


--Implicit and Explicit comversions

/* STRING FUNCTIONS */

--LEFT AND RIGHT=>
SELECT  FirstName,LastName, LEFT(FirstName,1) + LEFT(LastName,1) FROM Person.Person;

/*CHARINDEX & PATINDEX=> charindex searches for an index of a provided string but also allows for 3rd argument in its function
to let know from what to start teh search from.
WHEREas PATINDEX, no 3rd argument but searches for a pattern
*/
SELECT DISTINCT City, CHARINDEX('city', City) as CityStartsAt, PATINDEX('%town%', City) AS TownstartsAt
FROM Person.Address WHERE CHARINDEX('city', City) > 0 OR PATINDEX('%town%', City)>0;


/* SUBSTRING, REPLACE, REVERSE */
SELECT ProductNumber,

LEFT(ProductNumber, 2) AS ProductCode,
SUBSTRING(ProductNumber, CHARINDEX('-', ProductNumber, 0) + 1, 4) AS PartialProductNumber,
REPLACE(ProductNumber, '-', '') as NewproductNumber,
REVERSE(ProductNumber) AS BackwardsproductNumber

FROM Production.Product;


/* DATETIME functions */
--DATENAME
SELECT DISTINCT OrderDate,
DATENAME(YEAR, OrderDate) AS Orderyear,
DATENAME(MONTH, OrderDate) AS OrderMonth,
DATENAME(WEEK, OrderDate) AS OrderWeek,
DATENAME(DAY, OrderDate) AS OrderDay,
DATENAME(DAYOFYEAR, OrderDate) AS OrderDayOfYear
FROM Sales.SalesOrderHeader;


/* DATEDIFF & DATEADD */
-- DATEDIFF here gets the diff between current date and hiredate and then you can extract if you need to know no# of YEARS/MONTHS
--DATEADD is something in which you can add substract values to Current date. In this case I am getting date 5 years before and then comparing
--Don't get confused with parameters, YEAR -5 means minus 5 to current year so will give 20140203

SELECT LoginID, HireDate, DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed
FROM HumanResources.Employee
WHERE HireDate <=DATEADD(YEAR, -5, GETDATE())
ORDER BY YearsEmployed ASC;


/* SYSTEM FUNCTIONS */
--ISNULL replaces null with N/A
SELECT Name, ISNULL(Color, 'N/A') AS Color FROM Production.Product;

--NEWID
SELECT NEWID();

--SUSER_SNAME, USER_NAME, HOST_NAME
SELECT SUSER_SNAME() AS SystemUSername, USER_NAME() AS DatabaseUserName, HOST_NAME() AS MachineName;

--Not SARG-able
SELECT SalesOrderID, OrderDate, DATEDIFF(YEAR, Orderdate, GETDATE()) AS OrderAgeYears
FROM Sales.SalesOrderHeader
WHERE DATEDIFF(YEAR, Orderdate, GETDATE())>=5;

--SARG-able
SELECT SalesOrderID, OrderDate, DATEDIFF(YEAR, Orderdate, GETDATE()) AS OrderAgeYears
FROM Sales.SalesOrderHeader
WHERE OrderDate <=DATEADD(YEAR, -5, GETDATE());

--Not SARG-able
SELECT FirstName, LastName
FROM Person.Person
WHERE CHARINDEX('pow', LastName) >0;

--SARG-able
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE 'pow%';



--QUERY CHALLENGE
/*
Refactor the WHERE clause of this query to make it SARGable
SELECT OrderID, ORderDate, YEAR(OrderDate) AS OrderYear
FROM Sales.Orders
WHERE YEAR(OrderDate)=2016;
*/

USE WideWorldImporters;
GO

SELECT OrderID, OrderDate, YEAR(OrderDate) AS OrderYear
FROM Sales.Orders
WHERE YEAR(OrderDate)=2016;


SELECT OrderID, OrderDate, YEAR(OrderDate) AS OrderYear
FROM Sales.Orders
WHERE OrderDate >= '20160101' AND OrderDate <= '20161231';