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
