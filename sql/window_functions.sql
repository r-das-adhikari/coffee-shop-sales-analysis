
-- ==================================
-- Coffee Shop Sales Analysis
-- Advance Windos Functions 
-- ==================================

-- Task 1 : Calculate a 3-day moving average of the unit_price
select * from coffee_shop_sales;
select transaction_date,
       round(sum(unit_price),2)as Total_unit_price,
       round(avg(sum(unit_price)) over(order by transaction_date 
       rows between 2 preceding and current row),2) as Three_day_moving_average
from coffee_shop_sales
group by transaction_date;

SELECT 
    transaction_date,
    SUM(unit_price) AS daily_total_price,
    AVG(SUM(unit_price)) OVER(
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3day
FROM coffee_shop_sales
GROUP BY transaction_date;

-- Task 2: The Cumulative Total (Running Sum)
/*Goal: Create a "Bank Account" style view of total items sold.*/

select transaction_date,
       sum(transaction_qty),
       sum(sum(transaction_qty)) over(order by transaction_date 
       rows between unbounded preceding and current row) as Running_total_item_sold
from coffee_shop_sales
group by transaction_date;

-- Task 3: The Centered Window (Trend Analysis)
/* Goal: Compare a day to its immediate neighbors.*/

select transaction_date,
       sum(revenue)as Total_sale,
       avg(sum(revenue)) over(order by transaction_date 
       rows between 1 preceding and 1 following) as trend_analysis
from coffee_shop_sales
group by transaction_date;
       
-- Task 4: The Forward-Looking Window
/* The Goal: Future Inventory Planning. Scenario: You are the manager. Every morning, 
you look at the data to see how many items were sold on average over the next 3 days (including today) 
so you know how much milk to stock.*/

select transaction_date,
       sum(transaction_qty) as Item_sold,
       avg(sum(transaction_qty)) over(order by transaction_date 
       rows between current row and 2 following) as inventory_planning
from coffee_shop_sales
group by transaction_date ;

-- Task 5: The "Gold Medal" Days (RANK)
/* Goal: Find the top-performing days for revenue.*/
select transaction_date,
       sum(revenue) as Daily_revenue,
       rank() over(order by sum( revenue) desc ) as Top_performing_day
from coffee_shop_sales
group by transaction_date;

-- Task 6: The Consistent Leader (DENSE_RANK)
/* Goal: Rank product categories by popularity without skipping numbers.*/

select * from coffee_shop_sales;
select product_category,
       sum(transaction_qty) as Popularity,
       dense_rank() over(order by sum(transaction_qty) desc) as Popularity_rank
from coffee_shop_sales
group by product_category;

-- Task 7: The Partitioned Rank (Math Challenge)
/* Goal: Find the busiest hour for each specific month.*/

select * from coffee_shop_sales;

select month,
       hour,
       sum(revenue) as total_transaction ,
       rank() over(partition by month order by sum(revenue) desc ) as hour_rank
from coffee_shop_sales
group by month,hour
order by month;

       
-- Task 8: The Ultimate Combo (Rank + Frame)
/* Goal: Filter the "Noise" then Rank.
Scenario: We want to rank days, but daily sales are too "jumpy." We want to rank them based on their 7-day moving average instead of raw daily sales.
Task: 1. Calculate a 7-day moving average (like we did before). 2. Wrap that in a RANK() function to see which week-long period was truly the strongest.
Hint: This will require a CTE (Common Table Expression) or a Subquery.*/

with day_details as (
select transaction_date,
       sum(revenue) as Daily_sale,
       avg(sum(revenue))over (order by transaction_date rows between 6 preceding and current row ) as seven_day_avg
from coffee_shop_sales
group by transaction_date)
select transaction_date,
       Daily_sale,
       seven_day_avg,
       rank()over(order by seven_day_avg desc) as Performance_rank
from day_details;

       





