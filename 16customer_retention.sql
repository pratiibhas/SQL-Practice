-- customer retention and customer churn metrics
use yt_interview_query;
create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
-- delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;
select * from transactions;
select month(this_month.order_date) as month_date, count(distinct last_month.cust_id) as count_of_cust
 from transactions this_month
left join transactions last_month
on this_month.cust_id= last_month.cust_id
AND MONTH(last_month.order_date) - MONTH(this_month.order_date) = 1
AND YEAR(last_month.order_date) = YEAR(this_month.order_date)
group by month(this_month.order_date)


