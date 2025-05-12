use practice;
CREATE TABLE frnds (
    user_id INT,
    friend_id INT
);

-- Insert data into friends table
INSERT INTO frnds VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

-- Create likes table
CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

-- Insert data into likes table
INSERT INTO likes VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');

select * from frnds;
select * from likes;

-- Recommendation problem
-- If the friend of user had liked the page then recommend it but if he already liked then not
with user_pages as(
select distinct f.user_id,l.page_id from frnds f
inner join likes l
on f.user_id=l.user_id),
friends_pages as(
select  distinct f.user_id,f.friend_id,l.page_id from frnds f
inner join likes l
on f.friend_id=l.user_id)

select distinct fp.user_id,fp.friend_id,fp.page_id from friends_pages fp 
left join user_pages  up 
on fp.user_id= up.user_id and fp.page_id= up.page_id
where up.user_id is null
order by 1;

-- solution 2
select * from frnds f
inner join  likes fp on f.friend_id=fp.user_id
left join likes up on f.user_id=up.user_id and fp.page_id=up.page_id
where up.page_id is null;

-- solution 3 
select distinct f.user_id,fp.page_id from frnds f
inner join  likes fp on f.friend_id=fp.user_id
where concat(f.user_id,fp.page_id) not in( select concat(f.user_id,fp.page_id) as concat_cols from
friends f inner join likes fp  on f.user_id=fp.user_id 
)
group by 1,2;


select *
from frnds f 
join likes l on f.friend_id=l.user_id 
left join  likes on f.user_id=likes.user_id and l.page_id=likes.page_id

