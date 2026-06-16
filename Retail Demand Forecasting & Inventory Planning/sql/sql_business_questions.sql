-- SECTION A — DEMAND & SALES ANALYSIS
/*Business Objective :
We want to understand what customers are buying, which products sell fast or slow, and how demand changes during promotions 
or festive periods. This helps us forecast future sales accurately and avoid empty shelves or too much stock.*/

/*Question 1: What are the top 10 fastest selling products?
(This shows which items customers love most so we can keep them in stock.)*/
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

/* Question 2: Which product categories have very unstable demand?
(This measures how much daily sales go up and down) */
SELECT 
    p.category,
    ROUND(AVG(s.quantity_sold), 2) AS average_daily_sales,
    ROUND(STDDEV(s.quantity_sold), 2) AS sales_variation,
    ROUND((STDDEV(s.quantity_sold) / NULLIF(AVG(s.quantity_sold), 0)) * 100, 2) AS variation_percent
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY variation_percent DESC;

/* Question 3: Do sales and stockouts increase during festive periods?
(This helps us prepare for holidays like Christmas or Eid.) */
SELECT 
    s.festive_period,
    ROUND(AVG(s.quantity_sold), 2) AS average_units_sold,
    COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS number_of_stockouts
FROM sales s
GROUP BY s.festive_period;

/*Question 4: Which stores are performing best in sales?
(This shows if some locations need more attention or stock.)*/
SELECT 
    st.store_name,
    SUM(s.revenue) AS total_revenue_naira,
    ROUND(AVG(s.quantity_sold), 2) AS average_daily_units
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name
ORDER BY total_revenue_naira DESC;

/*
 Question 5: How much do promotions really increase sales?
(This tells us if discounts are working well.)
 */
SELECT 
    p.category,
    s.promotion_applied,
    ROUND(AVG(s.quantity_sold), 2) AS average_units_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category, s.promotion_applied
ORDER BY p.category;

/*
 Question 6: Which products have the most unpredictable demand?
(This identifies risky items that are hard to forecast.)
 */
SELECT 
    p.product_name,
    ROUND(STDDEV(s.quantity_sold), 2) AS demand_variation,
    ROUND(AVG(s.quantity_sold), 2) AS average_demand
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY demand_variation DESC 
LIMIT 8;


-- SECTION B — INVENTORY RISK ANALYSIS
/* Business Objective (Simple Explanation):
We want to find products that often run out of stock or have too much stock. This reduces lost sales and waste, which is 
very important for a supermarket in Nigeria.*/

/*Question 1: Which categories have the highest stockout rate?
(Stockout means the product is not available when customers want it.)*/
SELECT 
    p.category,
    COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS stockout_days,
    ROUND(100.0 * COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) / COUNT(*), 2) AS stockout_percent
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY stockout_percent DESC;

/*Question 2: Which individual products run out of stock most often? */
SELECT 
    p.product_name,
    COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS times_out_of_stock
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY times_out_of_stock DESC
LIMIT 10;

/*Question 3: Which stores have the most stockout problems?*/
SELECT 
    st.store_name,
    COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS total_stockouts
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name
ORDER BY total_stockouts DESC;

--Question 4: Are we ordering enough for perishable items?
-- (Perishables like milk and bread go bad quickly.)
SELECT 
    p.category,
    AVG(p.shelf_life_days) AS shelf_life_days,
    ROUND(AVG(s.quantity_sold), 2) AS daily_demand
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.shelf_life_days < 60
GROUP BY p.category
ORDER BY shelf_life_days ASC;

-- Question 5: How many products are at risk of low stock every day?
SELECT 
    COUNT(DISTINCT product_id) AS products_with_stockouts,
    COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS total_stockout_events
FROM sales;

-- Question 6: Which categories suffer from both stockouts and high demand?
SELECT 
    p.category,
    ROUND(AVG(s.quantity_sold), 2) AS average_demand,
    COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY stockouts DESC;


-- SECTION C — REPLENISHMENT EFFICIENCY
/* Business Objective (Simple Explanation):
We check if we are ordering the right quantity at the right time. Good replenishment means less money tied up in stock and 
fewer empty shelves. */

