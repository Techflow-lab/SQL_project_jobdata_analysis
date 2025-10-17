WITH remote_jobs_data AS (
    SELECT
        skill_id,
        COUNT(skills_to_job.job_id) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True
    GROUP BY       
        skill_id 
)

SELECT
    skills.skill_id,
    skills,
    skill_count
FROM    
    remote_jobs_data
INNER JOIN
    skills_dim AS skills ON skills.skill_id = remote_jobs_data.skill_id 
ORDER BY
    skill_count
LIMIT 5;