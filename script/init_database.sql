/* 
====================================
create database and schema
====================================

WARNING !! 
	this script will drop the entire "DataWarehouse" database if it exists.
	all data in the database will be permanently deleted.
	better check if you have database named "DataWarehouse" or not
	if yes, than you can change the name of the database of this project to something else


script purposes : 
	this script creates a new database named "DataWarehouse" after checking it it already exists.
	if the database exists, it is dropped and recreate
	additionally this script set up 3 schema within the database : bronze, silver, gold

*/


use master;
go 

-- drop and recreate the "DataWarehouse" database
if exists (select 1 from sys.databases where name = 'DataWarehouse') 
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database DataWarehouse;
end
go 

-- create the "DataWarehouse" database
create database DataWarehouse;
go

use DataWarehouse;
go

--create schema 
create schema bronze;
go

create schema silver;
go 

create schema gold;
go 
