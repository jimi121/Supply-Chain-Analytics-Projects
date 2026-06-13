-------------------------Import Data Into Tables------------------------------

-- Import Stores Data into Stores Table
COPY retail_inventory_optimization_analysis.stores
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\stores.csv'
DELIMITER ','
CSV HEADER;

-- Import Suppliers Data into Suppliers Table
COPY retail_inventory_optimization_analysis.suppliers
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\suppliers.csv'
DELIMITER ','
CSV HEADER;

-- Import Products Data into Products Table
COPY retail_inventory_optimization_analysis.products
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\products.csv'
DELIMITER ','
CSV HEADER;

-- Import Transactions Data into Transactions Table
COPY retail_inventory_optimization_analysis.transactions
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\Supply Chain Projects\transactions.csv'
DELIMITER ','
CSV HEADER;


--------------------------------Verify Data--------------------------------
-- Check Row Counts

SELECT COUNT(*) FROM retail_inventory_optimization_analysis.stores;

SELECT COUNT(*) FROM retail_inventory_optimization_analysis.suppliers;

SELECT COUNT(*) FROM retail_inventory_optimization_analysis.products;

SELECT COUNT(*) FROM retail_inventory_optimization_analysis.transactions;


--View Sample Data
SELECT * 
FROM retail_inventory_optimization_analysis.transactions
LIMIT 10;


---------------------Create Index---------------------------
-- Create Index on Product_id
CREATE INDEX idx_transactions_product
ON retail_inventory_optimization_analysis.transactions(product_id);

-- Create Index on Store_id
CREATE INDEX idx_transactions_store
ON retail_inventory_optimization_analysis.transactions(store_id);

-- Create Index on Date
CREATE INDEX idx_transactions_date
ON retail_inventory_optimization_analysis.transactions(date);

-- Create Index on Stockout
CREATE INDEX idx_transactions_stockout
ON retail_inventory_optimization_analysis.transactions(stockout);

-- Create index on Category
CREATE INDEX idx_products_category
ON retail_inventory_optimization_analysis.products(category);