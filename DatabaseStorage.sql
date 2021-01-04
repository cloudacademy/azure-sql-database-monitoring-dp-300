SELECT *
FROM sys.dm_db_resource_stats


SELECT *
FROM sys.resource_stats

SELECT name, growth * 8192 / 1024 / 1024
FROM sys.database_files;

SELECT SUM(reserved_page_count) * 8192 / 1024 /1024  AS SizeInMB
FROM sys.dm_db_partition_stats

SELECT OBJECT_NAME(p.object_id, p.database_id), index_id,index_type_desc,index_level, avg_fragmentation_in_percent,avg_page_space_used_in_percent,page_count
FROM sys.dm_db_index_physical_stats(DB_ID(N'SalesData'), NULL, NULL, NULL , 'Sampled') p
ORDER BY avg_fragmentation_in_percent DESC

SELECT *
FROM Customer 
WHERE Code LIKE 'FG%'

SELECT *
FROM Customer 
WHERE Code LIKE '%F%G%'

EXEC master.dbo.xp_fixeddrives 