-- Task 1:
-- Create a monthly sales report by Country and Region, including
-- order volume, unique customer count, salesperson count, and
-- total revenue (including tax) across all customer types.

-- Business Question:
-- How does sales performance vary across countries and regions over time?

-- Expected Insight:
-- Monitor sales trends, compare regional performance, and identify
-- markets with strong or weak growth based on revenue, customer activity,
-- and sales team engagement.

SELECT
  LAST_DAY(DATE(DATE_TRUNC(salesorderheader.OrderDate, MONTH))) AS order_month,
  salesterritory.CountryRegionCode AS country_region_code ,
  salesterritory.Name AS region,
  COUNT(DISTINCT salesorderheader.SalesOrderID) AS number_orders,
  COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
  COUNT(DISTINCT salesorderheader.SalesPersonID) AS number_salesperson,
  ROUND(SUM (salesorderheader.TotalDue),0)AS total_w_tax
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.salesterritory` AS salesterritory
ON
  salesorderheader.TerritoryID=salesterritory.TerritoryID 
GROUP BY
  order_month,
  country_region_code,
  region;

---

-- Task 2:
-- Extend the monthly sales report by adding a cumulative revenue metric
-- that tracks the running total of sales amount (including tax) for each
-- Country and Region over time.

-- Business Question:
-- How does revenue accumulate over time across different countries and regions?

-- Expected Insight:
-- Monitor long-term sales growth, compare market performance trends,
-- and identify regions that consistently contribute to overall revenue growth.

WITH
  MonthlySales AS (
  SELECT
    LAST_DAY(DATE(DATE_TRUNC(salesorderheader.OrderDate, MONTH))) AS order_month,
    salesterritory.CountryRegionCode AS country_region_code,
    salesterritory.Name AS region,
    COUNT (DISTINCT salesorderheader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT (DISTINCT salesorderheader.SalesPersonID) AS no_salesperson,
    ROUND(SUM (salesorderheader.TotalDue),0)AS total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN
    `tc-da-1.adwentureworks_db.salesterritory` AS salesterritory
  ON
    salesorderheader.TerritoryID=salesterritory.TerritoryID
  GROUP BY
    order_month,
    country_region_code,
    region) 

-- Select final results
SELECT
  order_month,
  country_region_code,
  region,
  number_orders,
  number_customers,
  no_salesperson,
  total_w_tax,
  SUM(Total_w_tax) OVER (PARTITION BY country_region_code, Region  ORDER BY order_month) AS cumulative_sum
FROM
  MonthlySales
  ORDER BY 
  country_region_code;

---
-- Task 3:
-- Enhance the regional monthly sales report by adding a ranking column
-- that ranks regions within each country based on total revenue (including tax)
-- for each month, from highest to lowest.

-- Business Question:
-- Which regions perform best within each country over time in terms of revenue generation?

-- Expected Insight:
-- Identify top-performing and underperforming regions within each market,
-- enabling benchmarking, performance comparison, and targeted regional strategy improvements.

WITH
  MonthlySales AS (
  SELECT
    LAST_DAY(DATE(DATE_TRUNC(salesorderheader.OrderDate, MONTH))) AS order_month,
    salesterritory.CountryRegionCode AS country_region_code,
    salesterritory.Name AS region,
    COUNT (DISTINCT salesorderheader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT (DISTINCT salesorderheader.SalesPersonID) AS number_salesperson,
    ROUND(SUM (salesorderheader.TotalDue),0)AS total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN
    `tc-da-1.adwentureworks_db.salesterritory` AS salesterritory
  ON
    salesorderheader.TerritoryID=salesterritory.TerritoryID
  GROUP BY
    order_month,
    country_region_code,
    region)

-- Select final results
SELECT
  order_month,
  country_region_code,
  region,
  number_orders,
  number_customers,
  number_salesperson,
  total_w_tax,
  RANK () OVER (PARTITION BY country_region_code, region  ORDER BY Total_w_tax DESC) AS country_sales_rank,
  SUM(total_w_tax) OVER (PARTITION BY country_region_code, region  ORDER BY order_month) AS cumulative_sum
FROM
  MonthlySales
ORDER BY
  country_region_code;

---

-- Task 4:
-- Extend the regional sales ranking report by adding country-level tax context.
-- Include the average tax rate per country (using the highest tax rate per province)
-- and the share of provinces/states with available tax data.

-- Business Question:
-- How do differences in tax structures and data coverage across countries
-- relate to reported sales performance?

-- Expected Insight:
-- Provide transparency into how tax variability may influence revenue comparisons
-- across regions, while also highlighting data completeness issues at the
-- province/state level. This supports more accurate cross-country benchmarking
-- and improves confidence in regional performance analysis.

-- CTE to aggregate monthly sales data per country and region
WITH
  MonthlySales AS (
  SELECT
    LAST_DAY(DATE(DATE_TRUNC(salesorderheader.OrderDate, MONTH))) AS order_month,
    salesterritory.CountryRegionCode AS country_region_code,
    salesterritory.Name AS region,
    COUNT (DISTINCT salesorderheader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT (DISTINCT salesorderheader.SalesPersonID) AS number_salesperson,
    ROUND(SUM (salesorderheader.TotalDue),0)AS total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN
    `tc-da-1.adwentureworks_db.salesterritory` AS salesterritory
  ON
    salesorderheader.TerritoryID=salesterritory.TerritoryID
  GROUP BY
    order_month,
    country_region_code,
    region),
-- CTE to calculate tax rate statistics per country
  TaxRates AS (
  WITH
    MaxRate AS (
    SELECT
      StateProvinceID,
      MAX (TaxRate) AS max_rate
    FROM
      `tc-da-1.adwentureworks_db.salestaxrate` AS salestaxrate
    GROUP BY
      StateProvinceID)
  SELECT
    stateprovince.CountryRegionCode AS country,
    COUNT(stateprovince.StateProvinceID) AS total_states,
    COUNT(MaxRate.StateProvinceID) AS states_with_rate,
    ROUND(AVG (max_rate),1) AS mean_tax_rate
  FROM
    `tc-da-1.adwentureworks_db.stateprovince` AS stateprovince
  LEFT JOIN
    MaxRate
  ON
    MaxRate.StateProvinceID=stateprovince.StateProvinceID
  GROUP BY
    country)
-- Select final results
SELECT
  order_month,
  country_region_code,
  region,
  number_orders,
  number_customers,
  number_salesperson,
  total_w_tax,
  RANK () OVER (PARTITION BY country_region_code, region ORDER BY total_w_tax DESC) AS country_sales_rank,
  SUM(total_w_tax) OVER (PARTITION BY country_region_code, region ORDER BY order_month) AS cumulative_sum,
  mean_tax_rate,
  ROUND(states_with_rate/total_states,2) AS perc_provinces_w_ta
FROM
  MonthlySales
JOIN
  TaxRates
ON
  MonthlySales.country_region_code=TaxRates.country
ORDER BY
  country_region_code;
