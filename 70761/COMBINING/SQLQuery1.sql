USE WideWorldImporters;
GO



--two sepereate queries, join them WITH UNION, PLEASE NOTE 2 TABLES MUST HAVE SAME MATCHING COLUMNS SELECTED WITH SAME NUMBER OF ROWS
-- By default it uses DISTINCT to remove duplicates

SELECT * FROM Warehouse.StockItems WHERE StockItemID BETWEEN 1 AND 4
UNION
SELECT * FROM Warehouse.StockItems WHERE StockItemID BETWEEN 10 AND 15;

-- UNION all to preserve duplicates as well and MORE FASTER and efficient than UNION because it removes  duplicate and hence costs more
SELECT * FROM Warehouse.StockItems WHERE StockItemID BETWEEN 1 AND 4
UNION ALL
SELECT * FROM Warehouse.StockItems WHERE StockItemID BETWEEN 10 AND 15;