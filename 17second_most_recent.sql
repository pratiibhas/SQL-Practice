use practice;
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');
select * from UserActivity;

-- most recent activity
with count__of_activities as(
select *, row_number() over (partition by username order by startDate desc , endDate desc) as rnk  from UserActivity)

select username,activity,startDate ,endDate 
from count__of_activities 
where rnk=1;

-- second most recent activity
with count_and_rank as(
select *, count(1) over (partition by username ) as cnt,
row_number() over (partition by username order by startDate desc , endDate desc) as rnk  from UserActivity)

select username,activity,startDate ,endDate 
from count_and_rank
where cnt=1 or rnk=2
