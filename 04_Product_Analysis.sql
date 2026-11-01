-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 04_Product_Analysis.sql
-- PURPOSE: Analyse product and category performance
-- DATABASE: MySQL
-- =====================================================


-- 1. TOTAL NUMBER OF PRODUCTS

SELECT
    COUNT(*) AS total_products
FROM olist_products_dataset;


-- 2. DISTINCT PRODUCTS SOLD

SELECT
    COUNT(DISTINCT product_id) AS distinct_products_sold
FROM olist_order_items_dataset;


-- 3. TOTAL ITEM VALUE BY PRODUCT CATEGORY

SELECT
    COALESCE(
        NULLIF(TRIM(pt.product_category_name_english), ''),
        'Uncategorized'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS total_item_value
FROM olist_order_items_dataset oi
INNER JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt
    ON TRIM(p.product_category_name) =
       TRIM(pt.product_category_name)
GROUP BY product_category
ORDER BY total_item_value DESC;


-- 4. TOP 10 PRODUCT CATEGORIES

SELECT
    COALESCE(
        NULLIF(TRIM(pt.product_category_name_english), ''),
        'Uncategorized'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS total_item_value
FROM olist_order_items_dataset oi
INNER JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt
    ON TRIM(p.product_category_name) =
       TRIM(pt.product_category_name)
GROUP BY product_category
ORDER BY total_item_value DESC
LIMIT 10;


-- 5. PRODUCTS WITH MISSING OR BLANK CATEGORIES

SELECT
    COUNT(*) AS uncategorized_products
FROM olist_products_dataset
WHERE product_category_name IS NULL
   OR TRIM(product_category_name) = '';


-- 6. ORDER ITEMS AND ITEM VALUE FOR UNCATEGORIZED PRODUCTS

SELECT
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT oi.product_id) AS distinct_products,
    ROUND(SUM(oi.price), 2) AS total_item_value
FROM olist_order_items_dataset oi
INNER JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL
   OR TRIM(p.product_category_name) = '';