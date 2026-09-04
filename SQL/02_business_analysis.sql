-- 02_business_analysis.sql

-- Customer profitability
WITH sales AS (
    SELECT CustomerID,
           SUM(NetSales) AS Revenue,
           SUM(COGS + ShippingCost + PaymentCost) AS OperatingCost
    FROM FactSales
    GROUP BY CustomerID
),
returns AS (
    SELECT fs.CustomerID,
           SUM(fr.RefundValue + fr.ReturnCost) AS ReturnImpact
    FROM FactReturns fr
    JOIN FactSales fs ON fs.OrderID = fr.OrderID
    GROUP BY fs.CustomerID
)
SELECT s.CustomerID,
       s.Revenue,
       s.Revenue - s.OperatingCost - COALESCE(r.ReturnImpact,0) AS CustomerProfit,
       (s.Revenue - s.OperatingCost - COALESCE(r.ReturnImpact,0))
          / NULLIF(s.Revenue,0) AS MarginPct
FROM sales s
LEFT JOIN returns r ON r.CustomerID = s.CustomerID
ORDER BY CustomerProfit DESC;

-- First purchase / repeat purchase
WITH x AS (
    SELECT CustomerID,
           MIN(OrderDate) OVER(PARTITION BY CustomerID) AS FirstOrderDate,
           COUNT(*) OVER(PARTITION BY CustomerID) AS LifetimeOrders
    FROM FactSales
)
SELECT CustomerID, FirstOrderDate, LifetimeOrders,
       CASE WHEN LifetimeOrders >= 2 THEN 1 ELSE 0 END AS IsRepeatCustomer
FROM x
GROUP BY CustomerID, FirstOrderDate, LifetimeOrders;

-- Cohort retention
WITH first_purchase AS (
    SELECT CustomerID, DATE_TRUNC('month', MIN(OrderDate)) AS CohortMonth
    FROM FactSales
    GROUP BY CustomerID
),
activity AS (
    SELECT DISTINCT CustomerID, DATE_TRUNC('month', OrderDate) AS ActivityMonth
    FROM FactSales
)
SELECT fp.CohortMonth, a.ActivityMonth,
       COUNT(DISTINCT a.CustomerID) AS ActiveCustomers,
       COUNT(DISTINCT fp.CustomerID) AS CohortSize
FROM first_purchase fp
JOIN activity a ON a.CustomerID = fp.CustomerID
GROUP BY fp.CohortMonth, a.ActivityMonth
ORDER BY fp.CohortMonth, a.ActivityMonth;

-- Discount economics
SELECT
    CASE
      WHEN DiscountRate = 0 THEN 'No Discount'
      WHEN DiscountRate <= .10 THEN '0-10%'
      WHEN DiscountRate <= .20 THEN '11-20%'
      ELSE '20%+'
    END AS DiscountBand,
    SUM(NetSales) AS Revenue,
    SUM(NetSales - COGS - ShippingCost - PaymentCost) AS ContributionProfit,
    SUM(NetSales - COGS - ShippingCost - PaymentCost)
      / NULLIF(SUM(NetSales),0) AS MarginPct
FROM FactSales
GROUP BY 1
ORDER BY 1;
