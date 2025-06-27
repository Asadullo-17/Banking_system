--#1


	------SP getting high value transactions------

create procedure sp_GetHighValueTransactions1
    @AmountThreshold decimal(18,2) = 10000
as
begin
    select c.CustomerID,
	       c.FullName,
	       t.TransactionID,
	       t.AccountID,
		   t.TransactionType,
		   t.Amount,
		   t.Currency,
		   t.Date,
		   t.Status
    from Core_Banking.Transactions t
	join Core_Banking.Accounts a 
	on t.AccountID=a.AccountID
	join Core_Banking.Customers c
	on a.CustomerID=c.CustomerID
    where Amount >= @AmountThreshold;
end;

exec sp_GetHighValueTransactions1 @AmountThreshold = 9999;


