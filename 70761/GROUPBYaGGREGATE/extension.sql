USE WideWorldImporters;
GO


--ROLLUP for subtotals and Totals
SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
GROUP BY ROLLUP(YEAR(OrderDate), c.ColorName )
ORDER BY OrderYear DESC, TotalSales DESC;
-- be careful with ROLLUP (YEAR , color.name) has to be in sequence otherwise it's not working


--GROUPING SETS for combining grouped queries(alternative to UNION ALL)
SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
GROUP BY GROUPING SETS
(
(YEAR(OrderDate)),
(c.ColorName),
(YEAR(OrderDate), c.ColorName)
)
ORDER BY OrderYear;


--CUBE for all possible combinations
SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
GROUP BY CUBE(YEAR(OrderDate), c.ColorName )
ORDER BY OrderYear DESC, TotalSales DESC;


--QUERY challenge
/* Write a query that returns the total amount due for each salesperson by year
Table: Sales.salesOrderheader
Columns: SalesPersonID, OrderYear
Grouping: SalespersonnID, OrderYear
Filter:Do not include NULL SalesPersonIDs
Sort: SalesPersonID asc, Orderyear DESC

BONUS: include subtotals and grand totals

*/
USE AdventureWorks2017;
GO

SELECT * FROM Sales.SalesOrderHeader;

SELECT SalesPersonID,YEAR(OrderDate) as Orderyear ,  SUM(TotalDue) AS TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY ROLLUP(SalesPersonID, YEAR(OrderDate))
ORDER BY SalesPersonID ASC, Orderyear DESC
;