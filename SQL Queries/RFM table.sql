USE [Contoso 1M];

WITH rfm_raw AS
(select dt.[Date], sq.[CustomerKey], sq.[Order Date], sq3.[OrderKey], DATEDIFF(DAY, sq.[Order Date], dt.[Date]) as [Since last order],
ROUND(sq3.[Total client revenue],2) as [Total client revenue],
DENSE_RANK() OVER (PARTITION BY sq.[CustomerKey] ORDER BY sq3.[OrderKey]) as [Total client purch]
from Data.[Date] dt
cross apply (select ord.[CustomerKey], MAX(ord.[Order Date]) as [Order Date]
 from Data.[Orders] ord
 where ord.[Order Date]  <= dt.[Date]
 group by ord.[CustomerKey]
 ) sq
join 
(select [Order Date], [CustomerKey], sq2.[OrderKey],
SUM([Revenue by day]) OVER (PARTITION BY [CustomerKey] ORDER BY [Order Date], [OrderKey]) as [Total client revenue]
from
(select ord.[Order Date], ord.[OrderKey], ord.[CustomerKey], 
SUM(orr.[Total order revenue]) as [Revenue by day]
from Data.[Orders] ord
join 
(select orr.[OrderKey], sum(orr.[Unit Price] * orr.[Quantity]) as [Total order revenue] from Data.[OrderRows] orr
group by orr.[OrderKey]) orr
ON ord.[OrderKey] = orr.[OrderKey]
group by ord.[Order Date], ord.[CustomerKey], ord.OrderKey) sq2
) sq3 on sq.[Order Date] = sq3.[Order Date] and sq.[CustomerKey] = sq3.[CustomerKey])
,rfm_table AS
(select [Date], [CustomerKey], [OrderKey],
	NTILE(5) OVER (PARTITION BY [Date] ORDER BY [Since last order]) as [R],
	NTILE(5) OVER (PARTITION BY [Date] ORDER BY [Total client purch] DESC) as [F],
	NTILE(5) OVER (PARTITION BY [Date] ORDER BY [Total client revenue] DESC) as [M]
	from rfm_raw
)
,rfm_codes AS
(select [Date], [CustomerKey], [OrderKey], CONCAT([R],[F],[M]) as [RFM code]
	from rfm_table
)
select * into Data.[RFM table]
from rfm_codes;