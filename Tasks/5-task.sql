with TransactionWithLag as (
    select 
        c.CustomerID,
        t.TransactionID,
        t.Amount,
        t.[Date] as TransactionDate,
        lag(t.[Date]) over (partition by c.CustomerID order by t.[Date]) as PreviousTransactionDate,
		lag(t.Amount) over (partition by c.CustomerID order by t.[Date]) as PreviousAmount
    from 
        Core_Banking.Customers c
        join Core_Banking.Accounts a on c.CustomerID = a.CustomerID
        join Core_Banking.Transactions t on a.AccountID = t.AccountID
    where 
        t.Amount > 10000
) 
select 
    CustomerID,
    TransactionID,
    Amount,
    TransactionDate,
    PreviousTransactionDate,
    DATEDIFF(MINUTE, PreviousTransactionDate, TransactionDate) as MinutesBetween
from 
    TransactionWithLag
where 
    PreviousTransactionDate IS NOT NULL
	AND PreviousAmount>10000
    AND DATEDIFF(MINUTE, PreviousTransactionDate, TransactionDate) < 60
order by 
    CustomerID, TransactionDate;


----- add column named country in Transaction table---

ALTER TABLE Core_Banking.Transactions
ADD Country VARCHAR(100);

UPDATE t
SET t.Country = b.Country
FROM Core_Banking.Transactions t
JOIN Core_Banking.Accounts a ON t.AccountID = a.AccountID
JOIN Core_Banking.Branches b ON a.BranchID = b.BranchID;
