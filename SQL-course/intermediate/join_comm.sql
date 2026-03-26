select * from customers;
select * from orders;

-- left join
select 
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
left join orders
on id = customer_id; 

-- left anti join
select 
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
left join orders
on id = customer_id
where orders.order_id is null; 

-- full anti join
select
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
full join orders
on id = customer_id
where orders.order_id is null or customers.id is null;

-- Task: select customers that place orders but w/o use inner join
select
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
left join orders
on id = customer_id
where orders.order_id is not null;

-- cross join: combines every rows from left & right 
-- => all possible combinations (row A x row B)
select
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
cross join orders;



-- Task Advanced join
-- :Retrieve and join all information by displaying
-- Order ID, Customer's name, Product name, Sales, Price, Sales person's name

select
	o.OrderID,
	c.FirstName as Customer_Firstname,
	c.LastName as Customer_LastName,
	p.Product as Product_name,
	p.Category as Product_category,
	o.Sales,
	p.Price as Price,
	e.FirstName as SalesPerson_name
from Sales.Orders as o
left join Sales.Customers as c
on o.CustomerID = c.CustomerID
left join Sales.Products as p
on o.ProductID = p.ProductID
left join Sales.Employees as e
on o.SalesPersonID = e.EmployeeID;


/*select *
from Sales.Orders;
select *
from Sales.Customers;
select *
from Sales.Products;
select *
from Sales.Employees;*/


