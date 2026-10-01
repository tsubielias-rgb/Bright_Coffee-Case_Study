-- Databricks notebook source
SELECT * 
from bright_coffee.bright_shop.bright_coffee_dataset;

----------------checking product types--------------
SELECT DISTINCT product_category
from bright_coffee.bright_shop.bright_coffee_dataset;
-- --------------------------------------------------------------------------------------

SELECT *
from bright_coffee.bright_shop.bright_coffee_dataset
LIMIT 100;

DESCRIBE  bright_coffee.bright_shop.bright_coffee_dataset;

--Checking the product Cat--
SELECT DISTINCT product_category
from bright_coffee.bright_shop.bright_coffee_dataset
LIMIT 100;

-- Cleaning Product Cat--
SELECT DISTINCT 
      product_category,
      CASE 
          WHEN product_category IS NULL THEN 'unknown'
          WHEN product_category =' ' THEN 'unknown'
          ELSE product_category
      END AS Product_cat
from bright_coffee.bright_shop.bright_coffee_dataset;

-- Inspecting Produc Type--
SELECT DISTINCT product_type
from bright_coffee.bright_shop.bright_coffee_dataset;

--Cleaning Product Type--
SELECT DISTINCT 
      product_type,
      CASE 
          WHEN product_type IS NULL THEN 'unknown'
          WHEN product_type =' ' THEN 'unknown'
          ELSE product_type
      END AS Product_typ
from bright_coffee.bright_shop.bright_coffee_dataset;

--Creating TOTAL_AMOUNT coloumn
 SELECT transaction_qty,
       ROUND(
           SUM(
               CAST(transaction_qty AS DOUBLE) *
               CAST(unit_price AS DOUBLE)
           ), 0
       ) AS TOTAL_AMOUNT
FROM bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_qty;
------------------------------------------------------------------------

SELECT COUNT(DISTINCT product_category),transaction_qty,
        product_type, unit_price
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_qty, unit_price,product_type,
        product_category;

-- -----------------------------------------------------------------------------------------------
-- DATA CLEANING
--Checking duplicates
SELECT transaction_id,
        COUNT(*) AS Duplicate_cnt
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_id
HAVING COUNT(*)
ORDER BY Duplicate_cnt DESC; 

SELECT transaction_id,
        COUNT(*) AS Duplicate_cnt
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_id
HAVING COUNT(*)>1;

--CHECKING DUPLICATES FOR ALL COLUMNS
SELECT *,
        COUNT(*) AS Duplicate_cnt
FROM bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY ALL
HAVING COUNT(*)>1;

--CHECKING THE DATE COLUMN

SELECT DISTINCT transaction_date
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT DATE_FORMAT(to_date(transaction_date, 'M/d/yyyy'), 'MMMM') AS Month_name
FROM bright_coffee.bright_shop.bright_coffee_dataset;

--CHECKING TRANCTION TIME COLUMN
SELECT DISTINCT transaction_time
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT DATE_FORMAT(transaction_time, 'HH:MM:SS') AS Time
from bright_coffee.bright_shop.bright_coffee_dataset;

--Creating time buckets
SELECT DISTINCT 
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 7 AND 11 THEN 'Morning'
        ELSE 'Other'
    END AS time_bucket
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT 
    COUNT(DISTINCT product_category) AS unique_categories,
    transaction_qty,
    product_type, 
    unit_price,
    DATE_FORMAT(to_date(transaction_date, 'M/d/yyyy'), 'MMMM') AS Month_name
FROM bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_qty, 
    unit_price,
    product_type,
    DATE_FORMAT(to_date(transaction_date, 'M/d/yyyy'), 'MMMM');

