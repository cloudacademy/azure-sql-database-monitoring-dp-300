DROP TRIGGER [Database_Created] ON ALL SERVER
GO


CREATE TRIGGER Database_Created 
ON ALL SERVER   
FOR CREATE_DATABASE   
AS   
	DECLARE @dbName varchar(2048) 
    SELECT @dbName = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
	
	EXEC msdb.dbo.sp_send_dbmail 
	@recipients = 'someone@azure.com',
	@subject = 'Database Created',
	@body = @dbName,
	@body_format = 'HTML',
	@importance = 'High'		
GO 


CREATE DATABASE [MyNewDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyNewDb', FILENAME = N'E:\MSSQL\DATA\MyNewDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MyNewDb_log', FILENAME = N'F:\MSSQL\Logs\MyNewDb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

DROP DATABASE [MyNewDb]
GO

