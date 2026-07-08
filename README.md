# ecommerce_store_analysis_olist
End-to-end SQL analysis of 550K+ Olist e-commerce transactions —  investigating revenue trends, customer retention, delivery performance,  and seller accountability using MySQL.

# Olist E-Commerce Analysis 🛒

## Project Overview
A end-to-end SQL analysis of Olist, a Brazilian e-commerce platform, 
investigating revenue health, customer retention, delivery performance, 
and seller accountability using real transactional data.

## Business Problem
Why is the business struggling to retain customers and what operational 
factors are driving dissatisfaction?

## Dataset
- **Source:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Size:** 550,000+ rows across 8 relational tables
- **Period:** January 2017 — August 2018

## Tools Used
- MySQL & MySQL Workbench
- Git & GitHub

## Schema Design
8 tables connected through primary and foreign key relationships.
Central table: `orders` — connects customers, payments, reviews, and items.

## Analysis & Key Findings

### Act 1 — Revenue Health Check
Investigated monthly revenue trends and top performing product categories.

> **Finding:** Explosive growth in February 2017 at 108.52% MoM. 
> Revenue growth flattened significantly by 2018, signaling the business 
> needs new customer acquisition or retention strategies.
> Top categories: bed_bath_table and health_beauty (high volume), 
> computers and watches (high order value).

### Act 2 — Customer Retention Analysis
Identified repeat vs one-time buyers using customer_unique_id to track 
real customers across multiple orders.

> **Finding:** 96.94% of customers are one-time buyers. 
> Only 0.11% qualify as loyal customers (6+ orders). 
> Severe retention problem threatening long-term revenue sustainability.

### Act 3 — Delivery Performance
Measured delivery delays using DATEDIFF between actual and estimated 
delivery dates, cross-referenced with customer review scores.

> **Finding:** Late deliveries score 2.27 vs 4.30 for early deliveries — 
> a 47% drop in customer satisfaction directly linked to delayed shipments.

### Act 4 — Seller Accountability
Identified worst performing sellers by late delivery rate and average 
review score, filtered to sellers with 10+ orders for statistical reliability.

> **Finding:** 11 sellers show late delivery rates above 20%. 
> Top problematic seller reaches 31.58% late rate with only 3.34 average 
> review score — well below the platform average of 4.30.

## Recommendations
1. **Prioritize logistics intervention** for the 11 sellers with 20%+ late 
   delivery rates — they are directly driving low review scores and customer churn.
2. **Investigate 2018 growth plateau** — flat MoM growth signals need for 
   new customer acquisition or loyalty programs.
3. **Launch retention campaign** targeting one-time buyers — converting even 
   5% of one-time buyers to repeat customers would significantly impact revenue.

## How to Run
1. Download dataset from Kaggle link above
2. Run `/schema/create_tables.sql` to create database structure
3. Load CSVs using LOAD DATA LOCAL INFILE pointing to your local file path
4. Run analysis queries in `/analysis/` folder in order (act1 through act4)

## Project Structure
ecommerce_store_analysis_olist/
├── README.md
├── schema/
│   └── create_tables.sql
├── analysis/
│   ├── act1_revenue.sql
│   ├── act2_retention.sql
│   ├── act3_delivery.sql
│   └── act4_sellers.sql
└── screenshots/
