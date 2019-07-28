USE WideWorldImporters;
GO


--scalar UDF, means returns one value
CREATE FUNCTION Warehouse.GetItemTransactionCount(@StockItemID int)
RETURNS int
AS
BEGIN
	DECLARE @ret int;

	SELECT @ret =COUNT(*)
	FROM Warehouse.StockItemTransactions
	WHERE StockItemID=@StockItemID

	SET @ret =ISNULL(@ret, 0)

	RETURN @ret;
END;
GO


--ALTER function, add alter


--query
SELECT StockItemName, Warehouse.GetItemTransactionCount(StockItemID) AS Transactions
FROM Warehouse.StockItems
WHERE IsChillerStock=1
ORDER BY Transactions DESC;
GO


--INLINE TABLE valued functions
CREATE FUNCTION Sales.GetOrdersByCustomer(@CustomerID int)
RETURNS TABLE
AS
RETURN
(
	SELECT o.OrderID, CustomerID, StockItemID, Quantity, OrderDate
	FROM Sales.Orders o
	JOIN Sales.OrderLines ol ON o.OrderID=ol.OrderID
	WHERE CustomerID=@CustomerID
	);
	GO

	--query
	SELECT * FROM Sales.GetOrdersByCustomer(2);
	GO


--multi statement table valued function
CREATE FUNCTION Sales.GetTopCustomersByCategory(@CategoryID int=0, @Top int)
RETURNS @tbl TABLE
(
	CustomerID INT NOT NULL,
	CustomerName nvarchar(100) NOT NULL,
	CategoryName nvarchar(50) NOT NULL,
	NumberOfSales INT NOT NULL,
	INDEX cidx_cid CLUSTERED(CustomerID)
)
WITH SCHEMABINDING
AS
BEGIN
	IF @CategoryID = 0
		BEGIN
			INSERT @tbl
			SELECT TOP(@Top)
				c.CustomerID,
				CustomerName,
				CustomerCategoryName,
				COUNT(*) AS NumberOfSales
			FROM Sales.Customers c
			JOIN Sales.Orders o ON c.CustomerID=o.CustomerID
			JOIN Sales.CustomerCategories cc ON c.CustomerCategoryID =cc.CustomerCategoryID
		GROUP BY c.CustomerID, CustomerName, CustomerCategoryName
		ORDER BY NumberOfSales DESC
		END
	ELSE
		BEGIN
			INSERT @tbl
			SELECT TOP(@Top)
				c.CustomerID,
				CustomerName,
				CustomerCategoryName,
				COUNT(*) AS NumberOfSales
			FROM Sales.Customers c
			JOIN Sales.Orders o ON c.CustomerID =o.CustomerID
			JOIN Sales.CustomerCategories cc ON c.CustomerCategoryID =cc.CustomerCategoryID
		WHERE c.CustomerCategoryID =@CategoryID
		GROUP BY c.CustomerID, CustomerName, CustomerCategoryName
		ORDER BY NumberOfSales DESC
		END

	RETURN
END
GO

--queries
SELECT * FROM Sales.GetTopCustomersByCategory(0,10);
SELECT * FROM Sales.GetTopCustomersByCategory(3,10);


/*  Write a scalar valued user-def function that will format a number as currency. Write a query against the products
 table that will return the listprice in this format
 UDF:dbo.FormatAsCurrency
 Parameters: @ Number money
 HINT: Use the format function 
 */

 USE AdventureWorks2017;
 GO


 CREATE FUNCTION dbo.FormatAsCurrency(@Number money)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @val varchar(50)
	SET @val =FORMAT(@Number, 'C')
	RETURN @val;
END;
GO


SELECT Name AS ProductName,
		ListPrice,
		dbo.FormatAsCurrency(ListPrice) AS FOrmattedListpRIce
FROM Production.Product
WHERE ListPrice >0;