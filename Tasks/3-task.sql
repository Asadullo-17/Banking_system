--3.Transactions That Were Flagged as Fraudulent

SELECT 
    f.FraudID,
    f.CustomerID,
    c.FullName,
    f.TransactionID,
    f.RiskLevel,
    f.ReportedDate
FROM staging.fraud_detection f
JOIN Core_Banking.Customers c ON f.CustomerID = c.CustomerID
WHERE f.RiskLevel IN ('High','Critical')
ORDER BY f.RiskLevel DESC, f.ReportedDate DESC;
