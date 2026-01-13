USE olist;


/*
Project: Olist E-Commerce Analytics
Author: Vignesh
Database: MySQL
Dataset: Brazilian E-Commerce Public Dataset (Olist)

Objective:
To analyze customer behavior, orders, revenue, and delivery performance
using SQL queries written in a clear, business-friendly manner.
*/

-----------------------------------------------------------------------------------------------------------------------------------
-- DATA UNDERSTANDING

-- Total number of orders placed on the platform
SELECT 
    COUNT(*) AS total_orders
FROM olist_orders_dataset
;


-- Total unique customers (avoids counting repeat purchases)
SELECT 
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset
;

-----------------------------------------------------------------------------------------------------------------------------------
-- ORDER STATUS ANALYSIS

-- Distribution of orders by status

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC
;

-----------------------------------------------------------------------------------------------------------------------------------
-- REVENUE ANALYSIS

-- Total revenue from delivered orders only

SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
;


-- Average Order Value (AOV)
SELECT 
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
;

-----------------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMER EXPERIENCE

-- Overall average customer review score

SELECT 
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM olist_order_reviews_dataset
WHERE review_score IS NOT NULL
;


-- Relationship between delivery delay and review score

SELECT
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On Time'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_rating
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status
;

-----------------------------------------------------------------------------------------------------------------------------

-- PRODUCT INSIGHTS

-- Top 10 product categories by total revenue

SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10
;



