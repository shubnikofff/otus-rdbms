-- product_categories
truncate table catalog.product_categories restart identity cascade;
insert into catalog.product_categories (name)
select generate_text(20)
from generate_series(1, 500);

-- producers
truncate table catalog.producers restart identity cascade;
insert into catalog.producers (name)
select generate_text(15)
from generate_series(1, 100000);

-- catalog.products
truncate table catalog.products restart identity cascade;
insert into catalog.products (name, producer_id)
select generate_text(25), generate_number(1, 100000)
from generate_series(1, 1000000);

-- catalog.products_product_categories
truncate table catalog.products_product_categories restart identity cascade;
insert into catalog.products_product_categories (product_id, category_id)
select generate_number(1, 100000), generate_number(1, 500)
from generate_series(1, 1000000);