-- Task 1:
-- Create a comprehensive customer overview by combining customer,
-- contact, address, and sales information. Calculate key customer metrics,
-- including order count, total spending (with tax), and most recent order date.
-- Use the latest available address for customers with multiple addresses and
-- return the top 200 customers by total spending.

-- Business Question:
-- Who are our most valuable individual customers, and what are their
-- key contact details, locations, and purchasing behaviors?

-- Expected Insight:
-- Provide a consolidated customer view that supports customer segmentation,
-- relationship management, targeted marketing campaigns, and identification
-- of high-value customers based on their purchasing activity.

WITH
  LatestAddress AS (
  SELECT
    customer_address.CustomerID,
    MAX(customer_address.AddressID) AS LatestAddressID
  FROM
    `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
  GROUP BY
    customer_address.CustomerID)
  
  -- Select final results
SELECT
  customer.CustomerID AS customer_id,
  contact.FirstName AS first_name,
  contact.LastName AS last_name,
  CONCAT(contact.FirstName, ' ', contact.LastName) AS full_name,
  CONCAT(COALESCE(contact.Title, 'Dear'), ' ', contact.LastName) AS addressing_title,
  contact.EmailAddress AS email_address,
  contact.phone,
  customer.AccountNumber AS account_number,
  customer.CustomerType AS customer_type,
  address.city,
  address.AddressLine1 AS address_line1,
  address.AddressLine2 AS addres_line2,
  state_province.Name AS state,
  countryregion.Name AS country,
  COUNT(DISTINCT salesorderheader.SalesOrderID) AS number_of_orders,
  ROUND(SUM(salesorderheader.TotalDue), 2) AS total_amount,
  MAX(salesorderheader.OrderDate) AS latest_order_date
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.customer` AS customer
ON
  salesorderheader.CustomerID = customer.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.contact`AS contact
ON
  salesorderheader.ContactID=contact.ContactID
JOIN
  LatestAddress AS latest
ON
  customer.CustomerID = latest.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
ON
  customer.CustomerID=customer_address.CustomerID
  AND customer_address.AddressID = latest.LatestAddressID
JOIN
  `tc-da-1.adwentureworks_db.address` AS address
ON
  customer_address.AddressID = address.AddressID
JOIN
  `tc-da-1.adwentureworks_db.stateprovince` AS state_province
ON
  address.StateProvinceID = state_province.StateProvinceID
JOIN
  `tc-da-1.adwentureworks_db.countryregion` AS countryregion
ON
  state_province.CountryRegionCode = countryregion.CountryRegionCode
WHERE
  customer.CustomerType = 'I'
GROUP BY
  customer_id,
  first_name,
  last_name,
  addressing_title,
  email_address,
  contact.phone,
  account_number,
  customer_type,
  address.city,
  address_line1,
  addres_line2,
  state,
  country
ORDER BY
  total_amount DESC
LIMIT
  200;

---
-- Task 2:
-- Extend the customer overview by identifying the top 200 customers
-- by total spending (including tax) who have not placed an order within
-- the last 365 days, using the latest order date in the database as the
-- reference date.

-- Business Question:
-- Which high-value customers have become inactive and may be at risk of churn?

-- Expected Insight:
-- Identify previously valuable customers who have stopped purchasing,
-- enabling targeted retention campaigns, re-engagement strategies,
-- and proactive customer relationship management.

WITH
  LatestAddress AS (
  SELECT
    customer_address.CustomerID,
    MAX(customer_address.AddressID) AS LatestAddressID
  FROM
    `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
  GROUP BY
    customer_address.CustomerID ),
  LastYearThreshold AS (
    --CTE to find customers who have not ordered for the last 365 days
  SELECT
    DATE_SUB(MAX(DATE_TRUNC(salesorderheader.OrderDate, DAY)), INTERVAL 365 DAY) AS cutoff_date
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader)
  -- Select final results
SELECT
  customer.CustomerID AS customer_id,
  contact.FirstName AS first_name,
  contact.LastName AS last_name,
  CONCAT(contact.FirstName, ' ', contact.LastName) AS full_name,
  CONCAT(COALESCE(contact.Title, 'Dear'), ' ', contact.LastName) AS addressing_title,
  contact.EmailAddress AS email_address,
  contact.phone,
  customer.AccountNumber AS account_number,
  customer.CustomerType AS customer_type,
  address.city,
  address.AddressLine1 AS address_line1,
  address.AddressLine2 AS addres_line2,
  state_province.Name AS state,
  countryregion.Name AS country,
  COUNT(DISTINCT salesorderheader.SalesOrderID) AS number_of_orders,
  ROUND(SUM(salesorderheader.TotalDue), 2) AS total_amount,
  MAX(salesorderheader.OrderDate) AS latest_order_date
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.customer` AS customer
ON
  salesorderheader.CustomerID = customer.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.contact`AS contact
ON
  salesorderheader.ContactID=contact.ContactID
