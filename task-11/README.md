# Партиционирование таблицы

### Решение

Был применено партиционирование по типу `range` к таблице `promotions`:
```sql
alter table promotions partition by range (region_id) (
    partition central_district values less than (10),
    partition europe_district values less than (20),
    partition northwestern_district values less than (maxvalue)
);
```

Рузультат запроса
```sql
select p.PARTITION_NAME, p.TABLE_ROWS FROM information_schema.PARTITIONS p where TABLE_NAME = 'promotions';
```

| PARTITION\_NAME | TABLE\_ROWS |
| :--- | :--- |
| central\_district | 3 |
| europe\_district | 4 |
| northwestern\_district | 3 |
