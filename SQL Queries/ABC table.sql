USE [Contoso 1M];
GO


--create view Data.[Raw abc data] as
--select sq.[Order Date], sq.[OrderKey], sq.[ProductKey], 
--SUM([Order Revenue]) OVER(ORDER BY sq.[Order Date]) as [Total Sales],
--SUM([Order Revenue]) OVER(PARTITION BY sq.[ProductKey] ORDER BY sq.[Order Date], sq.[OrderKey]) as [Product total sales]
--from
--(select ord.[Order Date], ord.[OrderKey], orr.[ProductKey], sum(orr.[Unit Price] * orr.[Quantity]) as [Order Revenue]
--from Data.[Orders] ord
--join Data.[OrderRows] orr on ord.[OrderKey] = orr.[OrderKey]
--group by ord.[Order Date], ord.[OrderKey], orr.[ProductKey]) sq;
--GO

drop table if exists #temp_abc_table;
select * into #temp_abc_table from Data.[Raw abc data];
select * into Data.[ABC Table]
from
(select sq2.[Date], sq2.[Order Date], sq2.[OrderKey], sq2.[ProductKey],
ROUND([Running product sales] / [Total Sales], 2) as [Sales share],
CASE 
	WHEN ROUND([Running product sales] / [Total Sales], 2) <= 0.8 THEN 'A'
	WHEN 0.8 < ROUND([Running product sales] / [Total Sales], 2) 
	AND ROUND([Running product sales] / [Total Sales], 2) <= 0.95 THEN 'B'
	ELSE 'C' END as [ABC score]
from
(select dt.[Date], sq.[Order Date], sq.[OrderKey], sq.[ProductKey], 
SUM(sq.[Product total sales]) OVER(PARTITION BY dt.[Date] ORDER BY sq.[Product total sales] DESC) as [Running product sales],
SUM(sq.[Product total sales]) OVER(PARTITION BY dt.[Date]) as [Total Sales]
from Data.[Date] dt
cross apply
(select max(tat.[Order Date]) as [Order Date], max(tat.[OrderKey]) as [OrderKey], 
tat.[ProductKey], max(tat.[Product total sales]) as [Product total sales]
from #temp_abc_table tat where tat.[Order Date] <= dt.[Date]
group by [ProductKey]) sq) sq2) sq3;
drop table #temp_abc_table;