-- ================================================
-- ACT 4: SELLER ACCOUNTABILITY
-- ================================================
-- Business Question: Which sellers are responsible for the most late deliveries?

-- Approach: Connected orders to sellers through order_items, calculated late
--           delivery rate and average review score per seller using CASE WHEN
--           inside SUM, filtered to sellers with 10+ orders for statistical
--           reliability

-- Key Finding: 11 sellers show late delivery rates above 20%. The Highest late rate
--              reaches 31.58% with 3.34 avg review score.
-- ================================================


-- Poor Order Processing(shipment) Performance of Sellers 
WITH delivery_data AS
  (SELECT DISTINCT o.order_id,
                   oi.seller_id,
                   ore.review_score,
                   datediff (o.order_delivered_customer_date, o.order_estimated_delivery_date) AS days_late
   FROM orders o
   JOIN order_items oi ON o.order_id = oi.order_id
   JOIN order_reviews ore ON oi.order_id = ore.order_id
   WHERE o.order_status = 'delivered'
     AND o.order_purchase_timestamp >= '2017-01-01'
     AND o.order_purchase_timestamp < '2018-09-01')
SELECT seller_id,
       count(*) AS total_orders,
       sum(CASE
               WHEN days_late > 0 THEN 1
               ELSE 0
           END) AS late_orders,
       round((sum(CASE
                      WHEN days_late > 0 THEN 1
                      ELSE 0
                  END)*100)/count(*), 2) AS percentage_of_late,
       round(avg(review_score), 2) AS average_score
FROM delivery_data
GROUP BY seller_id
HAVING count(*)>= 30
ORDER BY percentage_of_late DESC;