JOIN
  LatestAddress AS latest
ON
  customer.CustomerID = latest.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
ON
  customer.CustomerID=customer_address.CustomerID
  AND customer_address.AddressID = latest.LatestAddressID
JOIN
  `tc-da-1.adwentureworks_db.address` AS address
ON
  customer_address.AddressID = address.AddressID
JOIN
  `tc-da-1.adwentureworks_db.stateprovince` AS state_province
ON
  address.StateProvinceID = state_province.StateProvinceID
JOIN
  `tc-da-1.adwentureworks_db.countryregion` AS countryregion
ON
  state_province.CountryRegionCode = countryregion.CountryRegionCode
WHERE
  customer.CustomerType = 'I'
GROUP BY
  customer_id,
  first_name,
  last_name,
  addressing_title,
  email_address,
  contact.phone,
  account_number,
  customer_type,
  address.city,
  address_line1,
  addres_line2,
  state,
  country
HAVING
  MAX(DATE_TRUNC(salesorderheader.OrderDate, DAY)) < (
  SELECT
    cutoff_date
  FROM
    LastYearThreshold )
ORDER BY
  total_amount DESC
LIMIT
  200;

---
-- Task 3:
-- Enhance the customer overview by adding an activity status flag
-- that classifies customers as Active or Inactive based on whether
-- they have placed an order within the last 365 days.
-- Return the top 500 customers ordered by CustomerId in descending order.

-- Business Question:
-- Which customers are currently engaged with the business, and which
-- customers have become inactive?

-- Expected Insight:
-- Enable customer segmentation based on recent purchasing behavior,
-- supporting retention analysis, targeted marketing efforts, and
-- customer lifecycle management.

WITH
  LatestAddress AS (
  SELECT
    customer_address.CustomerID,
    MAX(customer_address.AddressID) AS LatestAddressID
  FROM
    `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
  GROUP BY
    customer_address.CustomerID ),
  --CTE to find customers who have not ordered for the last 365 days
  LastYearThreshold AS (
  SELECT
    DATE_SUB(MAX(DATE_TRUNC(salesorderheader.OrderDate, DAY)), INTERVAL 365 DAY) AS cutoff_date
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader)
  
  -- Select final results
SELECT
  customer.CustomerID AS customer_id,
  contact.FirstName AS first_name,
  contact.LastName AS last_name,
  CONCAT(contact.FirstName, ' ', contact.LastName) AS full_name,
  CONCAT(COALESCE(contact.Title, 'Dear'), ' ', contact.LastName) AS addressing_title,
  contact.EmailAddress AS email_address,
  contact.phone,
  customer.AccountNumber AS account_number,
  customer.CustomerType AS customer_type,
  address.city,
  address.AddressLine1 AS address_line1,
  address.AddressLine2 AS addres_line2,
  state_province.Name AS state,
  countryregion.Name AS country,
  COUNT(DISTINCT salesorderheader.SalesOrderID) AS number_of_orders,
  ROUND(SUM(salesorderheader.TotalDue), 2) AS total_amount,
  MAX(salesorderheader.OrderDate) AS latest_order_date,
  CASE
    WHEN salesorderheader.OrderDate < ( SELECT cutoff_date FROM LastYearThreshold ) THEN 'inactive'
    ELSE 'active'
END
  AS stauts
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.customer` AS customer
ON
  salesorderheader.CustomerID = customer.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.contact`AS contact
ON
  salesorderheader.ContactID=contact.ContactID
JOIN
  LatestAddress AS latest
ON
  customer.CustomerID = latest.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
ON
  customer.CustomerID=customer_address.CustomerID
  AND customer_address.AddressID = latest.LatestAddressID
JOIN
  `tc-da-1.adwentureworks_db.address` AS address
ON
  customer_address.AddressID = address.AddressID
JOIN
  `tc-da-1.adwentureworks_db.stateprovince` AS state_province
ON
  address.StateProvinceID = state_province.StateProvinceID
JOIN
  `tc-da-1.adwentureworks_db.countryregion` AS countryregion
ON
  state_province.CountryRegionCode = countryregion.CountryRegionCode
WHERE
  customer.CustomerType = 'I'
GROUP BY
  customer_id,
  first_name,
  last_name,
  addressing_title,
  email_address,
  contact.phone,
  account_number,
  customer_type,
  address.city,
  address_line1,
  addres_line2,
  state,
  country,
  stauts
ORDER BY
  customer.CustomerID DESC
LIMIT
  500;

---
-- Task 4:
-- Retrieve active customers from North America who either have a
-- total spending of at least 2500 (including tax) or have placed
-- 5 or more orders. Split the customer address into two separate columns.

-- Business Question:
-- Which active North American customers demonstrate high value through
-- either significant spending or frequent purchasing activity?

-- Expected Insight:
-- Identify high-value customer segments for targeted marketing,
-- loyalty programs, and customer relationship management initiatives.

WITH
  LatestAddress AS (
  SELECT
    customer_address.CustomerID,
    MAX(customer_address.AddressID) AS lastes_address_id
  FROM
    `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
  GROUP BY
    customer_address.CustomerID ),
  --CTE to find customers who have not ordered for the last 365 days
  LastYearThreshold AS (
  SELECT
    DATE_SUB(MAX(DATE_TRUNC(salesorderheader.OrderDate, DAY)), INTERVAL 365 DAY) AS cutoff_date
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader ),
  --CTE to clean not needed signes from address
  CleanedAddress AS (
  SELECT
    AddressLine1,
    AddressID,
    StateProvinceID,
    REGEXP_REPLACE(AddressLine1, r'[^A-Za-z0-9\s]', '') AS cleaned_line
  FROM
    `tc-da-1.adwentureworks_db.address` )
  -- Select final results
