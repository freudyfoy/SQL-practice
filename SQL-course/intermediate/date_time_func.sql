-- Date and Time Function 

-- Ex1: extraction part from date
select
YEAR(OrderDate) as YearOrder,
COUNT(*) as NoOrders
from Sales.Orders
group by YEAR(OrderDate);

-- Ex2: format date
select
FORMAT(OrderDate, 'dd/MM/yyyy') as Date_order
from Sales.Orders;

-- Ex3: custom date
select
OrderID,
'Day ' + FORMAT(CreationTime, 'ddd MMMM yyyy') +
' Qt' + DATENAME(quarter, CreationTime) + ' ' +
FORMAT(CreationTime, 'hh:mm:ss tt') as CustomFormat
from Sales.Orders;

-- Ex4: group by using customize format date
select
FORMAT(OrderDate, 'MMM yy') as OrderMonth,
COUNT(*) as NoOrder
from Sales.Orders
group by FORMAT(OrderDate, 'MMM yy');

-- Ex5: date calculation
select
OrderDate,
DATEADD(year, 2, OrderDate) as TwoYearLater
from Sales.Orders;

select
EmployeeID,
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) as Age
from Sales.Employees;

select
--OrderID,
MONTH(OrderDate) as OrderMonth,
--ShipDate,
AVG(DATEDIFF(day, OrderDate, ShipDate)) as ShipDuration
from Sales.Orders
group by MONTH(OrderDate);

select
OrderID,
OrderDate as CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) as PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) as NoDayOrder
from Sales.Orders

