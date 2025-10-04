use yt_initerview_query;
-- Create the table
CREATE TABLE emp_details (
    emp_name VARCHAR(10),
    city VARCHAR(15)
);

-- Insert sample data
INSERT INTO emp_details (emp_name, city) VALUES
('Sam', 'New York'),
('David', 'New York'),
('Peter', 'New York'),
('Chris', 'New York'),
('John', 'New York'),
('Steve', 'San Francisco'),
('Rachel', 'San Francisco'),
('Robert', 'Los Angeles');

-- write a query to return a list of teams
/* Rules:
1. team memebers must live in the same city they represent
2. for each city, create teams of three unless less than 3 available who are unassigned
3.when there are less than 3 unassigned in a city, they will form a team

city, team_group ,team_name,
order by city
order by 
*/
select * from emp_details;

WITH numbered AS (
  SELECT *,
         ROW_NUMBER() OVER ( PARTITION BY city ORDER BY emp_name) AS rn  -- Assigns global row numbers
  FROM emp_details
),
teams as(
  SELECT *,
         CEIL(rn / 3.0) AS team_no                   -- Every 3 employees form a team
  FROM numbered
),
grp as(
SELECT city, team_no, GROUP_CONCAT(emp_name ORDER BY emp_name) AS Team 
FROM teams 
GROUP BY city,team_no)

SELECT 
    city, 
    Team, 
    CONCAT('Team', ROW_NUMBER() OVER (ORDER BY city)) AS TeamName
FROM grp
ORDER BY city, team_no;



