# FoodMart Retail Chain: Demand Forecasting and Inventory Planning

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-Database%20Analysis-0F2D57?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Python-Forecasting%20%26%20Planning-E8622A?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Prophet%20%7C%20ARIMA%20%7C%20ETS-Demand%20Models-16A34A?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Status-Complete-16A34A?style=for-the-badge"/>
</p>

<br>

> **Can a supermarket predict what it needs before it runs out?**
>
> FoodMart runs seven branches across Ibadan, Nigeria. Over 18 months their products ran out of stock 19,262 times. 86% of supplier deliveries arrived late. And replenishment decisions were being made without a structured forecast to guide them.
>
> This project works through that problem from the ground up, starting from a raw PostgreSQL database and ending with a product by product replenishment action plan backed by three demand forecasting models.

<br>

## Executive Summary

FoodMart experienced 19,262 stockouts across seven stores over 18 months. Analysis revealed that stockout rates were nearly identical across all product categories, pointing to a network wide replenishment issue rather than individual product demand problems. After evaluating supplier reliability, forecasting demand with Prophet, ARIMA, and ETS models, and incorporating real supplier delays into inventory calculations, the project produced actionable reorder points, safety stock recommendations, inventory gap analysis, and transfer opportunities between stores. The result is a replenishment plan backed by data that any store manager can act on immediately.

<br>

## Key Numbers at a Glance

| Metric | Value |
|:--|:--|
| Total units sold | 1,508,751 across 18 months |
| Total stockout events | 19,262 across all stores and products |
| Products that never stocked out | 0 out of 20 |
| Average stockout rate | 25.1% across all categories |
| Supplier deliveries that arrived late | 86.1% |
| Average supplier delay | 4 days |
| Demand increase during festive periods | 46% above normal |
| Demand drop during inflation periods | 15% to 20% |
| Best forecast model | Prophet (lowest MAPE in 6 of 7 categories) |
| Class A products by revenue | 6 out of 20 products drive 70% of revenue |

<br>

## Project Workflow

```mermaid
flowchart TD
    A[🗄️ Raw CSV Data\n6 tables · 76,580 rows] --> B[PostgreSQL\nSchema · Loading · Cleaning]
    B --> C[SQL Analytical Views\n4 pre-aggregated views]
    C --> D[24 Business Questions\nDemand · Inventory · Suppliers · Trends]
    D --> E[Python via SQLAlchemy]
    E --> F[Exploratory Data Analysis\nTrends · Correlations · Seasonality]
    F --> G[ABC/XYZ Classification\nProduct Prioritisation]
    G --> H[Demand Forecasting\nProphet · ARIMA · ETS]
    H --> I[Inventory Planning\nSafety Stock · EOQ · Reorder Points]
    I --> J[✅ Replenishment Action Plan]
    I --> K[✅ Cross Store Transfer Opportunities]
    I --> L[✅ Inventory Gap Analysis]

    style A fill:#0F2D57,color:#fff
    style J fill:#16A34A,color:#fff
    style K fill:#16A34A,color:#fff
    style L fill:#16A34A,color:#fff
    style H fill:#E8622A,color:#fff
```

<br>

## The Data

Six CSV files covering seven branches, 20 products, seven suppliers, and 18 months of daily transactions. The dataset was built to behave like real retail data, complete with stockouts, late deliveries, demand drops from inflation, and festive season spikes. Clean, smooth data would have produced analysis that looks tidy but teaches nothing.

```
stores.csv               7 branches across Ibadan
products.csv             20 products across 7 categories with price, cost, and shelf life
suppliers.csv            7 suppliers with delivery history
sales.csv                76,580 daily transaction records
inventory.csv            Stock snapshots for 140 product and store combinations
supplier_deliveries.csv  1,000 delivery records with expected and actual dates
```

**Categories:** Food · Beverages · Bakery · Dairy · Frozen Foods · Household · Snacks

<br>

## Part 1: SQL Business Analysis

All business questions were answered in PostgreSQL before any Python work started. Understanding what the data says comes before building models on top of it.

📄 **[Read the full SQL analysis — 24 queries with findings and recommendations](./analysis.md)**

<br>

### Sales and Demand

