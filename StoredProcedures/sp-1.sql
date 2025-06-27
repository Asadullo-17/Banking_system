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


--#2

--Identifing customers who frequently use mobile or online banking, perform high-value transactions, and have low investments — these are high-risk customers (a potential fraud indicator).



CREATE PROCEDURE sp_HighRiskCustomer
AS
BEGIN
    SELECT
        c.CustomerID,
        ISNULL(mb.TotalMobileTxns, 0) AS MobileTxnCount,
        ISNULL(ob.TotalLogins, 0) AS OnlineLoginCount,
        ISNULL(st.CurrentValue, 0) AS InvestmentValue,
        ISNULL(mt.TotalMerchantSpend, 0) AS MerchantSpending,
        CASE 
            WHEN ISNULL(st.CurrentValue, 0) < 1000 AND ISNULL(mt.TotalMerchantSpend, 0) > 10000 THEN 'High Risk'
            ELSE 'Normal'
        END AS RiskLevel
    FROM (SELECT DISTINCT CustomerID FROM Digital_Banking_Payments.MobileBankingTransactions
          UNION
          SELECT DISTINCT CustomerID FROM Digital_Banking_Payments.OnlineBankingUsers) c
    LEFT JOIN (
        SELECT CustomerID, COUNT(*) AS TotalMobileTxns
        FROM Digital_Banking_Payments.MobileBankingTransactions
        GROUP BY CustomerID
    ) mb ON c.CustomerID = mb.CustomerID
    LEFT JOIN (
        SELECT CustomerID, COUNT(*) AS TotalLogins
        FROM Digital_Banking_Payments.OnlineBankingUsers
        GROUP BY CustomerID
    ) ob ON c.CustomerID = ob.CustomerID
    LEFT JOIN (
        SELECT CustomerID, SUM(CurrentValue) AS CurrentValue
        FROM Investments_Treasury.StockTradingAccounts
        GROUP BY CustomerID
    ) st ON c.CustomerID = st.CustomerID
    LEFT JOIN (
        SELECT me.CustomerID, SUM(mt.Amount) AS TotalMerchantSpend
        FROM Merchant_Services.MerchantTransactions mt
        JOIN Merchant_Services.Merchants me ON mt.MerchantID = me.MerchantID
        GROUP BY me.CustomerID
    ) mt ON c.CustomerID = mt.CustomerID
END;

execute sp_HighRiskCustomer

--#3

--Generating an overall activity report for each merchant: number of transactions, distribution of payment methods, and the most active month.



CREATE PROCEDURE sp_MerchantActivitySummary
AS
BEGIN
    WITH PaymentBreakdown AS (
        SELECT 
            MerchantID,
            STRING_AGG(
                PaymentMethod + ': ' + CAST(TransactionCount AS VARCHAR), ', '
            ) AS PaymentMethodBreakdown
        FROM (
            SELECT 
                MerchantID,
                PaymentMethod,
                COUNT(*) AS TransactionCount
            FROM Merchant_Services.MerchantTransactions
            GROUP BY MerchantID, PaymentMethod
        ) AS sub
        GROUP BY MerchantID
    )
	SELECT
        m.MerchantID,
        m.MerchantName,
        m.Industry,
        COUNT(mt.TransactionID) AS TotalTransactions,
        SUM(mt.Amount) AS TotalSales,
        CONVERT(char(7), MAX(mt.Date), 120) AS LastActiveMonth,
        pb.PaymentMethodBreakdown
    FROM Merchant_Services.Merchants m
    LEFT JOIN Merchant_Services.MerchantTransactions mt 
        ON m.MerchantID = mt.MerchantID
    LEFT JOIN PaymentBreakdown pb 
        ON m.MerchantID = pb.MerchantID
    GROUP BY 
        m.MerchantID, 
        m.MerchantName, 
        m.Industry, 
        pb.PaymentMethodBreakdown
END;
EXECUTE sp_MerchantActivitySummary
