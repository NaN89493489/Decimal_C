CREATE OR REPLACE FUNCTION affinity_index(customer_n integer, group_n bigint, first_date timestamp without time zone,
	last_date timestamp without time zone)
RETURNS bigint AS $$
BEGIN 
RETURN (
	select distinct group_affinity_index from
(select p2.customer_id, p2.group_id, p2.First_Group_Purchase_Date, p2.Last_Group_Purchase_Date,
count(transaction_id) over (partition by  p2.customer_id)::numeric  AS group_affinity_index
from purchase_history_view p 
join periods_view p2 on p2.customer_id=p.customer_id and p2.group_id=p.group_id
where p2.customer_id=customer_n AND transaction_datetime >= first_date AND transaction_datetime <= last_date)
where group_id=group_n
); 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Group_Margin(n integer, count_day integer, count integer)
RETURNS TABLE ("customer" integer, "group" bigint, "group_margin" numeric) AS $$
BEGIN
RETURN QUERY(
	select distinct customer_id, group_id, sum(Group_Summ_Paid-Group_Cost) over (partition by  group_id, customer_id) from 
	(select *,
	row_number() over (partition by  group_id, customer_id order by transaction_datetime desc)
	from purchase_history_view
	where (case when n=1 then (transaction_datetime > ((select max(analysis_formation) from date_of_analysis_formation)- 
		concat(count_day, 'day')::interval) )
		   else true end))
	where (case when n=2 then (row_number<=count) else true end)
);		
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW Groups_View AS
(
with Group_Stability_Index as 
    (select distinct customer_id, group_id, avg(Group_Stability_Index) over (partition by  group_id, customer_id) AS Group_Stability_Index from (
    select * from 
    (select p.customer_id, p.group_id,
    abs( (EXTRACT(EPOCH FROM((lead(p.transaction_datetime) over (partition by  p.group_id, p.customer_id order by p.transaction_datetime))-
    p.transaction_datetime))/86400) - group_frequency)/group_frequency AS Group_Stability_Index
    from purchase_history_view p
    join periods_view w on w.customer_id=p.customer_id AND w.group_id=p.group_id) 
    where Group_Stability_Index is not null) ),

SKU_Discount as (
	select distinct customer_id, group_id, count (transaction_id) over (partition by group_id, customer_id)/group_purchase::numeric
	AS group_discount_share,
	sum(Group_Summ_Paid)  over (partition by group_id, customer_id)/
	sum(Group_Summ) over (partition by group_id, customer_id) AS group_average_discount from
	(select distinct p.customer_id, g.group_id, c.transaction_id, sku_discount, 
	 group_purchase, Group_Summ_Paid, Group_Summ
	from checks c
	join transactions t on t.transaction_id=c.transaction_id
	join cards d on t.customer_card_id=d.customer_card_id
	join personal_information p on p.customer_id=d.customer_id
	join product_grid g on g.sku_id=c.sku_id
	join periods_view w on w.customer_id=p.customer_id AND w.group_id=g.group_id
	join purchase_history_view h on  h.customer_id=p.customer_id AND t.transaction_id=h.transaction_id
	where sku_discount>0)
),

final_table as 
    (select distinct p.customer_id, g.group_id,  
    group_purchase/affinity_index(p.customer_id, g.group_id, First_Group_Purchase_Date, Last_Group_Purchase_Date)::numeric AS Group_Affinity_Index,
    (EXTRACT(EPOCH FROM(select max(analysis_formation) from date_of_analysis_formation)-Last_Group_Purchase_Date)/86400)/Group_Frequency AS group_churn_rate
    , Group_Stability_Index,
    group_margin,
    group_discount_share,
    group_min_discount AS Group_Minimum_Discount,
    group_average_discount
    from checks c
    join transactions t on t.transaction_id=c.transaction_id
    join cards d on t.customer_card_id=d.customer_card_id
    join personal_information p on p.customer_id=d.customer_id
    join product_grid g on g.sku_id=c.sku_id
    join periods_view w on w.customer_id=p.customer_id AND w.group_id=g.group_id
    join purchase_history_view h on  h.customer_id=p.customer_id AND t.transaction_id=h.transaction_id
    join Group_Stability_Index s on s.customer_id=p.customer_id AND s.group_id=g.group_id
    join SKU_Discount k on k.customer_id=p.customer_id AND k.group_id=g.group_id
    join Group_Margin(0, 0, 0) m on  m.customer=p.customer_id AND m.group=g.group_id)

select p.customer_id, f.group_id, f.group_affinity_index,
f.group_churn_rate, f.group_stability_index, f.group_margin, f.group_discount_share, f.group_minimum_discount, f.group_average_discount
from  personal_information p
full join final_table f on p.customer_id=f.customer_id 
order by 1,2
);

select * from Groups_View