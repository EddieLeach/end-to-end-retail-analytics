# 🛒 End-to-End Retail Analytics (Python + SQL)

![Status](https://img.shields.io/badge/status-In_Progress-blue)
![Python](https://img.shields.io/badge/Python-3.11-blue)
![SQL](https://img.shields.io/badge/SQL-Analysis-orange)
![ETL](https://img.shields.io/badge/Process-ETL-blueviolet)
![Visualization](https://img.shields.io/badge/Visualization-Matplotlib-yellow)

## 📊 Project Overview

This repository showcases an **end-to-end data analytics workflow** on a retail orders dataset using **Python + SQL**.

It demonstrates how to:

- Extract data from a CSV (or Kaggle export)
- Clean & transform using Python (`pandas`)
- Load data into a SQL database for analysis
- Write analytical SQL queries to answer real business questions
- Build clear visualizations and summarize insights

This project is structured to mirror what a **Junior Data Analyst / Analytics Engineer** would deliver in a real environment.

---

## 🧱 Project Architecture

**Tech Stack**

- Python: `pandas`, `numpy`, `matplotlib`, `seaborn`, `sqlalchemy`
- SQL: SQLite for portability (optional: SQL Server / PostgreSQL compatible)
- Jupyter Notebooks
- Git & GitHub

**Folder Layout**

- `data/`
  - `raw/` – source CSVs (🚫 not committed)
  - `processed/` – cleaned datasets (small/reference only)
- `notebooks/` – EDA, cleaning, SQL exploration, visualizations
- `sql/` – table schema and analysis queries
- `src/` – Python ETL scripts (extract → transform → load)
- `reports/` – final charts and written insights

> Large/local data files are excluded via `.gitignore` to keep the repo lightweight and reproducible.

---

## 🔄 ETL Pipeline

1. **Extract**  
   Load the raw retail orders dataset from `data/raw/`.

2. **Transform**  
   - Remove duplicates  
   - Standardize text fields  
   - Parse dates  
   - Convert numeric columns (e.g., Sales, Profit, Discount, Quantity)

3. **Load**  
   Load the cleaned dataset into a local **SQLite database** as an `orders` table  
   (easily swappable to SQL Server or PostgreSQL).

4. **Analyze**  
   Use SQL queries and notebooks to answer concrete business questions.

5. **Visualize**  
   Build charts that help stakeholders quickly understand performance and trends.

---

## ❓ Business Questions

This project is designed to answer:

1. Which products generate the highest **revenue** and **profit**?
2. Who are the top 5 **categories per region** by revenue, discount, and profit?
3. How does **month-over-month growth** compare between 2022 and 2023?
4. Which sub-categories show the highest **year-over-year profit growth**?
5. How do **discounts** impact **profitability** across products and regions?
6. What is the **regional market share**, and how is it changing over time?

Each question is backed by:

- SQL logic in `sql/analysis_queries.sql` (planned/expanding)
- Notebooks in `notebooks/` for EDA and visualization

---

## ⚙️ How to Run This Project

### 1️⃣ Clone the repo

```bash
git clone https://github.com/eddieleach/end-to-end-retail-analytics.git
cd end-to-end-retail-analytics

### 2️⃣ Create and activate a virtual environment

python -m venv venv
venv\Scripts\activate      # Windows
# source venv/bin/activate # Mac/Linux

### 3️⃣ Install dependencies

pip install -r requirements.txt

### 4️⃣ Add the raw dataset

data/raw/

### 5️⃣ Run the ETL pipeline

python src/extract.py
python src/transform.py
python src/load.py

### 6️⃣ Explore and analyze

jupyter notebook

then open

notebooks/01_data_exploration.ipynb
