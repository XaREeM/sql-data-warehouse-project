/*
==============================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==============================================
Script purpose:
	This script loads data into the 'bronze' schema from CSV files, performing the following:
	- Truncate tables before loading data.
	- Use 'BULK INSERT' command for loading.
	- Calcuate the time of loading for each table and the whole batch as well.

No parameters required for this procedure.

Use the following command for execution:
	- EXEC bronze.load_bronze;
*/

CREATE or ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE()
		-- Printing more details to the chunks of code for more clarity at execution phase
		PRINT '============================================================'
		PRINT 'Loading Bronze Layer'
		PRINT '============================================================'

		PRINT '------------------------------------------------------------'
		PRINT 'Loding CRM Table'
		PRINT '------------------------------------------------------------'
	
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		-- Truncate and then fillup the bronze.crm_cust_info table
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		-- Bulk extract from CSV and load into the database's target table
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK,
			ERRORFILE = 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_crm\errors.txt'
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK insert bronze.crm_sales_details
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'

		PRINT '------------------------------------------------------------'
		PRINT 'Loding ERP Table'
		PRINT '------------------------------------------------------------'
	
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		BULK insert bronze.erp_cust_az12
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'

		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINt '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\LENOVO\Desktop\Data Analysis\Data_With_Baraa\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> -------------------'
		SET @batch_end_time = GETDATE()
 
		PRINT '============================================================'
		PRINT 'Loading Bronze Layer is Completed'
		PRINT '  - Total Load Duration: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '============================================================'

	END TRY
	BEGIN CATCH
		PRINT '============================================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE()
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR)
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT '============================================================'
	END CATCH
END
