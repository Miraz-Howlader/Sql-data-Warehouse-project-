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
| account_type | varchar(20) | The customer's account_type |
| branch | varchar(15)| The branch details of the customer (e.g., 'Gulshan', 'Uttara'). |
| account_status | DATE | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). |
| country | NVARCHAR(50) | The country of residence for the customer (e.g., 'Australia'). |
| marital_status | NVARCHAR(50) | The marital status of the customer (e.g., 'Married', 'Single'). |
| gender | NVARCHAR(50) | The gender of the customer (e.g., 'Male', 'Female', 'n/a'). |
| birthdate | DATE | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). |
| create_date | DATE | The date and time when the customer record was created in the system. |
