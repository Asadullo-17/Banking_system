--overall performance by sellers — number of transactions, total amount, and average payment.
CREATE VIEW vw_MerchantPerformanceSummary AS
SELECT 
    m.MerchantID,
    m.MerchantName,
    m.Industry,
    COUNT(mt.TransactionID) AS TotalTransactions,
    SUM(mt.Amount) AS TotalRevenue,
    AVG(mt.Amount) AS AvgTransactionValue
FROM Merchant_Services.Merchants m
JOIN Merchant_Services.MerchantTransactions mt ON m.MerchantID = mt.MerchantID
GROUP BY m.MerchantID, m.MerchantName, m.Industry;

select*from vw_MerchantPerformanceSummary
