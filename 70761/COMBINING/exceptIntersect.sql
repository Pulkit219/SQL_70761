USE WideWorldImporters;
GO

--except (unused item colors) EXCEPT means removing the duplicated from RHS table and showing unique exists only in LHS table
SELECT ColorID FROM Warehouse.Colors 
EXCEPT
SELECT ColorID FROM Warehouse.StockItems;

--- AN example of sub query
SELECT * FROM Warehouse.Colors WHERE ColorID IN(
SELECT ColorID FROM Warehouse.Colors 
EXCEPT
SELECT ColorID FROM Warehouse.StockItems);


--INTERSECT  , which means common in both tables
SELECT ColorID FROM Warehouse.Colors 
INTERSECT
SELECT ColorID FROM Warehouse.StockItems;

--- AN example of sub query
SELECT * FROM Warehouse.Colors WHERE ColorID IN(
SELECT ColorID FROM Warehouse.Colors 
INTERSECT
SELECT ColorID FROM Warehouse.StockItems);


/*
-- QUERY challenge , a query that returns a unique list of cities both customers and suppliers reside in.
Tables: Purchasing.suppliers, sales.customers
Columns: PostalCityID
*/


SELECT CityName FROM Application.Cities WHERE CityID IN(
SELECT PostalCityID FROM Purchasing.suppliers
UNION
SELECT PostalCityID FROM Sales.customers);
