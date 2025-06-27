----- View Table. Number of transactions processed each day/ Tracks customer activity/ Measures daily workload and helps in staffing or system capacity planning.-----
create view DailyTransactionVolume AS 
select 
    CAST([Date] as DATE) as TransactionDate,
    COUNT(*) as TotalTransactions
from 
    Core_Banking.Transactions
group by 
    CAST([Date] as DATE);

select * from DailyTransactionVolume
order by TransactionDate desc