-- Question 1: What is the average weekly demand for top products?
-- (This helps decide how much to order each week.)
SELECT 
    p.product_name,
    ROUND(AVG(s.quantity_sold) * 7, 0) AS average_weekly_demand
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY average_weekly_demand DESC 
LIMIT 10;

-- Question 2: Which products often run out despite high demand?
-- (This shows possible under-ordering.)
SELECT 
    p.product_name,
    ROUND(AVG(s.quantity_sold), 2) AS average_demand,
    COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) > 5
ORDER BY stockouts DESC;

-- Question 3: Do promotions require bigger orders?
SELECT 
    p.product_name,
    promotion_applied,
    ROUND(AVG(s.quantity_sold), 2) AS average_sales_during_promo
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, promotion_applied;

-- Question 4: How does demand change in festive vs normal periods?
SELECT 
    festive_period,
    ROUND(AVG(quantity_sold), 2) AS average_units_needed
FROM sales
GROUP BY festive_period;

-- Question 5: Which slow-selling products may be over-ordered?
SELECT 
    p.product_name,
    ROUND(AVG(s.quantity_sold), 2) AS average_daily_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING AVG(s.quantity_sold) < 5
ORDER BY average_daily_sales ASC
LIMIT 8;

-- Question 6: Is there a link between demand level and stockouts?
SELECT 
    customer_demand_level,
    COUNT(CASE WHEN stockout_event = 'Yes' THEN 1 END) AS stockouts
FROM sales
GROUP BY customer_demand_level;

-- SECTION D — SUPPLIER PERFORMANCE
/*Business Objective (Simple Explanation):
We check how reliable our suppliers are. Late deliveries cause stockouts. We need to know who to trust more.*/

-- Question 1: Which suppliers deliver on time and which are often late?
SELECT 
    sup.supplier_name,
    COUNT(DISTINCT sd.delivery_id) AS total_deliveries,
    ROUND(AVG(sd.supplier_delay_days), 2) AS average_delay_days,
    ROUND(100.0 * AVG(CASE WHEN sd.supplier_reliability_status = 'On Time' THEN 1 ELSE 0 END), 2) AS on_time_percent
FROM supplier_deliveries sd
JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name
ORDER BY average_delay_days DESC;

-- Question 2: Which suppliers cause the longest total delays?
SELECT 
    sup.supplier_name,
    SUM(sd.supplier_delay_days) AS total_delay_days
FROM supplier_deliveries sd
JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name
ORDER BY total_delay_days DESC;

-- Question 3: Do supplier delays lead to more stockouts?
SELECT 
    sup.supplier_name,
    COUNT(DISTINCT sd.delivery_id) AS total_deliveries,
    ROUND(AVG(sd.supplier_delay_days), 2) AS avg_delay_days,
    COUNT(DISTINCT CASE WHEN sd.supplier_delay_days > 0 THEN sd.delivery_id END) AS delayed_deliveries,
    COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS related_stockouts,
    ROUND(100.0 * COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) 
          / NULLIF(COUNT(*), 0), 2) AS stockout_rate_pct
FROM supplier_deliveries sd
JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
LEFT JOIN products p ON sd.supplier_id = p.supplier_id
LEFT JOIN sales s ON p.product_id = s.product_id 
    AND s.date >= sd.actual_delivery_date 
    AND s.date <= sd.actual_delivery_date + INTERVAL '30 days'
GROUP BY sup.supplier_name
ORDER BY avg_delay_days DESC;

-- Question 4: How has supplier performance changed over months?
SELECT 
    DATE_TRUNC('month', sd.actual_delivery_date) AS month,
    ROUND(100.0 * AVG(CASE WHEN sd.supplier_reliability_status = 'On Time' THEN 1 ELSE 0 END), 2) AS on_time_rate
FROM supplier_deliveries sd
GROUP BY month
ORDER BY month;

-- Question 5: Which suppliers affect important categories?
SELECT 
    sup.supplier_name,
    p.category,
    ROUND(AVG(sd.supplier_delay_days), 2) AS average_delay
FROM supplier_deliveries sd
JOIN suppliers sup ON sd.supplier_id = sup.supplier_id
JOIN products p ON sd.supplier_id = p.supplier_id
GROUP BY sup.supplier_name, p.category
ORDER BY average_delay DESC;

