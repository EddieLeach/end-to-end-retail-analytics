# 🛒 End-to-End Retail Analytics (Python + SQL)

![Status](https://img.shields.io/badge/status-In_Progress-blue)
![Python](https://img.shields.io/badge/Python-3.11-blue)
![SQL](https://img.shields.io/badge/SQL-Analysis-orange)
![ETL](https://img.shields.io/badge/Process-ETL-blueviolet)
![Visualization](https://img.shields.io/badge/Visualization-Matplotlib-yellow)

## 📊 Project Overview

This repository showcases an **end-to-end data analytics workflow** on a retail orders dataset using **Python + SQL**.

What it demonstrates:

- Extracting data (e.g. from Kaggle / CSV)
- Cleaning & transforming with Python (pandas)
- Loading into a SQL database
- Writing analytical SQL queries to answer real business questions
- Building clear visualizations & an insights summary

This project is designed to mirror what a **Junior Data Analyst / Analytics Engineer** would do in a real environment.

---

## 🧱 Project Architecture

**Tech Stack**

- Python (pandas, numpy, matplotlib, seaborn)
- SQL (SQL Server / SQLite / PostgreSQL)
- Jupyter Notebooks
- Git & GitHub

**Folder Layout**

- `data/` – raw & processed files (❗not committed; see `.gitignore`)
- `notebooks/` – EDA, cleaning, SQL exploration, visualization
- `sql/` – table schema + analysis queries
- `src/` – Python ETL scripts (extract → transform → load)
- `reports/` – final charts and written insights

---

## 🔄 ETL Pipeline

1. **Extract** – Load the source CSV / Kaggle dataset.
2. **Transform** – Clean data types, handle nulls, engineer features.
3. **Load** – Insert into SQL tables for structured querying.
4. **Analyze** – Use SQL & Python to answer business questions.
5. **Visualize** – Build charts to support decisions.

---

## ❓ Business Questions (Planned)

This project will (or does) answer:

1. Which products generate the highest **revenue** and **profit**?
2. Top 5 **categories per region** by revenue, discount, and profit.
3. **Month-over-month growth** comparison for 2022 vs 2023.
4. Which sub-categories show the highest **profit growth** YoY?
5. How do **discounts** impact **profitability**?
6. What is the **regional market share** and how is it changing?

Each question is backed by:
- a SQL query (see `sql/analysis_queries.sql`)
- and/or a notebook section (see `notebooks/`)

---

## ⚙️ How to Run This Project

### 1️⃣ Clone the repo

```bash
git clone https://github.com/eddieleach/end-to-end-retail-analytics.git
cd end-to-end-retail-analytics
