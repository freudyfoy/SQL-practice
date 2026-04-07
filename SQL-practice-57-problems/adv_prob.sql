-- Advance Problems
-- Q.32) High-value customers
-- We want to send all of our high-value customers a special VIP gift. We're defining high-value customers
-- as those who've made at least 1 order with a total value (not including the discount) equal to $10,000 or
-- more. We only want to consider orders made in the year 2016.
SELECT
	OD.OrderID,
	O.CustomerID,
	C.CompanyName,
	SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount
FROM OrderDetails AS OD
LEFT JOIN Orders AS O
	ON OD.OrderID = O.OrderID
LEFT JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
WHERE CAST(O.OrderDate AS DATE) >= '2016-01-01' 
	AND CAST(O.OrderDate AS DATE) < '2017-01-01'
GROUP BY OD.OrderID, O.CustomerID, C.CompanyName
HAVING SUM(OD.UnitPrice * OD.Quantity) >= 10000
ORDER BY TotalOrderAmount DESC;


-- Q.33) High-value customers - total orders
-- The manager has changed his mind. Instead of requiring that customers have at least one individual
-- orders totaling $10,000 or more, he wants to define high-value customers as those who have orders
-- totaling $15,000 or more in 2016. How would you change the answer to the problem above?
SELECT
	--OD.OrderID,
	O.CustomerID,
	C.CompanyName,
	SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount
FROM OrderDetails AS OD
LEFT JOIN Orders AS O
	ON OD.OrderID = O.OrderID
LEFT JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
WHERE CAST(O.OrderDate AS DATE) >= '2016-01-01' 
	AND CAST(O.OrderDate AS DATE) < '2017-01-01'
GROUP BY O.CustomerID, C.CompanyName
HAVING SUM(OD.UnitPrice * OD.Quantity) > 15000
ORDER BY TotalOrderAmount DESC;


-- Q.34) High-value customers - with discount
-- Change the above query to use the discount when calculating high-value customers. Order by the total
-- amount which includes the discount.
SELECT
	--OD.OrderID,
	O.CustomerID,
	C.CompanyName,
	SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) AS TotalOrderAmount
FROM OrderDetails AS OD
LEFT JOIN Orders AS O
	ON OD.OrderID = O.OrderID
LEFT JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
WHERE CAST(O.OrderDate AS DATE) >= '2016-01-01' 
	AND CAST(O.OrderDate AS DATE) < '2017-01-01'
GROUP BY O.CustomerID, C.CompanyName
HAVING SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) > 10000
ORDER BY TotalOrderAmount DESC;


-- Q.35) Month-end orders
-- At the end of the month, salespeople are likely to try much harder to get orders, to meet their month-end
-- quotas. Show all orders made on the last day of the month. Order by EmployeeID and OrderID
WITH CalculatedData AS (
SELECT
	EmployeeID,
	OrderID,
	OrderDate,
	CASE
		WHEN MONTH(CAST(OrderDate AS DATE)) IN (1,3,5,7,8,10,12) AND DAY(CAST(OrderDate AS DATE)) = 31 
			THEN 1
		WHEN MONTH(CAST(OrderDate AS DATE)) IN (4,6,9,11) AND DAY(CAST(OrderDate AS DATE)) = 30
			THEN 1
		WHEN MONTH(CAST(OrderDate AS DATE)) IN (2) AND DAY(CAST(OrderDate AS DATE)) IN (28,29)
			THEN 1
		ELSE 0
	END AS Flag_EOM
FROM Orders
) 
SELECT 
	EmployeeID,
	OrderID,
	OrderDate 
	FROM CalculatedData
WHERE Flag_EOM = 1
ORDER BY EmployeeID, OrderID;
-- Answer:
/* Select
		EmployeeID
		,OrderID
		,OrderDate
From Orders
Where OrderDate = EOMONTH(OrderDate )
Order by EmployeeID,OrderID
*/


