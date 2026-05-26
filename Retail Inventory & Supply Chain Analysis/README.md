# Retail Inventory and Supply Chain Analytics

**Excel · PostgreSQL · Power BI · DAX · PowerPoint**

Made by Olajimi Adeleke

---

## The Story Behind This Project

I was thinking about a common problem in retail grocery stores. You walk in to buy something you need, and it is not on the shelf. Or the opposite happens where a product sits there too long and eventually gets thrown away before anyone buys it. Both situations cost the business money, and both can be reduced with better data.

That got me thinking. What if I could use data to spot these problems before they happen? Which products are about to run out? Which ones are being ordered too much? Are the suppliers delivering on time? Are promotions actually working or just running in the background without making any real difference?

I decided to build a project around those questions. I simulated a dataset that reflects how a multi-store retail grocery business like FoodCo operates, and I used it to run a full inventory and supply chain analysis.

The project combines SQL analysis in PostgreSQL with an interactive Power BI dashboard to turn raw inventory data into real business insights.

---

## What This Project Is About

The project looks at seven areas that matter in any retail supply chain operation. Each area was treated as a real business problem with its own questions, findings, and recommendations.

**Sales and Profitability**
Which products and categories are bringing in the most revenue and profit, and how the five stores compare to each other in terms of financial performance.

**Inventory Health**
How much stock is available across the stores right now, which products are running dangerously low, and how many days of coverage remain before shelves go empty.

**Stockout Risk**
Which products go out of stock the most frequently, which stores are struggling the most with availability, and whether the shortages are happening because of high customer demand or because of how restocking is being managed.

**Expiry and Inventory Waste**
Which perishable products are expiring before they get sold, which categories carry the most expiry risk, and what can be done to reduce the losses.

**Supplier Performance**
How long each supplier takes to deliver, which ones are sending goods that arrive damaged, and which supplier and product combinations are causing the most operational problems.

**Replenishment Efficiency**
Whether products are being restocked in the right quantities relative to how much is actually being sold, and where over-ordering is creating unnecessary cost and waste.

**Promotion Effectiveness**
Whether running promotions is actually driving more sales or whether the revenue difference between promotional and non-promotional periods is too small to justify the effort.

---

## Dataset

The dataset was built specifically for this project to simulate realistic retail inventory conditions across a multi-store grocery business. It is not real company data.

The simulation was designed to reflect the kinds of challenges that actually show up in retail operations, things like demand and supply mismatches, perishable product mismanagement, over-ordering, and supplier inconsistency. The goal was to make the analysis meaningful rather than working with perfectly clean, unrealistic numbers.

The project uses four main tables.

| Table | Description |
|-------|-------------|
| `products` | Product names, categories, and pricing information |
| `stores` | The five store locations and their details |
| `suppliers` | Supplier names, lead times, and operational data |
| `inventory_supply_chain_analysis` | The main table covering inventory levels, sales, replenishment quantities, expiry dates, damage records, and stockout flags |

Rather than loading all four tables separately into Power BI, a SQL analytical view was created in PostgreSQL to join and prepare everything into one clean reporting dataset. This kept the Power BI model simple and made the DAX measures easier to manage.

---

## Data Modeling Approach

The workflow followed a clear step by step process from raw data to final dashboard.

```
Raw CSV Files  →  PostgreSQL (Schema + Data Loading + Cleaning)  →  SQL Analytical View  →  Power BI  →  DAX Measures + Calendar Table  →  Dashboard
```

Building the business logic in SQL before touching Power BI meant that all the data preparation and joining happened in one place. The Power BI model only needed to focus on visualization and KPI calculations, which made the whole process cleaner and easier to follow.

---

## SQL Business Analysis

The SQL analysis covers seven business areas. Each section was approached as a standalone business problem with specific questions to answer.

---

### 1. Sales and Profitability

**What I was trying to find out**

Which products are generating the most revenue and profit, which categories are leading the business, and whether all five stores are performing at a similar level.

**What the data showed**

Bread leads with the highest revenue across all stores, followed by Coca-Cola, Meat Pie, and Maltina Can. Beverages and Bakery are the top two categories by both revenue and profit. Store performance is relatively balanced, although FoodCo Akobo and FoodCo Mokola edge slightly ahead of the others.

**What this means for the business**

A small group of fast-moving products is carrying a large share of the business performance. That means if any of those products go out of stock, the impact on revenue will be immediate. The business needs to treat these products as a priority and make sure they are always available on the shelf.

**Recommendations**

