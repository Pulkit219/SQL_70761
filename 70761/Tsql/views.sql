USE AdventureWorks2017;
GO


--create a view, can have large block of query as view virtual table so don't have to type again and again but doesn't accept parameters
CREATE VIEW Sales.vSalesByTerritory
AS
	SELECT st.[Name] AS Territiryname,
			st.[Group] AS TerritoryRegion,
			soh.SUbtotal,
			soh.taxtotal,
			soh.Totaldue
	FROM Sales.SalesTerritory st
	JOIN(SELECT TerritoryID, SUM(Subtotal) As SUbtotal, SUM(TaxAmt) AS taxtotal, SUM(TotalDue) AS Totaldue
			FROM Sales.SalesOrderHeader
			GROUP BY TerritoryID) soh ON st.TerritoryID=soh.TerritoryID;
	GO

--Now we have a readymade table on WHICH we can apply CLAUSES



--MODIFY A VIEW
ALTER VIEW Sales.vSalesByTerritory
AS
	SELECT st.[Name] AS Territiryname,
			st.[Group] AS TerritoryRegion,
			st.CountryRegionCode,
			soh.SUbtotal,
			soh.taxtotal,
			soh.Totaldue
	FROM Sales.SalesTerritory st
	JOIN(SELECT TerritoryID, SUM(Subtotal) As SUbtotal, SUM(TaxAmt) AS taxtotal, SUM(TotalDue) AS Totaldue
			FROM Sales.SalesOrderHeader
			GROUP BY TerritoryID) soh ON st.TerritoryID=soh.TerritoryID;
	GO


	--Resuse the view again
	SELECT * FROM Sales.vSalesByTerritory
	WHERE CountryRegionCode ='US' AND NumOfOrders >1000
	ORDER BY TerritoryName;
	GO


	/*Add the schemabinding option to prevent underlying table changes, 
	means this view is now bound to related tables used to contruct this view 
	so no changes will be allowed to those tables like dropping that column or table itself
	
	WHILE encryption means you cannot have a look at this function or view and see the underlying code*/
ALTER VIEW Sales.vSalesByTerritory
WITH SCHEMABINDING, ENCRYPTION
AS
	SELECT st.[Name] AS Territiryname,
			st.[Group] AS TerritoryRegion,
			st.CountryRegionCode,
			soh.SUbtotal,
			soh.taxtotal,
			soh.Totaldue
	FROM Sales.SalesTerritory st
	JOIN(SELECT TerritoryID, SUM(Subtotal) As SUbtotal, SUM(TaxAmt) AS taxtotal, SUM(TotalDue) AS Totaldue
			FROM Sales.SalesOrderHeader
			GROUP BY TerritoryID) soh ON st.TerritoryID=soh.TerritoryID;
	GO


	--Create clustered INDEX, cannot create clustered index if VIEWS has derived table


	--rewriting query to support indexed view
	ALTER VIEW Sales.vSalesByTerritory
	WITH SCHEMABINDING
	AS

		SELECT st.TerritoryID,
			[Name] as TerritoryName,
			[Group] as territoryRegion,
			CountryRegionCode,
			SUM(Subtotal) as Subtotal,
			SUM(TaxAmt) AS TaxTotal,
			SUM(TotalDue) AS TotalDue,
			COUNT_BIG(*) NumOfOrders
		FROM Sales.SalesOrderHeader soh
		JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
		GROUP BY st.TerritoryID, [Name], [Group], CountryRegionCode;
	GO

	--create clustered index 
	CREATE UNIQUE CLUSTERED INDEX cidx_tid ON Sales.vSalesByTerritory(TerritoryID);
	GO

	--add addiotnal non-clustered index
	CREATE NONCLUSTERED INDEX idx_tname ON Sales.vSalesByTerritory(TerritoryName);
	GO

	SELECT * FROM Sales.vSalesByTerritory;

/*CHALLENGE
Create a view that aggregates quantity sold since last quantity take and total cost of 
quantity on hand grouped by StockGroupName, then write a query against it.

View: Warehouse.vItemQuantity
Columns: StockGroupName, QuantitySold, QuantityOnHandCost
Tables:Warehouse.StockGroups, Warehouse.StockItemStockGroups, Warehouse.StockItemHoldings

Bonus: turn it into an indexed view
*/
USE WideWorldImporters;
GO
SELECT * FROM Warehouse.StockGroups;
SELECT * FROM Warehouse.StockItemStockGroups;
SELECT * FROM Warehouse.StockItemHoldings;

CREATE VIEW Warehouse.vItemQuantity
AS
	SELECT StockGroupName,
			SUM(LastStocktakeQuantity - QuantityOnHand) AS QuantitySOld,
			SUM(QuantityOnHand * LastCostPrice) AS QUantityOnHandCost
	FROM Warehouse.StockGroups sg  JOIN Warehouse.StockItemStockGroups sisg ON sg.StockGroupID=sisg.StockGroupID
	JOIN Warehouse.StockItemHoldings sih ON sih.StockItemID=sisg.StockItemID
	GROUP BY StockGroupName;
GO

SELECT * FROM Warehouse.vItemQuantity ORDER BY QuantitySOld DESC;


--BONUS QUERY, REMEMBER, doing big aggregations with views, make sure to add schemabinding with COUNT BIG
ALTER VIEW Warehouse.vItemQuantity
WITH SCHEMABINDING
AS
	SELECT StockGroupName,
			SUM(LastStocktakeQuantity - QuantityOnHand) AS QuantitySOld,
			SUM(QuantityOnHand * LastCostPrice) AS QUantityOnHandCost,
			COUNT_BIG(*) AS RecordCount
	FROM Warehouse.StockGroups sg  JOIN Warehouse.StockItemStockGroups sisg ON sg.StockGroupID=sisg.StockGroupID
	JOIN Warehouse.StockItemHoldings sih ON sih.StockItemID=sisg.StockItemID
	GROUP BY StockGroupName;
GO

SELECT * FROM Warehouse.vItemQuantity ORDER BY QuantitySOld DESC;

--unique clustered index must be created before non- clustered indexes
CREATE UNIQUE CLUSTERED INDEX cix_sgname ON Warehouse.vItemQuantity (StockGroupName);
CREATE  NONCLUSTERED INDEX ix_qs ON Warehouse.vItemQuantity (QuantitySOld);

SELECT * FROM Warehouse.vItemQuantity ORDER BY QuantitySOld DESC;