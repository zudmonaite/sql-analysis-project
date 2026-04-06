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

--subquery
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
