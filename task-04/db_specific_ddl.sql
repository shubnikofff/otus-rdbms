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

    create index product_name_index on products (name) tablespace ssd_tablespace

    create table product_categories
    (
        id   serial primary key,
        name varchar not null unique
    ) tablespace ssd_tablespace

    create table products_product_categories
    (
        product_id  bigint not null,
        category_id int    not null,
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

    create index discount_dates_index on discounts (start_date, end_date) tablespace ssd_tablespace

    create table prices
    (
        id                 bigserial primary key,
        amount             money,
        start_date         date,
        end_date           date,
        product_id         bigint not null,
        supplier_id        bigint,
        available_quantity smallint check ( available_quantity >= 0 ),
        discount_id        bigint,
        check ( end_date > start_date ),
        constraint fk_product foreign key (product_id) references products (id) on delete cascade,
        constraint fk_supplier foreign key (supplier_id) references suppliers (id),
        constraint fk_discount foreign key (discount_id) references discounts (id)
    )

    create index price_dates_index on prices (start_date, end_date) tablespace ssd_tablespace

    create table picture_categories
    (
        id   smallserial primary key,
        name varchar not null unique
    ) tablespace ssd_tablespace

    create table pictures
    (
        id          bigserial primary key,
        s3_url      varchar not null,
        entity_id   bigint,
        category_id smallint,
        mime_type   varchar,
        constraint fk_category foreign key (category_id) references picture_categories (id)
    ) tablespace ssd_tablespace

    create index category_entity_index on pictures (category_id, entity_id) tablespace ssd_tablespace;

-- Schema Sales

drop schema if exists sales cascade;
create schema sales

    create table customers
    (
        id         serial primary key,
        email      varchar not null unique,
        password   varchar not null,
        name       varchar,
        contact    varchar,
        last_visit date
    ) tablespace hdd_tablespace

    create table delivery_addresses
    (
        id          bigserial primary key,
        country     varchar,
        street      varchar,
        building    varchar,
        zip_code    varchar,
        city        varchar,
        description varchar
    ) tablespace hdd_tablespace

    create table customers_delivery_addresses
    (
        customer_id bigint not null,
        address_id  bigint not null,
        constraint fk_product foreign key (customer_id) references customers (id) on delete cascade,
        constraint fk_category foreign key (address_id) references delivery_addresses (id) on delete cascade
    ) tablespace hdd_tablespace

    create table order_statuses
    (
        id   smallserial primary key,
        name varchar not null unique

    ) tablespace hdd_tablespace

    create table orders
    (
        id                  bigserial primary key,
        order_number        varchar not null,
        created_at          date    not null,
        customer_comment    text,
        customer_id         int,
        status_id           smallint,
        delivery_address_id int,
        delivery_date       date    not null,
        constraint fk_customer foreign key (customer_id) references customers (id),
        constraint fk_status foreign key (status_id) references order_statuses (id),
        constraint fk_delivery_address foreign key (delivery_address_id) references delivery_addresses (id)
    ) tablespace hdd_tablespace

    create index created_date_index on orders (created_at) tablespace hdd_tablespace

    create table order_items
    (
        order_id int,
        price_id int,
        quantity smallint not null check ( quantity > 0 ),
        constraint fk_order foreign key (order_id) references orders (id),
        constraint fk_price foreign key (price_id) references catalog.prices (id)
    ) tablespace hdd_tablespace

    create index order_price_index on order_items (order_id, price_id) tablespace hdd_tablespace

    create table reviews
    (
        id          bigserial primary key,
        score       smallint not null check ( score > 0 ),
        text        text,
        customer_id int,
        product_id  int,
        order_id    int,
        created_at  date     not null,
        constraint fk_customer foreign key (customer_id) references customers (id),
        constraint fk_product foreign key (product_id) references catalog.products (id),
        constraint fk_order foreign key (order_id) references orders (id)
    ) tablespace hdd_tablespace

    create index product_index on reviews (product_id) tablespace hdd_tablespace

    create index product_score_index on reviews (product_id, score) tablespace hdd_tablespace;