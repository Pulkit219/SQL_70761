USE WideWorldImporters;
GO

--pivot on customer, aggregating quantity by year
--taking unique values from column and tunrning it into seperate column names, basically rotating table, viewing it in different angle
SELECT * FROM
(
SELECT cc.CustomerCategoryName, YEAR(OrderDate) AS OrderYear, ol.Quantity
FROM Sales.Customers c
JOIN Sales.CustomerCategories cc ON c.CustomerCategoryID=cc.CustomerCategoryID
JOIN sales.Orders o ON c.CustomerID=o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
) src
PIVOT
(
	SUM(Quantity)
	FOR CustomerCategoryName IN ([Supermarket],[Novelty Shop], [Gift Store], [Computer Store], [Corporate])
)pvt;



/*while doing pivot, make sure to map columns, so for unique row values we did 
SELECT custcateg  TO PIVOT Custcateg in []
SELECT ol.quantity to PIVOT SUM(quantity)
SELECT orderyear which will display as column

*/
--pivot on order month, aggregating subtotal by year
SELECT * FROM
(
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, ol.PickedQuantity * ol.UnitPrice as SubTotal
FROM Sales.Orders o
JOIN Sales.OrderLines ol ON o.OrderID =ol.OrderID
) src
PIVOT
(
	SUM(SubTotal)
	FOR OrderMonth IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	
	)pvt
ORDER BY OrderYear;




--pivot on order month WITH FRIENDLY NAMES, aggreagting subtotal by year
--WROTE a case for order MONTH column
SELECT * FROM
(
SELECT YEAR(OrderDate) AS OrderYear, ol.PickedQuantity * ol.UnitPrice as SubTotal,
CASE MONTH(OrderDate)
WHEN 1 THEN 'January'
WHEN 2 THEN 'feb'
WHEN 3 THEN 'march'
WHEN 4 THEN 'april'
WHEN 5 THEN 'May'
WHEN 6 THEN 'June'
WHEN 7 THEN 'July'
WHEN 8 THEN 'august'
WHEN 9 THEN 'september'
WHEN 10 THEN 'October'
WHEN 11 THEN 'November'
WHEN 12 THEN 'dec'
END as OrderMonth
FROM Sales.Orders o
JOIN Sales.OrderLines ol ON o.OrderID =ol.OrderID
) src
PIVOT
(
	SUM(SubTotal)
	FOR OrderMonth IN ([January],[feb],[march],[april],[May],[June],[July],[august],[september],[October],[November],[dec])
	
	)pvt
ORDER BY OrderYear;


--connecting 1st example and making DYNAMIC query means what if in future there are more categories
DECLARE @colSQL VARCHAR(MAX)
SELECT @colSQL = COALESCE(@colSQL + ',[' + CustomerCategoryName + ']', '[' +CustomerCategoryName + ']')
FROM Sales.CustomerCategories
PRINT @colSQL

DECLARE @pvtSQL NVARCHAR(MAX)
SET @pvtSQL =N'
SELECT * FROM
(
SELECT cc.CustomerCategoryName, YEAR(OrderDate) AS OrderYear, DATEPART(q, OrderDate) AS OrderQuarter, ol.Quantity
FROM Sales.Customers c
JOIN Sales.CustomerCategories cc ON c.CustomerCategoryID=cc.CustomerCategoryID
JOIN sales.Orders o ON c.CustomerID=o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
) src
PIVOT
(
	SUM(Quantity)
	FOR CustomerCategoryName IN (' + @colSQL + ')
)pvt'
EXECUTE (@pvtSQL)

