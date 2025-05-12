use practice;
CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time datetime
);

-- Insert sample data
INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');
select * from swipe;

-- 1. Find out the ime employee spend in he office on a particular day
select employee_id,cast(activity_time as date) as date,
TIMESTAMPDIFF(SECOND, MIN(activity_time), MAX(activity_time)) / 3600 AS time_spent
from swipe
group by employee_id,cast(activity_time as date);

-- 2. Find out how productive was he at office, how much time he spent actually in office
with cte as(
select *,lead(activity_time) over(partition by employee_id,cast(activity_time as date) order by activity_time) as logout_time
from swipe),
cte2 as(
select employee_id,cast(activity_time as date) as activity_day, activity_time as login_time , logout_time from cte
where activity_type='login')
select employee_id,activity_day,
TIMESTAMPDIFF(hour, MIN(login_time), MAX(logout_time)) AS time_spent,
sum(TIMESTAMPDIFF(hour,login_time,logout_time)) as actual_time_spent
from cte2
group by employee_id,activity_day