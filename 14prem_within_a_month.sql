use case_questions;

create table users
(
user_id integer,
name varchar(20),
join_date date
);
INSERT INTO users (user_id, name, join_date) VALUES
(1, 'Jon', CAST('2020-02-14' AS DATE)), 
(2, 'Jane', CAST('2020-02-14' AS DATE)), 
(3, 'Jill', CAST('2020-02-15' AS DATE)), 
(4, 'Josh', CAST('2020-02-15' AS DATE)), 
(5, 'Jean', CAST('2020-02-16' AS DATE)), 
(6, 'Justin', CAST('2020-02-17' AS DATE)),
(7, 'Jeremy', CAST('2020-02-18' AS DATE));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

INSERT INTO events  VALUES
(1, 'Pay', CAST('2020-03-01' AS DATE)), 
(2, 'Music', CAST('2020-03-02' AS DATE)), 
(2, 'P', CAST('2020-03-12' AS DATE)),
(3, 'Music', CAST('2020-03-15' AS DATE)), 
(4, 'Music', CAST('2020-03-15' AS DATE)), 
(1, 'P', CAST('2020-03-16' AS DATE)), 
(3, 'P', CAST('2020-03-22' AS DATE));

select * from events;
select * from users;

-- return the fraction of users, who accessed amazon music and upgraded to amazon primemembership within he first 30 days of signing up
SELECT 
  COUNT(DISTINCT CASE 
        WHEN DATEDIFF(e.access_date, u.join_date) <= 30 THEN u.user_id 
    END) /(COUNT(DISTINCT u.user_id) ) *100 as percentage
FROM users u
LEFT JOIN events e
    ON u.user_id = e.user_id
    AND e.type = 'P'
WHERE u.user_id IN (
    SELECT user_id 
    FROM events 
    WHERE type = 'Music'
);



