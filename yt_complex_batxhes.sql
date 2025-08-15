USE yt_interview_query;
CREATE TABLE BATCH (
    BATCH_ID VARCHAR(10) PRIMARY KEY,
    QUANTITY INT
);

INSERT INTO BATCH (BATCH_ID, QUANTITY) VALUES
('B1', 5),
('B2', 12),
('B3', 8);

CREATE TABLE ORD (
    ORDER_NUMBER VARCHAR(10) PRIMARY KEY,
    QUANTITY INT
);

INSERT INTO ORD (ORDER_NUMBER, QUANTITY) VALUES
('O1', 2),
('O2', 8),
('O3', 2),
('O4', 5),
('O5', 9),
('O6', 5);

select * from ord;
select * from batch;
/*Imagine a warehouse where the available items are stored in different batches, as indicated in the BATCH table.
Customers can place orders that request multiple items, as shown in the ORDERS table.

You are required to write an SQL query that determines from which batch(es) the items for each order are fulfilled*/


with batch_cte as 
        (select *, row_number() over(order by batch_id) as rn
        from (
            with recursive batch_split as
                (select batch_id, 1 as quantity from batch
                union all
                select b.batch_id, (cte.quantity+1) as quantity
                from batch_split cte
                join batch b on b.batch_id = cte.batch_id and b.quantity > cte.quantity)
            select batch_id, 1 as quantity
            from batch_split) x),
    order_cte as
        (select *, row_number() over(order by order_number) as rn
        from (
            with recursive order_split as
                (select order_number, 1 as quantity from ord
                union all
                select o.order_number, (cte.quantity+1) as quantity
                from order_split cte
                join ord o on o.order_number = cte.order_number and o.quantity > cte.quantity)
            select order_number, 1 as quantity
            from order_split) x)
select o.order_number, b.batch_id, sum(o.quantity) as quantity
from order_cte o
left join batch_cte b on o.rn = b.rn
group by o.order_number, b.batch_id
order by o.order_number, b.batch_id;


-- --------------- Or  -------------------
with recursive cte as(
select batch_id, 1 as qt,quantity, 1 as rn
from batch 
union all
select batch_id , 1,quantity, rn+1
from cte
where quantity > rn),
cte2 as(
select order_number, 1 as qt,quantity, 1 as rn
from ord
union all
select order_number, 1,quantity, rn+1
from cte2
where quantity > rn),

ord2 as(
select order_number,qt, row_number() over(order by order_number) as r from cte2),
bt2 as(
select batch_id, qt, row_number() over(order by batch_id) as r from cte
)

select order_number,batch_id,sum(o.qt) as quantity from bt2 b
right join ord2 o
on o.r= b.r
group by 1,2;
