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

* **Purpose:** Stores customer transactions details enriched with demographic and geographic data.
* **Columns:**

| Column Name | Data Type | Description |
| :--- | :--- | :--- |





