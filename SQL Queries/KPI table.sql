WITH KPITargets ([Report Year], [Month Number], [Sales KPI])
AS
(SELECT distinct [Report Year], [Month Number], ROUND(COALESCE(Sales * (1 + LAG([Inflation Rate]) OVER(ORDER BY [Report Year])/100), Sales),2) as SalesKPI
FROM
(SELECT distinct dt.[Year] as [Report Year], dt.[Month Number], ir.[Inflation Rate], CAST(sq.[Sales] as float) as Sales
FROM Data.[Date] as dt
LEFT JOIN Data.[InFlationRates] ir ON dt.[Year] = YEAR(ir.[date])
LEFT JOIN
(SELECT YEAR(ord.[Order Date]) as order_year, SUM(orr.[Unit Price]*orr.[Quantity]) as Sales
FROM Data.[Orders] ord
JOIN Data.[OrderRows] orr ON ord.[OrderKey] = orr.[OrderKey]
GROUP BY YEAR(ord.[Order Date])) sq ON sq.order_year = dt.[Year]) sq2
WHERE Sales is not null)
select * into Data.[SalesKPI] from KPITargets