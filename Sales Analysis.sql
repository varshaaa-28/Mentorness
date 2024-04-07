create database Internship;
use Internship;

#1)

select * from customers 
where dob = "" and dob is not null;

#2) 

select 
	gender,
    primary_pincode,
    count(*) as count 
from 
	customers
group by
	primary_pincode, gender 
order by
	primary_pincode;

#3)

select 
	product_name,
    mrp 
from 
	products
where 
	mrp>50000;

#4)

select 
	count(name) as count,
    pincode 
from 
	delivery_person
group by
	pincode;

#5)

select 
	delivery_pincode,
	count(order_id) as order_count,
    sum(total_amount_paid) as sum_of_amount_paid,
    avg(total_amount_paid) as average_amount_paid,
	max(total_amount_paid) as max_amt_paid, 
    min(total_amount_paid) as min_amt_paid
from 
	orders
where 
	payment_type = "cash" and order_type = "buy"
group by 
	delivery_pincode;

#6)

select 
	delivery_person_id, count(order_id) as count_of_id ,
    sum(total_amount_paid) as total_amt 
from 
	orders
where 
	product_id = "12350" or product_id = "12348" 
    and tot_units>8 
    and order_type = "buy"
group by
	delivery_person_id
order by
	sum(total_amount_paid) desc;


#7)

select
	concat_ws(' ',first_name, last_name) as full_name 
from 
	customers
where 
	email like "%gmail.com%";

#8)

select 
	delivery_pincode, 
    avg(total_amount_paid) as amount 
from  
	orders
where 
	order_type="buy" 
group by
	delivery_pincode having avg(total_amount_paid) >150000;

#9)

select
	order_date, day(order_date) as order_day, month(order_date) as order_month, year(order_date) as order_year
from orders;

#10)

select * from orders
where order_type="buy";

select 
    month(order_date) as month,
    count(*) as total_orders,
    sum(case when order_type = 'return' then 1 else 0 end) as returned_orders,
    (100.0 * sum(case when order_type = 'return' then 1 else 0 end)) / sum(case when order_type="buy" then 1 else 0 end) as return_rate
from 
    orders
group by
    month(order_date);

#11) 

alter table 
	products
rename column 
	MyUnknownColumn to product_id;
    
select 
	products.brand,
	sum(orders.tot_units) as total_units_sold,
	sum(case when orders.order_type = "return" then orders.tot_units else 0 end) as total_returned_units
from 
	products
left join 
	orders on products.product_id = orders.product_id
group by
	products.brand;
    
#12)

select 
	count(distinct customers.cust_id) as count_of_customers,
	count(distinct delivery_person.delivery_person_id) as count_of_delivery_person,
	pincode.state
from 
	customers
left join
	delivery_person on customers.primary_pincode =  delivery_person.pincode
left join 
	pincode on customers.primary_pincode = pincode.pincode 
group by
	pincode.state;

#13)
      
select 
	customers.cust_id,
    sum(orders.tot_units) as total_units_ordered,
    sum(case when orders.delivery_pincode = customers.primary_pincode then orders.tot_units else 0 end) as units_ordered_primary,
    sum(case when orders.delivery_pincode <> customers.primary_pincode then orders.tot_units else 0 end) as units_ordered_not_primary,
    (100.0 * sum(case when orders.delivery_pincode = customers.primary_pincode then orders.tot_units else 0 end)) / sum(orders.tot_units) as percentage_ordered_primary
from 
    orders
left join 
    customers on orders.cust_id = customers.cust_id
group by
    customers.cust_id
order by
    percentage_ordered_primary desc;
      
#14) 

select 
    product_name,
	sum(orders.tot_units) as total_units, 
    sum(orders.total_amount_paid) as total_amt, 
    sum(orders.displayed_selling_price_per_unit*orders.tot_units) as total_displayed_selling_price,
    sum(products.mrp*orders.tot_units) as total_mrp,
    (100.0 - 100.0 * sum(orders.total_amount_paid) / sum(orders.displayed_selling_price_per_unit*orders.tot_units)) as net_discount_selling_price,
    (100.0 - 100.0 * sum(orders.total_amount_paid) / sum(products.mrp*orders.tot_units)) as net_discount_mrp
from 
    orders
left join 
	products on orders.product_id = products.product_id
group by
    products.product_name;
    
#15)
     
select 
    products.product_name, 
    orders.order_id,
    (100.0 - (100.0 * sum(orders.total_amount_paid) / sum(orders.displayed_selling_price_per_unit*orders.tot_units))) as discount_percent
from 
    orders
left join 
    products on orders.product_id = products.product_id
where 
    orders.order_type = "buy"
group by 
	products.product_name, orders.order_id
having 
    discount_percent > 10.10
order by
    discount_percent desc;
      
#16)
 
select 
	products.category,
    sum(orders.total_amount_paid - products.procurement_cost_per_unit*orders.tot_units) as absolute_profit,
     100* (sum(orders.total_amount_paid)/ sum(products.procurement_cost_per_unit*orders.tot_units))-100 as percentage_profit
from 
	orders
left join 
	products on orders.product_id = products.product_id
group by
	products.category;
    
#17)

select 
	delivery_person.name ,
    count(distinct orders.order_id) as total_ids,
    sum(case when month(order_date) =1 then 1 else 0 end) as Jan,
    sum(case when month(order_date) =2 then 1 else 0 end) as Feb,
    sum(case when month(order_date) =3 then 1 else 0 end) as Mar,
    sum(case when month(order_date) =4 then 1 else 0 end) as Apr,
    sum(case when month(order_date) =5 then 1 else 0 end) as May,
    sum(case when month(order_date) =6 then 1 else 0 end) as Jun,
    sum(case when month(order_date) =7 then 1 else 0 end) as Jul,
    sum(case when month(order_date) =8 then 1 else 0 end) as Aug,
    sum(case when month(order_date) =9 then 1 else 0 end) as Sep,
    sum(case when month(order_date) =10 then 1 else 0 end) as Oct,
    sum(case when month(order_date) =11 then 1 else 0 end) as Nov,
    sum(case when month(order_date) =12 then 1 else 0 end) as Decm
from 
	orders
left join 
	delivery_person on orders.delivery_pincode = delivery_person.pincode
where 
	orders.order_type="buy"
group by
	delivery_person.name;

#18)

select
	customers.gender,
    products.product_name,
	sum(orders.total_amount_paid - products.procurement_cost_per_unit*orders.tot_units) as absolute_profit,
	100* (sum(orders.total_amount_paid)/ sum(products.procurement_cost_per_unit*orders.tot_units))-100 as percentage_profit
from 
	orders
left join 
	customers on orders.cust_id = customers.cust_id
left join
	products on orders.product_id = products.product_id
group by
	customers.gender, 
    products.product_name;

#19)

select 
	products.product_name,
	orders.tot_units,
    round((avg((orders.displayed_selling_price_per_unit*orders.tot_units)-orders.total_amount_paid)/orders.tot_units),2) as discount_given_per_unit
from
	orders
left join 
	products on orders.product_id = products.product_id
where 
	orders.order_type = "buy" and products.product_name = "Dell AX420"
group by
	orders.tot_units
order by 
	orders.tot_units desc;

-- It suggests a trend of increasing discounts with higher purchase quantities.