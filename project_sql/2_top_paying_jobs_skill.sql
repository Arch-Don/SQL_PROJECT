WITH top_paying_jobs AS(    
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE (salary_year_avg IS NOT NULL) 
        AND (job_location = 'Anywhere')
        AND (job_title_short = 'Data Analyst')
    ORDER BY salary_year_avg DESC
    LIMIT 10)

SELECT top_paying_jobs.*,
        skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skillS_job_dim.skill_id

