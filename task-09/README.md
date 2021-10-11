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
Результаты теста **sysbench**:
```
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Initializing worker threads...

Threads started!

SQL statistics:
    queries performed:
        read:                            5222
        write:                           1492
        other:                           746
        total:                           7460
    transactions:                        373    (37.27 per sec.)
    queries:                             7460   (745.33 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          10.0078s
    total number of events:              373

Latency (ms):
         min:                                   21.48
         avg:                                   26.82
         max:                                   54.71
         95th percentile:                       29.19
         sum:                                10004.48

Threads fairness:
    events (avg/stddev):           373.0000/0.00
    execution time (avg/stddev):   10.0045/0.00
```
