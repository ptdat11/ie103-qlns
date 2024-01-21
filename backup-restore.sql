--backup
CREATE OR ALTER PROCEDURE BackUpDatabase
	@Path NVARCHAR(MAX)
AS BEGIN
	BACKUP DATABASE QLNS
	TO DISK = @Path
		WITH FORMAT,
			MEDIANAME = 'SQLSeverBackups',
			NAME = 'Full Backup of QLNS'
END
GO

--restore
CREATE OR ALTER PROCEDURE RestoreDatabase
	@Path NVARCHAR(MAX)
AS BEGIN 
	RESTORE DATABASE QLNS
	FROM DISK = @Path
END
GO