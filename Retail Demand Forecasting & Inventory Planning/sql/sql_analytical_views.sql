-- ============================================================
--  SUPPLY CHAIN PROJECT — POSTGRESQL VIEWS
--  Schema  : demand_forecasting_analytics
--  Database: supply_chain_project
-- ============================================================


-- ============================================================
--  VIEW 1: vw_supply_chain_operational
--  Purpose : Main transaction-level view used for all EDA,
--            inventory analysis, and as the forecasting base.
--            One row per product per store per day.
-- ============================================================

DROP VIEW IF EXISTS demand_forecasting_analytics.vw_supply_chain_operational CASCADE;

CREATE OR REPLACE VIEW demand_forecasting_analytics.vw_supply_chain_operational AS
SELECT
    -- ── Identifiers ──────────────────────────────────────────
    s.sales_id,
    s.date,
    EXTRACT(YEAR  FROM s.date)::INT   AS sales_year,
    EXTRACT(MONTH FROM s.date)::INT   AS sales_month,
    EXTRACT(WEEK  FROM s.date)::INT   AS sales_week,
    EXTRACT(DOW   FROM s.date)::INT   AS day_of_week,

    -- ── Store ────────────────────────────────────────────────
    s.store_id,
    st.store_name,
    st.location,

    -- ── Product ──────────────────────────────────────────────
    s.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    p.cost_price,
    p.shelf_life_days,

    -- ── Supplier (identity only — performance in own view) ───
    p.supplier_id,
    sup.supplier_name,

    -- ── Sales metrics ────────────────────────────────────────
    s.quantity_sold,
    s.revenue,
    ROUND((s.revenue - (s.quantity_sold * p.cost_price))::NUMERIC, 2) AS profit,

    -- ── Operational flags ────────────────────────────────────
    (CASE WHEN s.festive_period = 'Yes' THEN 1 ELSE 0 END)        AS festive_period,
    (CASE WHEN s.inflation_period = 'Yes' THEN 1 ELSE 0 END)      AS inflation_period,
    (CASE WHEN s.promotion_applied = 'Yes' THEN 1 ELSE 0 END)     AS promotion_applied,
    s.customer_demand_level,
    (CASE WHEN s.stockout_event = 'Yes' THEN 1 ELSE 0 END)		  AS stockout_event,

    CASE
        WHEN s.festive_period   = 'Yes' THEN 'Festive'
        WHEN s.inflation_period = 'Yes' THEN 'Inflation'
        ELSE 'Normal'
    END AS demand_regime,

    -- ── Inventory ────────────────────────────────────────────
    COALESCE(i.current_stock,    0)   AS current_stock,
    COALESCE(i.reorder_level,    0)   AS reorder_level,
    COALESCE(i.reorder_quantity, 0)   AS reorder_quantity,
    COALESCE(i.damaged_units,    0)   AS damaged_units,
    i.expiry_date,
    CASE
        WHEN i.expiry_date IS NOT NULL
        THEN GREATEST(0, (i.expiry_date - CURRENT_DATE)::INT)
        ELSE NULL
    END                               AS days_to_expiry,

    -- ── Supplier average delay (pre-aggregated — no per-row noise) ──
    COALESCE(sd_agg.avg_delay_days, 0) AS supplier_delay_days,

    -- ── Rolling 30-day demand metrics ────────────────────────
    ROUND(
        AVG(s.quantity_sold) OVER (
            PARTITION BY s.product_id, s.store_id
            ORDER BY s.date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        )::NUMERIC, 2
    ) AS avg_daily_demand_30d,

    ROUND(
        STDDEV(s.quantity_sold) OVER (
            PARTITION BY s.product_id, s.store_id
            ORDER BY s.date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        )::NUMERIC, 2
    ) AS demand_volatility_30d

FROM sales s
JOIN stores     st  ON s.store_id   = st.store_id
JOIN products   p   ON s.product_id = p.product_id
LEFT JOIN suppliers sup
    ON p.supplier_id = sup.supplier_id
