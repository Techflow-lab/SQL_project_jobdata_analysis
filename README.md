# 📊 SQL Job Data Analysis Project

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?style=for-the-badge&logo=postgresql)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

## 📋 Table of Contents
- [Introduction](#introduction)
- [Background](#background)
- [Tools Used](#tools-used)
- [Project Structure](#project-structure)
- [The Analysis](#the-analysis)
- [What I Learned](#what-i-learned)
- [Conclusions](#conclusions)
- [Getting Started](#getting-started)

---

## 🎯 Introduction

This project explores the **data job market** with a focus on **data analyst roles**. It dives deep into top-paying jobs, in-demand skills, and the intersection of high demand and high salaries in data analytics.

### Key Questions Answered:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

---

## 🔍 Background

The motivation behind this project stems from the desire to navigate the data analyst job market more effectively. This project aims to identify:
- **Top-paid positions**
- **Most in-demand skills**
- **Optimal skill combinations** for career development

### Data Source
The dataset contains real-world job postings from 2023, including:
- Job titles
- Salaries
- Locations
- Required skills
- Company information

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **SQL (PostgreSQL)** | Database management and querying |
| **PostgreSQL** | Database management system |
| **Visual Studio Code** | Code editor for SQL queries |
| **Git & GitHub** | Version control and collaboration |
| **Markdown** | Documentation |

---

## 📁 Project Structure

```
SQL_project_jobdata_analysis/
│
├── sql_queries/
│   ├── 1_top_paying_jobs.sql
│   ├── 2_top_paying_job_skills.sql
│   ├── 3_in_demand_skills.sql
│   ├── 4_top_paying_skills.sql
│   └── 5_optimal_skills.sql
│
├── README.md
└── LICENSE
```

---

## 📈 The Analysis

Each query for this project aimed to investigate specific aspects of the data analyst job market. Here's how I approached each question:

### 1️⃣ Top Paying Data Analyst Jobs

Identified the top 10 highest-paying Data Analyst roles available remotely.

```sql
SELECT
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = True
ORDER BY
    salary_year_avg DESC
LIMIT 20;
```

**Key Insights:**
- 💰 Salary range: $184K - $650K
- 📍 Remote positions dominate top-paying roles
- 🏢 Various company sizes offer competitive salaries

---

### 2️⃣ Skills for Top Paying Jobs

Analyzed what skills are required for the highest-paying positions.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

**Key Insights:**
- 🐍 Python and SQL are the most demanded skills
- 📊 Visualization tools (Tableau, Power BI) are highly valued
- ☁️ Cloud technologies increasingly important

---

### 3️⃣ In-Demand Skills

Identified the most frequently requested skills in job postings.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

**Top 5 Most Demanded Skills:**
1. SQL - 7,291 job postings
2. Excel - 4,611 job postings
3. Python - 4,330 job postings
4. Tableau - 3,745 job postings
5. Power BI - 2,609 job postings

---

### 4️⃣ Skills Based on Salary

Examined which skills are associated with higher average salaries.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

**Key Insights:**
- 🤖 Machine learning and AI skills command premium salaries
- 💻 Specialized technical skills (PySpark, DataRobot) highly compensated
- 📊 Big data technologies offer competitive compensation

---

### 5️⃣ Most Optimal Skills to Learn

Combined demand and salary data to identify the most strategic skills to develop.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

**Optimal Skills (High Demand + High Salary):**
- Programming: Python, R, SQL
- Cloud: Snowflake, Azure, AWS
- Visualization: Tableau, Power BI, Looker

---

## 💡 What I Learned

Throughout this project, I enhanced my SQL capabilities significantly:

- **🔧 Complex Query Construction:** Mastered advanced SQL techniques including CTEs, subqueries, and window functions
- **📊 Data Aggregation:** Became proficient with GROUP BY, aggregation functions, and HAVING clauses
- **🔗 Advanced Joins:** Developed expertise in various JOIN types to combine data from multiple tables
- **💭 Analytical Thinking:** Improved ability to translate business questions into actionable SQL queries
- **🎯 Problem-Solving:** Enhanced skills in debugging queries and optimizing performance

---

## 🎯 Conclusions

### Key Findings:

1. **💰 Top-Paying Jobs:** Remote data analyst positions offer wide salary ranges, with the highest reaching $650K annually

2. **🔑 Essential Skills:** SQL remains the cornerstone skill, but Python and data visualization tools are increasingly critical

3. **📈 High-Demand Skills:** SQL, Excel, and Python dominate job postings, making them essential for job seekers

4. **💎 Premium Skills:** Specialized technologies like machine learning frameworks and big data tools command higher salaries

5. **🎓 Optimal Learning Path:** Focus on SQL and Python as foundations, then add specialized skills based on career goals (cloud, ML, or visualization)

### Final Thoughts:

The data analyst job market rewards continuous learning and skill diversification. While foundational skills like SQL and Excel remain critical, emerging technologies in cloud computing, machine learning, and advanced analytics are becoming increasingly valuable.

**Recommendation:** Build a strong foundation in SQL and Python, then specialize based on industry interests and market demands.

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL installed
- Basic SQL knowledge
- Git for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Techflow-lab/SQL_project_jobdata_analysis.git
   cd SQL_project_jobdata_analysis
   ```

2. **Set up PostgreSQL database**
   ```sql
   CREATE DATABASE job_analysis;
   ```

3. **Import the data**
   ```bash
   psql -U your_username -d job_analysis -f data/schema.sql
   ```

4. **Run the queries**
   - Open the SQL files in `sql_queries/` directory
   - Execute them in your preferred SQL client or VS Code

---

## 📫 Contact

**Project Maintainer:** Techflow-lab

- GitHub: [@Techflow-lab](https://github.com/Techflow-lab)
- Project Link: [SQL Job Data Analysis](https://github.com/Techflow-lab/SQL_project_jobdata_analysis)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Data source inspiration from job posting APIs
- SQL community for best practices and optimization techniques
- Fellow data analysts for feedback and suggestions

---

<div align="center">

### ⭐ If you find this project helpful, please consider giving it a star!

**Made with ❤️ and SQL**

</div>

