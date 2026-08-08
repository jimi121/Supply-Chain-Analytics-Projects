<div align="center">

# NovaLink Inventory Control

**An Excel and Power BI inventory management system for monitoring stock, planning reorders and evaluating supplier performance.**

![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-2C2C2C?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-16A34A?style=for-the-badge)

</div>

I built NovaLink to turn inventory, sales and supplier data into a reporting system that makes it easier to see what is happening with stock and where attention is needed.

The project combines Microsoft Excel and Power BI to track inventory levels, stock movements, supplier performance and reorder requirements.

I worked on the data preparation, calculations, data modelling, validation, DAX measures and Power BI report design.

---

## Dashboard

![Executive Overview](images/dashboard-overview.png)

### Interactive Power BI Report

The full report can be explored here:

**[Open the Interactive Power BI Dashboard](PASTE-YOUR-POWER-BI-LINK-HERE)**

The interactive report allows users to filter products, categories and suppliers, investigate stock movements and review products that need attention.

---

## Project Overview

The dataset covers:

- 30 products
- 5 product categories
- 5 suppliers
- Six months of inventory, sales and supplier activity
- 7 Power BI report pages

The report is built around three practical questions:

1. What is happening with inventory right now?
2. Which products need attention or need to be reordered?
3. Which suppliers are performing reliably?

The aim was to make the report useful to someone who does not need to be a data analyst to understand it.

---

## Current Inventory Snapshot

The report provides a quick view of the current inventory position and the areas that need attention.

| Metric | Current Value |
|---|---:|
| Total stock value | **₦22,484,770** |
| Products below reorder point | **21** |
| Products out of stock | **15** |
| Healthy inventory | **77%** |
| Average days of stock remaining | **22.4 days** |
| Slow-moving products | **4** |
| Dead stock value | **₦1,953,450** |
| High-risk products | **3** |
| Products needing reorder | **9** |
| Suggested reorder value | **₦965,730** |
| Supplier on-time delivery | **90%** |
| Pending supplier orders | **6** |

These figures give a quick picture of where inventory is healthy and where action may be required. The individual report pages provide the detail behind each measure. :contentReference[oaicite:1]{index=1}

---

# The Seven Report Pages

## 1. Executive Overview

The Executive Overview is the starting point for understanding the overall inventory position.

It brings together total stock value, products below their reorder point, out-of-stock products and overall inventory health.

The page also shows how inventory value changes over time, which product categories hold the most inventory value and how much stock is being received compared with stock being issued.

The urgent-items section brings individual products that need attention into view.

![Executive Overview](images/dashboard-overview.png)

---

## 2. Product Catalog

The Product Catalog provides a detailed view of the 30 products in the dataset.

Users can filter the catalogue by status, category and supplier or search for a specific SKU or product.

The page shows product cost, yearly sales value, stock quantity, stock status and value classification.

This makes it possible to move from the overall inventory position into the details of an individual product.

![Product Catalog](images/product-catalog.png)

---

## 3. Inventory Levels

The Inventory Levels page focuses on stock availability and inventory coverage.

It shows current stock value, average days of stock remaining, slow-moving products and the value tied up in dead stock.

The product table provides more detail for each SKU, including:

- Quantity in stock
- Reorder point
- Days of stock remaining
- Days since the last movement
- Stock status

The page helps distinguish between healthy inventory, excess stock and products that are approaching a reorder point.

![Inventory Levels](images/inventory-levels.png)

---

## 4. Stock Movements

The Stock Movements page provides a transaction-level view of inventory activity.

It tracks receipts, issues and adjustments and shows the resulting stock level after each movement.

Users can filter the transaction history by SKU, product and date range and investigate individual movements when something does not look right.

This creates a link between the underlying inventory transactions and the stock figures shown elsewhere in the report.

The current report period contains **332 transactions**, with 28,470 units received and 27,870 units issued. :contentReference[oaicite:2]{index=2}

![Stock Movements](images/stock-movements.png)

