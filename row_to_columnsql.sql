use yt_interview_query;
-- Step 1: Create the input table
CREATE TABLE Transactions1 (
    SalesDate DATE,
    CustomerID VARCHAR(10),
    Amount INT
);

-- Step 2: Insert the data
INSERT INTO Transactions1 (SalesDate, CustomerID, Amount) VALUES
('2021-01-01', 'Cust-1', 50),
('2021-01-02', 'Cust-1', 50),
('2021-01-03', 'Cust-1', 50),
('2021-01-01', 'Cust-2', 100),
('2021-01-02', 'Cust-2', 100),
('2021-01-03', 'Cust-2', 100),
('2021-02-01', 'Cust-2', -100),
('2021-02-02', 'Cust-2', -100),
('2021-02-03', 'Cust-2', -100),
('2021-03-01', 'Cust-3', 1),
('2021-04-01', 'Cust-3', 1),
('2021-05-01', 'Cust-3', 1),
('2021-06-01', 'Cust-3', 1),
('2021-07-01', 'Cust-3', -1),
('2021-08-01', 'Cust-3', -1),
('2021-09-01', 'Cust-3', -1),
('2021-10-01', 'Cust-3', -1),
('2021-11-01', 'Cust-3', -1),
('2021-12-01', 'Cust-3', -1);

with pivotted_table as(

SELECT 
  CustomerID as Customers,
  
  -- Monthly Columns
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Jan-21' THEN Amount ELSE 0 END) AS `Jan-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Feb-21' THEN Amount ELSE 0 END) AS `Feb-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Mar-21' THEN Amount ELSE 0 END) AS `Mar-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Apr-21' THEN Amount ELSE 0 END) AS `Apr-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'May-21' THEN Amount ELSE 0 END) AS `May-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Jun-21' THEN Amount ELSE 0 END) AS `Jun-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Jul-21' THEN Amount ELSE 0 END) AS `Jul-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Aug-21' THEN Amount ELSE 0 END) AS `Aug-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Sep-21' THEN Amount ELSE 0 END) AS `Sep-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Oct-21' THEN Amount ELSE 0 END) AS `Oct-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Nov-21' THEN Amount ELSE 0 END) AS `Nov-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%m-%y') = 'Dec-21' THEN Amount ELSE 0 END) AS `Dec-21`,
  
  -- Total Column
  SUM(Amount) AS Total

 FROM Transactions1
 GROUP BY CustomerID
 UNION ALL
 SELECT 
  'Total' as Customers, -- ' Total row wise 
  
  -- Monthly Columns
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Jan-21' THEN Amount ELSE 0 END) AS `Jan-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Feb-21' THEN Amount ELSE 0 END) AS `Feb-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Mar-21' THEN Amount ELSE 0 END) AS `Mar-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Apr-21' THEN Amount ELSE 0 END) AS `Apr-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'May-21' THEN Amount ELSE 0 END) AS `May-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Jun-21' THEN Amount ELSE 0 END) AS `Jun-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Jul-21' THEN Amount ELSE 0 END) AS `Jul-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Aug-21' THEN Amount ELSE 0 END) AS `Aug-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Sep-21' THEN Amount ELSE 0 END) AS `Sep-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Oct-21' THEN Amount ELSE 0 END) AS `Oct-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Nov-21' THEN Amount ELSE 0 END) AS `Nov-21`,
  SUM(CASE WHEN DATE_FORMAT(SalesDate, '%b-%y') = 'Dec-21' THEN Amount ELSE 0 END) AS `Dec-21`,
  " " AS Total
  
 FROM transactions1)
 
SELECT  Customers,
  CASE 
    WHEN `Jan-21` < 0 THEN CONCAT('(', -`Jan-21`, '$', ')') 
    ELSE CONCAT(`Jan-21`, '$') 
  END AS `Jan-21`,

  CASE 
    WHEN `Feb-21` < 0 THEN CONCAT('(', -`Feb-21`, '$', ')') 
    ELSE CONCAT(`Feb-21`, '$') 
  END AS `Feb-21`,

  CASE 
    WHEN `Mar-21` < 0 THEN CONCAT('(', -`Mar-21`, '$', ')') 
    ELSE CONCAT(`Mar-21`, '$') 
  END AS `Mar-21`,

  CASE 
    WHEN `Apr-21` < 0 THEN CONCAT('(', -`Apr-21`, '$', ')') 
    ELSE CONCAT(`Apr-21`, '$') 
  END AS `Apr-21`,

  CASE 
    WHEN `May-21` < 0 THEN CONCAT('(', -`May-21`, '$', ')') 
    ELSE CONCAT(`May-21`, '$') 
  END AS `May-21`,

  CASE 
    WHEN `Jun-21` < 0 THEN CONCAT('(', -`Jun-21`, '$', ')') 
    ELSE CONCAT(`Jun-21`, '$') 
  END AS `Jun-21`,

  CASE 
    WHEN `Jul-21` < 0 THEN CONCAT('(', -`Jul-21`, '$', ')') 
    ELSE CONCAT(`Jul-21`, '$') 
  END AS `Jul-21`,

  CASE 
    WHEN `Aug-21` < 0 THEN CONCAT('(', -`Aug-21`, '$', ')') 
    ELSE CONCAT(`Aug-21`, '$') 
  END AS `Aug-21`,

  CASE 
    WHEN `Sep-21` < 0 THEN CONCAT('(', -`Sep-21`, '$', ')') 
    ELSE CONCAT(`Sep-21`, '$') 
  END AS `Sep-21`,

  CASE 
    WHEN `Oct-21` < 0 THEN CONCAT('(', -`Oct-21`, '$', ')') 
    ELSE CONCAT(`Oct-21`, '$') 
  END AS `Oct-21`,

  CASE 
    WHEN `Nov-21` < 0 THEN CONCAT('(', -`Nov-21`, '$', ')') 
    ELSE CONCAT(`Nov-21`, '$') 
  END AS `Nov-21`,

  CASE 
    WHEN `Dec-21` < 0 THEN CONCAT('(', -`Dec-21`, '$', ')') 
    ELSE CONCAT(`Dec-21`, '$') 
  END AS `Dec-21`,

CASE WHEN Total = ' ' THEN '' ELSE 
  CASE 
    WHEN Total < 0 THEN CONCAT('(', -Total, '$', ')') 
    ELSE CONCAT(Total, '$') 
END END AS `Total`
FROM pivotted_table;

 

;
