-- Schema Catalog
drop schema if exists catalog cascade;
create schema catalog

    create table producers
    (
        id      bigserial primary key,
        name    varchar not null unique,
        contact text
    ) tablespace ssd_tablespace

    create table products
    (
        id          bigserial primary key,
        code        uuid    not null unique,
        name        varchar not null,
        producer_id bigint,
        description text,
        constraint fk_producer foreign key (producer_id) references producers (id)
    ) tablespace ssd_tablespace

    create table product_categories
    (
        id   bigserial primary key,
        name varchar not null unique
    ) tablespace ssd_tablespace

    create table products_product_categories
    (
        product_id  bigint not null,
        category_id bigint not null,
        constraint fk_product foreign key (product_id) references products (id) on delete cascade,
        constraint fk_category foreign key (category_id) references product_categories (id) on delete cascade
    ) tablespace ssd_tablespace

    create table suppliers
    (
        id   bigserial primary key,
        name varchar not null
    ) tablespace ssd_tablespace

    create table discounts
    (
        id         bigserial primary key,
        start_date date,
        end_date   date,
        check ( end_date > start_date )
    )

    create table prices
    (
        id                 bigserial primary key,
        amount             money,
        start_date         date,
        end_date           date,
        product_id         bigint not null,
        supplier_id        bigint,
        available_quantity integer check ( available_quantity >= 0 ),
        discount_id        bigint,
        check ( end_date > start_date ),
        constraint fk_product foreign key (product_id) references products (id) on delete cascade,
        constraint fk_supplier foreign key (supplier_id) references suppliers (id),
        constraint fk_discount foreign key (discount_id) references discounts (id)
    )

    create index product_name_index on products (name) tablespace ssd_tablespace

    create index price_dates_index on prices (start_date, end_date) tablespace ssd_tablespace

    create index discount_dates_index on discounts (start_date, end_date) tablespace ssd_tablespace;
