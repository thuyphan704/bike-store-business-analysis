use bike_stores_2016;
-- ============================================================
-- SECTION E: BONUS QUERIES - ADDITIONAL INSIGHTS
-- ============================================================

-- E1: Revenue by Category Over Time
SELECT 
    c.category_id,
    c.category_name,
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY 
    c.category_id,
    c.category_name,
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY year, month, revenue DESC;


-- E2: Discount Impact Analysis
SELECT 
    p.product_id,
    p.product_name,
    ROUND(AVG(oi.discount), 4) AS avg_discount_rate,
    COUNT(DISTINCT o.order_id) AS orders_with_discount,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / SUM(oi.quantity),
        2
    ) AS effective_price,
    ROUND(
        SUM(oi.quantity * oi.list_price) - 
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
        2
    ) AS total_discount_given
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 4
GROUP BY 
    p.product_id,
    p.product_name
ORDER BY total_discount_given DESC;


-- E3: Top Brands Performance
SELECT 
    b.brand_id,
    b.brand_name,
    COUNT(DISTINCT p.product_id) AS products_offered,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
WHERE o.order_status = 4
GROUP BY 
    b.brand_id,
    b.brand_name
ORDER BY revenue DESC;


-- E4: Store Comparison Matrix (All Performance Metrics)
SELECT 
    s.store_id,
    s.store_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity), 0) AS total_units,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN o.shipped_date <= o.required_date THEN o.order_id END) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS on_time_delivery_rate,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(COUNT(DISTINCT o.order_id) / NULLIF(COUNT(DISTINCT o.customer_id), 0), 2) AS avg_orders_per_customer
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY 
    s.store_id,
    s.store_name
ORDER BY total_revenue DESC;


-- E5: Product Performance by Store
SELECT 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / SUM(oi.quantity),
        2
    ) AS avg_selling_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY s.store_id, revenue DESC;
