/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

create or alter procedure silver.load_silver as
begin
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
    SET @batch_start_time = GETDATE();
    PRINT '========================================';
    PRINT 'Loading Silver Layer';
    PRINT '========================================';

    PRINT '----------------------------------------';
    PRINT 'Loading customers_accounts Tables';
    PRINT '----------------------------------------';

    -- Loading silver.bronze_customers_accounts
    SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.bronze_customers_accounts';
TRUNCATE TABLE silver.bronze_customers_accounts;

PRINT '>> Inserting Data Into: silver.bronze_customers_accounts';
INSERT INTO silver.bronze_customers_accounts (
    customer_id,
    full_name,
    date_of_birth,
    email,
    phone,
    account_number,
    account_type,
    branch,
    account_open_date,
    account_status,
    city,
    country)
SELECT 
    customer_id,
    TRIM(full_name) AS full_name,
    silver.parse_flexible_date (date_of_birth) as date_of_birth,
    email,
    SUBSTRING(
    REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', ''),
    LEN(REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', '')) - 10,
    11
) AS phone,
    trim(account_number) as account_number ,
    CASE 
        When upper(trim(account_type)) in('SAVINGS','SAVING') then 'Saving'
        When upper(trim(account_type)) in ('FIXED DEPOSIT','FD') then 'Fixed Deposit'
        When upper(trim(account_type)) in ('CREDIT CARD','CC') then 'Credit Card'
        When upper(trim(account_type)) in ('CHECKING','CHK') then 'Checking'
        Else 'N/A'
    END account_type,
    branch,
    silver.parse_flexible_date (account_open_date) as account_open_date,
    CASE
    WHEN upper(TRIM(account_status)) = 'ACTIVE' then 'Active'
    WHEN upper(TRIM(account_status))= 'CLOSED' then 'Closed'
    WHEN upper(TRIM(account_status)) = 'INACTIVE' then 'Inactive'
    WHEN upper(TRIM(account_status)) = 'SUSPENDED' then 'Suspended'
    ELSE 'N/A'
    END account_status,
    CASE
    WHEN upper(TRIM(city)) = 'DHAKA' then 'Dhaka' 
    WHEN upper(TRIM(city)) = 'CHATTOGRAM' then 'Chattogram'
    WHEN upper(TRIM(city)) = 'COMILLA' then 'Comilla'
    WHEN upper(TRIM(city)) = 'BARISHAL' then 'Barishal'
    WHEN upper(TRIM(city)) = 'KHULNA' then 'Khulna'
    WHEN upper(TRIM(city)) = 'RAJSHAHI' then 'Rajshahi'
    WHEN upper(TRIM(city)) = 'SYLHET' then 'Sylhet'
    Else 'N/A'
    End city,
    country
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id 
               ORDER BY (SELECT NULL)
           ) AS row_num
    FROM bronze.bronze_customers_accounts
    WHERE customer_id IS NOT NULL
)t WHERE row_num = 1;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> ------------';

    PRINT '----------------------------------------';
    PRINT 'Loading customers_transactions Tables';
    PRINT '----------------------------------------';

-- Loading silver.bronze_transactions;

    SET @start_time = GETDATE();


PRINT '>> Truncating Table: silver.bronze_transactions';
TRUNCATE TABLE silver.bronze_transactions;

PRINT '>> Inserting Data Into: silver.bronze_transactions';
insert into silver.bronze_transactions (
transaction_id,
account_number,
transaction_date,
amount,
currency,
transaction_type,
channel,
description,
status
)

SELECT 
transaction_id,
trim(account_number) as account_number,
silver.parse_flexible_date (transaction_date) AS transaction_date,
isnull(TRY_CAST(
    REPLACE(
        REPLACE(TRIM(amount), 'BDT', ''), 
        ',', ''
    ) AS DECIMAL(25, 2)
),0) AS amount,
case
when upper(trim(currency)) = 'BDT' then 'BDT'
when upper(trim(currency)) = 'USD' then 'USD'
else 'N/A'
end currency,
case
when upper(trim(transaction_type)) = 'DEPOSIT' then 'Deposit'
when upper(trim(transaction_type)) = 'FEE' then 'Fee'
when upper(trim(transaction_type)) in ('PAYMENT','PMT') then 'Payment'
when upper(trim(transaction_type)) = 'REFUND' then 'Refund'
when upper(trim(transaction_type)) in ('TRANSFER','TRF') then 'Transfer'
when upper(trim(transaction_type)) in ('WITHDRAWAL','WD') then 'Withdraw'
else 'N/A'
end transaction_type,
case
when upper(trim(channel)) = 'ATM' then 'ATM'
when upper(trim(channel)) = 'BRANCH' then 'Branch'
when upper(trim(channel)) = 'MOBILE APP' then 'Mobile App'
when upper(trim(channel)) = 'ONLINE' then 'Online'
when upper(trim(channel)) = 'POS' then 'POS'
else 'N/A'
end channel,
trim(description) as description,
case
when upper(trim(status)) = 'COMPLETED' then 'Completed'
when upper(trim(status)) = 'FAILED' then 'Failed'
when upper(trim(status)) = 'PENDING' then 'Pending'
when upper(trim(status)) = 'REVERSED' then 'Reversed'
else 'N/A'
end status
FROM (SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY transaction_id 
               ORDER BY (SELECT NULL)
           ) AS row_num
    FROM bronze.bronze_transactions
    WHERE transaction_id IS NOT NULL
)t WHERE row_num = 1;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> ------------';



SET @batch_end_time = GETDATE();
PRINT '========================================';
PRINT 'Loading Silver Layer is Completed';
PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
PRINT '========================================';

END TRY
BEGIN CATCH
    PRINT '========================================';
    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    PRINT 'Error Message' + ERROR_MESSAGE();
    PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
    PRINT '========================================';
END CATCH

end
