# SQL Job Data Analysis

Data-driven analysis of the data analyst job market using SQL to uncover salary trends, skill demands, and optimal career development strategies for remote positions.

## Project Overview

This project analyzes job posting data to answer critical questions:
- What are the highest-paying data analyst jobs?
- What skills do top-paying jobs require?
- Which skills are most in-demand?
- Which skills offer the best salary returns?
- What's the optimal skill combination for career growth?

## Analysis & Key Insights

### 1. Top Paying Jobs
**Query:** [1_top_paying_jobs.sql](1_top_paying_jobs.sql)

Identifies the top 20 highest-paying remote data analyst positions.

```sql
SELECT job_title, job_location, salary_year_avg, name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' 
  AND job_location = 'Anywhere' 
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 20;
```

**Insight:** Premium remote data analyst roles exist with significant salary ranges, providing benchmark targets for career progression.

---

### 2. Skills for Top Paying Jobs
**Query:** [2_top_paying_job_skills.sql](2_top_paying_job_skills.sql)

Maps skills required by the top 10 highest-paying positions using a CTE.

```sql
WITH top_paying_jobs AS (
    SELECT job_id, job_title, salary_year_avg, name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' 
      AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC;
```

**Key Findings:**
- **SQL and Python** are the most critical skills (industry standard)
- **Tableau** is #3, showing high demand for data visualization
- **Cloud platforms** (Snowflake, Azure) indicate shift to cloud-based environments

---

### 3. Most In-Demand Skills
**Query:** [3_top_demanded_skills.sql](3_top_demanded_skills.sql)

Quantifies market demand across all remote data analyst positions.

```sql
SELECT skills, COUNT(*) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

**Top 5 Skills by Demand:**
1. **SQL** - 7,291 postings (foundational skill for data extraction)
2. **Excel** - High demand for ad-hoc analysis and reporting
3. **Python** - Advanced analysis, automation, and modeling
4. **Tableau** - Leading BI visualization platform
5. **Power BI** - Second major BI tool for storytelling with data

**Insight:** The market demands versatility across the entire data lifecycle: extraction (SQL), manipulation (Python), analysis (Excel/Python), and visualization (Tableau/Power BI).

---

### 4. Top Paying Skills
**Query:** [4_top_paying_skills.sql](4_top_paying_skills.sql)

Identifies which skills command the highest average salaries.

```sql
SELECT skills, ROUND(AVG(salary_year_avg)) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
WHERE job_title_short = 'Data Analyst' 
  AND salary_year_avg IS NOT NULL 
  AND job_location = 'Anywhere'
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```

**Salary Insights:**
- **Highest:** PySpark ($208,172)
- **Top Tier:** Bitbucket ($189,155), Couchbase & Watson ($160,515)
- **Median:** $141,907 (relatively symmetrical distribution)
- **Bottom:** MicroStrategy ($121,619), GCP ($122,500), PostgreSQL ($123,879)

**Finding:** Specialized big data and ML tools command significant salary premiums over standard tools.

---

### 5. Optimal Skills (High Demand + High Salary)
**Query:** [5_optimal_skills.sql](5_optimal_skills.sql)

Strategic analysis combining demand and salary to identify the most valuable skills.

```sql
WITH skills_demand AS (
    SELECT skills_dim.skill_id, skills_dim.skills, 
           COUNT(job_postings_fact.job_id) AS demand_number
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' 
      AND salary_year_avg IS NOT NULL 
      AND job_location = 'Anywhere'
    GROUP BY skills_dim.skill_id
),
average_salary AS (
    SELECT skills_dim.skill_id, ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
    WHERE job_title_short = 'Data Analyst' 
      AND salary_year_avg IS NOT NULL 
      AND job_location = 'Anywhere'
    GROUP BY skills_dim.skill_id
)
SELECT skills_demand.skills, demand_number, avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY demand_number DESC, avg_salary DESC
LIMIT 25;
```

**Strategic Career Roadmap:**
| Skill | Demand | Avg Salary | Value Proposition |
|-------|--------|-----------|-------------------|
| SQL | 398 | $97,237 | Maximum job access (foundation) |
| Tableau | 230 | $99,288 | Leading visualization tool |
| Python/R | High | ~$100K+ | Optimal versatility balance |
| Snowflake | Medium | $112,948 | Cloud specialization premium |
| Azure | Medium | $111,225 | Cloud platform expertise |
| AWS | Medium | $108,317 | Cloud infrastructure skills |

**Career Strategy:**
1. **Master SQL first** → Maximum employability
2. **Add Python/R** → Analytical versatility
3. **Learn Tableau** → Visualization capability
4. **Specialize in cloud platforms** → Salary optimization

## Technical Stack

**SQL Techniques:**
- Common Table Expressions (CTEs)
- Multiple JOINs (LEFT, INNER)
- Aggregate functions (COUNT, AVG, ROUND)
- GROUP BY with multiple conditions
- Subqueries and window functions

**Database Schema:**
- `job_postings_fact` - Job details and salaries
- `company_dim` - Company information
- `skills_job_dim` - Job-skill relationships
- `skills_dim` - Skill definitions

## Key Takeaways

1. **SQL is non-negotiable** - Foundation with highest demand (7,291 postings)
2. **Python bridges gaps** - Essential for advanced analytics and automation
3. **Visualization matters** - Tableau/Power BI significantly boost employability
4. **Cloud is the future** - Snowflake, Azure, AWS command $108K-$113K premiums
5. **Balance is optimal** - Combine high-demand foundations with specialized, high-paying expertise

## License

MIT License

---

**Author:** Techflow-lab  
**Focus:** Data-driven career intelligence for data analysts