--subquery 
select *
from (
    select * from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null
) as valid_salary
limit 10;

--CTE
with valid_salary as (
    select * from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null
)

select * from valid_salary limit 10;

--scenario 1 - subquery in select
--show each job's salary next to overall market median salary.
select job_title_short, salary_year_avg,
    (select percentile_cont(0.5) within group(order by salary_year_avg) from job_postings_fact) as median_salary
    from
    job_postings_fact
    where salary_year_avg is not null
limit 10;


--scenario 2 - subquery in from
--stage only jobs that are remote before aggrigating to determine remote job median salary:
select 
    job_title_short, median(salary_year_avg) as median_salary,

    (select percentile_cont(0.5) within group(order by salary_year_avg) 
    from job_postings_fact where job_work_from_home = True) as market_median_salary
from (
    select job_title_short, salary_year_avg
    from job_postings_fact
    where salary_year_avg is not null
    and job_work_from_home = True
) as remote_jobs
where salary_year_avg is not null
group by job_title_short
limit 10;


--scenario 3 - subquery in having
--keep only job titles whose median salary is above the median
select 
    job_title_short, median(salary_year_avg) as median_salary,

    (select percentile_cont(0.5) within group(order by salary_year_avg) 
    from job_postings_fact where job_work_from_home = True) as market_median_salary
from (
    select job_title_short, salary_year_avg
    from job_postings_fact
    where salary_year_avg is not null
    and job_work_from_home = True
) as remote_jobs
where salary_year_avg is not null
group by job_title_short
having median_salary > market_median_salary
limit 10;



--CTE example
--compare how much more (or less) remote roles pay compared to on-site roles for each title
--use a cte to calculate median salary by title and wfh status, the compare the median

with title_median as (
select job_title_short, job_work_from_home,
MEDIAN(salary_year_avg)::int as market_median_salary
from job_postings_fact
where job_country='Malaysia'
group by 
job_title_short,
job_work_from_home
)

select 
r.job_title_short,r.market_median_salary as remote_median,
m.market_median_salary as onsite_median,
--remote_median-onsite_median as premium_wfh,
(r.market_median_salary-m.market_median_salary) as remote_premium
from title_median as r
inner join title_median as m
on r.job_title_short = m.job_title_short
where r.job_work_from_home=True
and m.job_work_from_home=false;


--subquery --
--existence filtering
--identify job postings that has no associated skills before loading into data mart

select * from job_postings_fact
order by job_id
limit 10;

select * from skills_job_dim
order by job_id
limit 40;

select * from job_postings_fact as tgt
where  exists (
    select 1
    from skills_job_dim as src 
    where tgt.job_id=src.job_id
)
order by job_id;