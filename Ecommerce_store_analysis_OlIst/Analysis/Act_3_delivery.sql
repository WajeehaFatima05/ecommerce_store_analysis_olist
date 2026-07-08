-- ================================================
-- ACT 3: DELIVERY PERFORMANCE ROOT CAUSE
-- ================================================
-- Business Question: Does poor delivery experience drive low review scores?

-- Approach: Calculated delivery delay using DATEDIFF between actual and
--           estimated delivery dates, segmented orders by delivery status,
--           compared average review scores across segments

-- Key Finding: Late deliveries score 2.27 vs 4.30 for early deliveries —
--              a 47% drop in satisfaction. 87,708 orders arrived early vs
--              6,358 arriving late
-- ================================================


-- Delivery Delay by Days
-- Negative sign means delivered early

SELECT o.order_id,
       ore.review_score,
       o.order_delivered_customer_date,
       o.order_estimated_delivery_date,
       datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date) no_of_days
FROM orders o
JOIN order_reviews ore ON o.order_id = ore.order_id
WHERE o.order_status = "delivered"
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
  AND o.order_status NOT IN ('cancelled',
                             'unavailable');
                             
                             
-- Delivery Performance effect on Review Score
WITH delivery_table AS
  (SELECT o.order_id,
          ore.review_score,
          o.order_delivered_customer_date,
          o.order_estimated_delivery_date,
          datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date) no_of_days
   FROM orders o
   JOIN order_reviews ore ON o.order_id = ore.order_id
   WHERE o.order_status = "delivered"
     AND o.order_purchase_timestamp >= '2017-01-01'
     AND o.order_purchase_timestamp < '2018-09-01'
     AND o.order_status NOT IN ('cancelled',
                                'unavailable'))
SELECT CASE
           WHEN no_of_days = 0 THEN "delivered on time"
           WHEN no_of_days> 0 THEN "delivered late"
           WHEN no_of_days < 0 THEN "delivered earlier"
       END AS delivery_segment,
       avg(review_score) avg_score_per_delivery_performance,
       count(*) no_of_orders
FROM delivery_table
GROUP BY delivery_segment
ORDER BY avg_score_per_delivery_performance;