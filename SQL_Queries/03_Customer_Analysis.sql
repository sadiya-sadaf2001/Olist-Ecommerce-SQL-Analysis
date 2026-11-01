-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 03_Customer_Analysis.sql
-- PURPOSE: Analyse customer behaviour and retention
-- DATABASE: MySQL
-- =====================================================


-- 1. TOTAL UNIQUE CUSTOMERS

SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM olist_customers_dataset;


-- 2. TOP 10 CUSTOMER CITIES BY ORDER COUNT

SELECT
    c.customer_city,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_customers_dataset c
INNER JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;


-- 3. CUSTOMER DISTRIBUTION BY STATE

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY unique_customers DESC;


-- 4. IDENTIFY CUSTOMERS WITH MORE THAN ONE ORDER

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- 5. COUNT REPEAT CUSTOMERS

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM olist_orders_dataset o
    INNER JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS repeat_buyers;


-- 6. CALCULATE REPEAT CUSTOMER RATE

SELECT
    COUNT(*) AS total_unique_customers,
    SUM(CASE
        WHEN order_count > 1 THEN 1
        ELSE 0
    END) AS repeat_customers,
    ROUND(
        SUM(CASE
            WHEN order_count > 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM olist_customers_dataset c
    INNER JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders;
