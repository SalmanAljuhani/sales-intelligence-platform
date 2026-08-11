-- Salman Al-Juhani | Information Systems BI Portfolio Project
-- Project: Sales Intelligence Platform
-- Target: SQL Server

CREATE DATABASE SalmanBI;
GO
USE SalmanBI;
GO

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    segment VARCHAR(50) NOT NULL,
    list_price DECIMAL(12,2) NOT NULL
);

CREATE TABLE dim_branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE dim_customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_segment VARCHAR(30) NOT NULL
);

CREATE TABLE fact_sales (
    sale_id VARCHAR(20) PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    channel VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount_pct DECIMAL(5,2) NOT NULL,
    revenue DECIMAL(14,2) NOT NULL,
    cost DECIMAL(14,2) NOT NULL,
    profit AS (revenue - cost) PERSISTED,
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (branch_id) REFERENCES dim_branch(branch_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);
GO

-- KPI queries
-- 1) Total Revenue
SELECT SUM(revenue) AS total_revenue FROM fact_sales;

-- 2) Total Profit
SELECT SUM(profit) AS total_profit FROM fact_sales;

-- 3) Profit Margin
SELECT ROUND(SUM(profit) * 100.0 / NULLIF(SUM(revenue),0),2) AS profit_margin_pct
FROM fact_sales;

-- 4) Revenue by Branch
SELECT b.city, SUM(s.revenue) AS revenue
FROM fact_sales s
JOIN dim_branch b ON s.branch_id=b.branch_id
GROUP BY b.city
ORDER BY revenue DESC;

-- 5) Top Products
SELECT p.product_name, SUM(s.revenue) AS revenue, SUM(s.profit) AS profit
FROM fact_sales s
JOIN dim_product p ON s.product_id=p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 6) Monthly trend
SELECT YEAR(sale_date) AS sale_year, MONTH(sale_date) AS sale_month,
       SUM(revenue) AS revenue, SUM(profit) AS profit
FROM fact_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY sale_year, sale_month;

-- 7) Online vs Store vs Corporate
SELECT channel, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM fact_sales
GROUP BY channel
ORDER BY revenue DESC;

-- 8) Customers with high value
SELECT c.customer_segment, s.customer_id,
       SUM(s.revenue) AS revenue, SUM(s.profit) AS profit
FROM fact_sales s
JOIN dim_customer c ON s.customer_id=c.customer_id
GROUP BY c.customer_segment, s.customer_id
HAVING SUM(s.revenue) >= 10000
ORDER BY revenue DESC;
