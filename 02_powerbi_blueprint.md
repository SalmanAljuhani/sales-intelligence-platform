# Power BI Dashboard Blueprint — Sales Intelligence Platform

## Page 1: Executive Overview
Top KPI cards:
- Total Revenue
- Total Profit
- Profit Margin %
- Total Orders
- Units Sold

Visuals:
1. Line chart: Revenue by Month
2. Clustered column: Revenue by Branch
3. Bar chart: Top 10 Products by Revenue
4. Donut: Revenue by Channel
5. Slicer: Date / Region / Branch / Category / Channel

## Page 2: Product Performance
- Revenue by Product
- Profit by Product
- Margin % by Product
- Category performance
- Top/Bottom products

## Page 3: Branch Performance
- Revenue by City
- Profit by City
- Orders by City
- Revenue per Order
- Branch ranking

## Recommended DAX measures
Total Revenue = SUM(fact_sales[revenue])
Total Profit = SUM(fact_sales[profit])
Orders = DISTINCTCOUNT(fact_sales[sale_id])
Units Sold = SUM(fact_sales[quantity])
Profit Margin % = DIVIDE([Total Profit], [Total Revenue])
Avg Order Value = DIVIDE([Total Revenue], [Orders])

## Portfolio story
Do not only show charts. Add a "Management Insights" box with 3–5 decisions:
- Which branch needs attention?
- Which product drives profit?
- Which channel has the best margin?
- Where are discounts hurting profitability?
- Which products should be promoted or reviewed?

## Suggested project title on LinkedIn
Sales Intelligence Dashboard | SQL + Power BI | Business Decision Support
