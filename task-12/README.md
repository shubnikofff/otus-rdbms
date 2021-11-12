# SQL выборка в MySQL

## Задание
1. Напишите запрос по своей базе с inner join
2. Напишите запрос по своей базе с left join
3. Напишите 5 запросов с WHERE с использованием разных операторов, опишите для чего вам в проекте нужна такая выборка данных

## Решение

1. Пример запроса с `inner join`:
```sql
select p.name as product, (select name from product_categories pc where pc.id = ppc.category_id) as category
from products p inner join products_product_categories ppc on p.id = ppc.product_id;
```

2. Пример запроса с `left join`:
```sql
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
```

3. Пример 5 запросов с `WHERE` с использовавнием разных операторов:
- Поиск товаров, название которорых начинается с sony:
```sql
select id from products where name like 'sony%';
```
- Поиск скидок на определенный период
```sql
select id from discounts where start_date > '2021-11-10' and end_date <= '2021-12-30';
```
- Поиск цен в заданном диапозоне:
```sql
select id from prices where amount between 100.0 and 300.0;
```

- Поиск готовящихся и доставляемых заказаов:
```sql
select id from orders where status in ('preparing', 'delivering');
```

- Поиск цен скидкой:
```sql
select id from prices where discount_id is not null;
```
