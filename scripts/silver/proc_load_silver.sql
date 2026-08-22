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

EXEC silver.load_silver

CREATE OR ALTER PROCEDURE silver.load_silver 
AS
BEGIN
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
            country
        )
        SELECT 
            customer_id, 
            TRIM(full_name) AS full_name,
            silver.parse_flexible_date(date_of_birth) AS date_of_birth,
            NULLIF(TRIM(email), '') AS email,
            NULLIF(
                SUBSTRING(
                    REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', ''),
                    LEN(REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', '')) - 10,
                    11
                ), 
                ''
            ) AS phone,
            TRIM(account_number) AS account_number,
            CASE 
                WHEN UPPER(TRIM(account_type)) IN ('SAVINGS','SAVING') THEN 'Saving'
                WHEN UPPER(TRIM(account_type)) IN ('FIXED DEPOSIT','FD') THEN 'Fixed Deposit'
                WHEN UPPER(TRIM(account_type)) IN ('CREDIT CARD','CC') THEN 'Credit Card'
                WHEN UPPER(TRIM(account_type)) IN ('CHECKING','CHK') THEN 'Checking'
                ELSE 'N/A'
            END AS account_type,
            TRIM(branch) AS branch,
            silver.parse_flexible_date(account_open_date) AS account_open_date,
            CASE
                WHEN UPPER(TRIM(account_status)) = 'ACTIVE' THEN 'Active'
                WHEN UPPER(TRIM(account_status)) = 'CLOSED' THEN 'Closed'
                WHEN UPPER(TRIM(account_status)) = 'INACTIVE' THEN 'Inactive'
                WHEN UPPER(TRIM(account_status)) = 'SUSPENDED' THEN 'Suspended'
                ELSE 'N/A'
            END AS account_status,
            CASE
                WHEN UPPER(TRIM(city)) = 'DHAKA' THEN 'Dhaka' 
                WHEN UPPER(TRIM(city)) = 'CHATTOGRAM' THEN 'Chattogram'
                WHEN UPPER(TRIM(city)) = 'COMILLA' THEN 'Comilla'
                WHEN UPPER(TRIM(city)) = 'BARISHAL' THEN 'Barishal'
                WHEN UPPER(TRIM(city)) = 'KHULNA' THEN 'Khulna'
                WHEN UPPER(TRIM(city)) = 'RAJSHAHI' THEN 'Rajshahi'
                WHEN UPPER(TRIM(city)) = 'SYLHET' THEN 'Sylhet'
                ELSE 'N/A'
            END AS city,
            TRIM(country) AS country
        FROM (
            SELECT *,
                   ROW_NUMBER() OVER (
                       PARTITION BY customer_id 
                       ORDER BY (SELECT NULL)
                   ) AS row_num
            FROM bronze.bronze_customers_accounts
            WHERE account_number IS NOT NULL AND TRIM(account_number) != ''
        ) t 
        WHERE row_num = 1;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------';


        PRINT '----------------------------------------';
        PRINT 'Loading customers_transactions Tables';
        PRINT '----------------------------------------';

        -- Loading silver.bronze_transactions with Flags & Signed Amount
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.bronze_transactions';
        TRUNCATE TABLE silver.bronze_transactions;
        
        PRINT '>> Inserting Data Into: silver.bronze_transactions';
       
        WITH cleaned AS (
            SELECT 
                TRIM(transaction_id) AS transaction_id,
                TRIM(account_number) AS account_number,
                silver.parse_flexible_date(transaction_date) AS transaction_date,
                TRY_CAST(
                    REPLACE(REPLACE(TRIM(amount), 'BDT', ''), ',', '') AS DECIMAL(25, 2)
                ) AS amount,
                CASE
                    WHEN UPPER(TRIM(currency)) = 'BDT' THEN 'BDT'
                    WHEN UPPER(TRIM(currency)) = 'USD' THEN 'USD'
                    ELSE 'N/A'
                END AS currency,
                CASE
                    WHEN UPPER(TRIM(transaction_type)) = 'DEPOSIT' THEN 'Deposit'
                    WHEN UPPER(TRIM(transaction_type)) = 'FEE' THEN 'Fee'
                    WHEN UPPER(TRIM(transaction_type)) IN ('PAYMENT','PMT') THEN 'Payment'
                    WHEN UPPER(TRIM(transaction_type)) = 'REFUND' THEN 'Refund'
                    WHEN UPPER(TRIM(transaction_type)) IN ('TRANSFER','TRF') THEN 'Transfer'
                    WHEN UPPER(TRIM(transaction_type)) IN ('WITHDRAWAL','WD') THEN 'Withdraw'
                    ELSE 'N/A'
                END AS transaction_type,
                CASE
                    WHEN UPPER(TRIM(channel)) = 'ATM' THEN 'ATM'
                    WHEN UPPER(TRIM(channel)) = 'BRANCH' THEN 'Branch'
                    WHEN UPPER(TRIM(channel)) = 'MOBILE APP' THEN 'Mobile App'
                    WHEN UPPER(TRIM(channel)) = 'ONLINE' THEN 'Online'
                    WHEN UPPER(TRIM(channel)) = 'POS' THEN 'POS'
                    ELSE 'N/A'
                END AS channel,
                TRIM(description) AS description,
                CASE
                    WHEN UPPER(TRIM(status)) = 'COMPLETED' THEN 'Completed'
                    WHEN UPPER(TRIM(status)) = 'FAILED' THEN 'Failed'
                    WHEN UPPER(TRIM(status)) = 'PENDING' THEN 'Pending'
                    WHEN UPPER(TRIM(status)) = 'REVERSED' THEN 'Reversed'
                    ELSE 'N/A'
                END AS status
            FROM (
                SELECT *,
                       ROW_NUMBER() OVER (
                           PARTITION BY transaction_id 
                           ORDER BY (SELECT NULL)
                       ) AS row_num
                FROM bronze.bronze_transactions
                WHERE transaction_id IS NOT NULL AND TRIM(transaction_id) != ''
            ) t 
            WHERE row_num = 1
        )
        INSERT INTO silver.bronze_transactions (
            transaction_id,
            account_number,
            transaction_date,
            amount,
            currency,
            transaction_type,
            channel,
            description,
            status,
            amount_signed,
            is_amount_missing,
            is_amount_outlier,
            is_orphan_account,
            is_predates_account_open
        )
        SELECT 
            c.transaction_id,
            c.account_number,
            c.transaction_date,
            ISNULL(c.amount, 0) AS amount,
            c.currency,
            c.transaction_type,
            c.channel,
            c.description,
            c.status,
            -- Sign Normalization
            CASE
                WHEN c.transaction_type IN ('Deposit', 'Refund') THEN ABS(ISNULL(c.amount, 0))
                ELSE -ABS(ISNULL(c.amount, 0))
            END AS amount_signed,
            -- Quality Flags
            CAST(IIF(c.amount IS NULL, 1, 0) AS BIT) AS is_amount_missing,
            CAST(IIF(c.amount IS NOT NULL AND ABS(c.amount) > 400000, 1, 0) AS BIT) AS is_amount_outlier,
            CAST(IIF(a.account_number IS NULL, 1, 0) AS BIT) AS is_orphan_account,
            CAST(IIF(a.account_open_date IS NOT NULL AND c.transaction_date IS NOT NULL AND c.transaction_date < a.account_open_date, 1, 0) AS BIT) AS is_predates_account_open
        FROM cleaned c
        LEFT JOIN silver.bronze_customers_accounts a
            ON c.account_number = a.account_number;

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
        PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '========================================';
    END CATCH
END;
