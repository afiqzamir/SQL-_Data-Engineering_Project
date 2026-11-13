CREATE DATABASE if not exists jobs_mart;

show databases;

--drop database if exists jobs_mart;

create schema if not exists ;

select * from information_schema.schemata;

use jobs_mart; --to use the database directly. eg: no need(job_mart.staging)

create schema jobs_mart.staging;
create schema if not exists staging;
--drop schema if exists staging; --commented out to avoid accidental deletion of schema


select * from information_schema.tables where table_catalog = 'jobs_mart';


create table staging.prefferred_roles (
    role_id int primary key,
    role_name varchar
);

insert into staging.prefferred_roles (role_id, role_name) values
(1, 'Data Engineer'),
(2, 'Senior Data Engineer');


insert into staging.prefferred_roles (role_id, role_name) values
(3, 'Senior Data Engineer');

update staging.prefferred_roles set role_name = ' Data Analyst ' where role_id = 3;

select * from staging.prefferred_roles;

alter table staging.prefferred_roles add column preferred_role boolean;

--alter table staging.prefferred_roles drop column preferred_role;

update staging.prefferred_roles 
set preferred_role=true 
where role_id =1 or role_id = 2;

update staging.prefferred_roles 
set preferred_role=false 
where role_id =3;

alter table staging.prefferred_roles
rename to priority_roles;


select * from staging.priority_roles;

alter table staging.priority_roles 
rename column preferred_role to priority_lvl;

alter table staging.priority_roles
alter column priority_lvl type integer;

update staging.priority_roles
set role_name = 'Software Engineer' where role_id = 3;