-- Q.36) Orders with many line items
-- The Northwind mobile app developers are testing an app that customers will use to show orders. In order
-- to make sure that even the largest orders will show up correctly on the app, they'd like some samples of
-- orders that have lots of individual line items. Show the 10 orders with the most line items, in order of
-- total line items.
SELECT	TOP 10
	O.OrderID,
	COUNT(DISTINCT(ProductID)) AS TotalItems
FROM Orders AS O
LEFT JOIN OrderDetails AS OD
	ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
ORDER BY TotalItems DESC;


-- Q.37) Orders - random assortment
-- The Northwind mobile app developers would now like to just get a random assortment of orders for beta
-- testing on their app. Show a random set of 2% of all orders.
SELECT TOP 2 PERCENT 
	*
FROM Orders
ORDER BY NEWID();


-- Q.38) Orders - accidental double-entry
-- Janet Leverling has come to you with a request. She thinks that she accidentally
-- double-entered a line item on an order, with a different ProductID, but the same quantity. She
-- remembers that the quantity was 60 or more. Show all the OrderIDs with line items that match this, in
-- order of OrderID.
SELECT
	OrderID,
	Quantity,
	COUNT(*) AS DiffProdID
	--ProductID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1
ORDER BY OrderID;


-- Q.39) Orders - accidental double-entry details
-- Based on the previous question, we now want to show details of the order, 
-- for orders that match the above criteria.
WITH Criteria AS (
SELECT	TOP 10
	OrderID,
	Quantity,
	COUNT(*) AS DiffProdID
	--ProductID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1
-- ORDER BY OrderID
)
Select
	*
from OrderDetails
where OrderID in (Select OrderID from Criteria)
ORDER BY OrderID, Quantity;


-- Q.40) PotentialProblemOrders
Select DISTINCT
	OrderDetails.OrderID,
	ProductID,
	UnitPrice,
	OrderDetails.Quantity,
	Discount
From OrderDetails
Join (
	Select
		OrderID,
		Quantity
	From OrderDetails
	Where Quantity >= 60
	Group By OrderID, Quantity
	Having Count(*) > 1
) PotentialProblemOrders
on PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order by OrderDetails.OrderID, ProductID;


-- Q.41) Late orders
-- Some customers are complaining about their orders 1arriving late. Which orders are late?
SELECT 
	OrderID,
	RequiredDate,
	ShippedDate
FROM Orders
WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE);


-- Q.42) Late orders - which employees?
-- Some salespeople have more orders arriving late than others. Maybe they're not following up on the order
-- process, and need more training. Which salespeople have the most orders arriving late?
WITH LateOrders AS(
SELECT 
	OrderID,
	EmployeeID,
	RequiredDate,
	ShippedDate
FROM Orders
WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE)
)
SELECT
	E.EmployeeID,
	E.LastName,
	COUNT(*) AS TotalLateOrders
FROM Employees AS E
JOIN LateOrders AS L
	ON E.EmployeeID = L.EmployeeID
GROUP BY E.EmployeeID, E.LastName
ORDER BY TotalLateOrders DESC;


-- Q.43) Late orders vs. total orders
-- Andrew has been doing some more thinking some more about the problem of late orders.
-- He realizes that just looking at the number of orders arriving late for each salesperson isn't a good idea. 
-- It needs to be compared against the total number of orders per salesperson.
WITH 
	LateOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalLateOrders
		FROM Orders
		WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE)
		GROUP BY EmployeeID
	),
	AllOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalOrders
		FROM Orders
		GROUP BY EmployeeID
	)
SELECT
	Em.EmployeeID,
	Em.LastName,
	TotalOrders,
	TotalLateOrders
FROM Employees AS Em
INNER JOIN LateOrders AS L
	ON Em.EmployeeID = L.EmployeeID
INNER JOIN AllOrders AS A
	ON Em.EmployeeID = A.EmployeeID
ORDER BY Em.EmployeeID;


