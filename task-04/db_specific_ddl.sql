-- Schemas
drop schema if exists catalog cascade;
create schema catalog

    create table Products
    (
        id          bigserial not null primary key,
        code        uuid      not null unique,
        name        varchar   not null unique,
        producer_id bigint    not null,
        description text
    ) tablespace ssd_tablespace;
