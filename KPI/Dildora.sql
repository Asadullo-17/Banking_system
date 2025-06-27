--#1
---/  Useful for compliance reports and technical performance monitoring/ Tracks service reliability and system stability over time

select 
    YEAR([Date]) as TransactionYear,
    COUNT(case when Status IN ('Failed') then 1 end) * 100.0 / COUNT(*) as FailureRatePercentage
from 
    Core_Banking.Transactions
where 
    [Date] >= DATEADD(YEAR, -1, DATEFROMPARTS(YEAR(GETDATE()), 1, 1)) -- from Jan 1 last year
    AND [Date] < DATEADD(YEAR, 1, DATEFROMPARTS(YEAR(GETDATE()), 1, 1)) -- until Dec 31 this year
group by 
    YEAR([Date])
order by 
    TransactionYear;


--#2
---(KPI) Count of Active Mobile Banking Users (last 30 days)/ Tracks how many users are actively engaging with mobile banking features./
---/ A declining number may signal disengagement or usability issues.

select 
    COUNT(distinct CustomerID) as ActiveMobileBankingUsers
from 
    staging.mobile_banking_transactions
where 
    [Date] >= DATEADD(DAY, -30, GETDATE());

--#3
----(KPI) Number of Active users per day/Shows how many users are consistently using digital channels on a daily basis/
----- / It tracks each day’s active customer base, based on recorded activity like transactions, BalanceCheck, BillPay or any interaction captured in system logs.

select
    CAST([Date] as DATE) as ActivityDate,
    COUNT(distinct CustomerID) as ActiveUsers
from 
    staging.mobile_banking_transactions
group by 
    CAST([Date] as DATE)
order by 
    ActivityDate desc
