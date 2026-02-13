
-- =============================================
-- Coffee Shop Sales Analysis
-- Phase 5: Create Views for Dashboard
-- =============================================


-- View 1: Daily Summary
create view  daily_summary as 
select transaction_date,
       count(*) as transactions,
       sum(revenue) as Total_revenue,
       avg(revenue) as avg_transaction
from coffee_shop_sales
group by transaction_date;

-- View 2: Product Performance
create view  product_performance AS
select  
    product_category,
    product_type,
    count(*) as sold_count,
    sum(revenue) as total_revenue,
    round(avg(unit_price), 2) as avg_price
from coffee_shop_sales
group by product_category, product_type;

-- View 3: Store Metrics
Create view store_metrics as 
select  
    store_location,
    count(distinct transaction_date) as days_open,
    count(*) as total_transactions,
    sum(revenue) as total_revenue,
    round(sum(revenue) / count(distinct transaction_date), 2) as avg_daily_revenue
from coffee_shop_sales
group by  store_location;



