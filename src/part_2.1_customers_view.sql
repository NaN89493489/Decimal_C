CREATE OR REPLACE VIEW Customers_View AS
(
with 
Average_Check AS (select customer_id, Customer_Average_Check,
case when PERCENT_RANK() over (order by Customer_Average_Check desc) <=0.1 then 'Hight'
when PERCENT_RANK() over (order by Customer_Average_Check desc)  <=0.35 then 'Medium'
else 'Low' end AS Customer_Average_Check_Segment
from
(select c.customer_id, sum(t.transaction_summ::float)/count(t.transaction_summ::float) AS Customer_Average_Check from cards c
join transactions t on t.customer_card_id=c.customer_card_id
group by 1)
group by 1,2),

Customer_Frequency AS (
select customer_id, Customer_Frequency,
case when PERCENT_RANK() over (order by Customer_Frequency) <=0.1 then 'Often'
when PERCENT_RANK() over (order by Customer_Frequency)  <=0.35 then 'Occasionally'
else 'Rarely' end AS Customer_Frequency_Segment 
from
(select distinct c.customer_id, (LAST_VALUE(transaction_datetime) OVER(PARTITION BY customer_id ORDER BY transaction_datetime ASC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)-
LAST_VALUE(transaction_datetime) OVER(PARTITION BY customer_id ORDER BY transaction_datetime DESC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))/count(transaction_datetime) OVER(PARTITION BY customer_id) AS Customer_Frequency
from cards c
join transactions t on t.customer_card_id=c.customer_card_id)),
--where Customer_Frequency != '00:00:00'

Inactive_Period AS
(select distinct c.customer_id, (select max(analysis_formation) from date_of_analysis_formation) - 
LAST_VALUE(t.transaction_datetime) over (partition by c.customer_id order by t.transaction_datetime
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS customer_inactive_period from cards c
join transactions t on t.customer_card_id=c.customer_card_id),

part_store as 
(select *,
case when part = max (part)over (partition by customer_id) then transaction_store_id 
else NULL end AS p_store from
(select  distinct t.transaction_store_id, c.customer_id,(count(t.transaction_id) over (partition by t.transaction_store_id, c.customer_id))/
(count(t.transaction_id) over (partition by c.customer_id))::numeric AS part
,last_value(transaction_datetime) over (partition by c.customer_id,t.transaction_store_id  ORDER BY t.transaction_datetime 
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 	last_visit
from transactions t
join cards c on t.customer_card_id=c.customer_card_id)),

last_store as 
(select *,
case when sum(avg) over (partition by customer_id)=3 then transaction_store_id else -1 end AS l_store from (
select *,
case when avg(transaction_store_id) over (partition by customer_id) = transaction_store_id
then 1 end AS avg from
(select c.customer_id, t.*,
row_number() over (partition by c.customer_id order by t.transaction_datetime desc)  AS numb
from transactions t
join cards c on t.customer_card_id=c.customer_card_id)
where numb<4)),

latest_store as (
select * from
(select distinct part_store.customer_id,
case when max(last_visit) over (partition by customer_id)=last_visit then transaction_store_id else
0	end AS latest_store from
part_store
where p_store is not null
) where latest_store!=0),


favorite_store AS 
(select distinct part_store.*,last_store.l_store,
case when l_store>-1 then l_store 
else case when max(p_store)over (partition by part_store.customer_id)=avg(p_store)over (partition by part_store.customer_id)
then max(p_store) over (partition by part_store.customer_id)
else latest_store end
end AS favorite_store
from part_store
join last_store on part_store.customer_id=last_store.customer_id
join latest_store on part_store.customer_id=latest_store.customer_id),


Previous_Table as
(select *,
case when customer_churn_rate >5 then 'Hight'
when customer_churn_rate  >2 then 'Medium'
else 'Low' end AS customer_churn_segment
from(
select Average_Check.*, Customer_Frequency.customer_frequency, Customer_Frequency.Customer_Frequency_Segment,Inactive_Period.customer_inactive_period
,(EXTRACT(EPOCH FROM Inactive_Period.customer_inactive_period)/ 86400)/(EXTRACT(EPOCH FROM Customer_Frequency.customer_frequency)/ 86400)
AS customer_churn_rate
from Average_Check
 join Customer_Frequency on Average_Check.customer_id=Customer_Frequency.customer_id
 join Inactive_Period on Average_Check.customer_id=Inactive_Period.customer_id)),
 
final_table as 
(select distinct Previous_Table.*,
 case when Customer_Average_Check_Segment = 'Low' then 
 	case when Customer_Frequency_Segment = 'Rarely' then 
		case when Customer_Churn_Segment = 'Low' then 1 
		when Customer_Churn_Segment = 'Medium' then 2 
		else 3 end
	when Customer_Frequency_Segment = 'Occasionally' then
	 	case when Customer_Churn_Segment = 'Low' then 4 
		when Customer_Churn_Segment = 'Medium' then 5 
		else 6 end
	when Customer_Frequency_Segment = 'Often' then
	 	case when Customer_Churn_Segment = 'Low' then 7 
		when Customer_Churn_Segment = 'Medium' then 8 
		else 9 end
 	end 
 when Customer_Average_Check_Segment = 'Medium' then 
 	case when Customer_Frequency_Segment = 'Rarely' then 
		case when Customer_Churn_Segment = 'Low' then 10 
		when Customer_Churn_Segment = 'Medium' then 11 
		else 12 end
	when Customer_Frequency_Segment = 'Occasionally' then
	 	case when Customer_Churn_Segment = 'Low' then 13 
		when Customer_Churn_Segment = 'Medium' then 14
		else 15 end
	when Customer_Frequency_Segment = 'Often' then
	 	case when Customer_Churn_Segment = 'Low' then 16 
		when Customer_Churn_Segment = 'Medium' then 17 
		else 18 end
    end 
 when Customer_Average_Check_Segment = 'Hight' then 
 	case when Customer_Frequency_Segment = 'Rarely' then 
		case when Customer_Churn_Segment = 'Low' then 19 
		when Customer_Churn_Segment = 'Medium' then 20
		else 21 end
	when Customer_Frequency_Segment = 'Occasionally' then
	 	case when Customer_Churn_Segment = 'Low' then 22 
		when Customer_Churn_Segment = 'Medium' then 23
		else 24 end
	when Customer_Frequency_Segment = 'Often' then
	 	case when Customer_Churn_Segment = 'Low' then 25 
		when Customer_Churn_Segment = 'Medium' then 26 
		else 27 end
    end 
 end AS customer_segment,
 favorite_store.favorite_store AS customer_primary_store
 from Previous_Table
 join favorite_store on Previous_Table.customer_id=favorite_store.customer_id)
 
select  p.customer_id, f.customer_average_check, f.customer_average_check_segment, (EXTRACT(EPOCH FROM f.customer_frequency)/ 86400) AS customer_frequency, f.customer_frequency_segment,
(EXTRACT(EPOCH FROM f.customer_inactive_period)/ 86400) AS customer_inactive_period, f.customer_churn_rate, f.customer_churn_segment, f.customer_segment, f.customer_primary_store  from personal_information p
full join final_table f on p.customer_id=f.customer_id
);

select * from Customers_View

 