LEFT JOIN inventory i
    ON  s.product_id = i.product_id
    AND s.store_id   = i.store_id
-- Pre-aggregated supplier delay — accurate average across all deliveries
LEFT JOIN (
    SELECT
        supplier_id,
        ROUND(AVG(supplier_delay_days)::NUMERIC, 2) AS avg_delay_days
    FROM supplier_deliveries
    GROUP BY supplier_id
) sd_agg
    ON p.supplier_id = sd_agg.supplier_id;


-- ============================================================
--  VIEW 2: vw_supplier_performance
--  Purpose : Supplier-level scorecard aggregated from all
--            delivery records. Used for supplier analysis
--            section in Python and for Power BI reporting.
--            One row per supplier.
-- ============================================================

DROP VIEW IF EXISTS demand_forecasting_analytics.vw_supplier_performance CASCADE;

CREATE OR REPLACE VIEW demand_forecasting_analytics.vw_supplier_performance AS
SELECT
    sup.supplier_id,
    sup.supplier_name,
    sup.location                                              AS supplier_location,
    COUNT(sd.delivery_id)                                     AS total_deliveries,
    ROUND(AVG(sd.supplier_delay_days)::NUMERIC,  2)          AS avg_delay_days,
    MAX(sd.supplier_delay_days)                               AS max_delay_days,
    MIN(sd.supplier_delay_days)                               AS min_delay_days,
    ROUND(
        SUM(CASE WHEN sd.supplier_reliability_status = 'On Time'
                 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(sd.delivery_id), 0) * 100, 1
    )                                                         AS on_time_pct,
    ROUND(
        SUM(CASE WHEN sd.supplier_reliability_status = 'Delayed'
                 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(sd.delivery_id), 0) * 100, 1
    )                                                         AS delayed_pct,
    -- Reliability rating based on on-time percentage
    CASE
        WHEN ROUND(
            SUM(CASE WHEN sd.supplier_reliability_status = 'On Time'
                     THEN 1 ELSE 0 END)::NUMERIC
            / NULLIF(COUNT(sd.delivery_id), 0) * 100, 1
        ) >= 70 THEN 'Reliable'
        WHEN ROUND(
            SUM(CASE WHEN sd.supplier_reliability_status = 'On Time'
                     THEN 1 ELSE 0 END)::NUMERIC
            / NULLIF(COUNT(sd.delivery_id), 0) * 100, 1
        ) >= 50 THEN 'Moderate'
        ELSE 'Unreliable'
    END                                                       AS reliability_rating
FROM suppliers sup
LEFT JOIN supplier_deliveries sd
    ON sup.supplier_id = sd.supplier_id
GROUP BY
    sup.supplier_id,
    sup.supplier_name,
    sup.location
ORDER BY avg_delay_days DESC;


-- ============================================================
--  VIEW 3: vw_inventory_risk_summary
--  Purpose : Product and store level inventory health summary.
--            Shows current stock, reorder status, days of cover,
--            and stockout rate. Used for inventory risk analysis
--            and Power BI inventory dashboard page.
--            One row per product per store.
-- ============================================================

DROP VIEW IF EXISTS demand_forecasting_analytics.vw_inventory_risk_summary CASCADE;

