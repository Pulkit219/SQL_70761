USE WideWorldImporters;
GO


--raw data without GRoup BY
SELECT si.StockItemID, ol.OrderLineID, c.ColorName, ol.Quantity, ol.UnitPrice
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID;

--GROUP BY with single grouping
SELECT  c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
GROUP BY c.ColorName
ORDER BY TotalSales DESC;

--GROUP BY with multiple groupings
SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
GROUP BY c.ColorName, YEAR(OrderDate)
ORDER BY OrderYear DESC, TotalSales DESC;

--GROUP BY with multiple groupings using filter HAVING clause

SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
GROUP BY c.ColorName, YEAR(OrderDate)
HAVING COUNT(*) >5000
ORDER BY OrderYear DESC, TotalSales DESC;

--GROUP BY with multiple groupings using filter HAVING clause and WHERE
SELECT  YEAR(OrderDate) AS orderYear, c.ColorName,
SUM(ol.Quantity * ol.UnitPrice) AS TotalSales,
AVG(ol.Quantity * ol.UnitPrice) AS AvergaeSales,
COUNT(*) AS NumberOfSales
FROM Warehouse.Colors C
JOIN Warehouse.StockItems si ON c.ColorID=si.ColorID
JOIN Sales.OrderLines ol ON si.StockItemID=ol.StockItemID
JOIN Sales.Orders o ON ol.OrderID=o.OrderID
WHERE OrderDate>='20150101' AND OrderDate <='20161231'
GROUP BY c.ColorName, YEAR(OrderDate)
HAVING COUNT(*) >5000
ORDER BY OrderYear DESC, TotalSales DESC;
