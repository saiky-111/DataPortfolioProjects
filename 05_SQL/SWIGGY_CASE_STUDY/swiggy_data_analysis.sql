
CREATE TABLE swiggy(
   restaurant_no   INTEGER  NOT NULL 
  ,restaurant_name VARCHAR(50) NOT NULL
  ,city            VARCHAR(9) NOT NULL
  ,address         VARCHAR(204)
  ,rating          NUMERIC(3,1) NOT NULL
  ,cost_per_person INTEGER 
  ,cuisine         VARCHAR(49) NOT NULL
  ,restaurant_link VARCHAR(136) NOT NULL
  ,menu_category   VARCHAR(66)
  ,item            VARCHAR(188)
  ,price           VARCHAR(12) NOT NULL
  ,veg_or_nonveg   VARCHAR(7)
);


COPY swiggy (restaurant_no, restaurant_name, city, address, rating, cost_per_person, cuisine, restaurant_link, menu_category, item, price, veg_or_nonveg)
FROM 'E:\#DATA_ANALYST_PORTFOLIO_PROJECTS\05_SQL\SWIGGY_CASE_STUDY\Swiggy.csv'
DELIMITER ','
CSV HEADER;


select * from swiggy;


#Q1
HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

select count(distinct restaurant_name) 
as high_rated_restaurants
from swiggy
where rating>4.5;
-- Since, we have DISTINCT here because:
--For a particular restaurant, there are many items.
-- So, to avoid creating multiple records of the same restaurant, i.e why we are using distinct.

Output:
"high_rated_restaurants"
13 

#Q2
WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city,count(distinct restaurant_name) 
as restaurant_count from swiggy
group by city
order by restaurant_count desc
limit 1;

Output:
"city"	      "restaurant_count"
"Bangalore"	   196

#Q3
HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?
--Means Pizza in the name of the restaurant
-- Here we will do Pattern Matching and we'll use the keyword: Like

select count(distinct restaurant_name) as pizza_restaurants
from swiggy 
where restaurant_name like '%Pizza%';

--OR

select count(distinct restaurant_name) as pizza_restaurants
from swiggy 
where restaurant_name similar to '%Pizza%';

-- It will check in which restaurant , the word Pizza is present
-- The % sign means , there can be any no of words before the word Pizza
-- and after the word Pizza.

Output:
"pizza_restaurants"
4

#Q4
WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;
-- COUNT(*) AS cuisine_count: This part counts the number of rows for each distinct cuisine. 

Output:
"cuisine"	            "cuisine_count"
"North Indian,Chinese"	 3098

#Q5
WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city, avg(rating) as average_rating
from swiggy group by city;

"city"	       "average_rating"
"Ahmedabad"	   4.0686394733445205
"Bangalore"	   4.1151018754341283

#Q6
WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU
CATEGORY FOR EACH RESTAURANT?

select distinct restaurant_name,
menu_category,max(price) as highestprice
from swiggy where menu_category='Recommended'
group by restaurant_name,menu_category;


"restaurant_name"	"menu_category"	"highestprice"
"1944 - The Hocco Kitchen"	"Recommended"	"90"
"1944 The Hocco Kitchen"	"Recommended"	"90"
"9834 The Fruit Truck"	"Recommended"	"550"
"A2B Veg"	"Recommended"	"80"
..................

-- Around 149 rows are there in output.

#Q7
FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.

select distinct restaurant_name, cost_per_person
from swiggy where cuisine <> 'Indian'AND  cost_per_person IS NOT NULL
order by cost_per_person desc
limit 5;

-- <> means not equal to
-- cost_per_person , since the column cost_per_person gives the average cost per person
-- Using:  cost_per_person IS NOT NULL  , Since cost_per_person column was coming out as null.

#Q8
FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE
COST OF ALL RESTAURANTS TOGETHER.

select distinct restaurant_name,cost_per_person
from swiggy where cost_per_person > (
select avg(cost_per_person) from swiggy);

-- 1. SELECT DISTINCT restaurant_name, cost_per_person
--    - Selects unique combinations of 'restaurant_name' and 'cost_per_person'
--    - Ensures that if multiple rows have the same 'restaurant_name' and 'cost_per_person', 
--      only one will be included in the result.

SELECT DISTINCT restaurant_name, cost_per_person

-- 2. FROM swiggy
--    - Specifies the table from which to retrieve the data, in this case, 'swiggy'

FROM swiggy

-- 3. WHERE cost_per_person > (
--    - Filters the results to include only those rows where the 'cost_per_person' is greater than a certain value.
--    - This value is determined by the subquery that follows.

WHERE cost_per_person > (

    -- 4. Subquery: SELECT AVG(cost_per_person) FROM swiggy
    --    - This subquery calculates the average 'cost_per_person' across all rows in the 'swiggy' table.
    --    - The AVG() function computes the average of the 'cost_per_person' column.
    --    - The result is a single value: the average cost per person across all restaurants.
    
    SELECT AVG(cost_per_person) FROM swiggy
);


#Q9
RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARELOCATED 
IN DIFFERENT CITIES.

select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

#Q10
WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE'CATEGORY?

select distinct restaurant_name,menu_category
,count(item) as no_of_items from swiggy
where menu_category='Main Course' 
group by restaurant_name,menu_category
order by no_of_items desc limit 1;

#Q11
LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER
OF RESTAURANT NAME.

select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name;

#Q12
WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICEFOR ALL ITEMS?

select distinct restaurant_name,
avg(price) as average_price
from swiggy group by restaurant_name
order by average_price limit 1;

#Q13
WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select distinct restaurant_name,
count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc limit 5;

#Q14
WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select distinct restaurant_name,
(count(case when veg_or_nonveg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc limit 1;