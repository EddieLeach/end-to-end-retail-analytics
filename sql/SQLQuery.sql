-- Total Sales for 2022 and 2023
SELECT SUM(sale_price) AS total_sales
FROM df_orders;


-- Overall totals (no region): 2022, 2023, % growth, combined
SELECT
    SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END)                    AS total_sales_2022,
    SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price ELSE 0 END)                    AS total_sales_2023,
    CAST(
        (
          SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price ELSE 0 END) -
          SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END)
        ) / NULLIF(SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END), 0) * 100.0
        AS DECIMAL(10,2)
    )                                                                                    AS pct_growth_22_23,
    SUM(sale_price)                                                                      AS total_sales_combined
FROM df_orders;



-- Total Sales by Region per Year
SELECT 
    region,
    YEAR(order_date) AS year,
    SUM(sale_price) AS total_sales
FROM df_orders
GROUP BY region, YEAR(order_date)
ORDER BY year, total_sales DESC;


-- Total sales by region for 2022 and 2023, including % growth and combined total
SELECT 
    region,
    SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price ELSE 0 END) AS sales_2023,
    CAST(
        (SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price ELSE 0 END) -
         SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END)) 
         / NULLIF(SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END),0) * 100
        AS DECIMAL(10,2)
    ) AS pct_growth,
    SUM(sale_price) AS total_sales
FROM df_orders
GROUP BY region
ORDER BY total_sales DESC;


-- Market share by region: 2022, 2023, change, and combined share
WITH sales AS (
    SELECT region, YEAR(order_date) AS yr, SUM(sale_price) AS revenue
    FROM df_orders
    GROUP BY region, YEAR(order_date)
),
year_totals AS (
    SELECT yr, SUM(revenue) AS total_rev
    FROM sales
    GROUP BY yr
),
shares AS (
    SELECT
        s.region,
        s.yr,
        CAST(s.revenue / NULLIF(yt.total_rev,0) * 100.0 AS DECIMAL(6,2)) AS market_share_pct
    FROM sales s
    JOIN year_totals yt ON yt.yr = s.yr
),
region_combined AS (
    SELECT region, SUM(revenue) AS revenue_all_years
    FROM sales
    GROUP BY region
),
combined_total AS (
    SELECT SUM(revenue_all_years) AS grand_total
    FROM region_combined
)
SELECT
    sc.region,
    MAX(CASE WHEN sc.yr = 2022 THEN sc.market_share_pct END) AS market_share_2022,
    MAX(CASE WHEN sc.yr = 2023 THEN sc.market_share_pct END) AS market_share_2023,
    CAST(
        (MAX(CASE WHEN sc.yr = 2023 THEN sc.market_share_pct END)
       -  MAX(CASE WHEN sc.yr = 2022 THEN sc.market_share_pct END))
        AS DECIMAL(6,2)
    ) AS pct_growth_22_23,            -- change in percentage points
    CAST(rc.revenue_all_years / NULLIF(ct.grand_total,0) * 100.0 AS DECIMAL(6,2)) AS combined_market_share
FROM shares sc
JOIN region_combined rc ON rc.region = sc.region
CROSS JOIN combined_total ct
GROUP BY sc.region, rc.revenue_all_years, ct.grand_total
ORDER BY combined_market_share DESC;


--find top 10 highest reveue generating products 
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc


--find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month


--for each category which month had highest sales 
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1






--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc


-- FURTHER ANALYSIS

-- Calculate revenue share of the top 10 products
WITH product_sales AS (
    SELECT
        product_id,
        SUM(sale_price) AS total_sales
    FROM df_orders
    GROUP BY product_id
),
ranked_products AS (
    SELECT
        product_id,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM product_sales
),
summary AS (
    SELECT
        SUM(total_sales) AS total_revenue
    FROM product_sales
)
SELECT
    r.product_id,
    r.total_sales,
    ROUND(r.total_sales / s.total_revenue * 100, 2) AS pct_of_total_revenue
FROM ranked_products r
CROSS JOIN summary s
WHERE r.sales_rank <= 10
ORDER BY r.total_sales DESC;


-- Calculate total revenue (total sales across all orders)
SELECT SUM(sale_price) AS total_sales
FROM df_orders;


