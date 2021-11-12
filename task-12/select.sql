select p.id, p.name as product, (select name from product_categories pc where pc.id = ppc.category_id) as category
from products p inner join products_product_categories ppc on p.id = ppc.product_id;

select p.name as product, (select name from product_categories pc where pc.id = ppc.category_id) as category
from products p left join products_product_categories ppc on p.id = ppc.product_id;

select
       o.order_number,
       o.created_at,
       o.created_at,
       o.status,
       o.items,
       c.name,
       c.contact,
       (select concat_ws(' ', da.country, da.city, da.street, da.building) from delivery_addresses da where da.id = o.delivery_address_id) as delivery_address
from orders o left join customers c on c.id = o.customer_id;

select id from products where name like 'sony%';

select id from discounts where start_date > '2021-11-10' and end_date <= '2021-12-30';

select id from prices where amount between 100.0 and 300.0;

select id from orders where status in ('preparing', 'delivering');

select id from prices where discount_id is not null;