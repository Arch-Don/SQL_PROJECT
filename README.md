# Introduction
Dive into the data job market! Focusing on data analysis roles,this project eplores top paying jobs, in demand skills and where high demands meet high salary

- SQL Queries? Check out here:[project_sql_folder](/project_sql/)

# Background
- Data hails from [SQL Course](https://barousse.com/sql)

# Tools I Used
- **SQL**
- **Postgresql**
- **Visual Studio code**
- **Git and Github**

# The Analysis
### 1. Top paying Data Analyst jobs
This query highlights the top paying opportunities in the field. I filtered data analyst position by average yearly salary and location, focusing on remote jobs.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE (salary_year_avg IS NOT NULL) 
    AND (job_location = 'Anywhere')
    AND (job_title_short = 'Data Analyst')
ORDER BY salary_year_avg DESC
LIMIT 10;
```

### 2. Skills for top paying jobs
To understand what skills are required for top paying jobs,I joined the job posting with skills data,providing insight into what employers value for high-compensation roles
```sql
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

```
### 3. In-Demand skills for Data analysts
This query helped identify the skills most frequently requested in job postings, directing focus to area with high demand
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skillS_job_dim.skill_id
WHERE (job_title_short = 'Data Analyst')
    AND (job_work_from_home = TRUE)
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
### 4.Skills Based On salry
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
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
```
### 5. Most Optimal Skill To Learn
Combining Insight from demand and salary data,this query aim to pinpoint skills that are both in high demand and have high salaries,offering a strategic focus for skill development
```sql

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
```
# What I learned
- ***Complex Query Crafting***
- ***Data Aggregation***
- ***Analytical Wizadry***
# Conclusion
This Project enhanced my SQL skills and provided valuable insights into the data analyst job market.
