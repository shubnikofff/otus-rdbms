-- Database
drop database if exists shop;
create database shop;

# -- Tablespace
drop tablespace hdd_tablespace;
drop tablespace ssd_tablespace;
-- Simulating slow storage
create tablespace hdd_tablespace add datafile 'ts_hdd.ibd' engine=InnoDB;
-- Simulating fast storage
create tablespace ssd_tablespace add datafile 'ts_ssd.ibd' engine=InnoDB;

use shop;
