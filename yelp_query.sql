show databases;
use yelp_reviews;
select * from yelp_business;
select * from yelp_user;
select * from yelp_business_hours;
select * from yelp_business_attributes;
select * from yelp_checkin;
select * from yelp_tip;
select * from yelp_review;

select count(*) from yelp_business where name like '%star%';

select yb.business_id,name,city,state,stars,review_count,categories from yelp_business as yb
inner join yelp_business_hours as ybh
on yb.business_id = ybh.business_id
inner join yelp_business_attributes as yba
on yb.business_id = yba.business_id;
-- inner join yelp_checkin as yc
-- on yb.business_id = yc.business_id;
-- left join yelp_tip as yt
-- on yb.business_id = yt.business_id;
-- where categories like '%rest%'

select * from yelp_business;
select * from yelp_checkin;
select * from yelp_business_attributes;
select * from yelp_business_hours;
select * from yelp_user;
select count(*) from yelp_business where (categories like '%restaurants%' or categories like '%food%' or categories like '%bars%') AND state in ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN',
 'IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY',
'NC','ND','OH','OK','OR','PA','RI','SC','SD','TN',
'TX','UT','VT','VA','WA','WV','WI','WY');
select * from yelp_review;

select avg(checkins) as Average_No_Of_Checkins,hour from yelp_business as yb
inner join yelp_checkin as yc
on yb.business_id = yc.business_id
where categories like '%restaurants%' or categories like '%food%' or categories like '%bars%' group by hour order by Average_No_Of_Checkins desc;


#to show which cuisines are famous across the US
with tmp as 
(Select categories,
case when categories like "%pizza%" or categories like "%italian%" then "Italian Restaurant" 
when categories like "%mexican%" then "Mexican Restaurant" 
when categories like "%thai%" then "Thai Restaurant" 
when categories like "%chinese%" then "Chinese Restaurant"  
when categories like "%america%" or categories like "%steakhouse%" then "American Restaurant" 
when categories like "%japanese%" or categories like "sushi" then "Japanese Restaurant" 
when categories like "%indian%" then "Indian Restaurant" 
when categories like "%vietnamese%" then "Vietnamese Restaurant" 
when categories like "%french%" then "French Restaurant" 
when categories like "%korean%" then "Korean Restaurant" 
when categories like "%Greek%" then "Greek Restaurant" 
when categories like "%Carribean%" then "Carribean Restaurant" 
when categories like "%Middle Eastern%" or categories like "%Meditterranean%" then "Middle Eastern Restaurant"
when categories like "%german%"  then "German Restaurant"  
else "Others" end as Cuisine 
from yelp_business
where (categories like "%restaurant%" or categories like "%food%" or categories like "%bar%") and 
state in ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN',
 'IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY',
'NC','ND','OH','OK','OR','PA','RI','SC','SD','TN',
'TX','UT','VT','VA','WA','WV','WI','WY')
group by 1)

Select cuisine,
count(*) as count
from tmp
group by 1
order by 2 desc;

#To show which restaurants have highest ratings in which cities - 1

with CTE as (
select business_id, stars
from yelp_review
where useful>0 and stars between 4.5 and 5
)
select CTE.*, name, categories, neighborhood, city, state
from CTE 
inner join yelp_business as b
on CTE.business_id = b.business_id
where (categories like '%restaurants%' or categories like '%food%' or categories like '%bars%') AND
state in ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN',
 'IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY',
'NC','ND','OH','OK','OR','PA','RI','SC','SD','TN',
'TX','UT','VT','VA','WA','WV','WI','WY');

#Query to understand how many reviews counts are required 
with tmp as (Select B.*,
case when review_count between 0 and 20 then "Reviews less than 20"
when review_count between 21 and 40 then "Reviews between 21-40"
when review_count between 41 and 60 then "Reviews between 41-60"
when review_count between 61 and 80 then "Reviews between 61-80"
when review_count between 81 and 100 then "Reviews between 81-100"
else "Bin greater than 100" end as Counter_Bins
from yelp_business B
where (categories like "%restaurants%" or categories like "%food%" or categories like "%bar%")
and (stars >=5) and is_open = "1")

Select Counter_Bins,
Count(*) as Counter
from tmp
group by 1;


#Query for cuisines having the highest average ratings on yelp
with tmp as 
(Select *,
case when categories like "%pizza%" or categories like "%italian%" then "Italian Restaurant" 
when categories like "%mexican%" then "Mexican Restaurant" 
when categories like "%thai%" then "Thai Restaurant" 
when categories like "%chinese%" then "Chinese Restaurant"  
when categories like "%america%" or categories like "%steakhouse%" then "American Restaurant" 
when categories like "%japanese%" or categories like "sushi" then "Japanese Restaurant" 
when categories like "%indian%" then "Indian Restaurant" 
when categories like "%vietnamese%" then "Vietnamese Restaurant" 
when categories like "%french%" then "French Restaurant" 
when categories like "%korean%" then "Korean Restaurant" 
when categories like "%Greek%" then "Greek Restaurant" 
when categories like "%Carribean%" then "Carribean Restaurant" 
when categories like "%Middle Eastern%" or categories like "%Meditterranean%" then "Middle Eastern Restaurant"
when categories like "%german%"  then "German Restaurant"  
else "Others" end as Cuisine 
from yelp_business
where (categories like "%restaurant%" or categories like "%food%" or categories like "%bar%") and 
state in ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN',
 'IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY',
'NC','ND','OH','OK','OR','PA','RI','SC','SD','TN',
'TX','UT','VT','VA','WA','WV','WI','WY'))
Select 
Cuisine,avg(stars) as average_ratings
from tmp
where is_open=1 and review_count>60
group by 1 order by average_ratings desc;

select * from yelp_user LIMIT 10000;
select * from yelp_business LIMIT 10000;
select * from yelp_review LIMIT 10000;