-- Question 6: What is the overall supplier delay rate?
SELECT 
    ROUND(100.0 * COUNT(CASE WHEN supplier_delay_days > 0 THEN 1 END) / COUNT(*), 2) AS delayed_percent
FROM supplier_deliveries;


-- SECTION E — EXPIRY & WASTE ANALYSIS
/* Business Objective (Simple Explanation):
We want to reduce products going bad on the shelf (especially milk, bread, chicken). This saves money and reduces waste.*/

-- Question 1: Which categories have short shelf life compared to sales?
SELECT 
    p.category,
    ROUND(AVG(p.shelf_life_days), 1) AS average_shelf_life,
    ROUND(AVG(s.quantity_sold), 2) AS daily_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY average_shelf_life ASC;

-- Question 2: Which fast-selling perishables risk going to waste?
SELECT 
    p.product_name,
    p.category,
    SUM(s.quantity_sold) AS total_sold,
    AVG(p.shelf_life_days) AS shelf_life_days,
    ROUND(AVG(s.quantity_sold), 2) AS avg_daily_demand
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.shelf_life_days <= 30
GROUP BY p.product_name, p.category
ORDER BY total_sold DESC
LIMIT 10;

-- Question 3: Do we have more stockouts or expiry risk in perishables?
SELECT 
    p.category,
    COUNT(CASE WHEN s.stockout_event = 'Yes' THEN 1 END) AS stockouts
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.shelf_life_days < 60
GROUP BY p.category
ORDER BY stockouts DESC;

-- Question 4: Top high-volume short-life products?
SELECT 
    p.product_name,
    SUM(s.quantity_sold) AS total_sold,
    p.shelf_life_days
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.shelf_life_days <= 30
GROUP BY p.product_name, p.shelf_life_days
ORDER BY total_sold DESC;

-- Question 5: How many products have very high expiry risk?
SELECT 
    COUNT(CASE WHEN shelf_life_days < 15 THEN 1 END) AS very_high_risk_products,
    COUNT(CASE WHEN shelf_life_days BETWEEN 15 AND 30 THEN 1 END) AS high_risk_products,
    COUNT(CASE WHEN shelf_life_days > 30 THEN 1 END) AS lower_risk_products
FROM products;

-- Question 6: Does inflation affect buying of perishable goods?
SELECT 
    inflation_period,
    p.category,
    ROUND(AVG(s.quantity_sold), 2) AS average_demand
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY inflation_period, p.category
ORDER BY p.category, inflation_period;


-- SECTION F — DEMAND TREND ANALYSIS
/* Business Objective:
We want to understand how demand is changing over time, identify growth patterns, weekly cycles, and long-term trends. 
This helps us plan for increasing or decreasing demand and make better long-term inventory and procurement decisions.
*/

-- Question 1: What is the overall daily sales trend over the entire period?
--SELECT 
--    s.date,
--    SUM(s.quantity_sold) AS total_units_sold,
--    SUM(s.revenue) AS total_revenue
--FROM sales s
--GROUP BY s.date
--ORDER BY s.date;

-- Question 1: What is the monthly sales trend and growth?
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

-- Question 2: How does demand differ by day of the week?
SELECT 
    EXTRACT(DOW FROM s.date) AS day_of_week,
    TO_CHAR(s.date, 'Day') AS day_name,
    ROUND(AVG(s.quantity_sold), 2) AS avg_units_sold,
    SUM(s.quantity_sold) AS total_units_sold
FROM sales s
GROUP BY day_of_week, day_name
ORDER BY day_of_week;

-- Question 3: Weekend vs Weekday demand comparison
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

-- Question 5: Demand trend by category over time (Monthly)
--SELECT 
--    p.category,
--    EXTRACT(YEAR FROM s.date) AS year,
--    EXTRACT(MONTH FROM s.date) AS month,
--    ROUND(AVG(s.quantity_sold), 2) AS avg_monthly_demand
--FROM sales s
--JOIN products p ON s.product_id = p.product_id
--GROUP BY p.category, year, month
--ORDER BY p.category, year, month;

-- Question 4: Which products show the strongest upward demand trend?
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











































