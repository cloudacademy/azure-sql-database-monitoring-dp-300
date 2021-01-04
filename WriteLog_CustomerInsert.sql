

SELECT *
FROM sys.dm_os_wait_stats

SELECT *
FROM sys.dm_os_schedulers

DBCC SQLPERF('sys.dm_os_wait_stats',CLEAR);  

DECLARE @started DATETIME
DECLARE @finished DATETIME

SET @started = GETDATE()
DECLARE @c INT
SET @c = 1

   WHILE @c < 10000
   BEGIN
	INSERT INTO [Customer] (Code, CustType, [Name]) VALUES ('HOW', 'H', 'How now brown cow')
       SET @c = @c + 1
   END

SET @finished = GETDATE()

SELECT DATEDIFF(millisecond,@started,@finished) AS Elapsed_MS;

COMMIT

select wait_type, waiting_tasks_count, (wait_time_ms - signal_wait_time_ms) as resource_wait_time, (wait_time_ms - signal_wait_time_ms) / waiting_tasks_count as avg_wait_time
from sys.dm_os_wait_stats
where waiting_tasks_count > 0
order by avg_wait_time desc


ALTER DATABASE SalesData SET DELAYED_DURABILITY = DISABLED

