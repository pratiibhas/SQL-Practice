use practice;
create table polls
(
user_id varchar(4),
poll_id varchar(3),
poll_option_id varchar(3),
amount int,
created_date date
);
-- Insert sample data into the investments table
INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

create table poll_answers
(
poll_id varchar(3),
correct_option_id varchar(3)
);
-- Insert sample data into the poll_answers table
INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),('p2', 'A');

select * from poll_answers;
select * from polls;

-- There is like a bet system the one who won will have proportional money received as invested

-- for example C is the correct answer
-- and A, B D invested 1500 and three users who selected C invested money 250,200,50 then uers will receive 750,600,150
with cte as(
select p.user_id,p.poll_id,p.amount,pa.poll_id as winner_id from polls p
left join poll_answers pa
on p.poll_option_id=pa.correct_option_id and p.poll_id=pa.poll_id),

cte2 as(
select poll_id,user_id,
(case when winner_id is null then amount else 0 end) as total_money_distributed,
(case when winner_id is not null then amount else null end) as in_proportion,
(case when winner_id is not null then 1 else 0 end) as dist_among  from cte),

cte3 as(
select *,
rank() over(partition by poll_id order by in_proportion desc) as rn from cte2
)
select * from(
select poll_id,user_id,round(sum(total_money_distributed) over(partition by poll_id) *
in_proportion/case when in_proportion is not null then sum(in_proportion) over(partition by poll_id) end ,0)as proportion
from cte3)a 
where proportion is not null
;

-- Youtube's approach
-- kind of same approach a little smaller ,I guess
WITH CTE AS (
    SELECT 
        p.poll_id,
        p.user_id,
        p.amount,
        pa.correct_option_id,
        p.poll_option_id,
        SUM(CASE WHEN p.poll_option_id = pa.correct_option_id THEN p.amount ELSE 0 END) 
            OVER (PARTITION BY p.poll_id) AS total_winners_amount,
        SUM(CASE WHEN p.poll_option_id <> pa.correct_option_id THEN p.amount ELSE 0 END) 
            OVER (PARTITION BY p.poll_id) AS total_losers_amount
    FROM 
        polls p
    JOIN 
        poll_answers pa 
    USING(poll_id)
)
SELECT 
    poll_id, 
    user_id, 
    amount * (total_losers_amount / total_winners_amount) AS amount_won
FROM 
    CTE
WHERE 
    poll_option_id = correct_option_id;



