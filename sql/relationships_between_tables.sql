#Primary key
ALTER TABLE brands ADD PRIMARY KEY (brand_id);
ALTER TABLE categories ADD PRIMARY KEY (category_id);
ALTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE orders ADD PRIMARY KEY (order_id);
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE staffs ADD PRIMARY KEY (staff_id);
ALTER TABLE stores ADD PRIMARY KEY (store_id);

#Foreign key set up = database -> reverse engineer

