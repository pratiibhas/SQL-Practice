use practice;
create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');
select * from bms;

-- 3 or more consecutive empty seats


-- using lead ,lag
select  seat_no from(
select *,lag(is_empty,1) over (order by seat_no) as prev_1,
lag(is_empty,2) over (order by seat_no) as prev_2,
lead(is_empty,1) over (order by seat_no) as next_1,
lead(is_empty,2) over (order by seat_no) as next_2
from bms) a
where is_empty='Y' and prev_1='Y' and prev_2='Y'
or (is_empty='Y' and next_1='Y' and prev_1='Y')
or ( is_empty='Y' and next_1='Y' and next_2='Y');

-- method 2

select seat_no from(
select *,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as prev_next_1,
sum(case when is_empty='Y' then 1 else 0 end ) over (order by seat_no rows between current row and 2 following ) as next_2
from bms) a
where prev_2=3 or prev_next_1=3 or next_2=3;


--  method 3 analytical row_number function
with diff_num as (
select *,row_number() over(order by seat_no)  as rn,
(seat_no -row_number() over(order by seat_no) )as diff
from bms
where is_empty='Y'),
diff_counts as(
select diff, count(1) as cn from diff_num 
group by diff
having count(1)>=3)

select seat_no from diff_num where diff in(select diff from diff_counts)
