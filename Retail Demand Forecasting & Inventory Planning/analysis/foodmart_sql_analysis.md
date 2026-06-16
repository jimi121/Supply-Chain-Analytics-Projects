# 🛒 FoodMart Retail Chain: Demand Forecasting and Inventory Planning Analysis
**Tool:** PostgreSQL &nbsp;|&nbsp; **Author:** Olajimi Adeleke &nbsp;|&nbsp; **Project Type:** Portfolio Project

---

> **About This Project**
>
> FoodMart is a supermarket chain with seven branches across Ibadan, Nigeria. I worked with 18 months of transaction data covering 20 products, seven stores, and seven suppliers. The goal was to understand how demand behaves, identify where stockouts occur, evaluate supplier performance, and highlight areas where the business may be at risk of wasting perishable inventory.
>
> The analysis is organized into six sections, each focused on a specific business question. Using SQL, I explore the data and explain what the results reveal about demand patterns, inventory availability, supplier reliability, and operational risk. The findings provide a foundation for better forecasting, replenishment, and inventory planning decisions.

---

## 📑 Table of Contents

1. [Demand and Sales Analysis](#1-demand-and-sales-analysis)
   - [1.1 Top 10 Fastest Selling Products](#11-top-10-fastest-selling-products)
   - [1.2 Categories with the Most Unstable Demand](#12-categories-with-the-most-unstable-demand)
   - [1.3 Sales and Stockouts During Festive Periods](#13-sales-and-stockouts-during-festive-periods)
   - [1.4 Store Performance Comparison](#14-store-performance-comparison)
   - [1.5 Do Promotions Increase Sales?](#15-do-promotions-increase-sales)
   - [1.6 Products with the Most Unpredictable Demand](#16-products-with-the-most-unpredictable-demand)
2. [Inventory Risk Analysis](#2-inventory-risk-analysis)
   - [2.1 Categories with the Highest Stockout Rate](#21-categories-with-the-highest-stockout-rate)
   - [2.2 Products That Run Out of Stock Most Often](#22-products-that-run-out-of-stock-most-often)
   - [2.3 Stores with the Most Stockout Problems](#23-stores-with-the-most-stockout-problems)
   - [2.4 Perishable Categories and Daily Demand](#24-perishable-categories-and-daily-demand)
   - [2.5 Total Products Affected by Stockouts](#25-total-products-affected-by-stockouts)
   - [2.6 Categories with High Demand and High Stockouts](#26-categories-with-high-demand-and-high-stockouts)
3. [Replenishment Efficiency](#3-replenishment-efficiency)
   - [3.1 Average Weekly Demand for Top Products](#31-average-weekly-demand-for-top-products)
   - [3.2 Products with Frequent Stockouts Despite High Demand](#32-products-with-frequent-stockouts-despite-high-demand)
   - [3.3 Do Promotions Require Bigger Orders?](#33-do-promotions-require-bigger-orders)
   - [3.4 Festive vs Normal Period Demand](#34-festive-vs-normal-period-demand)
   - [3.5 Slow Selling Products That May Be Over-Ordered](#35-slow-selling-products-that-may-be-over-ordered)
   - [3.6 Demand Level and Stockout Relationship](#36-demand-level-and-stockout-relationship)
4. [Supplier Performance](#4-supplier-performance)
   - [4.1 On-Time Delivery by Supplier](#41-on-time-delivery-by-supplier)
   - [4.2 Suppliers with the Longest Total Delays](#42-suppliers-with-the-longest-total-delays)
   - [4.3 Do Supplier Delays Lead to More Stockouts?](#43-do-supplier-delays-lead-to-more-stockouts)
   - [4.4 Monthly Supplier On-Time Rate](#44-monthly-supplier-on-time-rate)
   - [4.5 Suppliers Affecting High-Demand Categories](#45-suppliers-affecting-high-demand-categories)
   - [4.6 Overall Supplier Delay Rate](#46-overall-supplier-delay-rate)
5. [Expiry and Waste Analysis](#5-expiry-and-waste-analysis)
   - [5.1 Categories with Short Shelf Life vs Daily Sales](#51-categories-with-short-shelf-life-vs-daily-sales)
   - [5.2 Fast-Selling Perishables at Risk of Waste](#52-fast-selling-perishables-at-risk-of-waste)
   - [5.3 Stockouts vs Expiry Risk in Perishable Categories](#53-stockouts-vs-expiry-risk-in-perishable-categories)
   - [5.4 High-Volume Products with Short Shelf Lives](#54-high-volume-products-with-short-shelf-lives)
   - [5.5 How Many Products Have Very High Expiry Risk?](#55-how-many-products-have-very-high-expiry-risk)
   - [5.6 Does Inflation Affect Buying of Perishable Goods?](#56-does-inflation-affect-buying-of-perishable-goods)
6. [Demand Trend Analysis](#6-demand-trend-analysis)
   - [6.1 Monthly Sales Trend and Growth](#61-monthly-sales-trend-and-growth)
   - [6.2 Demand by Day of the Week](#62-demand-by-day-of-the-week)
   - [6.3 Weekend vs Weekday Demand](#63-weekend-vs-weekday-demand)
   - [6.4 Products with the Strongest Upward Demand Trend](#64-products-with-the-strongest-upward-demand-trend)

---

## 1. Demand and Sales Analysis

Before inventory can be planned effectively, it is important to understand what customers are actually buying. This section explores the products and categories driving the most sales, identifies where demand is hardest to predict, and examines how promotions and festive periods influence purchasing behaviour. The goal is to build a clear picture of demand before looking at inventory-related problems.

---

### 1.1 Top 10 Fastest Selling Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name, 
      p.category,
      SUM(s.quantity_sold) AS total_units_sold,
      SUM(s.revenue) AS total_revenue_naira
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name, p.category
  ORDER BY total_units_sold DESC 
  LIMIT 10;
  ```

</details>

**Output:**

| Product Name | Category | Total Units Sold | Total Revenue (₦) |
|---|---|---|---|
| Bread | Bakery | 142,542 | 1,120,237,578 |
| Indomie Noodles | Food | 141,675 | 1,555,024,800 |
| Rice | Food | 140,280 | 593,805,240 |
| Toilet Tissue | Household | 94,645 | 903,291,880 |
| Coca-Cola | Beverages | 94,609 | 980,433,067 |
| Chocolate Drink | Beverages | 94,526 | 1,105,859,674 |
| Biscuits | Snacks | 94,428 | 619,919,820 |
| Maltina | Beverages | 93,975 | 1,047,539,325 |
| Peak Milk | Dairy | 93,798 | 389,918,286 |
| Yoghurt | Dairy | 93,594 | 188,966,286 |

Bread, Indomie Noodles and Rice consistently appear at the top of both sales volume and revenue rankings. These products are purchased frequently across all stores and represent the items customers are least willing to substitute. A stockout on any of these products would likely have a wider impact on overall store performance than a stockout on a slower-moving item.

---

### 1.2 Categories with the Most Unstable Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      ROUND(AVG(s.quantity_sold), 2) AS average_daily_sales,
      ROUND(STDDEV(s.quantity_sold), 2) AS sales_variation,
      ROUND((STDDEV(s.quantity_sold) / NULLIF(AVG(s.quantity_sold), 0)) * 100, 2) AS variation_percent
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.category
  ORDER BY variation_percent DESC;
  ```

</details>

**Output:**

| Category | Avg Daily Sales | Sales Variation | Variation (%) |
|---|---|---|---|
| Food | 29.24 | 17.32 | 59.22 |
| Frozen Foods | 24.14 | 13.72 | 56.83 |
| Snacks | 24.66 | 13.93 | 56.50 |
| Dairy | 24.33 | 13.69 | 56.28 |
| Beverages | 24.46 | 13.72 | 56.08 |
| Household | 24.48 | 13.68 | 55.89 |
| Bakery | 37.23 | 19.60 | 52.65 |

Food products show the highest demand variability, with daily sales fluctuating by almost 60% around the average. Frozen Foods, Snacks, Dairy and Beverages follow closely behind, suggesting that customer demand in most categories changes significantly from day to day. Bakery products have the highest daily sales volume overall, but their demand is slightly more stable than the other categories. This level of variation makes inventory planning more difficult because future demand cannot be estimated reliably using simple averages alone.

---

### 1.3 Sales and Stockouts During Festive Periods

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      festive_period,
      ROUND(AVG(quantity_sold), 2) AS average_units_sold,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS number_of_stockouts
  FROM sales
  GROUP BY festive_period;
  ```

</details>

**Output:**

| Festive Period | Avg Units Sold | Number of Stockouts |
|---|---|---|
| No | 24.35 | 16,092 |
| Yes | 35.68 | 3,170 |

Demand increases substantially during festive periods, with average sales rising from 24 units to nearly 36 units per day. Even with this higher demand, the number of recorded stockouts is lower than during normal periods. This suggests that inventory planning during festive seasons may already be receiving additional attention, allowing stores to support higher sales volumes without experiencing a proportional increase in stock shortages.

---

### 1.4 Store Performance Comparison

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      st.store_name,
      SUM(s.revenue) AS total_revenue_naira,
      ROUND(AVG(s.quantity_sold), 2) AS average_daily_units
  FROM sales s
  JOIN stores st ON s.store_id = st.store_id
  GROUP BY st.store_name
  ORDER BY total_revenue_naira DESC;
  ```

</details>

**Output:**

| Store Name | Total Revenue (₦) | Avg Daily Units |
|---|---|---|
| FoodMart Akobo | 1,914,032,426 | 26.56 |
| FoodMart Jericho | 1,903,906,721 | 26.34 |
| FoodMart Challenge | 1,888,715,634 | 26.18 |
| FoodMart Ring Road | 1,886,213,839 | 26.21 |
| FoodMart Bodija | 1,883,231,380 | 26.17 |
| FoodMart Mokola | 1,878,030,029 | 26.01 |
| FoodMart Dugbe | 1,877,903,480 | 26.15 |

Sales performance is remarkably consistent across all seven stores. Revenue differences between locations are relatively small, and average daily sales remain almost identical from one branch to another. No single store appears to be carrying the business, which suggests demand is evenly distributed across the network and inventory planning decisions can be standardized across most locations.

---

### 1.5 Do Promotions Increase Sales?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      promotion_applied,
      ROUND(AVG(s.quantity_sold), 2) AS average_units_sold
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.category, promotion_applied
  ORDER BY p.category;
  ```

</details>

**Output:**

| Category | Promotion Applied | Avg Units Sold |
|---|---|---|
| Bakery | Yes | 39.31 |
| Bakery | No | 35.18 |
| Beverages | Yes | 26.27 |
| Beverages | No | 22.65 |
| Dairy | Yes | 25.92 |
| Dairy | No | 22.74 |
| Food | Yes | 31.11 |
| Food | No | 27.39 |
| Frozen Foods | Yes | 25.57 |
| Frozen Foods | No | 22.74 |
| Household | Yes | 25.85 |
| Household | No | 23.14 |
| Snacks | Yes | 26.59 |
| Snacks | No | 22.76 |

Promotions increase average sales in every category. The effect is particularly visible in Bakery and Food products, where demand rises by roughly four units per day during promotional periods. Similar patterns appear across Beverages, Dairy, Snacks and Household products. Customers clearly respond to discounts and special offers, meaning promotional activity is an important driver of demand that should be considered when forecasting future sales.

---

### 1.6 Products with the Most Unpredictable Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      ROUND(STDDEV(s.quantity_sold), 2) AS demand_variation,
      ROUND(AVG(s.quantity_sold), 2) AS average_demand
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name
  ORDER BY demand_variation DESC 
  LIMIT 8;
  ```

</details>

**Output:**

| Product Name | Demand Variation | Avg Daily Demand |
|---|---|---|
| Bread | 19.60 | 37.23 |
| Rice | 19.46 | 36.64 |
| Indomie Noodles | 19.44 | 37.00 |
| Biscuits | 13.93 | 24.66 |
| Yoghurt | 13.87 | 24.44 |
| Toilet Tissue | 13.85 | 24.72 |
| Sausage | 13.84 | 24.22 |
| Coca-Cola | 13.81 | 24.71 |

Bread, Rice and Indomie Noodles combine high sales volumes with the largest swings in demand. These products are purchased frequently, but the quantity sold varies considerably from day to day. Because they are both high-volume and difficult to predict, forecasting errors on these items can have a much larger impact on inventory performance than forecasting errors on slower-moving products.

---

## 2. Inventory Risk Analysis

Once demand patterns are understood, the next question is where inventory is failing to keep up. Stockouts are one of the most expensive operational problems in retail because every unavailable product represents a potential lost sale. This section identifies where stock shortages occur most often and highlights the products, categories, and stores facing the greatest availability risk.

---

### 2.1 Categories with the Highest Stockout Rate

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockout_days,
      ROUND(100.0 * COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) / COUNT(*), 2) AS stockout_percent
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.category
  ORDER BY stockout_percent DESC;
  ```

</details>

**Output:**

| Category | Stockout Days | Stockout Rate (%) |
|---|---|---|
| Dairy | 3,910 | 25.53 |
| Household | 1,948 | 25.44 |
| Food | 4,822 | 25.19 |
| Snacks | 961 | 25.10 |
| Beverages | 3,837 | 25.05 |
| Bakery | 955 | 24.94 |
| Frozen Foods | 2,829 | 24.63 |

Stockout rates are surprisingly similar across categories, ranging from roughly 25% to 26%. Dairy experiences the highest stockout percentage, closely followed by Household and Food products. The consistency across categories suggests that stock shortages are not isolated to a specific product group but are instead a broader inventory management issue affecting the business as a whole.

---

### 2.2 Products That Run Out of Stock Most Often

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS times_out_of_stock
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name
  ORDER BY times_out_of_stock DESC
  LIMIT 10;
  ```

</details>

**Output:**

| Product Name | Times Out of Stock |
|---|---|
| Yoghurt | 1,002 |
| Detergent | 988 |
| Chocolate Drink | 986 |
| Butter | 984 |
| Rice | 984 |
| Indomie Noodles | 982 |
| Peak Milk | 971 |
| Coca-Cola | 970 |
| Biscuits | 961 |
| Toilet Tissue | 960 |

Yoghurt records the highest number of stockouts, followed closely by Detergent, Chocolate Drink, Butter and Rice. Several of the products appearing on this list also rank among the store's highest-selling items. This indicates that stock shortages are occurring on products customers purchase regularly, increasing the likelihood of lost sales and customer dissatisfaction.

---

### 2.3 Stores with the Most Stockout Problems

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      st.store_name,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS total_stockouts
  FROM sales s
  JOIN stores st ON s.store_id = st.store_id
  GROUP BY st.store_name
  ORDER BY total_stockouts DESC;
  ```

</details>

**Output:**

| Store Name | Total Stockouts |
|---|---|
| FoodMart Mokola | 2,803 |
| FoodMart Dugbe | 2,802 |
| FoodMart Ring Road | 2,789 |
| FoodMart Jericho | 2,754 |
| FoodMart Bodija | 2,731 |
| FoodMart Akobo | 2,696 |
| FoodMart Challenge | 2,687 |

Stockout levels are relatively similar across all stores, with only a small difference separating the highest and lowest locations. FoodMart Mokola records the most stockouts, while FoodMart Challenge records the fewest. Because the gap is small, stock availability issues appear to be network-wide rather than being driven by the performance of a single store.

---

### 2.4 Perishable Categories and Daily Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      AVG(p.shelf_life_days) AS shelf_life_days,
      ROUND(AVG(s.quantity_sold), 2) AS daily_demand
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  WHERE p.shelf_life_days < 60
  GROUP BY p.category
  ORDER BY shelf_life_days ASC;
  ```

</details>

**Output:**

| Category | Shelf Life (Days) | Daily Demand |
|---|---|---|
| Bakery | 7 | 37.23 |
| Dairy | 20.5 | 24.33 |
| Frozen Foods | 21.67 | 24.14 |

Bakery products have the shortest shelf life and the highest daily demand among all perishable categories. Dairy and Frozen Foods sell at lower daily volumes but still move quickly relative to their shelf-life limits. These categories require more precise replenishment because ordering too little creates stockouts, while ordering too much increases the risk of spoilage and waste.

---

### 2.5 Total Products Affected by Stockouts

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      COUNT(DISTINCT product_id) AS products_with_stockouts,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS total_stockout_events
  FROM sales;
  ```

</details>

**Output:**

| Products with Stockouts | Total Stockout Events |
|---|---|
| 20 | 19,262 |

All twenty products in the assortment experienced at least one stockout during the analysis period. With more than nineteen thousand stockout events recorded overall, inventory shortages are not limited to a handful of products but affect the entire product portfolio. This suggests the business is consistently operating with inventory levels that are unable to fully support customer demand.

---

### 2.6 Categories with High Demand and High Stockouts

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      ROUND(AVG(s.quantity_sold), 2) AS average_demand,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.category
  ORDER BY stockouts DESC;
  ```

</details>

**Output:**

| Category | Avg Demand | Total Stockouts |
|---|---|---|
| Food | 29.24 | 4,822 |
| Dairy | 24.33 | 3,910 |
| Beverages | 24.46 | 3,837 |
| Frozen Foods | 24.14 | 2,829 |
| Household | 24.48 | 1,948 |
| Snacks | 24.66 | 961 |
| Bakery | 37.23 | 955 |

Food products experience the highest combination of demand and stockouts, making them the largest contributor to lost sales risk. Dairy and Beverage categories also show substantial stockout volumes despite relatively stable average demand levels. These categories represent the areas where improvements in replenishment accuracy could have the greatest impact on product availability.

---

## 3. Replenishment Efficiency

Knowing where stockouts occur is only part of the story. The next step is understanding whether replenishment decisions are aligned with actual demand. This section examines demand levels, promotional activity, festive periods, and ordering patterns to identify situations where inventory may not be arriving in the right quantities or at the right time.

---

### 3.1 Average Weekly Demand for Top Products

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      ROUND(AVG(s.quantity_sold) * 7, 0) AS average_weekly_demand
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name
  ORDER BY average_weekly_demand DESC 
  LIMIT 10;
  ```

</details>

**Output:**

| Product Name | Avg Weekly Demand |
|---|---|
| Bread | 261 |
| Indomie Noodles | 259 |
| Rice | 256 |
| Chocolate Drink | 173 |
| Coca-Cola | 173 |
| Toilet Tissue | 173 |
| Biscuits | 173 |
| Maltina | 172 |
| Yoghurt | 171 |
| Peak Milk | 171 |

Bread, Indomie Noodles and Rice lead weekly demand by a significant margin, each averaging more than 250 units sold per week. The remaining products form a second tier with demand clustered around 170 units. This pattern highlights a small group of products that drive a disproportionate share of sales volume and require particularly close monitoring when planning inventory levels.

---

### 3.2 Products with Frequent Stockouts Despite High Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      ROUND(AVG(s.quantity_sold), 2) AS average_demand,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name
  HAVING COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) > 5
  ORDER BY stockouts DESC;
  ```

</details>

**Output:**

| Product Name | Avg Daily Demand | Stockouts |
|---|---|---|
| Yoghurt | 24.44 | 1,002 |
| Detergent | 24.24 | 988 |
| Chocolate Drink | 24.69 | 986 |
| Butter | 24.04 | 984 |
| Rice | 36.64 | 984 |
| Indomie Noodles | 37.00 | 982 |
| Peak Milk | 24.50 | 971 |
| Coca-Cola | 24.71 | 970 |
| Biscuits | 24.66 | 961 |
| Toilet Tissue | 24.72 | 960 |
| Golden Penny Spaghetti | 24.06 | 959 |
| Vegetable Oil | 24.17 | 956 |
| Bread | 37.23 | 955 |
| Frozen Chicken | 24.05 | 954 |
| Cheese | 24.33 | 953 |
| Sausage | 24.22 | 951 |
| Milo | 23.90 | 946 |
| Beans | 24.33 | 941 |
| Maltina | 24.54 | 935 |
| Ice Cream | 24.16 | 924 |

Many of the products experiencing the highest stockout counts are also products with strong daily demand. Rice, Bread and Indomie Noodles stand out because they combine very high sales volumes with frequent stock shortages. This suggests replenishment quantities are not fully keeping pace with customer demand, causing some of the store's most important products to run out regularly.

---

### 3.3 Do Promotions Require Bigger Orders?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      promotion_applied,
      ROUND(AVG(s.quantity_sold), 2) AS average_sales_during_promo
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name, promotion_applied;
  ```

</details>

**Output (selected rows):**

| Product Name | Promotion Applied | Avg Sales |
|---|---|---|
| Bread | Yes | 39.31 |
| Bread | No | 35.18 |
| Indomie Noodles | Yes | 39.21 |
| Indomie Noodles | No | 34.81 |
| Rice | Yes | 38.91 |
| Rice | No | 34.31 |
| Coca-Cola | Yes | 26.66 |
| Coca-Cola | No | 22.81 |
| Biscuits | Yes | 26.59 |
| Biscuits | No | 22.76 |

Products consistently sell more units when promotions are active. The increase is especially visible for high-volume items such as Bread, Rice and Indomie Noodles, where average sales rise by several units per day. Because promotions generate predictable demand increases, inventory requirements during promotional periods are likely higher than during normal trading periods.

---

### 3.4 Festive vs Normal Period Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      festive_period,
      ROUND(AVG(quantity_sold), 2) AS average_units_needed
  FROM sales
  GROUP BY festive_period;
  ```

</details>

**Output:**

| Festive Period | Avg Units Needed |
|---|---|
| No | 24.35 |
| Yes | 35.68 |

Average demand increases from approximately 24 units per day to almost 36 units during festive periods. This represents a substantial shift in purchasing behaviour and confirms that seasonal events have a meaningful impact on product consumption. Demand forecasting models that ignore festive periods would likely underestimate inventory requirements during these peak sales windows.

---

### 3.5 Slow-Selling Products That May Be Over-Ordered

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      ROUND(AVG(s.quantity_sold), 2) AS average_daily_sales
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY p.product_name
  HAVING AVG(s.quantity_sold) < 5
  ORDER BY average_daily_sales ASC
  LIMIT 8;
  ```

</details>

**Output:**

| Product Name | Avg Daily Sales |
|---|---|
| (No results returned) | |

No products were returned by the analysis, indicating that average sales remain sufficiently high across the product range. Based on the criteria used, there is no clear evidence that inventory is being heavily allocated to products with consistently weak demand.

---

### 3.6 Demand Level and Stockout Relationship

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      customer_demand_level,
      COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
  FROM sales
  GROUP BY customer_demand_level;
  ```

</details>

**Output:**

| Customer Demand Level | Stockouts |
|---|---|
| High | 3,527 |
| Medium | 8,467 |
| Low | 7,268 |

Stockouts occur across all demand levels, but the largest number is recorded among products with medium demand. High-demand products account for a smaller share of stockouts than expected, while low-demand products still contribute significantly to inventory shortages. This suggests stockout risk is not determined solely by sales volume and may also be influenced by replenishment practices and inventory policies.

---

## 4. Supplier Performance

Even well-planned inventory can run out if suppliers fail to deliver as expected. This section focuses on supplier reliability, delivery delays, and the potential impact of those delays on product availability. Understanding supplier performance helps explain whether stockouts are being driven by demand, replenishment decisions, or supply chain constraints.

---

### 4.1 On-Time Delivery by Supplier

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      sup.supplier_name,
      COUNT(*) AS total_deliveries,
      ROUND(AVG(sd.supplier_delay_days), 2) AS average_delay_days,
      ROUND(100.0 * SUM(CASE WHEN sd.supplier_reliability_status = 'On Time' THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_percent
  FROM supplier_deliveries sd
  JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
  GROUP BY sup.supplier_name
  ORDER BY on_time_percent ASC;
  ```

</details>

**Output:**

| Supplier Name | Total Deliveries | Avg Delay Days | On-Time Rate (%) |
|---|---|---|---|
| Naija Frozen Supplies | 151 | 4.19 | 50.99 |
| Ibadan Daily Essentials | 137 | 4.32 | 51.09 |
| FreshBake Foods Ltd | 149 | 3.93 | 55.70 |
| Golden Beverage Hub | 143 | 4.17 | 55.94 |
| Peak Consumer Goods | 157 | 3.82 | 57.32 |
| Lagos FMCG Distributors | 140 | 3.96 | 57.86 |
| Agodi Fresh Farms | 123 | 3.84 | 58.54 |

Supplier performance is relatively weak across the board, with on-time delivery rates ranging from approximately 51% to 59%. No supplier consistently achieves a high level of reliability, and average delays remain close to four days regardless of supplier. This indicates that late deliveries are a common occurrence rather than an isolated supplier issue.

---

### 4.2 Suppliers with the Longest Total Delays

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      sup.supplier_name,
      SUM(sd.supplier_delay_days) AS total_delay_days
  FROM supplier_deliveries sd
  JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
  GROUP BY sup.supplier_name
  ORDER BY total_delay_days DESC;
  ```

</details>

**Output:**

| Supplier Name | Total Delay Days |
|---|---|
| Naija Frozen Supplies | 632 |
| Peak Consumer Goods | 599 |
| Golden Beverage Hub | 597 |
| Ibadan Daily Essentials | 592 |
| FreshBake Foods Ltd | 585 |
| Lagos FMCG Distributors | 555 |
| Agodi Fresh Farms | 472 |

Naija Frozen Supplies accumulates the highest number of delayed days, followed closely by Peak Consumer Goods and Golden Beverage Hub. While the differences between suppliers are not extreme, the results show that delivery delays are frequent enough across all suppliers to create ongoing uncertainty in replenishment planning.

---

### 4.3 Do Supplier Delays Lead to More Stockouts?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      sup.supplier_name,
      COUNT(DISTINCT sd.delivery_id) AS total_deliveries,
      ROUND(AVG(sd.supplier_delay_days), 2) AS avg_delay_days,
      SUM(CASE WHEN sd.supplier_delay_days > 0 THEN 1 ELSE 0 END) AS delayed_deliveries,
      COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS related_stockouts,
      ROUND(100.0 * COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) 
            / NULLIF(COUNT(*), 0), 2) AS stockout_rate_pct
  FROM supplier_deliveries sd
  JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
  LEFT JOIN products p ON sd.supplier_id = p.supplier_id
  LEFT JOIN sales s ON p.product_id = s.product_id 
      AND s.date >= sd.actual_delivery_date - INTERVAL '45 days'
      AND s.date <= sd.actual_delivery_date + INTERVAL '15 days'
  GROUP BY sup.supplier_name
  ORDER BY avg_delay_days DESC;
  ```

</details>

**Output:**

| Supplier Name | Total Deliveries | Avg Delay Days | Delayed Deliveries | Related Stockouts | Stockout Rate (%) |
|---|---|---|---|---|---|
| Ibadan Daily Essentials | 137 | 4.32 | 119 | 22,250 | 25.62 |
| Naija Frozen Supplies | 151 | 4.16 | 130 | 23,945 | 24.98 |
| Golden Beverage Hub | 143 | 4.15 | 125 | 38,341 | 25.17 |
| Lagos FMCG Distributors | 140 | 3.94 | 128 | 22,264 | 25.24 |
| FreshBake Foods Ltd | 149 | 3.91 | 131 | 23,485 | 24.83 |
| Peak Consumer Goods | 157 | 3.80 | 124 | 24,748 | 24.80 |
| Agodi Fresh Farms | 123 | 3.84 | 104 | 0 | 0 |
The results show that suppliers with large numbers of delayed deliveries are also associated with substantial numbers of stockouts. Most suppliers display stockout rates close to 25%, suggesting a consistent relationship between delayed deliveries and product availability challenges. The exception is Agodi Fresh Farms, which records no related stockouts despite experiencing delivery delays, making it noticeably different from the other suppliers.

---

### 4.4 Monthly Supplier On-Time Rate

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      DATE_TRUNC('month', expected_delivery_date) AS month,
      ROUND(100.0 * AVG(CASE WHEN supplier_reliability_status = 'On Time' THEN 1 ELSE 0 END), 2) AS on_time_rate
  FROM supplier_deliveries
  GROUP BY month
  ORDER BY month;
  ```

</details>

**Output:**

| Month | On-Time Rate (%) |
|---|---|
| 2024 January | 52.00 |
| 2024 February | 56.90 |
| 2024 March | 55.74 |
| 2024 April | 45.65 |
| 2024 May | 49.02 |
| 2024 June | 46.03 |
| 2024 July | 52.08 |
| 2024 August | 56.36 |
| 2024 September | 58.62 |
| 2024 October | 61.40 |
| 2024 November | 53.13 |
| 2024 December | 70.18 |
| 2025 January | 64.29 |
| 2025 February | 42.86 |
| 2025 March | 56.16 |
| 2025 April | 55.56 |
| 2025 May | 59.18 |
| 2025 June | 59.09 |

Supplier reliability fluctuates significantly from month to month. On-time performance falls below 50% during several months but rises above 70% in December 2024. This variation suggests that supplier performance is not stable throughout the year and may be influenced by seasonal factors, operational constraints or changing demand conditions.

---

### 4.5 Suppliers Affecting High-Demand Categories

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      sup.supplier_name,
      p.category,
      AVG(sd.supplier_delay_days) AS average_delay
  FROM supplier_deliveries sd
  JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
  JOIN products p ON sup.supplier_id = p.supplier_id
  GROUP BY sup.supplier_name, p.category
  HAVING AVG(sd.supplier_delay_days) > 3;
  ```

</details>

**Output:**

| Supplier Name | Category | Avg Delay (Days) |
|---|---|---|
| Ibadan Daily Essentials | Food | 4.32 |
| Ibadan Daily Essentials | Bakery | 4.32 |
| Ibadan Daily Essentials | Dairy | 4.32 |
| Naija Frozen Supplies | Food | 4.19 |
| Naija Frozen Supplies | Beverages | 4.19 |
| Golden Beverage Hub | Snacks | 4.17 |
| Golden Beverage Hub | Dairy | 4.17 |
| Golden Beverage Hub | Frozen Foods | 4.17 |
| Golden Beverage Hub | Beverages | 4.17 |
| Lagos FMCG Distributors | Food | 3.96 |
| Lagos FMCG Distributors | Beverages | 3.96 |
| Lagos FMCG Distributors | Household | 3.96 |
| FreshBake Foods Ltd | Household | 3.93 |
| FreshBake Foods Ltd | Beverages | 3.93 |
| FreshBake Foods Ltd | Frozen Foods | 3.93 |
| Peak Consumer Goods | Dairy | 3.82 |
| Peak Consumer Goods | Food | 3.82 |
| Peak Consumer Goods | Frozen Foods | 3.82 |

Several suppliers support categories that are both high-demand and operationally important. Ibadan Daily Essentials and Naija Frozen Supplies are heavily involved in Food and Bakery products, while Peak Consumer Goods supplies Dairy and Frozen Foods. Delays from these suppliers have the potential to affect categories that contribute significantly to overall sales activity.

---

### 4.6 Overall Supplier Delay Rate

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      ROUND(100.0 * COUNT(CASE WHEN supplier_delay_days > 0 THEN 1 END) / COUNT(*), 2) AS delayed_percent
  FROM supplier_deliveries;
  ```

</details>

**Output:**

| Delayed Deliveries (%) |
|---|
| 86.10 |

More than 86% of deliveries experienced some level of delay during the analysis period. This indicates that late deliveries are the norm rather than the exception and suggests supplier lead times are highly unpredictable. Inventory planning processes must account for this level of uncertainty to avoid recurring stock shortages.

---

## 5. Expiry and Waste Analysis

While stockouts create lost sales, excess inventory creates a different problem: waste. This is especially important for products with limited shelf lives. This section explores the relationship between demand and shelf life to identify where the business may be at risk of spoilage, expiry, or unnecessary inventory holding costs.

---

### 5.1 Categories with Short Shelf Life vs Daily Sales

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      AVG(p.shelf_life_days) AS average_shelf_life,
      ROUND(AVG(s.quantity_sold), 2) AS daily_sales
  FROM products p
  JOIN sales s ON p.product_id = s.product_id
  GROUP BY p.category
  ORDER BY average_shelf_life ASC;
  ```

</details>

**Output:**

| Category | Avg Shelf Life (Days) | Daily Sales |
|---|---|---|
| Bakery | 7 | 37.23 |
| Dairy | 20.5 | 24.33 |
| Frozen Foods | 21.67 | 24.14 |
| Food | 195.8 | 29.24 |
| Snacks | 196 | 24.66 |
| Beverages | 214.5 | 24.46 |
| Household | 249 | 24.48 |

Bakery products stand out because they combine the shortest shelf life with the highest daily sales volume. Dairy and Frozen Foods also operate within relatively narrow shelf-life windows compared to the rest of the assortment. These categories require faster inventory turnover and leave less room for ordering mistakes than products with long shelf lives.

---

### 5.2 Fast-Selling Perishables at Risk of Waste

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      p.shelf_life_days,
      ROUND(AVG(s.quantity_sold), 2) AS daily_demand
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  WHERE p.shelf_life_days <= 30
  GROUP BY p.product_name, p.shelf_life_days
  ORDER BY daily_demand DESC;
  ```

</details>

**Output:**

| Product Name | Shelf Life (Days) | Daily Demand |
|---|---|---|
| Bread | 7 | 37.23 |
| Peak Milk | 13 | 24.50 |
| Yoghurt | 29 | 24.44 |
| Sausage | 9 | 24.22 |
| Ice Cream | 28 | 24.16 |
| Frozen Chicken | 28 | 24.05 |
| Butter | 9 | 24.04 |

Bread, Peak Milk and Yoghurt sell quickly but also have limited shelf lives. Products such as Sausage and Butter face an even tighter balance because they must be sold within a relatively short period after delivery. These products require careful inventory control because excess stock can quickly become unsellable.

---

### 5.3 Stockouts vs Expiry Risk in Perishable Categories

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.category,
      COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS stockouts
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  WHERE p.shelf_life_days < 60
  GROUP BY p.category;
  ```

</details>

**Output:**

| Category | Stockouts |
|---|---|
| Dairy | 3,910 |
| Frozen Foods | 2,829 |
| Bakery | 955 |

Dairy records the highest number of stockouts among perishable categories, followed by Frozen Foods and Bakery products. This suggests that availability challenges currently appear more visible than excess inventory issues. For perishables, the business is often running out of stock before products reach the end of their shelf life.

---

### 5.4 High-Volume Products with Short Shelf Lives

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      p.product_name,
      SUM(s.quantity_sold) AS total_sold,
      p.shelf_life_days
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  WHERE p.shelf_life_days <= 30
  GROUP BY p.product_name, p.shelf_life_days
  ORDER BY total_sold DESC;
  ```

</details>

**Output:**

| Product Name | Total Units Sold | Shelf Life (Days) |
|---|---|---|
| Bread | 142,542 | 7 |
| Peak Milk | 93,798 | 13 |
| Yoghurt | 93,594 | 29 |
| Sausage | 92,732 | 9 |
| Ice Cream | 92,510 | 28 |
| Frozen Chicken | 92,105 | 28 |
| Butter | 92,056 | 9 |

Bread is the clearest example of a high-volume, short-life product, selling more units than any other item while remaining sellable for only seven days. Peak Milk, Yoghurt, Sausage and Butter show similar characteristics on a smaller scale. These products have a narrow margin for inventory errors because both shortages and overstocking can be costly.

---

### 5.5 How Many Products Have Very High Expiry Risk?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      COUNT(CASE WHEN shelf_life_days < 15 THEN 1 END) AS very_high_risk_products,
      COUNT(CASE WHEN shelf_life_days BETWEEN 15 AND 30 THEN 1 END) AS high_risk_products,
      COUNT(CASE WHEN shelf_life_days > 30 THEN 1 END) AS lower_risk_products
  FROM products;
  ```

</details>

**Output:**

| Very High Risk Products | High Risk Products | Lower Risk Products |
|---|---|---|
| 4 | 3 | 13 |

Seven products fall into either the high-risk or very-high-risk category, while thirteen are considered lower risk. Although most products do not face severe expiry concerns, a meaningful portion of the assortment requires tighter inventory monitoring due to the combination of shelf-life constraints and demand patterns.

---

### 5.6 Does Inflation Affect Buying of Perishable Goods?

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      inflation_period,
      p.category,
      ROUND(AVG(s.quantity_sold), 2) AS average_demand
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY inflation_period, p.category
  ORDER BY p.category, inflation_period;
  ```

</details>

**Output:**

| Inflation Period | Category | Avg Demand |
|---|---|---|
| No | Bakery | 39.12 |
| Yes | Bakery | 32.22 |
| No | Beverages | 25.65 |
| Yes | Beverages | 21.29 |
| No | Dairy | 25.55 |
| Yes | Dairy | 21.09 |
| No | Food | 30.68 |
| Yes | Food | 25.41 |
| No | Frozen Foods | 25.56 |
| Yes | Frozen Foods | 20.41 |
| No | Household | 25.60 |
| Yes | Household | 21.51 |
| No | Snacks | 25.87 |
| Yes | Snacks | 21.46 |


Demand declines across every category during inflationary periods. The reduction is consistent, with average sales falling by roughly 15% to 20% depending on the category. This suggests customers become more selective in their purchasing behaviour when prices rise, reducing overall consumption across both essential and discretionary products.

---

## 6. Demand Trend Analysis

The final section shifts from current performance to longer-term patterns. By examining how demand changes across months, days of the week, and individual products, it becomes possible to identify recurring trends and seasonal behaviour. These insights provide a foundation for forecasting future demand rather than simply reacting to past sales.

---

### 6.1 Monthly Sales Trend and Growth

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      TO_CHAR(s.date, 'YYYY') AS year,
      TO_CHAR(s.date, 'Month') AS month_name,
      SUM(s.quantity_sold) AS total_units_sold,
      SUM(s.revenue) AS total_revenue_naira,
      ROUND(SUM(s.quantity_sold) / COUNT(DISTINCT s.date), 2) AS avg_daily_units
  FROM sales s
  GROUP BY 
      TO_CHAR(s.date, 'YYYY'),
      TO_CHAR(s.date, 'Month'),
      EXTRACT(YEAR FROM s.date),
      EXTRACT(MONTH FROM s.date)
  ORDER BY EXTRACT(YEAR FROM s.date), EXTRACT(MONTH FROM s.date);
  ```

</details>

**Output:**

| Year | Month | Total Units Sold | Total Revenue (₦) | Avg Daily Units |
|---|---|---|---|---|
| 2024 | January | 109,979 | 716,983,862 | 3,547 |
| 2024 | February | 92,012 | 610,887,828 | 3,172 |
| 2024 | March | 98,083 | 645,204,637 | 3,163 |
| 2024 | April | 149,690 | 990,337,686 | 4,989 |
| 2024 | May | 110,176 | 723,989,789 | 3,554 |
| 2024 | June | 104,533 | 691,178,819 | 3,484 |
| 2024 | July | 107,969 | 711,930,856 | 3,482 |
| 2024 | August | 99,050 | 651,343,841 | 3,195 |
| 2024 | September | 103,695 | 684,450,396 | 3,456 |
| 2024 | October | 109,361 | 715,432,066 | 3,527 |
| 2024 | November | 107,278 | 705,020,249 | 3,575 |
| 2024 | December | 154,638 | 1,019,332,164 | 4,988 |
| 2025 | January | 110,022 | 724,090,608 | 3,549 |
| 2025 | February | 88,705 | 586,643,151 | 3,168 |
| 2025 | March | 99,391 | 656,236,718 | 3,206 |
| 2025 | April | 150,198 | 985,081,156 | 5,006 |
| 2025 | May | 108,266 | 714,043,556 | 3,492 |
| 2025 | June | 105,705 | 699,846,127 | 3,523 |

Sales remain relatively stable throughout most months but show clear spikes in April and December. Both months record significantly higher unit sales and revenue than the surrounding periods, indicating recurring seasonal demand patterns. The consistency of these peaks across two years suggests they are driven by predictable events rather than random fluctuations.

---

### 6.2 Demand by Day of the Week

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      EXTRACT(DOW FROM s.date) AS day_of_week,
      TO_CHAR(s.date, 'Day') AS day_name,
      ROUND(AVG(s.quantity_sold), 2) AS avg_units_sold,
      SUM(s.quantity_sold) AS total_units_sold
  FROM sales s
  GROUP BY day_of_week, day_name
  ORDER BY day_of_week;
  ```

</details>

**Output:**

| Day | Avg Units Sold | Total Units Sold |
|---|---|---|
| Sunday | 26.24 | 286,500 |
| Monday | 26.24 | 290,250 |
| Tuesday | 26.46 | 288,956 |
| Wednesday | 26.27 | 286,915 |
| Thursday | 26.38 | 288,018 |
| Friday | 26.01 | 283,980 |
| Saturday | 26.02 | 284,132 |

Customer demand is remarkably consistent across all seven days of the week. Average sales fluctuate only slightly, with Tuesday recording the highest daily average and Friday the lowest. The differences are small enough to suggest that demand is spread evenly throughout the week rather than being concentrated on specific shopping days.

---

### 6.3 Weekend vs Weekday Demand

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  SELECT 
      CASE 
          WHEN EXTRACT(DOW FROM s.date) IN (0, 6) THEN 'Weekend'
          ELSE 'Weekday' 
      END AS period_type,
      ROUND(AVG(s.quantity_sold), 2) AS avg_daily_sales,
      SUM(s.quantity_sold) AS total_units_sold,
      COUNT(DISTINCT s.date) AS number_of_days
  FROM sales s
  GROUP BY period_type;
  ```

</details>

**Output:**

| Period Type | Avg Daily Sales | Total Units Sold | Number of Days |
|---|---|---|---|
| Weekday | 26.27 | 1,438,119 | 391 |
| Weekend | 26.13 | 570,632 | 156 |

Average daily sales are nearly identical between weekdays and weekends. Although total sales are naturally higher on weekdays because there are more weekday trading days in the dataset, customer purchasing behaviour appears largely unchanged between the two periods. Demand patterns therefore seem to be driven more by seasonality and promotions than by day type.

---

### 6.4 Products with the Strongest Upward Demand Trend

<details>
  <summary>🔍 Click to expand SQL query</summary>

  ```sql
  WITH monthly_sales AS (
      SELECT 
          p.product_name,
          EXTRACT(YEAR FROM s.date) * 100 + EXTRACT(MONTH FROM s.date) AS year_month,
          SUM(s.quantity_sold) AS monthly_units
      FROM sales s
      JOIN products p ON s.product_id = p.product_id
      GROUP BY p.product_name, year_month
  ),
  ranked AS (
      SELECT 
          product_name,
          monthly_units,
          ROW_NUMBER() OVER (PARTITION BY product_name ORDER BY year_month) AS month_rank,
          COUNT(*) OVER (PARTITION BY product_name) AS total_months
      FROM monthly_sales
  )
  SELECT 
      product_name,
      ROUND(AVG(monthly_units), 2) AS avg_monthly_units,
      ROUND(MAX(monthly_units) - MIN(monthly_units), 2) AS absolute_growth,
      ROUND(
          (MAX(monthly_units) - MIN(monthly_units)) * 100.0 / 
          NULLIF(MIN(monthly_units), 0), 2
      ) AS growth_percent,
      total_months
  FROM ranked
  WHERE total_months >= 6
  GROUP BY product_name, total_months
  ORDER BY growth_percent DESC 
  LIMIT 10;
  ```

</details>

**Output:**

| Product Name | Avg Monthly Units | Absolute Growth | Growth (%) | Total Months |
|---|---|---|---|---|
| Ice Cream | 5,139.44 | 3,454 | 91.96 | 18 |
| Detergent | 5,156.22 | 3,340 | 89.28 | 18 |
| Frozen Chicken | 5,116.94 | 3,408 | 87.68 | 18 |
| Coca-Cola | 5,256.06 | 3,530 | 86.88 | 18 |
| Chocolate Drink | 5,251.44 | 3,510 | 83.77 | 18 |
| Biscuits | 5,246.00 | 3,354 | 80.98 | 18 |
| Butter | 5,114.22 | 3,219 | 80.88 | 18 |
| Rice | 7,793.33 | 4,852 | 80.16 | 18 |
| Beans | 5,175.33 | 3,239 | 78.96 | 18 |
| Milo | 5,083.44 | 3,192 | 78.89 | 18 |

Ice Cream, Detergent, Frozen Chicken and Coca-Cola show the strongest growth over the analysis period, with demand increasing by more than 85% from the beginning to the end of the dataset. Rice also appears among the fastest-growing products despite already having a high sales volume. These products are becoming increasingly important contributors to future demand and may require larger inventory allocations over time.

---

## Overall Conclusion

This analysis covered 18 months of operations across seven FoodMart stores, 20 products, and seven suppliers. Looking across demand patterns, stockouts, supplier performance, and product shelf life, a few themes appear repeatedly.

Bread, Indomie Noodles, and Rice stand out throughout the analysis. They are among the highest-selling products in the business, but they also show some of the largest swings in demand. These products generate a significant share of sales, yet they are also among the most difficult to predict accurately. When they run out of stock, the impact is likely much greater than for slower-moving products.

Demand is also far from stable. Every category shows demand variation above 50%, while promotions, festive periods, and inflation all influence customer purchasing behaviour. April and December consistently record the strongest sales volumes, while inflation periods are associated with lower demand across every category. These patterns suggest that customer demand is being driven by factors that change over time rather than remaining constant throughout the year.

Stock availability remains a challenge across the business. Every product experienced stockouts during the analysis period, resulting in more than 19,000 stockout events. The issue is not concentrated in a single category or store; stockouts appear across the entire network, suggesting that inventory planning decisions may not be fully aligned with actual demand patterns.

Supplier performance adds another layer of uncertainty. More than 86% of deliveries experienced some level of delay, with suppliers averaging around four days late. This means inventory decisions cannot rely solely on planned lead times, since actual delivery performance often differs from expectations.

Taken together, the results point to three areas that deserve particular attention in the next phase of the project. First, high-volume products such as Bread, Rice, and Indomie Noodles would benefit from forecasting approaches that account for demand variability rather than relying on simple averages. Second, the recurring demand peaks observed in April and December suggest that seasonal adjustments should play an important role in future forecasting models. Finally, supplier lead times should reflect actual delivery performance rather than expected delivery dates, as delays appear to be a consistent feature of the supply chain.

These findings provide the foundation for the forecasting phase of the project, where historical demand patterns, seasonality, promotions, inflation effects, and supplier lead times can be incorporated into predictive models designed to improve inventory planning and reduce stockout risk.

---

*Analysis conducted using PostgreSQL.*  
*FoodMart Retail Chain, Ibadan — Demand Forecasting and Inventory Planning Portfolio Project.*
