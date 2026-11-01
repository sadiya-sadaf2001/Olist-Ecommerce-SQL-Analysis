-- =====================================================
-- OLIST E-COMMERCE SQL PROJECT
-- FILE: 05_Payment_Analysis.sql
-- PURPOSE: Analyse payment methods and values
-- DATABASE: MySQL
-- =====================================================


-- 1. TOTAL PAYMENT RECORDS

SELECT
    COUNT(*) AS total_payment_records
FROM olist_order_payments_dataset;


-- 2. PAYMENT METHOD DISTRIBUTION

SELECT
    payment_type,
    COUNT(*) AS total_payment_records
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment_records DESC;


-- 3. TOTAL PAYMENT VALUE BY METHOD

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 4. AVERAGE PAYMENT VALUE BY METHOD

SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY average_payment_value DESC;


-- 5. PAYMENT RECORD COUNT AND VALUE BY METHOD

SELECT
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 6. PAYMENT INSTALLMENT ANALYSIS

SELECT
    payment_installments,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_installments
ORDER BY payment_installments;