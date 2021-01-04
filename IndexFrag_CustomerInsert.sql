CREATE FUNCTION NewCode(@Lower int, @Upper INT) RETURNS VARCHAR(18) AS
BEGIN
	DECLARE @Code VARCHAR(18)

	SET @Code = CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0))
	RETURN @Code
END
GO

CREATE NONCLUSTERED INDEX [CustCode_IDX] ON [dbo].[Customer]
(
	[Code] ASC
)
GO

SELECT a.object_id, object_name(a.object_id) AS TableName, a.index_id, name AS IndedxName, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID (N'SalesData')
        , OBJECT_ID(N'dbo.Customer')
        , NULL
        , NULL
        , NULL) AS a
INNER JOIN sys.indexes AS b
    ON a.object_id = b.object_id
    AND a.index_id = b.index_id;
GO

DBCC SHOW_STATISTICS ('dbo.Customer', CustCode_IDX)

UPDATE STATISTICS dbo.Customer CustCode_IDX FULLSCAN

ALTER INDEX PK_Customer
    ON dbo.Customer
    REBUILD;

ALTER INDEX CustCode_IDX
    ON dbo.Customer
    REBUILD;

ALTER INDEX ALL ON dbo.Customer
    REORGANIZE;


DECLARE @started DATETIME
DECLARE @finished DATETIME
DECLARE @Code VARCHAR(18)
DECLARE @n INT

DECLARE @Upper INT;
DECLARE @Lower INT
SET @started = GETDATE()

SET @n = 1
SET @Lower = 65 ---- The lowest random number
SET @Upper = 90 ---- The highest random number
BEGIN TRAN
WHILE @n < 1000000 BEGIN

	SET @Code = CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CHAR(ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)) + CAST(@n AS VArchar)

	INSERT INTO [Customer] (Code, CustType, [Name]) VALUES (@Code, 'H', 'New Customer')
    SET @n = @n + 1

END
COMMIT

SET @finished = GETDATE()

SELECT DATEDIFF(millisecond,@started,@finished) AS Elapsed_MS;
GO
