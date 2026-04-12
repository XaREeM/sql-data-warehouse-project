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


---

## Prerequisites

- **Microsoft SQL Server** (2017 or later) – Developer or Express edition works fine.
- **SQL Server Management Studio (SSMS)** or **Azure Data Studio** – to run scripts.
- **Git Bash** – for version control and cloning the repository.
- **Access to file system** – SQL Server must be able to read the CSV files (local or network path).


---