**What was done:** Analysed 18 months of daily sales across all seven stores to find which products lead volume, which categories are most volatile, and how seasonal events shift buying behaviour.

**What was found:** Bread, Indomie Noodles, and Rice each exceeded 140,000 units sold. Food has the highest demand variability at 59% coefficient of variation. Festive periods in April and December push average daily sales from 24 units to nearly 36, a consistent 46% uplift that repeated across both years. Promotions added 3 to 4 units per day across every category.

**Why it matters:** A small group of products is carrying most of the volume. Losing stock on any of them during a festive window has an immediate revenue impact. Replenishment cycles need to shorten ahead of April and December, and forecasts must account for the seasonal uplift rather than relying on flat annual averages.

<br>

### Stockouts and Inventory Risk

**What was done:** Measured how often each product ran out of stock and whether the pattern pointed to a demand problem or a planning problem.

**What was found:** All 20 products experienced stockouts. The stockout rate barely moves between categories. Bakery sits at 24.8%, Frozen Foods at 25.3%, Dairy at 25.1%. When every category lands at roughly the same rate despite having different products, different shelf lives, and different demand behaviour, the cause is not the products. The replenishment process itself is broken.

**Why it matters:** A structural planning failure cannot be fixed product by product. Reorder points and safety stock need to be rebuilt from actual demand variability and real supplier lead times, not assumed values.

<br>

### Supplier Performance

**What was done:** Calculated delivery punctuality rates and average delay per supplier using the actual expected versus arrival dates in the delivery records.

**What was found:** 86.1% of deliveries arrived late. Even the best supplier, Agodi Fresh Farms at 58.5% punctuality, misses nearly four in every ten delivery windows. Average delay across the network is 4 days.

| Supplier | Punctuality | Avg Delay |
|:--|:--|:--|
| Agodi Fresh Farms | 58.5% | 3.8 days |
| Lagos FMCG Distributors | 57.9% | 4.0 days |
| Peak Consumer Goods | 57.3% | 3.8 days |
| FreshBake Foods Ltd | 55.7% | 3.9 days |
| Golden Beverage Hub | 55.9% | 4.2 days |
| Ibadan Daily Essentials | 51.1% | 4.3 days |
| Naija Frozen Supplies | 51.0% | 4.2 days |

**Why it matters:** Any safety stock formula built on the assumption that deliveries arrive on time is wrong 86% of the time. That error compounds directly into stockouts. Buffers must reflect what suppliers actually do, not what they promise.

<br>

### Expiry and Waste Risk

**What was done:** Identified products at highest risk of expiring before being sold, based on shelf life, demand rate, and demand period.

**What was found:** Four products have shelf lives under 15 days. Bread expires in 7 days and is simultaneously the highest selling product in the range, highest volume and least room for error. During inflation periods when demand falls 15% to 20%, the expiry risk for perishables rises sharply.

**Why it matters:** Over ordering short shelf life products during low demand periods creates direct losses. Bread ordered based on festive demand assumptions during an inflation window will expire before it sells.

<br>

### Demand Trends

**What was done:** Looked for consistent calendar patterns and sustained growth trends that could improve forecast accuracy.

**What was found:** Day of week has almost no effect on demand. Month of year matters significantly. April and December spike every year. Inflation periods pull demand down 15% to 20% in a consistent and repeatable pattern. Four products, Ice Cream, Detergent, Frozen Chicken, and Coca Cola, each grew more than 85% across the dataset.

**Why it matters:** Products growing at 85% over 18 months will be chronically short if forecasts use historical averages. That growth must be captured in the model. The seasonal and inflation patterns are predictable enough to treat as known inputs to any planning cycle.

<br>

## Part 2: Python Analysis, Forecasting and Inventory Planning

Data was pulled from PostgreSQL into Python via SQLAlchemy. The notebook runs from exploratory analysis through to a complete replenishment plan covering all seven stores.

📓 **[Open the full notebook](./demand_forecasting.ipynb)**

<br>

### Exploratory Data Analysis

The EDA extended the SQL findings into things SQL alone cannot visualise: rolling demand averages, full seasonal decomposition across all seven categories, promotion uplift measurement, and supplier reliability scoring from delivery records.

