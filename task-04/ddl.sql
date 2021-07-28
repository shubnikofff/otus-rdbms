-- Roles
drop role if exists customer, accountant, analyst;
create role customer with login password 'p@ssw0rd';
create role accountant with login password 'p@ssw0rd';
create role analyst with login password 'p@ssw0rd';

-- Database
drop database if exists shop;
create database shop;

-- Tablespace
-- drop tablespace if exists hdd_tablespace;
-- drop tablespace if exists ssd_tablespace;
--
-- create tablespace hdd_tablespace owner postgres location '1';

