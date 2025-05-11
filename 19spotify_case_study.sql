use yt_interview_query;
drop table activity;
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);

insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select * from activity;
-- Spotify case study
-- the table shows app installed and app purhcases activities for spotify app along with country details
-- q1 find total active users each day
select event_date ,count(distinct user_id) from activity
group by event_date;

-- q2 find total active users each week
select week(event_date) as weeks ,count(distinct user_id) from activity
group by week(event_date);

-- q2 date wise total number of users who made the purchase same day they installed the app
select a.event_date,coalesce(count(distinct(a.user_id)),0) as no_of_users_made_same_day_purchase
 from activity a
inner join activity a2  
on a.user_id=a2.user_id
where a.event_name= 'app-installed' and a2.event_name= 'app-purchase'
and a.event_date= a2.event_date
group by a.event_date;  -- but the problem with this query does not return all dates , returns only dates when value is not 0

-- using subquery instead
select event_date, count(new_user) as no_of_users_made_same_day_purchase
from (select user_id, event_date,case when count(distinct event_name)=2 then user_id else null
end as new_user from activity group by user_id,event_date)a
 group by event_date;

-- another approach
with cte as (
select *, lead(event_date,1) over (partition by user_id order by event_date desc) as lead_date
from activity),cte2 as (
select * from cte where lead_date is not null and event_date=lead_date)
select a.event_date, count(distinct c.user_id) as no_of_users
from cte2 c 
right join activity a on a.event_date=c.event_date
group by a.event_date;

-- q4 percentage of paid users in India,USA and any other country tagged as other
select * from activity;
with total_users_per_country as(select count(user_id) as total_users from activity where event_name='app-purchase'),
paid_users as (select 
case when country in('India' ,'USA') then country else 'other' end as country_needed,
count(user_id) as paid_us 
from activity 
where event_name='app-purchase'
group by case when country in('India' ,'USA') then country else 'other' end )

select p.country_needed as country, (sum(p.paid_us)/sum(tu.total_users))*100 as pct_of_paid_users
from total_users_per_country tu,
paid_users p
group by p.country_needed;

-- q5 among all the users who installed he app on a given day, how many did in app purchase on the very next day
-- day wise result

select * from activity;
-- unable to render all the dates
with installed_yester_date as (select user_id,
date_add(event_date, INTERVAL 1 DAY) AS yesterday_date
from activity
where event_name='app-installed'
order by user_id) ,

purchase_date as (select user_id ,event_date from activity where event_name='app-purchase')


select i.event_date,sum(case when (i.event_date!= y.Yesterday_date) then 0 else i.user_id end ) as users
 from installed_yester_date y, purchase_date i
where i.user_id=y.user_id
group by event_date;


-- updated version making a master cte sof al dates and then joining it to the sult using left join
-- Create a CTE for all unique event dates
WITH all_dates AS (
    SELECT DISTINCT event_date
    FROM activity
),
installed_yesterday AS (
    SELECT 
        user_id,
        event_date AS install_date,
        DATE_ADD(event_date, INTERVAL 1 DAY) AS yesterday_date
    FROM activity
    WHERE event_name = 'app-installed'
),
purchase_date AS (
    SELECT 
        user_id,
        event_date AS purchase_date
    FROM activity
    WHERE event_name = 'app-purchase'
)
-- Combine all dates and calculate the count
SELECT 
    d.event_date,
    COUNT(p.user_id) AS users
FROM 
    all_dates d
LEFT JOIN installed_yesterday i ON d.event_date = i.yesterday_date
LEFT JOIN purchase_date p ON i.user_id = p.user_id AND p.purchase_date = d.event_date
GROUP BY d.event_date
ORDER BY d.event_date;

-- from the yt
with prev_data as
(select *,
lag(event_date,1) over(partition by user_id order by event_date) as prev_event_date,
lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name 
from activity)

select event_date,
count(case when event_name='app-purchase' and prev_event_name='app-installed' and datediff(event_date,prev_event_date)=1 then user_id else null end) as user_cnt
from prev_data
group by event_date

