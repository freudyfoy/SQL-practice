-- Windows Function

-- Basic
-- Aggregate Function
select 
	*,
	SUM(Sales) OVER(PARTITION BY ProductID) as TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) as TotalSalesStatus
from Sales.Orders;

-- Rank Function
select
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) as RankingSales
from Sales.Orders;

-- Frame clause
select
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) as TotalSales
from Sales.Orders;

------------------------------------------------------------------------------------------------------------

-- Advanced
-- Deep Dive: Aggregate Function
select
	OrderID,
	CustomerID,
	OrderDate,
	COUNT(*) OVER() as TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) as OrdersByCustomers
from Sales.Orders;

select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() as TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) as SalesByProduct,
	ROUND(CAST(Sales as float) / SUM(Sales) OVER() * 100, 2) as SalesInPercent,
	ROUND(CAST(SUM(Sales) OVER(PARTITION BY ProductID) as float) / SUM(Sales) OVER() * 100, 2) as SalesByProductInPercent
from Sales.Orders;

select 
*
from (
select
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER() as AVGSales
from Sales.Orders
)t where Sales > AVGSales;

------------------------------------------------------------------------------------------------------------

-- Deep Dive: Rank Function
select
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as SalesTestCases,
	RANK() OVER(ORDER BY Sales DESC) as RankingSales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) as DenseRankingSales
from Sales.Orders;-- Windows Function

-- Basic
-- Aggregate Function
select 
	*,
	SUM(Sales) OVER(PARTITION BY ProductID) as TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) as TotalSalesStatus
from Sales.Orders;

-- Rank Function
select
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) as RankingSales
from Sales.Orders;

-- Frame clause
select
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) as TotalSales
from Sales.Orders;

------------------------------------------------------------------------------------------------------------

-- Advanced
-- Deep Dive: Aggregate Function
select
	OrderID,
	CustomerID,
	OrderDate,
	COUNT(*) OVER() as TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) as OrdersByCustomers
from Sales.Orders;

select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() as TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) as SalesByProduct,
	ROUND(CAST(Sales as float) / SUM(Sales) OVER() * 100, 2) as SalesInPercent,
	ROUND(CAST(SUM(Sales) OVER(PARTITION BY ProductID) as float) / SUM(Sales) OVER() * 100, 2) as SalesByProductInPercent
from Sales.Orders;

select 
*
from (
select
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER() as AVGSales
from Sales.Orders
)t where Sales > AVGSales;

------------------------------------------------------------------------------------------------------------

-- Deep Dive: Rank Function
select
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as SalesTestCases,
	RANK() OVER(ORDER BY Sales DESC) as RankingSales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) as DenseRankingSales
from Sales.Orders;

select
	NTILE(2) OVER (ORDER BY Sales) as Buckets,
	*
from Sales.Orders;