Fast-moving products like Bread, Coca-Cola, and Meat Pie should receive closer inventory monitoring and faster replenishment cycles. High-performing categories like Beverages and Bakery deserve more inventory investment. Operational practices from the stronger stores can also be studied and applied to locations that are slightly behind.

---

### 2. Inventory Health

**What I was trying to find out**

What the current stock condition looks like across all products and stores, and how much time is left before critical products run out completely.

**What the data showed**

Out of all the stock records reviewed, 458 are at critical levels, 384 are at low stock, and only 37 are actually healthy. That means the vast majority of the inventory is in a vulnerable state. Several fast-moving products like Bread and Coca-Cola have only between 1.6 and 4 days of stock coverage remaining.

**What this means for the business**

When almost everything is running low at the same time, the business has very little room to absorb any delay from a supplier or an unexpected spike in demand. Products with only a few days of coverage are one disruption away from going out of stock completely.

**Recommendations**

Inventory monitoring needs to become more proactive rather than reactive. Reorder levels should be reviewed regularly based on how fast each product actually sells. Safety stock for high-demand products should be higher to create a buffer against delays.

---

### 3. Stockout Risk

**What I was trying to find out**

Which products and stores are experiencing the most stockouts, and whether the problem is coming from customer demand or from how replenishment is being planned.

**What the data showed**

Biscuits recorded a 100 percent stockout rate, meaning it was out of stock every single time it was checked. Butter and Frozen Fish were not far behind. Bakery, Dairy, and Frozen Food products experienced the most frequent stockouts overall. FoodCo Jericho and FoodCo Akobo had the highest stockout rates among the five stores at 40.8 percent and 40.4 percent. Stockouts were also happening during periods of low customer demand, which was an important finding.

**What this means for the business**

If stockouts were only happening during high demand periods, the fix would be to order more during busy times. But since they are happening even when demand is low, the problem is in the replenishment planning itself. Products are not being reordered at the right time or in the right quantities, and that is creating gaps that should not exist.

**Recommendations**

Replenishment timing and order quantities need to be reviewed, especially for Bakery, Dairy, and Frozen Food products. Stores with consistently high stockout rates like Jericho and Akobo need closer attention. The goal should be to reorder earlier and in quantities that better reflect actual sales patterns.

---

### 4. Expiry and Inventory Waste

**What I was trying to find out**

How much inventory is expiring before it gets sold, which products and categories are most at risk, and whether over-ordering is making the problem worse.

**What the data showed**

154 products are already expired and 301 more are expiring within the next 30 days. Dairy and Frozen Foods carry the highest expiry exposure, with products like Butter, Cheese, Yoghurt, Frozen Fish, and Ice Cream appearing most frequently in the at-risk list. The same products that are expiring are also some of the most over-ordered products in the dataset.

**What this means for the business**

Over-ordering perishable products and then watching them expire is one of the most avoidable losses a retail business can have. The data suggests that replenishment quantities for Dairy and Frozen Food products are not being tied closely enough to actual sales rates, which means stock is piling up faster than it can be sold.

**Recommendations**

Replenishment quantities for perishable products should be reviewed regularly and matched to how fast those products actually move. Stock rotation practices need to be tightened so older stock gets sold before newer deliveries pile on top of it. Near-expiry products should be supported with targeted discounts or promotions before they cross the expiry date and become a complete loss.

---

### 5. Supplier Performance

**What I was trying to find out**

How suppliers compare in terms of delivery speed and product quality, and which supplier and product combinations are causing the most operational problems.

**What the data showed**

CoolFresh Logistics has the longest average lead time at 6 days, while FreshBake Suppliers and CoolFresh Logistics both recorded the highest rates of damaged goods on arrival. Products like Meat Pie, Frozen Fish, and Ice Cream are most frequently affected by damage during transit.

**What this means for the business**

The problem with suppliers is not so much about how long they take on average, since most lead times are within a reasonable range. The bigger concern is damage rates, especially for frozen and perishable products. Products arriving damaged are not just a financial loss on that delivery. They also create unexpected stock gaps that can quickly turn into stockouts.

**Recommendations**

Damaged inventory should be tracked more consistently and fed back to suppliers as part of regular performance conversations. For fragile and perishable products, packaging and transportation handling standards should be discussed with the relevant suppliers. Supplier performance should be reviewed periodically using concrete data rather than general impressions.

---

### 6. Replenishment Efficiency

**What I was trying to find out**

Whether products are being restocked in quantities that match actual sales demand, or whether some products are being massively over-ordered.

**What the data showed**

