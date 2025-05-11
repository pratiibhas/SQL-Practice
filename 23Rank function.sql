use practice;
create table covid(city varchar(50),days date,cases int);

insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);
select * from covid;


with rank_func as(
select city ,days, rank() over(partition by city order by cases) as rnk_cases,
rank() over(partition by city order by days) as rnk_days,
cast(rank() over(partition by city order by cases)as signed)-cast(rank() over(partition by city order by days)as signed) as diff
from covid)

select city 
from rank_func
group by city
having count(distinct(diff))=1 and max(diff)=0