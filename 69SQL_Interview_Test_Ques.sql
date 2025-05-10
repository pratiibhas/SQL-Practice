use practice;
drop table users;
drop table logins;
CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- Users Table
INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');

-- Logins Table 

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);


-- 2024 Q1
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);

select * from logins;
select * from users;


-- 1. Users that did not login in past five months
select user_id 
from logins
group by user_id
having max(LOGIN_TIMESTAMP)<=date_add(cast('2024-06-28' as date),interval -5 month); 
-- OR 
 select distinct user_id from logins where user_id not in 
 (select user_id from logins where login_timestamp>date_add(cast('2024-06-28' as date),interval -5 month));

-- 2. For the business units quarterly analysis, calculate how many users and how many sessions were at ach quarter
-- order by quarter oldest to newest
-- return: first day of the quarter,user_cnt,ession_cnt
with cte as(select *,quarter(LOGIN_TIMESTAMP) as quarter from logins)
select quarter,count(session_id) as session_cnt,min(date(login_timestamp)) as first_quar_date,count(distinct user_id) as usr_cnt from cte 
group by quarter;

-- Display user id's that log in in January2024 and did not login in November 2023
-- user_id

with cte as(
select *, DATE_FORMAT(LOGIN_TIMESTAMP, '%Y-%m')as formatted_date from logins
)
select distinct user_id from cte  where formatted_date ='2024-01'
and user_id not in (select user_id from cte where formatted_date ='2023-11');
-- OR 
select distinct user_id from logins where LOGIN_TIMESTAMP between '2024-01-01' and '2024-01-31' 
and user_id 
not in (select user_id from logins where LOGIN_TIMESTAMP between '2023-11-01' and '2023-11-30');

-- 4. Add to Q2 he precentage change in sessions from last quarter
-- return: first day of the quarter,user_cnt,ession_cnt, session_percent_change 

with cte as(
select quarter(LOGIN_TIMESTAMP)as quarter,count(session_id) as session_cnt,
min(date(login_timestamp)) as first_quar_date,count(distinct user_id) as usr_cnt 
 from logins
group by quarter),
prev_sess as(
select * ,lag(session_cnt) over( order by first_quar_date) as prev_ses_cnt from cte)

select quarter,session_cnt,first_quar_date,usr_cnt, coalesce((session_cnt-prev_ses_cnt)*100/prev_ses_cnt,0) as percentage from prev_sess;

-- 5. Display the user who have highest(max) session score for each day
-- Date username score
select * from logins;
select cast(LOGIN_TIMESTAMP as date)as date,user_id, sum(session_score) as maxi from logins
group by cast(LOGIN_TIMESTAMP as date),user_id
order by cast(LOGIN_TIMESTAMP as date);

-- 6. To identify our best users - return the users that had a session n every single day since their first login 
-- user_id
with cte as(select user_id, min(cast(login_timestamp as date)) as first_login ,
DATEDIFF('2024-06-28', MIN(CAST(login_timestamp AS DATE)))+1 AS no_of_login_dates
,count(distinct CAST(login_timestamp AS DATE)) as cnt
from logins
group by user_id)
select user_id from cte where cnt=no_of_login_dates;

-- 7. On what dates there was no log in at all
-- login_date
with cte as(select 
             min(cast(LOGIN_TIMESTAMP as date)) as first_date,
             DATE('2024-06-28')  as last_date 
             from 
                 logins
              )
select cd.cal_date from cal_dim_table cd
inner join cte l on  cd.cal_date between first_date and last_date
where cd.cal_date not in (select distinct(cast(login_timestamp as date)) from logins)
;
select min(cast(LOGIN_TIMESTAMP as date)) as first_date from logins;

-- OR 
-- Using recursive CTE
with recursive cte as(
select min(cast(LOGIN_TIMESTAMP as date)) as first_date,DATE('2024-06-28')  as last_date  from logins
union all
select date_add(first_date, interval 1 day) as first_date,last_date
from cte 
where first_date<last_date)

select first_date from cte
where first_date not in (select cast(LOGIN_TIMESTAMP as date) from logins)