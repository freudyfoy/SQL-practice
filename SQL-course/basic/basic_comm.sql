select * from customers

--insert into customers (id, first_name)
--values (7,'Somchai')

--copy data from the table to another one
/*
insert into persons (id, person_name, birth_date, phone)
select
	id,
	first_name,
	NULL,
	'Unknown'
from customers
select * from persons 
*/

--update customers
--set score = 0
--where score is NULL

--delete from customers
--where id > 5

--TRUNCATE TABLE persons
--SELECT * FROM persons