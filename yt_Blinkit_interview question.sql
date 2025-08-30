USE superstore;
CREATE TABLE orders (
    customer_id INT,
    order_date DATE,
    coupon_code VARCHAR(50)
);

TRUNCATE TABLE Orders;

-- ✅ Customer 1: First order in Jan, valid pattern
INSERT INTO Orders VALUES (1, '2025-01-10', NULL);
INSERT INTO Orders VALUES (1, '2025-02-05', NULL);
INSERT INTO Orders VALUES (1, '2025-02-20', NULL);
INSERT INTO Orders VALUES (1, '2025-03-01', NULL);
INSERT INTO Orders VALUES (1, '2025-03-10', NULL);
INSERT INTO Orders VALUES (1, '2025-03-15', 'DISC10'); -- last order with coupon ✅

-- ✅ Customer 2: First order in Feb, valid pattern
INSERT INTO Orders VALUES (2, '2025-02-02', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-02-05', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-03-05', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-18', NULL);
INSERT INTO Orders VALUES (2, '2025-03-20', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-22', NULL);
INSERT INTO Orders VALUES (2, '2025-04-02', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-10', NULL);
INSERT INTO Orders VALUES (2, '2025-04-15', 'DISC20'); -- last order with coupon ✅
INSERT INTO Orders VALUES (2, '2025-04-16', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-18', NULL);
INSERT INTO Orders VALUES (2, '2025-04-20', 'DISC20'); -- last order with coupon ✅

-- ❌ Customer 3: First order in March but wrong multiples
INSERT INTO Orders VALUES (3, '2025-03-05', NULL);  -- Month1 = 1
INSERT INTO Orders VALUES (3, '2025-04-10', NULL);  -- Month2 should have 2, but only 1 ❌
INSERT INTO Orders VALUES (3, '2025-05-15', 'DISC30');

-- ❌ Customer 4: First order in Feb but missing March (gap)
INSERT INTO Orders VALUES (4, '2025-02-01', NULL);  -- Month1
INSERT INTO Orders VALUES (4, '2025-04-05', 'DISC40'); -- Skipped March ❌

-- ❌ Customer 5: Valid multiples but last order has no coupon
INSERT INTO Orders VALUES (5, '2025-01-03', NULL);  -- M1 = 1
INSERT INTO Orders VALUES (5, '2025-02-05', NULL);  -- M2 = 2
INSERT INTO Orders VALUES (5, '2025-02-15', NULL);
INSERT INTO Orders VALUES (5, '2025-03-01', NULL);  -- M3 = 3
INSERT INTO Orders VALUES (5, '2025-03-08', 'DISC50'); -- coupon mid
INSERT INTO Orders VALUES (5, '2025-03-20', NULL);     -- last order no coupon ❌

-- ❌ Customer 6: Skips month 2, should be excluded
INSERT INTO Orders VALUES (6, '2025-01-05', NULL);     -- Month1 = 1 order
-- (no orders in Feb, so Month2 is missing ❌)
INSERT INTO Orders VALUES (6, '2025-03-02', NULL);     -- Month3 = 1st order
INSERT INTO Orders VALUES (6, '2025-03-15', NULL);     -- Month3 = 2nd order
-- Jump to May (Month5 relative to Jan)
INSERT INTO Orders VALUES (6, '2025-05-05', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-10', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-25', 'DISC60'); -- Last order with coupon

select * from orders;

-- query to return 
-- customer who placed orders in 3 consecutive months
-- number of orders in second month is exactly he double of first month
-- number of orders in third month is exactly he triple of first month
-- their last order was placed with a coupon code
with month_cte as(
select *,month(order_date) as mth  from orders),
mth_wise as(
select customer_id,mth, count(order_date) as num_of_orders 
 from month_cte
 group by 1,2),
  cnd_wise as(
 select *, lag(num_of_orders) over(partition by customer_id order by mth) as lg ,
 lead(num_of_orders) over(partition by customer_id order by mth) as ld ,
lag(mth) over(partition by customer_id order by mth) as lg_mth ,
 lead(mth) over(partition by customer_id order by mth) as ld_mth
 from mth_wise),
 cnd_sat as(
 select * from cnd_wise
 where num_of_orders =2* lg and ld = 3*lg and lg_mth = mth-1 and ld_mth = mth+1),
 last_promo_code as(
select * from orders
where (customer_id,order_date) in (select 
customer_id, max(order_date) as last_ord_date from orders group by 1))

select * from  cnd_sat c 
join last_promo_code l 
on c.customer_id = l.customer_id
where coupon_code is not null;



 -- Youtube's Approach
 
 
 WITH cte AS (
  SELECT
    customer_id,
    coupon_code,
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    MIN(DATE_FORMAT(order_date, '%Y-%m-01')) OVER (PARTITION BY customer_id) AS first_order_month,
    last_value(coupon_code) OVER (PARTITION BY customer_id ORDER BY order_date 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_cc
  FROM
    orders
),
cte2 as(
SELECT
  *,
  PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM order_month), EXTRACT(YEAR_MONTH FROM first_order_month)) + 1 AS month_number
FROM
  cte
  WHERE last_order_cc is not null),
  cte3 as(
   select customer_id,last_order_cc,
 sum(case when month_number =1 then 1 else 0 end) as cnt_first_mnth,
 sum(case when month_number =2 then 1 else 0 end) as cnt_sec_mnth,
 sum(case when month_number =3 then 1 else 0 end) as cnt_third_mnth
 from cte2 
 where month_number in (1,2,3)
 group by 1,2)
 
 select * from cte3 
 where cnt_sec_mnth = 2* cnt_first_mnth  and cnt_third_mnth= 3* cnt_first_mnth 

 