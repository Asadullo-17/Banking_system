--6. Customers who have made transactions from different countries within 10 minutes, a common red flag for fraud.

SELECT 
    DISTINCT c.CustomerID,
    c.FullName,
    t1.TransactionID AS Transaction1,
    t2.TransactionID AS Transaction2,
    t1.Amount AS Amount1,
    t2.Amount AS Amount2,
    t1.Date AS Date1,
    t2.Date AS Date2
FROM Core_Banking.Customers c
JOIN Core_Banking.Accounts as a1 on c.CustomerID=a1.CustomerID
JOIN Core_Banking.Transactions as t1 on a1.AccountID=t1.AccountID
JOIN Core_Banking.Accounts as a2 on a2.CustomerID=c.CustomerID
JOIN Core_Banking.Transactions as t2 on a2.AccountID=t2.AccountID
WHERE
	t1.TransactionID <> t2.TransactionID
    AND t1.Amount>10000
	AND t2.Amount>10000
    AND ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) <= 60;
