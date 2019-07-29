USE WideWorldImporters;
GO


--basic stored procedure
CREATE PROCEDURE Warehouse.GetColor
	@ColorID int
AS
	SELECT * FROM Warehouse.Colors WHERE ColorID =@ColorID
GO

EXEC Warehouse.GetColor 10;


--VIEW stored procedure plan cache


--dynamic stored procedure
CREATE PROCEDURE Sales.GetOrders
	@CustomerID int =NULL,
	@SalesPersonID int= NULL,
	@StartOrderDate date = NULL,
	@EndOrderDate date = NULL

WITH RECOMPILE
AS
	SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate, ExpectedDeliveryDate, DeliveryInstructions
	FROM Sales.Orders
	WHERE (CustomerID = @CustomerID OR @CustomerID IS NULL) 
	--so if nothing is passed here, it will be NULL IS NULL so no filtering by custID all iD's and then move onto second condition
	AND
	(SalespersonPersonID=@SalesPersonID OR @SalesPersonID IS NULL)
	AND
	(
	(OrderDate >= @StartOrderDate OR @StartOrderDate IS NULL)
	AND
	(OrderDate <= @EndOrderDate OR @EndOrderDate IS NULL)
	);
GO

EXEC Sales.GetOrders;
EXEC Sales.GetOrders 832, 2, null, null;
EXEC Sales.GetOrders 832, 2;
EXEC Sales.GetOrders @StartOrderDate = '20160101', @EndOrderDate = '20161231';



ALTER PROCEDURE Sales.GetOrders
	@CustomerID int =NULL,
	@SalesPersonID int= NULL,
	@StartOrderDate date = NULL,
	@EndOrderDate date = NULL

WITH RECOMPILE -- now evr=ery sp query executed will have it's own execution plan, cache
AS
	SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate, ExpectedDeliveryDate, DeliveryInstructions
	FROM Sales.Orders
	WHERE (CustomerID = @CustomerID OR @CustomerID IS NULL) 
	--so if nothing is passed here, it will be NULL IS NULL so no filtering by custID all iD's and then move onto second condition
	AND
	(SalespersonPersonID=@SalesPersonID OR @SalesPersonID IS NULL)
	AND
	(
	(OrderDate >= @StartOrderDate OR @StartOrderDate IS NULL)
	AND
	(OrderDate <= @EndOrderDate OR @EndOrderDate IS NULL)
	);
GO



--STORED Procedure with OUTPUT PROCEDURE

CREATE PROCEDURE Warehouse.AddColor
	@ColorName nvarchar(20),
	@ColorID int OUTPUT-- define its datatype with OUTPUT to define it as OUTPUT param
WITH EXECUTE AS OWNER
AS
	SET @ColorID= NEXT VALUE FOR Sequences.ColorID;

	INSERT INTO Warehouse.Colors(ColorID, ColorName, LastEditedBy)
		VALUES(@ColorID, @ColorName, 1);
GO


DECLARE @NewColorID int;
EXEC Warehouse.AddColor'ACOlor',@NewColorID OUTPUT ;
PRINT @NewColorID;


/*

a procedure that will update color
Stored Procedure Warehouse.UpdateColor
Input Parameters: @ColorID, @ColorName
*/

CREATE PROCEDURE Warehouse.UpdateColor
	@ColorName nvarchar(20),
	@ColorID int 

AS

	UPDATE Warehouse.Colors 
	SET ColorName=@ColorName
	WHERE ColorID=@ColorID;
GO

EXEC Warehouse.UpdateColor 13, 'blue';