-----------------------------------------------------------------------
SELECT
product_category,
product_type,
product_detail,
unit_price,
SUM(transaction_qty) AS total_transaction_qty,
ROUND(SUM(transaction_qty * CAST(unit_price AS DOUBLE)), 2) AS total_price
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY
product_category,
product_type,
product_detail,
unit_price
ORDER BY total_price DESC;
-----------------------------------------------------------------------------------------
SELECT DISTINCT product_type
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT 
     product_category,
     CASE 
         WHEN product_category IS NULL THEN 'Unknown' 
         WHEN TRIM(product_category) = '' THEN 'Unknown'
         ELSE product_category
    END AS product_cat
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT
       product_type,
     CASE 
         WHEN product_type IS NULL THEN 'Unknown' 
         WHEN TRIM(product_type) = '' THEN 'Unknown'
         ELSE product_type
    END AS product_typ
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT transaction_qty,
       unit_price,
       (CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_Amount
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT transaction_qty,
       unit_price,
       ROUND(SUM(CAST(unit_price AS DOUBLE) * transaction_qty), 2) AS Total_Amount
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_qty, unit_price;

SELECT transaction_qty, ROUND(SUM(CAST(transaction_qty AS DOUBLE)* CAST(unit_price AS DOUBLE)),0) AS Total_Amount
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_qty;

SELECT transaction_id,
       COUNT(*) AS Duplicate_cnt
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY Duplicate_cnt DESC;

SELECT transaction_id,
       COUNT(*) AS Duplicate_cnt
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT *,
       COUNT(*) OVER (PARTITION BY transaction_id, transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail) AS Duplicate_cnt
from bright_coffee.bright_shop.bright_coffee_dataset
QUALIFY Duplicate_cnt > 1;

SELECT DISTINCT transaction_date
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT DATE_FORMAT(to_date(transaction_date, 'M/d/yyyy'),'MMMM') AS month_name
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT transaction_time
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT DISTINCT date_format(transaction_time,'HH:mm:ss') AS TIME
from bright_coffee.bright_shop.bright_coffee_dataset;

SELECT
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
    WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
    WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
    ELSE 'Night'
  END AS Time_bucket
from bright_coffee.bright_shop.bright_coffee_dataset;

-- ANALYSING REVENUE BY TIME BUCKET
 SELECT
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
    WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
    WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
    ELSE 'Night'
  END AS Time_bucket,
  SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY Time_bucket
ORDER BY Total_revenue DESC;

--checking total revenue per store location
SELECT store_location, SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY store_location
ORDER BY Total_revenue DESC;

--checking high performing and low performing products
SELECT
       MAX (transaction_qty * CAST(unit_price AS DOUBLE)) AS Highest_product,
       MIN (transaction_qty * CAST(unit_price AS DOUBLE)) AS Lowest_product
from bright_coffee.bright_shop.bright_coffee_dataset;
--------------------------------------------------------------------------

--checking total revenue per store location
SELECT store_location, SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY store_location
ORDER BY Total_revenue DESC;

--checking high performing and low performing products
SELECT product_category, SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY product_category
ORDER BY Total_revenue DESC;


-------------------------------------------------------------------------------
SELECT MIN(transaction_date) AS Earliest_date, MAX(transaction_date) AS Latest_date
from bright_coffee.bright_shop.bright_coffee_dataset;

-------------------------------------------------------------------------------------
--Total units sold by product type---
SELECT product_type, SUM(transaction_qty) AS Total_units_sold
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY product_type
ORDER BY Total_units_sold DESC;
----------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
--Total revenue by product type----
SELECT product_type, SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY product_type
ORDER BY Total_revenue DESC;
----------------------------------------------------------------------------------------
--GROUPING product type and time bucket----
SELECT
       CASE 
    WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
    WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
    WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
    ELSE 'Night'
  END AS Time_bucket,
  product_type,
  SUM(transaction_qty) AS Total_units_sold,
  SUM(CAST(unit_price AS DOUBLE) * transaction_qty) AS Total_revenue
from bright_coffee.bright_shop.bright_coffee_dataset
GROUP BY Time_bucket, product_type
ORDER BY Time_bucket, Total_units_sold DESC;
------------------------------------------------------------------------------------------------------------------------------

---Checking the days---
SELECT
    CASE 
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 6 THEN 'Friday'
    WHEN DAYOFWEEK(to_date(transaction_date, 'M/d/yyyy')) = 7 THEN 'Saturday'
    END AS Day_type
from bright_coffee.bright_shop.bright_coffee_dataset;