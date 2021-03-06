-- Database
drop database if exists shop;
create database shop;

-- Tablespace
-- Simulating slow storage
create tablespace hdd_tablespace add datafile 'ts_hdd.ibd' engine = InnoDB;
-- Simulating fast storage
create tablespace ssd_tablespace add datafile 'ts_ssd.ibd' engine = InnoDB;

use shop;

create table producers
(
    id      bigint       not null auto_increment primary key,
    name    varchar(500) not null unique,
    contact text
) tablespace ssd_tablespace;

create table products
(
    id          bigint       not null auto_increment primary key,
    code        binary(16)   not null unique default (UUID_TO_BIN(UUID())),
    name        varchar(500) not null,
    producer_id bigint,
    description text,
    constraint fk_producer foreign key (producer_id) references producers (id)
) tablespace ssd_tablespace;

create table product_categories
(
    id   smallint     not null auto_increment primary key,
    name varchar(200) not null unique
) tablespace ssd_tablespace;

create table products_product_categories
(
    product_id  bigint   not null,
    category_id smallint not null,
    constraint fk_product foreign key (product_id) references products (id) on delete cascade,
    constraint fk_category foreign key (category_id) references product_categories (id) on delete cascade
) tablespace ssd_tablespace;

create table suppliers
(
    id   bigint       not null auto_increment primary key,
    name varchar(500) not null
) tablespace ssd_tablespace;

create table discounts
(
    id         bigint not null auto_increment primary key,
    start_date date,
    end_date   date,
    check ( end_date > start_date )
) tablespace ssd_tablespace;

create index discount_dates_idx on discounts (start_date, end_date) comment 'discount search often makes by dates';

create table prices
(
    id                 bigint not null auto_increment primary key,
    amount             decimal(13, 2),
    start_date         date,
    end_date           date,
    product_id         bigint not null,
    supplier_id        bigint,
    available_quantity smallint check ( available_quantity >= 0 ),
    discount_id        bigint,
    check ( end_date > start_date ),
    constraint fk_product_price foreign key (product_id) references products (id) on delete cascade,
    constraint fk_supplier foreign key (supplier_id) references suppliers (id),
    constraint fk_discount foreign key (discount_id) references discounts (id)
) tablespace ssd_tablespace;

create index prices_date_range_idx on prices (start_date, end_date);

create table picture_categories
(
    id   smallint     not null auto_increment primary key,
    name varchar(500) not null unique
);

create table pictures
(
    id          bigint        not null auto_increment primary key,
    s3_url      varchar(1000) not null,
    entity_id   bigint,
    category_id smallint,
    mime_type   varchar(50),
    constraint fk_picture_category foreign key (category_id) references picture_categories (id)
) tablespace ssd_tablespace;

create index category_entity_idx on pictures (category_id, entity_id);

create table customers
(
    id         int         not null auto_increment primary key,
    email      varchar(50) not null unique,
    password   varchar(50) not null,
    name       varchar(100),
    contact    varchar(500),
    last_visit date
) tablespace hdd_tablespace;

create table delivery_addresses
(
    id          bigint not null auto_increment primary key,
    country     varchar(100),
    street      varchar(250),
    building    varchar(20),
    zip_code    varchar(20),
    city        varchar(50),
    description varchar(500)
) tablespace hdd_tablespace;

create table customers_delivery_addresses
(
    customer_id int    not null,
    address_id  bigint not null,
    constraint fk_product_delivery_address foreign key (customer_id) references customers (id) on delete cascade,
    constraint fk_category_delivery_address foreign key (address_id) references delivery_addresses (id) on delete cascade
) tablespace hdd_tablespace;

create table order_statuses
(
    id   smallint    not null auto_increment primary key,
    name varchar(50) not null unique

) tablespace hdd_tablespace;

create table orders
(
    id                  bigint      not null auto_increment primary key,
    order_number        varchar(50) not null,
    created_at          date        not null,
    customer_comment    text,
    customer_id         int,
    status_id           smallint,
    delivery_address_id bigint,
    delivery_date       date        not null,
    constraint fk_customer foreign key (customer_id) references customers (id),
    constraint fk_status foreign key (status_id) references order_statuses (id),
    constraint fk_delivery_address foreign key (delivery_address_id) references delivery_addresses (id)
) tablespace hdd_tablespace;

create index created_date_idx on orders (created_at);

create table order_items
(
    order_id bigint,
    price_id bigint,
    quantity smallint not null check ( quantity > 0 ),
    constraint fk_order foreign key (order_id) references orders (id),
    constraint fk_price foreign key (price_id) references prices (id)
) tablespace hdd_tablespace;

create index order_price_idx on order_items (order_id, price_id);

create table reviews
(
    id          bigint not null auto_increment primary key,
    score       smallint not null check ( score > 0 ),
    text        text,
    customer_id int,
    product_id  bigint,
    order_id    bigint,
    created_at  date     not null,
    constraint fk_review_customer foreign key (customer_id) references customers (id),
    constraint fk_review_product foreign key (product_id) references products (id),
    constraint fk_review_order foreign key (order_id) references orders (id)
) tablespace hdd_tablespace;

create index product_idx on reviews (product_id);

create index product_score_idx on reviews (product_id, score);