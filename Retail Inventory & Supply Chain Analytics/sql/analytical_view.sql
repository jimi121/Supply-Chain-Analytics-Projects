-----------------------------Create View As inventory_supply_chain_analysis-----------------------------------
-- =============================================================
-- INVENTORY & SUPPLY CHAIN ANALYSIS VIEW (with Expiry Status)
-- =============================================================

DROP VIEW IF EXISTS retail_inventory_optimization_analysis.inventory_supply_chain_analysis;

CREATE VIEW retail_inventory_optimization_analysis.inventory_supply_chain_analysis AS
SELECT 
    t.transaction_id,
    t.date,
    s.store_name,
    s.city,
    p.product_name,
    p.category,
    
    -- Supplier Information
    sup.supplier_name,
    sup.average_lead_time_days,
    
    -- Sales & Stock Metrics
    t.quantity_sold,
    t.current_stock,
    t.warehouse_stock,
    t.reorder_level,
    t.restock_quantity,
    
    -- Performance Indicators
    t.lead_time_days,
    t.damaged_units,
    t.stockout,
    
    -- Demand & Promotion
    t.promotion,
    t.customer_demand,
    
    -- Expiry Information (NEW)
    t.expiry_date,
    CASE 
        WHEN t.expiry_date < t.date THEN 'Yes'
        ELSE 'No'
    END AS is_expired,
    
    CASE 
        WHEN t.expiry_date < t.date THEN 'Expired'
        WHEN t.expiry_date <= t.date + INTERVAL '30 days' THEN 'Expiring Soon'
        WHEN t.expiry_date <= t.date + INTERVAL '60 days' THEN 'Expiring in 2 Months'
        ELSE 'Valid'
    END AS expiry_status,
    
    (t.expiry_date - t.date) AS days_to_expiry,

    -- Financials
    t.revenue,
    t.profit,
    ROUND((t.profit / NULLIF(t.revenue, 0) * 100), 2) AS profit_margin_percentage,
    
    -- Stock Health
    CASE 
        WHEN t.current_stock < p.reorder_level THEN 'Critical'
        WHEN t.current_stock < p.reorder_level * 1.2 THEN 'Low'
        ELSE 'Healthy'
    END AS stock_status,

    -- Suggested Action
    CASE 
        WHEN t.expiry_date < t.date THEN 'REMOVE EXPIRED STOCK'
        WHEN t.stockout = 'Yes' OR t.current_stock < p.reorder_level THEN 'URGENT RESTOCK'
        WHEN t.damaged_units > 5 THEN 'Check Damages'
        WHEN t.expiry_date <= t.date + INTERVAL '30 days' THEN 'Sell Fast / Promote'
        ELSE 'Monitor'
    END AS recommended_action

FROM retail_inventory_optimization_analysis.transactions t
JOIN retail_inventory_optimization_analysis.products p 
    ON t.product_id = p.product_id
JOIN retail_inventory_optimization_analysis.suppliers sup 
    ON p.supplier_id = sup.supplier_id
JOIN retail_inventory_optimization_analysis.stores s 
    ON t.store_id = s.store_id;

-- Add comment
COMMENT ON VIEW retail_inventory_optimization_analysis.inventory_supply_chain_analysis 
IS 'Comprehensive inventory & supply chain view with expiry tracking';

------------------------------Check The View-------------------------------
SELECT * FROM retail_inventory_optimization_analysis.inventory_supply_chain_analysis;