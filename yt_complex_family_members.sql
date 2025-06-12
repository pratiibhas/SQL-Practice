use yt_interview_query;
-- Step 1: Create the table
CREATE TABLE Persons (
    PERSON_ID VARCHAR(10),
    RELATIVE_ID1 VARCHAR(10),
    RELATIVE_ID2 VARCHAR(10));

-- Step 2: Insert the data
INSERT INTO Persons (PERSON_ID, RELATIVE_ID1, RELATIVE_ID2) VALUES
('ATR-1', NULL, NULL),
('ATR-2', 'ATR-1', NULL),
('ATR-3', 'ATR-2', NULL),
('ATR-4', 'ATR-3', NULL),
('ATR-5', 'ATR-4', NULL),
('BTR-1', NULL, NULL),
('BTR-2', NULL, 'BTR-1'),
('BTR-3', NULL, 'BTR-2'),
('BTR-4', NULL, 'BTR-3'),
('BTR-5', NULL, 'BTR-4'),
('CTR-1', NULL, 'CTR-3'),
('CTR-2', 'CTR-1', NULL),
('CTR-3', NULL, NULL),
('DTR-1', 'DTR-3', 'ETR-2'),
('DTR-2', NULL, NULL),
('DTR-3', NULL, NULL),
('ETR-1', NULL, NULL),
('ETR-2', NULL, 'DTR-2'),
('FTR-1', NULL, NULL),
('FTR-2', NULL, NULL),
('FTR-3', NULL, NULL),
('GTR-1', 'GTR-1', NULL),
('GTR-2', 'GTR-1', NULL),
('GTR-3', 'GTR-1', NULL),
('HTR-1', 'GTR-1', NULL),
('HTR-2', 'GTR-1', NULL),
('HTR-3', 'GTR-1', NULL),
('ITR-1', NULL, NULL),
('ITR-2', 'ITR-3', 'ITR-1'),
('ITR-3', NULL, NULL);


select * from Persons;
-- write a query to find all of the family memebers

-- SELF JOINS
-- Step 1: Flatten relationships
WITH FlatRelations AS (
    SELECT PERSON_ID, RELATIVE_ID1 AS RELATIVE_ID FROM Persons WHERE RELATIVE_ID1 IS NOT NULL
    UNION
    SELECT PERSON_ID, RELATIVE_ID2 AS RELATIVE_ID FROM Persons WHERE RELATIVE_ID2 IS NOT NULL
    UNION
    SELECT RELATIVE_ID1 AS PERSON_ID, PERSON_ID AS RELATIVE_ID FROM Persons WHERE RELATIVE_ID1 IS NOT NULL
    UNION
    SELECT RELATIVE_ID2 AS PERSON_ID, PERSON_ID AS RELATIVE_ID FROM Persons WHERE RELATIVE_ID2 IS NOT NULL
),

-- Step 2: Use self joins to expand the connection up to 4 levels
Connected AS (
    SELECT p1.PERSON_ID AS root, p1.RELATIVE_ID AS member FROM FlatRelations p1
    UNION
    SELECT p1.PERSON_ID AS root, p2.RELATIVE_ID AS member
    FROM FlatRelations p1
    JOIN FlatRelations p2 ON p1.RELATIVE_ID = p2.PERSON_ID
    UNION
    SELECT p1.PERSON_ID AS root, p3.RELATIVE_ID AS member
    FROM FlatRelations p1
    JOIN FlatRelations p2 ON p1.RELATIVE_ID = p2.PERSON_ID
    JOIN FlatRelations p3 ON p2.RELATIVE_ID = p3.PERSON_ID
    UNION
    SELECT p1.PERSON_ID AS root, p4.RELATIVE_ID AS member
    FROM FlatRelations p1
    JOIN FlatRelations p2 ON p1.RELATIVE_ID = p2.PERSON_ID
    JOIN FlatRelations p3 ON p2.RELATIVE_ID = p3.PERSON_ID
    JOIN FlatRelations p4 ON p3.RELATIVE_ID = p4.PERSON_ID
),

-- Step 3: Combine all related people and their roots
AllConnections AS (
    SELECT root, member FROM Connected
    UNION
    SELECT PERSON_ID AS root, PERSON_ID AS member FROM Persons
),

-- Step 4: Assign family groups
FamilyGroups AS (
    SELECT 
        MIN(root) AS family_root,
        member
    FROM AllConnections
    GROUP BY member
)

-- Final output
SELECT 
    CONCAT('F_', DENSE_RANK() OVER (ORDER BY family_root)) AS family,
    member AS person_id
FROM FamilyGroups
ORDER BY family, person_id;

with recursive cte as
(select RELATIVE_ID1 as relatives,substr(person_id,1,3) as fam_group
 from persons where RELATIVE_ID1  is not null 
 union 
 select RELATIVE_ID2  , substr(person_id,1,3)
 from persons where RELATIVE_ID2  is not null

union
 select p.person_id,r.fam_group 
 from cte r join persons p 
 on p.relative_id1= r.relatives 
 or p.relative_id2= r.relatives),
 
no_relative as(
select person_id from persons 
where RELATIVE_ID2 is null and RELATIVE_ID1 is null
and person_id not in (
select RELATIVE_ID1 from persons where RELATIVE_ID1  is not null 
 union 
 select  RELATIVE_ID2 from persons where RELATIVE_ID2  is not null  )
)


select concat('F_',dense_rank() over (order by relatives)) as family_id, relatives  from(
select distinct  group_concat(relatives,"," order by relatives)  as relatives from cte
group by fam_group
union 
select * from no_relative

order by 1) a

