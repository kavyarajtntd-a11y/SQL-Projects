-- Module End Assignment 2
-- MySQL: E-Commerce Customer Churn Analysis
-- Database: ecomm
-- Main table: customer_churn


USE ecomm;

-- Disable Safe Update Mode for assignment data-cleaning updates.
SET SQL_SAFE_UPDATES = 0;


-- ============================================================
-- PART 1: DATA CLEANING
-- ============================================================

-- 1. HANDLE MISSING VALUES
-- Impute mean values and round to the nearest integer.

SET @mean_WarehouseToHome = (
    SELECT ROUND(AVG(WarehouseToHome))
    FROM customer_churn
    WHERE WarehouseToHome IS NOT NULL
);

UPDATE customer_churn
SET WarehouseToHome = @mean_WarehouseToHome
WHERE WarehouseToHome IS NULL;


SET @mean_HourSpendOnApp = (
    SELECT ROUND(AVG(HourSpendOnApp))
    FROM customer_churn
    WHERE HourSpendOnApp IS NOT NULL
);

UPDATE customer_churn
SET HourSpendOnApp = @mean_HourSpendOnApp
WHERE HourSpendOnApp IS NULL;


SET @mean_OrderAmountHikeFromlastYear = (
    SELECT ROUND(AVG(OrderAmountHikeFromlastYear))
    FROM customer_churn
    WHERE OrderAmountHikeFromlastYear IS NOT NULL
);

UPDATE customer_churn
SET OrderAmountHikeFromlastYear = @mean_OrderAmountHikeFromlastYear
WHERE OrderAmountHikeFromlastYear IS NULL;


SET @mean_DaySinceLastOrder = (
    SELECT ROUND(AVG(DaySinceLastOrder))
    FROM customer_churn
    WHERE DaySinceLastOrder IS NOT NULL
);

UPDATE customer_churn
SET DaySinceLastOrder = @mean_DaySinceLastOrder
WHERE DaySinceLastOrder IS NULL;


-- Impute mode values for Tenure, CouponUsed and OrderCount.

SET @mode_Tenure = (
    SELECT Tenure
    FROM customer_churn
    WHERE Tenure IS NOT NULL
    GROUP BY Tenure
    ORDER BY COUNT(*) DESC, Tenure ASC
    LIMIT 1
);

UPDATE customer_churn
SET Tenure = @mode_Tenure
WHERE Tenure IS NULL;


SET @mode_CouponUsed = (
    SELECT CouponUsed
    FROM customer_churn
    WHERE CouponUsed IS NOT NULL
    GROUP BY CouponUsed
    ORDER BY COUNT(*) DESC, CouponUsed ASC
    LIMIT 1
);

UPDATE customer_churn
SET CouponUsed = @mode_CouponUsed
WHERE CouponUsed IS NULL;


SET @mode_OrderCount = (
    SELECT OrderCount
    FROM customer_churn
    WHERE OrderCount IS NOT NULL
    GROUP BY OrderCount
    ORDER BY COUNT(*) DESC, OrderCount ASC
    LIMIT 1
);

UPDATE customer_churn
SET OrderCount = @mode_OrderCount
WHERE OrderCount IS NULL;


-- Check the imputed values.
-- Expected means: WarehouseToHome=16, HourSpendOnApp=3,
-- OrderAmountHikeFromlastYear=16, DaySinceLastOrder=5
-- Expected modes: Tenure=1, CouponUsed=1, OrderCount=2
SELECT
    @mean_WarehouseToHome AS Mean_WarehouseToHome,
    @mean_HourSpendOnApp AS Mean_HourSpendOnApp,
    @mean_OrderAmountHikeFromlastYear AS Mean_OrderAmountHikeFromlastYear,
    @mean_DaySinceLastOrder AS Mean_DaySinceLastOrder,
    @mode_Tenure AS Mode_Tenure,
    @mode_CouponUsed AS Mode_CouponUsed,
    @mode_OrderCount AS Mode_OrderCount;


-- Verify that required missing values were filled.
SELECT
    SUM(WarehouseToHome IS NULL) AS WarehouseToHome_Nulls,
    SUM(HourSpendOnApp IS NULL) AS HourSpendOnApp_Nulls,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS OrderAmountHike_Nulls,
    SUM(DaySinceLastOrder IS NULL) AS DaySinceLastOrder_Nulls,
    SUM(Tenure IS NULL) AS Tenure_Nulls,
    SUM(CouponUsed IS NULL) AS CouponUsed_Nulls,
    SUM(OrderCount IS NULL) AS OrderCount_Nulls
