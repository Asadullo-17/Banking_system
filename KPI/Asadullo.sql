
--1-KPI. total amount according to the payment methods

select 
	PaymentMethod,
	sum(Amount) as total_amount
from Merchant_Services.MerchantTransactions
group by PaymentMethod
order by total_amount desc


--2-KPI. TOP 10 Merchants by their transacrion value
select top 10 MerchantID,
	sum(Amount) as total_amount
from Merchant_Services.MerchantTransactions 
group by MerchantID 
order by total_amount desc

--3-KPI. Gross Profit of Brokerage firms

select 
		BrokerageFirm,
		(sum(CurrentValue)-sum(TotalInvested)) as total_profit
  from Investments_Treasury.StockTradingAccounts
  group by BrokerageFirm
  order by total_profit desc
