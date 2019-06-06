USE AdventureWorks2017;
GO

SELECT (VacationHours/24) AS vacationDays FROM HumanResources.Employee;

-- TOP limit the results with TOP
SELECT TOP 10 PERCENT JobTitle, MaritalStatus FROM HumanResources.Employee;


--remove duplicate records with DISTINCT
SELECT DISTINCT JobTitle FROM HumanResources.Employee;

-- a query challenge

USE WideWorldImporters;
GO

SELECT TOP 10 StockitemName, UnitPrice, TaxRate, (UnitPrice * (TaxRate / 100)) AS SalesTax FROM Warehouse.StockItems
ORDER BY UnitPrice DESC;




