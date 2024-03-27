CREATE OR REPLACE VIEW Periods_View AS
(
	with uniq_id_table as 
(select *,
count(transaction_id) over (partition by  group_id, customer_id) from 
(select distinct t.transaction_id, h.sku_id, g.group_id, c.customer_id
from transactions t
join cards c on t.customer_card_id=c.customer_card_id
join checks h on h.transaction_id=t.transaction_id
join product_grid g on g.sku_id=h.sku_id
join stores s on s.transaction_store_id=t.transaction_store_id AND s.sku_id=h.sku_id))

select distinct p.customer_id, a.group_id, a.first_group_purchase_date, a.last_group_purchase_date, a.group_purchase,
((EXTRACT(EPOCH FROM (a.last_group_purchase_date-a.first_group_purchase_date)/86400))+1)/a.group_purchase AS group_frequency,
case when min(a.group_min_discount) over (partition by  a.group_id, a.customer_id)=1000000 then 0
else min(a.group_min_discount) over (partition by  a.group_id, a.customer_id) end AS group_min_discount
from 
(select distinct g.group_id, c.customer_id, 
min(t.transaction_datetime)over (partition by  g.group_id, c.customer_id) AS first_group_purchase_date,
max(t.transaction_datetime)over (partition by  g.group_id, c.customer_id) AS last_group_purchase_date,
u.count AS group_purchase,
case when(h.sku_discount/h.sku_summ)=0 then 1000000 else (h.sku_discount/h.sku_summ) end AS group_min_discount
from transactions t
join cards c on t.customer_card_id=c.customer_card_id
join checks h on h.transaction_id=t.transaction_id
join product_grid g on g.sku_id=h.sku_id
join uniq_id_table u on u.transaction_id=t.transaction_id) a
full join personal_information p on p.customer_id=a.customer_id
order by 1,2
);

select * from Periods_View
