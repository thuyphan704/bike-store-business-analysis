use bike_stores_2016;
-- ============================================================
-- BIKE STORE BUSINESS INSIGHTS - SQL QUERIES (MYSQL VERSION)
-- ============================================================
-- SECTION A: SALES TREND ANALYSIS
-- ============================================================

-- A1: Sales Trend by Product (Monthly)
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    ROUND(AVG(oi.list_price * (1 - oi.discount)), 2) AS avg_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC, total_revenue DESC;


-- A2: Sales Trend by Store (Monthly)
SELECT 
    s.store_id,
    s.store_name,
    DATE_TRUNC(o.order_date, MONTH) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id), 
        2
    ) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY 
    s.store_id,
    s.store_name,
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY YEAR(o.order_date) DESC, MONTH(o.order_date) DESC, total_revenue DESC;


-- A3: Yearly Sales Comparison
SELECT 
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY 
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY year ASC, month ASC;


-- A4: Top 10 Best Selling Products (All Time)
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS orders_count,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / SUM(oi.quantity),
        2
    ) AS avg_unit_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- A5: Bottom 10 Worst Selling Products (All Time)
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS orders_count
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY total_revenue ASC
LIMIT 10;