Food, Beverages, and Bakery show the most stable and predictable seasonal patterns. Dairy, Frozen Foods, and Snacks carry larger irregular components, which means their forecasts hold more uncertainty.

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/01_daily_demand_trend.png" width="85%" alt="Monthly Demand Trend"/>
  <br><em>Total daily units sold across all 7 stores, Jan 2024 to Jun 2025</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/02_demand_timing.png" width="85%" alt="Weekly and Monthly Patterns"/>
  <br><em>Demand by day of week and by month. The festive months stand out clearly.</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/04_demand_by_regime.png" width="85%" alt="Seasonal Demand Behaviour"/>
  <br><em>Average daily units sold across festive, normal, and inflation periods by category</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/05_stockout_analysis.png" width="85%" alt="Stockout Rate Analysis"/>
  <br><em>Stockout rate per product and per store. Near identical rates across all categories point to a planning problem, not a product problem.</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/07_supplier_performance.png" width="85%" alt="Supplier Performance"/>
  <br><em>Delivery punctuality and average delay per supplier</em>
</p>

<p align="center">
  <img src="./images/rolling_demand.png" width="85%" alt="Rolling Demand"/>
  <br><em>30 day rolling average demand by category. Seasonal shape becomes visible once smoothed.</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/08_promotion_effect.png" width="85%" alt="Promotion Impact"/>
  <br><em>Sales with and without promotions across all categories. Uplift is consistent.</em>
</p>

<br>

### ABC/XYZ Product Classification

Every product was classified across two dimensions before any forecasting began.

**ABC** ranks products by revenue contribution. Six products account for 70% of total revenue. Those six deserve the most planning attention.

**XYZ** ranks products by demand predictability. X products are stable and foreseeable. Z products are volatile. The combined code shapes each product's safety stock level and forecasting approach.

**AX:** High revenue and stable demand. Prioritise stock availability.
**AZ:** High revenue but volatile demand. Needs larger safety buffers.
**CZ:** Low revenue and unpredictable demand. Monitor but deprioritise.

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/09_abc_xyz_classification.png" width="85%" alt="ABC/XYZ Matrix"/>
  <br><em>ABC/XYZ segmentation matrix showing where each product sits and what that means for planning</em>
</p>

> **Note on thresholds:** All products in this dataset have coefficient of variation values in a narrow range (0.52 to 0.57) because the data is simulated. Standard XYZ thresholds would have placed every product in the same class. Percentile based thresholds were applied instead to produce a meaningful split. Full reasoning is in the notebook.

<br>

### Demand Forecasting

Three models were tested across all seven categories. Training used the first 14 months. The final 4 months were held back for testing. A 12 week forward forecast was then generated per model and accuracy was measured using MAPE.

| Model | Approach |
|:--|:--|
| Exponential Smoothing (ETS) | Weights recent demand more heavily in the forecast |
| ARIMA (2,1,2) | Captures trends and autocorrelation in the demand series |
| Prophet | Explicitly models seasonality, holidays, and trend changes |

Prophet produced the lowest MAPE in 6 of the 7 categories. ARIMA was competitive on Bakery and Snacks. ETS consistently produced the highest errors across all categories. That comparison matters because choosing Prophet by default without testing would miss the cases where ARIMA performs better.

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/10_seasonal_decomposition.png" width="85%" alt="Forecast Diagnostics"/>
  <br><em>Seasonal decomposition and autocorrelation checks per category before model selection</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/12_category_forecasts.png" width="85%" alt="Category Level Forecasts"/>
  <br><em>12 week forward forecast per category showing historical and projected demand</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/13_model_accuracy.png" width="85%" alt="Model Accuracy Comparison"/>
  <br><em>MAPE comparison across all three models per category. Lower is better.</em>
</p>

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/14_product_forecasts.png" width="85%" alt="Product Level Forecasts"/>
  <br><em>Product level forecasts for the five highest stockout risk products</em>
</p>

<br>

### Inventory Planning

**Supplier Adjusted Safety Stock**

Two safety stock values were calculated per product. The standard version uses demand variability with a fixed assumed lead time. The supplier adjusted version uses each supplier's actual recorded average delay from the delivery data. Products from Naija Frozen Supplies carry a larger buffer than products from Agodi Fresh Farms because the delivery history justifies it. If safety stock assumes punctual delivery and the supplier is late 86% of the time, that safety stock will fail every time.

