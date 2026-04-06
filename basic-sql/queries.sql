SELECT 
  product.ProductID, 
  product.Name AS ProductName, 
  product.ProductNumber, 
  product.Size, 
  product.Color, 
  product.ProductSubcategoryID,
  subcategory.name AS SubCategory
FROM `tc-da-1.adwentureworks_db.product`  AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS subcategory
ON product.ProductSubcategoryID =subcategory.ProductSubcategoryID
ORDER BY SubCategory
;
