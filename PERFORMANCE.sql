use bike_stores_2016;
-- ============================================================
-- SECTION B: PERFORMANCE ANALYSIS
-- ============================================================

-- B1: Store Performance Summary
SELECT 
    s.store_id,
    s.store_name,
    s.city,
    s.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.customer_id),
        2
    ) AS revenue_per_customer
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY 
    s.store_id,
    s.store_name,
    s.city,
    s.state
ORDER BY total_revenue DESC;


-- B2: Staff Performance (Top Sellers)
SELECT 
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    s.store_name,
    COUNT(DISTINCT o.order_id) AS orders_processed,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN staffs st ON o.staff_id = st.staff_id
JOIN stores s ON st.store_id = s.store_id
WHERE o.order_status = 4 AND st.active = 1
GROUP BY 
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    s.store_name
ORDER BY total_revenue DESC;


-- B3: Top 20 Customers by Revenue (VIP Segment)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS lifetime_revenue,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / 
        COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(MAX(o.order_date), NOW()) AS days_since_last_order
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 4
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.state
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY lifetime_revenue DESC
LIMIT 20;


-- B4: Repeat vs One-Time Customers
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-Time Buyer'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Regular Customer'
        ELSE 'VIP Customer'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(lifetime_revenue) AS total_segment_revenue,
    ROUND(AVG(lifetime_revenue), 2) AS avg_customer_value
FROM (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS lifetime_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY c.customer_id
) AS customer_orders
GROUP BY 
    CASE 
        WHEN order_count = 1 THEN 'One-Time Buyer'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Regular Customer'
        ELSE 'VIP Customer'
    END
ORDER BY avg_customer_value DESC;