<p align="center">
  <img src="./images/safety_stock_comparison.png" width="85%" alt="Safety Stock Comparison"/>
  <br><em>Standard vs supplier adjusted safety stock per product. The gap shows the cost of using assumed lead times.</em>
</p>

**Reorder Point and EOQ**

Reorder point equals average demand during lead time plus safety stock. Economic Order Quantity was calculated to find the order size that balances purchasing cost against holding cost. For products with shelf lives under 14 days, EOQ was capped at 14 days of demand to prevent over ordering perishables.

**Replenishment Action Plan**

Every product across every store received a risk classification based on days of stock remaining.

| Risk Level | Days of Stock Left | Action |
|:--|:--|:--|
| 🔴 CRITICAL | Under 7 days | Order today |
| 🟡 HIGH | 7 to 14 days | Order this week |
| 🟢 OK | Normal range | Follow regular schedule |
| 🟣 OVERSTOCK | Over 2.5x reorder point | Hold new orders, check transfers first |

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/16_reorder_urgency.png" width="85%" alt="Replenishment Plan"/>
  <br><em>Products ranked by reorder urgency with suggested order quantities per store</em>
</p>

**Inventory Gap Analysis**

Current stock was compared against the 30 day demand forecast per product. A negative gap means a shortage is arriving before the next delivery. A positive gap means surplus stock that could be transferred rather than reordered.

<p align="center">
  <img src="https://github.com/jimi121/jimi121-Supply-Chain-Analytics-Projects/blob/main/Retail%20Demand%20Forecasting%20%26%20Inventory%20Planning/images/forecast_vs_inventory_gap.png" width="85%" alt="Inventory Gap Analysis"/>
  <br><em>Inventory gap per product. Negative values flag incoming shortages against forecasted demand.</em>
</p>

**Cross Store Transfers**

Where one branch holds surplus stock and another is running low on the same product, a transfer is faster and cheaper than placing a new supplier order, and it reduces waste at the sending store.

<p align="center">
  <img src="./images/cross_store_transfers.png" width="85%" alt="Cross Store Transfers"/>
  <br><em>Transfer opportunities across all seven branches showing which store sends, which receives, and quantities</em>
</p>

<br>

## Final Outputs

| Output | What It Gives You |
|:--|:--|
| Demand Forecasts | 12 week weekly forecast per category using the best performing model |
| ABC/XYZ Classification | Two dimension product segmentation to guide inventory prioritisation |
| Safety Stock | Supplier adjusted buffer per product based on real delivery delay data |
| Reorder Points | The stock level at which each product should trigger a new order |
| EOQ | Most cost efficient order quantity balancing purchasing and holding costs |
| Inventory Gap Analysis | Current stock vs 30 day forecasted demand per product |
| Cross Store Transfer Recommendations | Products and quantities to move between branches before reordering |
| Replenishment Action Plan | Every product ranked CRITICAL, HIGH, OK, or OVERSTOCK with a clear action |

<br>

## What I Learned Building This

The most important insight in this entire project came from a single SQL query, not from any forecasting model.

When every product category, Bakery, Dairy, Frozen Foods, Snacks, Beverages, lands at almost exactly the same stockout rate despite having completely different shelf lives, demand patterns, and suppliers, something structural is wrong. The problem is not with any individual product. It is in how replenishment decisions are being made. That observation only surfaces when you sit with the data before you build anything on top of it. A model would never have shown me that.

The safety stock calculation also took several iterations to get right. Using a fixed assumed lead time produced numbers that looked reasonable but were wrong for every product whose supplier consistently delivers late. Going back to the actual delivery records and computing real average delays per supplier changed the outputs significantly and made them defensible in a way assumed values never could be.

Comparing three models across seven categories meant 21 accuracy checks. Prophet won in 6 of 7 because it handles seasonal and holiday patterns directly. ARIMA was competitive on Bakery and Snacks, and knowing that matters when the output is an actual inventory plan, not a model comparison exercise.

<br>

## Project Files

