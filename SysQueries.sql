
select cores_per_socket, cpu_count, hyperthread_ratio, max_workers_count, *
from sys.dm_os_sys_info

select cores_per_socket, cpu_count, max_workers_count, os_quantum
from sys.dm_os_sys_info

select cpu_id, status, is_online, is_idle, total_cpu_usage_ms, quantum_length_us
from sys.dm_os_schedulers
order by status desc, cpu_id asc

SELECT  s.session_id, r.command, r.status,  
   r.wait_type, r.scheduler_id, w.worker_address,  
   w.is_preemptive, w.state, t.task_state,  
   t.session_id, t.exec_context_id, t.request_id  
FROM sys.dm_exec_sessions AS s  
INNER JOIN sys.dm_exec_requests AS r  
   ON s.session_id = r.session_id  
INNER JOIN sys.dm_os_tasks AS t  
   ON r.task_address = t.task_address  
INNER JOIN sys.dm_os_workers AS w  
   ON t.worker_address = w.worker_address  
WHERE s.is_user_process = 0;  

select *
from sys.dm_os_wait_stats

SELECT [object_name], [counter_name], [instance_name], [cntr_value]
FROM sys.dm_os_performance_counters
WHERE cntr_value <> 0


select cpu_count, hyperthread_ratio, physical_memory_kb/1024 AS PhysicalMemoryMB
from sys.dm_os_sys_info


SELECT f.database_id, f.file_id, volume_mount_point, total_bytes, available_bytes, f.name, F.physical_name, available_bytes / 1024 / 1024 / 1024 AS FreeSpaceGB
FROM sys.master_files AS f  
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id)


SELECT TOP 1 storage_in_megabytes AS DatabaseDataSpaceUsedInMB
FROM sys.resource_stats
WHERE database_name = 'SalesData'
ORDER BY end_time DESC 

SELECT SUM(size/128.0) AS [Size MB], SUM(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0) AS [Unused Space MB]
FROM sys.database_files
GROUP BY type_desc
HAVING type_desc = 'ROWS' 

select f.type_desc, f.file_id, f.type_desc, f.name, f.physical_name, f.size/128 AS [Size MB], f.max_size/128 AS [Max Size MB], size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS [Unused Space MB]
FROM sys.database_files f
 
Select *
from sys.dm_db_wait_stats
order by wait_time_ms desc

SELECT *
FROM sys.dm_os_wait_stats
WHERE waiting_tasks_count > 0

SELECT
         cpu_idle = record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int'),
         cpu_sql = record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int')
FROM (
         SELECT TOP 1 CONVERT(XML, record) AS record
         FROM sys.dm_os_ring_buffers
         WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
         AND record LIKE '% %'
		 ORDER BY TIMESTAMP DESC
) as cpu_usage


select top 200
    start_time,
    [cpu usage %] = avg_cpu_percent
from sys.server_resource_stats
order by start_time desc

SELECT * 
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO
SELECT session_id, wait_duration_ms, wait_type, blocking_session_id 
FROM sys.dm_os_waiting_tasks 
WHERE blocking_session_id <> 0

EXEC sp_who2

SELECT TOP 10 r.session_id, r.plan_handle, r.sql_handle, r.request_id, r.start_time, r.status, r.command, r.database_id, r.user_id, r.wait_type, r.wait_time, r.last_wait_type, r.wait_resource, r.total_elapsed_time,  
r.cpu_time, r.transaction_isolation_level,      r.row_count, st.text  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) as st  
WHERE r.blocking_session_id = 0       
and r.session_id in(SELECT distinct(blocking_session_id)           
FROM sys.dm_exec_requests)  
GROUP BY r.session_id, r.plan_handle,      r.sql_handle, r.request_id,      r.start_time, r.status,      r.command, r.database_id,      r.user_id, r.wait_type,      r.wait_time, r.last_wait_type,  r.wait_resource, r.total_elapsed_time,      r.cpu_time, r.transaction_isolation_level,      r.row_count, st.text  ORDER BY r.total_elapsed_time desc


SELECT *
FROM sys.dm_tran_active_transactions

SELECT *
FROM sys.dm_tran_locks

SELECT session_id, blocking_session_id, start_time, command, DB_NAME(database_id) as [database], 
	wait_type, wait_time, open_transaction_count, st.text
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) as st 
WHERE blocking_session_id > 0