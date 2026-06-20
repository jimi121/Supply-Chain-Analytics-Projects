# 🛒 ShelfCo Supermarket: Retail Inventory and Supply Chain Analysis
**Tool:** PostgreSQL &nbsp;|&nbsp; **Author:** Olajimi Adeleke &nbsp;|&nbsp; **Project Type:** Portfolio Project


> **About This Project**
>
> This project is a SQL-based business analysis of ShelfCo Supermarket's retail inventory and supply chain operations across five branch locations in Ibadan, Nigeria. The analysis covers seven business areas including sales performance, stock health, supplier quality, and promotion effectiveness. Each section ends with a result summary, key insight, and a practical recommendation that the business can act on.


## 📑 Table of Contents

1. [Sales and Profitability Performance](#1-sales-and-profitability-performance)
   - [1.1 Top 10 Best-Selling and Most Profitable Products](#11-top-10-best-selling-and-most-profitable-products)
   - [1.2 Category-Level Profitability](#12-category-level-profitability)
   - [1.3 Store Performance Comparison](#13-store-performance-comparison)
2. [Inventory Health and Stock Management](#2-inventory-health-and-stock-management)
   - [2.1 Overall Stock Health](#21-overall-stock-health)
   - [2.2 Critically Low Stock Products](#22-critically-low-stock-products)
   - [2.3 Average Stock Coverage (Days of Stock Left)](#23-average-stock-coverage-days-of-stock-left)
3. [Stockout Analysis](#3-stockout-analysis)
   - [3.1 Products with Highest Stockout Frequency](#31-products-with-highest-stockout-frequency)
   - [3.2 Stores with Most Stockouts](#32-stores-with-most-stockouts)
4. [Expiry Management and Waste Prevention](#4-expiry-management-and-waste-prevention)
   - [4.1 Current Expiry Risk Level](#41-current-expiry-risk-level)
   - [4.2 Expired and Expiring Soon Products](#42-expired-and-expiring-soon-products)
5. [Supplier Performance Analysis](#5-supplier-performance-analysis)
   - [5.1 Supplier Lead Time and Product Quality](#51-supplier-lead-time-and-product-quality)
   - [5.2 Highest Damage Rates by Supplier and Product](#52-highest-damage-rates-by-supplier-and-product)
6. [Replenishment and Restocking Efficiency](#6-replenishment-and-restocking-efficiency)
   - [6.1 Restock Quantity vs Actual Sales](#61-restock-quantity-vs-actual-sales)
   - [6.2 Over-Stocked vs Under-Stocked Products](#62-over-stocked-vs-under-stocked-products)
   - [6.3 Average Restock Quantity by Category](#63-average-restock-quantity-by-category)
7. [Promotion and Customer Demand Effectiveness](#7-promotion-and-customer-demand-effectiveness)
   - [7.1 Do Promotions Increase Sales?](#71-do-promotions-increase-sales)
   - [7.2 Categories That Respond Best to Promotions](#72-categories-that-respond-best-to-promotions)
   - [7.3 Customer Demand Level vs Sales and Stockouts](#73-customer-demand-level-vs-sales-and-stockouts)


## 1. Sales and Profitability Performance

**Business Objective:** Understand which products, categories, and stores are driving revenue and profit, and identify underperforming areas.


### 1.1 Top 10 Best-Selling and Most Profitable Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      product_name,
      category,
      SUM(quantity_sold)                         AS total_units_sold,
      SUM(revenue)                               AS total_revenue,
      SUM(profit)                                AS total_profit,
      ROUND(AVG(profit_margin_percentage), 2)    AS avg_profit_margin
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY product_name, category
  ORDER BY total_revenue DESC
  LIMIT 10;
  ```

</details>

**Output:**

| Product Name | Category | Total Units Sold | Total Revenue (₦) | Total Profit (₦) | Avg Profit Margin (%) |
|---|---|---|---|---|---|
| Bread | Bakery | 3,913 | 5,658,958 | 1,481,779.87 | 25.90 |
| Coca-Cola 50cl | Beverages | 3,239 | 5,066,360 | 1,347,259.01 | 26.56 |
| Meat Pie | Bakery | 2,581 | 3,641,293 | 1,010,513.35 | 28.07 |
| Maltina Can | Beverages | 2,723 | 3,542,473 | 934,761.52 | 26.07 |
| Ice Cream | Frozen Foods | 2,078 | 3,133,764 | 826,085.13 | 26.33 |
| Fruit Juice | Beverages | 2,009 | 3,013,069 | 794,029.21 | 26.72 |
| Yoghurt | Dairy | 1,972 | 2,949,887 | 775,756.44 | 26.35 |
| Chocolate Drink | Beverages | 1,925 | 2,774,699 | 754,113.66 | 27.36 |
| Chicken Wings | Frozen Foods | 1,807 | 2,695,775 | 727,938.28 | 26.91 |
| Frozen Fish | Frozen Foods | 1,747 | 2,613,380 | 720,740.40 | 27.27 |

**📊 Result Summary**

Bread generated the highest revenue at ₦5.66M, followed by Coca-Cola 50cl at ₦5.07M. Meat Pie and Maltina Can round out the top four. Together, these four products alone account for a large portion of total store revenue across all five branches.

**💡 Key Insight**

Bread, Coca-Cola 50cl, and Meat Pie are the top performers in both revenue and profit. What stands out is that Meat Pie has the highest average profit margin among the top 10 at 28.07%, meaning it contributes strong value beyond just volume. It is also worth noting that the top 10 list cuts across Bakery, Beverages, and Frozen Foods, which tells us ShelfCo is not relying on a single category to drive performance.

**✅ Recommendation**

These products should always be in stock. Any stockout on Bread or Coca-Cola 50cl directly translates to lost revenue since they are the two biggest earners. Management should set stricter replenishment rules for these items and ensure shelf availability is monitored daily.


### 1.2 Category-Level Profitability

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      category,
      SUM(revenue)                            AS total_revenue,
      SUM(profit)                             AS total_profit,
      ROUND(AVG(profit_margin_percentage), 2) AS avg_profit_margin,
      COUNT(DISTINCT product_name)            AS num_products
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY category
  ORDER BY total_profit DESC;
  ```

</details>

**Output:**

| Category | Total Revenue (₦) | Total Profit (₦) | Avg Profit Margin (%) | No. of Products |
|---|---|---|---|---|
| Beverages | 14,396,601 | 3,830,163.40 | 26.68 | 4 |
| Bakery | 11,821,392 | 3,141,097.31 | 26.57 | 3 |
| Frozen Foods | 10,840,430 | 2,880,744.49 | 26.42 | 4 |
| Toiletries | 7,525,585 | 2,005,982.71 | 26.68 | 4 |
| Dairy | 5,985,028 | 1,603,267.09 | 26.87 | 3 |
| Household | 3,465,564 | 919,332.09 | 27.00 | 2 |

**📊 Result Summary**

Beverages is the top revenue category at ₦14.4M in total revenue and ₦3.8M in profit, generated by just 4 products. Bakery is second with ₦11.8M from only 3 products. The Household category sits at the bottom for total profit but actually carries the highest average margin at 27%.

**💡 Key Insight**

Beverages and Bakery are carrying the business from a profitability standpoint. Bakery is particularly impressive given it only has 3 products generating ₦3.1M in profit, which shows strong demand concentration. For Household, the story is interesting: the margin is the best in the portfolio, but the low product count is limiting how much it contributes overall. The limiting factor there is volume, not efficiency.

**✅ Recommendation**

Inventory spending and promotional energy should be focused on Beverages and Bakery since that is where the money is. For the Household category, the business should look at expanding the number of products stocked or increasing visibility for the existing two products. There is clearly untapped potential there given the strong margin.


### 1.3 Store Performance Comparison

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      store_name,
      SUM(revenue)                                   AS total_revenue,
      SUM(profit)                                    AS total_profit,
      ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)  AS profit_margin
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY store_name
  ORDER BY total_profit DESC;
  ```

</details>

**Output:**

| Store Name | Total Revenue (₦) | Total Profit (₦) | Profit Margin (%) |
|---|---|---|---|
| ShelfCo Akobo | 11,133,733 | 3,002,456.54 | 26.97 |
| ShelfCo Mokola | 11,247,301 | 2,976,747.05 | 26.47 |
| ShelfCo Bodija | 10,857,701 | 2,945,502.15 | 27.13 |
| ShelfCo Jericho | 10,437,674 | 2,761,469.95 | 26.46 |
| ShelfCo Ring Road | 10,358,191 | 2,694,411.40 | 26.01 |

**📊 Result Summary**

ShelfCo Akobo ranks first in total profit at ₦3.0M, while ShelfCo Mokola generates the highest revenue overall at ₦11.25M. Bodija comes in third on both revenue and profit but holds the best profit margin at 27.13%. Ring Road is at the bottom on both profit and margin.

**💡 Key Insight**

The performance gap across all five stores is actually quite small. The difference between the highest and lowest revenue stores is under ₦900K, which suggests demand is fairly consistent across ShelfCo's Ibadan locations. What stands out is Bodija having the best margin despite not being first in revenue. This points to better cost control or product mix decisions at that branch. Ring Road's 26.01% margin is the lowest and deserves a closer look.

**✅ Recommendation**

Management should study what Bodija is doing differently in terms of pricing, waste control, or product selection and share those practices with the other stores. For Ring Road specifically, a review of the cost structure and product mix would help identify where the margin is being lost.


## 2. Inventory Health and Stock Management

**Business Objective:** Monitor current stock levels and identify products that are overstocked or at risk of stockout.


### 2.1 Overall Stock Health

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      stock_status,
      COUNT(*)                     AS product_count,
      ROUND(AVG(current_stock), 0) AS avg_current_stock,
      ROUND(AVG(reorder_level), 0) AS avg_reorder_level
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY stock_status;
  ```

</details>

**Output:**

| Stock Status | Product Count | Avg Current Stock | Avg Reorder Level |
|---|---|---|---|
| Low | 705 | 77 | 65 |
| Healthy | 37 | 73 | 46 |
| Critical | 458 | 62 | 72 |

**📊 Result Summary**

Out of 1,200 total inventory records, only 37 (3.1%) are classified as Healthy. The remaining 1,163 records fall into either Low (705) or Critical (458) status. Products in the Critical category have an average current stock of 62, which is already 10 units below their average reorder level of 72.

**💡 Key Insight**

Less than 4% of the inventory is in good shape. That is a serious problem. More than a third of all records have fallen below the reorder point, meaning restocking should have been triggered already but has not. The fact that Critical items have stock sitting 10 units below the reorder threshold tells us that the replenishment process is either too slow or not being triggered at all in many cases.

**✅ Recommendation**

The business needs automated stock alerts so that inventory managers are notified the moment a product approaches its reorder level. Safety stock calculations also need to be revisited for fast-moving products because clearly the current buffers are not giving enough lead time before stock runs out.


### 2.2 Critically Low Stock Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      store_name,
      product_name,
      category,
      current_stock,
      reorder_level,
      restock_quantity,
      recommended_action
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  WHERE stock_status = 'Critical'
  ORDER BY current_stock ASC;
  ```

</details>

**Output (Top 15 of 458 critical records, ordered by lowest stock):**

| Store | Product | Category | Current Stock | Reorder Level | Restock Qty | Recommended Action |
|---|---|---|---|---|---|---|
| ShelfCo Akobo | Air Freshener | Household | 35 | 40 | 83 | URGENT RESTOCK |
| ShelfCo Bodija | Air Freshener | Household | 35 | 40 | 94 | URGENT RESTOCK |
| ShelfCo Akobo | Air Freshener | Household | 37 | 40 | 89 | URGENT RESTOCK |
| ShelfCo Jericho | Air Freshener | Household | 37 | 40 | 101 | URGENT RESTOCK |
| ShelfCo Akobo | Air Freshener | Household | 39 | 40 | 123 | URGENT RESTOCK |
| ShelfCo Bodija | Air Freshener | Household | 39 | 40 | 91 | URGENT RESTOCK |
| ShelfCo Jericho | Air Freshener | Household | 39 | 40 | 125 | URGENT RESTOCK |
| ShelfCo Jericho | Air Freshener | Household | 39 | 40 | 147 | URGENT RESTOCK |
| ShelfCo Bodija | Butter | Dairy | 40 | 60 | 138 | REMOVE EXPIRED STOCK |
| ShelfCo Mokola | Butter | Dairy | 40 | 60 | 131 | URGENT RESTOCK |
| ShelfCo Mokola | Shampoo | Toiletries | 40 | 50 | 84 | URGENT RESTOCK |
| ShelfCo Jericho | Shampoo | Toiletries | 41 | 50 | 128 | URGENT RESTOCK |
| ShelfCo Bodija | Shampoo | Toiletries | 41 | 50 | 132 | URGENT RESTOCK |
| ShelfCo Ring Road | Butter | Dairy | 41 | 60 | 114 | URGENT RESTOCK |
| ShelfCo Akobo | Cheese | Dairy | 41 | 50 | 108 | URGENT RESTOCK |

**📊 Result Summary**

Air Freshener, Butter, Shampoo, and Cheese show up repeatedly across different stores in the Critical category. In some cases the recommended action is not just to restock but to first remove expired stock, which means the actual usable inventory is even lower than what the numbers show.

**💡 Key Insight**

Dairy and Household products are where the critical stock situations are clustering. What makes this worse is the combination of critically low stock and expired units sitting on the shelves at the same time. Take Butter at ShelfCo Bodija for example: current stock is 40 units but the reorder level is 60, and the action flagged is to remove expired stock first. That means before any meaningful restocking can help, the branch has to deal with expired product taking up space. It is a two-layer problem.

**✅ Recommendation**

Restocking orders for Air Freshener, Butter, Shampoo, and Cheese should go out immediately across all affected stores. For products flagged to remove expired stock first, that clearance has to happen before the restock arrives otherwise the same problem repeats. These products also need more frequent replenishment cycles going forward, not just a one-time top-up.


### 2.3 Average Stock Coverage (Days of Stock Left)

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      product_name,
      category,
      AVG(current_stock::float / NULLIF(quantity_sold, 0)) AS days_of_stock_left
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY product_name, category
  ORDER BY days_of_stock_left ASC;
  ```

</details>

**Output:**

| Product Name | Category | Days of Stock Left |
|---|---|---|
| Bread | Bakery | 1.68 |
| Coca-Cola 50cl | Beverages | 1.77 |
| Maltina Can | Beverages | 1.85 |
| Ice Cream | Frozen Foods | 1.99 |
| Yoghurt | Dairy | 2.04 |
| Meat Pie | Bakery | 2.23 |
| Chocolate Drink | Beverages | 2.54 |
| Fruit Juice | Beverages | 2.57 |
| Sausage | Frozen Foods | 2.57 |
| Chicken Wings | Frozen Foods | 2.57 |
| Detergent | Household | 2.62 |
| Frozen Fish | Frozen Foods | 2.67 |
| Body Cream | Toiletries | 2.70 |
| Shampoo | Toiletries | 2.70 |
| Biscuits | Bakery | 2.71 |
| Toothpaste | Toiletries | 3.08 |
| Butter | Dairy | 3.27 |
| Cheese | Dairy | 3.37 |
| Soap | Toiletries | 3.54 |
| Air Freshener | Household | 3.99 |

**📊 Result Summary**

Bread and Coca-Cola 50cl have less than 2 days of stock left on average. No product in the entire portfolio has more than 4 days of coverage. The buffer across every category is extremely thin.

**💡 Key Insight**

The top revenue products are also the ones running out the fastest. Bread has 1.68 days of stock, Coca-Cola 50cl has 1.77 days, and Maltina Can has 1.85 days. If there is even a short delay in delivery, ShelfCo will be completely out of its best-selling products. For perishables like Yoghurt and Ice Cream, you cannot just stockpile more to compensate because that creates expiry risk. The margin for error here is very small.

**✅ Recommendation**

Safety stock levels need to go up for at least the five products with the lowest coverage: Bread, Coca-Cola 50cl, Maltina Can, Ice Cream, and Yoghurt. Management should also work with suppliers to lock in a consistent delivery schedule for these products so that there is never a situation where a short delay causes a full stockout.


## 3. Stockout Analysis

**Business Objective:** Identify how often stockouts occur and their impact on sales and customer satisfaction.


### 3.1 Products with Highest Stockout Frequency

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      product_name,
      category,
      COUNT(*)                                                                AS total_months,
      SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END)                     AS stockout_months,
      ROUND(
          100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
          2
      )                                                                       AS stockout_percentage
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY product_name, category
  HAVING SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) > 0
  ORDER BY stockout_percentage DESC;
  ```

</details>

**Output:**

| Product Name | Category | Total Months | Stockout Months | Stockout Rate (%) |
|---|---|---|---|---|
| Biscuits | Bakery | 60 | 60 | 100.00 |
| Butter | Dairy | 60 | 45 | 75.00 |
| Frozen Fish | Frozen Foods | 60 | 44 | 73.33 |
| Ice Cream | Frozen Foods | 60 | 37 | 61.67 |
| Sausage | Frozen Foods | 60 | 35 | 58.33 |
| Chicken Wings | Frozen Foods | 60 | 32 | 53.33 |
| Yoghurt | Dairy | 60 | 24 | 40.00 |
| Meat Pie | Bakery | 60 | 23 | 38.33 |
| Soap | Toiletries | 60 | 19 | 31.67 |
| Cheese | Dairy | 60 | 19 | 31.67 |
| Shampoo | Toiletries | 60 | 18 | 30.00 |
| Fruit Juice | Beverages | 60 | 17 | 28.33 |
| Coca-Cola 50cl | Beverages | 60 | 16 | 26.67 |
| Bread | Bakery | 60 | 16 | 26.67 |
| Maltina Can | Beverages | 60 | 15 | 25.00 |
| Toothpaste | Toiletries | 60 | 14 | 23.33 |
| Detergent | Household | 60 | 9 | 15.00 |
| Air Freshener | Household | 60 | 8 | 13.33 |
| Chocolate Drink | Beverages | 60 | 7 | 11.67 |

**📊 Result Summary**

Biscuits recorded a 100% stockout rate across all 60 months in the dataset, meaning it was never reliably in stock. Butter comes next at 75% and Frozen Fish at 73.33%. Frozen Food products as a group have the worst stockout numbers, with Ice Cream, Sausage, and Chicken Wings all above 50%.

**💡 Key Insight**

A 100% stockout rate for Biscuits means customers looking for this product were consistently turned away for the entire period covered in this analysis. That is not an occasional supply hiccup, it is a persistent failure. The pattern in Frozen Foods is equally concerning since four out of five frozen products have stockout rates above 50%. These are also perishable items, so the challenge is not just restocking more but restocking at the right frequency before they expire.

**✅ Recommendation**

Biscuits needs immediate and sustained attention. The reorder point and replenishment quantity for this product should be reviewed and fixed right away. For any product with a stockout rate above 50%, the current reorder policy is clearly not working and needs to be replaced with one that is driven by actual daily or weekly sales data rather than fixed order cycles.


### 3.2 Stores with Most Stockouts

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      store_name,
      COUNT(*)                                                             AS total_records,
      SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END)                  AS total_stockouts,
      ROUND(
          100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
          2
      )                                                                    AS stockout_rate
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY store_name
  ORDER BY stockout_rate DESC;
  ```

</details>

**Output:**

| Store Name | Total Records | Total Stockouts | Stockout Rate (%) |
|---|---|---|---|
| ShelfCo Jericho | 240 | 98 | 40.83 |
| ShelfCo Akobo | 240 | 97 | 40.42 |
| ShelfCo Ring Road | 240 | 91 | 37.92 |
| ShelfCo Bodija | 240 | 87 | 36.25 |
| ShelfCo Mokola | 240 | 85 | 35.42 |

**📊 Result Summary**

ShelfCo Jericho has the highest stockout rate at 40.83%, with Akobo close behind at 40.42%. All five stores sit between 35% and 41%, which confirms this is not a problem with one or two branches but a chain-wide issue.

**💡 Key Insight**

When every single store has a stockout rate above 35%, the problem is clearly not location-specific. Something in the overall supply chain and replenishment process is broken. Jericho and Akobo being slightly worse could be linked to higher customer traffic or being further from suppliers, but even the best performer (Mokola at 35.42%) has a stockout rate that is far too high for a retail operation.

**✅ Recommendation**

This requires a chain-wide fix, not just attention to individual stores. Management needs to look at whether delivery schedules are actually aligned with how fast products sell at each location. Jericho and Akobo should be the starting point since they have the worst numbers, but the solution being implemented there should eventually be rolled out to all branches.

---

## 4. Expiry Management and Waste Prevention

**Business Objective:** Reduce product expiry losses, especially for perishable items.


### 4.1 Current Expiry Risk Level

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      expiry_status,
      COUNT(*)                        AS product_count,
      SUM(quantity_sold)              AS units_sold,
      ROUND(AVG(days_to_expiry), 1)  AS avg_days_to_expiry
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY expiry_status
  ORDER BY expiry_status;
  ```

</details>

**Output:**

| Expiry Status | Product Count | Units Sold | Avg Days to Expiry |
|---|---|---|---|
| Expired | 154 | 4,854 | -8 |
| Expiring in 2 Months | 145 | 4,835 | 38.1 |
| Expiring Soon | 301 | 9,878 | 15.9 |
| Valid | 600 | 17,479 | 212 |

**📊 Result Summary**

154 product records are already past their expiry date, averaging 8 days overdue. Another 301 items are expiring within roughly 30 days, and 145 more will expire within 2 months. In total, 600 out of 1,200 records (exactly 50%) have some level of expiry concern.

**💡 Key Insight**

Half the inventory is at risk in some form. The most urgent issue is the 154 already-expired records. These products should not be on shelves or in storage, yet the data shows 4,854 units have been sold from these expired batches. That is both a financial loss and a food safety issue that could harm customers and damage the brand. The 301 items expiring soon represent the next wave of losses if action is not taken quickly.

**✅ Recommendation**

Every store needs to pull expired products off shelves immediately. For items expiring within 30 days, targeted promotions like discounts, bundles, or end-of-aisle placements should be used to move them before the date hits. ShelfCo should also enforce FIFO (First-In, First-Out) rotation across all branches as a standard practice to stop this problem from continuing.


### 4.2 Expired and Expiring Soon Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      store_name,
      product_name,
      category,
      expiry_date,
      days_to_expiry,
      current_stock,
      quantity_sold,
      recommended_action
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  WHERE expiry_status IN ('Expired', 'Expiring Soon')
  ORDER BY days_to_expiry ASC;
  ```

</details>

**Output (Top 15 of 455 records, ordered by oldest expiry):**

| Store | Product | Category | Expiry Date | Days to Expiry | Current Stock | Qty Sold | Recommended Action |
|---|---|---|---|---|---|---|---|
| ShelfCo Mokola | Butter | Dairy | 2025-11-16 | -15 | 65 | 14 | REMOVE EXPIRED STOCK |
| ShelfCo Jericho | Sausage | Frozen Foods | 2025-09-16 | -15 | 74 | 30 | REMOVE EXPIRED STOCK |
| ShelfCo Bodija | Meat Pie | Bakery | 2025-02-14 | -15 | 110 | 49 | REMOVE EXPIRED STOCK |
| ShelfCo Bodija | Butter | Dairy | 2025-04-16 | -15 | 58 | 14 | REMOVE EXPIRED STOCK |
| ShelfCo Bodija | Ice Cream | Frozen Foods | 2025-05-17 | -15 | 68 | 23 | REMOVE EXPIRED STOCK |
| ShelfCo Ring Road | Sausage | Frozen Foods | 2025-02-14 | -15 | 81 | 29 | REMOVE EXPIRED STOCK |
| ShelfCo Bodija | Biscuits | Bakery | 2025-01-17 | -15 | 87 | 18 | REMOVE EXPIRED STOCK |
| ShelfCo Jericho | Meat Pie | Bakery | 2025-04-16 | -15 | 101 | 47 | REMOVE EXPIRED STOCK |
| ShelfCo Mokola | Yoghurt | Dairy | 2024-12-17 | -15 | 55 | 22 | REMOVE EXPIRED STOCK |
| ShelfCo Ring Road | Butter | Dairy | 2024-12-18 | -14 | 54 | 20 | REMOVE EXPIRED STOCK |
| ShelfCo Ring Road | Meat Pie | Bakery | 2025-04-17 | -14 | 108 | 55 | REMOVE EXPIRED STOCK |
| ShelfCo Bodija | Butter | Dairy | 2025-07-18 | -14 | 52 | 21 | REMOVE EXPIRED STOCK |
| ShelfCo Akobo | Ice Cream | Frozen Foods | 2025-03-18 | -14 | 53 | 36 | REMOVE EXPIRED STOCK |
| ShelfCo Akobo | Sausage | Frozen Foods | 2025-05-18 | -14 | 62 | 35 | REMOVE EXPIRED STOCK |
| ShelfCo Mokola | Ice Cream | Frozen Foods | 2025-03-19 | -13 | 51 | 38 | REMOVE EXPIRED STOCK |

**📊 Result Summary**

Dairy and Frozen Food products are responsible for the majority of expired and soon-to-expire items across all five branches. Several of these expired items still show large quantities in stock, for example, 110 units of expired Meat Pie at ShelfCo Bodija, which means they are still sitting in storage and have not been removed.

**💡 Key Insight**

The large stock counts on already-expired items are concerning. Meat Pie at Bodija (110 units), Sausage at Ring Road (81 units), and Meat Pie at Jericho (101 units) should have been pulled from inventory long ago. The fact that they are still recorded as available points to either a gap in the expiry checking process or the absence of any automated system to flag these items. The same categories (Dairy and Frozen Foods) that have the most stockout problems are also the ones generating the most expired waste, which is a sign that the ordering and receiving process for these categories is fundamentally misaligned.

**✅ Recommendation**

A full store audit for expired products needs to happen right away at every branch. Going forward, the business should put in place a digital expiry tracking system that sends alerts at 30, 14, and 7 days before expiry for perishable products. For Frozen Foods and Dairy specifically, ordering in smaller quantities more frequently would reduce the amount of product sitting long enough to expire.


## 5. Supplier Performance Analysis

**Business Objective:** Evaluate supplier reliability and lead time impact on inventory.


### 5.1 Supplier Lead Time and Product Quality

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      supplier_name,
      AVG(average_lead_time_days)    AS avg_lead_time,
      AVG(lead_time_days)            AS actual_avg_lead_time,
      COUNT(*)                       AS total_transactions,
      ROUND(AVG(damaged_units), 2)   AS avg_damaged_units
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY supplier_name
  ORDER BY avg_lead_time DESC;
  ```

</details>

**Output:**

| Supplier Name | Avg Lead Time (days) | Actual Avg Lead Time (days) | Total Transactions | Avg Damaged Units |
|---|---|---|---|---|
| CoolFresh Logistics | 7 | 7 | 240 | 4.25 |
| Chi Limited | 6 | 6 | 180 | 3.63 |
| Daily Dairy | 5 | 5 | 180 | 3.62 |
| Prime Household | 4 | 4 | 360 | 3.99 |
| Dangote Foods | 3 | 3 | 60 | 4.10 |
| FreshBake Suppliers | 2 | 2 | 180 | 4.29 |

**📊 Result Summary**

CoolFresh Logistics takes the longest to deliver at 7 days and has the second-highest damage rate at 4.25 units per transaction. FreshBake Suppliers is the fastest at 2 days but produces the highest average damage at 4.29. Prime Household handles the most transactions (360) with a 4-day lead time and sits in the middle for damage.

**💡 Key Insight**

Speed does not guarantee quality here. FreshBake is delivering the fastest but damaging the most products per order, which suggests they may be rushing through handling or packing. CoolFresh is both the slowest and among the most damaging, which raises specific concerns about how they are managing temperature-sensitive products over a 7-day delivery window. Prime Household handles by far the most transactions and keeps damage at a reasonable level, which suggests their logistics process is more reliable at scale.

**✅ Recommendation**

Management should sit down with both CoolFresh Logistics and FreshBake Suppliers to review their handling and packaging practices. For CoolFresh specifically, the cold chain during delivery needs to be investigated. A formal performance tracker showing damage rates per supplier per quarter would make it easier to hold them accountable and make data-driven decisions about switching volume if things do not improve.


### 5.2 Highest Damage Rates by Supplier and Product

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      supplier_name,
      product_name,
      ROUND(AVG(damaged_units), 2) AS avg_damaged,
      SUM(damaged_units)           AS total_damaged
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY supplier_name, product_name
  ORDER BY total_damaged DESC;
  ```

</details>

**Output:**

| Supplier | Product | Avg Damaged | Total Damaged |
|---|---|---|---|
| FreshBake Suppliers | Meat Pie | 4.90 | 294 |
| CoolFresh Logistics | Ice Cream | 4.60 | 276 |
| Prime Household | Toothpaste | 4.45 | 267 |
| CoolFresh Logistics | Chicken Wings | 4.28 | 257 |
| CoolFresh Logistics | Frozen Fish | 4.10 | 246 |
| Dangote Foods | Coca-Cola 50cl | 4.10 | 246 |
| FreshBake Suppliers | Bread | 4.07 | 244 |
| CoolFresh Logistics | Sausage | 4.03 | 242 |
| Prime Household | Air Freshener | 4.02 | 241 |
| Prime Household | Detergent | 4.02 | 241 |
| Prime Household | Shampoo | 3.98 | 239 |
| FreshBake Suppliers | Biscuits | 3.90 | 234 |
| Chi Limited | Chocolate Drink | 3.88 | 233 |
| Prime Household | Soap | 3.82 | 229 |
| Chi Limited | Maltina Can | 3.77 | 226 |
| Prime Household | Body Cream | 3.68 | 221 |
| Daily Dairy | Yoghurt | 3.68 | 221 |
| Daily Dairy | Butter | 3.65 | 219 |
| Daily Dairy | Cheese | 3.52 | 211 |
| Chi Limited | Fruit Juice | 3.25 | 195 |

**📊 Result Summary**

FreshBake Suppliers' Meat Pie is the most damaged product-supplier combination with 294 total units damaged. CoolFresh Logistics appears four times in the top eight, with its frozen products (Ice Cream, Chicken Wings, Frozen Fish, Sausage) accounting for a large share of the damage total. Dangote Foods' 246 damaged units of Coca-Cola 50cl is also notable given that product's high revenue value.

**💡 Key Insight**

CoolFresh Logistics is the biggest damage problem in ShelfCo's supply chain. Every single one of their product lines (Ice Cream, Chicken Wings, Frozen Fish, Sausage) shows up with high damage totals, and all of them are frozen products. This strongly points to a cold chain failure during transport, possibly insufficient refrigeration or too many handoffs along the delivery route. FreshBake's Meat Pie damage (averaging 4.9 units per delivery) is also a concern since Meat Pie is a top-revenue product. Even Dangote Foods managing to damage 246 units of Coca-Cola 50cl, which is ShelfCo's second highest earner, is not something that should be accepted without a formal conversation.

**✅ Recommendation**

A cold chain audit of CoolFresh Logistics is the most urgent action. They are damaging too many products and the financial cost is adding up. For FreshBake Suppliers, better packaging for Meat Pie should be negotiated. Supplier contracts across the board should include clear terms on who bears the cost of damaged goods, and those terms need to actually be enforced.


## 6. Replenishment and Restocking Efficiency

**Business Objective:** Improve how we decide when and how much to restock.


### 6.1 Restock Quantity vs Actual Sales

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      product_name,
      category,
      ROUND(AVG(quantity_sold), 1)                                           AS avg_monthly_sales,
      ROUND(AVG(restock_quantity), 1)                                        AS avg_restock_qty,
      ROUND(AVG(restock_quantity) / NULLIF(AVG(quantity_sold), 0), 2)       AS restock_to_sales_ratio
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY product_name, category
  ORDER BY restock_to_sales_ratio DESC;
  ```

</details>

**Output:**

| Product Name | Category | Avg Monthly Sales | Avg Restock Qty | Restock-to-Sales Ratio |
|---|---|---|---|---|
| Butter | Dairy | 17.3 | 95.3 | 5.50 |
| Biscuits | Bakery | 28.5 | 111.6 | 3.92 |
| Cheese | Dairy | 18.1 | 57.9 | 3.20 |
| Frozen Fish | Frozen Foods | 29.1 | 90.7 | 3.11 |
| Soap | Toiletries | 19.5 | 59.4 | 3.05 |
| Air Freshener | Household | 14.1 | 42.7 | 3.04 |
| Shampoo | Toiletries | 21.9 | 61.9 | 2.83 |
| Sausage | Frozen Foods | 27.3 | 76.9 | 2.82 |
| Toothpaste | Toiletries | 20.9 | 52.5 | 2.51 |
| Ice Cream | Frozen Foods | 34.6 | 84.1 | 2.43 |
| Chicken Wings | Frozen Foods | 30.1 | 72.3 | 2.40 |
| Yoghurt | Dairy | 32.9 | 67.7 | 2.06 |
| Detergent | Household | 25.4 | 45.6 | 1.80 |
| Fruit Juice | Beverages | 33.5 | 60.1 | 1.79 |
| Meat Pie | Bakery | 43.0 | 67.3 | 1.56 |
| Chocolate Drink | Beverages | 32.1 | 46.5 | 1.45 |
| Body Cream | Toiletries | 24.6 | 34.1 | 1.38 |
| Maltina Can | Beverages | 45.4 | 51.9 | 1.14 |
| Coca-Cola 50cl | Beverages | 54.0 | 53.1 | 0.98 |
| Bread | Bakery | 65.2 | 52.3 | 0.80 |

**📊 Result Summary**

Butter is being restocked at 5.5 times its monthly sales rate, the highest mismatch of any product. Biscuits, Cheese, and Frozen Fish follow with ratios above 3x. At the other end, Bread (0.80x) and Coca-Cola 50cl (0.98x), the two top-revenue products, are being restocked at quantities that do not even cover what they sell each month.

**💡 Key Insight**

The replenishment pattern here is backwards. The slowest-selling products are getting the most stock, and the fastest-selling ones are not getting enough. Butter sells just 17.3 units a month but receives 95.3 units in restocking orders. That excess stock sits on shelves, risks expiry, and ties up working capital. Meanwhile, Bread is selling 65.2 units monthly but only receiving 52.3 in restock, creating a recurring shortfall that leads directly to the stockouts seen in Section 3. This is not a supplier problem. This is an ordering problem that can be fixed internally.

**✅ Recommendation**

Restock quantities need to be rebuilt from scratch using actual sales data. A simple rule would be to set restock quantities as the average monthly sales plus a safety buffer of 20 to 30 percent. As a starting point, Butter and Biscuits restock quantities should be cut significantly, and that freed-up budget should go toward increasing orders for Bread and Coca-Cola 50cl.


### 6.2 Over-Stocked vs Under-Stocked Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      product_name,
      category,
      ROUND(AVG(quantity_sold), 1)      AS avg_monthly_sales,
      ROUND(AVG(restock_quantity), 1)   AS avg_restock_qty,
      ROUND(AVG(current_stock), 1)      AS avg_current_stock,
      CASE
          WHEN AVG(restock_quantity) > AVG(quantity_sold) * 2 THEN 'Over Restocking'
          WHEN AVG(restock_quantity) < AVG(quantity_sold) * 0.8 THEN 'Under Restocking'
          ELSE 'Balanced'
      END                               AS restock_evaluation
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY product_name, category
  ORDER BY avg_restock_qty DESC;
  ```

</details>

**Output:**

| Product Name | Category | Avg Monthly Sales | Avg Restock Qty | Avg Current Stock | Evaluation |
|---|---|---|---|---|---|
| Biscuits | Bakery | 28.5 | 111.6 | 73.2 | Over Restocking |
| Butter | Dairy | 17.3 | 95.3 | 54.2 | Over Restocking |
| Frozen Fish | Frozen Foods | 29.1 | 90.7 | 74.5 | Over Restocking |
| Ice Cream | Frozen Foods | 34.6 | 84.1 | 66.3 | Over Restocking |
| Sausage | Frozen Foods | 27.3 | 76.9 | 67.2 | Over Restocking |
| Chicken Wings | Frozen Foods | 30.1 | 72.3 | 73.4 | Over Restocking |
| Yoghurt | Dairy | 32.9 | 67.7 | 63.7 | Over Restocking |
| Meat Pie | Bakery | 43.0 | 67.3 | 93.1 | Balanced |
| Shampoo | Toiletries | 21.9 | 61.9 | 56.7 | Over Restocking |
| Fruit Juice | Beverages | 33.5 | 60.1 | 81.4 | Balanced |
| Soap | Toiletries | 19.5 | 59.4 | 65.3 | Over Restocking |
| Cheese | Dairy | 18.1 | 57.9 | 56.5 | Over Restocking |
| Coca-Cola 50cl | Beverages | 54.0 | 53.1 | 93.7 | Balanced |
| Toothpaste | Toiletries | 20.9 | 52.5 | 62.0 | Over Restocking |
| Bread | Bakery | 65.2 | 52.3 | 107.6 | Balanced |
| Maltina Can | Beverages | 45.4 | 51.9 | 80.4 | Balanced |
| Chocolate Drink | Beverages | 32.1 | 46.5 | 78.0 | Balanced |
| Detergent | Household | 25.4 | 45.6 | 61.8 | Balanced |
| Air Freshener | Household | 14.1 | 42.7 | 52.4 | Over Restocking |
| Body Cream | Toiletries | 24.6 | 34.1 | 64.7 | Balanced |

**📊 Result Summary**

12 of the 20 products are classified as Over Restocking and 8 are Balanced. Not a single product is flagged as Under Restocking. Over-restocked products are mostly in Frozen Foods, Dairy, and Toiletries.

**💡 Key Insight**

The fact that no product shows as Under Restocking might look reassuring at first glance, but it is misleading. Products like Bread and Coca-Cola appear Balanced because their current stock level looks okay at the snapshot point in time. However, Query 6.1 already showed they are being ordered below their sales rate, so the deficit builds gradually. The real issue is that the categories with the worst expiry problems (Frozen Foods and Dairy) are the same ones being most over-restocked. Money is being spent on excess perishable stock that expires before it sells, while the fast movers run dry.

**✅ Recommendation**

A monthly review should compare what was ordered against what was actually sold the previous month for every product. Products in the Over Restocking group should have their order quantities reduced by at least 20 to 30 percent as a starting point. That budget should be redirected to improve supply for products that are consistently running out.


### 6.3 Average Restock Quantity by Category

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      category,
      ROUND(AVG(restock_quantity), 1) AS avg_restock_quantity,
      ROUND(AVG(quantity_sold), 1)    AS avg_units_sold
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY category
  ORDER BY avg_restock_quantity DESC;
  ```

</details>

**Output:**

| Category | Avg Restock Quantity | Avg Units Sold |
|---|---|---|
| Frozen Foods | 81.0 | 30.3 |
| Bakery | 77.0 | 45.6 |
| Dairy | 73.6 | 22.8 |
| Beverages | 52.9 | 41.2 |
| Toiletries | 52.0 | 21.7 |
| Household | 44.2 | 19.7 |

**📊 Result Summary**

Frozen Foods receives the most stock per restock order (81 units average) despite only selling 30.3 units per month on average, a ratio of about 2.7x. Dairy is worse in ratio terms: 73.6 units ordered for 22.8 units sold (3.23x). Beverages is the most balanced category, restocking 52.9 units against sales of 41.2.

**💡 Key Insight**

Beverages shows what a healthy restock-to-sales relationship should look like at the category level. The ratio is tight enough that stock does not pile up, but not so low that shelves run dry. Frozen Foods and Dairy are doing the opposite: ordering bulk quantities that outpace sales, which is exactly what leads to the expiry problems seen in Section 4. Toiletries and Household are also over-ordered relative to their sales, though not as severely.

**✅ Recommendation**

The Beverages category should be used as the internal benchmark when setting restock quantities for other categories. For Frozen Foods and Dairy, the shift should be from large bulk deliveries on a fixed schedule to smaller and more frequent orders that better match the pace of sales and reduce how much stock sits long enough to expire.


## 7. Promotion and Customer Demand Effectiveness

**Business Objective:** Understand the impact of promotions and demand patterns.


### 7.1 Do Promotions Increase Sales?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      promotion,
      category,
      ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
      ROUND(AVG(revenue), 2)       AS avg_revenue,
      COUNT(*)                     AS total_records
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY promotion, category
  ORDER BY promotion, avg_units_sold DESC;
  ```

</details>

**Output:**

| Promotion | Category | Avg Units Sold | Avg Revenue (₦) | Total Records |
|---|---|---|---|---|
| No | Bakery | 45.61 | 67,420.96 | 92 |
| No | Beverages | 41.19 | 60,018.79 | 125 |
| No | Frozen Foods | 29.87 | 44,438.17 | 126 |
| No | Dairy | 22.10 | 31,435.50 | 88 |
| No | Toiletries | 21.68 | 31,315.55 | 126 |
| No | Household | 19.89 | 30,268.55 | 64 |
| Yes | Bakery | 45.53 | 63,848.45 | 88 |
| Yes | Beverages | 41.28 | 59,950.02 | 115 |
| Yes | Frozen Foods | 30.74 | 45,975.61 | 114 |
| Yes | Dairy | 23.39 | 34,985.91 | 92 |
| Yes | Toiletries | 21.78 | 31,401.98 | 114 |
| Yes | Household | 19.55 | 27,292.45 | 56 |

**📊 Result Summary**

The volume difference between promoted and non-promoted periods is less than one unit across every category. Bakery actually earns less revenue during promotions (₦63,848 vs ₦67,421) despite selling about the same number of units, which means the discount is cutting into revenue without driving more sales.

**💡 Key Insight**

The current promotions are not working. A difference of less than one unit in average sales between promoted and non-promoted periods is not a meaningful result. What is worse is the Bakery example: the promotion lowers revenue without lifting volume. That means customers who were already going to buy bread or meat pie are getting it cheaper, not that new customers are being attracted. The promotions are giving away margin without growing the business.

**✅ Recommendation**

The current promotional approach needs to be rethought. Instead of broad discounts that anyone can access, the business should test more targeted approaches: time-limited offers on products approaching expiry, bundle deals that pair top sellers with slower-moving items, or loyalty-based rewards for repeat customers. Tracking which promotions actually result in more units sold (not just cheaper units) is the key measurement to focus on.


### 7.2 Categories That Respond Best to Promotions

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      category,
      promotion,
      ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
      ROUND(AVG(profit), 2)        AS avg_profit
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY category, promotion
  ORDER BY category, promotion;
  ```

</details>

**Output:**

| Category | Promotion | Avg Units Sold | Avg Profit (₦) |
|---|---|---|---|
| Bakery | No | 45.61 | 17,790.51 |
| Bakery | Yes | 45.53 | 17,095.11 |
| Beverages | No | 41.19 | 16,090.63 |
| Beverages | Yes | 41.28 | 15,815.96 |
| Dairy | No | 22.10 | 8,576.94 |
| Dairy | Yes | 23.39 | 9,222.78 |
| Frozen Foods | No | 29.87 | 11,790.18 |
| Frozen Foods | Yes | 30.74 | 12,238.44 |
| Household | No | 19.89 | 7,993.38 |
| Household | Yes | 19.55 | 7,281.36 |
| Toiletries | No | 21.68 | 8,243.17 |
| Toiletries | Yes | 21.78 | 8,485.47 |

**📊 Result Summary**

Dairy and Frozen Foods are the only two categories where both units sold and profit go up during promotions. Household sees the opposite: both volume and profit drop when promotions run. Bakery and Beverages show very little change either way.

**💡 Key Insight**

Dairy and Frozen Foods showing positive results from promotions is an interesting find, especially since these are also the categories with the most expiry risk. It suggests that promotions in these categories may be doing what they should: moving perishable stock faster before it expires. For Household, promotions are clearly making things worse by reducing profit without increasing sales. Running promotions on products that do not respond to them is a direct cost to the business.

**✅ Recommendation**

Promotional spending should be concentrated on Dairy and Frozen Foods where there is actual evidence of a positive response. For Household products, promotions should stop until there is a clearer strategy in place. Future promotional decisions should be made based on category-level response data rather than running the same type of campaign across the board.


### 7.3 Customer Demand Level vs Sales and Stockouts

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT
      customer_demand,
      ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
      ROUND(AVG(revenue), 2)       AS avg_revenue,
      ROUND(
          100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
          2
      )                            AS stockout_rate
  FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
  GROUP BY customer_demand
  ORDER BY avg_units_sold DESC;
  ```

</details>

**Output:**

| Customer Demand | Avg Units Sold | Avg Revenue (₦) | Stockout Rate (%) |
|---|---|---|---|
| High | 30.99 | 44,936.40 | 36.34 |
| Low | 30.83 | 44,724.82 | 39.49 |
| Medium | 30.81 | 45,446.47 | 38.48 |

**📊 Result Summary**

Average units sold and revenue are almost identical across High, Low, and Medium demand periods, with less than 0.2 units difference. The stockout rate during Low demand periods (39.49%) is actually higher than during High demand periods (36.34%).

**💡 Key Insight**

This result is surprising and important. You would expect stockouts to be highest during High demand periods when customers are buying more. Instead, stockouts happen more often when demand is Low. This tells us that stockouts at ShelfCo are not being caused by unexpected surges in customer demand. They are happening because the inventory system is running on fixed order quantities that do not respond to actual demand conditions at all. Whether demand is high or low, the same amount of stock is ordered, and that stock often runs out before the next order arrives regardless of how much or how little customers are buying.

**✅ Recommendation**

ShelfCo needs to move away from fixed-quantity ordering toward a model that adjusts based on recent sales. Even a basic setup where reorder quantities are updated monthly based on the previous month's actual sales would be a significant improvement over what is currently in place. If point-of-sale data is available, it should be feeding directly into the restocking decision rather than being ignored.


## Overall Conclusion

ShelfCo Supermarket has a solid revenue foundation built on strong products and consistent demand across all five branches. However, the operational side of the business, particularly inventory management and supply chain reliability, is limiting how much of that revenue potential is being captured.

| Area | Key Finding |
|---|---|
| **Top Products** | Bread, Coca-Cola 50cl, and Meat Pie drive the most revenue and profit |
| **Category Leaders** | Beverages and Bakery are the most profitable categories |
| **Store Performance** | All five branches perform within a narrow range; Bodija leads on margin |
| **Inventory Health** | 96.9% of inventory is at Low or Critical stock status |
| **Stockouts** | Biscuits has a 100% stockout rate; Frozen Foods is the most problematic category |
| **Expiry Risk** | 50% of inventory carries some expiry risk; 154 records are already expired |
| **Supplier Quality** | CoolFresh Logistics causes the most product damage, especially for frozen goods |
| **Restocking** | Fast-sellers like Bread and Coca-Cola are under-restocked while slow-sellers are over-ordered |
| **Promotions** | Minimal sales impact overall; Dairy and Frozen Foods respond best |
| **Demand Alignment** | Stockouts are happening even during Low demand periods |

Three things need to happen to move the business forward:

1. **Fix the restocking model.** Restock quantities should be based on actual sales data, not fixed numbers. Fast movers need more stock. Slow movers need less.
2. **Take expiry seriously.** A digital tracking system with automated alerts is not a luxury at this point. It is necessary. FIFO rotation should be enforced in every store.
3. **Hold suppliers accountable.** CoolFresh Logistics in particular needs a cold chain audit. Damage costs need to be tracked formally and built into supplier contracts.
