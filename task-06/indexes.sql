-- 1) Создание индекса
create index products_name_idx on catalog.products using btree (name);
create index products_producer_id_idx on catalog.products using btree (producer_id);
analyse catalog.products;

select pg_size_pretty(pg_table_size('products'))                 as table_size,
       pg_size_pretty(pg_table_size('products_name_idx'))        as products_name_index_size,
       pg_size_pretty(pg_table_size('products_producer_id_idx')) as producer_id_index_size;

explain analyse
select name
from catalog.products
where name = 'NIVEA Gift box classic';

explain analyze
select products.name, p.name
from catalog.products
         left join producers p on p.id = products.producer_id
where products.name = 'NIVEA Gift box classic';

-- 2) Вывод команды explain:

-- 2.1) Для первого запроса применился Index Only Scan с использованием products_name_idx так как все запрашиваемые данные содержатся в самом индексе (столбец name)
-- Index Only Scan using products_name_idx on products  (cost=0.42..4.44 rows=1 width=26) (actual time=0.024..0.024 rows=0 loops=1)
--   Index Cond: (name = 'NIVEA Gift box classic'::text)
--   Heap Fetches: 0
-- Planning Time: 0.201 ms
-- Execution Time: 0.046 ms

-- 2.2) Для второго запроса применился Index Scan по двум индексам: producers_pkey для join и products_name_idx для фильтрации
-- Nested Loop Left Join  (cost=0.72..16.75 rows=1 width=42) (actual time=0.016..0.017 rows=0 loops=1)
--   ->  Index Scan using products_name_idx on products  (cost=0.42..8.44 rows=1 width=34) (actual time=0.016..0.016 rows=0 loops=1)
--         Index Cond: ((name)::text = 'NIVEA Gift box classic'::text)
--   ->  Index Scan using producers_pkey on producers p  (cost=0.29..8.31 rows=1 width=24) (never executed)
--         Index Cond: (id = products.producer_id)
-- Planning Time: 0.180 ms
-- Execution Time: 0.036 ms

-- 3) Реализция индекса для полнотекстового поиска
-- Для ускорения полнотекстового поиска используется индексы GIN и GIST. В своей реализации я использовал GIN:
create index products_description_idx on catalog.products using gin (description);
analyse catalog.products;
select pg_size_pretty(pg_table_size('products_description_idx'));

explain analyze
select description
from catalog.products
where description @@ to_tsquery('Product');

-- Bitmap Heap Scan on products  (cost=403.62..6294.10 rows=2500 width=32) (actual time=2.189..2.190 rows=0 loops=1)
--   Recheck Cond: (description @@ to_tsquery('Product'::text))
--   ->  Bitmap Index Scan on products_description_idx  (cost=0.00..403.00 rows=2500 width=0) (actual time=2.187..2.187 rows=0 loops=1)
--         Index Cond: (description @@ to_tsquery('Product'::text))
-- Planning Time: 0.273 ms
-- Execution Time: 2.210 ms
