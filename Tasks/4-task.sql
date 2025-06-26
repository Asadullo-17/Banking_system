--4.Total Loan Amount Issued Per Branch

SELECT 
    b.BranchID,
    b.BranchName,
    SUM(l.Amount) AS TotalLoanIssued
FROM Loans_Credit.Loans l
JOIN Core_Banking.Customers c ON l.CustomerID = c.CustomerID
JOIN Core_Banking.Accounts a ON a.CustomerID = c.CustomerID
JOIN Core_Banking.Branches b ON a.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName
ORDER BY BranchID
