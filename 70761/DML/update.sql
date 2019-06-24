USE WideWorldImporters;
GO

--UPDATE
UPDATE Warehouse.StockItemHoldings
SET QuantityOnHand*=0.7,
ReorderLevel*=0.9;
--It will update each row in entire table, no WHERE clause mentioned



--FOR testing purposes
BEGIN TRAN

SELECT * FROM Warehouse.StockItemHoldings;

UPDATE Warehouse.StockItemHoldings
SET QuantityOnHand*=0.7,
ReorderLevel*=0.9;

SELECT * FROM Warehouse.StockItemHoldings;
ROLLBACK

--UPDATE with JOINS
UPDATE sih
SET QuantityOnHand*=0.7,
ReorderLevel*=0.9
FROM Warehouse.StockItemHoldings sih
JOIN Warehouse.StockItemStockGroups sig ON sih.StockItemID=sih.StockItemID
WHERE sig.StockGroupID=3;


---UPDATE WITH OUTPUT
UPDATE sih
SET QuantityOnHand*=0.7,
ReorderLevel*=0.9
OUTPUT deleted.*, inserted.*
FROM Warehouse.StockItemHoldings sih
JOIN Warehouse.StockItemStockGroups sig ON sih.StockItemID=sih.StockItemID
WHERE sig.StockGroupID=3;
