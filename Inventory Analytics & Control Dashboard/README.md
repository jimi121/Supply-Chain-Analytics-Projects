<div align="center">

# Inventory Analytics & Control Dashboard

**An Excel and Power BI inventory reporting solution for monitoring stock, planning reorders and evaluating supplier performance.**

![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-2C2C2C?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-16A34A?style=for-the-badge)

</div>

I built this project to turn inventory, sales and supplier data into a reporting system that makes it easier to understand stock levels, identify products that need attention and support purchasing decisions.

The project combines Microsoft Excel and Power BI, with data preparation, validation, calculations, modelling and interactive reporting all forming part of the workflow.

---

## Dashboard

![Executive Overview](images/dashboard-overview.png)

### Interactive Power BI Report

**[Open the Interactive Power BI Dashboard](PASTE-YOUR-POWER-BI-LINK-HERE)**

The interactive report allows users to filter products, categories and suppliers, investigate stock movements and review products that require attention.

---

## Project Overview

The dataset covers:

- 30 products
- 5 product categories
- 5 suppliers
- Six months of inventory, sales and supplier activity
- 7 Power BI report pages

The report focuses on three practical areas:

- Understanding the current inventory position
- Identifying products that need attention or need to be reordered
- Evaluating supplier delivery performance

The aim was to make the report useful to both technical and non-technical users. Someone reviewing the dashboard should be able to understand the main inventory issues without having to work through the underlying calculations.

---

## Current Inventory Snapshot

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

These figures provide a quick view of the current inventory position. The individual report pages provide the detail behind each measure.

---

# The Seven Report Pages

## 1. Executive Overview

The Executive Overview provides the starting point for understanding the overall inventory position.

It brings together total stock value, products below their reorder point, out-of-stock products and overall inventory health.

The page also shows inventory value over time, category-level inventory value and the movement of stock into and out of the business.

The urgent-items section brings products requiring attention into view.

![Executive Overview](images/dashboard-overview.png)

---

## 2. Product Catalog

The Product Catalog provides a detailed view of the products in the dataset.

Users can filter the catalogue by status, category and supplier or search for a specific product.

The page includes product cost, yearly sales value, stock quantity, stock status and value classification.

This makes it possible to move from the overall inventory position into the details of an individual product.

![Product Catalog](images/product-catalog.png)

---

## 3. Inventory Levels

The Inventory Levels page focuses on stock availability and inventory coverage.

It shows current stock value, average days of stock remaining, slow-moving products and the value tied up in dead stock.

The product-level table provides:

- Quantity in stock
- Reorder point
- Days of stock remaining
- Days since the last movement
- Stock status

This helps distinguish between healthy inventory, stock that is running low and inventory that has remained unused for too long.

![Inventory Levels](images/inventory-levels.png)

---

## 4. Stock Movements

The Stock Movements page provides a transaction-level view of inventory activity.

It tracks receipts, issues and adjustments and shows the resulting stock level after each movement.

Users can filter the transaction history by product and date range and investigate individual movements when something does not look right.

The current report period contains **332 transactions**, with **28,470 units received** and **27,870 units issued**.

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

The current report shows **90% supplier on-time delivery**, an average lead time of **6.2 days** and **6 pending orders**.

The supplier scorecard makes it easier to compare suppliers and identify differences in delivery performance.

![Supplier Performance](images/supplier-performance.png)

---

## 6. Reorder Planning

The Reorder Planning page focuses on the products that may require purchasing action.

It identifies high-risk products and products that have fallen below their reorder point.

For each product, users can see:

- Current stock
- Reorder point
- Days of supply
- Suggested reorder quantity
- Stock status
- Expected run-out date
- Recommended action

The current analysis identifies **3 high-risk products** and **9 products requiring reorder**, with a suggested reorder value of **₦965,730**.

![Reorder Planning](images/reorder-planning.png)

---

## 7. Inventory Insights

The Inventory Insights page brings the main findings together in plain language.

Instead of leaving the user to interpret every chart, the page highlights the areas that deserve attention.

The analysis covers:

- Overall stock health
- Products approaching stockout
- Inventory value concentration
- Slow-moving inventory
- Supplier reliability
- Products requiring reorder

The current report identifies **3 products close to running out**, **4 products that have not moved in over a month** and **₦1,953,450 of stock tied up in slow-moving inventory**.

The executive summary brings the main findings together so that someone can understand the current inventory situation without going through every report page.

![Inventory Insights](images/inventory-insights.png)

---

# Data Validation

Data validation was an important part of the project.

Before finalising the report, I checked the stock movements against the running inventory balance and tested the calculations across the reporting period.

During validation, several issues were identified:

- A running balance was repeating an incorrect figure.
- A full month of sales was missing from the transaction ledger.
- A stock count correction had not been reflected in the official figures.

Each issue was traced back to its source and corrected before the final report was completed.

This helped ensure that the dashboard was based on data that had been checked rather than simply presented.

---

# Technical Work

The project involved:

- Data preparation and cleaning
- Data validation
- Power Query transformations
- Excel calculations
- Data modelling
- DAX measures
- Power BI relationships
- Inventory KPIs
- Reorder calculations
- Supplier performance analysis
- Transaction-level reconciliation
- Interactive dashboard design
- Written inventory insights

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

The purpose of this project was to connect inventory data to practical business questions.

The report starts with the overall inventory position, allows users to investigate individual products and transactions, compares supplier performance, identifies products that need to be reordered and brings the main findings together in plain language.

The result is an interactive reporting system that helps turn inventory data into information that can support stock and purchasing decisions.
