-- Database
drop database if exists shop;
create database shop;

-- Tablespace
drop tablespace if exists hdd_tablespace;
drop tablespace if exists ssd_tablespace;
-- Simulating slow storage
create tablespace hdd_tablespace location '/var/lib/postgresql/ts_hdd';
-- Simulating fast storage
create tablespace ssd_tablespace location '/var/lib/postgresql/ts_ssd';

-- Roles
drop role if exists catalog, sales, webapp, manager, analyst;
create role catalog;
create role sales;
create role webapp with login password 'p@ssw0rd' in group catalog, sales;
create role manager with login password 'p@ssw0rd' in group catalog;
create role analyst with login password 'p@ssw0rd' in group sales;
