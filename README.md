# bike-store-business-analysis
End-to-end SQL analysis of a multi-store bike retailer's sales, performance, delivery, and inventory data — from raw relational data to business-ready insights.
SQL + Power BI + Tableau + Python Business Analysis

📌 Project Overview

This project answers a set of core retail business questions using pure SQL against a 9-table relational database (customers, orders, order_items, products, stores, staffs, stocks, brands, categories).

Dataset: [Bike Store Relational Database](url) — 3 stores, ~1,445 customers, 321 products, 1,615 orders, 4,722 order line items.

❓ Business Questions Answered

Sales trend — which products/stores/months are driving revenue?

Performance — how do stores, staff, and customers rank?

Order fulfillment — what's the late delivery rate, and who/what is affected?

Products — best and worst sellers, by store and overall

Inventory — what's out of stock, low stock, or overstocked at each location?

🗂️ Schema

customers ──< orders >── stores
               │  │
               │  └──< staffs (self-referencing manager_id)
               │
               └──< order_items >── products ──< stocks >── stores
                                        │
                                        ├── brands
                                        └── categories                                       

orders.order_status: 1 = Pending · 2 = Processing · 3 = Rejected · 4 = Completed

🛠️ Tools Used: MySQL Workbench

📊 Key Findings
1. Revenue is dangerously concentrated in one store. Baldwin Bikes generates 70.6% of total revenue ($4.70M of $6.66M) from 1,019 orders — more than 3x Santa Cruz and 6.6x Rowlett combined. Rowlett, despite being smallest, has the highest average order value ($4,971 vs. Baldwin's $4,614), suggesting a higher-value but lower-volume customer base there.

2. Overall on-time delivery is weak — roughly 1 in 3 orders ships late. On-time rate is 68.3% (987/1,445 completed orders), averaging 1.98 days to ship. Santa Cruz has the worst late-delivery rate at 36.6% , even though it's only the #2 store by volume — meaning its delivery problem isn't simply a function of being overloaded.

3. A top-5 bestseller is out of stock at the store that sells the most of it. The Trek Remedy 29 Carbon Frameset (2016) is your #5 all-time bestseller (123 units, ~$200K revenue) — and it's sitting at zero stock in Santa Cruz . This is the single most concrete, actionable finding in the dataset: a proven revenue driver is currently unsellable at one location.

4. Capital is heavily tied up in a narrow set of premium Trek bikes. Across stores, $10.8M in inventory value sits in your overstock-flagged SKUs, and 71% of that ($7.7M) is Trek alone. The single biggest concentration is the Trek Domane SLR 9 Disc (2018) — $552K tied up in just two stores (Rowlett + Baldwin).

5. Out-of-stock issues aren't evenly distributed. Santa Cruz and Baldwin each have 10 out-of-stock SKUs; Rowlett has only 5 — consistent with Rowlett's smaller, lower-velocity footprint.
