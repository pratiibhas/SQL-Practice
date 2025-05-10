use practice;
CREATE TABLE cinema (
    seat_id INT PRIMARY KEY,
    free int
);
delete from cinema;
INSERT INTO cinema (seat_id, free) VALUES (1, 1);
INSERT INTO cinema (seat_id, free) VALUES (2, 0);
INSERT INTO cinema (seat_id, free) VALUES (3, 1);
INSERT INTO cinema (seat_id, free) VALUES (4, 1);
INSERT INTO cinema (seat_id, free) VALUES (5, 1);
INSERT INTO cinema (seat_id, free) VALUES (6, 0);
INSERT INTO cinema (seat_id, free) VALUES (7, 1);
INSERT INTO cinema (seat_id, free) VALUES (8, 1);
INSERT INTO cinema (seat_id, free) VALUES (9, 0);
INSERT INTO cinema (seat_id, free) VALUES (10, 1);
INSERT INTO cinema (seat_id, free) VALUES (11, 0);
INSERT INTO cinema (seat_id, free) VALUES (12, 1);
INSERT INTO cinema (seat_id, free) VALUES (13, 0);
INSERT INTO cinema (seat_id, free) VALUES (14, 1);
INSERT INTO cinema (seat_id, free) VALUES (15, 1);
INSERT INTO cinema (seat_id, free) VALUES (16, 0);
INSERT INTO cinema (seat_id, free) VALUES (17, 1);
INSERT INTO cinema (seat_id, free) VALUES (18, 1);
INSERT INTO cinema (seat_id, free) VALUES (19, 1);
INSERT INTO cinema (seat_id, free) VALUES (20, 1);
select * from cinema;
-- consecutive 2 free seats
-- method 1
with cte as(select *,lag(free) over (order by seat_id) as prev ,lead(free) over (order by seat_id) as nxt
from cinema)

select seat_id from cte where (free=1 and prev=1) or (free=1 and nxt=1)
order by seat_id;

-- method 2
with cte as(select *,seat_id-row_number() over(order by seat_id) as grp from cinema 
where free=1)
select seat_id from (
select *,count(*) over(partition by grp) as cnt from cte) a
where cnt>1;
 
 -- method 3 
 -- using self joins
 with cte as(
 select c.seat_id as s1, d.seat_id as s2 from cinema c
 inner join cinema d
 on c.seat_id=d.seat_id+1 
where c.free=1 and d.free=1)
select s1 from cte
union 
select s2 from cte
order by s1