USE WideWorldImporters;
GO


--WHat is window function in simple definition
/*
It's a kind of multiple group by with aggreagte functions thing, helps simply grouping according to your choice,
An ADVANCED GROUP BY
With just alone using group by it gives you aggreagte data only, you can see only grouped data but with OVER
in one table we can see individual record and for each record aggregate results are also diplayed.
*/

--standard aggragate function WITH GROUP BY
SELECT c.CustomerID, o.OrderID, 
		SUM(ol.UnitPrice *ol.Quantity) AS OrderTotal
FROM Sales.Customers c
JOIN Sales.Orders o ON c.CustomerID=o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID =ol.OrderID
GROUP BY c.CustomerID, o.OrderID
ORDER BY C.CustomerID, o.OrderID;


--WINDOWS aggregate function with OVER


SELECT c.CustomerID, o.OrderID, (ol.UnitPrice*ol.Quantity) AS Subtotal,
SUM(ol.UnitPrice*ol.Quantity) OVER(PARTITION BY c.CustomerID, o.OrderID) AS OrderTotal,
SUM(ol.UnitPrice*ol.Quantity) OVER(PARTITION BY c.CustomerID) AS CustomerTotal,
SUM(ol.UnitPrice*ol.Quantity) OVER(PARTITION BY c.CustomerID
--ORDER by is not oirdering but helping cumulative addition according to order for one cust ID partition, look at results
												ORDER BY o.OrderID
												ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CustomerRunningTotal,
												--it'always a good idea to do running total/cumulative sum using order by <unique id column>
SUM(ol.UnitPrice*ol.Quantity) OVER() AS GrandTotal
FROM Sales.Customers c
JOIN Sales.Orders o ON c.CustomerID=o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID =ol.OrderID
ORDER BY C.CustomerID, o.OrderID;



--WINDOWS RANKING functions with OVER
--ROW_NUMBER, RANK(), DENSE_RANK must be used with order by clause while PARTITION BY is optional becasue logically how would we rank if there is no order
SELECT c.CustomerID, o.OrderID, (ol.UnitPrice*ol.Quantity) AS Subtotal,
ROW_NUMBER() OVER(ORDER BY ol.UnitPrice*ol.Quantity) AS RowNumber,
RANK()		OVER(ORDER BY ol.UnitPrice*ol.Quantity) AS RANKED,
RANK()      OVER(PARTITION BY o.CustomerID ORDER BY ol.UnitPrice * ol.Quantity) AS CustomerRanked,
DENSE_RANK() OVER(ORDER BY ol.UnitPrice*ol.Quantity) AS DenseRank,
NTILE(10)   OVER(ORDER BY ol.UnitPrice * ol.Quantity) AS ntile10

FROM Sales.Customers c
JOIN Sales.Orders o ON c.CustomerID=o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID =ol.OrderID
ORDER BY o.CustomerID, Ranked;


/*
Transform the following detail query into a matix by adding a pivot on ProductcategoryName
and aggregating the subtotal by OrderYear, sort the results by OrderYear.

BONUS: Add OrderMonth into the detail data and sort order.
*/

USE AdventureWorks2017;
GO


SELECT * FROM
(
SELECT pc.Name AS ProductCategoryname, YEAR(OrderDate) AS Orderyear, MONTH(OrderDate)AS OrderMonth, CAST(Subtotal as decimal(10,2)) AS subtotal
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID=pc.ProductCategoryID
JOIN sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
)src
PIVOT
(
	SUM(subtotal)
	FOR ProductCategoryname IN ([Accesories], [Bikes], [Components],[Clothing])
	
	)pvt
ORDER BY OrderYear,OrderMonth;
