use practice;
create table customers  (customer_name varchar(30));
insert into customers values ('Ankit Bansal')
,('Vishal Pratap Singh')
,('Michael'); 

with cte as(
select customer_name,
length(customer_name)-length(replace(customer_name,' ',''))as no_of_spaces,
locate(" ",customer_name) as first_space,
locate(" ",customer_name,locate(" ",customer_name)+1) as second_space
from customers)
/*
select customer_name,
case when no_of_spaces=0 then customer_name 
else substring(customer_name,1,first_space-1) end as first_name,
case when no_of_spaces=2 then substring(customer_name,first_space+1,second_space-first_space) else null end as middle_name,
case when no_of_spaces=1 then substring(customer_name,first_space+1,length(customer_name)-first_space+1) else
          case when no_of_spaces=2 then substring(customer_name,second_space+1,length(customer_name)-second_space+1) 
               else null end end as last_name
from cte;*/
select customer_name,
case when no_of_spaces=0 then customer_name 
else left(customer_name,first_space-1) end as first_name,
case when no_of_spaces=2 then substring(customer_name,first_space+1,second_space-first_space) else null end as middle_name,
case when no_of_spaces=1 then right(customer_name,length(customer_name)-first_space) else
          case when no_of_spaces=2 then right(customer_name,length(customer_name)-second_space) 
               else null end end as last_name
from cte;