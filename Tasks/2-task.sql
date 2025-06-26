--2.Customers Who Have More Than One Active Loan

SELECT 
    l.CustomerID,
    c.FullName,
    COUNT(*) AS ActiveLoanCount
FROM Loans_Credit.Loans l
JOIN Core_Banking.Customers c ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Approved'
GROUP BY l.CustomerID, c.FullName
HAVING COUNT(*) > 1;