-- Q.44) Late orders vs. total orders - missing employee
-- There's an employee missing in the answer from the
-- problem above. Fix the SQL to show all employees who have taken orders.
WITH 
	LateOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalLateOrders
		FROM Orders
		WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE)
		GROUP BY EmployeeID
	),
	AllOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalOrders
		FROM Orders
		GROUP BY EmployeeID
	)
SELECT
	Em.EmployeeID,
	Em.LastName,
	TotalOrders,
	TotalLateOrders
FROM Employees AS Em
LEFT JOIN LateOrders AS L
	ON Em.EmployeeID = L.EmployeeID
LEFT JOIN AllOrders AS A
	ON Em.EmployeeID = A.EmployeeID
ORDER BY Em.EmployeeID;


-- Q.45) Late orders vs. total orders - fix null
-- Continuing on the answer for above query, let's fix
-- the results for row 5 - Buchanan. He should have a 0 instead of a Null in LateOrders.
WITH 
	LateOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalLateOrders
		FROM Orders
		WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE)
		GROUP BY EmployeeID
	),
	AllOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalOrders
		FROM Orders
		GROUP BY EmployeeID
	)
SELECT
	Em.EmployeeID,
	Em.LastName,
	TotalOrders,
	ISNULL(TotalLateOrders, 0) AS TotalLateOrders
FROM Employees AS Em
LEFT JOIN LateOrders AS L
	ON Em.EmployeeID = L.EmployeeID
LEFT JOIN AllOrders AS A
	ON Em.EmployeeID = A.EmployeeID
ORDER BY Em.EmployeeID;


-- Q.46) Late orders vs. total orders - percentage
-- Now we want to get the percentage of late orders over total orders.
-- And cut the PercentLateOrders off at 2 digits to the right of the decimal point.
WITH 
	LateOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalLateOrders
		FROM Orders
		WHERE CAST(ShippedDate AS DATE) >= CAST(RequiredDate AS DATE)
		GROUP BY EmployeeID
	),
	AllOrders AS (
		SELECT 
			EmployeeID,
			COUNT(*) AS TotalOrders
		FROM Orders
		GROUP BY EmployeeID
	)
SELECT
	Em.EmployeeID,
	Em.LastName,
	TotalOrders,
	ISNULL(TotalLateOrders, 0) AS SumLateOrders,
	ROUND(CAST(CAST(ISNULL(TotalLateOrders, 0) AS FLOAT) / CAST(TotalOrders AS FLOAT) AS FLOAT), 2) AS PercentLateOrders
FROM Employees AS Em
LEFT JOIN LateOrders AS L
	ON Em.EmployeeID = L.EmployeeID
LEFT JOIN AllOrders AS A
	ON Em.EmployeeID = A.EmployeeID
ORDER BY Em.EmployeeID;


-- Q.48) Customer grouping
-- Andrew Fuller would like to do a sales campaign for existing customers.
-- He'd like to categorize customers into groups, based on how much they ordered in 2016.
-- Then, depending on which group the customer is in, he will target the customer with different sales materials.
-- The customer grouping categories are 0 - 1,000, 1,000 - 5,000, 5,000 - 10,000, and over 10,000.
-- A good starting point for this query is the answer
-- from the problem “High-value customers - total orders". We don’t want to show customers who don’t
-- have any orders in 2016. Order the results by CustomerID.
SELECT
	O.CustomerID,
	C.CompanyName,
	SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount,
	CASE
		WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 0 AND SUM(OD.UnitPrice * OD.Quantity) < 1000
			THEN 'Low'
		WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 1000 AND SUM(OD.UnitPrice * OD.Quantity) < 5000
			THEN 'Medium'
		WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 5000 AND SUM(OD.UnitPrice * OD.Quantity) < 10000
			THEN 'High'
		WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 10000
			THEN 'Very High' 
	END AS CustomerGroup
FROM OrderDetails AS OD
LEFT JOIN Orders AS O
	ON OD.OrderID = O.OrderID
LEFT JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
GROUP BY O.CustomerID, C.CompanyName
ORDER BY O.CustomerID;


