--Identify the distribution of payment methods by merchant.

CREATE VIEW vw_MerchantPaymentMethodUsage AS
SELECT
    mt.MerchantID,
    me.MerchantName,
    mt.PaymentMethod,
    COUNT(mt.TransactionID) AS TxnCount,
    SUM(mt.Amount) AS TotalAmount
FROM Merchant_Services.MerchantTransactions mt
JOIN Merchant_Services.Merchants me ON mt.MerchantID = me.MerchantID
GROUP BY mt.MerchantID, me.MerchantName, mt.PaymentMethod;

select*from vw_MerchantPaymentMethodUsage
