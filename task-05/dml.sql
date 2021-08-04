truncate table catalog.product_categories, catalog.products, catalog.producers restart identity cascade;

copy catalog.product_categories (id, name) from '/var/lib/postgresql/csv/product_categories.csv' with csv header;
copy catalog.producers (id, name) from '/var/lib/postgresql/csv/producers.csv' with csv header;
copy catalog.products (id, name, producer_id) from '/var/lib/postgresql/csv/products.csv' with csv header;

-- Создание связей между товарами и категориями
insert into catalog.products_product_categories (product_id, category_id)
values (1, 3),
       (2, 3),
       (3, 1),
       (4, 5),
       (5, 5),
       (6, 5),
       (6, 8),
       (7, 5),
       (7, 8),
       (8, 4),
       (9, 4),
       (10, 4),
       (11, 4),
       (12, 3),
       (13, 3),
       (14, 3),
       (15, 3),
       (12, 9),
       (13, 9),
       (14, 9),
       (15, 9),
       (16, 2)
returning (select name from catalog.products where id = product_id) as product, (select name
                                                                                 from catalog.product_categories
                                                                                 where id = products_product_categories.category_id) as category;
