use practice_med;

-- Create tables
CREATE TABLE department (
    dep_id INT,
    dep_name VARCHAR(50)
);

CREATE TABLE empdetails (
    emp_id INT,
    first_name VARCHAR(50),
    gender VARCHAR(1),
    dep_id INT
);

CREATE TABLE client (
    client_id INT,
    client_name VARCHAR(50)
);

CREATE TABLE empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert data
INSERT INTO department (dep_id, dep_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

INSERT INTO empdetails (emp_id, first_name, gender, dep_id) VALUES
(101, 'Alice', 'F', 1),
(102, 'Bob', 'M', 1),
(103, 'Charlie', 'M', 2),
(104, 'Diana', 'F', 2),
(105, 'Ethan', 'M', 3),
(106, 'Fiona', 'F', 3);

INSERT INTO client (client_id, client_name) VALUES
(1, 'Amazon'),
(2, 'Walmart'),
(3, 'Costco'),
(4, 'Target'),
(5, 'BestBuy');

INSERT INTO empsales (emp_id, client_id, sales) VALUES
(101, 1, 5000),
(101, 2, 3000),
(102, 1, 7000),
(102, 3, 2000),
(103, 2, 4000),
(103, 4, 3000),
(104, 4, 6000),
(105, 5, 8000),
(106, 3, 5000),
(106, 5, 2000);


SELECT * FROM empsales;
SELECT * FROM client;
SELECT * FROM department;
SELECT * FROM empdetails;

-- Find the best employee(who did the most sales) and the best client (who has givemn most sales to department) of each department.\
with cte as(
select es.*,d.dep_name,d.dep_id,e.first_name,e.gender from empsales  as es
inner join empdetails as  e
on es.emp_id = e.emp_id
inner join department as  d
on e.dep_id=d.dep_id),
sum_sales as(
select dep_id,emp_id, sum(sales) as total_sales
from  cte 
group by 1,2
),best_sales as(
select *, row_number() over(partition by dep_id order by total_sales desc)  as rn
from sum_sales),
best_emp as(
select dep_id,emp_id,total_sales from best_sales
where rn =1),


sum_clients as(
select dep_id,client_id, sum(sales) as total_sales
from  cte 
group by 1,2
),best_clients as(
select *, row_number() over(partition by dep_id order by total_sales desc)  as rn
from sum_clients),
best_client as(
select dep_id,client_id,total_sales from best_clients
where rn =1)


select c.dep_id,client_id, emp_id
from best_client c
inner join best_emp e
on c.dep_id = e.dep_id;


-- Modified query
with cte as(
select es.*,d.dep_name,d.dep_id,e.first_name,e.gender from empsales  as es
inner join empdetails as  e
on es.emp_id = e.emp_id
inner join department as  d
on e.dep_id=d.dep_id),

sum_sales as(
select dep_id,emp_id,'emp' as saletype, sum(sales) as sales
from  cte 
group by 1,2
union all
select dep_id,client_id,'client' as saletype,  sum(sales) as client_sales
from  cte 
group by 1,2
) 

select dep_id,
max(case when saletype ='client' then emp_id  end )as client_id,
max(case when saletype ='emp' then emp_id end )as emp_id
from (
select *, row_number() over(partition by dep_id,saletype order by sales desc)  as rn
from  sum_sales) a
where rn =1
group by 1