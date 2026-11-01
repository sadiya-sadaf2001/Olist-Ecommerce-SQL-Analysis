-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 06_Delivery_Analysis.sql
-- PURPOSE: Analyse delivery performance
-- DATABASE: MySQL
-- =====================================================


-- 1. VALID DELIVERED ORDERS AND LATE ORDERS

SELECT
    COUNT(*) AS valid_delivered_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_delivered_customer_date >
                     order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM olist_orders_dataset

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_estimated_delivery_date IS NOT NULL
  AND CAST(order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%';


-- 2. AVERAGE PURCHASE-TO-DELIVERY TIME

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_delivered_customer_date
            )
        ) / 24,
        2
    ) AS average_delivery_days

FROM olist_orders_dataset

WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      AND CAST(order_purchase_timestamp AS CHAR)
    NOT LIKE '0000-00-00%';


-- 3. AVERAGE ORDER PROCESSING TIME

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_approved_at,
                order_delivered_carrier_date
            )
        ) / 24,
        2
    ) AS average_processing_days

FROM olist_orders_dataset

WHERE order_status = 'delivered'
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL AND CAST(order_approved_at AS CHAR)
AND CAST(order_delivered_carrier_date AS CHAR)
    NOT LIKE '0000-00-00%';


-- 4. AVERAGE TRANSIT TIME

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_delivered_carrier_date,
                order_delivered_customer_date
            )
        ) / 24,
        2
    ) AS average_transit_days

FROM olist_orders_dataset

WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR) 
      AND CAST(order_delivered_carrier_date AS CHAR)
    NOT LIKE '0000-00-00%';


-- 5. LATE DELIVERY ANALYSIS BY CUSTOMER STATE

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,

    COUNT(DISTINCT CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN o.order_id
    END) AS late_orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN o.order_id
        END) * 100.0 /
        COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_percentage

FROM olist_orders_dataset o

INNER JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND CAST(o.order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND o.order_estimated_delivery_date IS NOT NULL
  AND CAST(o.order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%'

GROUP BY c.customer_state

HAVING COUNT(DISTINCT o.order_id) >= 100

ORDER BY late_delivery_percentage DESC;


-- 6. REVIEW SCORES BY DELIVERY PERFORMANCE

SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time or Early'
    END AS delivery_group,

    COUNT(*) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM olist_orders_dataset o

INNER JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND CAST(o.order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND o.order_estimated_delivery_date IS NOT NULL
  AND CAST(o.order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%'

GROUP BY delivery_group

ORDER BY average_review_score DESC;
