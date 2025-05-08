-- recommendation system based on- product pairs most commonly purchased together
use practice;create table am_orders
(
order_id int,
customer_id int,
product_id int
);

insert into am_orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table am_products (
id int,
name varchar(10)
);
insert into am_products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from am_orders;
select * from am_products;

-- find frequency of the time two products bought together

select CONCAT(pr1.name ," ", pr2.name) as p2,count(1) as purchase_freq
from am_orders o1 
inner join am_orders o2
on o1.order_id=o2.order_id
inner join am_products pr1
on pr1.id=o1.product_id
inner join am_products pr2
on pr2.id=o2.product_id
where o1.product_id > o2.product_id
group by pr1.name ,pr2.name
