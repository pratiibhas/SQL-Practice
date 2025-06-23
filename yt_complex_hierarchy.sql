use yt_interview_query;

CREATE TABLE IF NOT EXISTS employee (
  emp_id INT PRIMARY KEY,
  reporting_id INT
);

-- Step 2: Insert the data
INSERT INTO employee (emp_id, reporting_id) VALUES
  (1, NULL),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 2),
  (6, 3),
  (7, 3),
  (8, 4),
  (9, 4);
  
  select * from employee;
  -- write a query to find all employees under a employee including herself
  with recursive cte as(
  select emp_id, emp_id as emp_hierarchy from employee
  union 
  select c.emp_id, e.emp_id
  from cte c join  employee e
  on c.emp_hierarchy = e.reporting_id)
 
 select * from cte
 order by emp_id;
  
  