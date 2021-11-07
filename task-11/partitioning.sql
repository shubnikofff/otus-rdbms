use shop;

alter table promotions partition by range (region_id) (
    partition central_district values less than (10),
    partition europe_district values less than (20),
    partition northwestern_district values less than (maxvalue)
);

select p.PARTITION_NAME, p.TABLE_ROWS FROM information_schema.PARTITIONS p where TABLE_NAME = 'promotions';
