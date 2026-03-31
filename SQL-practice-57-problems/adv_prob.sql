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
ORDER BY TotalOrderAmount DESC


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
HAVING SUM(OD.UnitPrice * OD.Quantity) >= 15000
ORDER BY TotalOrderAmount DESC


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
HAVING SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) >= 10000
ORDER BY TotalOrderAmount DESC


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
ORDER BY EmployeeID, OrderID


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
ORDER BY TotalItems DESC


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
ORDER BY OrderID


-- Q.39)


