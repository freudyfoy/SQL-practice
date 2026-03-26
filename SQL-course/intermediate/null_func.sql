-- Null fuction

select
OrderID,
ShipAddress,
BillAddress,
ISNULL(BillAddress,ShipAddress) as FinalAdd
from Sales.Orders;

select
CustomerID,
Score,
AVG(Score) OVER() as AvgScore,
AVG(COALESCE(Score,0)) OVER() as AvgScore2
from Sales.Customers;

select
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, '') as FullName,
Score,
COALESCE(Score, 0) + 10 as ScoreWithBonus
from Sales.Customers;

select
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) as Price
from Sales.Orders;

/* anti join
select *
from Sales.Customers
WHERE Score is not null;

select 
c.*,
o.OrderID
from Sales.Customers as c
left join Sales.Orders as o
on c.CustomerID = o.CustomerID
where o.OrderID is null;
*/

-- Handle null and spaces
WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  ' UNION
SELECT 5, '  B  '
)

SELECT
*,
TRIM(Category) AS Policy1,
NULLIF(TRIM(Category), '') AS Policy2,
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;
