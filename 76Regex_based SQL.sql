use practice;
create table phone_numbers (num varchar(20));
insert into phone_numbers values
('1234567780'),
('2234578996'),
('+1-12244567780'),
('+32-2233567889'),
('+2-23456987312'),
('+91-9087654123'),
('+23-9085761324'),
('+11-8091013345');

select * from phone_numbers;

-- INTRO to some functions

-- poatgres                      MySQL
-- REGEX_SPLIT_TO_TABLE         nO DIRECT FUNCTION
-- POSITION                      LOCATE('data', 'data science is fun')
-- SPLIT_PART                    no direct function but equivalent 
SELECT TRIM(
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(string, delimiter, n),
        delimiter, -1
    )
);

-- Question
WITH RECURSIVE split_string AS (
    -- Base case: Initialize with the filtered number
    SELECT 
        num, -- Original number
        new_num, -- Filtered part (after last hyphen)
        new_num AS rest, -- Remaining string to process
        SUBSTRING(new_num, 1, 1) AS part, -- First character
        1 AS level
    FROM (
        SELECT 
            num,
            CASE 
                WHEN LOCATE('-', num) = 0 THEN num -- If no hyphen, keep the number as is
                ELSE TRIM(SUBSTRING_INDEX(num, '-', -1)) -- Get the part after the last hyphen
            END AS new_num
        FROM phone_numbers
    ) AS init

    UNION ALL

    -- Recursive case: Process the remaining string
    SELECT 
        num, -- Keep the original number
        new_num, -- Keep the filtered part
        SUBSTRING(rest, 2) AS rest, -- Remaining string excluding the first character
        SUBSTRING(rest, 1, 1) AS part, -- Extract the next character
        level + 1 AS level
    FROM split_string
    WHERE CHAR_LENGTH(rest) > 1 -- Continue until the string is fully processed
)


SELECT num,
    new_num, -- Original number
    count(*) as total_digits,
	count(distinct part) as unique_digits -- Filtered part
    -- part -- Individual digits
FROM split_string
group by 1,2;
