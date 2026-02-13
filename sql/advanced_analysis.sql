
-- =============================================
-- Coffee Shop Sales Analysis
-- Phase 4: Advanced Analytics
-- =============================================

use PROJECTS;

-- Task 1.Store Performance Comparison

select * from coffee_shop_sales;
select store_id,
       store_location,
       product_category,
       sum(transaction_qty) as Item_sold,
       sum(revenue)as Total_revenue,
       rank() over(partition by store_id order by sum(revenue) desc) as Category_rank
from coffee_shop_sales
group by store_id,store_location,product_category
order by store_id,store_location,category_rank;

-- Task 2. Get Only second Top Category Per Store

with Ranked_categories as(
select store_id ,
       store_location,
       product_category,
       sum(transaction_qty) as Item_sold,
       sum(revenue)as Total_revenue,
       rank() over (Partition by store_id order by sum(revenue) desc) as Category_rank
from coffee_shop_sales
group by store_id,store_location,product_category
order by store_id )
select * 
from Ranked_categories 
where Category_rank = 2;

-- Task 3. Moving Average (7-day)

select transaction_date,
       sum(revenue) as Daily_sales,
       avg(sum(revenue)) over(order by transaction_date 
       rows between 6 preceding and current row)as Seven_day_avg
from coffee_shop_sales
group by transaction_date
order by transaction_date;
       
-- Task 4.Product Mix Analysis
/*"Within each product category, what is the revenue contribution (percentage) 
of each specific product type, and how do they rank by sales
*/

with Product_stats as (
select product_category,
       Product_type,
       count(*) as Total_transaction,
       sum(transaction_qty) as Item_sold,
       sum(Revenue) as Total_sale
from coffee_shop_sales
group by product_category,product_type
)
select *,
      round(Total_sale*100/sum(Total_sale) over(partition by product_category),2) as Percent_of_category
from Product_stats
order by product_category,Total_sale desc;

 -- Task 5. Customer Basket Analysis (Multi-item transactions)
 
select transaction_id,
       count(distinct product_category) as Categories_purchased,
       sum(revenue) as Busket_value
from coffee_shop_sales
group by transaction_id
having count(*) > 1
order by Busket_value desc
limit 20;