Several products have restock to sales ratios well above 2, meaning they are being ordered at more than double the rate they are being sold. Butter has a ratio of 5.5, Biscuits at 3.9, Cheese at 3.2, and Frozen Fish at 3.1. The Dairy and Frozen Foods categories show the worst overall replenishment imbalance.

**What this means for the business**

Over-ordering creates a chain of problems. It fills up storage space, increases the risk of expiry, ties up money in stock that is not moving, and makes it harder to spot which products genuinely need more attention. Restocking should be driven by sales data, not habit or assumption.

**Recommendations**

Replenishment quantities should be reviewed against recent sales performance on a rolling basis. Products with consistently high restock to sales ratios should have their order quantities reduced and monitored more closely. Demand forecasting should become a regular part of the replenishment process rather than an afterthought.

---

### 7. Promotion Effectiveness

**What I was trying to find out**

Whether the promotions being run are actually generating more sales, or whether the business is spending on promotions without seeing a meaningful return.

**What the data showed**

The revenue difference between promotional and non-promotional periods is small across most categories. Dairy and Frozen Foods responded slightly better to promotions compared to the others, but the overall lift was not significant. Stockouts were also still happening during low-demand periods, which reinforced the finding from the replenishment analysis that inventory problems are largely planning related.

**What this means for the business**

Running promotions that do not move the needle is a cost without a clear benefit. If certain categories respond better than others, it makes sense to concentrate promotional effort there rather than spreading it evenly across everything.

**Recommendations**

Promotional strategies should be more targeted and focused on categories that show a measurable response. Alternative formats like bundle deals, limited time discounts, or seasonal campaigns could be tested to see if they perform better than the current approach. Inventory planning should also be coordinated with any promotional activity to make sure the products being promoted are actually available in stock when customers come looking for them.

---

## Power BI Dashboard

After completing the SQL analysis, a four page Power BI dashboard was built to present the findings in a way that is easy to understand and act on. The goal was not to show as many charts as possible but to make sure each page answered a clear business question.

The dashboard follows a logical flow from overall performance, to inventory risks, to supplier operations, to profitability.

---

### Page 1 — Executive Overview

This page gives a high level picture of how the business is performing across all five stores. It covers total revenue, profit, profit margin, stockout rate, and the percentage of products currently classified as at risk.

The store performance comparison shows that FoodCo Mokola leads on revenue at 11.25 million naira while FoodCo Akobo leads on profit at 3 million naira. Beverages is the top revenue category at 14.4 million naira, followed by Bakery at 11.8 million naira.

This page is designed for someone who wants a quick snapshot of the business before diving into the details.

![Executive Overview](images/overview_dashboard.png)

---

### Page 2 — Inventory Health and Operational Risk

This page goes deeper into the stock condition across the business. It shows how many products are at critical, low, or healthy stock levels by category, which stores have the highest stockout rates, which products need immediate restocking, and how expiry risk is distributed across categories.

The inventory action monitoring table at the bottom of the page flags each product with a recommendation: OK, LOW STOCK, or REORDER. This makes it easy for an operations team to see exactly where attention is needed without having to interpret charts.

This page is designed to drive daily or weekly restocking decisions.

![Inventory Dashboard](images/inventory_dashboard.png)

---

### Page 3 — Supplier and Replenishment Performance

This page brings together supplier delivery performance and replenishment efficiency in one view. It shows how each supplier compares on lead time and damage rates, which products have the highest restock to sales ratios, and how replenishment behavior differs across categories.

The replenishment performance summary table gives a side by side view of average restock quantity versus average quantity sold for each category, making the over-ordering problem immediately visible.

This page is designed to help procurement and supply chain teams have informed conversations with suppliers and make better ordering decisions.

![Supplier Dashboard](images/supplier_dashboard.png)

---

### Page 4 — Profitability and Promotion Analysis

This page connects product and category performance to the bottom line. It shows profit margins by category, the top revenue generating products, monthly profit trends across the year, and how promotional activity compares to non-promotional periods for each category.

Profit margins are relatively consistent across categories, ranging from 26.53 percent to 26.79 percent. The monthly trend shows a noticeable dip in profitability around June and July, which is worth investigating further. Promotions show limited additional revenue impact across most categories.

This page is designed to help leadership understand not just what sold, but what actually contributed to profitability.

![Profitability Dashboard](images/profitability_dashboard.png)

---

## Key Business Outcomes

Putting everything together, a few clear patterns emerged from this analysis.

A small group of fast-moving products is responsible for a large share of revenue and profit, which means keeping those products consistently in stock should be a top priority for the business.

