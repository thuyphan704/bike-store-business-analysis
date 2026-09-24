use bike_stores_2016;
-- ============================================================
-- SECTION D: INVENTORY MANAGEMENT
-- ============================================================

-- D1: Current Stock by Store (Inventory Overview)
SELECT 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.list_price,
    st.quantity AS current_stock,
    CASE 
        WHEN st.quantity = 0 THEN 'Out of Stock'
        WHEN st.quantity < 10 THEN 'Low Stock'
        WHEN st.quantity < 20 THEN 'Medium Stock'
        ELSE 'Adequate Stock'
    END AS stock_status,
    ROUND(st.quantity * p.list_price, 2) AS inventory_value
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
ORDER BY s.store_id, st.quantity ASC;


-- D2: Out of Stock Products by Store
SELECT 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.list_price
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE st.quantity = 0
ORDER BY s.store_id, c.category_name;


-- D3: Overstock Alert (High Inventory - Slow Moving Products)
SELECT 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    st.quantity AS current_stock,
    ROUND(st.quantity * p.list_price, 2) AS inventory_value,
    MAX(o.order_date) AS last_sale_date,
    DATEDIFF(NOW(), MAX(o.order_date)) AS days_since_last_sale,
    SUM(oi.quantity) AS units_sold_last_3mo
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON st.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id 
    AND o.store_id = st.store_id
    AND o.order_date >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
WHERE st.quantity > 20
GROUP BY 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    st.quantity,
    p.list_price
HAVING MAX(o.order_date) < DATE_SUB(NOW(), INTERVAL 3 MONTH)
    OR MAX(o.order_date) IS NULL
ORDER BY inventory_value DESC;


-- D4: Inventory Summary by Category & Store
SELECT 
    s.store_id,
    s.store_name,
    c.category_id,
    c.category_name,
    COUNT(DISTINCT p.product_id) AS products_in_category,
    SUM(st.quantity) AS total_units,
    ROUND(SUM(st.quantity * p.list_price), 2) AS total_value,
    ROUND(AVG(st.quantity), 2) AS avg_units_per_product,
    MIN(st.quantity) AS min_stock,
    MAX(st.quantity) AS max_stock,
    SUM(CASE WHEN st.quantity = 0 THEN 1 ELSE 0 END) AS out_of_stock_count
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY 
    s.store_id,
    s.store_name,
    c.category_id,
    c.category_name
ORDER BY s.store_id, total_value DESC;


-- D5: Low Stock Alert (Below 10 units)
SELECT 
    s.store_id,
    s.store_name,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    st.quantity,
    p.list_price
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE st.quantity < 10 AND st.quantity > 0
ORDER BY s.store_id, st.quantity ASC;