<div align="center">

# Procurement Decision Intelligence Dashboard

### Turning procurement data into clear decisions about spending, suppliers, risk and savings.

![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-2C2C2C?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-16A34A?style=for-the-badge)

**FMCG Distribution | January to June 2026 | NGN (₦)**

</div>


## Project Overview

Procurement teams need more than a report showing how much money has been spent. They need to understand whether spending is within budget, which categories are driving costs, which suppliers need attention and where savings can be made.

### Project Objective

The objective of this project was to turn procurement data into a practical decision making tool that helps identify:

- Budget pressure and overspending
- Supplier performance issues
- Supplier concentration risk
- Changes in purchase prices
- Potential cost saving opportunities

The dashboard connects these findings to practical actions so that users can move from **seeing the numbers to understanding what needs to be done**.


#  Business Problem

The business has procurement data covering purchases, budgets, suppliers, products and categories. However, raw transaction data does not immediately show where management should focus.

The challenge was to build a reporting solution that could:

- Track actual spending against budget
- Identify categories exceeding their budgets
- Monitor supplier delivery performance
- Highlight supplier concentration and risk
- Track changes in purchase prices
- Identify realistic cost saving opportunities

The goal was not simply to create charts.

> **The goal was to turn procurement data into information that can support better purchasing and supplier decisions.**

#  Dashboard

The dashboard is divided into six pages. Each page answers a different business question.

