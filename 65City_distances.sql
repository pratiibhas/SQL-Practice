use practice;
CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');
select * from city_distance;
-- remove duplicates in case source,destination, distance are same and keep the first value only

-- first method -- does not make sure first record will come just make sure duplicates are not there 
with cte as(select c1.*
from city_distance c1 
left join city_distance c2 
on c1.source=c2.destination  and c1.source=c2.destination 
where c2.distance is null or c1.distance!=c2.distance or c1.source>c2.source)
select * from cte ;

-- second meethod 
with cte as (select *, 
case when source<destination then source else destination end as city_1,
case when source<destination then destination else source end as city_2
from city_distance),
cte2 as(
select *,count(*) over(partition by city_1,city_2,distance) as cn from cte)
select distance,source,destination from cte2 where cn=1 or source<destination ;

-- My solution
with ct as (select * ,row_number() over(partition by distance) as rn from city_distance)
select * from ct where rn=1;

-- third approach -- approached by me 
with c1 as(
select * ,row_number() over(order by (select null))as rn from city_distance)
select c1.distance,c1.source,c1.destination from c1 
left join c1 as  c2 
on c1.source=c2.destination and c2.source=c1.destination
where c1.distance!= c2.distance or c2.distance is null
or c1.rn<c2.rn;

select * ,row_number() over()as rn from city_distance