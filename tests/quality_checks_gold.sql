/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ============================================================================
-- Checking 'gold.dim_customers'
-- ============================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results

SELECT 
Customer_KEY,
COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY Customer_KEY
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_transactions'
-- ====================================================================
-- Check for Uniqueness of transaction Key in gold.dim_products
-- Expectation: No results

SELECT 
transaction_KEY,
COUNT(*) AS duplicate_count
FROM gold.fact_transactions
GROUP BY transaction_KEY
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check Data Model Connectivity / Referential Integrity
-- Check connectivity between Fact and Dimension using 'account_number'
-- ====================================================================
-- Expectation: Orphan records or missing joins (if any)

SELECT 
f.transaction_KEY,
f.transaction_id,
f.account_number AS fact_account_number,
c.account_number AS dim_account_number,
c.customer_name
FROM gold.fact_transactions f
LEFT JOIN gold.dim_customers c
    ON f.account_number = c.account_number
WHERE c.account_number IS NULL;
