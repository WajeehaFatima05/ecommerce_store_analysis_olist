-- ================================================
-- ACT 2: CUSTOMER RETENTION ANALYSIS
-- ================================================
-- Business Question: Are customers returning for repeat purchases?
-- Approach: Joined orders and customers, grouped by customer_unique_id to
--           identify real repeat buyers across multiple orders

-- Key Finding: 96.94% of customers are one-time buyers. Only 0.11% qualify
--              as loyal customers (5+ orders) — a severe retention problem
-- ================================================


-- Count of orders per customer TABLE 

SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS no_of_orders
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_status NOT IN ('canceled' , 'unavailabale')
        AND o.order_purchase_timestamp >= '2017-01-01'
        AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY c.customer_unique_id
ORDER BY no_of_orders DESC;


-- Segmentation of Customers and their %
WITH customer_order AS
  (SELECT c.customer_unique_id,
          count(DISTINCT o.order_id) AS no_of_orders
   FROM customers c
   JOIN orders o ON c.customer_id = o.customer_id
   WHERE o.order_status NOT IN ('canceled',
                                'unavailabale')
     AND o.order_purchase_timestamp >= '2017-01-01'
     AND o.order_purchase_timestamp < '2018-09-01'
   GROUP BY c.customer_unique_id)
SELECT CASE
           WHEN no_of_orders =1 THEN "one time buyers"
           WHEN no_of_orders = 2 THEN "TWICE"
           WHEN no_of_orders BETWEEN 3 AND 5 THEN "3-5 time buyers"
           WHEN no_of_orders > 5 THEN "loyal customers"
       END AS customer_segment,
       count(*) AS customer_count,
       round(count(*) * 100 / sum(count(*)) over(), 2) AS percentage
FROM customer_order
GROUP BY customer_segment
ORDER BY customer_count DESC;