USE WideWorldImporters;
GO


--autocommit transactions
DELETE FROM Warehouse.Colors WHERE ColorName ='Wheat';


--explicit transaction
BEGIN TRANSACTION
	DELETE FROM Warehouse.Colors
	WHERE ColorID NOT IN
			(SELECT DISTINCT ColorID FROM Warehouse.StockItems WHERE ColorID IS NOT NULL);
ROLLBACK;


TRUNCATE TABLE warehouse.Trasactions -- delete all the data from the table


--explicit transaction with xact_abort
SET XACT_ABORT ON; -- meaning if one of the transaction is a failure then all will fail
BEGIN TRANSACTION
	--success
	INSERT INTO Warehouse.transations(TheID, TheData) VALUES(1, 'hi');
	--failure (NULL error)
	INSERT INTO Warehouse.Transactions(TheID, Thedata) VALUES(2,NULL);
COMMIT;


--now USING TRY CATCH block
BEGIN TRY
	BEGIN TRANSACTION
	--success
	INSERT INTO Warehouse.transations(TheID, TheData) VALUES(1, 'hi');
	--failure (NULL error)
	INSERT INTO Warehouse.Transactions(TheID, Thedata) VALUES(2,NULL);

	THROW 51000, 'SOemthing bad happened', 1; -- your own  customized errors
	COMMIT;
END TRY

BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrNumber, ERROR_MESSAGE AS ErrMessage, ERROR_SEVERITY AS ErrSeverity;
	ROLLBACK;
END CATCH;



/*
add transaction support with error handling to the following Stored procedure

*/


CREATE PROCEDURE Warehouse.DeleteColor
	@ColorID int,
	@MakeItError bit=0
AS
  BEGIN TRY
   BEGIN TRANSACTION
	UPDATE Warehouse.Stockeitems
	SET ColorID =NULL
	WHERE ColorID =@ColorID;

	If@MakeItError =1
		THROW 51001, 'You made me do it!';

	DELETE FROM Warehouse.Colors
	WHERE ColorID =@ColorID;
   COMMIT;
 END TRY

 BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrNumber, ERROR_MESSAGE AS ErrMessage, ERROR_SEVERITY AS ErrSeverity;
	ROLLBACK;
 END CATCH
GO

EXEC Warehouse.DeleteColor 3, 1;
EXEC Warehouse.DeleteColor 1, default;


--in order to successfully implement error handling, surround it WITH BEGIN TRANSACTION - COMMIT and  then further surround it with BEGIN TRY-END TRY  BEGIN CATCH-END CATCH