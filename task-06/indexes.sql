-- 1) Создание индекса
create index products_name_idx on catalog.products (name);
create index products_producer_id_idx on catalog.products (producer_id);
analyse catalog.products;

select pg_size_pretty(pg_table_size('products'))                 as table_size,
       pg_size_pretty(pg_table_size('products_name_idx'))        as products_name_index_size,
       pg_size_pretty(pg_table_size('products_producer_id_idx')) as producer_id_index_size;

explain analyze
select products.name, p.name
from catalog.products
         left join producers p on p.id = products.producer_id
where products.name = 'NIVEA Gift box classic';

-- 2) Вывод команды explain:
-- Nested Loop Left Join  (cost=0.72..16.75 rows=1 width=42) (actual time=0.016..0.017 rows=0 loops=1)
--   ->  Index Scan using products_name_idx on products  (cost=0.42..8.44 rows=1 width=34) (actual time=0.016..0.016 rows=0 loops=1)
--         Index Cond: ((name)::text = 'NIVEA Gift box classic'::text)
--   ->  Index Scan using producers_pkey on producers p  (cost=0.29..8.31 rows=1 width=24) (never executed)
--         Index Cond: (id = products.producer_id)
-- Planning Time: 0.180 ms
-- Execution Time: 0.036 ms

