-- Task: Retrieve data for the most expensive products currently on sale, ordered by price in descending order.
-- Business goal:
-- Identify high-value products that are currently available for sale
-- to support pricing and sales analysis.

SELECT 
  product.ProductID,
  product.Name AS ProductName,
  product.ProductNumber,
  product.Size,
  product.Color,
  product.ProductSubcategoryID,
  product.ListPrice,
  product.SellEndDate,
  category.Name AS CategoryName
FROM `tc-da-1.adwentureworks_db.product` AS product

-- Join the subcategory to access the product grouping
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS subcategory
  ON product.ProductSubcategoryID =subcategory.ProductSubcategoryID

-- Join the category to retrieve higher-level classification
JOIN `tc-da-1.adwentureworks_db.productcategory` AS category
  ON subcategory.ProductCategoryID=category.ProductCategoryID

-- Apply filters:
-- 1. Include only high-value products (ListPrice > 2000)
-- 2. Include only active products (SellEndDate IS NULL)
WHERE product.ListPrice>2000 
  AND product.SellEndDate IS NULL
  
-- Sort results by price in descending order (highest first)
ORDER BY product.ListPrice DESC
;
