# SQL Data Warehouse Project – Medallion Architecture (Microsoft SQL Server)

This project builds an end‑to‑end SQL data warehouse from CSV source files using the **medallion architecture** (bronze, silver, gold layers). The entire ETL process is implemented in **T‑SQL** (Microsoft SQL Server) and version‑controlled with **Git Bash**. The goal is to transform raw operational CSVs into clean, enriched, and analytics‑ready datasets for reporting, dashboards, and machine learning.

---

## Architecture Overview

| Layer   | Purpose                                                                 |
|---------|-------------------------------------------------------------------------|
| **Bronze**  | Raw data as‑is from CSV files. No transformations – only staging.       |
| **Silver**  | Data cleaning, standardisation, deduplication, and enrichment (e.g., derived columns, lookups). |
| **Gold**    | Aggregated, business‑ready tables optimised for analysis & ML.          |

![Medallion+architecture](https://github.com/user-attachments/assets/2e8ba68c-01ea-4137-a43b-fdb4527f5271)

---
### 🗺️ System Integration Model (+ Table Relationships)

Below is the visual representation of how the **CRM** and **ERP** systems are integrated within this pipeline.

```text
       ┌───────────────────────────────┐               ┌───────────────────────────────┐
       │             CRM               │               │             ERP               │
       └───────────────┬───────────────┘               └───────────────┬───────────────┘
                       │                                               │
   ┌───────────────────┴───────────────────┐                           │
   │           crm_sales_details           │                           │
   │      (Sales & Order Transactions)     │                           │
   ├───────────────────────────────────────┤                           │
   │  prd_key  ──────────┐                 │                           │
   │  cst_id   ──────────┼─────────┐       │                           │
   └─────────────────────┼─────────┼───────┘                           │
                         │         │                                   │
             ┌───────────▼─────────┴──────────┐            ┌───────────▼───────────┐
             │          crm_prd_info          │            │    erp_px_cat_g1v2    │
             │   (Current & History Product)  │◄───────────┤  (Product Categories) │
             ├────────────────────────────────┤            ├───────────────────────┤
             │  prd_key                       │            │  id                   │
             └────────────────────────────────┘            └───────────────────────┘
                                   │
             ┌─────────────────────▼──────────┐            ┌───────────────────────┐
             │          crm_cust_info         │            │     erp_cust_az12     │
             │     (Customer Information)     │      ┌─────┤ (Birthdate/Extra Info)│
             ├────────────────────────────────┤      │     ├───────────────────────┤
             │  cst_id                        │      │     │  cid                  │
             │  cst_key                       │◄─────│     └───────────────────────┘
             └────────────────────────────────┘      │
                                                     │     ┌───────────────────────┐
                                                     │     │     erp_loc_a101      │
                                                     └─────┤  (Customer Location)  │
                                                           ├───────────────────────┤
                                                           │  cid                  │
                                                           └───────────────────────┘
```
---

### 💎 Final Analytical Model: Sales Data Mart (Star Schema)

This is the finalized, Gold-tier database schema. It uses a **Star Schema** architecture to optimize query performance for retail analytics.

```text
  ┌──────────────────────────┐          ┌──────────────────────────┐          ┌──────────────────────────┐
  │    gold.dim_customers    │          │     gold.fact_sales      │          │    gold.dim_products     │
  ├──────────────────────────┤          ├──────────────────────────┤          ├──────────────────────────┤
  │ PK │ customer_key   ◄────┼──────────┤ FK2│ customer_key        │          │ PK │ product_key    ◄───┐│
  ├────┴─────────────────────┤          │ FK1│ product_key   ──────┼──────────┴────┴────────────────────┘│
  │      customer_id         │          │      order_number        │          │      product_id          │
  │      customer_number     │          │      order_date          │          │      product_number      │
  │      first_name          │          │      shipping_date       │          │      product_name        │
  │      last_name           │          │      due_date            │          │      category_id         │
  │      country             │          │      sales_amount        │          │      category            │
  │      marital_status      │          │      quantity            │          │      subcategory         │
  │      gender              │          │      price               │          │      maintenance         │
  │      birthdate           │          └───────────┬──────────────┘          │      cost                │
  │      country             │                      │                         │      product_line        │
  └──────────────────────────┘                      │                         │      start_date          │
                                                    │                         └──────────────────────────┘
                                                    │
                                           📊 Sales Calculation:
                                         Sales = Quantity * Price
```

## Prerequisites

- **Microsoft SQL Server** – 2025 version was used on the entire project.
- **SQL Server Management Studio (SSMS)** – to run scripts.
- **Git Bash** – for version control, cloning, and pushing local machine adjustments into the repository.
- **Access to file system** – SQL Server must be able to read the CSV files (local or network path).


---

Feel free to connect with me on *LinekdIn* from the button below 👇🏻😁

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/kareem-hossam-hozayen/)

