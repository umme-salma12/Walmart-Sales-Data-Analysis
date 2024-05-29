-- Create database
CREATE DATABASE IF NOT EXISTS protfolioproject;

-- -- Add the time_of_day column --
alter table `walmartsalesdata.csv` add column time_of_day varchar(20);

update `walmartsalesdata.csv`
set time_of_day = (
	case 
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
    end
);

-- Add day_name column --
alter table `walmartsalesdata.csv` add column day_name varchar(20);

update `walmartsalesdata.csv`
set day_name = dayname(Date);

-- Add month_name column --
alter table `walmartsalesdata.csv` add column month_name varchar(20);

update `walmartsalesdata.csv`
set month_name = monthname(Date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------

-- 1. How many unique cities does the data have? --
select distinct city
from `walmartsalesdata.csv`;

-- 2. In which city is each branch --
SELECT city, BRANCH
FROM `walmartsalesdata.csv`
GROUP BY city, BRANCH
ORDER BY  city, BRANCH ASC;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- 1.How many unique product lines does the data have? --
select count(distinct `Product line`)
from `walmartsalesdata.csv`;

-- 2.what is the most common payment method --
select Payment, count(*) as common_payment_method
from `walmartsalesdata.csv`
group by Payment
order by common_payment_method desc
limit 1;

-- 3. What is the most selling product line --
select `Product line`, sum(Quantity) as most_selling_product_line
from `walmartsalesdata.csv`
group by `Product line`
order by most_selling_product_line desc
limit 1;

-- 4. What is the total revenue by month --
select monthname(Date) as month, round(sum(total), 2) as total_revenue
from `walmartsalesdata.csv`
group by month
order by month desc;

-- 5.what month had the largest COGS --
select monthname(date) as month, round(sum(cogs), 2) as cogs_sum
from `walmartsalesdata.csv`
group by month
order by cogs_sum desc
limit 1;

-- 6. What product line had the largest revenue --
select `Product line`, round(sum(total)) as revenue
from `walmartsalesdata.csv`
group by `Product line`
order by revenue desc
limit 1;

-- 7. what is the city with the largest revenue --
select city, round(sum(`total`), 2) as revenue
from `walmartsalesdata.csv`
group by city
order by revenue desc
limit 1;

-- 8. What product line had the largest VAT --
select 
`Product line`, round(avg(`Tax 5%`), 2) as avg_tax
from `walmartsalesdata.csv`
group by `Product line`
order by avg_tax;

-- 9.Fetch each product line and add a column to those product line showing "GOOD", "BAD". Good if its greater--
-- than average sale --
with cte as(
select round(avg(Quantity)) as avg_total
from `walmartsalesdata.csv`
)

select 
`Product line`,
case
	when avg(Quantity) > (select avg_total from cte) then "Good"
    else "BAD"
end as status
from `walmartsalesdata.csv`
group by`Product line`;


-- 10. which branch sold more products than avergae product sold --
with cte as (
	select avg(Quantity) as avg_qty from `walmartsalesdata.csv`
)
select
branch, sum(Quantity)
from `walmartsalesdata.csv`
group by branch
having sum(Quantity) > (SELECT avg_qty FROM cte);

-- 11. what is the most common product line by gender? --
select Gender, `Product line`, count(Gender) as common_products
from `walmartsalesdata.csv`
group by Gender, `Product line`;

-- 12. What is the average rating of each product line --
select `Product line`, round(avg(rating), 2) as avg_rating
from `walmartsalesdata.csv`
group by `Product line`
order by avg_rating desc;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday --
select  time_of_day, count(*) as total_sales, dayname(Date) as day_name
from `walmartsalesdata.csv`
where day_name <> 'Sunday'
group by Date
order by date asc;


-- 2. Which of the customer types bring the most revenue --
select `Customer type`, round(sum(Total), 2) as total_revenue
from `walmartsalesdata.csv`
group by `Customer type`
order by total_revenue desc
limit 1;

-- 3. Which city has the largest tax percent/VAT (Value added tax) --
select City, round(sum(`Tax 5%`), 2) as vat
from `walmartsalesdata.csv`
group by City
order by vat desc
limit 1;

-- 4. Which customer type pays the most in VAT --
select `Customer type`, round(sum(`Tax 5%`), 2) as vat
from `walmartsalesdata.csv`
group by `Customer type`
order by vat desc
limit 1;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- 1. How many unique customer types does the data have --
select distinct `Customer type`
from `walmartsalesdata.csv`;

-- 2. How many 	unique payment methods does the data have --
select distinct Payment
from `walmartsalesdata.csv`;

-- 3. what is the most common customer type --
select `Customer type`, count(*) as common_cust_type
from `walmartsalesdata.csv`
group by `Customer type`
order by common_cust_type desc
limit 1;

-- 4. which customer type buys the most --
select `Customer type`, COUNT(*) as most_buys
from `walmartsalesdata.csv`
group by `Customer type`;

-- 5. what is the gender of most of the customers --
select Gender, count(*) as total_genders
from `walmartsalesdata.csv`
group by Gender;

-- 6. what is the gender distribution per branch --
select Branch, Gender, count(*)
from `walmartsalesdata.csv`
group by  Branch, Gender;

-- 7. which time of the day do customers give more ratings --
select time_of_day, count(Rating) as rating
from `walmartsalesdata.csv`
group by time_of_day
order by rating desc;

-- 8. which time of the day do customers give most ratings per branch --
select time_of_day, Branch, avg(Rating) as rating
from `walmartsalesdata.csv`
group by Branch, time_of_day
order by branch asc;

-- 9. which day of the week has the best avg rating --
select day_name, round(avg(Rating), 2) as rating
from `walmartsalesdata.csv`
group by day_name
order by rating desc;

-- 10. which day of the week has the best average ratings per branch --
select branch, day_name, round(avg(Rating), 2) as rating
from `walmartsalesdata.csv`
group by branch, day_name
order by rating desc, branch asc;

















