--Retail Inventory & Supply Chain Analysis Project
--FoodCo Supermarket – Ibadan

--*******************************************************************************************************

/*
1. Sales and Profitability Performance
Business Objective: Understand which products, categories, and stores are driving revenue and profit, and identify 
underperforming areas. 
*/

-- 1.1 What are our Top 10 best-selling and most profitable products?
SELECT product_name, category, 
       SUM(quantity_sold) AS total_units_sold,
       SUM(revenue) AS total_revenue,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit_margin_percentage), 2) AS avg_profit_margin
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY product_name, category
ORDER BY total_revenue DESC
LIMIT 10;

-- 1.2 Which product categories are most and least profitable?
SELECT category, 
       SUM(revenue) AS total_revenue,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit_margin_percentage), 2) AS avg_profit_margin,
       COUNT(DISTINCT product_name) AS num_products
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY category
ORDER BY total_profit DESC;

-- 1.3 How do our stores compare in terms of revenue and profitability?
SELECT store_name, 
       SUM(revenue) AS total_revenue,
       SUM(profit) AS total_profit,
       ROUND(SUM(profit)*100.0/SUM(revenue), 2) AS profit_margin
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY store_name
ORDER BY total_profit DESC;

--*******************************************************************************************************

/*
2. Inventory Health & Stock Management
Business Objective: Monitor current stock levels and identify products that are overstocked or at risk of stockout.
*/

-- 2.1 What is the overall stock health across all products?
SELECT stock_status, COUNT(*) AS product_count,
       ROUND(AVG(current_stock), 0) AS avg_current_stock,
       ROUND(AVG(reorder_level), 0) AS avg_reorder_level
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY stock_status;

-- 2.2 Which products currently have critically low stock and need immediate attention?
SELECT store_name, product_name, category, current_stock, reorder_level, 
       restock_quantity, recommended_action
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
WHERE stock_status = 'Critical'
ORDER BY current_stock ASC;

-- 2.3 Average Stock Coverage (How many days of sales left)
SELECT product_name, category,
       AVG(current_stock::float / NULLIF(quantity_sold, 0)) AS days_of_stock_left
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY product_name, category
ORDER BY days_of_stock_left ASC;

--*******************************************************************************************************

/*
3. Stockout Analysis
Business Objective: Identify how often stockouts occur and their impact on sales and customer satisfaction.
*/
-- 3.1 Which products have the highest stockout frequency?
SELECT product_name, category,
       COUNT(*) AS total_months,
       SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_months,
       ROUND(100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS stockout_percentage
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY product_name, category
HAVING SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) > 0
ORDER BY stockout_percentage DESC;

-- 3.2 Which stores experience the most stockouts?
SELECT store_name, 
       COUNT(*) AS total_records,
       SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END) AS total_stockouts,
       ROUND(100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS stockout_rate
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY store_name
ORDER BY stockout_rate DESC;

--*******************************************************************************************************

/*
4. Expiry Management & Waste Prevention
Business Objective: Reduce product expiry losses, especially for perishable items.
*/
-- 4.1 What is the current expiry risk level across our inventory?
SELECT expiry_status, COUNT(*) AS product_count,
       SUM(quantity_sold) AS units_sold,
       ROUND(AVG(days_to_expiry), 1) AS avg_days_to_expiry
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY expiry_status
ORDER BY expiry_status;

-- 4.2 Which products are expired or expiring soon and need urgent action?
SELECT store_name, product_name, category, expiry_date, days_to_expiry, 
       current_stock, quantity_sold, recommended_action
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
WHERE expiry_status IN ('Expired', 'Expiring Soon')
ORDER BY days_to_expiry ASC;

--*******************************************************************************************************

/*
5. Supplier Performance Analysis
Business Objective: Evaluate supplier reliability and lead time impact on inventory.
*/
-- 5.1 How do our suppliers compare in terms of lead time and product quality?
SELECT supplier_name, 
       AVG(average_lead_time_days) AS avg_lead_time,
       AVG(lead_time_days) AS actual_avg_lead_time,
       COUNT(*) AS total_transactions,
       ROUND(AVG(damaged_units), 2) AS avg_damaged_units
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY supplier_name
ORDER BY avg_lead_time DESC;

-- 5.2 Which supplier-product combinations have the highest damage rate?
SELECT supplier_name, product_name,
       ROUND(AVG(damaged_units), 2) AS avg_damaged,
       SUM(damaged_units) AS total_damaged
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY supplier_name, product_name
ORDER BY total_damaged DESC;

--*******************************************************************************************************

/*
6. Replenishment & Restocking Efficiency
Business Objective: Improve how we decide when and how much to restock.
 */
-- 6.1 Are we restocking in the right quantities compared to actual sales?
SELECT product_name, category,
       ROUND(AVG(quantity_sold), 1) AS avg_monthly_sales,
       ROUND(AVG(restock_quantity), 1) AS avg_restock_qty,
       ROUND(AVG(restock_quantity) / NULLIF(AVG(quantity_sold), 0), 2) AS restock_to_sales_ratio
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY product_name, category
ORDER BY restock_to_sales_ratio DESC;

-- 6.2 Which products are being over-restocked or under-restocked?
SELECT product_name, category,
       ROUND(AVG(quantity_sold), 1) AS avg_monthly_sales,
       ROUND(AVG(restock_quantity), 1) AS avg_restock_qty,
       ROUND(AVG(current_stock), 1) AS avg_current_stock,
       CASE 
           WHEN AVG(restock_quantity) > AVG(quantity_sold) * 2 THEN 'Over Restocking'
           WHEN AVG(restock_quantity) < AVG(quantity_sold) * 0.8 THEN 'Under Restocking'
           ELSE 'Balanced'
       END AS restock_evaluation
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY product_name, category
ORDER BY avg_restock_qty DESC;

-- 6.3 What is the average restock quantity by category?
SELECT category,
       ROUND(AVG(restock_quantity), 1) AS avg_restock_quantity,
       ROUND(AVG(quantity_sold), 1) AS avg_units_sold
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY category
ORDER BY avg_restock_quantity DESC;

--*******************************************************************************************************

/*
7. Promotion & Customer Demand Effectiveness
Business Objective: Understand the impact of promotions and demand patterns.
 */
-- 7.1 Do promotions actually increase sales volume and revenue?
SELECT promotion, category,
       ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
       ROUND(AVG(revenue), 2) AS avg_revenue,
       COUNT(*) AS total_records
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY promotion, category
ORDER BY promotion, avg_units_sold DESC;

-- 7.2 Which categories respond best to promotions?
SELECT category, promotion,
       ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
       ROUND(AVG(profit), 2) AS avg_profit
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY category, promotion
ORDER BY category, promotion;

-- 7.3 How does customer demand level affect sales and stockouts?
SELECT customer_demand,
       ROUND(AVG(quantity_sold), 2) AS avg_units_sold,
       ROUND(AVG(revenue), 2) AS avg_revenue,
       ROUND(100.0 * SUM(CASE WHEN stockout = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS stockout_rate
FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis
GROUP BY customer_demand
ORDER BY avg_units_sold DESC;





