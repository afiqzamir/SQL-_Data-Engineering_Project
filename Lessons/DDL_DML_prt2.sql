--this file is for create CTAs, view table and temp table


--create CTAs table for job postings fact table
Create or replace table staging.job_postings_flat as
SELECT
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;

select count(*) from staging.job_postings_flat;



--create view table for priority jobs
create or replace view staging.priority_jobs_flat_view AS
select 
jpf.* 
from staging.job_postings_flat as jpf
join staging.priority_roles as pr
on jpf.job_title_short = pr.role_name
where pr.priority_lvl = 1;

select 
job_title_short, count(*) as job_count
from staging.priority_jobs_flat_view
group by job_title_short  
order by job_count desc;


create temporary table senior_jobs_flat_temp as
select * from staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';


select 
job_title_short, count(*) as job_count
from senior_jobs_flat_temp
group by job_title_short  
order by job_count desc;

--truncate and delete data from staging.job_postings_flat table
select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

delete from staging.job_postings_flat
where job_posted_date < '2024-01-01';

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

truncate table staging.job_postings_flat;

insert into staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
    where jpf.job_posted_date >= '2024-01-01';

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;