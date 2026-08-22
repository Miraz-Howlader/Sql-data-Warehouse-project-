# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. 

---

## 📖 Project Overview

This project involves:

1. **Data Architecture:** Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines:** Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting:** Creating SQL-based reports and dashboards for actionable insights.

🎯 **Key Skills & Expertise Highlighted:**
* SQL Development
* Data Engineering & Architecture (Medallion Architecture)
* ETL / ELT Pipeline Development
* Data Modeling (Star Schema, Fact & Dimension Tables)
* Data Analytics & Reporting

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**

Develop a modern data warehouse using SQL Server to consolidate Finance / Banking transactions data, enabling analytical reporting and informed decision-making.

**Specifications**

* **Data Sources:** Import customer, account, and transaction datasets provided as CSV files.
* **Data Quality:** Cleanse and resolve data quality issues prior to analysis.
* **Integration:** Combine all sources into a single, user-friendly data model designed for analytical queries.
* **Scope:** Focus on the latest dataset only; historization of data is not required.
* **Documentation:** Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analytics)

**Objective**

Develop SQL-based analytics to deliver detailed insights into:

* **Customer & Account Analysis:** Segmenting customer base (Active, At Risk, Churned) and tracking lifetime net inflows/outflows.
* **Transaction Behavior Analysis:** Analyzing month-over-month trends, transaction channels, and volume distribution.
* **Branch Performance Analysis:** Identifying top-performing branches and tracking failure/error rates operationally.
* **Risk & Data Quality Analysis:** Auditing anomalies, orphan records, outlier transactions, and fraud-style patterns.

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

For more details, refer to 

## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

<img width="899" height="527" alt="{08BF56C4-7F0A-4765-8D75-A25CA6688106}" src="https://github.com/user-attachments/assets/45812810-dde8-4201-b33a-3163f83fe0ff" />


1. **Bronze Layer:** Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer:** This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer:** Houses business-ready data modeled into a star schema required for reporting and analytics.

## 📁 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                   # Raw datasets used for the project (customer account and transaction data)
│
├── docs/                       # Project documentation and architecture details
│   ├── etl.drawio              # Draw.io file shows all different techniques and methods of ETL
│   ├── data_architecture.drawio# Draw.io file shows the project's architecture
│   ├── data_catalog.md         # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio        # Draw.io file for the data flow diagram
│   ├── data_models.drawio      # Draw.io file for data models (star schema)
│   └── naming-conventions.md   # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                    # SQL scripts for ETL and transformations
│   ├── bronze/                 # Scripts for extracting and loading raw data
│   ├── silver/                 # Scripts for cleaning and transforming data
│   └── gold/                   # Scripts for creating analytical models
│
├── tests/                      # Test scripts and quality files
│
├── README.md                   # Project overview and instructions
├── LICENSE                     # License information for the repository
├── .gitignore                  # Files and directories to be ignored by Git
└── requirements.txt            # Dependencies and requirements for the project

```

## 🛡️ License

This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.

---

## 🌟 About Me & Contact

Hi there! I'm **Miraz Howlader**, a passionate **Data Analyst** with a strong problem-solving mindset and expertise in data engineering, analytics, and risk management. I love transforming raw data into structured insights and building scalable data solutions to drive business decisions.

I am actively open to opportunities in **Data Analytics, Data Engineering, and Business Intelligence**.

Let's connect! Feel free to reach out to me:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/miraz-howlader)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mdmirazhowladermiraz491@gmail.com)
