CREATE OR REPLACE VIEW Purchase_History_View AS
(
	with final_table as (select distinct t.transaction_id, h.sku_id, g.group_id, c.customer_id, transaction_datetime, 
t.transaction_store_id, s.sku_purchase_price*h.sku_amount AS group_cost,
h.sku_summ AS group_summ,
h.sku_summ_paid AS group_summ_paid
from transactions t
join cards c on t.customer_card_id=c.customer_card_id
join checks h on h.transaction_id=t.transaction_id
join product_grid g on g.sku_id=h.sku_id
join stores s on s.transaction_store_id=t.transaction_store_id AND s.sku_id=h.sku_id)

select p.customer_id,f.transaction_id,f.transaction_datetime, f.group_id, f.group_cost, f.group_summ, f.group_summ_paid
from  personal_information p
full join final_table f on p.customer_id=f.customer_id
order by 1,2
);

select * from Purchase_History_View