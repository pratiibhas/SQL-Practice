use yt_interview_query;

-- ---------------------- USERS TABLE ------------------------------------------

-- q1 Write a SQL Query to fetch all the duplicate records in a table
--  Create the USERS table
CREATE TABLE USERS (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(30),
    email VARCHAR(50)
);

-- Step 2: Insert the data into the table
INSERT INTO USERS (user_id, user_name, email) VALUES
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');


select user_id, user_name,email from (
select *, row_number() over(partition by user_name,email) as rn from users)a 
where rn =2;


-- ---------------------- WEATHER TABLE ------------------------------------------

-- q2 fetch 'N' consecutive rows when temp is less than 0 
-- Table Structure:

create table if not exists weather
	(
		id 					int 				primary key,
		city 				varchar(50) not null,
		temperature int 				not null,
		day 				date				not null
	);


INSERT INTO weather (id, city, temperature, day) VALUES
  (1, 'London', -1, '2021-01-01'),
  (2, 'London', -2, '2021-01-02'),
  (3, 'London', 4, '2021-01-03'),
  (4, 'London', 1, '2021-01-04'),
  (5, 'London', -2, '2021-01-05'),
  (6, 'London', -5, '2021-01-06'),
  (7, 'London', -7, '2021-01-07'),
  (8, 'London', 5, '2021-01-08'),
  (9, 'London', -20, '2021-01-09'),
  (10, 'London', 20, '2021-01-10'),
  (11, 'London', 22, '2021-01-11'),
  (12, 'London', -1, '2021-01-12'),
  (13, 'London', -2, '2021-01-13'),
  (14, 'London', -2, '2021-01-14'),
  (15, 'London', -4, '2021-01-15'),
  (16, 'London', -9, '2021-01-16'),
  (17, 'London', 0, '2021-01-17'),
  (18, 'London', -10, '2021-01-18'),
  (19, 'London', -11, '2021-01-19'),
  (20, 'London', -12, '2021-01-20'),
  (21, 'London', -11, '2021-01-21');

-- When table does have a primary key
select * from weather;
with cte as(
select * ,id- row_number() over(order by id) as flag  from weather w
where w.temperature<0 
order by w.id),
cte2 as(
select *,count(flag) over(partition by flag) as cnt from cte )
select id, city,temperature from cte2 where cnt =5;

-- When table does not have a primary key
ALTER TABLE weather DROP COLUMN id;

select * from weather;
with rno as(
select *,row_number() over(order by null) as rn from weather),
cte as(select *,rn- row_number() over(order by rn) as flag from rno where temperature <0),
cte2 as(
select *,count(flag) over(partition by flag) as cnt from cte )
select  city,temperature from cte2 where cnt =4;

-- Query logic based on data field
with prev_day as(
select *, lag(day) over() as prev_day from weather),
with_id as(
select *, row_number() over(order by prev_day) as rn_id from prev_day),
grps as(
select *,(rn_id- row_number() over(order by rn_id))as flag from with_id where temperature<0),
cnts as(
select *, count(flag) over(partition by flag) as cnt from grps )
select city,temperature,day from cnts where cnt =3;


-- ---------------------- ORDERS TABLE ------------------------------------------

-- Query logic based on data field (On a different table)
-- Create the table
CREATE TABLE IF NOT EXISTS orders (
    order_id    VARCHAR(20) PRIMARY KEY,
    order_date  DATE NOT NULL
);

-- Clear previous data
DELETE FROM orders;

-- Insert data using MySQL-compatible date format
INSERT INTO orders (order_id, order_date) VALUES
  ('ORD1001', '2021-01-01'),
  ('ORD1002', '2021-02-01'),
  ('ORD1003', '2021-02-02'),
  ('ORD1004', '2021-02-03'),
  ('ORD1005', '2021-03-01'),
  ('ORD1006', '2021-06-01'),
  ('ORD1007', '2021-12-25'),
  ('ORD1008', '2021-12-26');

-- View results
SELECT * FROM orders;

-- Query to fetch N consecutive records
with cte as(
SELECT 
  *, 
  DATE_SUB(order_date, INTERVAL ROW_NUMBER() OVER (ORDER BY order_id) DAY) AS rn
FROM orders),
cnts as(
select *, count(rn) over(partition by rn) as cnt from cte )
select order_id,order_date from cnts where cnt=3



