-- Topic: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
--  Identify skills in high demand and associated with high average salaries for Data Analyst roles
--  Concentrates on remote positions with specified salaries
--  Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
--     offering strategic insights for career development in data analysis

WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_postings_fact.job_id) AS demand_number
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    GROUP BY
        skills_dim.skill_id
    ORDER BY
        demand_number
),

average_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    GROUP BY
        skills_dim.skill_id
    ORDER BY
        avg_salary DESC
)

SELECT 
    skills_demand.skill_id, 
    skills_demand.skills,
    demand_number, 
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_number DESC, 
    avg_salary DESC
LIMIT 25

-- Highest Demand (Foundation): SQL (398 postings, $\text{avg\_salary} = \$97,237$) is the single most required skill, making it essential for job volume and security.
-- Highest Salary (Specialization): Specialized data warehouse and cloud skills command the highest pay: Snowflake ($\$112,948$), Azure ($\$111,225$), and AWS ($\$108,317$).
-- Visualization: Tableau (230 postings, $\text{avg\_salary} = \$99,288$) is the leading visualization tool by demand.
-- Conclusion: Prioritize SQL (demand) and Python/R (optimal balance), then add a visualization tool (Tableau) and a specialization (Snowflake) to maximize both job access and earning potential.