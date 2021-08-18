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

-- products
truncate table catalog.products restart identity cascade;
insert into catalog.products (name, producer_id, description)
select generate_text(25), generate_number(1, 100000), generate_sentence(10)
from generate_series(1, 500000);

-- products_product_categories
truncate table catalog.products_product_categories restart identity cascade;
insert into catalog.products_product_categories (product_id, category_id)
select generate_number(1, 500000), generate_number(1, 500)
from generate_series(1, 1000000);

-- suppliers
truncate table catalog.suppliers restart identity cascade;
insert into catalog.suppliers(name)
select generate_text(20)
from generate_series(1, 200000);

-- prices
truncate table catalog.prices restart identity cascade;
insert into catalog.prices(amount, start_date, end_date, product_id, supplier_id, available_quantity)
select generate_number(1, 500),
       generate_date('2020-08-11', '2020-08-20'),
       generate_date('2020-08-21', '2020-08-30'),
       generate_number(1, 500000),
       generate_number(1, 200000),
       generate_number(0, 1000)
from generate_series(1,  1000000);
