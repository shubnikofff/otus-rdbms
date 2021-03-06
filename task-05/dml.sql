truncate table catalog.product_categories, catalog.products, catalog.producers restart identity cascade;

-- Пример использования утилиты COPY
copy catalog.product_categories (id, name) from '/var/lib/postgresql/csv/product_categories.csv' with csv header;
copy catalog.producers (id, name) from '/var/lib/postgresql/csv/producers.csv' with csv header;
copy catalog.products (id, name, producer_id) from '/var/lib/postgresql/csv/products.csv' with csv header;

-- Запрос на добавление данных с выводом информации о добавленных строках
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
returning
    (select name from catalog.products where id = product_id) as product,
    (select name from catalog.product_categories where id = products_product_categories.category_id) as category;

-- Запрос с регурярным выражением, который ищет все товары чьи названия начинаются с Sony или Apple вне зависимости от регистра
select * from catalog.products where name ~* '(sony|apple)+';

-- Пример запроса с использованием LEFT JOIN. Результат: найдены все товары и их категории, если такие имеются. Если поменять порядок соединений в FROM, то будут найдены только те товары, которые принаддежат хотя бы к одной категории.
-- Это происходит потому, что в результат поиска попадают все строки из левой таблицы и соответсвующие усдловию в ON строки из правой.
-- Соответственно товары, для которых не было найдено категории в результат не попадут.
select p.name as product, (select name from catalog.product_categories pc where pc.id = ppc.category_id) as category
from catalog.products p left join catalog.products_product_categories ppc on p.id = ppc.product_id;

select name, count(ppc.category_id) as category_count
from catalog.products p left join catalog.products_product_categories ppc on p.id = ppc.product_id
group by p.name having count(ppc.category_id) > 1
order by p.name;

-- Пример запроса с INNER JOIN. Результат: найдены только те товары, которые принаддежат хотя бы к одной категории.
-- Изменение порядка соединений не дает никакого эффекта, так как при INNER JOIN в результат попадают только те строки, которые есть в обеих таблицах и соответствуют условаию ON.
select p.name as product, (select name from catalog.product_categories pc where pc.id = ppc.category_id) as category from catalog.products p inner join catalog.products_product_categories ppc on p.id = ppc.product_id;

-- Ппример запроса на обновление данных сиспользованием UPDATE FROM
update catalog.products p set description = trim(concat(p.description, ' Made by', v.name)) from catalog.producers v where producer_id = v.id;

-- Запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью USING
delete from catalog.products using catalog.producers where producer_id = producers.id and producers.name ~* 'apple' returning products.name, producers.name;
