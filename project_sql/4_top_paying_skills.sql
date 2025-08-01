SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0 )as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skillS_job_dim.skill_id
WHERE (job_title_short = 'Data Analyst')
    AND (job_work_from_home = TRUE)
    AND(salary_year_avg IS NOT NULL)
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;