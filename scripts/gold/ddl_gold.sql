/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

--===========================================
--Create Dimension : gold.dim_customers
--===========================================
if object_id ('gold.dim_customers','V') is not null
drop table gold.dim_customers;
go
    CREATE VIEW gold.dim_customers AS
    SELECT 
    ROW_NUMBER() OVER(ORDER BY customer_id) AS Customer_KEY,
    customer_id,
    account_number,
    full_name AS customer_name,
    account_type,
    branch,
    account_status,
    city,
    country,
    account_open_date,
    email,
    phone
FROM silver.bronze_customers_accounts;
go

--===========================================
--Create Fact Table: gold.fact_transactions
--===========================================
if object_id ('gold.fact_transactions','V') is not null
drop table gold.fact_transactions;
go

    CREATE VIEW gold.fact_transactions AS
    SELECT 
    ROW_NUMBER() OVER(ORDER BY transaction_id) AS transaction_KEY,
    transaction_id,
    account_number,
    transaction_date,
    amount_signed,
    currency,
    transaction_type,
    channel,
    status,
    is_amount_missing,
    is_amount_outlier,
    is_orphan_account,
    is_predates_account_open
FROM silver.bronze_transactions
go
