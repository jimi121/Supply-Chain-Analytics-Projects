-- Create Schema "Retail Inventory Optimization Analysis"
CREATE SCHEMA demand_forecasting_analytics;

-- Set Schema to demand_forecasting_anlaytics
SET search_path TO demand_forecasting_analytics;

----------------------------- Create Tables--------------------------------
-- =============================================
-- 					CREATE TABLES 
-- =============================================
DROP TABLE IF EXISTS stores CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS supplier_deliveries CASCADE;

-- 1. Stores
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- 2. Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(50),
    location VARCHAR(100)
);

-- 3. Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),
    cost_price NUMERIC(12,2) NOT NULL CHECK (cost_price > 0),
    shelf_life_days INTEGER CHECK (shelf_life_days > 0)
);

-- 4. Sales
CREATE TABLE sales (
    sales_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    store_id INTEGER REFERENCES stores(store_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity_sold INTEGER NOT NULL CHECK (quantity_sold >= 0),
    revenue NUMERIC(15,2) NOT NULL CHECK (revenue >= 0),
    promotion_applied VARCHAR(3) DEFAULT 'No' CHECK (promotion_applied IN ('Yes', 'No')),
    customer_demand_level VARCHAR(20),
    festive_period VARCHAR(3) DEFAULT 'No' CHECK (festive_period IN ('Yes', 'No')),
    inflation_period VARCHAR(3) DEFAULT 'No' CHECK (inflation_period IN ('Yes', 'No')),
    stockout_event VARCHAR(3) DEFAULT 'No' CHECK (stockout_event IN ('Yes', 'No'))
);

-- 5. Inventory
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    store_id INTEGER REFERENCES stores(store_id),
    current_stock INTEGER NOT NULL CHECK (current_stock >= 0),
    reorder_level INTEGER NOT NULL CHECK (reorder_level >= 0),
    reorder_quantity INTEGER NOT NULL CHECK (reorder_quantity > 0),
    expiry_date DATE,
    damaged_units INTEGER DEFAULT 0 CHECK (damaged_units >= 0),
    stock_received_date DATE,
    UNIQUE(product_id, store_id)
);

-- 6. Supplier Deliveries
CREATE TABLE supplier_deliveries (
    delivery_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE,
    supplier_delay_days INTEGER DEFAULT 0 CHECK (supplier_delay_days >= 0),
    supplier_reliability_status VARCHAR(20) CHECK (supplier_reliability_status IN ('On Time', 'Delayed'))
);

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









