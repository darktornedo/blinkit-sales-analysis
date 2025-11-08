-- creating a database
create database blinkit_db;
use blinkit_db;

-- see all the imported data
select * from blinkit_sales;

-- set sql safe updates to 0 to update the dataset
set SQL_SAFE_UPDATES = 0;

-- data cleaning
update blinkit_sales
set item_fat_content =
   case
       when item_fat_content in ("LF","low fat") then "Low Fat"
       when item_fat_content = "reg" then "Regular"
       else item_fat_content
       end;

select distinct item_fat_content from blinkit_sales;

-- KPI's 
-- Total Sales
select round(sum((sales)/1000000.0),1) from blinkit_sales;

-- Average Sales
select round(avg(sales),0) from blinkit_sales;

-- Total number of orders
select count(*) as no_of_orders
from blinkit_sales;

-- Total number of items
select count(distinct item_type) as no_of_items from blinkit_sales;

-- Average Ratings
select cast(avg(rating) as decimal(10,1)) as avg_ratings
from blinkit_sales;

-- Total Sales by Fat Content
select distinct item_fat_content, round(sum(sales),2) as total_sales
from blinkit_sales
group by item_fat_content
order by total_sales DESC;


-- Total Sales by Item Types
select distinct item_type, round(sum(sales),2) as total_sales
from blinkit_sales
group by item_type;


-- Fat Content by Outlet for Total Sales
SELECT 
    outlet_location_type,
    round(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN sales ELSE 0 END),2) AS Low_Fat,
    round(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN sales ELSE 0 END),2) AS Regular
FROM 
    blinkit_sales
GROUP BY 
    outlet_location_type
ORDER BY 
    outlet_location_type;


-- Total Sales by Outlet Establishment
select distinct outlet_establishment_year, round(sum(sales),2) as total_sales
from blinkit_sales
group by outlet_establishment_year
order by outlet_establishment_year;


-- Percentage of Sales by Outlet Size
select outlet_size, round(sum(sales),2) as total_sales, 
round(
     (sum(sales)*100)/(select sum(sales) from blinkit_sales),2) as percentage_of_sales
from blinkit_sales
group by outlet_size
order by total_sales DESC;


-- Sales by Outlet Location
select outlet_location_type, round(sum(sales),2) as total_sales
from blinkit_sales
group by outlet_location_type
order by total_sales desc;


-- All Metrics by Outlet Type
select outlet_type, round(sum(sales),2) as total_sales, round(avg(sales),2) as avg_sales, count(distinct item_type) as no_of_items,
count(*) as no_of_orders, round(avg(rating),2) as avg_rating, round(avg(item_visibility),2) as item_visibility
from blinkit_sales
group by outlet_type
order by total_sales DESC;