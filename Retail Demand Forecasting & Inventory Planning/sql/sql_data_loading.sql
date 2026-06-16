-------------------------Import Data Into Tables------------------------------
-- Import Stores Data into Stores Table
COPY stores
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\stores.csv'
DELIMITER ','
CSV HEADER;

-- Import suppliers Data into suppliers Table
COPY suppliers
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\suppliers.csv'
DELIMITER ','
CSV HEADER;

-- Import products Data into products Table
COPY products
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\products.csv'
DELIMITER ','
CSV HEADER;

-- Import sales Data into sales Table
COPY sales
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\sales.csv'
DELIMITER ','
CSV HEADER;

-- Import inventory Data into inventory Table
COPY inventory
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\inventory.csv'
DELIMITER ','
CSV HEADER;

-- Import supplier_deliveries Data into supplier_deliveries Table
COPY supplier_deliveries
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\Demand Forecasting Analytics\Data\supplier_deliveries.csv'
DELIMITER ','
CSV HEADER;

-- ====================================================================================================
-- INDEXES FOR BETTER QUERY PERFORMANCE
-- ====================================================================================================

-- 1. Stores Table
CREATE INDEX idx_stores_location ON stores(location);

-- 2. Products Table
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_supplier_id ON products(supplier_id);

-- 3. Sales Table (Most Important - Heavily Queried)
CREATE INDEX idx_sales_date ON sales(date);
CREATE INDEX idx_sales_product_id ON sales(product_id);
CREATE INDEX idx_sales_store_id ON sales(store_id);
CREATE INDEX idx_sales_date_product ON sales(date, product_id);           -- for time series
CREATE INDEX idx_sales_date_store ON sales(date, store_id);
CREATE INDEX idx_sales_product_stockout ON sales(product_id, stockout_event);
CREATE INDEX idx_sales_promotion ON sales(promotion_applied);
CREATE INDEX idx_sales_festive ON sales(festive_period);

-- 4. Supplier Deliveries Table
CREATE INDEX idx_deliveries_supplier_id ON supplier_deliveries(supplier_id);
CREATE INDEX idx_deliveries_expected_date ON supplier_deliveries(expected_delivery_date);
CREATE INDEX idx_deliveries_actual_date ON supplier_deliveries(actual_delivery_date);
CREATE INDEX idx_deliveries_status ON supplier_deliveries(supplier_reliability_status);

-- 5. Inventory Table (if you have created it)
CREATE INDEX idx_inventory_product_id ON inventory(product_id);
CREATE INDEX idx_inventory_store_id ON inventory(store_id);
CREATE INDEX idx_inventory_product_store ON inventory(product_id, store_id);  -- For fast lookups
CREATE INDEX idx_inventory_expiry ON inventory(expiry_date);

-- ==========================================================================================
-- Verify Indexes Created
-- ==========================================================================================
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- =========================================================================================
-- DATA CLEANING & VALIDATION 
-- =========================================================================================
-- Check for duplicates
SELECT 'sales' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT sales_id) as unique_ids 
FROM sales 
UNION ALL
SELECT 'inventory', COUNT(*), COUNT(DISTINCT inventory_id) FROM inventory;

-- Missing values & data quality
SELECT 
    COUNT(CASE WHEN date IS NULL THEN 1 END) as null_dates,
    COUNT(CASE WHEN quantity_sold < 0 THEN 1 END) as negative_sales,
    COUNT(CASE WHEN current_stock < 0 THEN 1 END) as negative_stock
FROM sales s
FULL JOIN inventory i ON TRUE;

-- Date validation
SELECT 
    MIN(date) as earliest_sale,
    MAX(date) as latest_sale,
    COUNT(CASE WHEN expiry_date < CURRENT_DATE THEN 1 END) as already_expired
FROM sales s
LEFT JOIN inventory i ON s.product_id = i.product_id;

-- Remove invalid records
DELETE FROM sales WHERE quantity_sold < 0 OR revenue < 0;
UPDATE inventory SET damaged_units = 0 WHERE damaged_units IS NULL;