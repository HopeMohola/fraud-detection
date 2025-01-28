# Title: Fraud Detection Analysis with SQL

## Description:
This repository contains SQL scripts for analyzing a fraud detection dataset. The dataset consists of transaction details such as customer and merchant information, transaction dates, amounts, and labels indicating fraudulent activity. The aim is to extract meaningful insights and trends in fraudulent activity.

## Features:

## Data Import:
SQL query to load the dataset into MySQL Workbench.

## Data Analysis:
1. Identifying fraudulent trends by day, month, and customer.
2. Extracting high-risk customers and merchants using SQL queries.
3. Advanced analysis using Common Table Expressions (CTEs).

## data/:
Contains the dataset or instructions to download it.

## scripts/:
1. data_import.sql: Query for importing the CSV dataset.
2. data_exploration.sql: Queries for exploring and understanding the dataset.
3. fraud_trends_analysis.sql: SQL queries to analyze fraud patterns.
4. advanced_cte_queries.sql: Advanced queries using CTEs to generate insights.

## results/:
Images or CSVs showing analysis results like fraud trends by month or day.

## SQL Highlights:
Fraud by Month:

WITH MonthlyFraud AS (
    SELECT 
        MONTH(STR_TO_DATE(Transaction_Date, '%Y-%m-%d')) AS Month,
        COUNT(*) AS Fraudulent_Count
    FROM 
        fraud_detection_dataset
    WHERE 
        Fraudulent = 'Yes'
    GROUP BY 
        Month
)
SELECT * FROM MonthlyFraud ORDER BY Fraudulent_Count DESC;
Fraud by Day (Using CTE):


WITH DailyFraud AS (
    SELECT 
        DATE(STR_TO_DATE(Transaction_Date, '%Y-%m-%d %H:%i:%s')) AS transaction_day,
        COUNT(*) AS fraud_count
    FROM 
        fraud_detection_dataset
    WHERE 
        Fraudulent = 'Yes'
    GROUP BY 
        transaction_day
)
SELECT * FROM DailyFraud ORDER BY fraud_count DESC;
High-Risk Customers:


SELECT 
    Customer_Name, 
    COUNT(*) AS fraud_count
FROM 
    fraud_detection_dataset
WHERE 
    Fraudulent = 'Yes'
GROUP BY 
    Customer_Name
HAVING fraud_count > 1
ORDER BY fraud_count DESC;
Insights:
Fraud peaks during certain months and days, indicating temporal patterns.
Certain customers and merchants are involved in recurring fraud, helping identify high-risk entities.
Using CTEs, complex queries are simplified for better analysis.

## How to Use:
Clone the repository:
git clone https://github.com/HopeMohola/fraud-detection-analysis.git
Import the dataset into MySQL Workbench using data_import.sql.
Run queries in data_exploration.sql and fraud_trends_analysis.sql to extract insights, I used MySQL Workbench.

## Future Work:
Extend analysis to include more granular time trends.
Combine SQL queries with visualization tools like PowerBI.