-- Q.49) Customer grouping - fix null
-- There's a bug with the answer for the previous question. 
-- The CustomerGroup value for one of the rows is null.
-- Fix the SQL so that there are no nulls in the CustomerGroup field.
WITH CustGrp AS(	
	SELECT
		O.CustomerID,
		C.CompanyName,
		SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount,
		CASE
			WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 0 AND SUM(OD.UnitPrice * OD.Quantity) < 1000
				THEN 'Low'
			WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 1000 AND SUM(OD.UnitPrice * OD.Quantity) < 5000
				THEN 'Medium'
			WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 5000 AND SUM(OD.UnitPrice * OD.Quantity) < 10000
				THEN 'High'
			WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 10000
				THEN 'Very High' 
		END AS CustomerGroup
	FROM OrderDetails AS OD
	LEFT JOIN Orders AS O
		ON OD.OrderID = O.OrderID
	LEFT JOIN Customers AS C
		ON O.CustomerID = C.CustomerID
	WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
	GROUP BY O.CustomerID, C.CompanyName
	--ORDER BY O.CustomerID
)
SELECT
	*
FROM CustGrp;

-- Q.50)Customer grouping with percentage
-- Based on the above query, show all the defined CustomerGroups, and the percentage in each. 
-- Sort by the total in each group, in descending order.
WITH 
	CustomerGrouping AS (	
		SELECT
			O.CustomerID,
			C.CompanyName,
			SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount,
			CASE
				WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 0 AND SUM(OD.UnitPrice * OD.Quantity) < 1000
					THEN 'Low'
				WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 1000 AND SUM(OD.UnitPrice * OD.Quantity) < 5000
					THEN 'Medium'
				WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 5000 AND SUM(OD.UnitPrice * OD.Quantity) < 10000
					THEN 'High'
				WHEN  SUM(OD.UnitPrice * OD.Quantity) >= 10000
					THEN 'Very High' 
			END AS CustomerGroup
		FROM OrderDetails AS OD
		LEFT JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		LEFT JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
		WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
		GROUP BY O.CustomerID, C.CompanyName
		--ORDER BY O.CustomerID
	)
SELECT
	CustomerGroup,
	COUNT(*) AS TotalInGroup, 
	COUNT(*) * 1.0/ (SELECT COUNT(*) FROM CustomerGrouping) AS PercentageInGroup
FROM CustomerGrouping
GROUP BY CustomerGroup
ORDER BY TotalInGroup DESC;


-- Q.51) Customer grouping - flexible
-- Andrew thinking about how best to group customers, and define low, medium, high, and very high value customers. He now wants
-- complete flexibility in grouping the customers, based on the dollar amount they've ordered. He doesn’t
-- want to have to edit SQL in order to change the boundaries of the customer groups.
-- How would you write the SQL?
-- There's a table called CustomerGroupThreshold that you will need to use. Use only orders from 2016.
WITH 
	Customer2016 AS (	
		SELECT
			O.CustomerID,
			C.CompanyName,
			SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderAmount
		FROM OrderDetails AS OD
		LEFT JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		LEFT JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
		WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
		GROUP BY O.CustomerID, C.CompanyName
	)

SELECT
	CustomerID,
	CompanyName,
	CustomerGroupName
FROM Customer2016
JOIN CustomerGroupThresholds
	ON TotalOrderAmount BETWEEN CustomerGroupThresholds.RangeBottom AND CustomerGroupThresholds.RangeTop
ORDER BY CustomerID;


-- Q.52) Countries with suppliers or customers
-- Some Northwind employees are planning a business trip, and would like to visit as many suppliers and
-- customers as possible. For their planning, they’d like to see a list of all countries where suppliers and/or
-- customers are based.
SELECT Country FROM Customers
UNION
SELECT Country FROM Suppliers;


-- Q.53) Countries with suppliers or customers, version 2
-- The employees going on the business trip don’t want just a raw list of countries, they want more details.
WITH
	CustomerCountry AS (
	SELECT 
		DISTINCT Customers.Country
	FROM Customers
	),
	SupplierCountry AS (
	SELECT
		DISTINCT Country
	FROM Suppliers
	)
