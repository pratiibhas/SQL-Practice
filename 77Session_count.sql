use practice;
create table events 
(userid int , 
event_type varchar(20),
event_time datetime);

insert into events VALUES (1, 'click', '2023-09-10 09:00:00');
insert into events VALUES (1, 'click', '2023-09-10 10:00:00');
insert into events VALUES (1, 'scroll', '2023-09-10 10:20:00');
insert into events VALUES (1, 'click', '2023-09-10 10:50:00');
insert into events VALUES (1, 'scroll', '2023-09-10 11:40:00');
insert into events VALUES (1, 'click', '2023-09-10 12:40:00');
insert into events VALUES (1, 'scroll', '2023-09-10 12:50:00');
insert into events VALUES (2, 'click', '2023-09-10 09:00:00');
insert into events VALUES (2, 'scroll', '2023-09-10 09:20:00');
insert into events VALUES (2, 'click', '2023-09-10 10:30:00');

select * from events;
-- 1 .Identify users sessions: A user is defind as as sequence of events where he time difference between two events is less than or equal to 30 minutes.
-- if more than 30 minutes a new session is added.
with cte as(select *,lag(event_time,1,event_time) over(partition by userid order by event_time)as session_end_time,
                     coalesce(timestampdiff(minute,lag(event_time) over(partition by userid order by event_time),event_time),0) as session_end
           from events),
	
cte2 as(select *,
              (case when session_end<=30 then 0 else 1 end)as flag,
               sum(case when session_end<=30 then 0 else 1 end) over(partition by userid order by event_time) as session_grp
          from cte)

select userid,session_grp+1 as session_id,
min(event_time) as session_start_time,
max(event_time) as  session_end_time,
count(*) as no_of_events,
 timestampdiff(minute,min(event_time),max(event_time)) as session_dur
from cte2
 group by 1,2 ;
 
 