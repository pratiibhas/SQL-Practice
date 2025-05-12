use practice;
drop table numbers;
create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5);
insert into numbers values (9);

select * from numbers;
-- with recursive cte 
with recursive cte as(
select n,1 as counter from numbers
union all
select n, counter+1 as counter from cte 
where counter+1<=n)
select n from cte
order by n;

-- without recursive cte (when consecutive numbers given)
select n from (
select n2.n as n , row_number() over(partition by n) as rn
 from numbers as n1,numbers as n2) a
 where rn<=n;
 -- or 
 select n2.n
 from numbers as n1,numbers as n2
 where n1.n<=n2.n
 order by 1;
 
 -- when a number is available which is not a consecutive number , here that is 9
 
 with recursive cte as(
 select max(n)as n from numbers
 union all
 select n-1 from cte
 where n-1>=1)
 select c2.n from cte c1 inner join  numbers c2
 where c1.n<=c2.n
 order by 1;

 
 
 

