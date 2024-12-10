USE [bakery]
GO

-- Remove the user from all roles
ALTER ROLE [db_accessadmin] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_datareader] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_datawriter] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_owner] DROP MEMBER [dbs_admin]
GO

-- Drop the user
DROP USER [dbs_admin]
GO

CREATE USER [dbs_admin] FOR LOGIN [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_owner] ADD MEMBER [dbs_admin]
GO
