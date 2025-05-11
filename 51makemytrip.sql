use practice;
CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');

select * from booking_table;
select * from user_table;

-- Q1 segment wise information segment,total_user_count, users who booked flight in apr_2022

SELECT 
    u.Segment,
    COUNT(DISTINCT u.user_id) AS total_user_count,
    COUNT(DISTINCT CASE 
                      WHEN b.Line_of_business = 'Flight' 
                           AND YEAR(b.Booking_date) = 2022 
                           AND MONTH(b.Booking_date) = 4 
                      THEN User_id
                  END) AS flight_in_apr_2022
FROM user_table u
LEFT JOIN booking_table b ON u.user_id = b.user_id
GROUP BY u.Segment;

-- q2 write a query to find uses whose firstt booking was a hotel booking
WITH cte AS(
         SELECT User_id,Booking_date,Line_of_business, 
		 rank() over(partition by User_id order by Booking_date asc) as rnk
		 FROM booking_table)
SELECT * FROM cte  
	     WHERE rnk=1 and Line_of_business='Hotel';
         
-- Another Approach 
-- FIRST_VALUE function   
SELECT   DISTINCT User_id FROM    
     (SELECT User_ id,Booking_date,Line_of_business, FIRST_VALUE(Line_of_Business) over(partition by User_id order by Booking_date asc) as First_val
		 FROM booking_table) a
         WHERE First_val='Hotel';
         
-- q3 Write a query to find the days between first and last booking of each user.
WITH cteq as(
SELECT User_id, min(Booking_date) as first_date,max(Booking_date) as last_date
     FROM booking_table 
     GROUP BY User_id)
     
SELECT User_id,DATEDIFF(last_date,first_date)as diff
FROM cteq;

-- Q4  Write a query to find the number of flight and hotel bookings in each of the segments for the year 2022
SELECT 
    u.Segment,
    SUM(CASE WHEN Line_of_business='Flight' THEN 1 ELSE 0 END ) AS Flight_bookings,
    SUM(CASE WHEN Line_of_business='Hotel' THEN 1 ELSE 0 END ) AS Hotel_bookings
FROM user_table u
INNER JOIN booking_table b ON u.user_id = b.user_id
WHERE YEAR(Booking_date)=2022
GROUP BY u.Segment
