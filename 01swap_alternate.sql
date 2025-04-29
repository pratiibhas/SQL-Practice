use practice;
CREATE TABLE seats (
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats VALUES 
(1, 'Amit'),
(2, 'Deepa'),
(3, 'Rohit'),
(4, 'Anjali'),
(5, 'Neha'),
(6, 'Sanjay'),
(7, 'Priya');

select * from seats;

-- swap seats with alternate student 
select id,student,
case when id=(select  max(id) from seats)and id%2=1 then id 
when id%2=0 then id-1 
else  id+1 end as new_id
from seats
