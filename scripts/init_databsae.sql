/*
==============================================
Create Databse and Schemas
==============================================
Script purpose:
	Create a new databse after checking whether it exists or not. If yes, it gets dropped first then gets recreated

WARNING:
	Running this script drops the entire databse and recreates it from scratch. Ensure this is the required action
	before proceeding.
*/


USE master;

IF EXISTS (SELECT * FROM sys.databases WHERE name='DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWareHouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
