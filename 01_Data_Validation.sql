-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 01_Data_Validation.sql
-- PURPOSE: Check data quality and table consistency
-- DATABASE: MySQL
-- =====================================================


-- 1. CHECK TOTAL ROW COUNTS

SELECT 'Orders' AS table_name, COUNT(*) AS total_rows
FROM olist_orders_dataset

UNION ALL

SELECT 'Order Items', COUNT(*)
FROM olist_order_items_dataset

UNION ALL

SELECT 'Customers', COUNT(*)
FROM olist_customers_dataset

UNION ALL

SELECT 'Products', COUNT(*)
FROM olist_products_dataset

UNION ALL

SELECT 'Payments', COUNT(*)
FROM olist_order_payments_dataset

UNION ALL

SELECT 'Reviews', COUNT(*)
FROM olist_order_reviews_dataset

UNION ALL

SELECT 'Sellers', COUNT(*)
FROM olist_sellers_dataset

UNION ALL

SELECT 'Geolocation', COUNT(*)
FROM olist_geolocation_dataset

UNION ALL

SELECT 'Category Translation', COUNT(*)
FROM product_category_name_translation;


-- 2. CHECK DUPLICATE ORDER IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM olist_orders_dataset;


-- 3. CHECK DUPLICATE CUSTOMER IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM olist_customers_dataset;


-- 4. CHECK DUPLICATE PRODUCT IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM olist_products_dataset;


-- 5. CHECK DUPLICATE SELLER IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM olist_sellers_dataset;


-- 6. CHECK DUPLICATE ORDER ITEM COMBINATIONS

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id))
        AS unique_order_item_combinations
FROM olist_order_items_dataset;


-- 7. CHECK MISSING VALUES IN IMPORTANT ORDER COLUMNS

SELECT
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(customer_id IS NULL) AS missing_customer_ids
FROM olist_orders_dataset;


-- 8. CHECK MISSING VALUES IN IMPORTANT ORDER ITEM COLUMNS

SELECT
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(product_id IS NULL) AS missing_product_ids,
    SUM(seller_id IS NULL) AS missing_seller_ids,
    SUM(price IS NULL) AS missing_prices,
    SUM(freight_value IS NULL) AS missing_freight_values
FROM olist_order_items_dataset;


-- 9. CHECK UNMATCHED CUSTOMERS

SELECT COUNT(*) AS unmatched_customers
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 10. CHECK UNMATCHED ORDER ITEMS

SELECT COUNT(*) AS unmatched_order_items
FROM olist_order_items_dataset oi
LEFT JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 11. CHECK INVALID ZERO DELIVERY DATES

SELECT COUNT(*) AS invalid_delivery_dates
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND CAST(order_delivered_customer_date AS CHAR)
    LIKE '0000-00-00%';


-- 12. CHECK BLANK PRODUCT CATEGORIES

SELECT COUNT(*) AS uncategorized_products
FROM olist_products_dataset
WHERE product_category_name IS NULL
   OR TRIM(product_category_name) = '';
