# Создание интсанса MySQL в Docker

Был создан docker-compose.yml следующего содержания:
```yaml
version: "3.9"
services:
  mysql:
    image: mysql:8.0.26
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: otus
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
volumes:
  mysql-data:
```

Был создан [init.sql](init.sql) с DDL операциями по инициализации БД:
- создание БД
- создание табличных пространств
- создание таблиц
- создание ключей и ограничений

Скрипт запускается автоматически каждый раз при создании нового контейнера, так как он размещен в каталоге `/docker-entrypoint-initdb.d`

Проверка подключения к контейнеру:
```bash
docker-compose exec mysql mysql -uroot -p
```
```
mysql> show tables;
+------------------------------+
| Tables_in_shop               |
+------------------------------+
| customers                    |
| customers_delivery_addresses |
| delivery_addresses           |
| discounts                    |
| order_items                  |
| order_statuses               |
| orders                       |
| picture_categories           |
| pictures                     |
| prices                       |
| producers                    |
| product_categories           |
| products                     |
| products_product_categories  |
| reviews                      |
| suppliers                    |
+------------------------------+
```
Был создан кастомный файл конфигурации [my-custom.cnf](./my-custom.cnf) следующего содержания:
```ini
[mysqld]
innodb_buffer_pool_size = 256M
```
