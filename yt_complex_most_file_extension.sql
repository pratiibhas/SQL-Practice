-- Use database
USE yt_interview_query;

-- create the table
CREATE TABLE IF NOT EXISTS files (
  id INT PRIMARY KEY,
  date_modified DATE,
  file_name VARCHAR(50)
);

-- Insert values
INSERT INTO files (id, date_modified, file_name) VALUES 
(1 , '2021-06-03', 'thresholds.svg'),
(2 , '2021-06-01', 'redrag.py'),
(3 , '2021-06-03', 'counter.pdf'),
(4 , '2021-06-06', 'reinfusion.py'),
(5 , '2021-06-06', 'tonoplast.docx'),
(6 , '2021-06-01', 'uranian.pptx'),
(7 , '2021-06-03', 'discuss.pdf'),
(8 , '2021-06-06', 'nontheologically.pdf'),
(9 , '2021-06-01', 'skiagrams.py'),
(10, '2021-06-04', 'flavors.py'),
(11, '2021-06-05', 'nonv.pptx'),
(12, '2021-06-01', 'under.pptx'),
(13, '2021-06-02', 'demit.csv'),
(14, '2021-06-02', 'trailings.pptx'),
(15, '2021-06-04', 'asst.py'),
(16, '2021-06-03', 'pseudo.pdf'),
(17, '2021-06-03', 'unguarded.jpeg'),
(18, '2021-06-06', 'suzy.docx'),
(19, '2021-06-06', 'anitsplentic.py'),
(20, '2021-06-03', 'tallies.py');

--  View data
SELECT * FROM files;

-- MOST  MODIFIED EXTENSION
-- o/p :date_modified, file_extension, count

-- got the file extensions
with cte as(
select * ,SUBSTRING_INDEX(file_name, '.', -1) AS extension from files
order by date_modified),
-- find out the count of times the file updated
cnt_extensions as(
select date_modified,extension ,count(extension) as cnt
from cte
group by 1,2),
-- find out the max number of times a file updated in a day
max_updates as(
select date_modified,max(cnt) as count
 from cnt_extensions
 group by 1)
 
 -- concatanating the file extension which had a tie
select m.date_modified,
GROUP_CONCAT(DISTINCT SUBSTRING_INDEX(extension, '.', -1) order by extension SEPARATOR ', ') AS extensions,
m.count as count
from max_updates m
 left join cnt_extensions c 
 on m.count = c.cnt and  m.date_modified = c.date_modified
 group by 1,3