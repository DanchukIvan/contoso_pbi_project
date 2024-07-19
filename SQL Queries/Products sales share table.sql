USE [Contoso 1M];

WITH ProductsSalesShareTemp
AS 
(SELECT [Order Year], [ProductKey], [Product Sales], 
(CAST([Product Sales] as real) / SUM([Product Sales]) OVER(PARTITION BY [Order Year] ORDER BY [Order Year]))*100 as [Sales Share, %]
FROM
(SELECT YEAR(ord.[Order Date]) as [Order Year], orr.[ProductKey],
ROUND(SUM([Unit Price]*[Quantity]),2) as [Product Sales]
FROM Data.[OrderRows] orr
LEFT JOIN Data.[Orders] ord ON orr.OrderKey = ord.OrderKey
GROUP BY YEAR(ord.[Order Date]), orr.[ProductKey]) sq),
ProductKpiFinal AS
(select ptmp.[Order Year], ptmp.[ProductKey], pr.Brand, ptmp.[Sales Share, %]
from ProductsSalesShareTemp ptmp
join Data.Product pr on pr.ProductKey = ptmp.ProductKey)

select * into Data.[ProductSalesShare] from ProductKpiFinal;