
USE WideWorldImporters;
GO

--conversion with TRY_PARSE

SELECT
	TRY_PARSE('$123.00' AS money USING 'en-gb') AS Fail
	

-- ISNULL and COALESCE

SELECT ISNULL(NULL, 'hello') AS [ISNULL];
SELECT COALESCE(NULL,NULL<NULL, 'hello') AS COALESCE;


-- A smart way to use COALESCE

ALTER PROCEDURE Sales.GetOrders
	@CustomerID int =NULL,
	@SalesPersonID int= NULL,
	@StartOrderDate date = NULL,
	@EndOrderDate date = NULL

WITH RECOMPILE -- now every sp query executed will have it's own execution plan, cache
AS
	SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate, ExpectedDeliveryDate, DeliveryInstructions
	FROM Sales.Orders
	WHERE (CustomerID = COALESCE(@CustomerID, CustomerID) 
	--so if nothing is passed here, it will be NULL IS NULL so no filtering by custID all iD's and then move onto second condition
	AND
	(SalespersonPersonID=COALESCE(@SalesPersonID ,SalespersonPersonID)
	AND
	(
	(OrderDate >= COALESCE(@StartOrderDate ,'01/01/1900')
	AND
	(OrderDate <= COALESCE(@EndOrderDate ,'12/31/9999')
	);
GO



/*
WHERE clause is broken in the following stored procedure, fix it

*/

ALTER PROCEDURE Sales.GetPersons
	@FirstName nvarchar(50) =NULL,
	@LastName nvarchar(50) =NULL
AS
	SELECT FirstName, LastName, Title
	FROM Person.Person
	WHERE FirstName LIKE ISNULL(@FirstName, '%') + '%'
		AND
		LastName LIKE ISNULL(@LastName, '%') + '%';
GO

EXEC Sales.GetPersons 'r', 'a';