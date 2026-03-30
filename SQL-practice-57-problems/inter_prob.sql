-- Intermediate Problems
-- Q.20) Categories, and the total products in each category
-- For this problem, we’d like to see the total number of products in each category. Sort the results by the total
-- number of products, in descending order.
SELECT
	Cat.CategoryName,
	COUNT(*) AS TotalProducts
FROM Products AS Prod
LEFT JOIN Categories AS Cat
ON Prod.CategoryID = Cat.CategoryID
GROUP BY Cat.CategoryName
ORDER BY TotalProducts DESC

-- Q.21) Total customers per country/city
-- In the Customers table, show the total number of customers per Country and City.
SELECT 
	Country,
	City,
	COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomers DESC

-- Q.22) Products that need reordering
-- What products do we have in our inventory that should be reordered? For now, just use the fields
-- UnitsInStock and ReorderLevel, where UnitsInStock is less than the ReorderLevel, ignoring the fields
-- UnitsOnOrder and Discontinued. Order the results by ProductID.
SELECT
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel
FROM Products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ProductID;

-- Q.23) Products that need reordering, continued
-- Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
-- into our calculation. We’ll define “products that need reordering” with the following:
-- UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel
-- The Discontinued flag is false (0).
SELECT
	ProductID,
	ProductName,
	UnitsInStock,
	UnitsOnOrder,
	ReorderLevel,
	Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
	and Discontinued = 0;

-- Q.24) Customer list by region
-- A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of
-- all customers, sorted by region, alphabetically.
-- However, he wants the customers with no region (null in the Region field) to be at the end, instead of
-- at the top, where you’d normally find the null values.
-- Within the same region, companies should be sorted by CustomerID.
SELECT
	CustomerID,
	CompanyName,
	Region	
FROM Customers
ORDER BY CASE
			WHEN Region IS NULL THEN 1
			ELSE 0
		 END,
		Region,
		CustomerID;

-- Q.25) High freight charges
-- Some of the countries we ship to have very high freight charges. We'd like to investigate some more
-- shipping options for our customers, to be able to offer them lower freight charges. Return the three ship
-- countries with the highest average freight overall, in descending order by average freight.
SELECT	TOP 3
	ShipCountry,
	AVG(Freight) AS AverageFreight
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- Q.26) High freight charges - 2015
-- We're continuing on the question above on high freight charges. Now, instead of using all the orders
-- we have, we only want to see orders from the year 2015.
SELECT	TOP 3
	ShipCountry,
	AVG(Freight) AS AverageFreight
FROM Orders
WHERE CAST(OrderDate AS DATE) >= '2015-01-01' 
	AND CAST(OrderDate AS DATE) < '2016-01-01'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- Q.28) High freight charges - last year
-- We're continuing to work on high freight charges. We now want to get the three ship countries with the
-- highest average freight charges. But instead of filtering for a particular year, we want to use the last
-- 12 months of order data, using as the end date the last OrderDate in Orders.
SELECT	TOP 3
	 ShipCountry,
	AVG(Freight) AS AverageFreight
FROM Orders
WHERE CAST(OrderDate AS DATE) >= DATEADD(yy, -1, (SELECT MAX(OrderDate) FROM Orders))
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- Q.29) Inventory list
-- We're doing inventory, and need to show information
-- like the below, for all orders. Sort by OrderID and Product ID.
SELECT
	O.EmployeeID,
	E.LastName,
	O.OrderID,
	P.ProductName,
	OD.Quantity
FROM Orders AS O
LEFT JOIN Employees AS E
	ON O.EmployeeID = E.EmployeeID
LEFT JOIN OrderDetails AS OD
	ON O.OrderID = OD.OrderID
LEFT JOIN Products AS P
	ON OD.ProductID = P.ProductID
ORDER BY O.OrderID


-- Q.30) Customers with no orders
-- There are some customers who have never actually placed an order. Show these customers.
SELECT
	C.CustomerID,
	O.OrderID
FROM Customers AS C
LEFT JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL

-- Q.31) Customers with no orders for EmployeeID 4
-- One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. However, there are some
-- customers who've never placed an order with her.
-- Show only those customers who have never placed an order with her.
WITH EmployeeNo4 AS(
	SELECT *
	FROM Orders
	WHERE EmployeeID = 4
)
SELECT 
	C.CustomerID,
	E.EmployeeID
FROM Customers AS C
LEFT JOIN EmployeeNo4 AS E
ON C.CustomerID = E.CustomerID
WHERE E.EmployeeID IS NULL
ORDER BY CustomerID

-- Select
-- Customers.CustomerID,
-- Orders.CustomerID
-- From Customers
-- left join Orders
-- on Orders.CustomerID = Customers.CustomerID
-- and Orders.EmployeeID = 4
-- Where Orders.CustomerID is null
-- ORDER BY Customers.CustomerID







