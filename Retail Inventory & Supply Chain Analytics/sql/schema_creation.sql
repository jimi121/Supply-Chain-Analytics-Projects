-- Create DataBase "Supply Chain Projects"
CREATE DATABASE supply_chain_project;

-- Create Schema "Retail Inventory Optimization Analysis"
CREATE SCHEMA retail_inventory_optimization_analysis;

-- Set Schema to retail_inventory_optimization_analysis
SET search_path TO retail_inventory_optimization_analysis;

----------------------------- Create Tables--------------------------------
-- =============================================
-- 					CREATE TABLES 
-- =============================================

DROP TABLE IF EXISTS retail_inventory_optimization_analysis.transactions;
DROP TABLE IF EXISTS retail_inventory_optimization_analysis.products;
DROP TABLE IF EXISTS retail_inventory_optimization_analysis.suppliers;
DROP TABLE IF EXISTS retail_inventory_optimization_analysis.stores;

-- 1. STORES TABLE
CREATE TABLE retail_inventory_optimization_analysis.stores (
    store_id     VARCHAR(10) PRIMARY KEY,
    store_name   VARCHAR(100) NOT NULL,
    city         VARCHAR(50)  NOT NULL
);

-- 2. SUPPLIERS TABLE
CREATE TABLE retail_inventory_optimization_analysis.suppliers (
    supplier_id            VARCHAR(10) PRIMARY KEY,
    supplier_name          VARCHAR(100) NOT NULL,
    average_lead_time_days INT NOT NULL
);

-- 3. PRODUCTS TABLE
CREATE TABLE retail_inventory_optimization_analysis.products (
    product_id     VARCHAR(10) PRIMARY KEY,
    product_name   VARCHAR(100) NOT NULL,
    category       VARCHAR(50)  NOT NULL,
    supplier_id    VARCHAR(10)  NOT NULL,
    reorder_level  INT NOT NULL,

    CONSTRAINT fk_product_supplier 
        FOREIGN KEY (supplier_id) 
        REFERENCES retail_inventory_optimization_analysis.suppliers(supplier_id)
);

-- 4. TRANSACTIONS TABLE
CREATE TABLE retail_inventory_optimization_analysis.transactions (
    transaction_id   VARCHAR(20) PRIMARY KEY,
    date             DATE NOT NULL,
    store_id         VARCHAR(10) NOT NULL,
    product_id       VARCHAR(10) NOT NULL,

    quantity_sold    INT NOT NULL,
    current_stock    INT NOT NULL,
    warehouse_stock  INT NOT NULL,
    reorder_level    INT NOT NULL,
    restock_quantity INT NOT NULL,

    lead_time_days   INT NOT NULL,
    damaged_units    INT NOT NULL DEFAULT 0,

    promotion        VARCHAR(10),
    customer_demand  VARCHAR(20),

    expiry_date      DATE,
    stockout         VARCHAR(10),

    revenue          NUMERIC(12,2) NOT NULL,
    profit           NUMERIC(12,2) NOT NULL,

    CONSTRAINT fk_trans_store 
        FOREIGN KEY (store_id) 
        REFERENCES retail_inventory_optimization_analysis.stores(store_id),

    CONSTRAINT fk_trans_product 
        FOREIGN KEY (product_id) 
        REFERENCES retail_inventory_optimization_analysis.products(product_id)
);








