-- Roles
drop role if exists customer, accountant, analyst;
create role customer with login password 'p@ssw0rd';
create role accountant with login password 'p@ssw0rd';
create role analyst with login password 'p@ssw0rd';

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