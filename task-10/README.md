# Типы данных в MySQL

## Задание
1. Проанализировать типы данных в своем проекте, изменить при необходимости. В README указать что на что поменялось и почему.
2. Добавить тип JSON в структуру. Проанализировать какие данные могли бы там хранится. привести примеры SQL для добавления записей и выборки.

## Решение

### Что поменялось в типах

Все изменения можно посмотреть в файле [init.sql](./init.sql)
1. Все столбцы с типом `bigint not null auto_increment primary key` заменены на `serial` из соображений простоты и удобочитаемости кода.
2. Использован тип `binary` для хранения UUID значений по причине экономии места на диске.
3. Заменены справочники `picture_categories` и `order_statuses` на enum поля с целью избежания дополнительных `join`.

### Тип JSON

В таблицу `orders` было добавлено поле `items` с типом `json`. Это позволило избавиться от лишних связей и таблицы `order_items`. Теперь все позиции заказа хранятся непосредсивенно в таблице `orders`.

#### Пример записи
```sql
insert into orders(order_number, created_at, customer_id, status, delivery_address_id, delivery_date, items)
values ('A001', now(), 1, 'created', 1, curdate() + 7, 
    json_array(
        json_object(
            'product', json_object('id', 1, 'name', 'headphones', 'supplier', 'Digital goods LLC'), 
            'price', 110.50, 
            'discount', 0.1, 
            'quantity', 2
        ),
        json_object(
            'product', json_object('id', 2, 'name', 'PS4 console', 'supplier', 'Satoshkin LLC'), 
            'price', 450.90, 
            'discount', 0.2, 
            'quantity', 1
        ),
        json_object(
            'product', json_object('id', 3, 'name', 'PS4 VR pack', 'supplier', 'Satoshkin LLC'),
            'price', 320.0,
            'quantity', 1
        )
    )
);
```

#### Пример выборки

Найдем все заказы, в которых есть позиции со скидкой
```sql
select id, order_number, json_extract(items, '$[*].product.name') as product
from orders
where json_contains_path(items, 'all', '$[*].discount');
```