FROM customer_churn;


-- 2. HANDLE OUTLIERS
-- Delete rows where WarehouseToHome is greater than 100.
DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

-- Expected remaining rows: 5628
SELECT COUNT(*) AS Rows_After_Outlier_Removal
FROM customer_churn;

-- Expected result: 0
SELECT COUNT(*) AS Remaining_Outliers
FROM customer_churn
WHERE WarehouseToHome > 100;


-- ============================================================
-- PART 2: DEALING WITH INCONSISTENCIES
-- ============================================================

-- Replace "Phone" with "Mobile Phone".
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

-- Replace "Mobile" with "Mobile Phone".
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

-- Standardize payment mode values.
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';


-- Verify standardized values.
SELECT DISTINCT PreferredLoginDevice
FROM customer_churn
ORDER BY PreferredLoginDevice;

SELECT DISTINCT PreferedOrderCat
FROM customer_churn
ORDER BY PreferedOrderCat;

SELECT DISTINCT PreferredPaymentMode
FROM customer_churn
ORDER BY PreferredPaymentMode;


-- ============================================================
-- PART 3: DATA TRANSFORMATION
-- ============================================================

-- 1. RENAME COLUMNS
ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;


-- 2. CREATE NEW COLUMNS
ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);

UPDATE customer_churn
SET ComplaintReceived =
    CASE
        WHEN Complain = 1 THEN 'Yes'
        ELSE 'No'
    END;


ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(7);

UPDATE customer_churn
SET ChurnStatus =
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Active'
    END;


-- Verify new columns before dropping Churn and Complain.
SELECT CustomerID, Churn, ChurnStatus, Complain, ComplaintReceived
FROM customer_churn
LIMIT 10;


-- 3. DROP ORIGINAL COLUMNS
ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

-- Check final table structure.
DESCRIBE customer_churn;


-- ============================================================
-- PART 4: DATA EXPLORATION AND ANALYSIS
-- ============================================================

-- 1. Retrieve the count of churned and active customers.
-- Expected: Active=4680, Churned=948
SELECT
    ChurnStatus,
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY ChurnStatus
ORDER BY ChurnStatus;


-- 2. Display the average tenure and total cashback amount
--    of customers who churned.
-- Expected average tenure about 3.18, total cashback 152030
SELECT
    ROUND(AVG(Tenure), 2) AS Average_Tenure,
    SUM(CashbackAmount) AS Total_Cashback_Amount
FROM customer_churn
WHERE ChurnStatus = 'Churned';


-- 3. Determine the percentage of churned customers who complained.
-- Expected about 53.59%
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN ComplaintReceived = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Churned_Customers_Complained_Percentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';


-- 4. Identify the city tier with the highest number of churned customers
--    whose preferred order category is Laptop & Accessory.
-- Expected: CityTier 3, 150 customers
SELECT
    CityTier,
    COUNT(*) AS Churned_Customers
FROM customer_churn
WHERE ChurnStatus = 'Churned'
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY Churned_Customers DESC
LIMIT 1;


-- 5. Identify the most preferred payment mode among active customers.
-- Expected: Debit Card
SELECT
    PreferredPaymentMode,
    COUNT(*) AS Customer_Count
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY Customer_Count DESC
LIMIT 1;


-- 6. Calculate the total order amount hike from last year for customers
--    who are single and prefer mobile phones for ordering.
-- Expected: 12177
SELECT
    SUM(OrderAmountHikeFromlastYear) AS Total_Order_Amount_Hike
FROM customer_churn
WHERE MaritalStatus = 'Single'
  AND PreferredOrderCat = 'Mobile Phone';


-- 7. Find the average number of devices registered among customers
--    who used UPI as their preferred payment mode.
-- Expected about 3.72
SELECT
    ROUND(AVG(NumberOfDeviceRegistered), 2) AS Average_Devices_Registered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';


-- 8. Determine the city tier with the highest number of customers.
-- Expected: CityTier 1, 3666 customers
SELECT
    CityTier,
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY CityTier
ORDER BY Customer_Count DESC
LIMIT 1;


-- 9. Identify the gender that utilized the highest number of coupons.
-- Expected: Male, 5629 coupons
SELECT
    Gender,
    SUM(CouponUsed) AS Total_Coupons_Used
FROM customer_churn
GROUP BY Gender
ORDER BY Total_Coupons_Used DESC
LIMIT 1;