-- Top 10 revenue products with useful context (uses only columns in your table)
SELECT TOP 10
    product_id,
    SUM(sale_price)                           AS revenue,        -- total sales $
    COUNT(*)                                   AS orders,         -- number of order lines
    SUM(quantity)                              AS units,          -- total units
    SUM(ISNULL(discount, 0))                   AS total_discount, -- $ discount (if any NULLs)
    SUM(ISNULL(profit, 0))                     AS profit,         -- total profit $
    CAST(SUM(sale_price) / NULLIF(SUM(quantity), 0) AS DECIMAL(18,2)) AS avg_selling_price, -- ASP
    CAST(SUM(ISNULL(profit,0)) / NULLIF(SUM(sale_price),0) AS DECIMAL(18,4)) AS profit_margin -- % of revenue
FROM df_orders
GROUP BY product_id
ORDER BY revenue DESC;   -- or ORDER BY profit DESC if you want top by profit


-- Top 10 most profitable products (uses only columns in your table)
SELECT TOP 10
    product_id,
    SUM(profit) AS total_profit,                 -- total profit earned
    SUM(sale_price) AS revenue,                  -- total revenue
    SUM(quantity) AS units_sold,                 -- total units sold
    COUNT(*) AS total_orders,                    -- total order lines
    SUM(ISNULL(discount,0)) AS total_discount,   -- total discount amount
    CAST(SUM(profit) / NULLIF(SUM(sale_price),0) AS DECIMAL(18,4)) AS profit_margin, -- % margin
    CAST(SUM(sale_price) / NULLIF(SUM(quantity),0) AS DECIMAL(18,2)) AS avg_selling_price -- avg $
FROM df_orders
GROUP BY product_id
ORDER BY total_profit DESC;


-- Top 10 sub-categories ranked by total profit
SELECT TOP 10
    sub_category,
    SUM(profit) AS total_profit,                 -- total profit earned
    SUM(sale_price) AS total_revenue,            -- total revenue
    SUM(quantity) AS total_units,                -- total units sold
    COUNT(*) AS total_orders,                    -- number of order lines
    SUM(ISNULL(discount,0)) AS total_discount,   -- total discount
    CAST(SUM(profit) / NULLIF(SUM(sale_price),0) AS DECIMAL(18,4)) AS avg_profit_margin,
    CAST(SUM(sale_price) / NULLIF(SUM(quantity),0) AS DECIMAL(18,2)) AS avg_selling_price
FROM df_orders
GROUP BY sub_category
ORDER BY total_profit DESC;


-- Top 10 sub-categories ranked by total revenue
SELECT TOP 10
    sub_category,
    SUM(sale_price) AS total_revenue,               -- total sales $
    SUM(profit) AS total_profit,                    -- total profit $
    SUM(quantity) AS total_units,                   -- total units sold
    COUNT(*) AS total_orders,                       -- number of orders
    SUM(ISNULL(discount,0)) AS total_discount,      -- total discount $
    CAST(SUM(profit) / NULLIF(SUM(sale_price),0) AS DECIMAL(18,4)) AS avg_profit_margin, -- profit %
    CAST(SUM(sale_price) / NULLIF(SUM(quantity),0) AS DECIMAL(18,2)) AS avg_selling_price -- avg $
FROM df_orders
GROUP BY sub_category
ORDER BY total_revenue DESC;


-- Top 5 categories per region with performance metrics
WITH category_region_sales AS (
    SELECT 
        region,
        category,
        SUM(sale_price) AS total_revenue,
        SUM(ISNULL(discount,0)) AS total_discount,
        SUM(ISNULL(profit,0)) AS total_profit,
        SUM(quantity) AS total_units,
        COUNT(*) AS total_orders,
        CAST(SUM(sale_price) / NULLIF(SUM(quantity),0) AS DECIMAL(10,2)) AS avg_selling_price
    FROM df_orders
    GROUP BY region, category
),
ranked AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS rank_by_revenue
    FROM category_region_sales
)
SELECT 
    region,
    category,
    total_revenue,
    total_discount,
    total_profit,
    avg_selling_price,
    total_units,
    total_orders
