select product_name, max(length(product_name)) as name_length
from product
group by product_name;

select * from product;

select product_id,
       product_name||', '||sub_category||', '||category as product_details
from product;

select product_id,
substring(product_id for 3) as first_part,
substring(product_id  from 5 for 2) as second_part,
substring(product_id from 8 for 8) as third_part
from product
where substring(product_id for 3) like '___';

select product_name, string_agg(sub_category, ', ')
from product
where sub_category in ('Chairs', 'Tables')
group by product_name;