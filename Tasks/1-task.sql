--1.Top 3 Customers with the Highest Total Balance Across All Accounts

SELECT TOP 3 
    c.CustomerID,
    c.FullName,
    SUM(a.Balance) AS TotalBalance
FROM Core_Banking.Customers c
JOIN Core_Banking.Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalBalance DESC;