SELECT 
	SupplierCountry.Country AS SupplierCountry,
	CustomerCountry.Country AS CustomerCountry
From SupplierCountry
Full Outer Join CustomerCountry
ON CustomerCountry.Country = SupplierCountry.Country


-- Q.54) Countries with suppliers or customers - version 3
-- The output of the above is improved, but it’s still not ideal
-- What we’d really like to see is the country name, the total suppliers, and the total customers.
WITH
	CustomerCountry AS (
	SELECT 
		Country,
		COUNT(*) AS TotalCustomers
	FROM Customers
	GROUP BY Country
	),
	SupplierCountry AS (
	SELECT
		Country,
		COUNT(*) AS TotalSuppliers
	FROM Suppliers
	GROUP BY Country
	)
SELECT 
	ISNULL(SupplierCountry.Country,CustomerCountry.Country) AS Country,
	ISNULL(TotalSuppliers,0) AS TotalSuppliers, 
	ISNULL(TotalCustomers,0) AS TotalCustomers
From SupplierCountry
Full OUTER JOIN CustomerCountry
ON CustomerCountry.Country = SupplierCountry.Country


-- Q.55) First order in each country
-- Looking at the Orders table—we’d like to show details for each order that was the first in that
-- particular country, ordered by OrderID.
-- So, we need one row per ShipCountry, and CustomerID, OrderID, and OrderDate should be of
-- the first order from that country.
WITH Part AS (
SELECT
	CustomerID,
	OrderID,
	CAST(OrderDate AS DATE) AS OrderDate,
	ShipCountry,
	ROW_NUMBER() OVER (PARTITION BY ShipCountry ORDER BY OrderDate) AS row_num
FROM Orders
)
SELECT
	ShipCountry,
	CustomerID,
	OrderID,
	OrderDate	
FROM Part
WHERE row_num = 1
ORDER BY ShipCountry


-- Q.56) Customers with multiple orders in 5 day period
-- There are some customers for whom freight is a major expense when ordering from Northwind.
-- However, by batching up their orders, and making one larger order instead of multiple smaller orders in
-- a short period of time, they could reduce their freight costs significantly.
-- Show those customers who have made more than 1 order in a 5 day period. The sales people will use this to help customers reduce their costs.
-- Note: There are more than one way of solving this kind of problem. For this problem, we will not be using Window functions.
WITH CalDatediff AS (
	SELECT
		InitialOrder.CustomerID,
		InitialOrder.OrderID AS InitialOrderID,
		InitialOrder.OrderDate AS InitialOrderDate,
		NextOrder.OrderID AS NextOrderID,
		NextOrder.OrderDate AS NextOrderDate,
		DATEDIFF(dd, InitialOrder.OrderDate,NextOrder.OrderDate) AS DaysBetween
	FROM Orders InitialOrder
	JOIN Orders NextOrder
	ON InitialOrder.CustomerID = NextOrder.CustomerID
	WHERE InitialOrder.OrderID < NextOrder.OrderID
)
SELECT * 
FROM CalDatediff
WHERE DaysBetween <= 5
ORDER BY CustomerID,InitialOrderID


-- Q.57) Customers with multiple orders in 5 day period, version 2
-- There’s another way of solving the problem above, using Window functions.
WITH NextOrderData AS ( 
SELECT
	CustomerID,
	CONVERT(date, OrderDate) AS OrderDate,
	NextOrderDate = CONVERT(date, Lead(OrderDate,1)
						OVER (Partition by CustomerID order by CustomerID,OrderDate)
	)
FROM Orders
)
SELECT
	CustomerID,
	OrderDate,
	NextOrderDate,
	DATEDIFF(dd, OrderDate, NextOrderDate) AS DaysBetween
FROM NextOrderData
WHERE DATEDIFF(dd, OrderDate, NextOrderDate) <= 5
ORDER BY CustomerID, OrderDate