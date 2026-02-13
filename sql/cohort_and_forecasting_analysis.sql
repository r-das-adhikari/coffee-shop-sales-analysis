
-- ==========================================
-- Coffee Shop Sales Analysis
-- cohort_and_forecasting_analysis
-- ==========================================


-- ========================================================================================
-- TASK 1: Customer Segmentation by Transaction Value
-- Purpose: Classify transactions as Low/Medium/High value to understand customer behavior
-- ========================================================================================

-- Step 1: Determine value thresholds

select 
      min(revenue) as min_transaction,
      max(revenue) as max_transaction,
      avg(revenue) as Avg_transaction,
      (select revenue from (
      select revenue, percent_rank() over (order by revenue) as p
      from coffee_shop_sales) t 
      where p >= 0.33 limit 1) as low_threshold,
      (select revenue from (
      select revenue , percent_rank() over (order by revenue) as p 
      from coffee_shop_sales) t 
      where p >= 0.67 limit 1) as High_threshold
from coffee_shop_sales;
      
-- Step 2: Segment transactions into Low/Medium/High value 
with transaction_segments as (
	select transaction_id,
		   transaction_date,
		   store_location,
		   product_category,
		   revenue,
		   case
			   when revenue < 3.5 then 'Low Value'
			   when revenue between 3.5 and 5.1 then 'Medium Value'
			   else 'High Value'
			end as value_segment
	from coffee_shop_sales
    )
    select value_segment,
           count(*) as Transaction_count,
           round(count(*)*100/(select count(*) from coffee_shop_sales),2) as pct_of_total,
           round(sum(revenue),2) as Total_revenue,
           round(avg(revenue),2) as avg_transaction_value
from transaction_segments
group by value_segment
order by avg_transaction_value;

-- Step 3: Segment by Store Location

with transaction_segment as (
	select store_location,
           revenue,
           case
           when revenue < 3.5 then 'Low Value'
           when revenue between 3.5 and 5.1 then 'Medium Value'
           else 'High Value'
           end as Value_segment
	from coffee_shop_sales
    )
select store_location ,
       Value_segment,
       count(*) as Transaction_count,
       round(sum(revenue),2) as Revenue
from transaction_segment
group by store_location,value_segment
order by Revenue desc;

-- ===================================================
-- TASK 2: Cohort Analysis - First Purchase Month
-- ===================================================

select * from coffee_shop_sales;
 With Product_first_sales as (
	select product_detail,
           min(transaction_date) as first_sale_date,
           date_format(min(transaction_date), '%Y-%m') as Cohort_month
	from coffee_shop_sales
    group by product_detail) ,
    
cohort_performance as (
	select pfs.cohort_month,
           date_format(css.transaction_date,'%Y-%m') as transaction_month,
           count(distinct css.product_detail) as active_products,
           count(*) as transactions,
           round(sum(css.revenue),2) as Revenue
	from coffee_shop_sales css
    join Product_first_sales pfs on css.product_detail=pfs.product_detail
    group by pfs.cohort_month,transaction_month)
select cohort_month,
       transaction_month,
       active_products,
       transactions,
       Revenue,
       round(Revenue/transactions,2) as avg_transaction
from cohort_performance
order by cohort_month,transaction_month;

-- ====================================================
-- TASK 3: Month-over-Month (MoM) Growth Analysis
-- ====================================================

with Monthly_cohorts  as (
      select date_format(transaction_date,'%Y-%m') as Purchase_month,
             product_category,
             count(*) as Transactions,
             round(sum(revenue),2) as Revenue
	 from coffee_shop_sales
     group by Purchase_month,product_category
     )
     select product_category,
            Purchase_month,
            Transactions,
            Revenue,
            lag(revenue) over (partition by product_category order by Purchase_month) as previous_month_revenue,
            round(
                 100*(revenue - lag(revenue) over (partition by product_category order by Purchase_month))/
                 nullif (lag(revenue) over (partition by product_category order by Purchase_month),0),2) as revenue_growth_pct
	 from Monthly_cohorts
     order by product_category,Purchase_month;

-- ======================================================
-- TASK 4: Revenue Forecasting Using Moving Averages
-- ======================================================

-- Step 1: Calculate monthly revenue with trends

with monthly_revenue as (
	select date_format(transaction_date,'%Y-%m') as years_month,
           round(sum(revenue),2) as monthly_revenue
	from coffee_shop_sales
    group by years_month),
-- Step 2: Calculate 3-month moving average
revenue_with_ma as(
	select years_month,
           monthly_revenue,
           round(avg(monthly_revenue) over (order by years_month rows between 2 preceding and current row),2) as monthly_avg_3ma,
           coalesce(lag(monthly_revenue,1) over (order by years_month),0.00) as prev_month_rev,
           coalesce(lag(monthly_revenue,12) over (order by years_month),0.00) as same_month_last_year
	from monthly_revenue )
select years_month,
       monthly_revenue,
       monthly_avg_3ma,
       prev_month_rev,
       same_month_last_year,
       -- monthly growth rate
       coalesce(round(100*(monthly_revenue-prev_month_rev)/nullif(prev_month_rev,0),2),0.00) as monthly_growth_pct,
       -- year over year growth
       coalesce(round(100*(monthly_revenue - same_month_last_year)/nullif(same_month_last_year,0),2),0.00) as yoy_growth_pct
from revenue_with_ma
order by years_month;
       

-- Simple forecast: Next month = 3-month average

select 'Forecast' as years_month,
       round(avg(monthly_revenue),2) as predicted_revenue
from (
     select date_format(transaction_date,'%Y-%m') as Years_month,
            sum(revenue) as monthly_revenue
	 from coffee_shop_sales
     group by Years_month
     order by monthly_revenue desc
     limit 3) as recent_months;

-- every month forecast

select years_month,
       monthly_revenue,
       coalesce(round(avg(monthly_revenue) over (order by years_month rows between 3 preceding and 1 preceding ),2),0.00) as next_month_forecast
from (
      select date_format(transaction_date,'%Y-%m') as years_month,
             sum(revenue) as monthly_revenue
	  from coffee_shop_sales
      group by years_month) as monthly_report
order by years_month;


      

   



