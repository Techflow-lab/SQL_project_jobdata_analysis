SELECT
    skills,     
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
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

-- Highest Paid Skill: Pyspark commands the highest average salary at $\$208,172$.
-- Top-Tier Skills (Above $\$160,000$): Pyspark $(\$208,172)$ and Bitbucket $(\$189,155)$ are the top two. Couchbase and Watson are tied for the next highest at $\$160,515$.
-- Lowest Paid Skills: Microstrategy $(\$121,619)$, GCP $(\$122,500)$, and PostgreSQL $(\$123,879)$ represent the bottom three skills by average salary in this dataset.
-- Central Tendency: The median salary is $\$141,907$, which is very close to the mean, suggesting the data is relatively symmetrical, though the high maximum $(\$208,172)$ compared to the third quartile $(\$153,750)$ shows a potential right-skew or a few high-paying outliers (like Pyspark).
