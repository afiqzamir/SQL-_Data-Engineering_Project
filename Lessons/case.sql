--handling error missing expression
--filter 
select 
    job_title_short,
    salary_hour_avg,
    case 
        when salary_hour_avg is null then 'Missing'
        when salary_hour_avg < 25 then 'Low'
        when salary_hour_avg <50 Then 'Low'
        else 'High'
    end as Salary_category
from job_postings_fact
--where salary_hour_avg is not null
limit 10;


--categorizing categorical balues
--classsify 'job title ' column values as :
    --data analyst
    --data scientist
    --data engineer

select 
    job_title,
    case
        when job_title like '%Data%' and job_title like '%Analyst%'
        then 'Data Anlyst'
        when job_title like '%Data%' and job_title like '%Engineer%'
        then 'Data Engineer'
        else  'Other'
    end as job_title_category,
    job_title_short,
from job_postings_fact
order by random()
limit 10;

--conditional aggreggation
--calculate median salary for diff buckets
    --<100k
    -->=100k

select 
    job_title_short,
    count(*) as total_posting,
    MEDIAN(
        case 
            when salary_year_avg <100_100 then salary_year_avg
        end
    )as median_low_salary
    MEDIAN(
        case 
            when salary_year_avg >=100_100 then salary_year_avg
        end
    )as median_high_salary
from job_postings_fact
where salary_year_avg is not null
group by job_title_short;


--conditional example: calculation
--compute standardized salary using yearly salary average and adjusted hourly salary(eg 2000 hours/year)
--categorize salary into tiers
--<75k 'low'
--75 -150k medium
-- >=150k high

with salaries as(
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
        END AS standardized_salary
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL
        or salary_hour_avg IS NOT NULL
    
)

select 
    *,
    case 
        when standardized_salary <75_000 then 'low'
        when standardized_salary <150_00 and  standardized_salary >75_000 then 'Medium'
        when standardized_salary >150_000 then 'High'
        else 'other'
    end as salary_bucket
from 
    salaries
    -- order by standardized_salary 
    limit 10;