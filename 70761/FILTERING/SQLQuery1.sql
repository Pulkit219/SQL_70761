USE WideWorldImporters;
GO

-- Return record from specific supplier
SELECT * FROM warehouse.StockItems WHERE SupplierID=5;


-- Return record from specific supplier and specific color --------USE AND
SELECT * FROM warehouse.StockItems WHERE SupplierID=5 AND ColorID=3;

--combining predicates, controlling order( precedence: NOT > AND > OR) and paranthesis has greatest precedence
SELECT * FROM warehouse.StockItems WHERE (SupplierID =4  OR SupplierID=5 ) AND ColorID =3;

--negate a query
SELECT * FROM warehouse.StockItems WHERE NOT(SupplierID =4  OR SupplierID=5 ) AND ColorID =3;


--using LIKE with wildcard=======we can notice it ignores case sensitivity xx or XX
SELECT * FROM warehouse.StockItems WHERE Size LIKE '%xx%';

--negating using AND =================PLEASE CHECK SIMILAR COMMANDS ON LIKE , PRESS FN+ F1
SELECT * FROM warehouse.StockItems WHERE Size LIKE '%XX%' AND Size NOT LIKE '%S%';


-- DATE SEARCHES , normalized and standard format is 20160101 ====it cuts off last day it seemss
SELECT OrderID, OrderDate FROM Sales.Orders WHERE OrderDate BETWEEN '20160101' AND '20160131'
ORDER BY OrderDate;

-- DATE SEARCHES , normalized and standard format is 20160101===it includes both 01 and 31
SELECT OrderID, OrderDate FROM Sales.Orders WHERE OrderDate BETWEEN '20160301' AND '20160331'
ORDER BY OrderDate;

--ANOTHER more efficient way to do it with open dateandtime range
SELECT OrderID, OrderDate FROM Sales.Orders WHERE OrderDate >= '20160301' AND OrderDate <= '20160331'
ORDER BY OrderDate;

--OR

SELECT OrderID, OrderDate FROM Sales.Orders WHERE OrderDate >= '20160301' AND OrderDate <'20160401'
ORDER BY OrderDate;

--query challenge
--a query to identify people who are allowed to login but are not employees and does not contain example.com in their logon name
SELECT FullName,LogonName, IsPermittedToLogon, IsEmployee FROM Application.People
WHERE IsEmployee =0 AND IsPermittedToLogon=1 AND  LogonName NOT LIKE '%example.com';