Almost the entire inventory is operating at low or critical levels, which leaves the business very exposed to any disruption in supply. The stockout rate of 38.2 percent is high, and the fact that stockouts are happening even during low-demand periods points to a planning problem rather than a demand problem.

Perishable categories like Dairy and Frozen Foods are carrying the most expiry risk at the same time that they are being over-ordered. That combination is creating avoidable losses that better replenishment planning could fix.

Supplier damage rates vary across products and suppliers, with frozen and fragile items being the most vulnerable. Tracking this consistently would give the business a stronger foundation for supplier conversations.

Promotions as currently structured are not generating a meaningful return. A more targeted approach focused on categories that actually respond would likely produce better results.

---

## Challenges I Faced

The most difficult part of building this project was making the simulated dataset behave realistically enough to produce meaningful analysis.

In early versions of the data, the outputs were technically correct but operationally strange. Stockout rates were too uniform across stores, replenishment quantities had no relationship to sales, and expiry patterns did not match realistic shelf life timelines. Getting the data to behave like a real retail operation required several rounds of adjustments.

Building the dashboard also took more thought than I expected. It was easy to add more charts, but harder to decide which ones actually helped someone understand the business better. The four-page structure with each page anchored to a specific business question was the answer, and I kept going back to that principle every time I was tempted to add something that looked interesting but did not serve a clear purpose.

---

## Tools Used

| Tool | What I used it for |
|------|-------------------|
| PostgreSQL | Building the database, writing all the business analysis queries, and creating the analytical view |
| Power BI | Building the interactive four page dashboard |
| DAX | Writing KPI measures, trend calculations, and the calendar table |
| Excel | Preparing and staging the raw dataset files before loading into PostgreSQL |
| PowerPoint | Designing the project presentation slides summarising the objectives, key findings, and business recommendations |

---

## Project Files

| File | Description |
|------|-------------|
| `datasets/transactions.csv` | Raw transactional data covering sales, stock movements, and stockout records across all five FoodCo branches |
| `datasets/products.csv` | Product reference data including product names, categories, reorder levels, and expiry information |
| `datasets/stores.csv` | Store details for all five FoodCo branch locations in Ibadan |
| `datasets/suppliers.csv` | Supplier information including names, lead times, and product-supplier mappings |
| `sql/schema_creation.sql` | CREATE TABLE statements and database schema used to structure the FoodCo inventory dataset in PostgreSQL |
| `sql/data_loading.sql` | Scripts used to import and load the raw dataset into the PostgreSQL database |
| `sql/analytical_view.sql` | SQL view that aggregates and prepares data for use as the Power BI data source |
| `sql/business_queries.sql` | All seven business analysis query sets covering sales, inventory, stockouts, expiry, suppliers, restocking, and promotions |
| `analysis/foodco_sql_analysis.md` | Full written analysis including SQL queries, query outputs, insights, and recommendations for each business question |
| `dashboard/Retail_Inventory_Dashboard.pbix` | Complete Power BI dashboard file containing all charts, KPIs, and visual reports |
| `presentation/project_presentation_slides.pptx` | Slide deck summarising the project objectives, key findings, and business recommendations |
| `images/overview_dashboard.png` | Screenshot of the Power BI overview dashboard showing high-level KPIs and revenue performance |
| `images/inventory_dashboard.png` | Screenshot of the inventory health dashboard showing stock status, coverage days, and critical stock alerts |
| `images/supplier_dashboard.png` | Screenshot of the supplier performance dashboard showing lead times and damage rates by supplier |
| `images/profitability_dashboard.png` | Screenshot of the profitability dashboard showing revenue and profit breakdown by product, category, and store |

---

## Repository Structure

```
retail-inventory-supply-chain-analytics/
│
├── datasets/
│   ├── transactions.csv
│   ├── products.csv
│   ├── stores.csv
│   └── suppliers.csv
│
├── sql/
│   ├── schema_creation.sql
│   ├── data_loading.sql
│   ├── analytical_view.sql
│   └── business_queries.sql
│
├── analysis/
│   └── foodco_sql_analysis.md
│
├── dashboard/
│   └── Retail_Inventory_Dashboard.pbix
│
├── presentation/
│   └── project_presentation_slides.pptx
│
├── images/
│   ├── overview_dashboard.png
│   ├── inventory_dashboard.png
│   ├── supplier_dashboard.png
│   └── profitability_dashboard.png
│
└── README.md
```

---

*Olajimi Adeleke — [LinkedIn](https://www.linkedin.com/in/olajimi-adeleke) · [Portfolio](https://jimi121.github.io/)*
