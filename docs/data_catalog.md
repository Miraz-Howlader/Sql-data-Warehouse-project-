Markdown
# Data Dictionary for Gold Layer

## Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

## 1. gold.dim_customers

* **Purpose:** Stores customer details enriched with demographic and geographic data.
* **Columns:**

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| Customer_KEY | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id | varchar(20) | Unique identifier assigned to each customer. |
| account_number | varchar(10) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| customer_name |varchar(30) | The customer's full name, as recorded in the system. |
| account_type | varchar(20) | The customer's account_type (e.g., 'Credit Card', 'Saving').|
| branch | varchar(15)| The branch details of the customer (e.g., 'Gulshan', 'Uttara'). |
| account_status | varchar(20) | Present Status of the customer account (e.g., 'Active','Inactive'). |
| city  | varchar(20) | The city of residence for the customer (e.g., 'Dhaka','Chattogram'). |
| country | varchar(20) | The country of residence for the customer (e.g., 'Bangladesh'). |
| account_open_date | DATE | The date of opening of the customer account, formatted as YYYY-MM-DD (e.g., 2016-10-15). |
| email  | varchar(35) | The customer's email account, as recorded in the system. |
| phone | INT | The customer's phone number, as recorded in the system. |

## 2. gold.fact_transactions

* **Purpose:** Stores transactions details enriched with demographic and geographic data.
* **Columns:**

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| transaction_KEY | INT | Surrogate key uniquely identifying each transaction record in the fact table. |
| transaction_id | VARCHAR(50) | Unique identifier assigned to each transaction. |
| account_number | varchar(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| transaction_date | DATE | The date of transaction of the customer account, formatted as YYYY-MM-DD (e.g., 2024-04-18). |
| amount_signed |decimal(25,2) | The customer's deposits/refunds are inflows (+), withdrawals/payments/fees/transfers are outflows (-) (e.g., 66842.64,-8201.50). |
| currency | varchar(50) | The currency in which the transaction was completed (e.g., 'BDT', 'USD').|
| transaction_type | varchar(50)| which process the transaction was completed (e.g., 'Deposit', 'Payment'). |
| channel | varchar(50) | which way the transaction was completed (e.g., 'Online','Branch'). |
| status  | varchar(50) | status of the transaction  (e.g., 'Failed','Pending'). |
| is_amount_missing | bit | the transaction amount is null? (e.g., 'amount is null =1','amount is not null =0').  |
| is_amount_outlier | bit | the transaction amount is outlier? (e.g., 'amount is outlier =1','amount is not outlier =0').  |
| is_orphan_account | bit | the account number is null? (e.g., 'account number is null =1','account number is not null =0').  |
| is_predates_account_open | bit | open date > transaction date and those is not null? (e.g., 'true=1','false =0').  |






