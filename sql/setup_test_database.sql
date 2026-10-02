create database bike_stores_2016;
use bike_stores_2016;
SHOW TABLES; 
# test database
SELECT COUNT(*) AS total_rows FROM brands;
SELECT COUNT(*) AS total_rows FROM categories;
SELECT COUNT(*) AS total_rows FROM customers;
SELECT COUNT(*) AS total_rows FROM order_items;
SELECT COUNT(*) AS total_rows FROM orders;
SELECT COUNT(*) AS total_rows FROM staffs;
SELECT COUNT(*) AS total_rows FROM products;
SELECT COUNT(*) AS total_rows FROM stocks;
SELECT COUNT(*) AS total_rows FROM stores;

#test table
SELECT * FROM orders LIMIT 100;

#Setup relationships
-- kiểm tra null 
SELECT COUNT(*) AS null_count FROM brands WHERE brand_id IS NULL;
SELECT COUNT(*) AS null_count FROM categories WHERE category_id IS NULL;
SELECT COUNT(*) AS null_count FROM customers WHERE customer_id IS NULL;
SELECT COUNT(*) AS null_count FROM orders WHERE order_id IS NULL;
SELECT COUNT(*) AS null_count FROM order_items WHERE item_id IS NULL;
SELECT COUNT(*) AS null_count FROM products WHERE product_id IS NULL;
SELECT COUNT(*) AS null_count FROM staffs WHERE staff_id IS NULL;
SELECT COUNT(*) AS null_count FROM stores WHERE store_id IS NULL;

-- test trùng lặp
SELECT brand_id, COUNT(*) AS duplicate_count FROM brands
GROUP BY brand_id HAVING COUNT(*) > 1;

SELECT category_id, COUNT(*) AS duplicate_count FROM categories
GROUP BY category_id HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) AS duplicate_count FROM customers
GROUP BY customer_id HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS duplicate_count FROM orders
GROUP BY order_id HAVING COUNT(*) > 1;

SELECT item_id, COUNT(*) AS duplicate_count FROM order_items
GROUP BY item_id HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS duplicate_count FROM products
GROUP BY product_id HAVING COUNT(*) > 1;

SELECT staff_id, COUNT(*) AS duplicate_count FROM staffs
GROUP BY staff_id HAVING COUNT(*) > 1;

SELECT store_id, COUNT(*) AS duplicate_count FROM stores
GROUP BY store_id HAVING COUNT(*) > 1;