[**View the Interactive Power BI Dashboard**](https://app.powerbi.com/view?r=eyJrIjoiYTc4NDM0MjctNzM0MS00NmFhLTg4ZGUtNWY5YjExNjk4ZTFmIiwidCI6IjYyMGJjNTRiLTE2Y2YtNDhjNy1iNWE3LTY0ZmFkNmI5OTdhZiJ9)


## 1. Procurement Overview

### What does this page show?

This page provides a high level view of the company's procurement position.

It brings together:

- Total Procurement Spend
- Total Budget
- Budget Variance
- Budget Utilisation
- Monthly Spending
- Budget Status by Category

### Business Question

> **Are we currently spending within budget and where should management pay attention?**

### Key Finding

Total procurement spend is **₦30.75M** against a **₦31.66M budget**, representing **97% budget utilisation**.

Although total spending is below budget, the category breakdown shows that **3 of 6 categories are already over budget**.


![Procurement Overview](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Overview.PNG)

## 2. Spend vs Budget

### What does this page show?

This page provides a closer look at how actual spending compares with the approved budget.

It includes:

- Monthly Spend Against Budget
- Budget vs Actual Spend by Category
- Budget Utilisation Gauge

### Business Question

> **When and where is procurement spending exceeding expectations?**

### Key Finding

Spending reached its highest point in **April at ₦6.2M**, making it the only month where actual spending exceeded the monthly budget.

At category level, **Cleaning & Hygiene and Office & Admin** are the most significant areas of overspending.


![Spend vs Budget](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Spend%20vs%20Budget.PNG)


## 3. Category Performance

### What does this page show?

This page looks at procurement performance at category level.

It combines:

- Category Budget
- Actual Spend
- Budget Variance
- Average Purchase Price
- Price Changes
- Total Spend by Category

### Business Question

> **Which categories are driving procurement costs and what is causing the change?**

### Key Finding

**Facilities & Maintenance** has the highest average purchase price at **₦98,043.64**.

Packaging and Cleaning & Hygiene also recorded significant price increases since January at **14.73%** and **11.28%** respectively.

This suggests that supplier pricing needs attention, particularly in categories where higher prices are contributing to budget pressure.


![Category Performance](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Category%20Performance.PNG)


## 4. Supplier Performance

### What does this page show?

This page evaluates supplier performance using both delivery and purchasing information.

It looks at:

- Total Supplier Spend
- Spend Share
- Average Purchase Price
- On Time Delivery
- Average Lead Time
- Supplier Performance Status

### Business Question

> **Which suppliers are reliable and which suppliers require attention?**

### Key Finding

Average on time delivery is **87.4%**, with an average lead time of **5.8 days**.

**Chukwuma Beverages Distribution** has the lowest on time delivery rate at **80%**, while **Delta Fresh Foods Nigeria** records **84.6%**.

These suppliers should be reviewed to determine whether delivery terms or supplier allocation need to change.


![Supplier Performance](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Supplier%20Performance.PNG)


## 5. Supplier Risk and Concentration

### What does this page show?

Good supplier performance does not necessarily mean low risk.

This page looks at how much procurement spending depends on individual suppliers and identifies suppliers that require further review.

It includes:

- Supplier Spend Concentration
- Top Supplier Share
- Top Three Supplier Share
- Suppliers Flagged for Risk Review

### Business Question

> **Are we too dependent on a small number of suppliers?**

### Key Finding

**Faj Hygiene Products Ltd accounts for 22.7% of total procurement spend**, making it the largest supplier relationship in the business.

The top three suppliers together account for **47.7% of total procurement spend**.

Because Faj Hygiene Products Ltd is also flagged for review, identifying a qualified secondary supplier would help reduce dependency and protect supply continuity.

![Supplier Risk and Concentration](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Suppliers%20Risk.PNG)

## 6. Cost and Savings Opportunities

### What does this page show?

This page focuses on identifying specific opportunities to reduce procurement costs.

It compares supplier prices for the same products and identifies products where a lower cost alternative is available.

The analysis includes:

- Average Purchase Price
- Price Change Since January
- Current Supplier
- Alternative Supplier
- Current Price
- Alternative Price
- Potential Saving

### Business Question

> **Where can procurement reduce costs by changing suppliers or negotiating better prices?**

### Key Finding

The analysis identified **10 products with lower cost alternative suppliers**, representing a combined potential saving of **₦20,497**.

The strongest opportunities include **Hand Sanitizer 5L, Fruit Juice Concentrate 5L and Malt Drink Carton**.

The Hand Sanitizer opportunity is particularly useful because changing the supplier could both reduce cost and lower dependence on **Faj Hygiene Products Ltd**.

![Cost and Savings Opportunities](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Cost%20%26%20Saving.PNG)


# Key Business Insights

The dashboard uncovered several issues that are not immediately obvious from total procurement spend.

| Area | Finding | Recommended Action |
|---|---|---|
| **Budget** | 3 of 6 categories are over budget | Review Cleaning & Hygiene and Office & Admin |
| **Monthly Spend** | April reached ₦6.2M and exceeded budget | Investigate the April spending increase |
| **Category Pricing** | Packaging prices increased 14.73% | Review supplier pricing |
| **Delivery** | Chukwuma Beverages has 80% OTD | Review delivery performance |
| **Supplier Risk** | Faj Hygiene Products holds 22.7% of spend | Identify a secondary supplier |
| **Savings** | ₦20,497 in potential savings identified | Prioritise the strongest supplier switching opportunities |

![Insights](https://github.com/jimi121/Supply-Chain-Analytics-Projects/blob/main/Procurement%20Decision%20Intelligence%20Dashboard/Image/Insights.PNG)

# Problem Solving Approach

I approached the project as a business problem rather than simply a dashboard design exercise.

### 1. Understand

Identify the procurement questions that management needs answered.

### 2. Prepare

Clean and structure the procurement, budget, supplier, product and category data.

### 3. Model

Build relationships between the different datasets using a structured data model.

### 4. Analyse

Create DAX measures for spending, budget variance, utilisation, supplier performance, concentration and savings.

### 5. Investigate

Look beyond the headline numbers to identify the reasons behind overspending, supplier risk and price changes.

### 6. Recommend

Translate the findings into practical actions that procurement teams can take.

# Tools and Skills

### Microsoft Excel

Used for the underlying procurement dataset and data preparation.

### Power BI

Used for data modelling, DAX, visualisation, filtering and dashboard development.

### DAX

Used to create business measures and logic for:

- Spend
- Budget
- Budget Variance
- Budget Utilisation
- Supplier Performance
- Supplier Concentration
- Price Change
- Savings Opportunities

### Skills Demonstrated

- Data Cleaning
- Data Analysis
- Data Modelling
- DAX
- KPI Development
- Budget Analysis
- Variance Analysis
- Supplier Performance Analysis
- Supplier Risk Analysis
- Cost Analysis
- Business Intelligence
- Data Storytelling
- Decision Support

# Project Results

| Metric | Result |
|---|---:|
| Total Procurement Spend | **₦30.75M** |
| Total Budget | **₦31.66M** |
| Budget Utilisation | **97%** |
| Budget Remaining | **₦906,910** |
| Categories Over Budget | **3 of 6** |
| Average On Time Delivery | **87.4%** |
| Largest Supplier Spend Share | **22.7%** |
| Top 3 Supplier Concentration | **47.7%** |
| Products With Lower Cost Alternatives | **10** |
| Identified Savings Opportunity | **₦20,497** |


# Data

The project uses a fictional Nigerian FMCG distribution company with:

- **25 products**
- **6 procurement categories**
- **10 suppliers**
- **6 months of procurement activity**
- **₦31.66M total budget**
- **₦30.75M total procurement spend**

The company, supplier and product names are fictional. The dataset is fixed for reproducibility.


<!-- # Project Structure

```text
Procurement-Decision-Intelligence-Dashboard/
│
├── Excel/
│   ├── Transactions
│   ├── Budget
│   ├── Suppliers
│   ├── Products
│   └── Categories
│
├── Power BI/
│   └── Procurement Dashboard.pbix
│
├── images/
│   ├── procurement-overview.png
│   ├── spend-vs-budget.png
│   ├── category-performance.png
│   ├── supplier-performance.png
│   ├── supplier-risk.png
│   └── cost-savings.png
│
└── README.md
```
-->

# Interactive Power BI Report

### Interactive Power BI Report

[**View the Interactive Power BI Dashboard**](https://app.powerbi.com/view?r=eyJrIjoiYTc4NDM0MjctNzM0MS00NmFhLTg4ZGUtNWY5YjExNjk4ZTFmIiwidCI6IjYyMGJjNTRiLTE2Y2YtNDhjNy1iNWE3LTY0ZmFkNmI5OTdhZiJ9)


<!-- # Project Files

### Excel Dataset

[**Download the Excel Dataset**](PLACEHOLDER_EXCEL_DATASET_LINK)

### Power BI File

[**Download the Power BI File**](PLACEHOLDER_POWER_BI_FILE_LINK)

-->

## Disclaimer

This is a portfolio project created for demonstration purposes. All company, supplier and product names are fictional.
