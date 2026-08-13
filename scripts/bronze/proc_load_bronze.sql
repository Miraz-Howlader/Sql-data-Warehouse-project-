/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
create or alter procedure bronze.load_bronze as 
begin
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    begin try
    set @batch_start_time = getdate();
PRINT '==================================================';
PRINT 'Loading Bronze Layer';
PRINT '==================================================';

PRINT '--------------------------------------------------';
PRINT 'Loading customers_accounts Tables';
PRINT '--------------------------------------------------';

set @start_time = getdate();
PRINT '>> Truncating Table: bronze.bronze_customers_accounts';

truncate table bronze.bronze_customers_accounts;

PRINT '>> Inserting Data Into: bronze.bronze_customers_accounts';

BULK INSERT bronze.bronze_customers_accounts
FROM 'G:\p_1\bronze_customers_accounts.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
 
 print '>> Load Duration: ' +cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds';
 PRINT '--------------------------------------------------';

PRINT '--------------------------------------------------';
PRINT 'Loading transactions Tables';
PRINT '--------------------------------------------------';

set @start_time = getdate();
PRINT '>> Truncating Table: bronze.bronze_transactions';

truncate table bronze.bronze_transactions;

PRINT '>> Inserting Data Into: bronze.bronze_transactions';

BULK INSERT bronze.bronze_transactions
FROM 'G:\p_1\bronze_transactions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
set @end_time = getdate();
 
 print '>> Load Duration: ' +cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds';
 PRINT '--------------------------------------------------';

     set @batch_end_time = getdate();
     PRINT '==================================================';
    PRINT 'Loading Bronze Layer Is Complete';
    print '>> Total Load Duration: ' +cast(datediff(second,@batch_start_time,@batch_end_time) as varchar) + 'seconds';
    PRINT '==================================================';
    end try
    begin catch
    PRINT '==================================================';
    PRINT 'Error Occured During Loading Bronze Layer';
    PRINT 'Error Message' + ERROR_MESSAGE();
    PRINT 'Error Message' + CAST (ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message' + CAST (ERROR_STATE() AS VARCHAR);
    PRINT '==================================================';
    end catch
end
go
