/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.bronze_customers_accounts '
-- ====================================================================

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
select
customer_id,
count(*)
from silver.bronze_customers_accounts 
group by customer_id
having count(*) > 1

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT 
    *
FROM silver.bronze_customers_accounts 
WHERE full_name != TRIM(full_name)
   OR phone != TRIM(phone)
   OR account_number != TRIM(account_number)
   OR account_type != TRIM(account_type)
   OR account_status != TRIM(account_status)
   OR city != TRIM(city)
   OR customer_id != TRIM(customer_id);

--Data Standardization & Consistency
select 
distinct (account_type )
from silver.bronze_customers_accounts ;

-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT 
    date_of_birth
FROM silver.bronze_customers_accounts 
WHERE TRY_CAST(date_of_birth AS DATE) IS NULL 
   OR TRY_CAST(date_of_birth AS DATE) < '1900-01-01'
   OR TRY_CAST(date_of_birth AS DATE) > GETDATE();



-- ====================================================================
-- Checking 'silver.bronze_transactions'
-- ====================================================================

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
select
transaction_id,
count(*)
from silver.bronze_transactions
group by transaction_id
having count(*) > 1

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT 
    *
FROM silver.bronze_transactions
WHERE transaction_id != TRIM(transaction_id)
   OR account_number != TRIM(account_number)
   OR description != TRIM(description)
   OR transaction_type != TRIM(transaction_type)
   OR currency != TRIM(currency)
   OR channel != TRIM(channel)
   OR status != TRIM(status);

--Data Standardization & Consistency
select 
distinct(channel )
from silver.bronze_transactions;

-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT 
    transaction_date
FROM silver.bronze_transactions
WHERE TRY_CAST(transaction_date AS DATE) IS NULL 
   OR TRY_CAST(transaction_date AS DATE) < '1900-01-01'
   OR TRY_CAST(transaction_date AS DATE) > GETDATE();
