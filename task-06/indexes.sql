drop index catalog.products_name_idx cascade;
-- 1) Создание индекса
create index products_name_idx on catalog.products (name);
analyse catalog.products;

select pg_size_pretty(pg_table_size('products')) as table_size,
       pg_size_pretty(pg_table_size('products_name_idx')) as index_size;

explain
select name
from catalog.products
where name = 'NIVEA Gift box classic';

-- 2) Вывод команды explain:
-- Index Only Scan using products_name_idx on products  (cost=0.42..4.44 rows=1 width=26)
-- Index Cond: (name = 'NIVEA Gift box classic'::text)