SELECT
  customer.CustomerID AS customer_id,
  contact.FirstName AS first_name,
  contact.LastName AS last_name,
  CONCAT(contact.FirstName, ' ', contact.LastName) AS full_name,
  CONCAT(COALESCE(contact.Title, 'Dear'), ' ', contact.LastName) AS addressing_title,
  contact.EmailAddress AS email_address,
  contact.phone,
  customer.AccountNumber AS account_number,
  customer.CustomerType AS customer_type,
  address.city,
  address.AddressLine1 AS address_line1,
  TRIM(
    CASE
      WHEN REGEXP_CONTAINS(CleanedAddress.cleaned_line, r'\b\d+th\b') THEN REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\b\d+\w*th\s+\w+\b|\b\w*th')
      WHEN REGEXP_CONTAINS(CleanedAddress.cleaned_line, r'\b\d+rd\b') THEN REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\b\d+\w*rd\s+\w+\b|\b\w*rd')
      WHEN REGEXP_CONTAINS(CleanedAddress.cleaned_line, r'\b\d+nd\b') THEN REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\b\d+\w*nd\s+\w+\b|\b\w*nd')
      WHEN TRIM(REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\D+')) = 'No' THEN REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\b[A-Za-z]+\s+[A-Za-z]+\b')
      WHEN TRIM(REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\D+')) = '-' THEN REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\b[A-Za-z]+\s+[A-Za-z]+\b')
      ELSE REGEXP_EXTRACT(CleanedAddress.cleaned_line, r'\D+')
  END
    ) AS address_st,
  REGEXP_EXTRACT (CleanedAddress.cleaned_line, r'\d+') AS address_no,
  address.AddressLine2 AS addres_line2,
  state_province.Name AS state,
  countryregion.Name AS country,
  COUNT(DISTINCT salesorderheader.SalesOrderID) AS number_of_orders,
  ROUND(SUM(salesorderheader.TotalDue), 2) AS total_amount,
  MAX(salesorderheader.OrderDate) AS latest_order_date,
  CASE
    WHEN salesorderheader.OrderDate < ( SELECT cutoff_date FROM LastYearThreshold ) THEN 'inactive'
    ELSE 'active'
END
  AS stauts
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.customer` AS customer
ON
  salesorderheader.CustomerID = customer.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.contact`AS contact
ON
  salesorderheader.ContactID=contact.ContactID
JOIN
  LatestAddress AS latest
ON
  customer.CustomerID = latest.CustomerID
JOIN
  `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
ON
  customer.CustomerID=customer_address.CustomerID
  AND customer_address.AddressID = latest.lastes_address_id
JOIN
  `tc-da-1.adwentureworks_db.address` AS address
ON
  customer_address.AddressID = address.AddressID
JOIN
  `tc-da-1.adwentureworks_db.stateprovince` AS state_province
ON
  address.StateProvinceID = state_province.StateProvinceID
JOIN
  `tc-da-1.adwentureworks_db.countryregion` AS countryregion
ON
  state_province.CountryRegionCode = countryregion.CountryRegionCode
JOIN
  CleanedAddress
ON
  CleanedAddress.AddressID=address.AddressID
JOIN
  `tc-da-1.adwentureworks_db.salesterritory` AS salesterritory
ON
  salesorderheader.TerritoryID=salesterritory.TerritoryID
  AND salesterritory.Group = 'North America'
WHERE
  customer.CustomerType = 'I'
  AND salesorderheader.OrderDate > (
  SELECT
    cutoff_date
  FROM
    LastYearThreshold )
GROUP BY
  customer_id,
  first_name,
  last_name,
  addressing_title,
  email_address,
  contact.phone,
  account_number,
  customer_type,
  address.city,
  address_line1,
  addres_line2,
  state,
  country,
  stauts,
  cleaned_line
HAVING
  ROUND(SUM(salesorderheader.TotalDue), 2) >=2500
  OR COUNT(DISTINCT salesorderheader.SalesOrderID)>=5
ORDER BY
  countryregion.Name,
  state_province.Name,
  MAX(salesorderheader.OrderDate);
