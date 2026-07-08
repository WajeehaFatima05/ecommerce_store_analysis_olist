-- ================================================
-- ACT 1: REVENUE HEALTH CHECK
-- ================================================
-- Business Question: Is revenue growing and which product categories drive it?

-- Approach: Joined orders and order_payments to calculate monthly revenue trends
--           and category-wise revenue using a 5-table join through order_items,
--           products, and product_category_name_translation

-- Key Finding: Explosive growth in early 2017 (108% MoM), November 2017 Black
--              Friday spike at 53%, growth flattening by 2018. Bed_bath_table
--              leads revenue by volume, computers/watches lead by order value
-- ================================================



SELECT o.order_purchase_timestamp,
       op.payment_value
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
LIMIT 10;


SELECT year(o.order_purchase_timestamp),
       month(o.order_purchase_timestamp),
       op.payment_value
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
LIMIT 10;

-- Monthly Revenue health check table

SELECT YEAR(o.order_purchase_timestamp) AS YEAR,
       MONTH(o.order_purchase_timestamp) AS MONTH,
       ROUND(SUM(op.payment_value), 2) AS REVENUE
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status NOT IN ('cancelled',
                             'unavailable')
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY YEAR,
         MONTH
ORDER BY YEAR,
         MONTH ;

-- Checking suspicious 2018 september and octobr drop in revenue ( data truncation happened) and we dont need these 2 months

SELECT YEAR(o.order_purchase_timestamp) AS YEAR,
       MONTH(o.order_purchase_timestamp) AS MONTH,
       COUNT(*)
FROM orders o
WHERE order_status NOT IN ('cancelled',
                           'unavailable')
GROUP BY YEAR,
         MONTH
ORDER BY YEAR,
         MONTH;


SELECT *
FROM products
LIMIT 10;

-- Most Revenue Generating Product Category quantifying their frequency of orders and average revenue per category

SELECT t.product_category_name_english,
       ROUND(SUM(op.payment_value), 2) AS total_revenue,
       count(DISTINCT o.order_id) "no. of orders per category",
       ROUND(SUM(op.payment_value)/ count(DISTINCT o.order_id), 2) average_revenue_per_category
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
JOIN order_items oi ON oi.order_id = op.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
WHERE o.order_status NOT IN ('cancelled',
                             'unavailable')
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC;



-- Monthly % growth of revenue
WITH monthly_revenue AS
  (SELECT YEAR(o.order_purchase_timestamp) AS YEAR,
          MONTH(o.order_purchase_timestamp) AS MONTH,
          ROUND(SUM(op.payment_value), 2) AS total_revenue
   FROM orders o
   JOIN order_payments op ON o.order_id = op.order_id
   WHERE o.order_status NOT IN ('cancelled',
                                'unavailable')
     AND o.order_purchase_timestamp >= '2017-01-01'
     AND o.order_purchase_timestamp < '2018-09-01'
   GROUP BY YEAR,
            MONTH)
SELECT YEAR,
       MONTH,
       total_revenue,
       lag(total_revenue) over(
                               ORDER BY YEAR, MONTH) AS prev_month_revenue,
       round(((total_revenue - lag(total_revenue) over(
                                                       ORDER BY YEAR, MONTH)) / (lag(total_revenue) over(
                                                                                                         ORDER BY YEAR, MONTH)))*100, 2) AS "% growth of revenue"
FROM monthly_revenue
ORDER BY YEAR,
         MONTH;