-- =============================================
-- Coffee Shop Sales Analysis
-- Phase 1: Database Setup & Data Cleaning
-- =============================================

-- Create Database
create database PROJECTS;
use PROJECTS;

-- Import CSV (Table Name - coffee_shop_sales)
-- [Import using your SQL tool's import wizard]

-- Verify import
select count(*) from coffee_shop_sales;
select * from coffee_shop_sales limit 10;

-- ===================================
## Phase 2 : Add Calculated Columns
-- ===================================

-- Task 1 : Add revenue column

alter table coffee_shop_sales 
add column revenue decimal(10,2);
update coffee_shop_sales
set revenue = transaction_qty * unit_price;

-- Task 2 : Add date parts for analysis

alter table coffee_shop_sales
add column day_of_week varchar(10),
add column month varchar(10),
add column hour int;

update coffee_shop_sales
set day_of_week = dayname(transaction_date),
    month =monthname(transaction_date),
    hour=hour(transaction_time);
    
 -- Verify columns added
select * from coffee_shop_sales limit 5;   
