-- Topic: What are the most in-demand skills for data analysts

SELECT 
    skills, 
    COUNT(*) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

-- The data highlights a significant market demand for analysts with a versatile technical toolkit centered on the entire data lifecycle: extraction, manipulation, analysis, and visualization.

-- SQL is the foundational and most critical skill. Its overwhelming lead in demand (7,291 postings) confirms it as the industry standard for data extraction and management from databases.

-- Excel remains a mandatory, high-demand tool for quick, ad-hoc analysis and simple reporting, serving as a universal business tool.

-- Python represents the demand for advanced analysis, statistical modeling, and automation, indicating a shift toward more complex data science-adjacent tasks.

-- Tableau and Power BI are the leading platforms for data visualization and business intelligence (BI). The high demand for both tools reflects the need for analysts who can translate complex data into clear, interactive, and compelling stories for business stakeholders.