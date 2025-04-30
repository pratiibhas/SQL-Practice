-- recursive query 
use practice;

with Recursive cte_numbers as(
      select 1 as num 
      union all
      select  num+1 from cte_numbers 
      where num<6)
      
select * from cte_numbers   ;   

-- total sales per year  
-- recursive query 
select * from sales;
with recursive r_cte as (select min(period_start) as dates , max(period_end) as max_date from sales 
union all
select date_add(dates ,interval  1 day ) as dates ,max_date from r_cte
where dates<max_date )
select s.product_id,year(dates) as report_year,sum(average_daily_sales) as total_sum from  r_cte
inner join sales s 
on dates between period_start and period_end 
group by s.product_id,report_year
order by s.product_id,report_year










