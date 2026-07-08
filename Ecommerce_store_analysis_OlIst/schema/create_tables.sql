CREATE DATABASE olist;

USE olist;


CREATE TABLE customers (customer_id VARCHAR(50) PRIMARY KEY,
                                                customer_unique_id VARCHAR(50),
                                                                   customer_zip_code_prefix VARCHAR(10),
                                                                                            customer_state VARCHAR(25),
                                                                                                           customer_city VARCHAR(25));


CREATE TABLE orders (order_id VARCHAR(50) PRIMARY KEY,
                                          customer_id VARCHAR(50),
                                                      order_status VARCHAR(25),
                                                                   order_purchase_timestamp DATETIME,
                                                                   order_approved_at DATETIME,
                                                                   order_delivered_carrier_date DATETIME,
                                                                   order_delivered_customer_date DATETIME,
                                                                   order_estimated_delivery_date DATETIME,
                     FOREIGN KEY (customer_id) REFERENCES customers (customer_id));


CREATE TABLE order_items (order_id VARCHAR(50),
                                   order_item_id INT, product_id VARCHAR(50),
                                                                 seller_id VARCHAR(50),
                                                                           shipping_limit_date DATETIME,
                                                                           price DECIMAL(10, 2),
                                                                                 freight_value DECIMAL(10, 2),
                          FOREIGN KEY (order_id) REFERENCES orders (order_id));


SELECT *
FROM customers;


SELECT *
FROM orders;


SELECT *
FROM order_items;


SELECT o.order_id,
       c.customer_unique_id,
       c.customer_city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 5;


CREATE TABLE products (product_id VARCHAR(50),
                                  product_category_name VARCHAR(100),
                                                        product_name_lenght INT, product_description_lenght INT, product_photos_qty INT, product_weight_g DECIMAL(10, 2),
                                                                                                                                                          product_length_cm DECIMAL(10, 2),
                                                                                                                                                                            product_height_cm DECIMAL(10, 2),
                                                                                                                                                                                              product_width_cm DECIMAL(10, 2));


ALTER TABLE products ADD PRIMARY KEY(product_id);


CREATE TABLE sellers(seller_id varchar(50) PRIMARY KEY,
                                           seller_zip_code_prefix varchar(10),
                                                                  seller_city varchar(25),
                                                                              seller_state varchar(25));


CREATE TABLE order_payments(order_id varchar(50),
                                     payment_sequential int, payment_type varchar(25),
                                                                          payment_installments int, payment_value decimal(10, 2),
                            FOREIGN KEY (order_id) REFERENCES orders(order_id));


CREATE TABLE order_reviews (review_id VARCHAR(50) PRIMARY KEY,
                                                  order_id VARCHAR(50),
                                                           review_score INT, review_comment_title VARCHAR(100),
                                                                                                  review_comment_message TEXT, review_creation_date DATETIME,
                                                                                                                               review_answer_timestamp DATETIME,
                            FOREIGN KEY (order_id) REFERENCES orders(order_id));


CREATE TABLE product_category_name_translation (product_category_name VARCHAR(100) PRIMARY KEY,
                                                                                   product_category_name_english VARCHAR(100));


ALTER TABLE order_items ADD
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
                                   ADD
FOREIGN KEY (product_id) REFERENCES products(product_id);


SELECT *
FROM order_reviews;


SELECT *
FROM order_payments;


SELECT *
FROM sellers;


SELECT *
FROM product_category_name_translation;

-- Rows Count Check

SELECT 'customers' AS TABLE_NAME,
       COUNT(*) AS ROW_COUNT
FROM customers
UNION ALL
SELECT 'orders',
       COUNT(*)
FROM orders
UNION ALL
SELECT 'order_items',
       COUNT(*)
FROM order_items
UNION ALL
SELECT 'products',
       COUNT(*)
FROM products
UNION ALL
SELECT 'sellers',
       COUNT(*)
FROM sellers
UNION ALL
SELECT 'order_payments',
       COUNT(*)
FROM order_payments
UNION ALL
SELECT 'order_reviews',
       COUNT(*)
FROM order_reviews
UNION ALL
SELECT 'product_category_name_translation',
       COUNT(*)
FROM product_category_name_translation;

;