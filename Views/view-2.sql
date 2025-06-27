----View Table. The percentage of daily transactions that failed

create view DailyFailedTransactionRate as
select 
    CAST(Date as DATE) as TransactionDate,
    COUNT(case when Status IN ('Failed') then 1 end) * 100.0 / COUNT(*) as FailedTransactionRate
from 
    Core_Banking.Transactions
group by 
    CAST(Date as DATE);

Select * from DailyFailedTransactionRate as dft
order by TransactionDate desc
