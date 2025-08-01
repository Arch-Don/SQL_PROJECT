
WITH skills_demand AS(
    SELECT 
    skills_dim.skill_id,
    skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skillS_job_dim.skill_id
WHERE (job_title_short = 'Data Analyst')
    AND(salary_year_avg IS NOT NULL)
    AND (job_work_from_home = TRUE)
GROUP BY skills_dim.skill_id
),average_salary AS(
    SELECT 
    skills_dim.skill_id,
    ROUND(AVG(salary_year_avg),0 )as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skillS_job_dim.skill_id
WHERE (job_title_short = 'Data Analyst')
    AND (job_work_from_home = TRUE)
    AND(salary_year_avg IS NOT NULL)
GROUP BY skills_dim.skill_id

)

SELECT 
    skills_demand.skill_id,
    skills,
    demand_count,
    avg_salary
FROM average_salary
INNER JOIN skills_demand ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;