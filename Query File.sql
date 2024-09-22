-- new query--
select upper(products.product_category)as category, 
round(sum(payments.payment_value),2) sales 
from products join order_items
on products.product_id = order_items.product_id
join payments
on payments.order_id= order_items.order_id
group by product_category;

-- new query--
select orders.order_id, orders.customer_id, count(order_items.order_id)
from orders join order_items
on orders.order_id= order_items.order_id
group by orders.order_id, orders.customer_id;

-- new query--
with count_per_order as 
(select orders.order_id, orders.customer_id, count(order_items.order_id)as oc
from orders join order_items
on orders.order_id= order_items.order_id
group by orders.order_id, orders.customer_id)
select customers.customer_city,round(avg(count_per_order.oc),2)
from customers join count_per_order
on customers.customer_id= count_per_order.customer_id
group by customers.customer_city;


-- -- new query---- 
select upper(products.product_category)as category, 
round((sum(payments.payment_value)/(select sum(payment_value)from payments))*100,2) sales 
from products join order_items
on products.product_id = order_items.product_id
join payments
on payments.order_id= order_items.order_id
group by product_category order by sales desc;

select sum(payment_value)from payments;
-- new query--
select products.product_category,count(order_items.product_id),
round(avg(order_items.price ),2)
from products join order_items
on products.product_id= order_items.product_id
group by products.product_category;


SELECT * FROM ecommerce.products;


SELECT * FROM ecommerce.sales;

-- new query--
select * ,dense_rank() over(order by revenue desc) as Rank1 from
(select order_items.seller_id, sum(payments.payment_value)as Revenue
from order_items join payments
on order_items.order_id =payments.order_id
group by order_items.seller_id) as a;

-- new query--
select order_items.seller_id, sum(payments.payment_value)as Revenue
from order_items join payments
on order_items.order_id =payments.order_id
group by order_items.seller_id;


SELECT * FROM ecommerce.payments;

select sum(case when payment_installments >= 1 then 1 else 0 end)/count(*)*100 from payments;

-- new query--
select Purchase_year,customer_id, payment,d_rank
from
(select year(orders.order_purchase_timestamp) as Purchase_year,orders.customer_id,
sum(payments.payment_value) payment,
dense_rank() over (partition by year(orders.order_purchase_timestamp) 
order by  sum(payments.payment_value)desc) d_rank
from orders join  payments
on payments.order_id = orders.order_id
group by year(orders.order_purchase_timestamp),
orders.customer_id order by Purchase_year asc ) as a
where d_rank <=3;


SELECT * FROM ecommerce.orders;

select count(order_id) from orders where year(order_purchase_timestamp)=2018;

select monthname(order_purchase_timestamp)Months,count(order_id) 
as Order_Count from orders where  year(order_purchase_timestamp)=2018 group by Months;

-- new query--  
select customer_id,order_purchase_timestamp, payment,
avg(payment) over(partition by customer_id order by order_purchase_timestamp
rows between 2 preceding and current row)as Mov_avg
from
(select orders.customer_id, orders.order_purchase_timestamp,
payments.payment_value as payment
from payments join orders on payments.order_id = orders.order_id)as a;


use ecommerce;

-- new query -- 
select years , months, payment ,sum(payment)
 over(order by years, months) cumulative_sales from
(select year(orders.order_purchase_timestamp)as years,
month(orders.order_purchase_timestamp)as months,
round(sum(payments.payment_value),2)as payment from orders join payments
on orders.order_id= payments.order_id 
group by years, months order by years asc ,months asc)as a;

-- new query--
with a as (select year(orders.order_purchase_timestamp)as years,
round(sum(payments.payment_value),2)as payment from orders join payments
on orders.order_id= payments.order_id 
group by years order by years asc)
select years, ((Payment-lag(payment,1) over(order by years))/
lag(payment,1) over(order by years))*100
Year_over_year_growth from a;

SELECT * FROM ecommerce.order_items;


SELECT * FROM ecommerce.customers;


select distinct(customer_city) from customers;

select customer_state, count(customer_id)  from customers group by customer_state;
-- new query--
with a as (select customers.customer_id,
min(orders.order_purchase_timestamp)first_order
from customers join orders
on customers.customer_id = orders.customer_id
group by customers.customer_id),
b as(select a.customer_id, count(distinct orders.order_purchase_timestamp)
from a join orders
on orders.customer_id= a.customer_id
and orders.order_purchase_timestamp > first_order
and orders.order_purchase_timestamp <
date_add(first_order,interval 6 month)
group by a .customer_id)
select 100 * (count(distinct a.customer_id)/ count(distinct b.customer_id))
from a left join b
on a.customer_id= b.customer_id;


SELECT * FROM ecommerce.geolocation;


