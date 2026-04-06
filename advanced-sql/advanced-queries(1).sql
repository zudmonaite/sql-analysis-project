WITH
  LatestAddress AS (
  SELECT
    customer_address.CustomerID,
    MAX(customer_address.AddressID) AS LatestAddressID
  FROM
    `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
  GROUP BY
    customer_address.CustomerID )
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
