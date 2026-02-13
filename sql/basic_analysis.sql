
-- =============================================
-- Coffee Shop Sales Analysis
-- Phase 3: Basic Business Analytics
-- =============================================

use PROJECTS;

-- Task 1. Total Revenue & Transactions

select count(transaction_id) as Total_transactions,
       sum(revenue) as Total_Revenue,
       avg(revenue) as Average_transaction_value
from coffee_shop_sales;

-- Task 2.Top 10 Best-Selling Products

select product_detail,
       sum(transaction_qty)as Total_qty_sold,
       sum(revenue) as Total_revenue
from coffee_shop_sales
group by product_detail
order by Total_revenue desc 
limit 10;

-- Task 3.Revenue by Store Location

select store_location,
       count(*) as Transactions,
       sum(revenue) as Total_revenue,
       round(avg(revenue),2) as avg_sale
from coffee_shop_sales
group by store_location
order by Total_revenue desc;

-- Task 4.Sales by Product Category

select product_category,
       count(*) as Transactions_count,
       sum(transaction_qty) as Item_sold,
       sum(revenue) as Total_revenue,
       round(sum(revenue)*100/(select Sum(revenue) from coffee_shop_sales) , 2) as Revenue_percent
from coffee_shop_sales
group by product_category
order by Total_revenue desc;

-- Task 5.Peak Hours Analysis

select hour,
       count(*) as Transaction_count,
       sum(transaction_qty) as Item_sold,
       sum(revenue) as Total_revenue,
       round(avg(revenue),2) as avg_sale
from coffee_shop_sales
group by hour
order by hour;

-- Task 6.Monthly Sales Trend

select date_format(transaction_date,'%Y-%m') as years_month,
       count(*) as Total_transactions,
       sum(transaction_qty) as Item_sold,
       sum(revenue) as Total_revenue
from coffee_shop_sales
group by years_month
order by years_month;
       

-- Task 7.Best Day of Week

select day_of_week,
       count(*) as Transaction_count,
       sum(revenue) as Total_revenue,
       round(avg(revenue),2) as Avg_sale
from coffee_shop_sales
group by day_of_week
order by Total_revenue desc;
