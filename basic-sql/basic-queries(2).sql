--Task 1:  Retrieve data for location and calculate order count, product count, and total costs.
-- Business goal: 
-- Compare production activity and costs across locations to identify
-- high-volume and high-cost operations that may require further analysis.

SELECT
  LocationID,
  COUNT(DISTINCT WorkOrderID) AS OrdersCount,
  COUNT(DISTINCT ProductID) AS ProductCount,
  SUM (ActualCost) AS TotalCost
FROM `tc-da-1.adwentureworks_db.workorderrouting`
WHERE SAFE_CAST(ActualStartDate AS DATE) BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY LocationID
ORDER BY TotalCost DESC;

--- 
-- Task 2:
-- Add the location name using a JOIN to improve result readability.
-- Calculate the average number of days between Actual Start Date
-- and Actual End Date for each location.
-- Business Goal:
-- Compare average work order completion times across production locations
-- to identify potential operational bottlenecks and differences in efficiency.
SELECT
  Routing.LocationID,
  Location.Name AS LocationName,
  COUNT(DISTINCT Routing.WorkOrderID) AS OrdersCount,
  COUNT(DISTINCT Routing.ProductID) AS ProductCount,
  SUM (Routing.ActualCost) AS TotalCost,
  ROUND(AVG(DATETIME_DIFF(Routing.ActualEndDate, Routing.ActualStartDate, DAY)),2) AS Mean_delivery_time
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS Routing
LEFT JOIN `tc-da-1.adwentureworks_db.location` Location
  ON Routing.LocationID=Location.LocationID
WHERE SAFE_CAST(Routing.ActualStartDate AS DATE) BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY Routing.LocationID,LocationName
ORDER BY TotalCost DESC
;

---
-- Task 3:
-- Retrieve all work orders from January 2004 where the actual cost
-- exceeds 300.
-- Business Question:
-- Which work orders generated unusually high production costs?
SELECT 
  WorkOrderID,
  SUM(ActualCost) AS TotalActualCost
FROM  `tc-da-1.adwentureworks_db.workorderrouting`
WHERE SAFE_CAST(ActualStartDate AS DATE) BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY WorkOrderID
HAVING TotalActualCost>300
ORDER BY TotalActualCost DESC
;