CREATE OR REPLACE VIEW demand_forecasting_analytics.vw_inventory_risk_summary AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.shelf_life_days,
    st.store_id,
    st.store_name,
    sup.supplier_name,

    -- Inventory position
    COALESCE(i.current_stock,    0)                           AS current_stock,
    COALESCE(i.reorder_level,    0)                           AS reorder_level,
    COALESCE(i.reorder_quantity, 0)                           AS reorder_quantity,
    COALESCE(i.damaged_units,    0)                           AS damaged_units,

    -- Demand metrics from sales history
    ROUND(AVG(s.quantity_sold)::NUMERIC, 2)                   AS avg_daily_demand,
    ROUND(STDDEV(s.quantity_sold)::NUMERIC, 2)                AS std_daily_demand,

    -- Days of cover = current stock / average daily demand
    ROUND(
        COALESCE(i.current_stock, 0)::NUMERIC
        / NULLIF(AVG(s.quantity_sold), 0), 1
    )                                                         AS days_of_cover,

    -- Stockout metrics
    ROUND(SUM(CASE WHEN s.stockout_event = 'Yes' THEN 1 END)::NUMERIC / COUNT(*) * 100, 1)   AS stockout_rate_pct,
    SUM(CASE WHEN s.stockout_event = 'Yes' THEN 1 END)                                       AS total_stockout_days,

    -- Inventory status flag
    CASE
        WHEN COALESCE(i.current_stock, 0) < COALESCE(i.reorder_level, 0)
            THEN 'Below Reorder Level'
        WHEN COALESCE(i.current_stock, 0) > COALESCE(i.reorder_quantity, 0) * 2
            THEN 'Overstock'
        ELSE 'OK'
    END                                                       AS stock_status,

    -- Risk level based on days of cover
    CASE
        WHEN ROUND(
            COALESCE(i.current_stock, 0)::NUMERIC
            / NULLIF(AVG(s.quantity_sold), 0), 1
        ) < 7  THEN 'CRITICAL'
        WHEN ROUND(
            COALESCE(i.current_stock, 0)::NUMERIC
            / NULLIF(AVG(s.quantity_sold), 0), 1
        ) < 14 THEN 'HIGH'
        ELSE 'OK'
    END                                                       AS risk_level

FROM sales s
JOIN products  p   ON s.product_id = p.product_id
JOIN stores    st  ON s.store_id   = st.store_id
LEFT JOIN suppliers sup ON p.supplier_id = sup.supplier_id
LEFT JOIN inventory i
    ON  s.product_id = i.product_id
    AND s.store_id   = i.store_id
GROUP BY
    p.product_id, p.product_name, p.category, p.shelf_life_days,
    st.store_id, st.store_name,
    sup.supplier_name,
    i.current_stock, i.reorder_level,
    i.reorder_quantity, i.damaged_units
ORDER BY
    stockout_rate_pct DESC,
    days_of_cover ASC;


-- ============================================================
--  VIEW 4: vw_demand_forecast_input
--  Purpose : Weekly aggregated demand series per product and
--            category. Pre-processed and ready to be pulled
--            directly into Prophet, ARIMA, or ETS without any
--            additional Python aggregation needed.
--            One row per product per week.
-- ============================================================

DROP VIEW IF EXISTS demand_forecasting_analytics.vw_demand_forecast_input CASCADE;

CREATE OR REPLACE VIEW demand_forecasting_analytics.vw_demand_forecast_input AS
SELECT
    DATE_TRUNC('week', s.date)::DATE  AS week_start,
    p.product_id,
    p.product_name,
    p.category,

    -- Weekly demand totals
    SUM(s.quantity_sold)              AS weekly_units_sold,
    SUM(s.revenue)                    AS weekly_revenue,
    SUM(CASE WHEN s.stockout_event = 'Yes' THEN 1 END)        AS stockout_events,

    -- Demand context flags for the week
    MAX(CASE WHEN s.festive_period = 'Yes' THEN 1 ELSE 0 END)        AS festive_week,
    MAX(CASE WHEN s.inflation_period = 'Yes' THEN 1 ELSE 0 END)      AS inflation_week,
    MAX(CASE WHEN s.promotion_applied = 'Yes' THEN 1 ELSE 0 END)     AS promotion_week,

    -- Category weekly total (useful for category-level forecasting)
    SUM(SUM(s.quantity_sold)) OVER (
        PARTITION BY DATE_TRUNC('week', s.date), p.category
    )                                 AS category_weekly_units

FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY
    DATE_TRUNC('week', s.date),
    p.product_id,
    p.product_name,
    p.category
ORDER BY
    p.product_name,
    week_start;

SELECT * FROM vw_inventory_risk_summary virs; 
SELECT * FROM vw_demand_forecast_input; 
SELECT * FROM vw_supplier_performance; 
SELECT * FROM vw_supply_chain_operational; 