| File | Contents |
|:--|:--|
| [`datasets/`](./datasets) | Six raw CSV files: stores, products, suppliers, sales, inventory, deliveries |
| [`sql/schema_creation.sql`](./sql/schema_creation.sql) | Table definitions, constraints, and indexes |
| [`sql/sql_data_loading.sql`](./sql/sql_data_loading.sql) | Scripts to load all six CSV files into PostgreSQL |
| [`sql/sql_analytical_views.sql`](./sql/sql_analytical_views.sql) | Four pre-aggregated views used by the Python notebook |
| [`sql/sql_business_questions.sql`](./sql/sql_business_questions.sql) | All 24 business analysis queries |
| [`analysis/foodmart_sql_analysis.md`](./analysis.md) | Full SQL analysis with findings and recommendations per section |
| [`forecasting/demand_forecasting.ipynb`](./demand_forecasting.ipynb) | Complete Python notebook from EDA to inventory planning |
| [`presentation/foodmart_supply_chain.pdf`](./presentation/foodmart_supply_chain.pptx) | Presentation deck summarising findings and recommendations |

<br>

## Repository Structure

```
foodmart-demand-forecasting/
│
├── datasets/
│   ├── stores.csv
│   ├── products.csv
│   ├── suppliers.csv
│   ├── sales.csv
│   ├── inventory.csv
│   └── supplier_deliveries.csv
│
├── sql/
│   ├── sql_schema_creation.sql
│   ├── sql_data_loading.sql
│   ├── sql_analytical_views.sql
│   └── sql_business_questions.sql
│
├── images/
│   └── notebook charts
│
├── presentation/
│   ├── foodmart_supply_chain.pdf
│   ├── foodmart_supply_chain.pptx
│
├── analysis.md
│   └── foodmart_sql_analysis.md
├── forecasting.ipynb
│   └── demand_forecasting.ipynb
└── README.md
```

<br>

## How to Run This Project

**Step 1: Set up PostgreSQL**

Run the SQL files in this order. Update the file paths in `sql_data_loading.sql` to match where you saved the `datasets/` folder.

```sql
\i schema_creation.sql
\i sql_data_loading.sql
\i sql_analytical_views.sql
\i sql_business_questions.sql
```

**Step 2: Install Python dependencies**

```bash
pip install pandas numpy matplotlib seaborn statsmodels prophet scikit-learn sqlalchemy psycopg2-binary openpyxl
```

**Step 3: Connect the notebook**

Open `demand_forecasting.ipynb` and update the connection string with your PostgreSQL credentials.

```python
engine = create_engine(
    "postgresql+psycopg2://your_username:your_password@localhost:5432/supply_chain_project"
)
```

Run all cells from top to bottom. Charts generate inline and planning outputs export to CSV automatically.

> To show charts in this README, add `plt.savefig("../images/chart_name.png", dpi=150, bbox_inches="tight")` before each `plt.show()` in the notebook, then push the `images/` folder to GitHub.

<br>

## Tools Used

| Tool | Purpose |
|:--|:--|
| PostgreSQL | Database design, business analysis, and analytical views |
| Python 3 | EDA, forecasting, and inventory planning |
| pandas | Data manipulation and aggregation |
| numpy | Safety stock, EOQ, and reorder point calculations |
| matplotlib and seaborn | All charts and visualisations |
| statsmodels | Exponential Smoothing and ARIMA models |
| Prophet | Seasonal demand forecasting |
| scikit-learn | MAPE and MAE accuracy measurement |
| SQLAlchemy | Connecting Python to PostgreSQL |
| Jupyter Notebook | Analysis environment |
| PowerPoint | Project presentation deck |

<br>

## About This Project

This is a personal portfolio project. The data is simulated and FoodMart is a fictional supermarket chain. The problems it represents are not fictional.

Empty shelves, expiring stock, suppliers who never arrive on time, and replenishment decisions made without data. These things are happening in real retail businesses right now. This project shows what changes when you actually use the data to make those decisions.

<br>

<p align="center">
  <strong>Olajimi Adeleke</strong><br>
  Data Analyst<br><br>
  <a href="https://www.linkedin.com/in/olajimi-adeleke">LinkedIn</a>
  &nbsp;&nbsp;
  <a href="https://github.com/Jimi121">GitHub</a>
</p>
