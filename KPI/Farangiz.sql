--#1.Branch revenue is estimated based on the number of accounts, total transaction volume, and loan amounts at each branch.


SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(a.AccountID) AS NumAccounts,
    SUM(t.Amount) AS TotalTransactions,
    SUM(l.Amount) AS TotalLoans,
    (SUM(t.Amount) + SUM(l.Amount)) AS TotalRevenue
FROM Core_Banking.Branches b
LEFT JOIN Core_Banking.Accounts a ON b.BranchID = a.BranchID
LEFT JOIN Core_Banking.Transactions t ON a.AccountID = t.AccountID
LEFT JOIN Loans_Credit.Loans l ON a.CustomerID = l.CustomerID
GROUP BY b.BranchID, b.BranchName;

--#2
\--Determine the last login date of each customer to identify whether they are active or passive.
\--Activity is classified into three categories:
--Active**: Less than 7 days.
--At Risk**: 8–30 days.
--Inactive**: More than 30 days.

SELECT 
    ou.CustomerID,
    ou.Username,
    DATEDIFF(DAY, ou.LastLogin, GETDATE()) AS DaysSinceLastLogin,
    CASE 
        WHEN DATEDIFF(DAY, ou.LastLogin, GETDATE()) <= 7 THEN 'Active'
        WHEN DATEDIFF(DAY, ou.LastLogin, GETDATE()) BETWEEN 8 AND 30 THEN 'At Risk'
        ELSE 'Inactive'
    END AS EngagementStatus
FROM Digital_Banking_Payments.OnlineBankingUsers ou;
