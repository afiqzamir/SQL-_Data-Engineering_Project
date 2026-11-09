/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

select sd.skills, 
--count(sd.skill_id) as freq,
COUNT(jpf.*) AS skill_count,
    PERCENTILE_CONT(0.5) within group(order by salary_year_avg) as median_salary
from job_postings_fact as jpf
inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
inner join skills_dim as sd on sd.skill_id = sjd.skill_id
where 
jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home = True
group by sd.skills 
having count(sd.skills) >100
--order by freq desc
order by skill_count desc
limit 25


/*
Here's a breakdown of the highest-paying skills for Data Engineers:

Key Insights:
- Rust remains the top-paying skill at $210K median salary, though demand is still relatively limited (232 postings).
- Terraform and Golang both have high median salaries at $184K, with strong demand (Terraform: 3,248 postings; Golang: 912 postings).
- Other notable skills with both high pay and moderate-to-high frequency include:
  - Spring: $175.5K median salary (364 postings)
  - Neo4j: $170K median salary (277 postings)
  - GDPR: $169.6K median salary (582 postings)
  - GraphQL: $167.5K median salary (445 postings)
  - Kubernetes: $150.5K median salary (4,202 postings)
  - Airflow: $150K median salary (9,996 postings)
- Bitbucket, Ruby, Redis, Ansible, and Jupyter all appear in the top 25 for pay, each with hundreds of postings.
- Most skills on the list are no longer extreme statistical outliers with just a handful of postings; instead, many show consistently strong demand.

Takeaway: While the very top-paying skill (Rust) still has less demand than major cloud and data tools, most of the top-paying skills have both solid salaries and significant demand. This suggests that learning tools like Terraform, Golang, Spring, Neo4j, and especially core data engineering tools (Airflow, Kubernetes) provides a strong balance between compensation and marketability.

┌────────────┬───────────────┬─────────────┐
│   skills   │ median_salary │ skill_count │
│  varchar   │    double     │    int64    │
├────────────┼───────────────┼─────────────┤
│ rust       │      210000.0 │         232 │
│ terraform  │      184000.0 │        3248 │
│ golang     │      184000.0 │         912 │
│ spring     │      175500.0 │         364 │
│ neo4j      │      170000.0 │         277 │
│ gdpr       │      169616.0 │         582 │
│ zoom       │      168438.0 │         127 │
│ graphql    │      167500.0 │         445 │
│ mongo      │      162250.0 │         265 │
│ fastapi    │      157500.0 │         204 │
│ django     │      155000.0 │         265 │
│ bitbucket  │      155000.0 │         478 │
│ crystal    │      154224.0 │         129 │
│ atlassian  │      151500.0 │         249 │
│ c          │      151500.0 │         444 │
│ typescript │      151000.0 │         388 │
│ kubernetes │      150500.0 │        4202 │
│ node       │      150000.0 │         179 │
│ ruby       │      150000.0 │         736 │
│ airflow    │      150000.0 │        9996 │
│ css        │      150000.0 │         262 │
│ redis      │      149000.0 │         605 │
│ ansible    │      148798.0 │         475 │
│ vmware     │      148798.0 │         136 │
│ jupyter    │      147500.0 │         400 │
├────────────┴───────────────┴─────────────┤
│ 25 rows                        3 columns │
└──────────────────────────────────────────┘
*/