---

## 5. Supplier Performance

The Supplier Performance page looks at supplier delivery and purchasing activity.

It tracks:

- On-time delivery rate
- Average lead time
- Purchase order value
- Pending orders
- Products supplied
- Supplier stock value

The current report shows an overall supplier on-time delivery rate of **90%**, with an average lead time of **6.2 days** and **6 pending orders**. :contentReference[oaicite:3]{index=3}

The supplier scorecard makes it easier to compare suppliers and identify differences in delivery performance.

![Supplier Performance](images/supplier-performance.png)

---

## 6. Reorder Planning

The Reorder Planning page focuses on the next purchasing decisions.

It identifies products that are at higher risk of stockout and products that have fallen below their reorder point.

For each product, the report shows:

- Current stock
- Reorder point
- Days of supply
- Suggested reorder quantity
- Stock status
- Expected run-out date
- Recommended action

The current analysis identifies **3 high-risk products** and **9 products requiring reorder**, with a suggested reorder value of **₦965,730**. :contentReference[oaicite:4]{index=4}

This turns the inventory data into information that can support purchasing decisions.

![Reorder Planning](images/reorder-planning.png)

---

## 7. Inventory Insights

The Inventory Insights page brings the main findings together in plain language.

Rather than making the user interpret every chart, the page highlights the areas that deserve attention.

The analysis covers:

- Overall stock health
- Products approaching stockout
- Where inventory value is concentrated
- Slow-moving inventory
- Supplier reliability
- Products requiring reorder

The current report identifies **3 products close to running out**, **4 products that have not moved in over a month** and **₦1,953,450 of stock tied up in slow-moving inventory**.

It also highlights supplier performance and the products that need to be reordered. :contentReference[oaicite:5]{index=5}

The executive summary at the bottom of the page brings the main findings together so that someone can understand the current inventory situation without going through every report page.

![Inventory Insights](images/inventory-insights.png)

---

# Data Validation

Data validation was an important part of the project.

I did not want to build the visuals and simply assume the underlying numbers were correct. The stock movements were checked against the running inventory balance and the calculations were tested across the reporting period.

During validation, several issues were identified in the data:

- A running balance was repeating an incorrect figure.
- A full month of sales was missing from the transaction ledger.
- A stock count correction had not been reflected in the official figures.

Each issue was traced back to its source and corrected before the final report was completed.

This process helped make sure the dashboard was based on data that could be checked rather than simply presented.

---

# What I Built

The project involved several stages of the analytics process:

- Preparing and cleaning the source data
- Transforming data with Power Query
- Building the inventory data model
- Creating Excel calculations
- Developing DAX measures
- Creating inventory and supplier KPIs
- Building reorder calculations
- Validating stock movements
- Designing the Power BI report
- Adding filters and interactive views
- Creating written inventory insights

---

# Tools Used

### Microsoft Excel

Used for the underlying data, calculations, inventory logic and validation.

### Power Query

Used to prepare and transform the source data before it was loaded into the reporting model.

### Power BI

Used for data modelling, relationships, visualisation, filtering and interactive report development.

### DAX

Used to create calculated measures and implement the business logic behind the inventory, reorder and supplier metrics.

---

# Project Structure

### Excel Workbook

- Products
- Suppliers and Supplier Lead Time
- Monthly Stock Movement
- Transactions
- Purchase Orders

### Power BI Report

- Executive Overview
- Product Catalog
- Inventory Levels
- Stock Movements
- Supplier Performance
- Reorder Planning
- Inventory Insights

---

# Project Objective

The purpose of this project was not simply to create an inventory dashboard.

I wanted to build a reporting system that connects the underlying transactions to the questions someone managing inventory would actually need to answer.

The report starts with the overall inventory position, allows users to investigate individual products and transactions, compares supplier performance, identifies products that need to be reordered and then brings the main findings together in plain language.

The result is a system that helps turn inventory data into something that can be understood and acted on.