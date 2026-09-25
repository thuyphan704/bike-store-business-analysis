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
