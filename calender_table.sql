use practice;
select cast('2000-01-01' as date ) as cal_date, 
year('2000-01-01')  as date_year,
dayofyear('2000-01-01')  as cal_year_day,
month('2000-01-01')  as date_month,
monthname('2000-01-01')  as date_month_name,
day('2000-01-01')  as cal_month_day,
quarter('2000-01-01')  as date_quarter,
WEEK('2000-01-14', 1)as cal_week,
dayname('2000-01-01')  as cal_weekname,
weekday('2000-01-01')  as cal_weekday;


SET @@cte_max_recursion_depth = 32676;
CREATE TABLE cal_dim_table AS
with recursive cal_dim as(
select cast('2000-01-01' as date ) as cal_date, 
year('2000-01-01')  as date_year,
dayofyear('2000-01-01')  as cal_year_day,
month('2000-01-01')  as date_month,
monthname('2000-01-01')  as date_month_name,
day('2000-01-01')  as cal_month_day,
quarter('2000-01-01')  as date_quarter,
WEEK('2000-01-14', 1)as cal_week,
dayname('2000-01-01')  as cal_weekname,
weekday('2000-01-01')  as cal_weekday
union all
select date_add(cal_date, interval 1 day) as cal_date, 
year(date_add(cal_date,interval 1 day))  as date_year,
dayofyear(date_add(cal_date,interval 1 day))  as cal_year_day,
month(date_add(cal_date,interval 1 day))  as date_month,
monthname(date_add(cal_date,interval 1 day))  as date_month_name,
day(date_add(cal_date,interval 1 day))  as cal_month_day,
quarter(date_add(cal_date,interval 1 day))  as date_quarter,
WEEK(date_add(cal_date,interval 1 day))as cal_week,
dayname(date_add(cal_date,interval 1 day))  as cal_weekname,
weekday(date_add(cal_date,interval 1 day))  as cal_weekday
from cal_dim
where cal_date <'2050-01-01')


SELECT 
    ROW_NUMBER() OVER (ORDER BY cal_date ASC) AS ind,
    cal_date,
    date_year,
    cal_year_day,
    date_month,
    date_month_name,
    cal_month_day,
    date_quarter,
    cal_week,
    cal_weekname,
    cal_weekday
FROM cal_dim;

select * from cal_dim;


