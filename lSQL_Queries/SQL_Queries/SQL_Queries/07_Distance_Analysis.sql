-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 07_Distance_Analysis.sql
-- PURPOSE: Estimate seller-to-customer distance
-- DATABASE: MySQL
-- =====================================================

-- 1. CREATE REPRESENTATIVE GEOLOCATION COORDINATES

DROP TEMPORARY TABLE IF EXISTS temp_geolocation;

CREATE TEMPORARY TABLE temp_geolocation AS
SELECT
    geolocation_zip_code_prefix AS zip_prefix,
    AVG(geolocation_lat) AS latitude,
    AVG(geolocation_lng) AS longitude
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix;


-- 2. MATCH SELLERS WITH GEOLOCATION

DROP TEMPORARY TABLE IF EXISTS temp_seller_locations;

CREATE TEMPORARY TABLE temp_seller_locations AS
SELECT
    s.seller_id,
    g.latitude,
    g.longitude
FROM olist_sellers_dataset s
INNER JOIN temp_geolocation g
    ON s.seller_zip_code_prefix = g.zip_prefix;


-- 3. MATCH CUSTOMERS WITH GEOLOCATION

DROP TEMPORARY TABLE IF EXISTS temp_customer_locations;

CREATE TEMPORARY TABLE temp_customer_locations AS
SELECT
    c.customer_id,
    g.latitude,
    g.longitude
FROM olist_customers_dataset c
INNER JOIN temp_geolocation g
    ON c.customer_zip_code_prefix = g.zip_prefix;


-- 4. CREATE DISTINCT SELLER-ORDER COMBINATIONS

DROP TEMPORARY TABLE IF EXISTS temp_seller_orders;

CREATE TEMPORARY TABLE temp_seller_orders AS
SELECT DISTINCT
    oi.order_id,
    oi.seller_id,
    o.customer_id,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM olist_order_items_dataset oi
INNER JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND CAST(o.order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND o.order_estimated_delivery_date IS NOT NULL
  AND CAST(o.order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%';


-- 5. MATCH SELLER AND CUSTOMER COORDINATES

DROP TEMPORARY TABLE IF EXISTS temp_delivery_locations;

CREATE TEMPORARY TABLE temp_delivery_locations AS
SELECT
    so.order_id,
    so.seller_id,
    so.customer_id,
    so.order_delivered_customer_date,
    so.order_estimated_delivery_date,
    sl.latitude AS seller_latitude,
    sl.longitude AS seller_longitude,
    cl.latitude AS customer_latitude,
    cl.longitude AS customer_longitude
FROM temp_seller_orders so
INNER JOIN temp_seller_locations sl
    ON so.seller_id = sl.seller_id
INNER JOIN temp_customer_locations cl
    ON so.customer_id = cl.customer_id;


-- 6. CALCULATE APPROXIMATE DISTANCE USING HAVERSINE

DROP TEMPORARY TABLE IF EXISTS temp_delivery_distance;

CREATE TEMPORARY TABLE temp_delivery_distance AS
SELECT
    order_id,
    seller_id,
    customer_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    6371 * 2 * ASIN(
        SQRT(
            POWER(
                SIN(
                    RADIANS(
                        customer_latitude - seller_latitude
                    ) / 2
                ),
                2
            )
            + COS(RADIANS(seller_latitude))
            * COS(RADIANS(customer_latitude))
            * POWER(
                SIN(
                    RADIANS(
                        customer_longitude - seller_longitude
                    ) / 2
                ),
                2
            )
        )
    ) AS distance_km

FROM temp_delivery_locations;


-- 7. ANALYSE LATE DELIVERY BY DISTANCE GROUP

SELECT
    CASE
        WHEN distance_km < 100 THEN 'Under 100 km'
        WHEN distance_km < 500 THEN '100-499 km'
        WHEN distance_km < 1000 THEN '500-999 km'
        WHEN distance_km < 2000 THEN '1000-1999 km'
        ELSE '2000 km and above'
    END AS distance_group,

    COUNT(*) AS seller_order_records,

    COUNT(DISTINCT CASE
        WHEN order_delivered_customer_date >
             order_estimated_delivery_date
        THEN order_id
    END) AS late_orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN order_id
        END) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage,

    ROUND(AVG(distance_km), 2) AS average_distance_km

FROM temp_delivery_distance

GROUP BY distance_group

ORDER BY MIN(distance_km);