-- 10. List the number of customers and maximum hours spent on the app
--     in each preferred order category.
SELECT
    PreferredOrderCat,
    COUNT(*) AS Number_Of_Customers,
    MAX(HoursSpentOnApp) AS Maximum_Hours_Spent_On_App
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY PreferredOrderCat;


-- 11. Calculate the total order count for customers who prefer using
--     credit cards and have the maximum satisfaction score.
-- Expected maximum satisfaction score: 5
-- Expected total order count: 1122
SELECT
    SUM(OrderCount) AS Total_Order_Count
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (
      SELECT MAX(SatisfactionScore)
      FROM customer_churn
  );


-- 12. Find the average satisfaction score of customers who complained.
-- Expected about 3.00
SELECT
    ROUND(AVG(SatisfactionScore), 2) AS Average_Satisfaction_Score
FROM customer_churn
WHERE ComplaintReceived = 'Yes';


-- 13. List preferred order categories among customers
--     who used more than 5 coupons.
SELECT DISTINCT
    PreferredOrderCat
FROM customer_churn
WHERE CouponUsed > 5
ORDER BY PreferredOrderCat;


-- 14. List the top 3 preferred order categories with the highest
--     average cashback amount.
-- Expected top 3: Others, Grocery, Fashion
SELECT
    PreferredOrderCat,
    ROUND(AVG(CashbackAmount), 2) AS Average_Cashback_Amount
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Average_Cashback_Amount DESC
LIMIT 3;


-- 15. Find preferred payment modes whose rounded average tenure
--     is 10 months and whose customers placed more than 500 orders.
-- Expected: Credit Card, Debit Card, E wallet
SELECT
    PreferredPaymentMode,
    ROUND(AVG(Tenure), 2) AS Average_Tenure,
    SUM(OrderCount) AS Total_Orders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING ROUND(AVG(Tenure), 0) = 10
   AND SUM(OrderCount) > 500
ORDER BY PreferredPaymentMode;


-- 16. Categorize customers based on WarehouseToHome distance
--     and display the churn status breakdown for each category.
SELECT
    Distance_Category,
    ChurnStatus,
    COUNT(*) AS Customer_Count
FROM (
    SELECT
        CASE
            WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
            WHEN WarehouseToHome <= 10 THEN 'Close Distance'
            WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
            ELSE 'Far Distance'
        END AS Distance_Category,
        ChurnStatus
    FROM customer_churn
) AS DistanceData
GROUP BY Distance_Category, ChurnStatus
ORDER BY
    FIELD(
        Distance_Category,
        'Very Close Distance',
        'Close Distance',
        'Moderate Distance',
        'Far Distance'
    ),
    ChurnStatus;


-- 17. List order details for married customers who live in City Tier 1
--     and whose order counts are above the overall average.
SELECT
    CustomerID,
    MaritalStatus,
    CityTier,
    PreferredOrderCat,
    PreferredPaymentMode,
    OrderCount,
    OrderAmountHikeFromlastYear,
    CashbackAmount
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (
      SELECT AVG(OrderCount)
      FROM customer_churn
  )
ORDER BY CustomerID;


-- ============================================================
-- PART 5: CUSTOMER RETURNS
-- ============================================================

-- 18(a). Create customer_returns table and insert the supplied records.
DROP TABLE IF EXISTS customer_returns;

CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID)
        REFERENCES customer_churn(CustomerID)
);

INSERT INTO customer_returns
    (ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
    (1001, 50022, '2023-01-01', 2130),
    (1002, 50316, '2023-01-23', 2000),
    (1003, 51099, '2023-02-14', 2290),
    (1004, 52321, '2023-03-08', 2510),
    (1005, 52928, '2023-03-20', 3000),
    (1006, 53749, '2023-04-17', 1740),
    (1007, 54206, '2023-04-21', 3250),
    (1008, 54838, '2023-04-30', 1990);

SELECT *
FROM customer_returns
ORDER BY ReturnID;


-- 18(b). Display return details with customer details for customers
--        who churned and made complaints.
-- Expected matching ReturnIDs: 1002, 1004, 1006
SELECT
    r.ReturnID,
    r.CustomerID,
    r.ReturnDate,
    r.RefundAmount,
    c.*
FROM customer_returns r
INNER JOIN customer_churn c
    ON r.CustomerID = c.CustomerID
WHERE c.ChurnStatus = 'Churned'
  AND c.ComplaintReceived = 'Yes'
ORDER BY r.ReturnID;


-- Restore Safe Update Mode.
SET SQL_SAFE_UPDATES = 1;
