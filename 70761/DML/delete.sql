--DELETE
DELETE FROM Sales.OrderLines
WHERE OrderId=1;

--DELETE with JOIN
DELETE FROM ol
FROM Sales.OrderLines ol
JOIN Warehouse.StockItemStockGroups sig ON ol.StockItemID=sig.StockItemID
WHERE StockGroupID=4;

--DELETE  with OUTPUT
DELETE ol
OUTPUT deleted.*
INTO Sales.OrderLines_bak -- deleted log into _bak table
FROM Sales.OrderLines ol
JOIN Warehouse.StockItemStockGroups sig ON ol.StockItemID=sig.StockItemID
WHERE StockGroupID=4;



/*

1. Write an insert query statement that adds a new customer category named BEST CATEGORY EVER.

2. Write an UPDATE statement that modifies customers in category 5 to the new category created above.
*/



INSERT INTO [Sales].[CustomerCategories]
           ([CustomerCategoryID]
           ,[CustomerCategoryName]
           ,[LastEditedBy])
     VALUES
           (DEFAULT,
           'best category ever',
            1)
GO


UPDATE [Sales].[CustomerCategories]
   SET [CustomerCategoryID] = <CustomerCategoryID, int,>
      ,[CustomerCategoryName] = <CustomerCategoryName, nvarchar(50),>
      ,[LastEditedBy] = <LastEditedBy, int,>
 WHERE <Search Conditions,,>
GO

