/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

if object_id ('bronze.bronze_customers_accounts','U') is not null
drop table bronze.bronze_customers_accounts;

create table bronze.bronze_customers_accounts (
customer_id varchar(20),
full_name   varchar(30),
date_of_birth varchar(50) ,
email varchar(35),
phone varchar(20),
account_number varchar(10),
account_type varchar(20),
branch varchar(15),
account_open_date varchar(50) ,
account_status varchar(20),
city varchar(20),
country varchar(20)
);

if object_id ('bronze.bronze_transactions','U') is not null
drop table bronze.bronze_transactions;

create table bronze.bronze_transactions(
transaction_id VARCHAR(50),
    account_number VARCHAR(50),
    transaction_date VARCHAR(50),
    amount VARCHAR(50),
    currency VARCHAR(50),
    transaction_type VARCHAR(50),
    channel VARCHAR(50),
    description VARCHAR(255),
    status VARCHAR(50)
);
go
