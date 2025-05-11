use yt_interview_query;
select * from transactions;
select count(distinct cust_id) from transactions where month(order_date);

select last_month.*, this_month.*
from transactions last_month
left join transactions this_month
on this_month.cust_id = last_month.cust_id
where month(last_month.order_date)-month(this_month.order_date)=1
and year(last_month.order_date)= year(this_month.order_date);

select last_month.*,this_month.*
from transactions last_month
left join transactions this_month
on this_month.cust_id = last_month.cust_id
where month(last_month.order_date)-month(this_month.order_date)=1
and year(last_month.order_date)= year(this_month.order_date)




