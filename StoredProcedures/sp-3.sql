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