FROM ranked
WHERE rank_by_revenue <= 5
ORDER BY region, total_revenue DESC;


-- Swap this to each of your top 3 in turn:
-- 'TEC-CO-10004722', 'OFF-BI-10003527', 'TEC-MA-10002412'
DECLARE @product_id VARCHAR(50) = 'OFF-BI-10003527';

WITH monthly AS (
    SELECT
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
        SUM(sale_price)                       AS revenue,
        SUM(quantity)                         AS units,
        COUNT(*)                              AS orders,
        CAST(SUM(sale_price) / NULLIF(SUM(quantity),0) AS DECIMAL(10,2)) AS avg_selling_price,
        SUM(ISNULL(discount,0))               AS total_discount,
        SUM(ISNULL(profit,0))                 AS total_profit
    FROM df_orders
    WHERE product_id = @product_id
      AND YEAR(order_date) IN (2022, 2023)
    GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
)
SELECT 
    month_start,
    revenue, units, orders, avg_selling_price, total_discount, total_profit
FROM monthly
ORDER BY month_start;


-- Swap this to each of your top 3 in turn:
-- 'TEC-CO-10004722', 'OFF-BI-10003527', 'TEC-MA-10002412'
DECLARE @product_id VARCHAR(50) = 'OFF-BI-10003527';

SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
    region,
    SUM(sale_price)  AS revenue,
    SUM(quantity)    AS units,
    COUNT(*)         AS orders
FROM df_orders
WHERE product_id = @product_id
  AND YEAR(order_date) IN (2022, 2023)
GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1), region
ORDER BY month_start, revenue DESC;


-- Swap this to each of your top 3 in turn:
-- 'TEC-CO-10004722', 'OFF-BI-10003527', 'TEC-MA-10002412'
DECLARE @product_id VARCHAR(50) = 'TEC-AC-10003832';

WITH base AS (
    SELECT
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
        region,
        SUM(sale_price) AS revenue
    FROM df_orders
    WHERE product_id = @product_id
      AND YEAR(order_date) IN (2022, 2023)
    GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1), region
)
SELECT 
    month_start,
    ISNULL([Central],0) AS Central_rev,
    ISNULL([East],0)    AS East_rev,
    ISNULL([South],0)   AS South_rev,
    ISNULL([West],0)    AS West_rev,
    (ISNULL([Central],0)+ISNULL([East],0)+ISNULL([South],0)+ISNULL([West],0)) AS total_rev
FROM base
PIVOT (SUM(revenue) FOR region IN ([Central],[East],[South],[West])) p
ORDER BY month_start;


-- Top product by units sold with metrics
SELECT TOP 5
    product_id,
    SUM(quantity) AS total_units_sold,
    SUM(sale_price) AS total_revenue,
    SUM(ISNULL(profit, 0)) AS total_profit,
    SUM(ISNULL(discount, 0)) AS total_discount,
    COUNT(*) AS total_orders,
    CAST(SUM(sale_price) / NULLIF(SUM(quantity), 0) AS DECIMAL(10,2)) AS avg_selling_price,
    CAST(SUM(ISNULL(profit,0)) / NULLIF(SUM(sale_price), 0) * 100 AS DECIMAL(10,2)) AS profit_margin_pct
FROM df_orders
GROUP BY product_id
ORDER BY total_units_sold DESC;


-- Monthly revenue pivoted by region (2022–2023)
WITH monthly AS (
    SELECT
        FORMAT(order_date, 'yyyy-MM') AS month,   -- year-month format
        region,
        SUM(sale_price) AS total_revenue
    FROM df_orders
    WHERE YEAR(order_date) IN (2022, 2023)
    GROUP BY FORMAT(order_date, 'yyyy-MM'), region
)
SELECT 
    month,
    ISNULL([Central], 0) AS Central,
    ISNULL([East], 0)    AS East,
    ISNULL([South], 0)   AS South,
    ISNULL([West], 0)    AS West,
    (ISNULL([Central],0)+ISNULL([East],0)+ISNULL([South],0)+ISNULL([West],0)) AS Total
FROM monthly
PIVOT (
    SUM(total_revenue)
    FOR region IN ([Central],[East],[South],[West])
) AS p
ORDER BY month;

