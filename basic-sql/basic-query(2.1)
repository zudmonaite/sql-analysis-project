SELECT
  LocationID,
  COUNT(DISTINCT WorkOrderID) AS OrdersCount,
  COUNT(DISTINCT ProductID) AS ProductCount,
  SUM (ActualCost) AS TotalCost
FROM `tc-da-1.adwentureworks_db.workorderrouting`
WHERE SAFE_CAST(ActualStartDate AS DATE) BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY LocationID
ORDER BY TotalCost DESC;
