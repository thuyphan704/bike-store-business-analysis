use bike_stores_2016;

#Sản phẩm bán nhiều/ít
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY total_units_sold DESC;

#Revenue theo product
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY revenue DESC;

#Thành phố mua sản phẩm nào nhiều nhất
SELECT
    c.city,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY
    c.city,
    p.product_name
ORDER BY c.city, units_sold DESC;