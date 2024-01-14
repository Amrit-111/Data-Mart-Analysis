use case1;
select * from weekly_sales limit 10;
# Data Cleansing
drop table clean_weekly_sales;
create table clean_weekly_sales as 
select week_date,
week(week_date) as week_number,
month(week_date) as month_number,
year(week_date) as calender_year,
region,platform,
case
when segment = null then 'Unknown'
else segment
end as segment,
case
     when right(segment,1)='1' then 'Young Adults'
     when right(segment,1)='2' then 'Middle Aged'
     when right(segment,1) in ('3','4') then 'Retaires'
     else 'Unknown'
     end as age_band,
case
when left(segment,1) = 'C' then 'Couples'
when left(segment,1) = 'F' then 'families'
else 'Unknown'
end as demographic,
customer_type,transactions,sales,
round(sales/transactions,2) as 'avg_transaction'
from weekly_sales
     
     select * from clean_weekly_sales limit 10;
     
### B. Data Exploration 
drop table seq100;
create table seq100(x int auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();

insert into seq100 select x + 50 from seq100;
select * from seq100;

drop table seq52;
create table seq52 as (select x from seq100 limit 52);
select * from seq52;
select distinct x as week_day from seq52
where x not in(select distinct week_number from clean_weekly_sales);

select distinct week_number from clean_weekly_sales;


select  calender_year,
sum(transactions) as total_transactions
from clean_weekly_sales group by calender_year;


select region,month_number,
sum(sales) as total_sales
from clean_weekly_sales 
group by month_number,region;


select platform,
sum(transactions) as totaL_transactions 
from clean_weekly_sales
group by platform;



with cte_monthly_platform_sales as 
(select month_number,calender_year,platform,
sum(sales) as monthly_sales
from clean_weekly_sales
group by month_number,calender_year,platform)

select month_number,calender_year,
round(100*max(case when platform = 'Retail'
then monthly_sales 
else null end)/sum(monthly_sales),2)
as reatil_percentage,
round(100*max(case when platform = 'shopify'
then monthly_sales 
else null end)/sum(monthly_sales),2)
as shopify_percentage 
from cte_monthly_platform_sales
group by month_number,calender_year;


select age_band,demographic,
sum(sales) as total_sales
from clean_weekly_sales
where platform = 'Retail'
group by age_band,demographic
order by total_sales desc;

