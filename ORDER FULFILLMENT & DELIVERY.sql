use bike_stores_2016;
-- ============================================================
-- SECTION C: ORDER FULFILLMENT & DELIVERY ANALYSIS
-- ============================================================

-- C1: Late Delivery Rate (Overall & by Store)
SELECT 
    s.store_id,
    s.store_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate_pct,
    ROUND(
        AVG(DATEDIFF(o.shipped_date, o.required_date)),
        2
    ) AS avg_days_late
FROM orders o
JOIN stores s ON o.store_id = s.store_id
WHERE o.order_status = 4 AND o.shipped_date IS NOT NULL
GROUP BY 
    s.store_id,
    s.store_name
ORDER BY late_delivery_rate_pct DESC;


-- C2: Late Deliveries by Customer
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS late_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 4 AND o.shipped_date IS NOT NULL
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.state
HAVING SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) > 0
ORDER BY late_orders DESC;


-- C3: Late Deliveries by Product
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    COUNT(DISTINCT o.order_id) AS total_orders_containing_product,
    SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS late_rate_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4 AND o.shipped_date IS NOT NULL
GROUP BY 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY late_rate_pct DESC
LIMIT 20;


-- C4: Unshipped/Pending Orders (Orders Not Yet Fulfilled)
SELECT 
    o.order_id,
    o.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.store_id,
    s.store_name,
    o.staff_id,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    o.order_date,
    o.required_date,
    o.order_status,
    DATEDIFF(NOW(), o.required_date) AS days_overdue,
    COUNT(oi.item_id) AS line_items,
    SUM(oi.quantity) AS total_units
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN stores s ON o.store_id = s.store_id
LEFT JOIN staffs st ON o.staff_id = st.staff_id
WHERE o.shipped_date IS NULL
GROUP BY 
    o.order_id,
    o.customer_id,
    c.first_name,
    c.last_name,
    o.store_id,
    s.store_name,
    o.staff_id,
    st.first_name,
    st.last_name,
    o.order_date,
    o.required_date,
    o.order_status
ORDER BY DATEDIFF(NOW(), o.required_date) DESC;


-- C5: On-Time Delivery Rate Summary
SELECT 
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    SUM(CASE WHEN o.shipped_date <= o.required_date THEN 1 ELSE 0 END) AS on_time_orders,
    SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.shipped_date <= o.required_date THEN 1 ELSE 0 END) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS on_time_rate_pct,
    ROUND(
        AVG(DATEDIFF(o.shipped_date, o.order_date)),
        2
    ) AS avg_days_to_ship
FROM orders o
WHERE o.order_status = 4 AND o.shipped_date IS NOT NULL;