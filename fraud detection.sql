-- Objective:
/*To analyze the given fraud detection dataset and identify key patterns, 
trends, 
and relationships that can help understand the factors contributing to fraudulent transactions.
 This analysis will guide the development of better fraud detection strategies.*/
 
USE fraud_detection;

-- view sample data
SELECT * FROM fraud_detection_dataset LIMIT 10;

-- size of Dataset
SELECT COUNT(*) AS total_records FROM fraud_detection_dataset; -- there are 2000 records in total

-- What are the column names and their data types?
DESCRIBE fraud_detection_dataset;

-- Transactional Insights
-- what is the total number of transactions?
-- same as size of data 2000

/*What is the average transaction amount, 
and how does it vary between fraudulent and non-fraudulent transactions?*/
SELECT AVG(Transaction_Amount) AS avg_amount_for_all
FROM fraud_detection_dataset;  -- 511.6175050000007
SELECT Fraudulent, AVG(Transaction_Amount) as avg_amount
FROM fraud_detection_dataset
GROUP BY Fraudulent; -- ave_amount_fraud = 513.6091875626881, avg_amount_nonfraud = 509.637736789631
-- non-fraudulent transactions have a negative deviation(by 2 units)
-- faudulent transactions have a positive deviation(by 2 units)

-- What is the distribution of transaction amounts across different merchant locations?
SELECT Merchant_Location, COUNT(*) AS transaction_count
FROM fraud_detection_dataset
GROUP BY Merchant_Location
ORDER BY transaction_count DESC; -- Korea has more transactions meanwhile Lao People's Democratic Republic has the lowest transactions

-- Fraud Analysis:
-- What percentage of transactions are fraudulent?
SELECT Fraudulent, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fraud_detection_dataset) AS percentage
FROM fraud_detection_dataset
GROUP BY Fraudulent; -- fraudulent: 49.85000, non-fraudulent: 50.15000

-- Which merchants or merchant locations report the highest number of fraudulent transactions?
SELECT Merchant_Location, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Merchant_Location
ORDER BY fraud_count DESC
LIMIT 10; -- Highest: Korea with 13

SELECT Merchant_Name, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Merchant_Name
ORDER BY fraud_count DESC; -- high:Smith PLC

-- Are there specific transaction types more prone to fraud?
SELECT Transaction_Type, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
GROUP BY Transaction_Type
ORDER BY fraud_count DESC; -- online(1003) transactions are prone to fraud than in-store(997)

-- Customer and Card Analysis:
-- Are there customers with multiple fraudulent transactions?
SELECT Customer_Name, Customer_Email, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Customer_Name, Customer_Email
HAVING fraud_count > 1
ORDER BY fraud_count DESC;  -- no

/* Do certain card numbers or expiry dates 
have a higher likelihood of being associated with fraud?*/
SELECT Card_Number, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Card_Number
ORDER BY fraud_count DESC; -- no

-- Device and IP Address Analysis:
-- Which device types are most commonly used for fraudulent transactions?
SELECT Device_Type, COUNT(*) as fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Device_Type
ORDER BY fraud_count DESC; -- Desktop=347, Mobile=329, Tablet=321
-- Desktop is most likely used for fraud transactions

-- Are there specific IP addresses that appear frequently in fraudulent transactions?
SELECT IP_Address, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY IP_Address
ORDER BY fraud_count DESC; -- no

-- Temporal Analysis:
-- Are fraudulent transactions more common on specific dates or times?
SELECT Transaction_Date, COUNT(*) AS fraud_count
FROM fraud_detection_dataset
WHERE Fraudulent = 'True'
GROUP BY Transaction_Date
ORDER BY fraud_count DESC; 

-- fraud detection ny the month
WITH MonthlyFraud AS (
    SELECT 
        MONTH(STR_TO_DATE(Transaction_Date, '%Y-%m-%d')) AS Month,
        COUNT(*) AS Fraudulent_Count
    FROM 
        fraud_detection_dataset
    WHERE 
        Fraudulent = 'True'  -- Adjust based on your dataset
    GROUP BY 
        Month
)
SELECT * 
FROM MonthlyFraud
ORDER BY Month; -- more fraud seems to be happening in month 1 and 2

-- Is there a seasonal pattern in fraudulent activity?
WITH DailyFraud AS (
    SELECT 
        DATE(STR_TO_DATE(Transaction_Date, '%Y-%m-%d %H:%i:%s')) AS transaction_day, 
        COUNT(*) AS fraud_count
    FROM 
        fraud_detection_dataset
    WHERE 
        Fraudulent = 'True' -- Adjust if the Fraudulent value differs
    GROUP BY 
        transaction_day
)
SELECT 
    transaction_day, 
    fraud_count
FROM 
    DailyFraud
ORDER BY 
    fraud_count DESC;
-- I'll deliver my results after doing the visuals


